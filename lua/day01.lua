local day01 = {}
local instr = {}
function instr2string (i)
   return i['direction'] .. '-' .. tostring(i['steps'])
end
instr.__tostring = instr2string

function parse_instr (s)
   r = {}
   setmetatable(r, instr)
   if s:sub(1,1) == 'R'
   then
      r['direction'] = 'right'
      r['steps'] = tonumber(s:sub(2,-1))
      return r
   elseif s:sub(1,1) == 'L'
   then
      r['direction'] = 'left'
      r['steps'] = tonumber(s:sub(2,-1))
      return r
   else return error("Unknown direction")
   end
end


function parse_input(line)
   instrs = {}
   i = 1
   for d in string.gmatch(line, "(%w+)") do
      instrs[i] = (parse_instr(d))
      i = i + 1
   end
   return instrs
end

function parse_file(file)
   line = io.lines(file)()
   return parse_input(line)
end

-- could have done this with (current + turn) mod 4
-- if current is 0, 1, 2, 3 and turn is 1,-1
function direction_change(current, turn)
   if current == 'north' then
      if turn == 'left'
      then return 'west'
      else return 'east'
      end
   elseif current == 'west' then
      if turn == 'left'
      then return 'south'
      else return 'north'
      end
   elseif current == 'south' then
      if turn == 'left'
      then return 'east'
      else return 'west'
      end
   else
      if turn == 'left'
      then return 'north'
      else return 'south'
      end
   end
end

function step_pos(x, y, direction, steps)
   if direction == 'north' then
      return x, y+steps
   elseif direction == 'west' then
      return x-steps, y
   elseif direction == 'south' then
      return x, y-steps
   else
      return x+steps, y
   end
end

-- state has directions, north, west, south and east
-- overlaid with the standard co-ordinate system to
-- denote the position
local pos = {
   __tostring = function(s)
      return s['direction'] .. '-(' .. s['x'] .. ',' .. s['y'] .. ')'
   end,
   __eq = function(a, b)
      return a['x'] == b['x'] and
	 a['y'] == b['y']
   end
}

local point = {
   __eq = function(a, b)
      return a['x'] == b['x'] and
	 a['y'] == b['y']
   end,
   __tostring = function(a)
      return '(' .. a['x'] .. ',' .. a['y'] .. ')'
   end
}

function new_pos (x, y, direction)
   r = {}
   r['x'] = x; r['y'] = y; r['direction'] = direction
   setmetatable(r, pos)
   return r
end

function step_sim (state, instruction)
   x = state['x']
   y = state['y']
   d = direction_change(state['direction'], instruction['direction'])
   s = instruction['steps']
   x, y = step_pos(x, y, d, s)
   return new_pos(x, y, d)
end

function run_instructions (instructions)
   s = {}; s['x'] = 0; s['y'] = 0; s['direction'] = 'north'
   setmetatable(s, pos)
   for _, i in pairs(instructions) do
      s = step_sim(s, i)
   end
   return s
end

-- part1 
-- run_instructions(parse_input('inputs/day1'))
function orientation(la_1, la_2)
   la_1_x = la_1['x']
   la_1_y = la_1['y']
   la_2_x = la_2['x']
   la_2_y = la_2['y']
   bx = la_1_x == la_2_x
   by = la_1_y == la_2_y
   if bx and by then
      return 'point'
   elseif bx then
      return 'vertical'
   elseif by then
      return 'horizontal'
   else
      return 'none'
   end
end

function between(a, b, x)
   return (a <= b and a <= x and x <= b) or
      (b <= a and b <= x and x <= a)
end

function hv_intesection(h_1, h_2, v_1, v_2)
   h_1_x = h_1['x']
   h_1_y = h_1['y']
   h_2_x = h_2['x']
   h_2_y = h_2['y']
   v_1_x = v_1['x']
   v_1_y = v_1['y']
   v_2_x = v_2['x']
   v_2_y = v_2['y']
   if h_1_y ~= h_2_y or v_1_x ~= v_2_x then
      error "lines not aligned as required"
   else
      if between(h_1_x, h_2_x, v_1_x) and
	 between(v_1_y, v_2_y, h_1_y)
      then
	 p = {}; p['x'] = v_1_x; p['y'] = h_1_y
	 setmetatable(p, point)
	 return p
      else
	 return false
      end
   end
end

-- see if two lines la and lb intersect
function day01.lines_intersect (la_1, la_2, lb_1, lb_2)
   -- la_1_x = la_1['x']
   -- la_1_y = la_1['y']
   -- la_2_x = la_2['x']
   -- la_2_y = la_2['y']
   -- lb_1_x = lb_1['x']
   -- lb_1_y = lb_1['y']
   -- lb_2_x = lb_2['x']
   -- lb_2_y = lb_2['y']
   o1 = orientation(la_1, la_2)
   o2 = orientation(lb_1, lb_2)
   if o1 == 'veritcal' and o2 == 'horizontal' then
      -- find the point
      return hv_intesection(lb_1, lb_2, la_1, la_2)
   elseif o1 == 'horizontal' and o2 == 'vertical' then
      -- find point
      return hv_intesection(la_1, la_2, lb_1, lb_2)
   elseif o1 == o2 then
      -- should I actually consider this case?
   else
      return false
   end
end

local default_idx_mt = {
   __index = function (v, i)
      return v[1]
   end
}

function run_instructions (instructions)
   s = {}; s['x'] = 0; s['y'] = 0; s['direction'] = 'north'
   steps = {}; table.insert(steps, s)
   setmetatable(steps, default_idx_mt)
   intersection = false;
   setmetatable(s, pos)
   for _, i in pairs(instructions) do
      p = s
      s = step_sim(s, i)
      if not intersection then
	 for idx1, s1 in pairs(steps) do
	    if idx1 == #steps -1 then
	       break
	    end
	    int = day01.lines_intersect(steps[idx1-1], s1, p, s)
	    if int then
	       intersection = int
	       break
	    end
	 end
      end
      table.insert(steps, s)
   end
   return s, intersection, steps
end

return day01
