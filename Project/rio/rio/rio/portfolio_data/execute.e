note
	description: "Summary description for {EXECUTE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXECUTE
create
	make
feature {NONE}
	make
	do
		read_from_input
		read_file
	end
feature {NONE}
	read_from_input
	do
		io.put_string ("roi ")
		io.read_line
		file_path := io.last_string
	end


	read_file
	local
			rd_file : READ_FILE
	do
			rd_file := sh_classes.init_file_read
			rd_file.open_file (file_path)
			if  rd_file.is_path_valid then
				parse_file
			else
				io.put_string ("Unable to read file. Invalid file path")
			end

	end

	parse_file
	local
			csv_iteration_cursor: CSV_DOC_ITERATION_CURSOR
	do
			from
				csv_iteration_cursor :=  sh_classes.init_file_read.init_new_cursor
			until
				csv_iteration_cursor.after
			loop
				obtain_data(csv_iteration_cursor.item)	-- will obtain data from filr
				csv_iteration_cursor.forth
			end
			across context_list as  c  loop c.item.error_examine end -- if any parsing class left an error will be reported
			sh_classes.init_portfolio_data.printout -- just test to print portfolio data


	end

	obtain_data ( row : ROW)
	local
		i : INTEGER
	do
		init_context_list
		from
				i := context_list.lower
				invariant
						i >= context_list.lower
						i <= context_list.count + 1
			until
				i > context_list.upper
			loop
				context_list[i].getrowinfo (row)
				if context_list[i].has_obtained_data then
					remove_at(i)
				end
				i := i + 1
			variant
			context_list.count + 1 - i
			end

	end
	init_context_list
	do
		create context_list.make_empty
		context_list.grow (9)
		across 1 |..| 9 as i loop context_list.force (create {PARSING_CONTEXT}.make, i.item)  end
		context_list[1].setparsingstrategy (create {PARSE_DESCR}.make)
		context_list[2].setparsingstrategy (create {PARSE_NAME}.make)
		context_list[3].setparsingstrategy (create {PARSE_EMAIL}.make)
		context_list[4].setparsingstrategy (create {PARSE_PHONE}.make)
		context_list[5].setparsingstrategy (create {PARSE_ADDR}.make)
		context_list[6].setparsingstrategy (create {PARSE_ACCOUNT}.make)
		context_list[7].setparsingstrategy (create {PARSE_EVAL_PER}.make)
		context_list[8].setparsingstrategy (create {PARSE_DATA}.make)
		context_list[9].setparsingstrategy (create {PARSE_TABLE}.make)
	end

feature -- routine helpers\
	remove_at( j : INTEGER)
			-- remove element from context list
local
			i : INTEGER
	do

		from
			i := j
		invariant
			i >= j
			i <= context_list.count
		until
			i = context_list.count
		loop
			context_list[i] := context_list[i+1]
			i := i + 1
		variant
			context_list.count - i
		end
		context_list.remove_tail (1)
	end


feature {NONE}
	file_path : STRING
	sh_classes : SHARED_CLASSES
	context_list :ARRAY[PARSING_CONTEXT]

end
