day04 = {}

function day04.parse_line (s) -- export to test parsing 
   local name, id, chksum = string.match(s, "([%w-]+)-(%d+)%[(%w+)%]")
   return name, tonumber(id), chksum
end

local function char_count (s)
   t = {}
   setmetatable(t, { __index = function (n) return 0 end})
   for c in string.gmatch(s, '.') do
      if c ~= '-' then
	 t[c] = t[c] + 1
      end
   end
   return t
end

function day04.checksum (s)
   local count = char_count(s)
   local t = {}
   for c, n in pairs(count) do
      table.insert(t, c .. tostring(n))
   end
   table.sort(t, function(a, b)
		 local ac = string.sub(a, 1, 1)
		 local an = tonumber(string.sub(a, 2))
		 local bc = string.sub(b, 1, 1)
		 local bn = tonumber(string.sub(b, 2))
		 return an > bn or an == bn and ac < bc
   end)
   local r = ''
   for i=1,5 do
      r = r .. string.sub(t[i], 1, 1)
   end
   return r
end

local function shift_char(char, num)
   i = ((string.byte(char, 1, 1) - 97 + num) % 26) + 97
   return string.char(i)
end

local function decode(str, num)
   r = ''
   for c in string.gmatch(str, '.') do
      b = string.byte(c, 1, 1)
      if 97 <= b and b <= 122 then
	 r = r .. shift_char(c, num)
      else
	 r = r .. c
      end
   end
   return r
end

function day04.all (file)
   sum = 0; decoded = {}
   for l in io.lines(file) do
      local name, id, chk = day04.parse_line(l)
      if day04.checksum(name) == chk then
	 sum = sum + id
	 decoded[id] = decode(name, id)
      end
   end
   return sum, decoded
end

return day04
