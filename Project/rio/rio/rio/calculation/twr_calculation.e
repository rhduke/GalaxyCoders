note
	description: "Summary description for {TWR_CALCULATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TWR_CALCULATION

create
	make

feature

	make
		do
			inv_history := sh_classes.init_portfolio_data
			tr := inv_history.getlist
		end

feature

	count: INTEGER
		do
			Result := tr.count
		ensure
			Result = tr.count
		end

	dates: ARRAYED_LIST [PF_DATE]
		do
			create Result.make (0)
			across
				tr as c
			loop
				Result.extend (c.item.date)
			end
		end

	start_date: PF_DATE
		do
			Result := tr [1].date
		ensure
			Result = tr [1].date
		end

	end_date: PF_DATE
		do
			Result := tr [tr.count].date
		ensure
			Result = tr [tr.count].date
		end

	duration (a_start, a_end: PF_DATE): REAL_64
		do
			Result := (a_end.getValue.days - a_start.getValue.days) / (365.2422)
		ensure
			Result = ((a_end.getValue.days - a_start.getValue.days) / (365.2422))
		end

	di (d: PF_DATE): INTEGER
		require
			across dates as h some h.item.getValue.is_equal (d.getValue) end
		do
			across
				1 |..| count as i
			loop
				if tr [i.item].date.getvalue ~ d.getvalue then
					result := i.item
				end
			end --loop

		ensure
			across 1 |..| count as i some Result = i.item end
			tr [Result].date.getvalue ~ d.getvalue
		end

	twr (a_start, a_end: PF_DATE): TUPLE [answer: REAL_64; found: BOOLEAN]
		require
			across dates as h some h.item.getValue.is_equal (a_start.getValue) end
			across dates as h some h.item.getValue.is_equal (a_end.getValue) end
			a_end_is_after_a_start: a_end.getvalue.is_greater (a_start.getvalue)
			--across 2 |..| count as i all tr [i.item - 1].mv.getvalue + tr [i.item - 1].cf.getvalue /= 0 end
		do
			create Result.default_create
			if not product_of_wealth (di (a_start) + 1, di (a_end)).found then
				sh_classes.init_error.twr_no_sol
				Result.answer := product_of_wealth (di (a_start) + 1, di (a_end)).answer - 1
				Result.found := false
			else
				Result.answer := product_of_wealth (di (a_start) + 1, di (a_end)).answer - 1
				Result.found := true
			end
		ensure
			Result.answer = product_of_wealth (di (a_start) + 1, di (a_end)).answer - 1
			Result.found = product_of_wealth (di (a_start) + 1, di (a_end)).found
		end

	compounded_twr (a_start, a_end: PF_DATE): TUPLE [answer: REAL_64; found: BOOLEAN]
		do
			create Result.default_create
			Result.answer := twr (a_start, a_end).answer
			Result.found := twr (a_start, a_end).found
		ensure
			Result.answer = twr (a_start, a_end).answer
			Result.found = twr (a_start, a_end).found
		end

	anual_compounded_twr (a_start, a_end: PF_DATE): TUPLE [answer: REAL_64; found: BOOLEAN]
		do
			create Result.default_create
			if (duration (a_start, a_end) >= 1) then
				Result.answer := exponent ((1 + compounded_twr (a_start, a_end).answer), (1 / duration (a_start, a_end))) - 1
				Result.found := compounded_twr (a_start, a_end).found
			else
				Result.answer := compounded_twr (a_start, a_end).answer
				Result.found := compounded_twr (a_start, a_end).found
			end
		ensure
			(duration (a_start, a_end) >= 1) implies (Result.answer = exponent ((1 + compounded_twr (a_start, a_end).answer), (1 / duration (a_start, a_end))) - 1) and (Result.found = compounded_twr (a_start, a_end).found)
			(duration (a_start, a_end) < 1) implies (Result.answer = compounded_twr (a_start, a_end).answer) and (Result.found = compounded_twr (a_start, a_end).found)
		end

feature

	wealth (i: INTEGER): TUPLE [answer: REAL_64; found: BOOLEAN]
		require
			across 2 |..| count as j some i = j.item end
		do
			create Result.default_create
			if ((tr [i - 1].mv.getvalue + tr [i - 1].cf.getvalue - tr [i - 1].af.getvalue) = 0) then
				Result.answer := 0
				Result.found := false
			else
				Result.answer := tr [i].mv.getvalue / (tr [i - 1].mv.getvalue + tr [i - 1].cf.getvalue - tr [i - 1].af.getvalue)
				Result.found := true
			end
		ensure
			Result.answer = (tr [i].mv.getvalue / (tr [i - 1].mv.getvalue + tr [i - 1].cf.getvalue - tr [i - 1].af.getvalue)) or Result.answer = 0
		end

	product_of_wealth (i, j: INTEGER): TUPLE [answer: REAL_64; found: BOOLEAN]
		require
			across 2 |..| count as c some i = c.item end
		local
			terminate: BOOLEAN
			index: INTEGER
		do
			create Result.default_create
			Result.answer := 1.0
			terminate := false
			from
				index := i
			invariant
				index >= i
				index <= j + 1
			until
				index > j or terminate
			loop
				if not wealth (index).found then
					Result.answer := Result.answer * 0
					Result.found := false
					terminate := true
				else
					Result.answer := Result.answer * wealth (index).answer
					Result.found := true
				end
				index := index + 1
			variant
				j + 1 - index
			end
		end

	exponent (value, power: REAL_64): REAL_64
		do
			Result := value.power (power)
		ensure
			Result ~ value.power (power)
		end

feature --class variables

	sh_classes: SHARED_CLASSES

	inv_history: PORTFOLIO_DATA

	tr: LIST [INVESTMENT]

invariant
	metadata_evaluation_period_is_in_range_and_valid: start_date.getvalue.is_less (end_date.getvalue) and dates.has (start_date) and dates.has (end_date)
	every_row_has_a_date_and_a_non_negative_market_value: across tr as t all t.item.date /= void and t.item.mv.getvalue >= 0 end
	dates_are_unique_and_ordered: across 2 |..| count as i all tr [i.item].date.getvalue.is_greater (tr [i.item - 1].date.getvalue) end
	Cannot_withdraw_more_than_the_market_value: across tr as t all t.item.mv.getvalue + t.item.cf.getvalue >= 0 end
	account_cannot_grow_from_zero_market_value_and_cash_flow: across 2 |..| count as i all tr [i.item - 1].mv.getvalue = 0 and tr [i.item - 1].cf.getvalue = 0 implies tr [i.item].mv.getvalue = 0 end

end
