

local menu = class(require 'core.scene')

function menu:constructor(context)
	self.baseclass.constructor(self, context)
end

function menu:create()
	local background = display.newRect(
			self.context.x,
			self.context.y,
			self.context.width,
			self.context.height
		)
	background:setFillColor(hex("#00475D"))
	local toolbar_height = not self.context.isSim and display.statusBarHeight * 1.55 or 50 * 1.55
	local toolbar = display.newRect(
			self.context.x,
			self.context.top + toolbar_height / 2,
			self.context.width,
			toolbar_height
		)
	toolbar:setFillColor(hex("#002B3B"))

	self:addview(background)
	self:addview(toolbar)
end

return menu