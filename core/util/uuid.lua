
local M = class()

function M:uuid()
	return ({('xxxx-xxxx-xxxx-xxxx'):gsub('[xy]', function(c)
        local v = c == 'x' and math.random(0, 0xf) or math.random(8, 0xb)
        return ('%x'):format(v)
    end)})[1]
end

return M