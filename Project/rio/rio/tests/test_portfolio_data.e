note
	description: "Testing Portfolio data ."
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
			add_boolean_case (agent t13)
			add_boolean_case (agent t14)
			add_boolean_case (agent t15)



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
		create d1.make_month_day_year (1,1,1900)
		create d2.make_month_day_year (1,1,1901)

		tup := [d1, d2]
		create ep.make ("1900-01-01 to 1901-01-01")
		Result := ep.getvalue.x.days = tup.x.days
		check Result end
		Result := ep.getvalue.y.days = tup.y.days
--		Result := ep.exists = true
	end

	t12 : BOOLEAN
	local
		ep : PF_EVAL_PER
		d1 : DATE
		d2 : DATE
		tup : TUPLE[x,y:DATE]
	do
		comment("Testing non-existing evaluation period")

		create ep.make_not_exist
		Result := ep.exists = false
	end

	t13 : BOOLEAN
	local
		mk : PF_MARKETVALUE
		af : PF_AGENTFEE
		bm : PF_BENCHMARK
		cf : PF_CASHFLOW
		d : PF_DATE
		i : INVESTMENT
		date : DATE
		t : TUPLE[date:PF_DATE; mk:PF_MARKETVALUE; cf:PF_CASHFLOW; af:PF_AGENTFEE; bm:PF_BENCHMARK]
	do
		comment("Testing Investment tuple with values [(1993,08,30),12.03,45.13,0,0.1")

		create date.make (1993, 08, 30)

		create mk.make(12.03)
		create af.make(45.13)
		create bm.make(0)
		create cf.make(0.1)
		create d.make (date)

		t := [d, mk, cf, af, bm]
		create i.make(t)

		Result := i.af.getvalue = af.getvalue
		check Result end
		Result := i.mv.getvalue = mk.getvalue
		check Result end
		Result := i.bm.getvalue = bm.getvalue
		check Result end
		Result := i.cf.getvalue = cf.getvalue
		check Result end
		Result := i.date.getvalue ~ date
		check Result end
	end

	t14 : BOOLEAN
	local
		mk : PF_MARKETVALUE
		af : PF_AGENTFEE
		bm : PF_BENCHMARK
		cf : PF_CASHFLOW
		d : PF_DATE
		i : INVESTMENT
		date : DATE
		t : TUPLE[date:PF_DATE; mk:PF_MARKETVALUE; cf:PF_CASHFLOW; af:PF_AGENTFEE; bm:PF_BENCHMARK]
	do
		comment("Testing Investment tuple with non-existant values")



		create mk.make_not_exist
		create af.make_not_exist
		create bm.make_not_exist
		create cf.make_not_exist
		create d.make_not_exist

		t := [d, mk, cf, af, bm]
		create i.make(t)

		Result := i.af.getvalue = af.getvalue
		check Result end
		Result := i.mv.getvalue = mk.getvalue
		check Result end
		Result := i.bm.getvalue = bm.getvalue
		check Result end
		Result := i.cf.getvalue = cf.getvalue
		check Result end
		Result := i.date.exists = false
		check Result end
	end

	t15 : BOOLEAN
	local
		inv1, inv2 : INVESTMENT
		date : DATE
		PF : PORTFOLIO_DATA
		sc : SHARED_CLASSES
		t : TUPLE[date:PF_DATE; mk:PF_MARKETVALUE; cf:PF_CASHFLOW; af:PF_AGENTFEE; bm:PF_BENCHMARK]
	do
		comment("Testing portfolio data with two investments")

		create date.make (1993, 08, 30)

		t := [create {PF_DATE}.make (date),
			  create {PF_MARKETVALUE}.make(34),
			  create {PF_CASHFLOW}.make (36),
		      create {PF_AGENTFEE}.make (47),
		      create {PF_BENCHMARK}.make (58)]

		create inv1.make(t)

		t := [create {PF_DATE}.make_not_exist,
			  create {PF_MARKETVALUE}.make_not_exist,
			  create {PF_CASHFLOW}.make_not_exist,
		      create {PF_AGENTFEE}.make_not_exist,
		      create {PF_BENCHMARK}.make_not_exist]

		create inv2.make(t)

		PF := sc.init_portfolio_data
		PF.flush
		PF.printout
		Result := PF.getlist.is_empty = true
		check Result end

		PF.add (inv1, 1)
		PF.add (inv2, 2)

		Result := PF[1] = inv1
		check Result end
		Result := PF[2] = inv2
		check Result end

	end

end

