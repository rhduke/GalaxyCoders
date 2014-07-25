note
	description: "Summary description for {PF_EVAL_PER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PF_EVAL_PER
inherit
	PF_DATATYPE

create
	make,
	make_not_exist

feature {NONE} -- constructor
	make (ep : like evaluation_period)
		do
			exist := true
			evaluation_period := ep
		end

	make_not_exist
		do
			exist := false
		end

	valid : BOOLEAN
		do

		end
		
feature -- inherited
	getValue : like evaluation_period
		do
			Result := evaluation_period
		end

	exists : BOOLEAN
		do
			Result := exist
		end

feature {PF_EVAL_PER} -- implementation
	evaluation_period : TUPLE[x,y:DATE]
	exist : BOOLEAN
end
