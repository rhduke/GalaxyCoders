note
	description: "Summary description for {SHARED_CLASSES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class
	SHARED_CLASSES
inherit
ANY

feature
	init_error : ERROR_TYPE
	once ("PROCESS")
		create result.make
	end

	init_file_read : READ_FILE
	once ("PROCESS")
		create result.make
	end
invariant
	init_error = init_error
	init_file_read = init_file_read


end
