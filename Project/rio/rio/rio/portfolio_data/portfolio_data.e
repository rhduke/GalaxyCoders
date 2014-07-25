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
			create invest_history.make_empty
		end

feature -- getters and adders
	add (inv : INVESTMENT)
		do
			invest_history.force (inv, invest_history.capacity + 1)
		end


	item (i : INTEGER_32) : INVESTMENT
		do
			Result := invest_history.item (i)
		end

	getList : like invest_history
		do
			Result := invest_history
		end

	checkListErrors()
		do

		end

	printOut
		local
			i : INTEGER
		do
			from
				i := 1
			until
				i > invest_history.capacity
			loop
				print("index ")
				print(i)
				print(": ")
				print(invest_history.item(i).get.date.getvalue.days)
				print(",")
				print(invest_history.item (i).get.mk.getvalue)
				print(",")
				print(invest_history.item (i).get.cf.getvalue)
				print(",")
				print(invest_history.item (i).get.af.getvalue)
				print(",")
				print(invest_history.item (i).get.bm.getvalue)
				io.new_line
				i := i + 1
			end
		end

feature {PORTFOLIO_DATA} -- implementation
	invest_history : ARRAY[INVESTMENT]

end
