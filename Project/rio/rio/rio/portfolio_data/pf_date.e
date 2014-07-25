note
	description: "Summary description for {INVESTMENT_DATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PF_DATE
inherit
	PF_DATATYPE

create
	make,
	make_not_exist

feature {NONE} -- constructor
	make (d : like date)
		do
			exist := true
			date := d
		end

	make_not_exist
		do
			exist := false
		end

	valid : BOOLEAN
		do
				Result := true
				ensure then
				result = true
		end

feature -- inherited
	getValue : like date
		do
			Result := date
		end

	exists : BOOLEAN
		do
			Result := exist
		end

feature {PF_DATE} -- implementation
	date : DATE
	exist : BOOLEAN
end
