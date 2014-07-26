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
	make (cf : REAL_64)
		do
			exist := true
			cash_flow := cf
		end

	make_not_exist
		do
			exist := false
			cash_flow := 0.0
		end

feature -- inherited
	getValue : REAL_64
		do
			Result := cash_flow
			ensure then
				not_null : result /= void
		end

	exists : BOOLEAN
		do
			Result := exist
		end

feature {PF_CASHFLOW} -- implementation
	cash_flow : REAL_64
	exist : BOOLEAN

end
