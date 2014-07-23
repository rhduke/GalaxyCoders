note
	description: "Summary description for {PF_DESCR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PF_DESCR
inherit
	PF_DATATYPE

create
	make,
	make_not_exist

feature {NONE} -- constructor
	make (des : STRING_32)
		do
			exist := true
			description := des
		end

	make_not_exist
		do
			exist := false
		end

feature -- inherited
	getValue : STRING_32
		do
			Result := description
		end

	exists : BOOLEAN
		do
			Result := exist
		end

feature {PF_DESCR} -- implementation
	description : STRING_32
	exist : BOOLEAN

end
