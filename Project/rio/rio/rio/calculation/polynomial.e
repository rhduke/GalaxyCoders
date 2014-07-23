note
	description: "Summary description for {POLYNOMIAL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	POLYNOMIAL

feature -- implementation


feature

	solution : REAL_64

	solution_not_found : BOOLEAN

	calculate
		deferred
		end

	set_poly (poly:ANY)
		require
			poly_not_null: poly /= void
		deferred
		ensure
		end
end
