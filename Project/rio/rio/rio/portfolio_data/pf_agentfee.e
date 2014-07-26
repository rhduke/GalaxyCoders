note
	description: "Summary description for {PF_AGENTFEE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PF_AGENTFEE
inherit
	PF_DATATYPE

create
	make,
	make_not_exist

feature {NONE} -- constructor
	make (af : REAL_64)
		do
			exist := true
			agent_fee := af
		end

	make_not_exist
		do
			exist := false
			agent_fee := 0.0
		end

feature -- inherited
	getValue : REAL_64
		do
			Result := agent_fee
		end

	exists : BOOLEAN
		do
			Result := exist
			ensure then
				not_null : result /= void
		end

feature {PF_AGENTFEE} -- implementation
	agent_fee : REAL_64
	exist : BOOLEAN

end
