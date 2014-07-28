note
	description: "Summary description for {TEST_TWR_CALCULATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_TWR_CALCULATION
inherit
	ES_TEST
create
	make

feature -- Constructor
	make
		do
			create flush.make
			add_boolean_case (agent t1)
			add_boolean_case (agent t2)
			add_boolean_case (agent t3)
		end

feature -- Data Storage
	sh_classes : SHARED_CLASSES
	flush : FLUSH_SHARED
	inv_hist: PORTFOLIO_DATA

feature -- Globals
	csv_doc: CSV_DOCUMENT
	csv_cursor: CSV_DOC_ITERATION_CURSOR

feature -- parse data
	parsedata
		local
			parse : PARSING_CONTEXT
		do
			create csv_doc.make_from_file_name ("rio/csv-inputs/new_ac2.csv")
			inv_hist := sh_classes.init_portfolio_data
			create parse.make
			parse.setparsingstrategy (create {PARSE_DATA}.make)
			from
				csv_cursor := csv_doc.new_cursor
			until
				csv_cursor.after
			loop
				parse.getrowinfo (csv_cursor.item)
				csv_cursor.forth
			end
		end


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
			twr : TWR_CALCULATION
			soln : TUPLE[s: REAL_64; f : BOOLEAN]
			soln2 : REAL_64
		do
			comment ("t1: checks the wealths are 1.05, 1.08, 1.31852 and the product of wealth is 1.4952")
			flush.flushall
			parsedata

			create twr.make

			-- check wealth method
			soln := twr.wealth (2)
			Result := almost_equal(soln.s, 1.05)
			check Result end
			soln := twr.wealth (3)
			Result := almost_equal(soln.s, 1.08)
			check Result end
			soln := twr.wealth (4)
			Result := almost_equal(soln.s,1.31852)
			check Result end

			-- check product_of_wealth method
			soln2 := twr.product_of_wealth (2, 4)
			Result := almost_equal(soln2,1.4952)
			check Result end
		end

	t2 : BOOLEAN
		local
			twr : TWR_CALCULATION
			soln : REAL_64
		do
			comment ("t2: checks the compounded TWR is 0.4952")
			flush.flushall
			parsedata
			create twr.make
			soln := twr.compounded_twr
			Result := almost_equal(soln,0.4952)
			check Result end
		end

	t3 : BOOLEAN
		local
			twr : TWR_CALCULATION
			soln : REAL_64
		do
			comment ("t3: checks the compounded Annual TWR is 0.22245")
			flush.flushall
			parsedata
			create twr.make
			soln := twr.anual_compounded_twr
			Result := almost_equal(soln,0.22245)
			check Result end

		end
end
