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

	date : PF_DATE
		do
			Result := investment.date
		end

	mv : PF_MARKETVALUE
		do
			Result := investment.mk
		end

	cf : PF_CASHFLOW
		do
			Result := investment.cf
		end

	af : PF_AGENTFEE
		do
			Result := investment.af
		end

	bm : PF_BENCHMARK
		do
			Result := investment.bm
		end

feature {INVESTMENT} -- implementation
	investment : TUPLE[date:PF_DATE; mk:PF_MARKETVALUE; cf:PF_CASHFLOW; af:PF_AGENTFEE; bm:PF_BENCHMARK]

end
