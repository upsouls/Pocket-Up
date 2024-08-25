
local uuid_gen = require('core.util.uuid')()

local scene = class()

function scene:_init()
	self.group = display.newGroup()
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

function scene:isActive()
	return self.group.isVisible
end

function scene:get(name)
	return self.layout[name]
end

function scene:addView(object, name, listener)
	object.uuid = name or uuid_gen.uuid()

	self.layout[object.uuid] = object
	self.group:insert(object)

	self:addTouchCallback(object, listener)
end

function scene:addTouchCallback(object, listener)
	if listener and self.handler then
		object:addEventListener('touch', function (e)
				listener(self.handler, e)
			end)
	elseif listener then
		object:addEventListener('touch', listener)
	end
end

function scene:removeView(object)
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