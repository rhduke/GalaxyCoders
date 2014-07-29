note
	description: "Summary description for {ACCEPTANCE_SET2}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ACCEPTANCE_SET2
inherit
	ES_TEST
create
	make

feature
	make
		do
			add_boolean_case (agent is_correct ("roi/csv-inputs/accept2(warning)/WAR-T1.csv", 1))
			add_boolean_case (agent is_correct ("roi/csv-inputs/accept2(warning)/WAR-T2.csv", 1))
			add_boolean_case (agent is_correct ("roi/csv-inputs/accept2(warning)/WAR-T3.csv", 1))
			add_boolean_case (agent is_correct ("roi/csv-inputs/accept2(warning)/WAR-T4.csv", 5))
		end


feature
	is_correct (path : STRING; num : INTEGER_32) : BOOLEAN
		local
			exe : EXECUTE
			f : FLUSH_SHARED
		do
			comment(path)
			create f.make
			f.flushall
			print("TEST FOR : " + path)
			io.new_line
			create exe.make_from_path (path)
			Result := exe.count_errors = num
			print("==============================================================")
			io.new_line
		end
end
