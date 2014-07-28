note
	description: "Summary description for {PF_GEN_INFO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

frozen class
	PF_GEN_INFO

inherit

	PF_DATATYPE

create
	make

feature

	make
		do
			create gen_info.make (0)
		end

feature -- inherited routines

	getvalue: LIST [STRING]
		do
			Result := gen_info.twin
		end

	exists: BOOLEAN
		do
		end

	print_info
		do
			across
				gen_info as c
			loop
				io.put_string (c.item + "%N")
			end
		end

feature {PARSING_STRATEGY} -- add info routines

	add_name (name: STRING)
		local
		do
			if name.has_substring ("Name") or name.has_substring ("name") then
				gen_info.extend ("Name " + name.substring (5, name.count))
			else
				gen_info.extend ("Name: " + name)
			end
		end

	add_decr (decr: STRING)
		local
		do
			if decr.has_substring ("Description") or decr.has_substring ("description") then
				gen_info.extend ("Description " + decr.substring (12, decr.count))
			else
				gen_info.extend ("Description: " + decr)
			end
		end

	add_email (email: STRING)
		do
			if email.has_substring ("Email") or email.has_substring ("email") then
				gen_info.extend ("Email " + email.substring (6, email.count))
			else
				gen_info.extend ("Email: " + email)
			end
		end

	add_phone (Phone: STRING)
		do
			if Phone.has_substring ("Phone") or Phone.has_substring ("phone") then
				gen_info.extend ("Phone " + Phone.substring (6, Phone.count))
			else
				gen_info.extend ("Phone: " + Phone)
			end
		end

	add_addr (addr: STRING)
		do
			if addr.has_substring ("Address") or addr.has_substring ("address") then
				gen_info.extend ("Address " + addr.substring (8, addr.count))
			else
				gen_info.extend ("Address: " + addr)
			end
		end

	add_account (account: STRING)
		do
			if account.has_substring ("Account") or account.has_substring ("account") then
				gen_info.extend ("Account" + account.substring (8, account.count))
			else
				gen_info.extend ("Account#: " + account)
			end
		end

feature {NONE}

	gen_info: ARRAYED_LIST [STRING]

end
