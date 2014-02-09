		-- A Records
		a(_a, "${EXTERNAL_IP_CMDS1}")

		-- CNAME Records
		cname("www", _a)

		-- MX Records
		mx(_a, _a)
