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
			error := sh_classes.init_error
		end

feature -- getters and adders

	add (inv: INVESTMENT; line_num: INTEGER_32)
		do
			invest_history.force (inv)
			line_numbers.extend (line_num)
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

	is_valid_portfolio: BOOLEAN
		do
			Result := statements_size >= 2 and across 1 |..| statements_size as i all invest_history [i.item].mv.getvalue >= 0 end and
			across 2 |..| statements_size as i all invest_history [i.item].date.getvalue.is_greater (invest_history [i.item - 1].date.getvalue) end and
			across 2 |..| statements_size as i all invest_history [i.item - 1].mv.getvalue = 0 and
			invest_history [i.item - 1].cf.getvalue = 0 implies invest_history [i.item].mv.getvalue = 0 end and
			across 2 |..| statements_size as i all invest_history [i.item].mv.getvalue + invest_history [i.item].cf.getvalue >= 0 end
		ensure
			Result = (statements_size >= 2)
		end

feature {NONE} -- checking validity of data

	row_has_non_negative_mk
			-- checks , fix and report if row has
			--negative market value
		do
			if statements_size > 0 then
				across
					1 |..| statements_size as i
				loop
					if invest_history [i.item].mv.getvalue < 0 then
						error.statement_error ("has market value that is negative. ", line_numbers.array_at (i.item))
						remove_investment_line (i.item)
					end
				end
			end
		end

	dates_uniq_ordered
			-- checks , fix and report if dates are uniqe and ordered
			-- if not then it attempts to delete the row that has invalid date
		do
			if statements_size >= 2 then
				across
					2 |..| statements_size as i
				loop
					if not invest_history [i.item].date.getvalue.is_greater (invest_history [i.item - 1].date.getvalue) then
						error.statement_error ("has date that earlier than previous statements ", line_numbers.array_at (i.item))
						remove_investment_line (i.item)
					end
				end
			end
		end

	no_grow_from_zero
			-- checks , fix and report if market has grown from previous
			-- zero cash flow and market value
		do
			if statements_size >= 2 then
				across
					2 |..| statements_size as i
				loop
					if invest_history [i.item].mv.getvalue > 0 and invest_history [i.item - 1].mv.getvalue = 0 and invest_history [i.item - 1].cf.getvalue = 0 then
						error.statement_error ("has grown market value from previous zero cash flow and market value. ", line_numbers.array_at (i.item))
						remove_investment_line (i.item)
					end
				end
			end
		end

	cant_withdraw_more_market_value
			-- checks , fix and report if cash flow
			-- withdraw more than  its current market value
		do
			if statements_size >= 2 then
				across
					2 |..| statements_size as i
				loop
					if invest_history [i.item].mv.getvalue + invest_history [i.item].cf.getvalue < 0 then
						error.statement_error ("has amount of cash flow greater than its current value. ", line_numbers.array_at (i.item))
						remove_investment_line (i.item)
					end
				end
			end
		end

feature {NONE}

	remove_investment_line (i: INTEGER_32)
		require
			index_bounded: across getList.lower |..| getList.upper as j some i = j.item end
		do
			across
				i |..| (statements_size - 1) as index
			loop
				invest_history [index.item] := invest_history [index.item + 1]
			end
			invest_history.resize (statements_size - 1)
		ensure
			less_statments: invest_history.capacity = old invest_history.capacity - 1
		end

	run_validation
			-- run the routines that checks the data
		local
			commands: ARRAYED_LIST [PROCEDURE [ANY, TUPLE]]
		do
			commands.extend (agent row_has_non_negative_mk)
			commands.extend (agent dates_uniq_ordered)
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

feature {PORTFOLIO_DATA} -- implementation

	invest_history: ARRAYED_LIST [INVESTMENT]

	line_numbers: ARRAYED_LIST [INTEGER_32]

	sh_classes: SHARED_CLASSES

	error: ERROR_TYPE

end
