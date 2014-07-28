note
	description: "Summary description for {PARSE_DESCR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PARSE_DESCR

inherit

	PARSING_STRATEGY

create
	make

feature {NONE}

	make
		do
			error := sh_classes.init_error
			create str_err.make_empty
			obtained_data := false
		end

feature

	parseRow (row: ROW)
		local
			row_temp: ROW
			descr: STRING
		do
			row_temp := row
			if row_temp.matches_regex ("^\s*(?i)Description\s*:?\s*$") then -- field only contain
					--   keyword description but does not contains contents
				if row_temp.is_empty_from (row_temp.index_of ("Description") + 1) then
						-- the line does not contain any contents
					str_err := "Description field is empty on line" + row_temp.number.out + ". only Description keyword is found.%N"
				else
						-- contains contents
					if row_temp.matches_regex ("^(?!\s*$).+") then
							-- the fields contain contents
						create descr.make_empty
						across
							row_temp.capture_strings_in_row ("^(?!\s*$).+") as c
						loop
							descr := descr + c.item
						end
						sh_classes.init_genaral_info.add_decr (descr)
						obtained_data := true
					else
							-- the fields have empty string
						str_err := "Description field is invalid on line" + row_temp.number.out + ". make sure to have non_empty content.%N"
					end
				end
			end
			if row_temp.matches_regex ("^\s*(?i)Description\s*:?\s*[\w]+.*$") then
					-- this contains keyword Description and content might be the same Description's field or spread over fields
				create descr.make_empty
				if row_temp.is_empty_from (row_temp.index_of ("Description") + 1) then
						-- the content and Address are on same field as Address
					descr := row_temp [row_temp.index_of ("Description")].out
				else
						-- the content and Address are on different  field of Address
					descr := row [row_temp.index_of ("Description")].out
					across
						(row_temp.index_of ("Description") + 1) |..| row_temp.contents.capacity as i
					loop
						descr := descr + row_temp [i.item].out
					end
				end
				sh_classes.init_genaral_info.add_decr (descr)
				obtained_data := true
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
				error.custom_msg (str_err)
			end
		end

feature {NONE}

	sh_classes: SHARED_CLASSES

	error: ERROR_TYPE

	str_err: STRING

	obtained_data: BOOLEAN

end
