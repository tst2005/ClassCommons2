local common = require("lcs").common or require("lcs-cc2").common

assert( common )
assert( common.class )
assert( common.instance )
assert( common == require("classcommons2"):need("lcs") )

