d = require('day04')

do -- parse tests
   local n, i, c = d.parse_line("aaaaa-bbb-z-y-x-123[abxyz]")
   assert(n == "aaaaa-bbb-z-y-x")
   assert(i == 123)
   assert(c == "abxyz")
end

do -- checksum tests
   local exs = {"aaaaa-bbb-z-y-x-123[abxyz]",
		"a-b-c-d-e-f-g-h-987[abcde]",
		"not-a-real-room-404[oarel]"}
   for _, ex in pairs(exs) do
      local s, n, c = d.parse_line(ex)
      assert(d.checksum(s) == c, string.format("example: %s", ex))
   end
   assert(d.checksum("totally-real-room") ~= "decoy")
end

-- c, t = d.all('inputs/day4')
-- check the table t for the phrase north pole
