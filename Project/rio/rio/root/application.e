note
	description : "rio application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	ES_SUITE

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			add_test (create {TEST_ROOTS}.make)
			add_test (create {TEST_CSV_USE}.make)
			add_test (create {TEST_ROW}.make)
			add_test (create {TEST_CSV_PARSER}.make)
			show_errors
			show_browser
			run_espec
		end

end
