--[[
	
]]
local pocketup  = class(require 'core.application')
local language = require('app.data.language')()

function pocketup:_init()
	self.super._init(self)

	ctx.assets = require 'resources.assets'
	ctx.color = require 'app.data.colors'
	ctx.str = language:getTranslation(ctx.app.lang)
end

function pocketup:create()
	self.super.create(self)

	--ctx.sceneManager:goto("projects", {cache=true})
end

return pocketup