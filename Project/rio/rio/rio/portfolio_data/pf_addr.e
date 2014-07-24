note
	description: "Summary description for {PF_ADDR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PF_ADDR
inherit
	PF_DATATYPE

create
	make,
	make_not_exist

feature {NONE} -- constructor
	make (addr : like address)
		do
			exist := true
			address := addr
		end

	make_not_exist
		do
			exist := false
		end

feature -- inherited
	getValue : like address
		do
			Result := address
		end

	exists : BOOLEAN
		do
			Result := exist
		end

feature {PF_ADDR} -- impementation
	address : STRING_32
	exist : BOOLEAN
end