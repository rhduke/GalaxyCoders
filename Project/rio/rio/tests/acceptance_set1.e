note
	description: "Summary description for {ACCEPTANCE_SET1}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ACCEPTANCE_SET1
inherit
	ES_TEST
create
	make

feature
	make
		do
			add_boolean_case (agent t1 ("rio/csv-inputs/accept1(correct)/ACC-T1.csv"))
		end


feature
	t1 (path : STRING) : BOOLEAN
		local
			exe : EXECUTE
			f : FLUSH_SHARED
		do
			f.flushall
			create exe.make_from_path (path)
			Result := exe.has_errors = false
		end
end
