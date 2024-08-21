local M = {}

M.uuid = function()
	return ({('xxx-xxx-xxx-xxx'):gsub('[xy]', function(c)
        local v = c == 'x' and math.random(0, 0xf) or math.random(8, 0xb)
        return ('%x'):format(v)
    end)})[1]
end

return M