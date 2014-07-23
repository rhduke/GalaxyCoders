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
			create inv_history.make_empty
		end

feature
	addInfo(info : PF_DATATYPE)
		do
			general_info.force (info, general_info.capacity + 1)
		end

--	addInv

feature {PORTFOLIO_DATA} -- implementation
	general_info : ARRAY[PF_DATATYPE]
	inv_history : INVESTMENT_HISTORY

end
