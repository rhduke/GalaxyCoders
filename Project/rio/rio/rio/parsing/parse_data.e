note
	description: "Summary description for {PARSE_DATA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PARSE_DATA

inherit

	PARSING_STRATEGY

create
	make

feature {NONE}

	make
		do
			error := sh_classes.init_error
			obtained_data := false
			inv_history := sh_classes.init_portfolio_data
		end

feature

	parseRow (row: ROW)
		local
			row_temp: ROW
			market_value: PF_MARKETVALUE
			cash_flow: PF_CASHFLOW
			agent_fee: PF_AGENTFEE
			bench_mark: PF_BENCHMARK
			trans_date: PF_DATE
			invest: INVESTMENT
		do
			row_temp := row
			if row_temp [1].is_date then
			--	print ("d1%N")
				if row_temp [1].is_date and (row_temp [2].is_double or row_temp [2] ~ "") --b
					and (row_temp [3].is_float or row_temp [3].out ~ "") -- cf
					and (row_temp [4].is_float or row_temp [4].out ~ "") -- af
					and (row_temp [5].is_percentage or row_temp [5].out ~ "") -- bm

				then
				--	print ("d2%N")
					create trans_date.make (row_temp [1].as_date)
					if row_temp [2].is_float then
				--		print ("d31%N")
						create market_value.make (row_temp [2].as_float)
					else
				--		print ("d32%N")
						create market_value.make_not_exist
					end --1

					if row_temp [3].is_float then
				--		print ("d41%N")
						create cash_flow.make (row_temp [3].as_float)
					else
				--		print ("d42%N")
						create cash_flow.make_not_exist
					end --2

					if row_temp [4].is_float then
				--		print ("d51%N")
						create agent_fee.make (row_temp [4].as_float)
					else
				--		print ("d52%N")
						create agent_fee.make_not_exist
					end --3

					if row_temp [5].is_percentage then
				--		print ("d61%N")
						create bench_mark.make (row_temp [5].as_percentage)
					else
				--		print ("d62%N")
						create bench_mark.make_not_exist
					end --4

				--	print ("d7%N")
					create invest.make ([trans_date, market_value, cash_flow, agent_fee, bench_mark])
				--	print ("d8%N")
					inv_history.add (invest)
				--	print ("d9%N")
				else
				--	print ("d10%N")
					error.custom_msg ("Row number " + row_temp.number.out + ": is invalid.")
				end --b

--                elseif row_temp.is_empty then
--					print("empty%N")
--				else

--					print("Row number " + row_temp.number.out
--                   			+ ": a data item row should have a date as its first field." + "%N")
			end
		end --parse

	is_successfully_obtain_data: BOOLEAN
			-- did we obtain the data ?
		do
			result := obtained_data
		end

	detect_error
			-- detect errors and call error class
		do
		end

feature {NONE} -- global variable

	sh_classes: SHARED_CLASSES

	error: ERROR_TYPE

	inv_history: PORTFOLIO_DATA

	obtained_data: BOOLEAN

end
