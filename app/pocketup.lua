--[[
	
]]

local cls = require 'core.class'

local pocketup  = cls.class(require 'core.application')

function pocketup:constructor()
	self.baseclass.constructor(self)

end

function pocketup:create()
	self.baseclass.create(self)

	self.context.preferences:load()
	self.context.preferences:put("test", 123)
	self.context.preferences:save()

	self.context.scenes.menu = require('app.ui.menu')(self.context)

	self.context.scene_manager:open(self.context.scenes.menu)
end

return pocketup