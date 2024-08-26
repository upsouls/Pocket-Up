
local widget = require('widget')
local projects = class(require 'core.scene')

function projects:_init()
	self.handler = require('app.ui.handler.projects')()
	
	self.super._init(self)
end

function projects:create()
	local background = display.newRect(
			ctx.app.x, ctx.app.y,
			ctx.app.width, ctx.app.height )
		background:setFillColor(hex(ctx.color.projects.background))

	local actionBar = display.newGroup()
		local actionBarBackground = display.newRect(
				ctx.app.x, ctx.app.top + ctx.app.actionBarSize / 2,
				ctx.app.width, ctx.app.actionBarSize )
			actionBarBackground:setFillColor(hex(ctx.color.projects.actionBar))
		local actionBarMenu = display.newImage(ctx.assets.ic_menu)
			actionBarMenu.width = ctx.app.actionBarSize * 0.6
			actionBarMenu.height = ctx.app.actionBarSize * 0.6
			actionBarMenu.x = ctx.app.right - 10 - actionBarMenu.width / 2
			actionBarMenu.y = actionBarBackground.y

		local actionBarIcon = display.newImage(ctx.assets.ic_arrow_left)
			actionBarIcon.width = ctx.app.actionBarSize * 0.6
			actionBarIcon.height = ctx.app.actionBarSize * 0.6
			actionBarIcon.x = ctx.app.left + 20 + actionBarIcon.width / 2
			actionBarIcon.y = actionBarBackground.y

		local actionBarTitle = display.newText({
				text = ctx.str.projectsTitle, align = "left",
				fontSize = 30, font = native.systemFont,
				width = (actionBarMenu.x - actionBarMenu.width/2) - (actionBarIcon.x + actionBarIcon.width/2), height = 0,
				x = ctx.app.left + 30 + actionBarIcon.x + actionBarIcon.width/2, y = actionBarBackground.y })
			actionBarTitle.anchorX = 0

		actionBar:insert(actionBarBackground)
		actionBar:insert(actionBarMenu)
		actionBar:insert(actionBarIcon)
		actionBar:insert(actionBarTitle)

	local projectsScroll = widget.newScrollView({
		top = ctx.app.actionBarSize, left = ctx.app.left,
		width = ctx.app.width, height = ctx.app.bottom - ctx.app.actionBarSize,
		horizontalScrollDisabled=true, isBounceEnabled=false,
		hideBackground=true,
		hideScrollBar=true})

	local createButton = display.newGroup()
		local createBackground = display.newCircle(
				ctx.app.right - 60 - 20,
				ctx.app.bottom - 60 - 20, 60 )
			createBackground:setFillColor(hex(ctx.color.projects.orangeBtn))
		
		local createForeground = display.newImage(ctx.assets.ic_plus)
			createForeground.x = ctx.app.right - 60 - 20
			createForeground.y = ctx.app.bottom - 60 - 20
			createForeground.width = 40
			createForeground.height = 40

		createButton:insert(createBackground)
		createButton:insert(createForeground)

	self:addTouchCallback(actionBarIcon, self.handler.onTouchBack)
	self:addTouchCallback(actionBarMenu, self.handler.onTouchMenu)

	self:addView(background)
	self:addView(actionBar)
	self:addView(projectsScroll)
	self:addView(createButton, _, self.handler.onTouchCreateBtn)
end

return projects