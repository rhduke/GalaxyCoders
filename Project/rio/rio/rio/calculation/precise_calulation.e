note
	description: "Summary description for {PRECISE_CALULATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PRECISE_CALULATION

create
	make

feature

	make (l: ARRAYED_LIST [TUPLE [PF_DATE, PF_MARKETVALUE, PF_CASHFLOW, PF_AGENTFEE]])
		do
			tr := l
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
			dates.has (d)
		do
			across
				1 |..| count as i
			loop
				if tr [i.item].date.getvalue ~ d.getvalue then
					result := i.item
				end
			end --loop

		end

	precise (a_start, a_end: PF_DATE): REAL_64

	require
			a_start_is_date_domain: dates.has (a_start)
			a_end_is_date_domain: dates.has (a_end)
			a_end_is_after_a_start: a_end.getvalue.is_greater (a_start.getvalue)

		local
			ls: ARRAYED_LIST [TUPLE [REAL_64, REAL_64]]
			c: CALCULATION
			i: INTEGER
		do
			create ls.make (0)
			ls.force ([tr [1].mv.getValue, duration (a_start)])
			from
				i := 2
			until
				i >= di (a_end)
			loop
				ls.force ([(tr [i].cf.getValue - tr [i].af.getValue), duration (tr [i].date)])
				i := i + 1
			end
			ls.force ([((tr [di (a_end)].mv.getValue) * -1), 0.0])
			create c.make (create {POLYNOMIAL_NR}.make_from_list (ls))
			c.calculate
			Result := (c.solution - 1) * 100
		end

feature --class variables

	tr: LIST [TUPLE [date: PF_DATE; mv: PF_MARKETVALUE; cf: PF_CASHFLOW; af: PF_AGENTFEE]]

end
