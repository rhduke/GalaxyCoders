note
	description: "Summary description for {PF_PHONE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PF_PHONE
inherit
	PF_DATATYPE

create
	make,
	make_not_exist

feature {NONE} -- constructor
	make (p : STRING_32)
		do
			exist := true
			phone := p
		end

	make_not_exist
		do
			exist := false
		end

feature -- inherited
	getValue : STRING_32
		do
			Result := phone
		end

	exists : BOOLEAN
		do
			Result := exist
		end

feature {PF_PHONE} -- implementation
	phone : STRING_32
	exist : BOOLEAN
end
