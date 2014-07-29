note
	Address: "Summary addressiption for {PARSE_address}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PARSE_ADDR

inherit

	PARSING_STRATEGY

create
	make

feature {NONE}

	make
		do
			error := sh_classes.init_error
			obtained_data := false
			create str_err.make_empty
		end

feature

	parseRow (row: ROW)
		local
			row_temp: ROW
			address: STRING
		do
			row_temp := row
			if row_temp.matches_regex ("^\s*(?i)Address\s*:?\s*$") then -- field only contain
					--   keyword Address but does not contains contents
				if row_temp.is_empty_from (row_temp.index_of ("Address") + 1) then
						-- the line does not contain any contents
					str_err := "Address field is empty on line" + row_temp.number.out + ". only Address keyword is found.%N"
				else
						-- contains contents
					if row_temp.matches_regex ("^(?!\s*$).+") then
							-- the fields contain contents
						create address.make_empty
						across
							row_temp.capture_strings_in_row ("^(?!\s*$).+") as c
						loop
							address := address + c.item
						end
						sh_classes.init_genaral_info.add_addr (address)
						obtained_data := true
					else
							-- the fields have empty string
						str_err := "Adress field is invalid on line" + row_temp.number.out + ". make sure to non-empty address content.%N"
					end
				end
			end
			if row_temp.matches_regex ("^\s*(?i)Address\s*:?\s*[\w]+.*$") then
					-- this contains keyword Address and content might be the same Address's field or spread over fields
				create address.make_empty
				if row_temp.is_empty_from (row_temp.index_of ("Address") + 1) then
						-- the content and Address are on same field as Address
					address := row_temp [row_temp.index_of ("Address")].out
				else
						-- the content and Address are on different  field of Address
					address := row [row_temp.index_of ("Address")].out
					across
						(row_temp.index_of ("Address") + 1) |..| row_temp.contents.capacity as i
					loop
						address := address + row_temp [i.item].out
					end
				end
				sh_classes.init_genaral_info.add_addr (address)
				obtained_data := true
			end
		end

	is_successfully_obtain_data: BOOLEAN
		do
			result := obtained_data
		end

	detect_error
			-- detect errors and call error class
		do
			if not str_err.is_empty then
				error.error_custom (str_err)
			end
		end

feature {NONE}

	sh_classes: SHARED_CLASSES

	error: ERROR_TYPE

	str_err: STRING

	obtained_data: BOOLEAN

end
