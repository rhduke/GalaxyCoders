note
	description: "Summary description for {PORTFOLIO_HISTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PORTFOLIO_HISTORY

create
	make

feature -- attritubes
	name: STRING
	data: TUPLE[date:DATE; market_val:REAL_64; cash_flow:REAL_64; agent_fees:REAL_64; benchmark:REAL_64]
	description: STRING
	acc_num: INTEGER
	email: STRING
	address: STRING
	phone_num: INTEGER

feature -- extract
	make
		local
			input : CSV_DOCUMENT
			cursor : CSV_DOC_ITERATION_CURSOR
			text : ARRAY[FIELD]
		do
			create input.make_from_file_name("csv-inputs/roi-test1.csv")

			from
				cursor := input.new_cursor
			until
				cursor.after
			loop
				text := cursor.item.contents
				text.compare_objects
				print(text[1])
				io.new_line
				cursor.forth
			end

			--print(input.stream.last_string)
		end


end
