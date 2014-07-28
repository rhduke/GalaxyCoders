note
	description: "Summary description for {PARSE_EMAIL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PARSE_EMAIL
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
	parseRow ( row : ROW)
			local
				row_temp : ROW
			do
						row_temp := row
							if row_temp.matches_regex("^\s*(?i)Email\s*:?\s*$") then -- keyword name is found

							--  but does not contains person's name
								if row_temp.is_empty_from (row_temp.index_of ("Email")+1) then
									-- the line does not contain person's name
									error.custom_msg ("Email field is empty on line" + row_temp.number.out+". only Email keyword is found.%N")
								else
									 -- contains words	
											if row_temp.matches_regex ("\s*[\w]+@[\w]+.[\w]{1,3}\s*") then
												-- the fields contain valid name
												row_temp.capture_strings_in_row ("\s*[\w]+@[\w]+.[\w]{1,3}\s*").do_all (agent io.put_string (?))
												obtained_data := true

											else
												error.custom_msg ("Email field is invalid on line" + row_temp.number.out+". make sure to valid email.%N")
											end


								end

							end
							if row_temp.matches_regex("^\s*(?i)Email\s*:?\s*[\w]+@[\w]+.[\w]{1,3}\s*$") then
							-- this contains keyword name and full name is one field
								row_temp.capture_strings_in_row ("^\s*(?i)Email\s*:?\s*[\w]+@[\w]+.[\w]{1,3}\s*$").do_all (agent io.put_string (?)) -- store in object
								io.put_new_line
								obtained_data := true
							end
			end

	is_successfully_obtain_data : BOOLEAN
	do
		result := obtained_data
	end
	detect_error
			-- detect errors and call error class
	do
			-- nothing to do here since account # is not manditory
	end

feature {NONE}
	sh_classes : SHARED_CLASSES

	error : ERROR_TYPE

	obtained_data : BOOLEAN
end
