local common = require("hump.class").common

assert( common )
assert( common.class )
assert( common.instance )
assert( common == require("classcommons2"):need("hump.class") )

