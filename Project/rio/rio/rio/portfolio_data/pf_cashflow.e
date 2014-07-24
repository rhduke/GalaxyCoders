note
	description: "Summary description for {INVESTMENT_CF}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PF_CASHFLOW
inherit
	PF_DATATYPE

create
	make,
	make_not_exist

feature {NONE} -- constructor
	make (cf : like cash_flow)
		do
			exist := true
			cash_flow := cf
		end

	make_not_exist
		do
			exist := false
		end

feature -- inherited
	getValue : like cash_flow
		do
			Result := cash_flow
		end

	exists : BOOLEAN
		do
			Result := exist
		end

feature {PF_CASHFLOW} -- implementation
	cash_flow : REAL_64
	exist : BOOLEAN

end