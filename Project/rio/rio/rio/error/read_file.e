note
	description: "Summary description for {READ_FILE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

frozen class
	READ_FILE
inherit ANY
create {SHARED_CLASSES}
	make
feature {NONE}

	make  do
	end
feature
	open_file ( path : STRING)
	require
		path_not_void: path /= void
	do
			create csv_doc.make_from_file_name (path)
	end

	init_new_cursor : CSV_DOC_ITERATION_CURSOR
	require
		file_reachable : is_path_valid
	do
		Result := csv_doc.new_cursor
		ensure
			Result /= void
	end


	is_path_valid : BOOLEAN
	do
		Result := csv_doc.stream.is_open_read
		ensure
			Result = csv_doc.stream.is_open_read
	end
feature {NONE }
	csv_doc : CSV_DOCUMENT
end
