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
			add_to_list
			from
				csv_iteration_cursor := csv_doc.new_cursor
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
	local
		par : PARSING_CONTEXT
		i: INTEGER
	do
		create par.make
		create list.make_empty
		list.grow (2)
		from
			i := list.lower
		until
			i > list.upper
		loop
			list.force (create {PARSING_CONTEXT}.make, i)
			i := i + 1
		end
--		list.force (create {PARSING_CONTEXT}.make, 1)
--		list.force (create {PARSING_CONTEXT}.make, 2)
		list[1].setparsingstrategy (create {PARSE_DESCR}.make)
		list[2].setparsingstrategy (create {PARSE_NAME}.make)
	end
	pass_to_list ( row : ROW)
	local
		i : INTEGER
	do
		from
			i := list.lower

		until
			i > list.upper
		loop
			list[i].getrowinfo (row)
			if list[i].has_obtained_data then
				remove_at(i)
			end
			i := i + 1
		end
--		across list as c  loop c.item.getrowinfo (row)  end

	end

	remove_at( j : INTEGER)
	local
			i : INTEGER
	do

		from
			i := j
		until
			i = list.count
		loop
			list[i] := list[i+1]
			i := i + 1
		end
		list.remove_tail (1)
	end
feature
	csv_doc: CSV_DOCUMENT
	csv_iteration_cursor: CSV_DOC_ITERATION_CURSOR
	list : ARRAY[PARSING_CONTEXT]
	error : SHARED_ERROR_TYPE

end
