note
	description	: "Tests for CSE3311 Project"
	date: "$Date$"
	revision: "$Revision$"

class
	ROOT
inherit
	ES_SUITE

create
	make

feature -- Initialization

	make
			-- Run application.
		do
			add_test (create {TEST_ROOTS}.make)
			show_errors
			show_browser
			run_espec
		end

end -- class ROOT

