
local json = require 'core.util.json'

local M = class()

function M:_init(filename)
	self.prefrencesData = {}
	self.prefrencesPath = system.pathForFile(filename or 'prefrences.data', system.DocumentsDirectory)
end

function M:put(key, value)
	self.prefrencesData[key] = value
end

function M:get(key)
	return self.prefrencesData[key]
end

function M:save()
	local file = io.open(self.prefrencesPath, 'w')
	file:write(json.encode(self.prefrencesData))
	file:close()
end

function M:clear()
	self.prefrencesData = {}
end

function M:load()
	local file = io.open(self.prefrencesPath, 'r')
	if file then
		self.prefrencesData = json.decode(file:read('*a'))
		file:close()
	end
end

return M