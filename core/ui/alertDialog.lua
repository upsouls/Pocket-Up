
local dialog = class()

function dialog:_init()
	self.group = display.newGroup()
	self.group.alpha = 0
end

function dialog:add(view)
	self.group:insert(view)
end

function dialog:show()
	local back = display.newRect(
		ctx.app.x, ctx.app.y, ctx.app.width, ctx.app.height)
		back:setFillColor(0, 0, 0, 0.6)
		back:addEventListener('touch', function(e)
			if e.phase == "began" then self:close() end
			return true end)

	local dialogBack = display.newRoundedRect(
		ctx.app.x, ctx.app.y, ctx.app.width*0.8, 200, 4)
		dialogBack:setFillColor(hex("#424242"))

	local placeholder = display.newText({
			text="Название проекта",
			width = dialogBack.width - ctx.app.width/17*2,
			x=ctx.app.x,
			y=dialogBack.y - dialogBack.height/2 + 25,
			font=nil,
			fontSize=20
		})
		placeholder:setFillColor(171/255, 219/255, 241/255)

	local input = native.newTextBox(
			ctx.app.x, placeholder.y + placeholder.height, dialogBack.width*0.8, placeholder.width/10
		)
		input.isEditable = true
		input.hasBackground = false
		input.anchorY = 0

	self:add(back)
	self:add(dialogBack)
	self:add(placeholder)
	self:add(input)
	
	transition.to(self.group, {time=150, alpha=1})
end

function dialog:close()
	transition.to(self.group, {time=150, alpha=0})
	self.group:removeSelf()
	self.group = nil
end

return dialog