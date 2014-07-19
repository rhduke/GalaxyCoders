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



end
