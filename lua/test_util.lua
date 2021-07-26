u = require('util')

assert(u.count_array(function (x) return x < 5 end, {2, 4, 6, 8, 10}), 2)
