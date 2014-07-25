note
	description: "Summary description for {PORTFOLIO_DATA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PORTFOLIO_DATA

create
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

	getList : like invest_history
		do
			Result := invest_history
		end

	checkListErrors()
		do

		end
	

feature {PORTFOLIO_DATA} -- implementation
	list : ARRAY[INVESTMENT]

end
