note
	description: "rio application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit

	ES_SUITE

create
	make

feature {NONE} -- Initialization

	make
			-- Run application. -- Tessssst
		local
			exe: EXECUTE
			enable_test: BOOLEAN
		do
			enable_test := true
			if enable_test then
				add_test (create {ACCEPTANCE_SET1}.make)
				add_test (create {ACCEPTANCE_SET2}.make)
				add_test (create {ACCEPTANCE_SET3}.make)
				add_test (create {TEST_VALIDITY}.make)
				add_test (create {TEST_TWR_CALCULATION}.make)
				add_test (create {TEST_PRECISE_CALCULATION}.make)
				add_test (create {TEST_POLYNOMIAL}.make)
				add_test (create {TEST_PORTFOLIO_DATA}.make)
				add_test (create {TEST_PARSING}.make)
				add_test (create {TEST_ROOTS}.make)
				add_test (create {TEST_CSV_USE}.make)
				add_test (create {TEST_ROW}.make)
				add_test (create {TEST_CSV_PARSER}.make)
				show_errors
				show_browser
				run_espec
			else
				create exe.make
			end
		end

end
