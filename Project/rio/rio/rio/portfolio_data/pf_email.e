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
	make (em : like email)
		do
			exist := true
			email := em
		end

	make_not_exist
		do
			exist := false
		end

feature -- inherited
	getValue : like email
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
