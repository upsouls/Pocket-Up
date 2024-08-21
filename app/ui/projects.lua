

local cls = require 'core.class'

local projects = cls.class(require 'core.scene')

function projects:constructor(context)
	self.baseclass.constructor(self, context)
end

function projects:create()
	local text = display.newText("Text2", 100, 100, nil, 30)
	self:addview(text)
end

return menu