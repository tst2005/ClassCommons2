--local cc2 = require("classcommons2")
--local common = cc2:need("foo") or cc2:need("middleclass") or cc2:need("secs") or cc2:need("bar")

local cc2 = require("classcommons2")
local common = cc2:requireany("foo", "middleclass", "secs", "bar")
assert( type(common) == "table")
assert( common.__BY == "middleclass" )

local common = cc2:requireany( {"foo", "lcs", "middleclass", "secs", "bar"} )
assert( type(common) == "table")
assert( common.__BY == "lcs" )

local cc2 = require("classcommons2")
local ok = pcall(function()
	 cc2:requireany("foo", "bar")
end)
assert(not ok, "an error should be raised (no implementation found)")


