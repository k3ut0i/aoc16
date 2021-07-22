local d = require('day01')
local point = {
   __eq = function(a, b)
      return a['x'] == b['x'] and
	 a['y'] == b['y']
   end
}

local p1 = {}; p1['x'] = 0; p1['y'] = 0;
local p2 = {}; p2['x'] = 2; p2['y'] = 0;
local p3 = {}; p3['x'] = 1; p3['y'] = -1;
local p4 = {}; p4['x'] = 1; p4['y'] = 1;
local pr = {}; pr['x'] = 1; pr['y'] = 0;
setmetatable(pr, point)
local p = d.lines_intersect(p1, p2, p3, p4);
setmetatable(p, point)
assert(p == pr);

local ex_in = "R8, R4, R4, R8"
local final, intersection, steps = run_instructions(parse_input(ex_in))
print(intersection['x'], intersection['y'])
