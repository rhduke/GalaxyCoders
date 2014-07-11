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
			text : ARRAY[FIELD]
			row : ROW
			num_rows : INTEGER
			input_file : KL_TEXT_INPUT_FILE
			csv_doc_it : CSV_DOC_ITERATION_CURSOR
			date : DATE
			amount : REAL_64
			cash_flow : REAL_64
			agent_fees : REAL_64
			benchmark : REAL_64


		do

			create input_file.make ("csv-inputs/case1.txt")
			input_file.open_read
			create csv_doc.make (input_file)

			from
				csv_doc_it := csv_doc.new_cursor
				num_rows := 0
			until
				csv_doc_it.after
			loop
				row := csv_doc_it.item
				num_rows := num_rows + 1

				if row[1].is_date then
					date := row[1].as_date
					print(date)
					print(",")
				end

				if row [2].is_double then
					amount := row[2].as_double
					print(amount)
					print(",")
				end

				if row [3].is_float then
					cash_flow := row[3].as_float
					print(cash_flow)
					print(",")
				else
					cash_flow := 0.0
					print(cash_flow)
					print(",")
				end

				if row [4].is_float then
					agent_fees := row[4].as_float
					print(agent_fees)
					print(",")
				else
					agent_fees := 0.0
					print(agent_fees)
					print(",")
				end

				if row [5].is_percentage then
					benchmark := row[5].as_percentage
					print(benchmark)

				else
					benchmark := 0.0
					print(benchmark)

				end




				csv_doc_it.forth
				io.put_new_line

			end


		end


end




