note
	description: "Summary description for {ACCEPTANCE_SET1}. Inputs should have no errors or warnings."
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
			add_boolean_case (agent is_correct ("rio/csv-inputs/accept1(correct)/ACC-T1.csv"))
			add_boolean_case (agent is_correct ("rio/csv-inputs/accept1(correct)/ACC-T2.csv"))
			add_boolean_case (agent is_correct ("rio/csv-inputs/accept1(correct)/ACC-T3.csv"))
			add_boolean_case (agent is_correct ("rio/csv-inputs/accept1(correct)/ACC-T4.csv"))
			add_boolean_case (agent is_correct ("rio/csv-inputs/accept1(correct)/ACC-T5.csv"))
			add_boolean_case (agent is_correct ("rio/csv-inputs/accept1(correct)/ACC-T6.csv"))
			add_boolean_case (agent is_correct ("rio/csv-inputs/accept1(correct)/ACC-T7.csv"))
			add_boolean_case (agent no_soln ("rio/csv-inputs/accept1(correct)/ACC-T8.csv"))
		end


feature
	is_correct (path : STRING) : BOOLEAN
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
			Result := exe.has_errors = false
			print("==============================================================")
			io.new_line
		end

	no_soln (path : STRING) : BOOLEAN
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
			Result := exe.has_errors = true
			print("==============================================================")
			io.new_line
		end
end
