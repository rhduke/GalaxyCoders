note
	description: "Summary description for {TEST_ERROR_TYPE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_ERROR_TYPE
create
	make
feature
	make ( path : STRING)
	local
		err : ERROR_TYPE
	do
			create csv_doc.make_from_file_name(path)
			csv_iteration_cursor := csv_doc.new_cursor

			from
				csv_iteration_cursor.forth
			until
				csv_iteration_cursor.after
			loop
				pass_to_list(csv_iteration_cursor.item)
				csv_iteration_cursor.forth
			end
			err := error.singlenton
			err.print_errors
	end
feature
	add_to_list
	do

		list[1].setparsingstrategy (create {PARSE_NAME}.make)
		list[2].setparsingstrategy (create {PARSE_DESCR}.make)
	end
	pass_to_list ( row : ROW)
	local
		par : PARSING_CONTEXT
		par_2 : PARSING_CONTEXT
	do
--		add_to_list
--		across list as c  loop c.item.getrowinfo (row) end
	create par.make
	create par_2.make
	par.setparsingstrategy (create {PARSE_NAME}.make)
	par.getrowinfo (row)
	par_2.setparsingstrategy (create {PARSE_DESCR}.make)
	par.getrowinfo (row)
	end
feature
	csv_doc: CSV_DOCUMENT
	csv_iteration_cursor: CSV_DOC_ITERATION_CURSOR
	list : ARRAY[PARSING_CONTEXT] do
		create result.make_filled (create {PARSING_CONTEXT}.make, 1,2)
	end
	error : SHARED_ERROR_TYPE

end
