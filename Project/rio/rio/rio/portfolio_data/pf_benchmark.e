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
	make (bm : like bench_mark)
		do
			exist := true
			bench_mark := bm
		end

	make_not_exist
		do
			exist := false
		end

feature -- inherited
	getValue : like bench_mark
		do
			Result := bench_mark
		end

	exists : BOOLEAN
		do
			Result := exist
		end

	valid : BOOLEAN -- not done
		do
			Result := true
			ensure then
				Result = true
		end

feature {PF_BENCHMARK} -- implementation
	bench_mark : REAL_64
	exist : BOOLEAN
end
