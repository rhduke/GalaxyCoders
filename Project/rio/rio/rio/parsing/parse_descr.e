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
		error := sh_error.singlenton
		obtained_data := false
	end

feature
	parseRow ( row : ROW)
			local
				row_temp : ROW
				descr: STRING
				regexp: RX_PCRE_REGULAR_EXPRESSION
				i : INTEGER
			do
						row_temp := row
						io.put_string (row.contents.capacity.out)
						if row_temp.is_empty  then -- need to implented , should be end of file
--							error.name_error (1) -- should be description
						else

							if row_temp.matches_regex("^ *Description *:? *$") then -- field only contain
							--   keyword description but does not contains contents
								if row_temp.is_empty_from (row_temp.index_of ("Description")+1) then
									-- the line does not contain any contents
									io.put_string ("Description field is empty. only Description keyword is found%N")
								else
									 -- contains contents	
											if row_temp.matches_regex ("^(?!\s*$).+") then
												-- the fields contain contents
													row_temp.capture_strings_in_row ("^(?!\s*$).+").do_all (agent io.put_string (?))
													io.put_string ("valid Description%N")
												obtained_data := true
											else
												-- the fields have empty string
												io.put_string ("the Description field has empty strings %N")

											end
								end

							end
							if row_temp.matches_regex("^ *Description *:? *.+$") then
							-- this contains keyword Description and content might be the same Description's field or spread over fields
								if row_temp.is_empty_from (row_temp.index_of ("Description")+1)  then
									-- the content and Description are on same field as Description
									io.put_string (row_temp[row_temp.index_of ("Description")].out)
								else
									-- the content and Description are on different  field of Description
									descr := row[row_temp.index_of ("Description")].out
									from
										i := row_temp.index_of ("Description")+1;
									invariant
										i >= row_temp.index_of ("Description")+1
										i <= row_temp.contents.capacity +1
									until
										i > row_temp.contents.capacity
									loop
										descr :=descr +  row_temp[i].out
										i := i + 1
									variant
										row_temp.contents.capacity +1 - i
									end
									io.put_string (descr) -- store decr in object
								end
								obtained_data := true
							end

						end
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
