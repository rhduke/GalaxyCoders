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
				pattern , string: STRING
				regexp , valid_name: RX_PCRE_REGULAR_EXPRESSION
			do
				pattern := " *Name *: *(.+)"

				create regexp.make
				regexp.compile (pattern)
				check
					regexp.is_compiled
				end
				create valid_name.make
					valid_name.compile ("^[a-zA-Z]+[\s|,]*[a-zA-Z]*$") -- assume that name is following
					--  N.A convention
					check valid_name.is_compiled  end
				row_temp := row

				if row_temp.is_empty and row_temp.number  = 1 then
					error.name_error (1)
				else
					if row_temp.matches_regex("^ *Name * :? *$") then -- keyword name is found
					--  but does not contains person's name
						if row_temp.is_empty_from (row_temp.index_of ("Name")) then
							-- the line does not contain person's name
							io.put_string ("Name field is empty. only Name keyword is found%N")
						else
							 -- contains words
							 if row.number = 1 then
									-- if its in row 1
									-- need to be completed
							 end
						end
					elseif row_temp.matches_regex("^ *Name *: *[a-zA-Z]+[\s|,]*[a-zA-Z]*$") then
					-- this contains keyword name and full name is one field
						if row.number = 1 then -- its valid csv sytnax
							io.put_string ("yes.Vaild %N") -- store in object
						else
							io.put_string ("yes Name found but different line%N") -- call this in error class
						end

					end


--					across row_temp.contents  as fields
--					loop
--						regexp.match (fields.item.out)
--						if regexp.has_matched then
--							string := regexp.captured_substring (1)
--							string.trim
--							valid_name.match (string) -- check if given name is valid N.A standard
--							if valid_name.has_matched then
--								if row.number = 1 then
--									io.put_string (valid_name.captured_substring (0)+ "%N") -- Name is found ,valid and its on first line
--								else
--									io.put_string ("Name is found but not on first line%N") -- Name is found ,valid and its not on first line
--									-- need add to add to error	class								

--								end
--								obtained_data := true
--							else
----								io.put_string ("Name is not found%N") -- Name is not in file
--									-- need add to add to error	class			
--							end

--						else
--							io.put_string (obtained_data.out+ "%N")
--							io.put_string ("name is not found%N") -- name is not found
--							-- need add to add to error error	class	
--						end

--				 	end
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
