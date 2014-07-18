note
	description: "Summary description for {SHARED_ERROR_TYPE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class
	SHARED_ERROR_TYPE
inherit
ANY

feature
	singlenton : ERROR_TYPE
	once ("PROCESS")
		create result.make
	end
invariant
	inistante_once : singlenton = singlenton


end
