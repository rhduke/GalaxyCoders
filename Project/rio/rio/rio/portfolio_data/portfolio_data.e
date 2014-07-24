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
			create general_info.make_empty
			create invest_history.make_empty
		end

feature -- getters and adders
	addInfo(info : PF_DATATYPE)
		do
			general_info.force (info, general_info.capacity + 1)
		end

	addInvestment (inv : INVESTMENT)
		do
			invest_history.force (inv, invest_history.capacity + 1)
		end

	getInfo : like general_info
		do
			Result := general_info
		end

	getInvestHistory : like invest_history
		do
			Result := invest_history
		end

feature {PORTFOLIO_DATA} -- implementation
	general_info : ARRAY[PF_DATATYPE]
	invest_history : ARRAY[INVESTMENT]

end
