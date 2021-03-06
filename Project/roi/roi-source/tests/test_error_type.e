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

	make (path: STRING)
		local
			err: ERROR_TYPE
			rd_file: READ_FILE
			csv_iteration_cursor: CSV_DOC_ITERATION_CURSOR
			pt: PORTFOLIO_DATA
			temp_1, temp_2: PF_DATE
		do
				--			create csv_doc.make_from_file_name(path)
			rd_file := sh_classes.init_file_read
			rd_file.open_file (path)
			add_to_list
			from
					--				csv_iteration_cursor := csv_doc.new_cursor
				csv_iteration_cursor := rd_file.init_new_cursor
			until
				csv_iteration_cursor.after
			loop
				pass_to_list (csv_iteration_cursor.item)
				csv_iteration_cursor.forth
			end
			across
				list as c
			loop
				c.item.error_examine
			end
			err := sh_classes.init_error
			pt := sh_classes.init_portfolio_data
			pt.run_validation
			if pt.is_valid_portfolio then
				sh_classes.init_portfolio_data.printout
				create p.make
				print ("PRECISE (whole): " + p.anual_precise.out + "%N")
				if pt.is_eval_per_in_range then
					create temp_1.make (pt.get_eval_per.getvalue.x)
					create temp_2.make (pt.get_eval_per.getvalue.y)
					print ("PRECISE (part): " + p.precise (temp_1, temp_2).out + "%N")
				end
				create twr.make
				print ("TWR (whole): " + twr.anual_compounded_twr (twr.start_date, twr.end_date).out + "%N")
				if pt.is_eval_per_in_range then
					create temp_1.make (pt.get_eval_per.getvalue.x)
					create temp_2.make (pt.get_eval_per.getvalue.y)
					print ("TWR (part): " + twr.anual_compounded_twr (temp_1, temp_2).out + "%N")
				end
			else
				print ("error")
			end

				--			err.print_errors

		end

feature

	add_to_list
		local
			par: PARSING_CONTEXT
			i: INTEGER
		do
			create par.make
			create list.make_empty
			list.grow (8)
			from
				i := list.lower
			until
				i > list.upper
			loop
				list.force (create {PARSING_CONTEXT}.make, i)
				i := i + 1
			end
			list [1].setparsingstrategy (create {PARSE_DESCR}.make)
			list [2].setparsingstrategy (create {PARSE_NAME}.make)
			list [3].setparsingstrategy (create {PARSE_EMAIL}.make)
			list [4].setparsingstrategy (create {PARSE_PHONE}.make)
			list [5].setparsingstrategy (create {PARSE_ADDR}.make)
			list [6].setparsingstrategy (create {PARSE_ACCOUNT}.make)
			list [7].setparsingstrategy (create {PARSE_EVAL_PER}.make)
			list [8].setparsingstrategy (create {PARSE_DATA}.make)
		end

	pass_to_list (row: ROW)
		local
			i: INTEGER
		do
			from
				i := list.lower
			until
				i > list.upper
			loop
				list [i].getrowinfo (row)
				if list [i].has_obtained_data then
					remove_at (i)
				end
				i := i + 1
			end
				--		across list as c  loop c.item.getrowinfo (row)  end

		end

	remove_at (j: INTEGER)
		local
			i: INTEGER
		do
			from
				i := j
			until
				i = list.count
			loop
				list [i] := list [i + 1]
				i := i + 1
			end
			list.remove_tail (1)
		end

feature
	--	csv_doc: CSV_DOCUMENT
	--	csv_iteration_cursor: CSV_DOC_ITERATION_CURSOR

	list: ARRAY [PARSING_CONTEXT]

	sh_classes: SHARED_CLASSES

	twr: TWR_CALCULATION

	p: PRECISE_CALCULATION

	soln: REAL_64

end
