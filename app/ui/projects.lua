

local projects = class(require 'core.scene')

function projects:constructor(context)
	self.baseclass.constructor(self, context)
end

function projects:create()
	local text = display.newText("Text2", 100, 100, nil, 30)
	text:addEventListener('touch', function(e)
		if e.phase == 'began' then
			self.context.scene_manager:open(self.context.scenes.menu)
		end
	end)
	self:addview(text)
end

return projects