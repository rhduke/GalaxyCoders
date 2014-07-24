note
	description: "Summary description for {INVESTMENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INVESTMENT

create
	make

feature {NONE} -- constructor
	make (i : like investment)
		do
			investment := i
		end

feature -- getter
	get : like investment
		do
			Result := investment
		end

feature {INVESTMENT} -- implementation
	investment : TUPLE[date:PF_DATE; mk:PF_MARKETVALUE; cf:PF_CASHFLOW; af:PF_AGENTFEE; bm:PF_BENCHMARK]

end
