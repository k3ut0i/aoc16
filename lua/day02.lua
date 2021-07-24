local day02 = {}
u = require('util')
--[[
   We will represent the direction by numbers, such that it can be easily
converted to co-ordinate diffs
   1 = (0, 1) north
   2 = (1, 0) east
   -1 = (0, -1) south
   -2 = (-1, 0) west
   now x = sig(n) * int(n/2), y = sig(n) * n mod 2
]]
function parse_dir (c)
   if (c == 'U') then return 1
   elseif (c == 'L') then return -2
   elseif (c == 'D') then return -1
   elseif (c == 'R') then return 2
   else
      error("Unknown direction character: [" .. c .. "].")
   end
end

function sign(n)
   return n >= 0 and 1 or -1
end

function dir2point (d)
   if d == 1 then
      return 0, 1
   elseif d == 2 then
      return 1, 0
   elseif d == -1 then
      return 0, -1
   else
      return -1, 0
   end
end

function day02.parse_line (line)
   r = {}
   for c in string.gmatch(line, ".") do
      table.insert(r, parse_dir(c))
   end
   return r
end

function day02.parse_file (file)
   lines = io.lines(file)
   t = {}
   for l in lines do
      table.insert(t, day02.parse_line(l))
   end
   return t
end

--[[
   step the point *p* in the direction *i* only if the new point
satisifies the function f
]]
function day02.step (p, i, f)
   local dx, dy = dir2point(i)
   px_new = p.x + dx
   py_new = p.y + dy
   if f(px_new, py_new) then
      p.x = px_new
      p.y = py_new
   end
   return p
end

function constraint_1(x, y)
   return u.between(-1, x, 1) and u.between(-1, y, 1)
end

function constraint_2(x, y)
   return u.between(0, math.abs(x) + math.abs(y),2)
end

function data_1(x, y)
   return 5 - 3 * y + x
end

--[[
   Is there a better way to write this data_2 decoder?
I gave up when implementing mercury too 
]]
function data_2(x, y)
   if y == 2 and x == 0 then
      return 1
   elseif y == 1 then
      return x + 3
   elseif y == 0 then
      return x + 7
   elseif y == -1 then
      return x + 11
   elseif y == -2 and x == 0 then
      return 13
   else
      error "Unknown data point"
   end
end

function find_code(x_i, y_i, constraint, data, input)
   p = {x = x_i, y = y_i}
   r1 = {}
   for _, i in pairs(input) do
      p = day02.step(p, i, constraint)
   end
   return p, data(p.x, p.y)
end

function day02.part1 (is)
   rs = {} ; p = {x = 0, y = 0}
   for _, i in pairs(is) do
      p, r = find_code(p.x, p.y, constraint_1, data_1, i)
      table.insert(rs, r)
   end
   return rs
end

function day02.part2 (is)
   rs = {} ; p = {x = 0, y = 0}
   for _, i in pairs(is) do
      p, r = find_code(p.x, p.y, constraint_2, data_2, i)
      table.insert(rs, r)
   end
   return rs
end

return day02
