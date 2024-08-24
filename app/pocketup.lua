--[[
	
]]
local pocketup  = class(require 'core.application')

function pocketup:constructor()
	self.baseclass.constructor(self)
	self.context.assets = require 'resources.assets'
	self:_loadstrings()
end

function pocketup:_loadstrings()
	self.context.str = require('app.data.strings.' .. self.context.lang)
end

function pocketup:create()
	self.baseclass.create(self)

	self.context.scenes.menu = require('app.ui.menu')(self.context)

	self.context.scene_manager:open(self.context.scenes.menu)
end

return pocketup