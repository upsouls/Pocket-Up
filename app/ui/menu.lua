
local menu = class(require 'core.scene')

function menu:_init()
	self.handler = require('app.ui.handler.menu')()

	self.super._init(self)
end

function menu:create()
	local background = display.newRect(
			ctx.app.x, ctx.app.y,
			ctx.app.width, ctx.app.height )
		background:setFillColor(hex(ctx.color.menu.background))

	local actionBar = display.newGroup()
		local actionBarBackground = display.newRect(
				ctx.app.x, ctx.app.top + ctx.app.actionBarSize / 2,
				ctx.app.width, ctx.app.actionBarSize )
			actionBarBackground:setFillColor(hex(ctx.color.menu.actionBar))

		local actionBarMenu = display.newImage(ctx.assets.ic_menu)
			actionBarMenu.width = ctx.app.actionBarSize * 0.6
			actionBarMenu.height = ctx.app.actionBarSize * 0.6
			actionBarMenu.x = ctx.app.right - 10 - actionBarMenu.width / 2
			actionBarMenu.y = actionBarBackground.y

		local actionBarHelp = display.newImage(ctx.assets.ic_question)
			actionBarHelp.width = ctx.app.actionBarSize * 0.6
			actionBarHelp.height = ctx.app.actionBarSize * 0.6
			actionBarHelp.x = actionBarMenu.x - actionBarMenu.width - 30
			actionBarHelp.y = actionBarBackground.y

		local actionBarIcon = display.newImage(ctx.assets.app_icon_foreground)
			actionBarIcon.width = ctx.app.actionBarSize * 0.9
			actionBarIcon.height = ctx.app.actionBarSize * 0.9
			actionBarIcon.x = ctx.app.left + 5 + actionBarIcon.width / 2
			actionBarIcon.y = actionBarBackground.y

		local actionBarTitle = display.newText({
				text = ctx.str.app_name, align = "left",
				fontSize = 30, font = native.systemFont,
				width = (actionBarHelp.x - actionBarHelp.width/2) - (actionBarIcon.x + actionBarIcon.width/2), height = 0,
				x = ctx.app.left + 10 + actionBarIcon.x + actionBarIcon.width/2, y = actionBarBackground.y })
			actionBarTitle.anchorX = 0

		actionBar:insert(actionBarBackground)
		actionBar:insert(actionBarMenu)
		actionBar:insert(actionBarHelp)
		actionBar:insert(actionBarIcon)
		actionBar:insert(actionBarTitle)
	-- Цвет не внесен в список цветов потому что временный
	local preview = display.newRect(
			ctx.app.left, ctx.app.actionBarSize,
			ctx.app.width, ctx.app.height * 0.35 )
		preview.anchorX = 0
		preview.anchorY = 0
		preview:setFillColor(hex("#00171E"))

	local myProjects = display.newGroup()
		local myProjectsBackground = display.newRect(
				ctx.app.left, preview.y + preview.height,
				ctx.app.width, 100 )
			myProjectsBackground.anchorX = 0
			myProjectsBackground.anchorY = 0
			myProjectsBackground.alpha = 0
			
		local myProjectsTitle = display.newText({
				text = ctx.str.projects, align = "left",
				fontSize = 40, font = native.systemFont,
				width = ctx.app.width, height = 0,
				x = ctx.app.left + 40, y = myProjectsBackground.y + myProjectsBackground.height/2 })
			myProjectsTitle.anchorX = 0

		local myProjectsIcon = display.newImage(ctx.assets.ic_arrow_right)
			myProjectsIcon.y = myProjectsBackground.y + myProjectsBackground.height/2
			myProjectsIcon.x = ctx.app.right - 50 - 20
			myProjectsIcon.width = 50
			myProjectsIcon.height = 50

		myProjects:insert(myProjectsBackground)
		myProjects:insert(myProjectsTitle)
		myProjects:insert(myProjectsIcon)
	
	local upsouls = display.newGroup()
		local upsoulsBackground = display.newRect(
				ctx.app.left, myProjectsBackground.y + myProjectsBackground.height,
				ctx.app.width, 100 )
			upsoulsBackground.anchorX = 0
			upsoulsBackground.anchorY = 0
			upsoulsBackground.alpha = 0

		local upsoulsTitle = display.newText({
				text = ctx.str.community, align = "left",
				fontSize = 40, font = native.systemFont,
				width = ctx.app.width, height = 0,
				x = ctx.app.left + 40, y = upsoulsBackground.y + upsoulsBackground.height/2 })
			upsoulsTitle.anchorX = 0

		local upsoulsIcon = display.newImage(ctx.assets.ic_arrow_right)
			upsoulsIcon.y = upsoulsBackground.y + upsoulsBackground.height/2
			upsoulsIcon.x = ctx.app.right - 50 - 20
			upsoulsIcon.width = 50
			upsoulsIcon.height = 50
		upsouls:insert(upsoulsBackground)
		upsouls:insert(upsoulsTitle)
		upsouls:insert(upsoulsIcon)

	local createButton = display.newGroup()
		local createBackground = display.newCircle(
				ctx.app.right - 50 - 20,
				ctx.app.bottom - 50 - 20, 50 )
			createBackground:setFillColor(hex(ctx.color.menu.orangeBtn))
		
		local createForeground = display.newImage(ctx.assets.ic_plus)
			createForeground.x = ctx.app.right - 50 - 20
			createForeground.y = ctx.app.bottom - 50 - 20
			createForeground.width = 50
			createForeground.height = 50

		createButton:insert(createBackground)
		createButton:insert(createForeground)

	self:addView(background)
	self:addView(actionBar)
	self:addView(preview)

	self:addView(myProjects, _, self.handler.onTouchMyProjects)
	self:addView(upsouls, _, self.handler.onTouchUpsouls)
	self:addView(createButton, _, self.handler.onTouchCreateBtn)
end

return menu