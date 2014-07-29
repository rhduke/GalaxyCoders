note
	description: "Summary description for {PARSE_Account}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PARSE_ACCOUNT

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
			account: STRING
			gen_info: PF_GEN_INFO
		do
			row_temp := row
			if row_temp.matches_regex ("^\s*(?i)Account\s*#?\s*:?\s*$") then -- keyword name is found

					--  but does not contains person's name
				if row_temp.is_empty_from (row_temp.index_of ("Account") + 1) then
						-- the line does not contain person's name
					str_err := "Account field is empty on line" + row_temp.number.out + ". only Account keyword is found.%N"
				else
						-- contains words
					if row_temp.matches_regex ("\s*\d+\s*") then
							-- the fields contain valid name
						create account.make_empty
						across
							row_temp.capture_strings_in_row ("\s*\d+\s*") as c
						loop
							account := account + c.item
						end
						sh_classes.init_genaral_info.add_account (account)
						obtained_data := true
					else
						str_err := "Account field is invalid on line" + row_temp.number.out + ". make sure to have only numbers.%N"
					end
				end
			end
			if row_temp.matches_regex ("^\s*(?i)Account\s*#?\s*:?\s*\d+\s*$") then
					-- this contains keyword name and full name is one field
				create account.make_empty
				across
					row_temp.capture_strings_in_row ("^\s*(?i)Account\s*#?\s*:?\s*\d+\s*$") as c
				loop
					account := account + c.item
				end
				sh_classes.init_genaral_info.add_account (account)
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

feature

	sh_classes: SHARED_CLASSES

	error: ERROR_TYPE

	str_err: STRING

	obtained_data: BOOLEAN

end
