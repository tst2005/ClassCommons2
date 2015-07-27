
local lcs = require "lcs"

local common = {}
common.class = function(name, prototype, parent)
	-- FILL ME
end
common.instance = function(class, ...)
	-- FILL ME
end
common.__BY = "lcs"

pcall(function() require("classcommons2"):register("lcs", common) end)

return {common = common}
