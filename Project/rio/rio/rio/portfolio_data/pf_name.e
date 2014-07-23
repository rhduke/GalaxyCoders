note
	description: "Summary description for {PF_NAME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PF_NAME
inherit
	PF_DATATYPE

create
	make,
	make_not_exist

feature {NONE} -- constructor
	make (n : STRING_32)
		do
			exist := true
			name := n
		end

	make_not_exist
		do
			exist := false
		end

feature -- inherited
	getValue : STRING_32
		do
			Result := name
		end

	exists : BOOLEAN
		do
			Result := exist
		end

feature {PF_NAME} -- implementation
	name : STRING_32
	exist : BOOLEAN
end
