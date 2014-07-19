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
feature
	make do  end;

feature
	parseRow (row : ROW)
			local
				row_temp : ROW
				pattern: STRING
				regexp: RX_PCRE_REGULAR_EXPRESSION
			do
				pattern := " *Name *: *(.+)"

				create regexp.make
				regexp.compile (pattern)
				check
					regexp.is_compiled
				end
				regexp.match (row[1].out)
				if regexp.has_matched then
					io.put_string (regexp.captured_substring (1))
				else
					error.name_error (row.number)
				end

	end


feature -- global variable
	sh_error : SHARED_ERROR_TYPE

	error : ERROR_TYPE do
		result := sh_error.singlenton
	end

end
