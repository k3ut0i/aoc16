d = require('day02')
u = require('util')
-- assert(u.array_mt.__eq({2, 1, -2, -1, 2}, d.parse_line("LURDL")))

ex_str = {"ULL", "RRDDD", "LURDL", "UUUUD"}
-- ex_in = u.map(d.parse_line, ex_str)
ex_in = {}
for _, i in pairs(ex_str) do
   table.insert(ex_in, d.parse_line(i))
end
u.print_array(d.part1(ex_in))

-- part1
-- u.print_array(d.part1(d.parse_file('inputs/day2')))

-- part2
-- u.print_array(d.part2(d.parse_file('inputs/day2')))
