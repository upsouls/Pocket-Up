

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

	local menu = display.newImage(self.context.assets.ic_menu)
		menu.width = toolbar_height * 0.6
		menu.height = toolbar_height * 0.6
		menu.x = self.context.right - 10 - menu.width / 2
		menu.y = toolbar.y

	local help = display.newImage(self.context.assets.ic_question)
		help.width = toolbar_height * 0.6
		help.height = toolbar_height * 0.6
		help.x = menu.x - menu.width - 30
		help.y = toolbar.y

	local app_icon = display.newImage(self.context.assets.app_icon_foreground)
		app_icon.width = toolbar_height * 0.9
		app_icon.height = toolbar_height * 0.9
		app_icon.x = self.context.left + 5 + app_icon.width / 2
		app_icon.y = toolbar.y
	local title = display.newText({
			text = self.context.str.app_name,
			align = "left",
			fontSize = 30,
			font = native.systemFont,
			width = (help.x - help.width/2) - (app_icon.x + app_icon.width/2),
			height = 0,
			x = self.context.left + 10 + app_icon.x + app_icon.width/2,
			y = toolbar.y
		})
		title.anchorX = 0

	local preview = display.newRect(
			self.context.left,
			toolbar_height,
			self.context.width,
			self.context.height * 0.35
		)
		preview.anchorX = 0
		preview.anchorY = 0
		preview:setFillColor(hex("#00171E"))
	local projects_back = display.newRect(
			self.context.left,
			preview.y + preview.height,
			self.context.width,
			100
		)
		projects_back.anchorX = 0
		projects_back.anchorY = 0
		projects_back.alpha = 0

	local projects_front = display.newText({
			text = self.context.str.projects,
			align = "left",
			fontSize = 40,
			font = native.systemFont,
			width = self.context.width,
			height = 0,
			x = self.context.left + 40,
			y = projects_back.y + projects_back.height/2
		})
		projects_front.anchorX = 0

	local projects_arrow = display.newImage(self.context.assets.ic_arrow_right)
		projects_arrow.y = projects_back.y + projects_back.height/2
		projects_arrow.x = self.context.right - 80 - 20
		projects_arrow.width = 80
		projects_arrow.height = 80
	

	local upsouls_back = display.newRect(
			self.context.left,
			projects_back.y + projects_back.height,
			self.context.width,
			100
		)
		upsouls_back.anchorX = 0
		upsouls_back.anchorY = 0
		upsouls_back.alpha = 0

	local upsouls_front = display.newText({
			text = self.context.str.community,
			align = "left",
			fontSize = 40,
			font = native.systemFont,
			width = self.context.width,
			height = 0,
			x = self.context.left + 40,
			y = upsouls_back.y + upsouls_back.height/2
		})
		upsouls_front.anchorX = 0

	local upsouls_arrow = display.newImage(self.context.assets.ic_arrow_right)
		upsouls_arrow.y = upsouls_back.y + upsouls_back.height/2
		upsouls_arrow.x = self.context.right - 80 - 20
		upsouls_arrow.width = 80
		upsouls_arrow.height = 80


	local create_back = display.newCircle(
			self.context.right - 50 - 20,
			self.context.bottom - 50 - 20,
			50
		)
		create_back:setFillColor(hex("#FFAC06"))
	
	local create_front = display.newImage(self.context.assets.ic_plus)
		create_front.x = self.context.right - 50 - 20
		create_front.y = self.context.bottom - 50 - 20
		create_front.width = 50
		create_front.height = 50

	self:addview(background)
	self:addview(toolbar)
		self:addview(menu)
		self:addview(help)
		self:addview(app_icon)
		self:addview(title)
	self:addview(preview)

	self:addview(projects_back)
		self:addview(projects_front)
		self:addview(projects_arrow)
	self:addview(upsouls_back)
		self:addview(upsouls_front)
		self:addview(upsouls_arrow)


	self:addview(create_back)
		self:addview(create_front)
end

return menu