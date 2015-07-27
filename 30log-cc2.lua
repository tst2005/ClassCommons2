local class = require "30log"

local common = {}
common.class = function(name, prototype, parent)
        local klass = class():extends(parent):extends(prototype)
        klass.__init = prototype.init or (parent or {}).init
        klass.__name = name
        return klass
end
common.instance = function(class, ...)
        return class:new(...)
end
common.__BY = "30log"
local _M = {common = common}

assert(
pcall(function() require("classcommons2"):register("30log", common) end)
)

return setmetatable(_M, {__call = function(self, ...) return class(...) end})
