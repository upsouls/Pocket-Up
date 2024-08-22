

local cls = require 'core.class'

local menu = cls.class(require 'core.scene')

function menu:constructor(context)
	self.baseclass.constructor(self, context)
end

function menu:create()
	local text = display.newText("Text", 100, 100, nil, 30)
	text:addEventListener('touch', function(e)
		if e.phase == 'began' then
			self.context.scenes.projects = require('app.ui.projects')(self.context)
			self.context.scene_manager:open(self.context.scenes.projects)
		end
	end)
	self:addview(text)
end

return menu