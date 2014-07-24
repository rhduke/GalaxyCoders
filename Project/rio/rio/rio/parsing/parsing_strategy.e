note
	description: "Summary description for {PARSING_STRATEGY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PARSING_STRATEGY
feature
	parseRow ( row : ROW)
			-- extract the information from row
		require
			row_not_void : row /= void
		deferred
		end

	is_successfully_obtain_data : BOOLEAN
			-- did the class successfully obtain  the data from row
		deferred
		ensure
			not_void : result /= void
		end
feature {NONE} -- note this
	sh_classes : SHARED_CLASSES deferred end

end
