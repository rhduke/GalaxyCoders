note
	Name: "Summary Name for {PARSE_NAME}."
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
		error := sh_classes.init_error
		obtained_data := false
	end

feature
	parseRow (row : ROW)
			local
				row_temp : ROW
				name : STRING
				i : INTEGER
			do
				row_temp := row
				if row_temp.number = 1 then
					if row_temp.matches_regex("^\s*(?i)Name\s*:?\s*$") then -- keyword name is found
						--  but does not contains person's name
						if row_temp.is_empty_from (row_temp.index_of ("Name")+1) then
							-- the line does not contain person's name
							error.custom_msg ("Name content is empty on line 1. only Name keyword is found%N")
						else
							-- contains words	
							if row_temp.matches_regex ("^ *[a-zA-Z]+[\s|,]*[a-zA-Z]* *$") then
								-- the fields contain valid name
									row_temp.capture_strings_in_row ("^ *[a-zA-Z]+[\s|,]*[a-zA-Z]* *$").do_all (agent io.put_string (?))
									obtained_data := true
							else
								error.custom_msg ("Name content is empty on line 1. only Name keyword is found%N")

							end
						end
					end
			if row_temp.matches_regex("^\s*(?i)Name\s*:?\s*[a-zA-Z]+.*$") then
				-- this contains keyword Name and content might be the same Name's field or spread over fields
				if row_temp.is_empty_from (row_temp.index_of ("Name")+1)  then
					-- the content and Name are on same field as Name
					io.put_string (row_temp[row_temp.index_of ("Name")].out)
					io.put_new_line
				else
					-- the content and Name are on different  field of Name
					name := row[row_temp.index_of ("Name")].out
					from
						i := row_temp.index_of ("Name")+1;
					invariant
						i >= row_temp.index_of ("Name")+1
						i <= row_temp.contents.capacity +1
					until
						i > row_temp.contents.capacity
					loop
						name :=name +  row_temp[i].out
						i := i + 1
					variant
						row_temp.contents.capacity +1 - i
					end
					io.put_string (name + "%N") -- store decr in object
				end
				obtained_data := true
			end

		end

	end

	is_successfully_obtain_data : BOOLEAN
			-- did we obtain the data ?
	do
		result := obtained_data
	end

	detect_error
			-- detect errors and call error class
	do
		if not is_successfully_obtain_data then
			error.name_error
		end
	end
feature {NONE} -- global variable
	sh_classes : SHARED_CLASSES
	error : ERROR_TYPE
	obtained_data : BOOLEAN

end
