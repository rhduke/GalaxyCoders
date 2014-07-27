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
		end

feature -- getters and adders
	add (inv : INVESTMENT)
		do
			invest_history.force (inv)
		end


	item alias "[]" (i : INTEGER_32) : INVESTMENT
		require
			index_bounded : across 1 |..| invest_statements_size  as j  some i = j.item   end
		do
			Result := invest_history[i]	
		end

	getList : like invest_history
		do
			Result := invest_history
		end

	printOut
		local
			i : INTEGER
		do
			from
				i := 1
			until
				i > invest_history.count
			loop
				io.put_new_line
				print("index ")
				print(i)
				print(": ")
				print(invest_history[i].date.getvalue)
				print(",")
				print(invest_history[i].mv.getvalue)
				print(",")
				print(invest_history[i].cf.getvalue)
				print(",")
				print(invest_history[i].af.getvalue)
				print(",")
				print(invest_history[i].bm.getvalue)
				io.new_line
				i := i + 1
			end
		end
	invest_statements_size : INTEGER
			-- return how many statment we have currently
	do
		Result := invest_history.upper
	ensure
		Result = invest_history.upper
	end



feature {PORTFOLIO_DATA} -- implementation
	invest_history : ARRAYED_LIST[INVESTMENT]

end
