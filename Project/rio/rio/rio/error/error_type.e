note
	description: "Summary description for {ERROR_TYPE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ERROR_TYPE
create
	make

feature -- initialize
	make
	local
		err_list : LINKED_LIST[STRING]

	  do
		create err_list.make
	  	check err_list.is_empty end
	  	error_list := err_list
	 end
feature -- Error types
	name_error ( line_number : INTEGER_32)
		require
			line_num_pos: line_number >=1
		do
		 	error_list.extend("Error!. Name was not found on the " + line_number.out + " . Check the input file")
		ensure
			error_added : error_list.count = old error_list.count + 1
		end

feature --  arbitrary data errors

		description_error ( line_number: INTEGER_32)
			require
				line_num_pos: line_number >=1
			do
				error_list.extend("Error!.The line " + line_number.out + " is not valid description.")
			ensure
				error_added : error_list.count = old error_list.count + 1
			end

		accout_num_error ( line_num : INTEGER_32)
			require
				line_num_pos: line_num >=1
			do
				error_list.extend("Error!. The line " + line_num.out + " is not valid  account number.")
			ensure
				error_added : error_list.count = old error_list.count + 1
			end

		email_error ( line_num : INTEGER_32)
			require
				line_num_pos: line_num >=1
			do
				error_list.extend("Error!. The line " + line_num.out + " is not valid email.")
			ensure
				error_added : error_list.count = old error_list.count + 1
			end

		address_error ( line_num : INTEGER_32)
			require
				line_num_pos: line_num >=1
			do
				error_list.extend("Error!. The line "+ line_num.out + " is valid adress. ")
			ensure
				error_added : error_list.count = old error_list.count + 1
			end

		phone_num_error ( line_num : INTEGER_32)
			require
				line_num_pos: line_num >=1
			do
				error_list.extend("Error!. The line" + line_num.out + " is not valid phone number.")
			ensure
				error_added : error_list.count = old error_list.count + 1
			end
feature
	print_errors
		require
			list_not_void : error_list /= void
		do

			across error_list as c  loop io.put_string (c.item)  end
		end

feature -- add error

	error_list : LIST[STRING]

invariant
 list_not_void : error_list /= void

end
