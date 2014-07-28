note
	description: "Summary description for {TEST_VALIDITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_VALIDITY
inherit
	ES_TEST
create
	make

feature -- Constructor
	make
		do
			create flush.make
			add_boolean_case (agent empty)
			add_boolean_case (agent one_inv)
			add_boolean_case (agent neg_mk)
			add_boolean_case (agent one_inv_rem)
			add_boolean_case (agent date_order)
			add_boolean_case (agent same_date)
		end

feature -- Data Storage
	sh_classes : SHARED_CLASSES
	flush : FLUSH_SHARED
	inv_hist: PORTFOLIO_DATA
	err : ERROR_TYPE

feature -- Globals
	csv_doc: CSV_DOCUMENT
	csv_cursor: CSV_DOC_ITERATION_CURSOR

feature -- parse data
	parsedata(path : STRING_32)
		local
			parse : PARSING_CONTEXT
		do
			create csv_doc.make_from_file_name (path)
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

	empty : BOOLEAN
		local
			i : INTEGER_32
			s : STRING
		do
			comment("check empty_file.csv")
			flush.flushall
			err := sh_classes.init_error
			parsedata("rio/csv-inputs/test-validity/empty_file.csv")
			inv_hist.run_validation

			from
				i := 1
			until
				i > err.size
			loop
				if (err[i] ~ "Error! No investment history found.%N") then
					Result := true
					check Result end
				end
				i := i + 1
			end

		end

	one_inv : BOOLEAN
		local
			i : INTEGER_32
			s : STRING
		do
			comment("check one_inv.csv has only one investment entry")
			flush.flushall
			err := sh_classes.init_error
			parsedata("rio/csv-inputs/test-validity/one_inv.csv")
			inv_hist.run_validation

			from
				i := 1
			until
				i > err.size
			loop
				if (err[i] ~ "Error! Only found one valid investment entry. Need at least two.%N") then
					Result := true
					check Result end
				end
				i := i + 1
			end
		end

	neg_mk : BOOLEAN
		local
			i : INTEGER_32
			s : STRING
		do
			comment("check neg_mv.csv has a negative market value")
			flush.flushall
			err := sh_classes.init_error
			parsedata("rio/csv-inputs/test-validity/neg_mv.csv")
			inv_hist.run_validation
			from
				i := 1
			until
				i > err.size
			loop
				if (err[i] ~ "Warning! the statment at line 10 has market value that is negative. This statement will be ignored in ROI calculation.%N") then
					Result := true
					check Result end
				end
				i := i + 1
			end
		end

	one_inv_rem : BOOLEAN
		local
			i : INTEGER_32
			s : STRING
			f1, f2: BOOLEAN
		do
			comment("check one_inv(with_remove).csv has one investment after removal of invalid investment")
			flush.flushall
			err := sh_classes.init_error
			parsedata("rio/csv-inputs/test-validity/one_inv(with_remove).csv")
			inv_hist.run_validation
			from
				i := 1
			until
				i > err.size
			loop
				if (err[i] ~ "Error! Only found one valid investment entry. Need at least two.%N") then
					f1 := true
				elseif (err[i] ~ "Warning! the statment at line 11 has market value that is negative. This statement will be ignored in ROI calculation.%N") then
					f2 := true
				end
				i := i + 1
			end
			Result := f1 and f2
		end


	date_order : BOOLEAN
		local
			i : INTEGER_32
			s : STRING
		do
			comment("check date_order.csv has dates out of order")
			flush.flushall
			err := sh_classes.init_error
			parsedata("rio/csv-inputs/test-validity/date_order.csv")
			inv_hist.run_validation
--			err.print_errors
			from
				i := 1
			until
				i > err.size
			loop
				if (err[i] ~ "Warning! the statment at line 12 has date that's earlier than or equal to previous statements. Dates must be in increasing order and unique. This statement will be ignored in ROI calculation.%N") then
					Result := true
					check Result end
				end
				i := i + 1
			end
		end

	same_date : BOOLEAN
		local
			i : INTEGER_32
			s : STRING
			f1,f2 : BOOLEAN
		do
			comment("check same_date.csv has same dates")
			flush.flushall
			err := sh_classes.init_error
			parsedata("rio/csv-inputs/test-validity/same_date.csv")
			inv_hist.run_validation
			err.print_errors
			from
				i := 1
			until
				i > err.size
			loop
				if (err[i] ~ "Warning! the statment at line 12 has date that's earlier than or equal to previous statements. Dates must be in increasing order and unique. This statement will be ignored in ROI calculation.%N") then
					f1 := true
				elseif (err[i] ~ "Warning! the statment at line 13 has date that's earlier than or equal to previous statements. Dates must be in increasing order and unique. This statement will be ignored in ROI calculation.%N") then
					f2 := true
				end
				i := i + 1
			end
			Result := f1 and f2
		end
end
