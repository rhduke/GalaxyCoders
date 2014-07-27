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
		make(l : ARRAYED_LIST[TUPLE[PF_DATE,PF_MARKETVALUE,PF_CASHFLOW,PF_AGENTFEE]])
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

	duration(given: PF_DATE): REAL_64
		do
			Result := (end_date.getValue.days - given.getValue.days) / (365.2422)
--		ensure
--			Result = create {REAL_64}.make_from_reference ((end_date.getValue.days - given.getValue.days) / (365.2422))
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
			create Result.make_empty
			across
				tr as c
			loop
				create Result.force(c.item)
			end
		end

--     	cashflow_val(i:INTEGER) : REAL_64
--		do
--		Result:=	tr[i].cf.getValue - tr[i].af.getValue
--		end

		di (d: PF_DATE): INTEGER

		require
			dates.has (d)  this is wrong


           do


				across
					1 |..| count as i
				loop
					if tr [i.item].date.getvalue ~ d.getvalue then
						result := i.item
					end
				end --loop

				end

--		sum_of_cashflow(i,j: INTEGER) : REAL_64
--		do
--		create result.make_from_reference (0.0)
--		across i |..| j  as c loop Result := Result + cashflow_val(c.item)  end
--		end

        precise(a_start,a_end : PF_DATE) : REAL_64
        local
        ls : ARRAYED_LIST [TUPLE [REAL_64, REAL_64]]
        c : CALCULATION
        i : INTEGER

        do
--    --    di(a_start)
--    --    di(a_end)
        create ls.make (0)
        ls.force ([tr[1].mv.getValue,duration(a_start)])
        from
        	i := 2
        until
        	i >= di(a_end)
        loop
        	ls.force ([(tr[i].cf.getValue - tr[i].af.getValue),duration(tr[i].date)])
        	i := i+1
        end
        ls.force ([((tr[di(a_end)].mv.getValue) * -1),0.0])

       create c.make (create {POLYNOMIAL_NR}.make_from_list (ls))
	   c.calculate

 Result := (c.solution - 1) * 100

--result:= di(a_end)

end

		feature --class variables
tr: LIST [TUPLE [date: PF_DATE; mv: PF_MARKETVALUE; cf: PF_CASHFLOW; af: PF_AGENTFEE]]

end
