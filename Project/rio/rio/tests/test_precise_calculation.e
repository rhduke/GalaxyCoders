note
	description: "Summary description for {TEST_PRECISE_CALCULATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_PRECISE_CALCULATION
inherit
	ES_TEST
create
	make

feature -- Constructor
	make
		do
			parsedata
			add_boolean_case (agent t1)
		end

feature -- Data Storage
	sh_classes : SHARED_CLASSES

feature -- Globals
	csv_doc: CSV_DOCUMENT
	csv_cursor: CSV_DOC_ITERATION_CURSOR

feature -- parse data
	parsedata
		local
			inv_hist: PORTFOLIO_DATA
			parse : PARSING_CONTEXT
		do
			create csv_doc.make_from_file_name ("rio/csv-inputs/new_ac1.csv")
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
			precise : PRECISE_CALCULATION
			soln : REAL_64
		do
			comment ("t1: check precise roi is 22.751")
			create precise.make
			soln := precise.anual_precise
			Result := almost_equal (soln, 22.751)
		end
end
