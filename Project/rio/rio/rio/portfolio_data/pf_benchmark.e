note
	description: "Summary description for {PF_BENCHMARK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PF_BENCHMARK
inherit
	PF_DATATYPE

create
	make,
	make_not_exist

feature {NONE} -- constructor
	make (bm : REAL_64)
		do
			exist := true
			bench_mark := bm
		end

	make_not_exist
		do
			exist := false
			bench_mark := 0.0
		end

feature -- inherited
	getValue : REAL_64
		do
			Result := bench_mark
			ensure then
				not_null : result /= void
		end

	exists : BOOLEAN
		do
			Result := exist
		end

feature {PF_BENCHMARK} -- implementation
	bench_mark : REAL_64
	exist : BOOLEAN
end
