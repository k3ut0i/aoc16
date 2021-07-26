util = {}
util.array_mt = {
   __eq = function(a, b)
      if #a == #b then
	 for i, e in pairs(a) do
	    if e ~= b[i] then
	       return false
	    end
	 end
	 return true
      end
   end
}

util.point_mt = {
   __eq = function(a, b)
      return a.x == b.x and a.y == b.y
   end,
   __tostring = function(a)
      return '(' .. a.x .. ',' .. a.y .. ')'
   end
}

function util.print_array(a)
   for _, i in pairs(a) do
      print(i)
   end
end

function util.print_pairs(a)
      for i, e in pairs(a) do
      print(i, e)
   end
end

function util.between(a, x, b)
   return a <= x and x <= b
end

function util.map(f, t)
   r = {}
   for _, e in pairs(t) do
      table.insert(r, f(e))
   end
   return r
end

function util.count_array(f, t)
   r = 0
   for _, e in pairs(t) do
      if f(e) then r = r + 1 end
   end
   return r
end

return util
