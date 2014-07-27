note
	description: "Summary description for {TEST_PORTFOLIO_DATA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_PORTFOLIO_DATA
inherit
	ES_TEST
create
	make

feature -- Constructor
	make
		do
			add_boolean_case (agent t1)
			add_boolean_case (agent t2)
			add_boolean_case (agent t3)
			add_boolean_case (agent t4)
			add_boolean_case (agent t5)
			add_boolean_case (agent t6)
			add_boolean_case (agent t7)
			add_boolean_case (agent t8)
			add_boolean_case (agent t9)
			add_boolean_case (agent t10)
			add_boolean_case (agent t11)
			add_boolean_case (agent t12)


		end

feature -- tests

	t1 : BOOLEAN
	local
		cf : PF_CASHFLOW
	do
		comment("Testing existing CashFlow")
		create cf.make(12.03)
		Result := cf.getvalue = 12.03
		check Result end
		Result := cf.exists = true
	end

	t2 : BOOLEAN
	local
		cf : PF_CASHFLOW
	do
		comment("Testing non-existing cashflow")
		create cf.make_not_exist
		Result := cf.getvalue = 0
		check Result end
		Result := cf.exists = false

	end

	t3 : BOOLEAN
	local
		af : PF_AGENTFEE
	do
		comment("Testing existing Agent Fees")
		create af.make(9.87)
		Result := af.getvalue = 9.87
		check Result end
		Result := af.exists = true
--		check Result end
--		Result := af.valid = true

	end

	t4 : BOOLEAN
	local
		af : PF_AGENTFEE
	do
		comment("Testing non-existing agent fees")
		create af.make_not_exist
		Result := af.getvalue = 0
		check Result end
		Result := af.exists = false

	end

	t5 : BOOLEAN
	local
		bm : PF_BENCHMARK
	do
		comment("Testing existing Benchmark ")
		create bm.make(0.05)
		Result := bm.getvalue = 0.05
		check Result end
		Result := bm.exists = true
	end

	t6 : BOOLEAN
	local
		bm : PF_BENCHMARK
	do
		comment("Testing non-existing Benchmark")
		create bm.make_not_exist
		Result := bm.getvalue = 0
		check Result end
		Result := bm.exists = false

	end

	t7 : BOOLEAN
	local
		d : PF_DATE
		date : DATE
	do
		comment("Testing existing date")
		create date.make (1993, 8, 30)
		create d.make(date)
		Result := d.getvalue = date
		check Result end
		Result := d.exists = true
	end

	t8 : BOOLEAN
	local
		d : PF_DATE
		date : DATE
	do
		comment("Testing non-existing date")

		create d.make_not_exist
		date := d.getvalue
		Result := date = void
		check Result end
		Result := d.exists = false

	end

	t9 : BOOLEAN
	local
		mv : PF_MARKETVALUE
	do
		comment("Testing existing MarketValue")
		create mv.make(122.03)
		Result := mv.getvalue = 122.03
		check Result end
		Result := mv.exists = true
	end

	t10 : BOOLEAN
	local
		mv : PF_MARKETVALUE
	do
		comment("Testing non-existing MarketValue")
		create mv.make_not_exist
		Result := mv.getvalue = 0
		check Result end
		Result := mv.exists = false

	end

	t11 : BOOLEAN
	local
		ep : PF_EVAL_PER
		d1 : DATE
		d2 : DATE
		tup : TUPLE[x,y:DATE]
	do
		comment("Testing existing evaluation period")
		create d1.make (1993, 8, 30)
		create d2.make (1994, 9, 25)

		tup := [d1, d2]
		create ep.make (tup)
		Result := ep.getvalue = tup
		check Result end
		Result := ep.exists = true
	end

	t12 : BOOLEAN
	local
		ep : PF_EVAL_PER
		d1 : DATE
		d2 : DATE
		tup : TUPLE[x,y:DATE]
	do
		comment("Testing non-existing evaluation period")
--		create d1.make (1993, 8, 30)
--		create d2.make (1994, 9, 25)

--		tup := [d1, d2]
		create ep.make_not_exist
		Result := ep.getvalue = void
--		check Result end
		Result := ep.exists = false
	end



end

-- problems
--agent fees valid has problem
--date is set to void
