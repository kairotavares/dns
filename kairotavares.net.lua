-- File: example.com.lua
-- Variable _a is replaced with zone name by LuaDNS
-- _a = "example.com"

-- A Records
a(_a, "201.9.70.20")

-- CNAME Records
cname("www", _a)

-- MX Records
mx(_a, _a)
