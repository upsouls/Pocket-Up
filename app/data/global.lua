class = require('core.class').class

hex = function(hex)
	local r, g, b = hex:gsub('#', ''):match('(..)(..)(..)')
	return tonumber(r, 16) / 255, tonumber(g, 16) / 255, tonumber(b, 16) / 255
end


table.removeByValue = function(tabl, value)
	for k, v in pairs(tabl) do
		if v == value then
			tabl[k] = nil
		end
	end
end