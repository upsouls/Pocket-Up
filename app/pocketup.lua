--[[
	Да, я люблю ООП
]]

local cls = require 'core.class'

local pocketup  = cls.class(require 'core.application')

function pocketup:constructor()
	self.baseclass.constructor(self)

	self.scenes = {}
end

function pocketup:create()
	self.baseclass.create(self)

	self.scenes.menu = require('app.ui.menu')(self.context)
	self.scenes.projects = require('app.ui.projects')

	self.context.scene_manager:open(self.scenes.menu)
end

return pocketup