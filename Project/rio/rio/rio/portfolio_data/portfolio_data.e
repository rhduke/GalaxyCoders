note
	description: "Summary description for {PORTFOLIO_DATA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

frozen class
	PORTFOLIO_DATA

create {SHARED_CLASSES}
	make_empty

feature {NONE} -- constructor

	make_empty
		do
			create invest_history.make (0)
			create line_numbers.make (0)
			create eval_pr.make_not_exist
			error := sh_classes.init_error
		end

feature -- getters and adders

	add (inv: INVESTMENT; line_num: INTEGER_32)
		do
			invest_history.force (inv)
			line_numbers.extend (line_num)
		end

	add_eval_pr ( eval_per : PF_EVAL_PER)
	require
			not_void : eval_per /= void
	do
		eval_pr  := eval_per
	end

	item alias "[]" (i: INTEGER_32): INVESTMENT
		require
			index_bounded: across getList.lower |..| getList.upper as j some i = j.item end
		do
			Result := invest_history [i]
		ensure
			contain_pt_data: getList.has (result)
		end

	getList: ARRAYED_LIST [INVESTMENT]
		do
			Result := invest_history.twin
		end

	get_eval_per : PF_EVAL_PER
		do
			Result := eval_pr
		end

	get_pt_line_num ( i :INTEGER_32) : INTEGER_32
		-- return the line number at which that portfolio statement located in the document is located
	do
		Result := line_numbers[i]
	ensure
		Result = line_numbers[i]
	end

	flush
		do
			invest_history.wipe_out
			line_numbers.wipe_out
			eval_pr := void
		end

	run_validation
			-- run the routines that checks the data
		local
			commands: ARRAYED_LIST [PROCEDURE [ANY, TUPLE]]
		do
			create commands.make (0)
			commands.extend (agent inv_history_not_empty)
			commands.extend (agent has_at_least_two_investments)
			commands.extend (agent row_has_non_negative_mk)
			commands.extend (agent dates_uniq_order)
			commands.extend (agent no_grow_from_zero)
			commands.extend (agent cant_withdraw_more_market_value)
			from
				commands.start
			until
				commands.after
			loop
				commands.item.call ([])
				commands.forth
			end
		end

	is_valid_portfolio: BOOLEAN
		do
			Result := statements_size >= 2 and across 1 |..| statements_size as i all invest_history [i.item].mv.getvalue >= 0 end and
			across 2 |..| statements_size as i all invest_history [i.item].date.getvalue.is_greater (invest_history [i.item - 1].date.getvalue) end and
			across 2 |..| statements_size as i all invest_history [i.item - 1].mv.getvalue = 0 and
			invest_history [i.item - 1].cf.getvalue = 0 implies invest_history [i.item].mv.getvalue = 0 end and
			across 2 |..| statements_size as i all invest_history [i.item].mv.getvalue + invest_history [i.item].cf.getvalue >= 0 end
		ensure
			Result = (statements_size >= 2) and across 1 |..| statements_size as i all invest_history [i.item].mv.getvalue >= 0 end and
					across 2 |..| statements_size as i all invest_history [i.item].date.getvalue.is_greater (invest_history [i.item - 1].date.getvalue) end and
					across 2 |..| statements_size as i all invest_history [i.item - 1].mv.getvalue = 0 and
					invest_history [i.item - 1].cf.getvalue = 0 implies invest_history [i.item].mv.getvalue = 0 end and
					across 2 |..| statements_size as i all invest_history [i.item].mv.getvalue + invest_history [i.item].cf.getvalue >= 0 end
		end


	is_eval_per_in_range : BOOLEAN
	do
		Result := across  1 |..| statements_size as i some invest_history [i.item].date.getvalue.is_equal (eval_pr.getvalue.x) end and
		across  1 |..| statements_size as i some invest_history [i.item].date.getvalue.is_equal (eval_pr.getvalue.y) end and
		is_valid_portfolio
	ensure
		Result = ((across  1 |..| statements_size as i some invest_history [i.item].date.getvalue.is_equal (eval_pr.getvalue.x) end) and
		(across  1 |..| statements_size as i some invest_history [i.item].date.getvalue.is_equal (eval_pr.getvalue.y) end) and
		(is_valid_portfolio))
	end

feature {NONE} -- checking validity of data

	inv_history_not_empty
			-- checks if there's any data
		do
			if statements_size = 0 then
				error.error_no_inv_history
			end
		end

	has_at_least_two_investments
			-- checks if there's at least two rows of investments
		do
			if statements_size = 1 then
				error.error_one_inv
			end
		end

	row_has_non_negative_mk
			-- checks , fix and report if row has
			--negative market value
		local
			i : INTEGER_32
		do
			if statements_size > 0 then
				from
					i := 1
				invariant
					i >= 1
					i <= statements_size + 1
				until
					i > statements_size
				loop
					if invest_history [i].mv.getvalue < 0 then
						error.error_statement (" has market value that is negative. ", line_numbers[i])
						remove_investment_line (i)
						has_at_least_two_investments
					else
						i := i + 1
					end
				variant
					statements_size + 1 - i
				end
			end
		end

	dates_uniq_order
			-- checks , fix and report if dates are ordered and unique
			-- if not then it attempts to delete the row that has invalid date
		local
			i : INTEGER_32
		do

			if statements_size >= 2 then
				from
					i := 2
				invariant
					i >= 1
					i <= statements_size + 1
				until
					i > statements_size
				loop
					if not invest_history [i].date.getvalue.is_greater (invest_history [i- 1].date.getvalue) then
						error.error_statement (" has date that's earlier than or equal to previous statements. Dates must be in increasing order and unique. ", line_numbers[i.item])
						remove_investment_line (i)
						has_at_least_two_investments
					else
						i := i + 1
					end
				variant
					statements_size + 1 - i
				end

			end
		end

	no_grow_from_zero
			-- checks , fix and report if market has grown from previous
			-- zero cash flow and market value
		local
			i : INTEGER_32
		do
			if statements_size >= 2 then
				from
					i := 2
				invariant
					i >= 1
					i <= statements_size + 1
				until
					i > statements_size
				loop
					if invest_history [i].mv.getvalue /= 0 and ( invest_history [i - 1].mv.getvalue + invest_history [i - 1].cf.getvalue = 0) then
						error.error_statement (" has grown market value from previous zero cash flow and market value. ", line_numbers[i])
						remove_investment_line (i-1)
						has_at_least_two_investments
					else
						i := i + 1
					end
				variant
					statements_size + 1 - i
				end
			end
		end

	cant_withdraw_more_market_value
			-- checks , fix and report if cash flow
			-- withdraw more than  its current market value
		local
			i : INTEGER_32
		do
			if statements_size >= 2 then
				from
					i := 2
				invariant
					i >= 1
					i <= statements_size + 1
				until
					i > statements_size
				loop
					if (invest_history [i].mv.getvalue + invest_history [i].cf.getvalue - invest_history[i].af.getvalue) < 0 then
						error.error_statement (" has amount of cash flow greater than its current value. ", line_numbers[i])
						remove_investment_line (i)
						has_at_least_two_investments
					else
						i := i + 1
					end
				variant
					statements_size + 1 - i
				end
			end
		end

feature {NONE}

	remove_investment_line (i: INTEGER_32)
		require
			index_bounded: across getList.lower |..| getList.upper as j some i = j.item end
		local
			temp : ARRAYED_LIST[INVESTMENT]
			templine : ARRAYED_LIST [INTEGER_32]
			k : INTEGER_32
		do
			create temp.make (0)
			create templine.make (0)
			from
				k := 1
			until
				k > (statements_size)
			loop
				if (k /= i) then
					temp.extend (invest_history[k])
					templine.extend (line_numbers[k])
				end
				k := k + 1
			end
			invest_history.copy (temp)
			line_numbers.copy (templine)
		ensure
			less_statments: invest_history.count = old invest_history.count - 1
			less_linenum: line_numbers.count = old line_numbers.count - 1
		end



feature

	printOut
		do
			across
				invest_history as iv
			loop
				io.put_string ("[ " + iv.item.date.getvalue.out + ", ")
				io.put_string (iv.item.mv.getvalue.out + ", ")
				io.put_string (iv.item.cf.getvalue.out + ", ")
				io.put_string (iv.item.af.getvalue.out + ", ")
				io.put_string (iv.item.bm.getvalue.out + " ]%N")
			end
		end

	statements_size: INTEGER_32
			-- return how many statment we have currently
		do
			Result := invest_history.upper
		ensure
			Result = invest_history.upper
		end

feature {NONE} -- implementation

	invest_history: ARRAYED_LIST [INVESTMENT]

	line_numbers: ARRAYED_LIST [INTEGER_32]

	sh_classes: SHARED_CLASSES

	error: ERROR_TYPE

	eval_pr : PF_EVAL_PER

end
