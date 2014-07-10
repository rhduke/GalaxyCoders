note
	description : "test-array application root class"
	date        : "$DATE"
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
			add_test (create {TEST_CSV_USE}.make)
			add_test (create {TEST_ROW}.make)
			add_test (create {TEST_CSV_PARSER}.make)
			show_browser
			run_espec
		end



end
