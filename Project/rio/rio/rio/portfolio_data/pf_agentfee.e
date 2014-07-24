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
	make (af : like agent_fee)
		do
			exist := true
			agent_fee := af
		end

	make_not_exist
		do
			exist := false
		end

feature -- inherited
	getValue : like agent_fee
		do
			Result := agent_fee
		end

	exists : BOOLEAN
		do
			Result := exist
		end

feature {PF_AGENTFEE} -- implementation
	agent_fee : REAL_64
	exist : BOOLEAN

end