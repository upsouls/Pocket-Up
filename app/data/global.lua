class = require('core.class').class

hex = function(hex)
	local r, g, b = hex:gsub('#', ''):match('(..)(..)(..)')
	return tonumber(r, 16) / 255, tonumber(g, 16) / 255, tonumber(b, 16) / 255
end