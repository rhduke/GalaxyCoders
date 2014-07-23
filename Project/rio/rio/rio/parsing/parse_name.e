note
	description: "Summary description for {PARSE_NAME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PARSE_NAME
	inherit
	PARSING_STRATEGY
create
	make
feature {NONE}
	make
	do
		error := sh_error.singlenton
		obtained_data := false
	end

feature
	parseRow (row : ROW)
			local
				row_temp : ROW
			do
				row_temp := row

				if row_temp.is_empty and row_temp.number  = 1 then
					error.name_error (1)
				else
					if row_temp.matches_regex("^\s*(?i)Name\s*:?\s*$") then -- keyword name is found
					--  but does not contains person's name
						if row_temp.is_empty_from (row_temp.index_of ("Name")+1) then
							-- the line does not contain person's name
							io.put_string ("Name field is empty. only Name keyword is found%N")
						else
							 -- contains words	
									if row_temp.matches_regex ("^ *[a-zA-Z]+[\s|,]*[a-zA-Z]* *$") then
										-- the fields contain valid name
										if row_temp.number = 1 then
											-- on first line
											row_temp.capture_strings_in_row ("^ *[a-zA-Z]+[\s|,]*[a-zA-Z]* *$").do_all (agent io.put_string (?))
											io.put_string ("valid name and on first line , on sperate fields%N")
										else

											-- other than first line
											row_temp.capture_strings_in_row ("^ *[a-zA-Z]+[\s|,]*[a-zA-Z]* *$").do_all (agent io.put_string (?))
											io.put_string ("valid name  not on  first line , on sperate fields%N")
										end
										obtained_data := true
									else
										io.put_string ("the row does not contain person's name %N")

									end


						end
					elseif row_temp.matches_regex("^\s*(?i)Name\s*:\s*[a-zA-Z]+[\s|,]*[a-zA-Z]*$") then
					-- this contains keyword name and full name is one field
						if row.number = 1 then -- its valid csv sytnax
							io.put_string ("yes.Vaild  %N") -- store in object
							obtained_data := true
						else
							io.put_string ("yes Name found but different line%N") -- call this in error class
						end

					end
				end



	end

	is_successfully_obtain_data : BOOLEAN
	do
		result := obtained_data
	end
feature
feature {NONE} -- global variable
	sh_error : SHARED_ERROR_TYPE

	error : ERROR_TYPE

	obtained_data : BOOLEAN

end
