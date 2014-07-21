note
	description: "Summary description for {PARSER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PARSER

create
	make

feature -- extract

	make

		local
			csv_doc : CSV_DOCUMENT
			cursor : CSV_DOC_ITERATION_CURSOR
			row : ROW
			valid_rows : INTEGER
			i : INTEGER
			input_file : KL_TEXT_INPUT_FILE
			csv_doc_it : CSV_DOC_ITERATION_CURSOR
			mv: TUPLE [exists: BOOLEAN; value: REAL_64] -- market value
			cf: REAL_64 -- cash flow
			af: REAL_64 -- agent fees
			bm: TUPLE [exists: BOOLEAN; value: REAL_64] -- benchmark
			l_date: DATE
			name_error: BOOLEAN
			data_error: BOOLEAN
			rows_number_error: BOOLEAN
			error_name_message: STRING
			t: TUPLE [date: DATE;
			          mv: TUPLE[BOOLEAN,REAL_64];
			          cf: REAL_64;
			          af: REAL_64;
			          bm: TUPLE[BOOLEAN, REAL_64]]
			client_name : STRING
			pattern: STRING
			regexp: RX_PCRE_REGULAR_EXPRESSION
			error_date : BOOLEAN
			error_format : BOOLEAN
			error_name : BOOLEAN
			error_date_message: STRING
			error_format_message: STRING
			l_found: BOOLEAN
			e_found: BOOLEAN
			error_line : BOOLEAN
			error_line_message : STRING
			num_rows : INTEGER


		do
			l_found := false
			error_line := false
			error_format := false
			error_date := false
			error_name := false

			-- generating the pattern for name
			pattern := " *Name *: *(.+)"
			create regexp.make
			regexp.compile (pattern)
			check
				regexp.is_compiled
			end

			--setting the input file
			create input_file.make ("csv-inputs/case1.txt")
			input_file.open_read
			create csv_doc.make (input_file)

			--iterator
			from
				csv_doc_it := csv_doc.new_cursor
				num_rows := 0
			until
				csv_doc_it.after
			loop
				row := csv_doc_it.item
				num_rows := num_rows + 1

			-- name checking	
			if num_rows = 1 then
				regexp.match (row [1].out)
					if regexp.has_matched then
						client_name := regexp.captured_substring (1)
						client_name.trim
					else
						error_name := true
						error_name_message := "Error: Row number " + row.number.out
				        + ": Row containing the client name is not found.%N"
					end
			end

			--checking if file has the line "Transaction date, Market Value, Cash Flow, Agent Fees, Benchmark"
			if row.out.starts_with ("Transaction Date,Market Value,Cash Flow,Agent Fees,Benchmark") and then row.is_empty_from (6) then
				l_found := true
			end

			if row [1].is_date then
					if row [1].is_date and (row [2].is_double or row [2] ~ "") -- mv
						and (row [3].is_float or row [3].out ~ "") -- cf
						and (row [4].is_float or row [4].out ~ "") -- af
						and (row [5].is_percentage or row [5].out ~ "") -- bm
						and row.is_empty_from (6)
					then

						l_date := row [1].as_date
						if row [2].is_float then
							mv := [true, row [2].as_float]
						else
							mv := [false, 0.0]
						end
						if row [3].is_float then
							cf := row [3].as_float
						else
							cf := 0.0
						end
						if row [4].is_float then
							af := row [4].as_float
						else
							af := 0.0
						end
						if row [5].is_percentage then
							bm := [true, row [5].as_percentage] -- what about percentage
						else
							bm := [false, 0.0]
						end
						valid_rows := valid_rows + 1
						t := [l_date, mv, cf, af, bm]
						print(t.date)
						print(", ")
						print(t.mv)
						print(", ")
						print(t.cf)
						print(", ")
						print(t.af)
						print(", ")
						print(t.bm)
						io.put_new_line

						--data.force (t, i)
						i := i + 1

					else
						error_format := true
						error_format_message := "Error: Row number " + row.number.out
                   			+ ": types of a data item row should be: [DATE, DOUBLE, FLOAT, FLOAT, _%%%N]."
					end
				elseif row.is_empty then
					e_found := true


				elseif valid_rows > 1 then
                 		error_date := true
						error_date_message := "Error: Row number " + row.number.out
	                   			+ ": a data item row should have a date as its first field%N."
				end


			csv_doc_it.forth


			end

--		if error_format = true then
--			print(error_format_message)
--		end

		if error_name = true then
			print(error_name_message)
		end

		if error_date  = true then
			print(error_date_message)
		end

		if not l_found then
		error_line := true
		error_line_message := "Error: Row number " + row.number.out
      	+ ": Data header (i.e. Transaction Date,Market Value,Cash Flow,Agent Fees,Benchmark) is not found.%N"
		print(error_line_message)

		end

	-- checking if there are two or more syntactically valid rows
       if valid_rows < 2 then
			rows_number_error := true
			print("Error : Your file has less than two valid data rows%N")
		end



		end



end





