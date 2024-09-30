-- принимает массив строк. пример {"переименовать","копировать","удалить"}

cerberus.newVatiants = function (variants, onComplete)
	local backgroundBlackAlpha = display.newRect(CENTER_X, CENTER_Y, display.contentWidth, display.contentHeight)
	backgroundBlackAlpha:setFillColor(0,0,0,0.6)
	SCENES[SCENE][(SCENE=="scripts" and 1 or #SCENES[SCENE])]:insert(backgroundBlackAlpha)
	local group = display.newGroup()
	SCENES[SCENE][(SCENE=="scripts" and 1 or #SCENES[SCENE])]:insert(group)
	local rect = display.newRoundedRect(CENTER_X, CENTER_Y, display.contentWidth/1.16, 0, roundedRect)
	rect.anchorY=0,
	rect:setFillColor(66/255, 66/255, 66/255)
	group:insert(rect)

	local buttons = {}
	local touchBackground
	local function touchVariant(event)
		if (event.phase=="began") then
			event.target:setFillColor(72/255, 72/255, 72/255)
		elseif (event.phase=="moved" and (math.abs(event.x-event.xStart)>20 or math.abs(event.y-event.yStart)>20)) then
			event.target:setFillColor(66/255, 66/255, 66/255)
		elseif (event.phase~="moved") then
			event.target:setFillColor(66/255, 66/255, 66/255)

			for i=1, #variants do
				buttons[i]:removeEventListener("touch", touchVariant)
			end
			rect:removeEventListener("touch", touchBackground)
			backgroundBlackAlpha:removeEventListener("touch", touchBackground)
			transition.to(backgroundBlackAlpha, {time=200, alpha=0, inComplete=function()
				display.remove(backgroundBlackAlpha)
			end})
			transition.to(group, {time=200, alpha=0, inComplete=function()
				display.remove(group)
			end})

			if (onComplete~=nil) then
				onComplete(event.target.id)
			end

		end
		return(true)
	end

	for i=1, #variants do
		local button = display.newRect(group, CENTER_X, CENTER_Y+(i-0.5)*display.contentWidth/8+display.contentWidth/50, display.contentWidth/1.16, display.contentWidth/8)
		button:setFillColor(66/255, 66/255, 66/255)
		local text = display.newText({
			text=variants[i],
			x=button.x,
			y=button.y,
			width=display.contentWidth/1.16-(display.contentWidth-display.contentWidth/1.16),
			fontSise=fontSize1,
		})
		group:insert(text)
		buttons[i] = button

		button.id = i
		button:addEventListener("touch", touchVariant)
	end
	rect.height = #variants*display.contentWidth/8+display.contentWidth/25
	group.y = -rect.height/2

	touchBackground = function (event)
		if (event.phase=="ended" and event.target~=rect) then
			for i=1, #variants do
				buttons[i]:removeEventListener("touch", touchVariant)
			end
			rect:removeEventListener("touch", touchBackground)
			backgroundBlackAlpha:removeEventListener("touch", touchBackground)
			transition.to(backgroundBlackAlpha, {time=200, alpha=0, inComplete=function()
				display.remove(backgroundBlackAlpha)
			end})
			transition.to(group, {time=200, alpha=0, inComplete=function()
				display.remove(group)
			end})

			if (onComplete~=nil) then
				onComplete(nil)
			end
		end
		return(true)
	end
	rect:addEventListener("touch", touchBackground)
	backgroundBlackAlpha:addEventListener("touch", touchBackground)

	backgroundBlackAlpha.alpha = 0
	group.alpha = 0
	transition.to(backgroundBlackAlpha, {time=150, alpha=1})
	transition.to(group, {time=150, alpha=1})
end