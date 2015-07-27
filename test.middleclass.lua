local common = require("middleclass").common or require("middleclass-cc2").common

assert( common )
assert( common.class )
assert( common.instance )
assert( common == require("classcommons2"):need("middleclass") )

