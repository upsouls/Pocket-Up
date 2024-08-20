local bitmap = require 'plugin.memoryBitmap'

local M = {}

M.new = function(width, height)
	M.canvasRect = {}
	M.canvasTexture = bitmap.newTexture({
		width = width,
		height = height,
		format = "rgba"
	})

	M.canvasRect = display.newImageRect(
		M.canvasTexture.filename,
		M.canvasTexture.baseDir,
		width, height
	)
end

M.update = function()
	M.canvasTexture:invalidate()
end

M.pixel = function(x, y, r, g, b, a)
	r = r > 1 and math.round(r / 255) or r
	g = g > 1 and math.round(g / 255) or g
	b = b > 1 and math.round(b / 255) or b
	a = a > 1 and math.round(a / 255) or a

	M.canvasTexture:setPixel(x, y, r, g, b, a)

	M.canvasTexture:setPixel(x+1, y, r, g, b, a)
	M.canvasTexture:setPixel(x, y+1, r, g, b, a)
	M.canvasTexture:setPixel(x-1, y, r, g, b, a)
	M.canvasTexture:setPixel(x, y-1, r, g, b, a)
end

M.line = function(x0, y0, x1, y1)
	local max = math.max(x0, x1)
	local min = math.min(x0, x1)
	x0 = min
	x1 = max 
	local deltax = math.round(math.abs(x1 - x0))
	local deltay = math.round(math.abs(y1 - y0))
	local error = 0
	local deltaerr = (deltay + 1)
	local y = y0
	local diry = math.round(y1 - y0)
	if diry > 0 then
		diry = 1
	end
	if diry < 0 then
		diry = -1
	end
	for x = x0, x1 do
		M.pixel(x, y, 1, 0, 0, 1)
		error = error + deltaerr
		if error >= (deltax + 1) then
			y = y + diry
			error = error - (deltax + 1)
		end
	end
end

return M