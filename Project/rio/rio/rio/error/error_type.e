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
		end

feature --  arbitrary data errors

	name_error
		do
			error_list.extend ("Error!. Name was not found on the first line.%N")
		ensure
			error_added: error_list.count = old error_list.count + 1
		end

	description_error (line_number: INTEGER_32)
		require
			line_num_pos: line_number >= 1
		do
			error_list.extend ("Error!.The line " + line_number.out + " is not valid description.")
		ensure
			error_added: error_list.count = old error_list.count + 1
		end

	accout_num_error (line_num: INTEGER_32)
		require
			line_num_pos: line_num >= 1
		do
			error_list.extend ("Error!. The line " + line_num.out + " is not valid  account number.")
		ensure
			error_added: error_list.count = old error_list.count + 1
		end

	email_error (line_num: INTEGER_32)
		require
			line_num_pos: line_num >= 1
		do
			error_list.extend ("Error!. The line " + line_num.out + " is not valid email.")
		ensure
			error_added: error_list.count = old error_list.count + 1
		end

	address_error (line_num: INTEGER_32)
		require
			line_num_pos: line_num >= 1
		do
			error_list.extend ("Error!. The line " + line_num.out + " is valid address. ")
		ensure
			error_added: error_list.count = old error_list.count + 1
		end

	phone_num_error (line_num: INTEGER_32)
		require
			line_num_pos: line_num >= 1
		do
			error_list.extend ("Error!. The line" + line_num.out + " is not valid phone number.")
		ensure
			error_added: error_list.count = old error_list.count + 1
		end

	custom_msg (string: STRING)
		require
			string_not_void: string /= void
		do
			error_list.extend (string)
		ensure
			error_added: error_list.count = old error_list.count + 1
		end

feature -- errors for portfolio

	two_or_less_stm
		do
			error_list.extend ("ROI calculation can't be done because your "
			+ "portfolio history has less than two statements due to error fixing." +
			"Or you original input file had less than two statements.%N")
		ensure
			error_added: error_list.count = old error_list.count + 1
		end

	statement_error (statement: STRING; line_num: INTEGER_32)
		do
			error_list.extend ("Warning! the statment at line" + line_num.out + statement + ".This statement will be ignored in ROI calculation.%N")
		ensure
			error_added: error_list.count = old error_list.count + 1
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
			end
		end

feature {NONE} -- add error

	error_list: LIST [STRING]

invariant
	list_not_void: error_list /= void

end
