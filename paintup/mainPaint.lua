function scene_paint( orientation, pathImage )
	-- 211/255, 211/255, 211/255
	-- 50/255, 139/255, 153/255
	-- 163/255, 163/255, 163/255
	-- 21/255, 125/255, 162/255
	display.setDefault("background", 211/255, 211/255, 211/255)
	local groupScene = display.newGroup()
	local groupSceneScroll = display.newGroup()
	app.scene = "projects"
	app.scenes[app.scene] = {groupSceneScroll, groupScene}
	local funMenuObjects={}
	local funCheckObjects = {}
	local funBackObjects = {}
	local isBackScene = "back"
	local valueHeaderTopBar = app.words[1]
	local topBarArray = topBar(groupScene, 1, funMenuObjects, funCheckObjects, funBackObjects)
	topBarArray[1]:setFillColor(50/255, 139/255, 153/255)
	topBarArray[2].alpha = 0.75
	topBarArray[3].isVisible = false
	topBarArray[4].alpha = 0.75
	display.remove(topBarArray[5])

	local textFieldSizeBrush
	local rectBackScrollSizeBrush
	local rectScrollSizeBrush
	local circleScrollSizeBrush
	local rectTextFieldSizeBrush = display.newRoundedRect(groupScene, CENTER_X-display.contentWidth/2+20, topBarArray[1].y+topBarArray[1].height+20, display.contentWidth/6, display.contentWidth/12, app.roundedRect*3)
	rectTextFieldSizeBrush.anchorX, rectTextFieldSizeBrush.anchorY = 0, 0
	rectTextFieldSizeBrush:addEventListener("touch", function(event)
		if (event.phase=="began") then
			native.setKeyboardFocus(textFieldSizeBrush)
		end
		return(true)
	end)
	textFieldSizeBrush = native.newTextField(rectTextFieldSizeBrush.x+rectTextFieldSizeBrush.width/2, rectTextFieldSizeBrush.y+rectTextFieldSizeBrush.height/2, rectTextFieldSizeBrush.width, rectTextFieldSizeBrush.height/1.5)
	textFieldSizeBrush.text = "25"
	textFieldSizeBrush.hasBackground = false
	textFieldSizeBrush.inputType = "number"
	textFieldSizeBrush.align = "center"
	textFieldSizeBrush:addEventListener("userInput", function(event)
		if (textFieldSizeBrush.text~="" and tonumber(textFieldSizeBrush.text)>100) then
			textFieldSizeBrush.text = event.oldText
		elseif (textFieldSizeBrush.text:gsub("0", "")=="") then
			textFieldSizeBrush.text = ""
		end
		if (event.phase=="editing") then
			if (textFieldSizeBrush.text == "") then
				circleScrollSizeBrush.x = rectBackScrollSizeBrush.x
				rectScrollSizeBrush.width = 0
			else
				circleScrollSizeBrush.x = rectBackScrollSizeBrush.x+rectBackScrollSizeBrush.width/100*textFieldSizeBrush.text
				rectScrollSizeBrush.width = circleScrollSizeBrush.x - rectBackScrollSizeBrush.x
			end
		end
	end)
	textFieldSizeBrush:setTextColor(21/255, 125/255, 162/255)
	textFieldSizeBrush.font = native.newFont("fonts/font_2.ttf")
	textFieldSizeBrush.size = app.fontSize2
	groupScene:insert(textFieldSizeBrush)

	rectBackScrollSizeBrush = display.newRect(groupScene, rectTextFieldSizeBrush.x+rectTextFieldSizeBrush.width+50, textFieldSizeBrush.y, display.contentWidth - rectTextFieldSizeBrush.x - rectTextFieldSizeBrush.width - 100, 7)
	rectBackScrollSizeBrush.anchorX = 0
	rectBackScrollSizeBrush:setFillColor(163/255, 163/255, 163/255)
	rectBackScrollSizeBrush.alpha = 0.5
	circleScrollSizeBrush = display.newCircle(groupScene, rectBackScrollSizeBrush.x+rectBackScrollSizeBrush.width/100*textFieldSizeBrush.text, rectBackScrollSizeBrush.y, rectBackScrollSizeBrush.height*2)
	circleScrollSizeBrush:setFillColor(21/255, 125/255, 162/255)
	rectScrollSizeBrush = display.newRect(groupScene, rectBackScrollSizeBrush.x, rectBackScrollSizeBrush.y, circleScrollSizeBrush.x - rectBackScrollSizeBrush.x, rectBackScrollSizeBrush.height)
	rectScrollSizeBrush.anchorX = 0
	rectScrollSizeBrush:setFillColor(21/255, 125/255, 162/255)
	local buttonScrollSizeBrush = display.newImage("images/notVisible.png", rectBackScrollSizeBrush.x, rectBackScrollSizeBrush.y)
	buttonScrollSizeBrush.anchorX = 0
	buttonScrollSizeBrush.width, buttonScrollSizeBrush.height = rectBackScrollSizeBrush.width, textFieldSizeBrush.height
	buttonScrollSizeBrush:addEventListener("touch", function(event)
		if (event.phase=="began") then
			display.getCurrentStage():setFocus(event.target, event.id)
		else
			circleScrollSizeBrush.x = math.min(math.max(event.x, rectBackScrollSizeBrush.x+rectBackScrollSizeBrush.width/100), rectBackScrollSizeBrush.x+rectBackScrollSizeBrush.width)
			rectScrollSizeBrush.width = circleScrollSizeBrush.x - rectBackScrollSizeBrush.x
			textFieldSizeBrush.text = tostring(math.round(rectScrollSizeBrush.width/rectBackScrollSizeBrush.width*100))
			if (event.phase~="moved") then
				display.getCurrentStage():setFocus(event.target, nil)
			end
		end
		return(true)
	end)

	local rectDownBar = display.newRect(CENTER_X, CENTER_Y+display.contentHeight/2, topBarArray[1].width, topBarArray[1].height+50)
	rectDownBar.anchorY = 1
	rectDownBar:setFillColor(50/255, 139/255, 153/255)
end