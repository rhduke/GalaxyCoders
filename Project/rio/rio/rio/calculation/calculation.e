note
	description: "Summary description for {CALCULATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CALCULATION

create
	make

feature {NONE}
	make (p : POLYNOMIAL)
		do
			setPoly(p)
		end

feature

	solution : REAL_64
		do
			Result := poly.solution
		end

	solution_not_found : BOOLEAN
		do
			Result := poly.solution_not_found
		end

	calculate
		do
			poly.calculate
		end

	setPoly (p : POLYNOMIAL)
		require
			not_void: p /= void
		do
			poly := p
		end

feature {CALCULATION} -- implementation
	poly : POLYNOMIAL

end
