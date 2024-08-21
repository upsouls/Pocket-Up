

local cls = require 'core.class'

local menu = cls.class(require 'core.scene')

function menu:constructor(context)
	self.baseclass.constructor(self, context)
end

function menu:create()
	local text = display.newText("Text", 100, 100, nil, 30)
	self:addview(text)
end

return menu