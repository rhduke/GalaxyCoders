note
	description: "Summary description for {INVESTMENT_HISTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INVESTMENT_HISTORY

create
	make_empty

feature {NONE} -- constructor
	make_empty
		do
			create history.make_empty
		end

feature
	add (inv : like t)
		do
			history.force (inv, history.capacity + 1)
		end

feature {INVESTMENT_HISTORY} -- implementation
	t : TUPLE[date:PF_DATE; mk:PF_MARKETVALUE; cf:PF_CASHFLOW; af:PF_AGENTFEE; bm:PF_BENCHMARK]
	history : ARRAY[like t]

end
