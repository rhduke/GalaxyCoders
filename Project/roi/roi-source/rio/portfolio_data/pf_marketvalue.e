note
	description: "Summary description for {INVESTMENT_MK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PF_MARKETVALUE

inherit

	PF_DATATYPE

create
	make, make_not_exist

feature {NONE} -- constructor

	make (mk: REAL_64)
		do
			exist := true
			market_value := mk
		end

	make_not_exist
		do
			exist := false
			market_value := 0.0
		end
feature -- inherited

	getValue: REAL_64
		do
			Result := market_value

			ensure then
				not_null : result /= void
		end

	exists: BOOLEAN
		do
			Result := exist
		end

feature {PF_MARKETVALUE} -- implementation

	market_value: REAL_64

	exist: BOOLEAN

end
