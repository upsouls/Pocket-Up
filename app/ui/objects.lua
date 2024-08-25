
local objects = class(require 'core.scene')

function objects:_init()
	self.handler = require('app.ui.handler.objects')()

	self.super._init(self)
end

function objects:create()
	local background = display.newRect(
			ctx.app.x, ctx.app.y,
			ctx.app.width, ctx.app.height )
		background:setFillColor(hex(ctx.color.objects.background))

	local actionBar = display.newGroup()
		local actionBarBackground = display.newRect(
				ctx.app.x, ctx.app.top + ctx.app.actionBarSize / 2,
				ctx.app.width, ctx.app.actionBarSize )
			actionBarBackground:setFillColor(hex(ctx.color.objects.actionBar))
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
				text = "project" .. ctx.str.project, align = "left",
				fontSize = 30, font = native.systemFont,
				width = (actionBarMenu.x - actionBarMenu.width/2) - (actionBarIcon.x + actionBarIcon.width/2), height = 0,
				x = ctx.app.left + 30 + actionBarIcon.x + actionBarIcon.width/2, y = actionBarBackground.y })
			actionBarTitle.anchorX = 0

		actionBar:insert(actionBarBackground)
		actionBar:insert(actionBarMenu)
		actionBar:insert(actionBarIcon)
		actionBar:insert(actionBarTitle)

	local createButton = display.newGroup()
		local createBackground = display.newCircle(
				ctx.app.right - 50 - 20,
				ctx.app.bottom - 50 - 20, 50 )
			createBackground:setFillColor(hex(ctx.color.objects.orangeBtn))
		
		local createForeground = display.newImage(ctx.assets.ic_plus)
			createForeground.x = ctx.app.right - 50 - 20
			createForeground.y = ctx.app.bottom - 50 - 20
			createForeground.width = 50
			createForeground.height = 50

		createButton:insert(createBackground)
		createButton:insert(createForeground)

	local playButton = display.newGroup()
		local playBackground = display.newCircle(
				ctx.app.right - 50 - 20,
				createBackground.y - 100 - 20, 50 )
			playBackground:setFillColor(hex(ctx.color.objects.orangeBtn))
		
		local playForeground = display.newImage(ctx.assets.ic_play)
			playForeground.x = playBackground.x
			playForeground.y = playBackground.y
			playForeground.width = 50
			playForeground.height = 50

		playButton:insert(playBackground)
		playButton:insert(playForeground)

	self:addTouchCallback(actionBarIcon, self.handler.onTouchBack)
	self:addTouchCallback(actionBarMenu, self.handler.onTouchMenu)

	self:addView(background)
	self:addView(actionBar)

	self:addView(createButton, _, self.handler.onTouchCreateBtn)
	self:addView(playButton, _, self.handler.onTouchPlayBtn)
end

return objects