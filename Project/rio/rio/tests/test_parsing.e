note
	description: "Summary description for {TEST_PARSING}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_PARSING
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
		p : PARSE_ACCOUNT
		row : ROW
	do
		comment("Testing parser with valid account")
		create p.make
		create row.make ("account: 4502", 17)
		p.parserow (row)

		Result := p.is_successfully_obtain_data = true

	end

	t2 : BOOLEAN
	local
		p : PARSE_ACCOUNT
		row : ROW
	do
		comment("Testing parser with non-valid account")
		create p.make
		create row.make ("not valid", 17)
		p.parserow (row)
		Result := p.is_successfully_obtain_data = false
		Check Result end
		create row.make ("accoount number 4568", 17)
		p.parserow (row)
		Result := p.is_successfully_obtain_data = false
		Check Result end
		create row.make ("accountt : 4578", 17)
		p.parserow (row)
		Result := p.is_successfully_obtain_data = false


	end

	t3 : BOOLEAN
	local
		p : PARSE_ADDR
		row : ROW
	do
		comment("Testing parser with valid address")
		create p.make
		create row.make ("address: 1967 Martin Grove road", 30)
		p.parserow (row)

		Result := p.is_successfully_obtain_data = true


	end

	t4 : BOOLEAN
	local
		p : PARSE_ADDR
		row : ROW
	do
		comment("Testing parser with non-valid address")
		create p.make
		create row.make ("this is not a valid address", 30)
		p.parserow (row)

		Result := p.is_successfully_obtain_data = false
		Check Result end
		create row.make ("addrees : 45 Steeles Ave West", 17)
		p.parserow (row)
		Result := p.is_successfully_obtain_data = false
		Check Result end
		create row.make ("adress : 64 Rexdale Blvd", 17)
		p.parserow (row)
		Result := p.is_successfully_obtain_data = false

	end

	t5 : BOOLEAN
	local
		p : PARSE_DESCR
		row : ROW
	do
		comment("Testing parser with valid description")
		create p.make
		create row.make ("Description: BMO RRSP", 30)
		p.parserow (row)

		Result := p.is_successfully_obtain_data = true

	end

	t6 : BOOLEAN
	local
		p : PARSE_DESCR
		row : ROW
	do
		comment("Testing parser with non-valid description")
		create p.make
		create row.make ("this is not a valid description", 30)
		p.parserow (row)

		Result := p.is_successfully_obtain_data = false
		Check Result end
		create row.make ("Descripton: CIBC", 17)
		p.parserow (row)
		Result := p.is_successfully_obtain_data = false
		Check Result end
		create row.make ("Description > CIBC", 17)
		p.parserow (row)
		Result := p.is_successfully_obtain_data = false

	end

	t7 : BOOLEAN
	local
		p : PARSE_EMAIL
		row : ROW
	do
		comment("Testing parser with valid email")
		create p.make
		create row.make ("Email: John@yorku.ca", 30)
		p.parserow (row)

		Result := p.is_successfully_obtain_data = true

	end

	t8 : BOOLEAN
	local
		p : PARSE_EMAIL
		row : ROW
	do
		comment("Testing parser with non-valid email")
		create p.make
		create row.make ("this is not a valid email", 30)
		p.parserow (row)

		Result := p.is_successfully_obtain_data = false
		Check Result end
		create row.make ("email ; cash@money.yorku.ca", 17)
		p.parserow (row)
		Result := p.is_successfully_obtain_data = false
		Check Result end
		create row.make ("email : whatsup", 17)
		p.parserow (row)
		Result := p.is_successfully_obtain_data = false

	end

	t9 : BOOLEAN
	local
		p : PARSE_PHONE
		row : ROW
	do
		comment("Testing parser with valid phone number")
		create p.make
		create row.make ("Phone: 416-736-1200", 30)
		p.parserow (row)

		Result := p.is_successfully_obtain_data = true

	end

	t10 : BOOLEAN
	local
		p : PARSE_PHONE
		row : ROW
	do
		comment("Testing parser with non-valid phone number")
		create p.make
		create row.make ("this is not a valid phone number", 30)
		p.parserow (row)

		Result := p.is_successfully_obtain_data = false
		Check Result end
		create row.make ("phone number : 416-8S2-78B", 17)
		p.parserow (row)
		Result := p.is_successfully_obtain_data = false
		Check Result end
		create row.make ("cell phone : 416-768-9999", 17)
		p.parserow (row)
		Result := p.is_successfully_obtain_data = false

	end

	t11 : BOOLEAN
	local
		p : PARSE_NAME
		row : ROW
	do
		comment("Testing parser with valid name")
		create p.make
		create row.make ("Name: Khurram Saleem", 1)
		p.parserow (row)

		Result := p.is_successfully_obtain_data = true


	end

	t12 : BOOLEAN
	local
		p : PARSE_NAME
		row : ROW
	do
		comment("Testing parser with invalid names")
		create p.make
		create row.make ("Name : Khurram Saleem", 2) -- not on first line
		p.parserow (row)

		Result := p.is_successfully_obtain_data = false
		Check Result end
		create row.make ("Name : 416-564-8976", 17)
		p.parserow (row)
		Result := p.is_successfully_obtain_data = false
		Check Result end
		create row.make ("Name : 5ara", 17)
		p.parserow (row)
		Result := p.is_successfully_obtain_data = false

	end

	t13 : BOOLEAN
	local
		p : PARSE_EVAL_PER
		row : ROW
	do
		comment("Testing parser with valid evaluation period")
		create p.make
		create row.make ("Evaluation Period: 2007-08-30 to 2009-05-30", 1)
		p.parserow (row)

		Result := p.is_successfully_obtain_data = true


	end

	t14 : BOOLEAN
	local
		p : PARSE_EVAL_PER
		row : ROW
	do
		comment("Testing parser with non-valid evaluation period")
		create p.make
		create row.make ("Evaluation Period: 2009-05-30 to 2007-05-30", 2)
		p.parserow (row)

		Result := p.is_successfully_obtain_data = false

	end

	t15 : BOOLEAN
	local
		p : PARSE_DATA
		row : ROW
	do
		comment("Testing parser with valid data")
		create p.make
		create row.make ("2009-12-21,10000,0,0,", 7)
		p.parserow (row)

		Result := p.is_successfully_obtain_data = true

	end




end

--problems
--evaluation period problem
--shouldn't everything else if found on first row should be invalid if name is only valid on first row
--parsing data problem