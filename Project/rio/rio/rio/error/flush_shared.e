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
			ge : PF_GEN_INFO
		do
			pd := sh_classes.init_portfolio_data
			er := sh_classes.init_error
			ge := sh_classes.init_genaral_info
			if pd /= void then
				pd.flush
			end
			if er /= void then
				er.flush
			end
			if er /= void then
				ge.flush
			end

		end

feature {FLUSH_SHARED}
	sh_classes : SHARED_CLASSES

end
