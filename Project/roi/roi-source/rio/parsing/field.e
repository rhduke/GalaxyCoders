note
	description: "Representation of fields appearing in a comma-separated document."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FIELD

inherit

	ANY
		redefine
			is_equal,
			out
		end

create
	make

feature {NONE} -- Implementation

	rep: STRING

feature -- Constructor

	make (s: STRING)
		do
			rep := s
		end

feature -- Queries on status

	is_empty: BOOLEAN
			-- Is the current field empty?
		do
			Result := across rep as c all c.item = ' ' or c.item = '%T' end
		end

	is_int: BOOLEAN
			-- Does the current field represent an INTEGER_64?
		do
			Result := rep.is_integer_64
		end

	is_double: BOOLEAN
			-- Does the current field represent a REAL_64?

		do
			Result := rep.is_double
		end

	is_float: BOOLEAN
			-- Is the current field a double or integer
		local
			l: LIST [STRING]
			i: INTEGER
		do
			if (rep.has (',')) then
				l := rep.split (',')
				create rep.make_empty
				from
					i := 1
				until
					i > l.count
				loop
					rep.append_string (l [i])
					i := i + 1
				end
				Result := is_int or is_double
			else
				Result := is_int or is_double
			end
		end

	is_date: BOOLEAN
			-- Does the current field represent a date?
		local
			pattern, pattern2: STRING
			regexp, regexp2: RX_PCRE_REGULAR_EXPRESSION
			rep_trimmed: STRING
			l_date: DATE
		do
			create l_date.make_day_month_year (1, 1, 1900)
				-- pattern 1
			pattern := "(\d\d\d\d-\d\d-\d\d)"
			create regexp.make
			regexp.compile (pattern)
			check
				regexp.is_compiled
			end
			regexp.match (rep)
				-- pattern 2
			pattern2 := "(\d?\d/\d?\d/\d\d\d\d)"
			create regexp2.make
			regexp2.compile (pattern2)
			check
				regexp2.is_compiled
			end
			regexp2.match (rep)

				--test
			if regexp.has_matched and then l_date.date_valid (rep, "yyyy-mm-dd") then
				Result := true
			elseif regexp2.has_matched and then l_date.date_valid (rep, "mm/dd/yyyy") then
				Result := true
			else
				Result := false
			end
		end

	is_percentage: BOOLEAN
			-- Is current field xx.yy%
		local
			l_pattern: STRING
			regexp: RX_PCRE_REGULAR_EXPRESSION
		do
			l_pattern := "([-+]?[0-9]*\.?[0-9]+)%%"
			create regexp.make
			regexp.compile (l_pattern)
			check
				regexp.is_compiled
			end
			regexp.match (rep)
			if regexp.has_matched then
				Result := true
			else
				Result := false
			end
		end

feature -- Conversion

	as_date: DATE
		require
			is_date
		local
			pattern, pattern2: STRING
			regexp, regexp2: RX_PCRE_REGULAR_EXPRESSION
		do
				-- pattern 1
			pattern := "(\d\d\d\d-\d\d-\d\d)"
			create regexp.make
			regexp.compile (pattern)
			check
				regexp.is_compiled
			end
			regexp.match (rep)
				-- pattern 2
			pattern2 := "(\d?\d/\d?\d/\d\d\d\d)"
			create regexp2.make
			regexp2.compile (pattern2)
			check
				regexp2.is_compiled
			end
			regexp2.match (rep)
			create Result.make_day_month_year (1, 1, 1900)
			if regexp.has_matched then
				Result.make_from_string (rep, "yyyy-mm-dd")
			elseif regexp2.has_matched then
				Result.make_from_string (rep, "mm/dd/yyyy")
			end
		end

	as_int: INTEGER_64
			-- Convert the current field into an INTEGER_64.
		require
			is_int
		do
			Result := rep.to_integer_64
		end

	as_double: REAL_64
			-- Convert the current field into a REAL_64.
		require
			is_double
		do
			Result := rep.to_real_64
		end

	as_float: REAL_64
		require
			is_float
		do
			Result := rep.to_real_64
		end

	as_percentage: REAL_64
			-- Convert xx.yy% to xx.yy
		require
			is_percentage
		local
			regexp: RX_PCRE_REGULAR_EXPRESSION
			l_pattern: STRING
		do
			l_pattern := "([-+]?[0-9]*\.?[0-9]+)%%"
			create regexp.make
			regexp.compile (l_pattern)
			check
				regexp.is_compiled
			end
			regexp.match (rep)
			Result := regexp.captured_substring (1).to_real_64
		end

feature -- Equality and String Representation

	is_equal (other: FIELD): BOOLEAN
			-- Is the current field equal to 'other'?
		do
			if other /= Void then
				Result := rep ~ other.out
			end
		end

	out: STRING
			-- Convert the current field into a string.
		do
			Result := rep.twin
		end

end
