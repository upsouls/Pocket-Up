
local json = require 'core.util.json'

local M = class()

function M:constructor(filename)
	self.prefrences_data = {}
	self.prefrences_path = system.pathForFile(filename or 'prefrences.data', system.DocumentsDirectory)
end

-- TODO: сделать assert на тип userdata
function M:put(key, value)
	self.prefrences_data[key] = value
end

function M:get(key)
	return self.prefrences_data[key]
end

function M:save()
	local file = io.open(self.prefrences_path, 'w')
	file:write(json.encode(self.prefrences_data))
	file:close()
end

function M:clear()
	self.prefrences_data = {}
end

function M:load()
	local file = io.open(self.prefrences_path, 'r')
	if file then
		self.prefrences_data = json.decode(file:read('*a'))
		file:close()
	end
end

return M