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
 --lolll

	make
			-- Run application. -- Tessssst
		local
			err : TEST_ERROR_TYPE
		do
			create err.make("rio/csv-inputs/roi-test1.csv")
--			add_test (create {TEST_ROOTS}.make)
--			add_test (create {TEST_CSV_USE}.make)
--			add_test (create {TEST_ROW}.make)
--			add_test (create {TEST_CSV_PARSER}.make)
--			show_errors
--			show_browser
--			run_espec
		end

end
