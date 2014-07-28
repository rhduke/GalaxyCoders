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
			create flush.make
			add_boolean_case (agent t1)
		end

feature -- Data Storage
	sh_classes : SHARED_CLASSES
	inv_hist: PORTFOLIO_DATA
	flush : FLUSH_SHARED

feature -- Globals
	csv_doc: CSV_DOCUMENT
	csv_cursor: CSV_DOC_ITERATION_CURSOR

feature -- parse data
	parsedata
		local
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
			soln : TUPLE[s:REAL_64; f:BOOLEAN]
		do
			comment ("t1: check precise roi is 22.751")
			flush.flushall
			parsedata
			create precise.make
			soln := precise.anual_precise
			Result := almost_equal (soln.s, 22.751)
		end
end
