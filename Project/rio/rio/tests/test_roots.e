note
	description: "Summary description for {TEST_ROOTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_ROOTS

inherit
	ES_TEST

create
	make

feature -- Initialization

	make
		do
			add_boolean_case (agent t11)
			add_boolean_case (agent t4)
			add_boolean_case (agent t1)
			add_boolean_case (agent t3)
		end

feature -- Creation

	new_polynomial (ls: ARRAYED_LIST [TUPLE [x,y: REAL_64]]): NR_POLYNOMIAL
		do
			create Result.make_from_list (ls)
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

	t1: BOOLEAN
		local
			f: NR_POLYNOMIAL
			fmt: FORMAT_DOUBLE
			sln, two: REAL_64
			e: REAL_64
			ls: ARRAYED_LIST [TUPLE [REAL_64, REAL_64]]

			hell,para,cold: NR_POLYNOMIAL
			temp,obv: ARRAYED_LIST [TUPLE [REAL_64, REAL_64]]
		do
			comment ("t1: test root finding in dummy square root finding class")
			create fmt.make (10, 10)
			two := 2.0
			create ls.make_from_array (<< [2.0, 0.0], [-1.0, 2.0] >>)
			create f.make_from_list (ls)
				-- the roots of f are the square roots of 2

			f.search_root
			check not f.solution_not_found end
			Result := almost_equal (f.solution * f.solution, 2.0)
			check Result end

			--just checkin how this works

			create temp.make_from_array (<<[2.0,3.0],[4.0,5.0]>>)
			create obv.make_from_array (<<[6.0,2.0],[20.0,4.0]>>)
			create hell.make_from_list (temp)
		    create cold.make_from_list (obv)
			para := hell.derivative
			Result := para.equals (cold)
			check Result end


		end

	t3: BOOLEAN
		local
			f: NR_POLYNOMIAL
			ls: ARRAYED_LIST [TUPLE [REAL_64, REAL_64]]
		do
			comment ("t3: build a polynomial from financial data and find its roots")
			create ls.make_from_array (<<[10.0,0.0],[10000.0,.25],[-10500.0,.5]>>)
			f := new_polynomial (ls)
			f.search_root
			check not f.solution_not_found end
			Result := f.item (f.solution).abs < tolerance
			check Result end
			Result := almost_equal (f.solution, 0.8261596392439689884)
		end

	t4: BOOLEAN
		local
			f: NR_POLYNOMIAL
			ls: ARRAYED_LIST [TUPLE [REAL_64, REAL_64]]
			expected: REAL_64
			precision: REAL_64
		do
			comment("t4: test polynomila with ROI data")
				-- answer is 22.75% ROI
			expected := 1 + .227509
				-- We are solving polynomial f(R) for R = 1+r

			precision := .0005 -- estimated Excel precision

				-- create a polynomial f(R)
			create ls.make_from_array (<<
				[ 100000.0, 2.00274],
				[  20000.0, 1.5006849],
				[      0.0, 1.00274],
				[-178000.5, 0.0]>>)
			f := new_polynomial (ls)
			f.search_root
			Result := not f.solution_not_found
			check Result end
			Result := f.item (f.solution).abs < tolerance -- (f(x) = [-a, +b], i.e. 0 in [-a, +b].
			check Result end
			Result := almost_equal (f.solution, expected)
			check Result end
			Result := not (f.item (expected).abs < tolerance)
				-- Excel didn't get as close as we did.
		end

	t11: BOOLEAN
		local
			f1: NR_POLYNOMIAL
			ls: ARRAYED_LIST [TUPLE [x,y: REAL_64]]
		do
			comment ("t11: find roots of an polynomial with large values")
			create ls.make_from_array (
				<<  [3.0, 2.0],
					[-1.0e9, 1.0],
					[5.0, 0.0] >>)
			f1 := new_polynomial (ls)
			f1.search_root
			Result := (f1.solution - 5.0e-9).abs < 1.0e-12
				or (f1.solution - 333333333.3333333).abs < 10.0
		end

end
