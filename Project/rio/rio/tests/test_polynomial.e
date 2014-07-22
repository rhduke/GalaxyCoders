note
	description: "Summary description for {TEST_POLYNOMIAL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_POLYNOMIAL
inherit
	ES_TEST
create
	make

feature -- Constructor
	make
		do
			add_boolean_case (agent t1)
		end

feature -- Test cases

	tolerance: REAL_64 = 0.001

	almost_equal (x, y: REAL_64): BOOLEAN
		do
			if x ~ 0.0 and y ~ 0.0 then
				Result := True
			else
				Result := (x - y).abs / x.abs.max (y.abs) < tolerance
			end
		end

	t1 : BOOLEAN
		local
			c : CALCULATION
			ls: ARRAYED_LIST [TUPLE [REAL_64, REAL_64]]
		do
			comment ("t1: test root for -1x^2 + 2 is equal to 2")
			create ls.make_from_array (<< [2.0, 0.0], [-1.0, 2.0] >>)
			create c.make (create {POLYNOMIAL_NR}.make_from_list (ls))
			c.calculate
			check not c.solution_not_found end
			Result := almost_equal (c.solution * c.solution, 2.0)
			check Result end
		end
end
