note
	description: "Summary description for {PRECISE_CALULATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PRECISE_CALCULATION

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

	duration (given: PF_DATE): REAL_64
		do
			Result := (end_date.getValue.days - given.getValue.days) / (365.2422)
		ensure
			Result = ((end_date.getValue.days - given.getValue.days) / (365.2422))
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

	dates: ARRAYED_LIST [PF_DATE]
		do
			create Result.make (0)
			across
				tr as c
			loop
				Result.force (c.item.date)
			end
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

		end

	precise (a_start, a_end: PF_DATE): TUPLE [answer: REAL_64; found: BOOLEAN]
		require
				--	a_start_is_date_domain: dates.has (a_start)
			across dates as h some h.item.getValue.is_equal (a_start.getValue) end
			across dates as h some h.item.getValue.is_equal (a_end.getValue) end
			a_end_is_after_a_start: a_end.getvalue.is_greater (a_start.getvalue)
		local
			ls: ARRAYED_LIST [TUPLE [REAL_64, REAL_64]]
			c: CALCULATION
			i: INTEGER_32
		do
			create ls.make (di (a_end))
			ls.force ([tr [di (a_start)].mv.getValue, duration (a_start)])
			from
				i := di (a_start) + 1
			until
				i >= di (a_end)
			loop
				ls.force ([(tr [i].cf.getValue - tr [i].af.getValue), duration (tr [i].date)])
				i := i + 1
			end
			ls.force ([((tr [di (a_end)].mv.getValue) * -1), 0.0])
			create c.make (create {POLYNOMIAL_NR}.make_from_list (ls))
			c.calculate
			create Result.default_create
			if c.solution_not_found then
				ls.wipe_out
				Result.answer := -100
				Result.found := false
			else
				Result.answer := (c.solution - 1) * 100
				ls.wipe_out
				Result.found := true
			end
		end

	anual_precise: TUPLE [answer: REAL_64; found: BOOLEAN]
		do
			create Result.default_create
			Result.answer := precise (start_date, end_date).answer
			Result.found := precise (start_date, end_date).found
		end

feature --class variables

	sh_classes: SHARED_CLASSES

	inv_history: PORTFOLIO_DATA

	tr: LIST [INVESTMENT]

end
