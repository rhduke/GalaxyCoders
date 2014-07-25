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
		end

feature

	count: INTEGER
		do
			Result := tr.count
		ensure
			Result = tr.count
		end

	dates: LIST [PF_DATE]
		do
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

	duration: REAL_64
		do
			Result := (end_date.getValue.days - start_date.getValue.days) / (365.2422)
		ensure
			Result = create {REAL_64}.make_from_reference ((end_date.getValue.days - start_date.getValue.days) / (365.2422))
		end

	di (d: PF_DATE): INTEGER
		require
			dates.has (d)
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
	twr ( a_start , a_end : PF_DATE) : REAL_64

		require
			a_start_is_date_domain : dates.has(a_start)
			a_end_is_date_domain :dates.has(a_end)
			a_end_is_after_a_start : a_end.getvalue.is_greater (a_start.getvalue)
			across 2 |..| count  as i all tr[i.item-1].mv.getvalue + tr[i.item-1].cf.getvalue /= 0   end
	do
		Result := product_of_wealth(di(a_start),di(a_end))-1

		ensure
--			across di(a_start) |..| di(a_end) as i all  result.getvalue. = i.item     end
			Result= product_of_wealth(di(a_start),di(a_end)) - 1
	end
	compounded_twr : REAL_64
	do
		ensure
			Result = twr(start_date,end_date)
	end

	anual_compounded_twr : REAL_64
	do

		Result := exponent((1+ compounded_twr) , (1/duration))-1

		ensure
			(duration >= 1) implies Result = exponent ( (1 + compounded_twr) , (1/duration)) - 1
			(duration < 1) implies Result = compounded_twr
	end

feature
	wealth ( i : INTEGER) : REAL_64
	require
		across 2 |..| count as j some i = j.item end
	do
		Result := tr[i].mv.getvalue / (tr[i-1].mv.getvalue + tr[i-1].cf.getvalue + tr[i-1].af.getvalue)
		ensure
			Result = create {REAL_64}.make_from_reference (tr[i].mv.getvalue / (tr[i-1].mv.getvalue + tr[i-1].cf.getvalue + tr[i-1].af.getvalue))
	end

	product_of_wealth ( i , j : INTEGER) : REAL_64
	require
			across 2 |..| count as c some i = c.item end
			across 2 |..| count as c some j = c.item end
	do
		create result.make_from_reference (0.0)
		across i |..| j  as c loop Result := Result * wealth(c.item)  end

	end
	exponent ( value , power : REAL_64) : REAL_64
	do
		Result := value.power (power)

	ensure
		Result  ~ value.power (power)

	end

feature --class variables

	tr: LIST [TUPLE [date: PF_DATE; mv: PF_MARKETVALUE; cf: PF_CASHFLOW; af: PF_AGENTFEE]]
invariant
	metadata_evaluation_period_is_in_range_and_valid:
	start_date.getvalue.is_less (end_date.getvalue) and dates.has (start_date) and dates.has (end_date)

	every_row_has_a_date_and_a_non_negative_market_value:
	across tr as t  all t.item.date /= void and t.item.mv.getvalue >= 0  end

	 dates_are_unique_and_ordered:
	 across 2 |..| count  as i all tr[i.item].date.getvalue.is_greater (tr[i.item-1].date.getvalue) end

	 Cannot_withdraw_more_than_the_market_value :
	 across tr as t all t.item.mv.getvalue +t.item.cf.getvalue  >= 0  end

	  account_cannot_grow_from_zero_market_value_and_cash_flow :
	  	 across 2 |..| count  as i all tr[i.item-1].mv.getvalue = 0 and tr[i.item-1].cf.getvalue =0 implies tr[i.item].mv.getvalue = 0  end




end
