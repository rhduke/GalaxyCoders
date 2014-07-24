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
	end

feature
	parseRow (row : ROW)
			local
				row_temp : ROW
				market_value : PF_MARKETVALUE
				cash_flow : PF_CASHFLOW
			    agent_fee : PF_AGENTFEE
				bench_mark : PF_BENCHMARK
				trans_date: PF_DATE
				invest : INVESTMENT

			do
				row_temp := row

		   if row_temp[1].is_date and (row_temp [2].is_double or row_temp [2] ~ "") --b
		      	        and (row_temp [3].is_float or row_temp [3].out ~ "") -- cf
						and (row_temp [4].is_float or row_temp [4].out ~ "") -- af
						and (row_temp [5].is_percentage or row_temp [5].out ~ "") -- bm
						and row_temp.is_empty_from (6)
		      	then
		      		create trans_date.make(row_temp[1].as_date)

                    if row_temp[2].is_float then
		      			create market_value.make(row_temp[2].as_float)
		      		else
		      			create market_value.make(0.0)
		      		end  --1

		      		if row_temp[3].is_float then
		      			create cash_flow.make(row_temp[3].as_float)
		      		else
		      			create cash_flow.make(0.0)
		      		end --2

		      		if row_temp[4].is_float then
		      			create agent_fee.make(row_temp[4].as_float)
		      		else
		      			create agent_fee.make(0.0)
		      		end --3

		      		if row_temp[5].is_percentage then
		      			create bench_mark.make(row_temp[5].as_percentage)
		      		else
		      			create bench_mark.make(0.0)
		      		end --4

		      		obtained_data := true

		      		create invest.make ([trans_date,market_value,cash_flow,agent_fee,bench_mark])


     else
             error.custom_msg ("Row number " + row_temp.number.out
                 + ": is invalid.")
         end --b

end --parse

	is_successfully_obtain_data : BOOLEAN
			-- did we obtain the data ?
	do
		result := obtained_data
	end

	detect_error
			-- detect errors and call error class
	do

    end

feature {NONE} -- global variable
	sh_classes : SHARED_CLASSES
	error : ERROR_TYPE
	obtained_data : BOOLEAN

end



