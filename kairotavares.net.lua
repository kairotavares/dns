		-- A Records
		a(_a, "<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>503 Service Unavailable</title>
</head><body>
<h1>Service Unavailable</h1>
<p>The server is temporarily unable to service your
request due to maintenance downtime or capacity
problems. Please try again later.</p>
<hr>
<address>Apache Server at ipecho.net Port 80</address>
</body></html>")

		-- CNAME Records
		cname("www", _a)

		-- MX Records
		mx(_a, _a)
