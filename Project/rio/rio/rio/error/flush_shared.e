note
	description: "Summary description for {FLUSH_SHARED}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FLUSH_SHARED

create
	make

feature
	make
	do

	end

feature
	flushAll
		local
			pd : PORTFOLIO_DATA
			er : ERROR_TYPE
			rf : READ_FILE
		do
			pd := sh_classes.init_portfolio_data
			er := sh_classes.init_error
			rf := sh_classes.init_file_read

			pd.flush
			er.flush
			rf.flush
		end

feature {FLUSH_SHARED}
	sh_classes : SHARED_CLASSES

end
