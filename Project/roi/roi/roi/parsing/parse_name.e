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

	parseRow (row: ROW)
		local
			row_temp: ROW
			name: STRING
			gen_info: PF_GEN_INFO
		do
			row_temp := row
			if row_temp.number = 1 then
				if row_temp.matches_regex ("^\s*(?i)Name\s*:?\s*$") then -- keyword name is found
						--  but does not contains person's name
					if row_temp.is_empty_from (row_temp.index_of ("Name") + 1) then
							-- the line does not contain person's name
					else
							-- contains words
						if row_temp.matches_regex ("^\s*[a-zA-Z]+[\s|,]*[a-zA-Z]*\s*$") then
								-- the fields contain valid name
							create name.make_empty
							across
								row_temp.capture_strings_in_row ("^\s*[a-zA-Z]+[\s|,]*[a-zA-Z]*\s*$") as c
							loop
								c.item.trim
								name := name + c.item
							end
							obtained_data := true
							gen_info := sh_classes.init_genaral_info
							gen_info.add_name (name)
						end
					end
				end
				if row_temp.matches_regex ("^\s*(?i)Name\s*:?\s*\w+\s*\w+\s*$") then
						-- this contains keyword Name and content might be the same Name's field or spread over fields
					create name.make_empty
					across
						row_temp.capture_strings_in_row ("^\s*(?i)Name\s*:?\s*\w+\s*\w+\s*$") as c
					loop
						name := name + c.item
					end
					obtained_data := true
					gen_info := sh_classes.init_genaral_info
					gen_info.add_name (name)
				end
			end
		end

	is_successfully_obtain_data: BOOLEAN
			-- did we obtain the data ?
		do
			result := obtained_data
		end

	detect_error
			-- detect errors and call error class
		do
			if not is_successfully_obtain_data then
				error.error_name
			end
		end

feature {NONE} -- global variable

	sh_classes: SHARED_CLASSES

	error: ERROR_TYPE

	obtained_data: BOOLEAN

end
