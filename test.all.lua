
local all = {"middleclass", "secs", "30log", "lcs", "hump.class"}
--require "strict"

for i,modname in ipairs(all) do
	local ok, err = pcall(function()
		require(modname.."-cc2")
	end)
	if ok then
		print("- "..modname.."-cc2 loaded.")
	else
		require(modname)
		print("- "..modname.." loaded.")
	end

end

local cc2 = require("classcommons2")
--print( table.concat( cc2.available(), " ") )

local function  checkthis(name)
	local common = require("classcommons2"):need(name)
	local Assert = function(x) if not x then error("test fail for '"..name.."'", 3) end end
	Assert( common)
	Assert( common.class )
	Assert( common.instance )
	Assert( common.__BY == name )
	print("OK: "..name)
end

for i,modname in ipairs(all) do checkthis(modname) end

