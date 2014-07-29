note
	description: "Summary description for {PARSE_TABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PARSE_TABLE

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
			if row_temp.number >= 5 then
				if row_temp[1].out.is_case_insensitive_equal("Transaction Date") and row_temp[2].out.is_case_insensitive_equal("Market Value")
							and row_temp[3].out.is_case_insensitive_equal("Cash Flow") and row_temp[4].out.is_case_insensitive_equal("Agent Fees")
							and row_temp[5].out.is_case_insensitive_equal("Benchmark")
						--  table titles are precisely shown
				then
					obtained_data := true
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
				error.error_table
			end
		end

feature {NONE} -- global variable

	sh_classes: SHARED_CLASSES

	error: ERROR_TYPE

	obtained_data: BOOLEAN

end
