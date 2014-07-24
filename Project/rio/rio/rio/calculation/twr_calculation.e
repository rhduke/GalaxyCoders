note
	description: "Summary description for {TWR_CALCULATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TWR_CALCULATION

create
    make

    feature make
    do


     end

     feature


     	count : INTEGER
     	do

     		Result := tr.count

     		ensure
     		    Result = tr.count
     	end



     	dates : LIST[PF_DATE]
     	do

     	across tr as c  loop Result.extend(c.item.date) end

     	end



     	start : PF_DATE

     	do
     		Result := tr[1].date

     		ensure
     			Result = tr[1].date
     	end




     	end_date : PF_DATE

     	do
     		Result := tr[tr.count].date

     		ensure
     			Result = tr[tr.count].date
     	end

     	duration: REAL_64

     	do

     		Result :=  (end_date.getValue.days - start.getValue.days)/ (365.2422)

     		ensure
     			Result = create {REAL_64}.make_from_reference ((end_date.getValue.days - start.getValue.days)/ (365.2422))

     	end

     	di(d:PF_DATE):INTEGER

     	require
     	   	dates.has (d)

     	 do

     	   across 1 |..| count as i loop
     	   if tr[i.item].date.getvalue ~ d.getvalue then
     	   	result := i.item
     	   end

     	      end --loop

     	      ensure

     	      across 1 |..| count as i some Result = i.item   end
     	      tr[Result].date.getvalue ~ d.getvalue

       end



     	feature  --class variables

     	tr : LIST[TUPLE[date:PF_DATE;mv:PF_MARKETVALUE;cf:PF_CASHFLOW;af:PF_AGENTFEE]]




end
