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
		csv_iteration_cursor := csv_doc.new_cursor
	ensure
		doc_is_not_void
	end

	is_end_of_file : BOOLEAN
	require
		not_void : doc_is_not_void
	do
		result := csv_iteration_cursor.after
	ensure
		result = csv_iteration_cursor.after
	end

	get_cursor : CSV_DOC_ITERATION_CURSOR
	do
		result := csv_iteration_cursor.twin
	end

	doc_is_not_void : BOOLEAN
	do
		Result := csv_doc /= void
	ensure
		Result = csv_doc /= void
	end
feature {NONE }
	csv_doc : CSV_DOCUMENT
	csv_iteration_cursor: CSV_DOC_ITERATION_CURSOR
end
