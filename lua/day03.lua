local day03 = {}

function day03.trianglep (a, b, c)
   return a < b + c and b < c + a and c < a + b
end

local function read_triple(l)
   local a, b, c = string.match(l, "(%d+)%s+(%d+)%s+(%d+)")
   return tonumber(a), tonumber(b), tonumber(c)
end

function day03.part1 (file)
   r = 0
   for l in io.lines(file) do
      local a, b, c = read_triple(l)
      if day03.trianglep(a, b, c) then
	 r = r + 1
      end
   end
   return r
end

local function read_columns (file)
   local c1, c2, c3 = {}, {}, {}
   for l in io.lines(file) do
      local a, b, c = read_triple(l)
      table.insert(c1, a)
      table.insert(c2, b)
      table.insert(c3, c)
   end
   return c1, c2, c3
end

--[[
   I have misundestood the problem again. I tried for all possible
triangles with those given numbers not just in batch of three. I made
the same mistake during my first implementation in mercury.
Total possible triangles this way are 458181813	439735390 460416473
per column
]]
local function num_triangles_wrong (nums)
   table.sort(nums)
   local l = #nums
   local count = 0
   for i=1,l do
      for j=i,l do
	 for k=j,l do
	    if nums[k] < nums[i] + nums[j] then
	       count = count + 1
	    end
	 end
      end
   end
   return count
end

function day03.num_triangles (nums)
   local l = #nums
   local count = 0
   for i = 1, math.floor(l/3) do
      if day03.trianglep(nums[3*i-2], nums[3*i-1], nums[3*i]) then
	 count = count + 1
      end
   end
   return count
end

function day03.part2 (file)
   local a, b, c = read_columns(file)
   return day03.num_triangles(a),
      day03.num_triangles(b),
      day03.num_triangles(c)
end

return day03
