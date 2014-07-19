note
	description: "Summary description for {PARSING_CONTEXT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PARSING_CONTEXT
create
	make

feature { NONE } -- class variables
	parsing_strategy : PARSING_STRATEGY

feature -- global access
	SetParsingStrategy(pars_strat : PARSING_STRATEGY)
	require
			not_void : pars_strat /= void
	do
		parsing_strategy := pars_strat

		ensure
			not_void : parsing_strategy /= void

	end

	GetRowInfo ( row : ROW)
	require
			not_void : row /= void
	do
		parsing_strategy.parseRow(row)
	end

feature -- constructor
make do end;

end
