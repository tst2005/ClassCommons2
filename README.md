
My proposal :
 * I'm agree to avoid using global. I prefer the `require` function use
 * I'm agree to keep `common.class` and `common.instance` as introduced in the [ClassCommons 1.0 Specs](https://github.com/bartbes/Class-Commons/blob/master/SPECS.md)
 * <b>Each class system modules MUST have a `common` table item</b>
 * Allow to be able to load different class system implementation (see below)
 * Allow to list and switch between available implementations
 * Allow to load class system implementation that th his original name even if it not following the classcommons recommandation (see below how make an additionnal module to fix)
 * Allow each class system implementation to call classcommons2 module to register it self (recommended, not mandatory)

# Differents cases

## Case 0 : an usual module (without ClassCommons)

File `fooclass.lua` :
```lua
local fooclass = {}
-- define the fooclass stuff
local function new_class()
	-- [...]
end
setmetatable(fooclass, {__call = function(_, ...) return new_class(...) end})
return fooclass -- return the fooclass module
```

## Case 1 : how to modify the module to support ClassCommons2

If the class system module follow the ClassCommons 2.0

 * a loaded module MUST return a table
 * the returned module table MUST contains a `common` item with a table value. This value is the common table
 * like ClassCommons 1.0 the common table MUST have a `class` and `instance` items.
 * the module MAY register itself over the classcommons2 interface

fooclass.lua :
```lua
local fooclass = {}
-- define the fooclass stuff
local function new_class()
	-- [...]
end
setmetatable(fooclass, {__call = function(_, ...) return new_class(...) end})

---------------------------------------------------------------------->8--
-- Setup the ClassCommons common table (See ClassCommons 1.0)
local common = {}
common.class = function(...) end
common.instance = function(...) end

-- Setup the ClassCommons 2.0 interface
fooclass.common = common

-- try to load classcommons2 if available and register the fooclass module
pcall(function() require("classcommons2"):register("fooclass", common) end)
--------------------------------------------------------------------->8--

return fooclass -- return the fooclass module
```

A minimal test suite.

File `test.fooclass.lua` :
```lua
local mod = require "fooclass"
assert( type(mod) == "table" )
local common = mod.common
assert( type(common) == "table" )
assert( common.class and common.instance )
```


## Case 2 : How to support ClassCommons2 with third-party module and keep the original module unchanged

I choose to add a suffix named "-cc2" to the name.
For the original `fooclass` module we need to create a `fooclass-cc2` module.

File `fooclass-cc2.lua` :
```lua
local fooclass = require "fooclass"
local _M = {} -- create a new module (do not change the original fooclass table)

-- Setup the ClassCommons common table (See ClassCommons 1.0)
local common = {}
common.class = function(...) end
common.instance = function(...) end

-- Setup the ClassCommons 2.0 interface
_M.common = common -- inside the compat module

-- try to load classcommons2 if available and register the fooclass module
pcall(function() require("classcommons2"):register("fooclass", common) end)
-- yes, we are fooclass-cc2 but we register as fooclass.

return _M -- return the module (that have a .common element to follow the ClassCommons2 rule)
```

# How to use

## Inside the class system module

```lua
local middleclass = require "middleclass"
local common = middleclass.common
if common then
	print("ClassCommons2 seems available")
else
	print("ClassCommons2 unavailable")
end
```

## Asking classcommons2 to find one

Find one implementation :
```lua
local common = require "classcommons2":need("middleclass")
if common then
	print("ClassCommons2 found")
else
	print("ClassCommons2 not found")
end
```

The `require "classcommons2":need` function never raise error.

## Ask classcommons2 to find one of them

Find the first implementation :
```lua
local common = require "classcommons2":requireany("fooclass", "barclass", "middleclass", "secs", "30log")
-- or
local common = require "classcommons2":requireany{"fooclass", "barclass", "middleclass", "secs", "30log"}

```

The `require "classcommons2":requireany` raise an error if no implementation was found.


# Supported implementations

I tried to make ClassCommons2 support for
 * middleclass (native)
 * secs (native)
 * hump (native)
 * 30log (with 30log-cc2.lua) (but also native)
 * LCS (with lcs-cc2.lua, only for demo with fake `common.class`/`instance`)

Not yet done
 * Slither

test with :
```sh
$ lua test.all.lua
- middleclass loaded.
- secs loaded.
- 30log-cc2 loaded.
- lcs-cc2 loaded.
- hump.class loaded.
OK: middleclass
OK: secs
OK: 30log
OK: lcs
OK: hump.class
```


# TODO / To be defined

 * a way to get a default implementation (I hope to have a `require "classcommons2".common`)
 * did we allow to change the default implementation, and how.
 * I add a `common.__BY` to be able to know which implementation I got.
 * choose a better name for `__BY`
 * define if load (with `need` or `requireany` will automatically register the module found)
 * choose a better name for the module name suffix `-cc2` (maybe something like `-compat` or `-commons2`)

