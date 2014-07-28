note
	description: "Summary description for {PF_EVAL_PER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PF_EVAL_PER

inherit

	PF_DATATYPE
	redefine
	is_equal
	end


create make, make_not_exist

feature {NONE} -- constructor

	make (date_string: STRING)
		do
			exist := true
			string := date_string
			extract_date
		end

	make_not_exist
		do
			make("")
			exist := false
		end

feature {PORTFOLIO_DATA} -- inherited

	getValue: TUPLE [x, y: DATE]
		do
			Result := evaluation_period.twin
		ensure then
				Result = evaluation_period.twin
		end

	exists: BOOLEAN
		do
			Result := exist
		end

feature {NONE} -- routines to help extract and validate dates

	extract_date
		local
			regexp: RX_PCRE_REGULAR_EXPRESSION
			regexp_2: RX_PCRE_REGULAR_EXPRESSION
			arr_string: LIST [STRING]
			counter: INTEGER
		do
			create regexp.make ; create regexp_2.make
			create evaluation_period.default_create
			arr_string := string.split (' ')
			regexp.compile ("\d{4}-\d{2}-\d{2}")
			regexp_2.compile ("\d{2}/\d{2}/\d{4}")
			check
				regexp.is_compiled and regexp_2.is_compiled
			end
			counter := 1
			evaluation_period.x := create {DATE}.make_month_day_year (1,1,1900)
			evaluation_period.y :=  create {DATE}.make_month_day_year (1,1,1900)
			across	arr_string as c loop
				regexp.match (c.item)
				regexp_2.match (c.item)
				if regexp.has_matched then
					if counter = 1 then
						 evaluation_period.x := create {DATE}.make_from_string (regexp.captured_substring (0), "yyyy-mm-dd")
					end
					if counter = 2 then
						  evaluation_period.y := create {DATE}.make_from_string (regexp.captured_substring (0), "yyyy-mm-dd")
					end
					counter := counter + 1
				end
				if regexp_2.has_matched then
								if counter = 1 then
									 evaluation_period.x := create {DATE}.make_from_string (regexp_2.captured_substring (0), "mm/dd/yyyy")
								end
								if counter = 2 then
									  evaluation_period.y := create {DATE}.make_from_string (regexp_2.captured_substring (0), "mm/dd/yyyy")
								end
								counter := counter + 1
							end
			end

		end
	is_equal ( other : like current) : BOOLEAN
	do
		Result := other.evaluation_period.x.is_equal (evaluation_period.x) and
				other.evaluation_period.y.is_equal (evaluation_period.y)
		ensure then
			Result = other.evaluation_period.x.is_equal (evaluation_period.x) and
				other.evaluation_period.y.is_equal (evaluation_period.y)

	end

feature {PF_EVAL_PER} -- implementation

	evaluation_period: TUPLE [x, y: DATE]

	string: STRING

	exist: BOOLEAN

end
