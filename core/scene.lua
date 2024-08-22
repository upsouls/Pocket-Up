
local uuid_gen = require('core.util.uuid')()

local scene = class()

scene.isinflated = false

function scene:constructor(context)
	self.context = context
	self.isinflated = true
	self.group = display.newGroup()
	self:hide()
	self.layout = {}
	self:create()
end

function scene:create()
	
end

function scene:show()
	self.group.isVisible = true
end

function scene:hide()
	self.group.isVisible = false
end

function scene:destroy()
	self.group:removeSelf()
	self.group = nil
end

function scene:isactive()
	return self.group.isVisible
end

function scene:addview(object, listener, name)
	if listener and type(listener) == "function" then
		object:addEventListener('touch', listener)
	end
	object.uuid = name or uuid_gen.uuid()
	self.layout[object.uuid] = object
	self.group:insert(object)
end

function scene:removeview(object)
	if type(object) == "string" then
		local obj = self.layout[object]
		self.layout[object] = nil
		self.group:remove(obj)
		return
	end
	self.layout[object.uuid] = nil
	self.group:remove(object)

end

return scene