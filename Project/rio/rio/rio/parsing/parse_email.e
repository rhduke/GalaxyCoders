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
		error := sh_error.singlenton
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

						if row_temp.is_empty  then -- need to implented , should be end of file
--							error.name_error (1) -- should be description

						else

							if row_temp.matches_regex("^ *Email *:? *$") then -- keyword name is found

							--  but does not contains person's name
								if row_temp.is_empty_from (row_temp.index_of ("Email")+1) then
									-- the line does not contain person's name
									io.put_string ("Email field is empty. only Email keyword is found%N")
								else
									 -- contains words	
											if row_temp.matches_regex ("\s*[\w]+@[\w]+.[\w]{1,3}\s*") then
												-- the fields contain valid name
													row_temp.capture_strings_in_row ("\s*[\w]+@[\w]+.[\w]{1,3}\s*").do_all (agent io.put_string (?))
													io.put_string (" valid Email%N")
												obtained_data := true

											else
												io.put_string ("the Email field has empty strings %N")
											end


								end

							end
							if row_temp.matches_regex("^ *Email *:? *[\w]+@[\w]+.[\w]{1,3}") then
							-- this contains keyword name and full name is one field
								io.put_string ("Email is found %N") -- store in object
								obtained_data := true
							end
						end


--				pattern := " *Description *: *(.+)"

--				create regexp.make
--				regexp.compile (pattern)
--				check
--					regexp.is_compiled
--				end
--				regexp.match (row[1].out)
--				if regexp.has_matched then
--					io.put_string (regexp.captured_substring (1) + "%N")
--					obtained_data := true
--				else
--					error.description_error (row.number)
--				end
			end

	is_successfully_obtain_data : BOOLEAN
	do
		result := obtained_data
	end

feature {NONE}
	sh_error : SHARED_ERROR_TYPE

	error : ERROR_TYPE

	obtained_data : BOOLEAN
end
