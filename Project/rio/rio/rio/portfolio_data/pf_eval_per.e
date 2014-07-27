note
	description: "Summary description for {PF_EVAL_PER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PF_EVAL_PER
inherit
	PF_DATATYPE

create
	make,
	make_not_exist

feature {NONE} -- constructor
	make (date_string : STRING)
		do
			exist := true
			string := date_string
		end

	make_not_exist
		do
			exist := false
		end

feature -- inherited
	getValue : TUPLE[x,y:DATE]
		do
			Result := evaluation_period
			ensure then
				not_null : result /= void
		end

	exists : BOOLEAN
		do
			Result := exist
		end
feature -- routines to help extract and validate dates
	extract_date
		local
			regexp: RX_PCRE_REGULAR_EXPRESSION
	do
		create regexp.make

		regexp.compile("\d{4}-\d{2}-\d{2}")
		check regexp.is_compiled  end
		regexp.match (string)
		if regexp.has_matched  then
			io.put_string ("matched"+ regexp.captured_substring (0))
		else
			io.put_string ("not captured")
		end


	end
feature {PF_EVAL_PER} -- implementation
	evaluation_period : TUPLE[x,y:DATE]
	string : STRING
	exist : BOOLEAN
end
