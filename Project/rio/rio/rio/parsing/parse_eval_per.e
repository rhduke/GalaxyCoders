note
	Evaluation_period: "Summary Evaluation periodiption for {PARSE_Evaluation period}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PARSE_EVAL_PER
	inherit
		PARSING_STRATEGY
create
	make
feature {NONE}
	make
	do
		error := sh_classes.init_error
		obtained_data := false
		create string_err.make_empty
	end

feature
	parseRow ( row : ROW)
			local
				row_temp : ROW
				Evaluation_period: STRING
				i : INTEGER
				pf_eval : PF_EVAL_PER
			do

						row_temp := row
							if row_temp.matches_regex("^\s*(?i)Evaluation\s*(?i)Period\s*:?\s*.*$") then -- field only contain
							--   keyword Evaluation period but does not contains contents

								if row_temp.is_empty_from (row_temp.index_of ("Evaluation")+1) then
									-- the line does not contain any contents
									string_err := "Evaluation period field is empty on line" + row_temp.number.out+". only Evaluation period keyword is found.%N"
								else
									 -- contains contents	
											if row_temp.matches_regex (
											"(\d{4}-\d{2}-\d{2}|\d{2}/\d{2}/\d{4})\s*(to)?\s*(\d{4}-\d{2}-\d{2}|\d{2}/\d{2}/\d{4})*\s*") then
												-- the fields contain contents
												create Evaluation_period.make_empty
													across row_temp.capture_strings_in_row ("(\d{4}-\d{2}-\d{2}|\d{2}/\d{2}/\d{4})\s*(to)?\s*(\d{4}-\d{2}-\d{2}|\d{2}/\d{2}/\d{4})*\s*") as
													c loop Evaluation_period := Evaluation_period + c.item + " " end
												create pf_eval.make(Evaluation_period)
												obtained_data := true
											else
												-- the fields have empty string
												string_err := "Evaluation period is invalid on line" + row_temp.number.out+". make sure to have the right date format.%N"

											end
								end

							end
							if row_temp.matches_regex("^\s*(?i)Evaluation\s*(?i)Period\s*:?\s*(\d{4}-\d{2}-\d{2}|\d{2}/\d{2}/\d{4})\s*(to)?\s*(\d{4}-\d{2}-\d{2}|\d{2}/\d{2}/\d{4})$") then
							-- this contains keyword Evaluation period and content might be the same Evaluation period's field or spread over fields
								if row_temp.is_empty_from (row_temp.index_of ("Evaluation")+1)  then
									-- the content and Evaluation period are on same field as Evaluation period
									Evaluation_period := row_temp[row_temp.index_of ("Evaluation")].out
								else
									-- the content and Evaluation period are on different  field of Evaluation period
									Evaluation_period := row[row_temp.index_of ("Evaluation")].out
									from
										i := row_temp.index_of ("Evaluation")+1;
									invariant
										i >= row_temp.index_of ("Evaluation")+1
										i <= row_temp.contents.capacity +1
									until
										i > row_temp.contents.capacity
									loop
										Evaluation_period :=Evaluation_period +  row_temp[i].out
										i := i + 1
									variant
										row_temp.contents.capacity +1 - i
									end

								end
								create pf_eval.make(Evaluation_period)
								obtained_data := true
							end

			end

	is_successfully_obtain_data : BOOLEAN
	do
		result := obtained_data
	end
	detect_error
			-- detect errors and call error class
	do
			if not string_err.is_empty then
				error.error_custom(string_err)
			end
	end

feature {NONE}
	sh_classes : SHARED_CLASSES
	string_err : STRING
	error : ERROR_TYPE
	obtained_data : BOOLEAN
end
