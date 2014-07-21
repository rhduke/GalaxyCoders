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
				pattern: STRING
				regexp: RX_PCRE_REGULAR_EXPRESSION
			do

							


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
