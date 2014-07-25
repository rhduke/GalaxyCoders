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
	make,
	make_not_exist

feature {NONE} -- constructor
	make (mk : like market_value)
		do
			exist := true
			market_value := mk
		end

	make_not_exist
		do
			exist := false
		end

	valid : BOOLEAN
		do

		end

feature -- inherited
	getValue : like market_value
		do
			Result := market_value
		end

	exists : BOOLEAN
		do
			Result := exist
		end

feature {PF_MARKETVALUE} -- implementation
	market_value : REAL_64
	exist : BOOLEAN
end
