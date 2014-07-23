note
	description: "Summary description for {PF_EMAIL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PF_EMAIL
inherit
	PF_DATATYPE

create
	make,
	make_not_exist

feature {NONE} -- constructor
	make (em : STRING_32)
		do
			exist := true
			email := em
		end

	make_not_exist
		do
			exist := false
		end

feature -- inherited
	getValue : STRING_32
		do
			Result := email
		end

	exists : BOOLEAN
		do
			Result := exist
		end

feature {PF_EMAIL} -- implementation
	email : STRING_32
	exist : BOOLEAN
end
