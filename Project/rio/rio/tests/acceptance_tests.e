note
	description: "Summary description for {TEST_TWR_CALCULATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ACCEPTANCE_TESTS
inherit
	ES_TEST
create
	make

feature -- Constructor
	make
		do
			add_boolean_case (agent t1)
		end

feature -- Data Storage
	sh_classes : SHARED_CLASSES

feature -- Globals
	csv_doc: CSV_DOCUMENT
	csv_cursor: CSV_DOC_ITERATION_CURSOR

feature -- Test cases

	tolerance: REAL_64 = 0.001

	almost_equal (x, y: REAL_64): BOOLEAN
		do
			if x ~ 0.0 and y ~ 0.0 then
				Result := True
			else
				Result := (x - y).abs / x.abs.max (y.abs) < tolerance
			end
		end

	t1 : BOOLEAN
		local
			inv_hist: PORTFOLIO_DATA
			parse : PARSING_CONTEXT
			parse_data : PARSE_DATA
			twr : TWR_CALCULATION
		do
			create csv_doc.make_from_file_name ("rio/csv-inputs/new_ac1.csv")
			inv_hist := sh_classes.init_portfolio_data
			create parse.make
			create parse_data.make
			parse.setparsingstrategy (parse_data)
			from
				csv_cursor := csv_doc.new_cursor
			until
				csv_cursor.after
			loop
				parse.getrowinfo (csv_cursor.item)
--				print(csv_cursor.item.out)
--				io.new_line
--				if attached {PF_INVESTMENT} parse.getdata as inv2 then
--					data.add (inv2)
--				end
				csv_cursor.forth
			end
			inv_hist.printout
		end

--	t1 : BOOLEAN
--		local
--			c : CALCULATION
--			ls: ARRAYED_LIST [TUPLE [REAL_64, REAL_64]]
--		do
--			comment ("t1: test root for -1x^2 + 2 is equal to 2")
--			create ls.make_from_array (<< [2.0, 0.0], [-1.0, 2.0] >>)
--			create c.make (create {POLYNOMIAL_NR}.make_from_list (ls))
--			c.calculate
--			check not c.solution_not_found end
--			Result := almost_equal (c.solution * c.solution, 2.0)
--			check Result end
--		end
end
