note
	description: "Summary description for {PF_ACCOUNT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PF_ACCOUNT
inherit
	PF_DATATYPE

create
	make,
	make_not_exist

feature {NONE} -- constructor
	make (acc : like account)
		do
			exist := true
			account := acc
		end

	make_not_exist
		do
			exist := false
		end

feature -- inherited
	getValue : like account
		do
			Result := account
		end

	exists : BOOLEAN
		do
			Result := exist
		end

feature {PF_ACCOUNT} -- implementation
	account : INTEGER_32
	exist : BOOLEAN
end