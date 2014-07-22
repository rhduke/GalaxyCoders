note
	description: "Summary description for {POLYNOMIAL_NEWTON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	POLYNOMIAL_NR
inherit
	POLYNOMIAL

create
	make_from_list

feature {NONE}
	make_from_list (given : LIST[TUPLE [x,y: REAL_64]])
	do
		list := given
	end

feature
	calculate
		local
			nr : NR_POLYNOMIAL
		do
			create nr.make_from_list (list)
			nr.search_root
			solution_not_found := nr.solution_not_found
			solution := nr.solution
		end

	set_poly (poly : ANY)
		do
			if attached {LIST[TUPLE[x,y: REAL_64]]} poly as cs then
				list := cs
			end
		ensure then
			valid_set : valid_poly(list)
		end

	valid_poly (poly : ANY) : BOOLEAN
		do
			if attached {LIST[TUPLE[x,y: REAL_64]]} poly as cs then
				Result := true
			else
				Result := false
			end
		end

feature {POLYNOMIAL_NR} -- implementation
	list : LIST[TUPLE[x,y: REAL_64]]

end
