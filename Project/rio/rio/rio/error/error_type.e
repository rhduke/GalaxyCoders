note
	description: "Summary description for {ERROR_TYPE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

frozen class
	ERROR_TYPE

inherit

	ANY

create {SHARED_CLASSES}
	make

feature {NONE} -- initialize

	make
		local
			err_list: LINKED_LIST [STRING]
		do
			create err_list.make
			error_list := err_list
			twr_no_sol_found := false
		end

feature --  arbitrary data errors

	error_name
		do
			error_list.extend ("Warning! Name was not found on the first line.%N")
		ensure
			error_added: error_list.count = old error_list.count + 1
		end

	error_description (line_number: INTEGER_32)
		require
			line_num_pos: line_number >= 1
		do
			error_list.extend ("Warning! The line " + line_number.out + " is not valid description.%N")
		ensure
			error_added: error_list.count = old error_list.count + 1
		end

	error_accout_num (line_num: INTEGER_32)
		require
			line_num_pos: line_num >= 1
		do
			error_list.extend ("Warning! The line " + line_num.out + " is not valid  account number.%N")
		ensure
			error_added: error_list.count = old error_list.count + 1
		end

	error_email (line_num: INTEGER_32)
		require
			line_num_pos: line_num >= 1
		do
			error_list.extend ("Warning! The line " + line_num.out + " is not valid email.%N")
		ensure
			error_added: error_list.count = old error_list.count + 1
		end

	error_benchmark (line_num: INTEGER_32)
		require
			line_num_pos: line_num >= 1
		do
			error_list.extend ("Warning! The line " + line_num.out + " contains date the corresponds benchmark at line has month-day that is not Jan-01 or not in last satement.%N")
		ensure
			error_added: error_list.count = old error_list.count + 1
		end

	error_phone_num (line_num: INTEGER_32)
		require
			line_num_pos: line_num >= 1
		do
			error_list.extend ("Warning! The line " + line_num.out + " is not valid phone number.%N")
		ensure
			error_added: error_list.count = old error_list.count + 1
		end

	error_table
		do
			error_list.extend ("Warning! The table title is invalid. The proper format is: Transaction Date,Market Value,Cash Flow,Agent Fees,Benchmark%N")
		ensure
			error_added: error_list.count = old error_list.count + 1
		end

	error_eval_per
		do
			error_list.extend ("Error! The dates in the evaluation period are invalid or don't exist.%N")
		ensure
			error_added: error_list.count = old error_list.count + 1
		end

	error_custom (string: STRING)
		require
			string_not_void: string /= void
		do
			error_list.extend (string)
		ensure
			error_added: error_list.count = old error_list.count + 1
		end

feature -- errors for portfolio

	error_no_inv_history
		do
			error_list.extend ("Error! No investment history found.%N")
		ensure
			error_added: error_list.count = old error_list.count + 1
		end

	error_one_inv
		do
			error_list.extend ("Error! Only found one valid investment entry. Need at least two.%N")
		ensure
			error_added: error_list.count = old error_list.count + 1
		end

	error_statement (statement: STRING; line_num: INTEGER_32)
		do
			error_list.extend ("Warning! the statment at line " + line_num.out + statement + "This statement will be ignored in ROI calculation.%N")
		ensure
			error_added: error_list.count = old error_list.count + 1
		end

feature -- errors for TWR and precise

	twr_no_sol
		do
			if not twr_no_sol_found then
				error_list.extend ("TWR will not proceed because there is zero market and cash flow value.%N")
				twr_no_sol_found := true
			end
		ensure
			error_added: error_list.count = old error_list.count + 1
		end

feature -- get errors from list

	item alias "[]" (i: INTEGER_32): STRING
		do
			Result := create {STRING}.make_from_string (error_list [i])
		end

	size: INTEGER_32
		do
			Result := error_list.count
		end

feature

	print_errors
		do
			if not error_list.is_empty then
				across
					error_list as c
				loop
					io.put_string (c.item);
					io.put_new_line
				end
			else
				print ("no errors")
				io.new_line
			end
		end

	flush
		do
			error_list.wipe_out
		end

feature {NONE} -- add error

	error_list: LIST [STRING]

	twr_no_sol_found: BOOLEAN

invariant
	list_not_void: error_list /= void

end
