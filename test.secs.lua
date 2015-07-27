local common = require("secs").common or require("secs-cc2").common

assert( common )
assert( common.class )
assert( common.instance )
assert( common == require("classcommons2"):need("secs") )

