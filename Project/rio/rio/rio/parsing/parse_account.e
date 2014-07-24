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
	end

feature
	parseRow ( row : ROW)
			local
				row_temp : ROW
				pattern: STRING
				regexp: RX_PCRE_REGULAR_EXPRESSION
			do
						row_temp := row
							if row_temp.matches_regex("^\s*(?i)Account\s*#?\s*:?\s*$") then -- keyword name is found

							--  but does not contains person's name
								if row_temp.is_empty_from (row_temp.index_of ("Account")+1) then
									-- the line does not contain person's name
									io.put_string ("Account field is empty. only Account keyword is found%N")
								else
									 -- contains words	
											if row_temp.matches_regex ("\s*\d+\s*") then
												-- the fields contain valid name
													row_temp.capture_strings_in_row ("\s*\d+\s*").do_all (agent io.put_string (?))
													io.put_string (" valid Account%N")
													obtained_data := true

											else
												io.put_string ("the Account field has empty strings %N")
											end


								end

							end
							if row_temp.matches_regex("^\s*(?i)Account\s*#?\s*:?\s*\d+\s*$") then
							-- this contains keyword name and full name is one field
								row_temp.capture_strings_in_row ("^\s*(?i)Account\s*#?\s*:?\s*\d+\s*$").do_all (agent io.put_string (?)) -- store in object
								io.put_new_line
								obtained_data := true
							end
			end

	is_successfully_obtain_data : BOOLEAN
	do
		result := obtained_data
	end

feature
	sh_classes : SHARED_CLASSES
	error : ERROR_TYPE
	obtained_data : BOOLEAN
end
