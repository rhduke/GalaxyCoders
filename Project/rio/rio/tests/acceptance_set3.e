note
	description: "Summary description for {ACCEPTANCE_SET3}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ACCEPTANCE_SET3
inherit
	ES_TEST
create
	make

feature
	make
		do
			add_boolean_case (agent is_correct ("rio/csv-inputs/accept3(error)/ERR-T1.csv", 1))
			add_boolean_case (agent is_correct ("rio/csv-inputs/accept3(error)/ERR-T2.csv", 1))
			add_boolean_case (agent is_correct ("rio/csv-inputs/accept3(error)/ERR-T3.csv", 1))
			add_boolean_case (agent is_correct ("rio/csv-inputs/accept3(error)/ERR-T4.csv", 2))
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
