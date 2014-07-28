note
	description: "Summary description for {PARSE_PHONE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PARSE_PHONE

inherit

	PARSING_STRATEGY

create
	make

feature {NONE}

	make
		do
			error := sh_classes.init_error
			obtained_data := false
		end

feature

	parseRow (row: ROW)
		local
			row_temp: ROW
		do
			row_temp := row
			if row_temp.matches_regex ("^\s*(?i)Phone\s*:?\s*$") then -- keyword name is found

					--  but does not contains person's name
				if row_temp.is_empty_from (row_temp.index_of ("Phone") + 1) then
						-- the line does not contain person's name
					error.custom_msg ("phone field is empty on line" + row_temp.number.out + ". only phone period keyword is found.%N")
				else
						-- contains words
					if row_temp.matches_regex ("^\s*\(?[1-9]\d{2}\)?-?\d{3}-?\d{4}\s*(x\d+)$") then
							-- the fields contain valid name
						row_temp.capture_strings_in_row ("^\s*\(?[1-9]\d{2}\)?-?\d{3}-?\d{4}\s*(x\d+)$").do_all (agent io.put_string(?))
						obtained_data := true
					elseif row_temp.matches_regex ("^\s*\(?[1-9]\d{2}\)?-?\d{3}-?\d{4}\s*$") then
						if row_temp.matches_regex ("^\s*x\d+\s*$") then
							row_temp.capture_strings_in_row ("^\s*\(?[1-9]\d{2}\)?-?\d{3}-?\d{4}\s*$").do_all (agent io.put_string(?))
							row_temp.capture_strings_in_row ("^\s*x\d+\s*$").do_all (agent io.put_string(?))
							obtained_data := true
						else
							row_temp.capture_strings_in_row ("^\s*\(?[1-9]\d{2}\)?-?\d{3}-?\d{4}\s*$").do_all (agent io.put_string(?))
							obtained_data := true
						end
					else
						io.put_string ("phone field is empty on line" + row_temp.number.out + ".%N")
					end
				end
			end
			if row_temp.matches_regex ("^\s*(?i)Phone\s*:?\s*\(?[1-9]\d{2}\)?-?\d{3}-?\d{4}\s*(x\d+)?\s*$") then
					-- this contains keyword name and full name is one field
				io.put_string ("Phone is found %N") -- store in object
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
				-- nothing to do here since account # is not manditory
		end

feature {NONE}

	sh_classes: SHARED_CLASSES

	error: ERROR_TYPE

	obtained_data: BOOLEAN

end
