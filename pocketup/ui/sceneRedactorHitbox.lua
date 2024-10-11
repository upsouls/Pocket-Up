function scene_redactorShapeHitbox(arrayShape, textParameter, images, blocks)
	app.scene = "redactorHitbox"
	local isBackScene = "back"
	local funBackObjects = {}
	local groupScene = display.newGroup()
	app.scenes[app.scene] = {groupScene}
	local oldFunBack = funBack
	local arrayTopBar = topBar(groupScene, 523, nil, nil, funBackObjects)
	arrayTopBar[4].alpha = 0

	local scrollImages = plugins.widget.newScrollView({
		width=display.contentWidth,
		height=display.contentWidth/4,
		verticalScrollDisabled=true,
		isBounceEnabled=false,
		hideBackground=true,
		x=CENTER_X,
		y=arrayTopBar[1].y+arrayTopBar[1].height
	})
	--scrollImages.x=CENTER_X
	groupScene:insert(scrollImages)
	scrollImages.anchorY=0

	

	local rectRightGradient = display.newRect(0, scrollImages.y, scrollImages.height, scrollImages.height)
	rectRightGradient.anchorX, rectRightGradient.anchorY = 0, 0
	local gradient = {
	    type = "gradient",
	    color1 = { 4/255, 34/255, 44/255 },
	    color2 = { 0, 0, 0, 0 },
	    direction = "right"
	}
	rectRightGradient.fill = gradient
	local rectLeftGradient = display.newRect(CENTER_X+display.contentWidth/2, scrollImages.y, scrollImages.height, scrollImages.height)
	rectLeftGradient.anchorX, rectLeftGradient.anchorY = 1, 0
	gradient = {
	    type = "gradient",
	    color1 = { 4/255, 34/255, 44/255 },
	    color2 = { 0, 0, 0, 0 },
	    direction = "left"
	}
	rectLeftGradient.fill = gradient
	groupScene:insert(rectLeftGradient)
	groupScene:insert(rectRightGradient)

	local tablePositions = plugins.json.decode(arrayShape[2])

	funBackObjects[1] = function()
		if (isBackScene == "back") then
			funBack = oldFunBack
			display.remove(groupScene)
			arrayShape[2] = plugins.json.encode(tablePositions)
			textParameter.text = arrayShape[2]
			app.scene = "scripts"
			app.scenes[app.scene][1].alpha = 1
			funsP["записать сохранение"](app.idObject.."/scripts", plugins.json.encode(blocks))
		end
	end


	local mainImage
	local polygonHitbox
	plugins.physics.setDrawMode('hybrid')
	plugins.physics.start()
	local function updatePolygon()
		if (polygonHitbox~=nil or true) then
			plugins.physics.removeBody(mainImage)
		end
		local resizePositions = {}
		for i=1, #tablePositions/2 do
			resizePositions[i*2-1] = tablePositions[i*2-1]*mainImage.xScale
			resizePositions[i*2] = tablePositions[i*2]*mainImage.yScale
		end
		plugins.physics.addBody(mainImage, "static", {shape=resizePositions})
	end

	local tablePoints = {}
	local touchedPoint = nil
	local slidersObjects = {}
	local groupPoints = display.newGroup()
	local groupInterface
	groupScene:insert(groupPoints)
	local function createMainImage(path)
		if (mainImage~=nil) then
			display.remove(mainImage)
		end
		mainImage = display.newImage(app.idObject.."/image_"..path..".png", system.DocumentsDirectory)
		local size = display.contentWidth/1.5
		if (mainImage.width>mainImage.height) then
			mainImage.xScale = size/mainImage.width/1.2
			mainImage.yScale = mainImage.xScale
			mainImage.y = scrollImages.y+scrollImages.height+display.contentWidth/20+mainImage.width/2*mainImage.xScale
		else
			mainImage.yScale = size/mainImage.height/1.2
			mainImage.xScale = mainImage.yScale
			mainImage.y = scrollImages.y+scrollImages.height+display.contentWidth/20+mainImage.height/2*mainImage.yScale
		end
		mainImage.x = CENTER_X
		groupScene:insert(mainImage)
		mainImage.strokeWidth = 3/mainImage.xScale
		mainImage:setStrokeColor(171/255, 219/255, 241/255)
		groupPoints:toFront()
		groupPoints.x, groupPoints.y = mainImage.x, mainImage.y
		for i=1, #tablePoints do
			local groupPoint = tablePoints[i]
			groupPoint.x, groupPoint.y = math.max(math.min(tablePositions[i*2-1]*mainImage.xScale, mainImage.width*mainImage.xScale/2), -mainImage.width*mainImage.xScale/2), math.max(math.min(tablePositions[i*2]*mainImage.yScale, mainImage.height*mainImage.yScale/2), -mainImage.height*mainImage.yScale/2)
			
			if (touchedPoint==i) then
				local line = slidersObjects[1]
				line.circle.x =  line.x+(groupPoint.x+mainImage.x-(mainImage.x-mainImage.width*mainImage.xScale/2))/(mainImage.width*mainImage.xScale)*line.width
				line.line.width = line.circle.x-line.x
				local line = slidersObjects[2]
				line.circle.x =  line.x+(groupPoint.y+mainImage.y-(mainImage.y-mainImage.height*mainImage.yScale/2))/(mainImage.height*mainImage.yScale)*line.width
				line.line.width = line.circle.x-line.x
			end
		end
		updatePolygon()
	end
	createMainImage(images[1][2])


	local size = display.contentWidth/4
	local tableImages = {}
	local idImage = 1
	for i=1, #images do
		local image = display.newImage(app.idObject.."/image_"..images[i][2]..".png", system.DocumentsDirectory)
		local strokeImage = display.newImage("images/notVisible.png")
		if (image.width>image.height) then
			image.xScale = size/image.width/1.2
			image.yScale = image.xScale
			strokeImage.width = image.width*image.xScale
			strokeImage.height = strokeImage.width
		else
			image.yScale = size/image.height/1.2
			image.xScale = image.yScale
			strokeImage.width = image.height*image.yScale
			strokeImage.height = strokeImage.width
		end
		image.x, image.y = (i-0.25)*size/1.1+(size-size/1.1)/2, size/2
		strokeImage.x, strokeImage. y = image.x, image.y
		scrollImages:insert(strokeImage)
		scrollImages:insert(image)
		strokeImage.strokeWidth = 3
		if (i~=1) then
			strokeImage:setStrokeColor(171/255, 219/255, 241/255)
		else
			strokeImage:setStrokeColor(241/255, 219/255, 171/255)
		end

		tableImages[i] = image
		strokeImage.id = i
		image.objectStroke = strokeImage

		strokeImage:addEventListener("touch", function(event)
			if (event.phase == "began") then
				strokeImage:setStrokeColor(241/255, 219/255, 171/255)
				display.getCurrentStage():setFocus(event.target, event.id)
			elseif (event.phase=="moved" and (math.abs(event.xStart-event.x)>20 or math.abs(event.yStart-event.y)>20)) then
				if (strokeImage.id~=idImage) then
					strokeImage:setStrokeColor(171/255, 219/255, 241/255)
				end
				scrollImages:takeFocus(event)
			elseif (event.phase=="ended" and strokeImage.id~=idImage) then
				local oldId = idImage
				idImage = strokeImage.id
				tableImages[oldId].objectStroke:setStrokeColor(171/255, 219/255, 241/255)
				display.getCurrentStage():setFocus(event.target, nil)
				createMainImage(images[idImage][2])
			end
			return(true)
		end)
	end
	local scrollImagesWidth = math.max(tableImages[#images].x+size/1.25-(size-size/1.1)/2, scrollImages.width)
	scrollImages:setScrollWidth(scrollImagesWidth)
	if (scrollImagesWidth > scrollImages.width) then
		timer.performWithDelay(500, function()
			scrollImages:scrollToPosition({x=-size*1.5, time=500, transition=easing.inOutQuad})
		end)
	end

	local textFieldXPos
	local textFieldYPos
	local isMoved = false
	local function touchPoint(event)
		if (event.phase=="began") then
			display.getCurrentStage():setFocus(event.target, event.id)
			event.target:toFront()
			if (touchedPoint~=nil) then
				tablePoints[touchedPoint].point:setFillColor(171/255, 219/255, 241/255)
			end
			groupInterface.alpha = 0.5

			local line = slidersObjects[1]
			line.circle.x =  line.x+(event.target.x+mainImage.x-(mainImage.x-mainImage.width*mainImage.xScale/2))/(mainImage.width*mainImage.xScale)*line.width
			line.line.width = line.circle.x-line.x
			local line = slidersObjects[2]
			line.circle.x =  line.x+(event.target.y+mainImage.y-(mainImage.y-mainImage.height*mainImage.yScale/2))/(mainImage.height*mainImage.yScale)*line.width
			line.line.width = line.circle.x-line.x
			textFieldXPos.text, textFieldYPos.text = tostring(math.round(tablePositions[event.target.id*2-1])), tostring(-math.round(tablePositions[event.target.id*2]))
			updatePolygon()

		elseif (event.phase=="moved" and (math.abs(event.xStart-event.x)>20 or math.abs(event.yStart-event.y)>20 or isMoved) ) then
			display.getCurrentStage():setFocus(event.target, event.id)
			isMoved = true
			event.target.x, event.target.y = math.max(math.min(event.x-groupPoints.x, mainImage.width*mainImage.xScale/2), -mainImage.width*mainImage.xScale/2), math.max(math.min(event.y-groupPoints.y, mainImage.height*mainImage.xScale/2), -mainImage.height*mainImage.xScale/2)
			local id = event.target.id
			tablePositions[id*2-1], tablePositions[id*2] = math.max(math.min((event.x-groupPoints.x)/mainImage.xScale, mainImage.width/2), -mainImage.width/2), math.max(math.min((event.y-groupPoints.y)/mainImage.yScale, mainImage.height/2), -mainImage.height/2)

			local line = slidersObjects[1]
			line.circle.x =  line.x+(event.target.x+mainImage.x-(mainImage.x-mainImage.width*mainImage.xScale/2))/(mainImage.width*mainImage.xScale)*line.width
			line.line.width = line.circle.x-line.x
			local line = slidersObjects[2]
			line.circle.x =  line.x+(event.target.y+mainImage.y-(mainImage.y-mainImage.height*mainImage.yScale/2))/(mainImage.height*mainImage.yScale)*line.width
			line.line.width = line.circle.x-line.x
			textFieldXPos.text, textFieldYPos.text = tostring(math.round(tablePositions[id*2-1])), tostring(-math.round(tablePositions[id*2]))
			updatePolygon()
		elseif (event.phase=="ended") then
			display.getCurrentStage():setFocus(event.target, nil)
			if (not isMoved or true) then
				event.target.point:setFillColor(0,1,0)
				touchedPoint = event.target.id
				groupInterface.alpha = 1
			end
			isMoved = false
		end
		return(true)
	end

	for i=1, #tablePositions/2 do
		local groupPoint = display.newGroup()
		groupPoint.id = i
		groupPoints:insert(groupPoint)
		groupPoint.x, groupPoint.y = tablePositions[i*2-1]*mainImage.xScale, tablePositions[i*2]*mainImage.yScale
		local point = display.newCircle(0, 0, display.contentWidth/50)
		groupPoint:insert(point)
		groupPoint.point = point
		point.strokeWidth = 5
		point:setStrokeColor(0, 0.5, 1)
		point:setFillColor(171/255, 219/255, 241/255)

		tablePoints[i] = groupPoint
		groupPoint:addEventListener("touch", touchPoint)
	end

	groupInterface = display.newGroup()
	groupInterface.alpha = 0.5
	groupScene:insert(groupInterface)

	local deleteButton = display.newRoundedRect(CENTER_X, CENTER_Y+display.contentHeight/2-display.contentWidth/20, display.contentWidth/1.5, display.contentWidth/8.5, app.roundedRect)
	deleteButton.anchorY = 1
	deleteButton:setFillColor(213/255, 1/255, 0)
	groupInterface:insert(deleteButton)
	local headerDelete = display.newText(app.words[525], deleteButton.x, deleteButton.y-deleteButton.height/2, nil, app.fontSize1)
	groupInterface:insert(headerDelete)
	deleteButton:addEventListener("touch", function(event)
		if (groupInterface.alpha>0.75 and #tablePoints>3) then
			if (event.phase=="began") then
				event.target:setFillColor(221/255, 51/255, 51/255)
		        display.getCurrentStage():setFocus(event.target, event.id)
			elseif (event.phase=="moved" and (math.abs(event.x-event.xStart)>20 or math.abs(event.y-event.yStart)>20)) then
				event.target:setFillColor(213/255, 1/255, 0)
			elseif (event.phase=="ended") then
				event.target:setFillColor(213/255, 1/255, 0)
		        display.getCurrentStage():setFocus(event.target, nil)
		        groupInterface.alpha = 0.5
		        for i=1, #slidersObjects do
			        slidersObjects[i].circle.x = slidersObjects[i].x
			        slidersObjects[i].line.width = 0
		        end
		        textFieldXPos.text, textFieldYPos.text = "0", "0"
		        local point = tablePoints[touchedPoint]
		        table.remove(tablePoints, touchedPoint)
		        table.remove(tablePositions, touchedPoint*2)
		        table.remove(tablePositions, touchedPoint*2-1)
		        display.remove(point)
		        for i = 1, #tablePoints do
		        	tablePoints[i].id = i
		        end
		        touchedPoint = nil
		        updatePolygon()
			end
			return(true)
		elseif (groupInterface.alpha>0.75) then
			isBackScene = "block"
			plugins.physics.removeBody(mainImage)
			app.cerberus.newBannerQuestion(app.words[526], function()
				isBackScene = "back"
				updatePolygon()
			end, "", app.words[16])
		end
	end)

	local function touchSlider(event)
		if (groupInterface.alpha>0.75) then
			if (event.phase=="began") then
			elseif (event.phase=="moved") then
				display.getCurrentStage():setFocus(event.target, event.id)
				local circle = event.target.rectLine.circle
				local line = event.target.rectLine
				local lineBlue = event.target.rectLine.line
				circle.x = math.min(math.max(event.x, line.x), line.x+line.width)
				lineBlue.width = circle.x-line.x
				local point = tablePoints[touchedPoint]
				local keyPos = line.id == 1 and "x" or "y"
				local keyPosSize = line.id == 1 and "width" or "height"
				point[keyPos] = mainImage[keyPos]-mainImage[keyPosSize]*mainImage[keyPos.."Scale"]/2+lineBlue.width/line.width*(mainImage[keyPosSize]*mainImage[keyPos.."Scale"])-groupPoints[keyPos]

				tablePositions[touchedPoint*2-(keyPos=="y" and 0 or 1)] = (circle.x-line.x)/line.width*mainImage[keyPosSize]-mainImage[keyPosSize]/2
				updatePolygon()
				textFieldXPos.text, textFieldYPos.text = tostring(math.round(tablePositions[touchedPoint*2-1])), tostring(-math.round(tablePositions[touchedPoint*2]))
			else
				display.getCurrentStage():setFocus(event.target, nil)
			end
			return(true)
		end
	end

	local yPos = deleteButton.y-deleteButton.height-display.contentWidth/10
	for i=1, 2 do
		local button = display.newRect(deleteButton.x, yPos, deleteButton.width, display.contentWidth/15)
		button:setFillColor(4/255, 34/255, 44/255)
		groupInterface:insert(button)
		local text = display.newText((i==1 and app.words[59] or app.words[60])..':', button.x-button.width/2-display.contentWidth/40, yPos, nil, app.fontSize2)
		text.anchorX=1
		text:setFillColor(1, 1, 1)
		groupInterface:insert(text)
		local rectLine = display.newRect(button.x-button.width/2, button.y, button.width, display.contentWidth/150)
		rectLine.anchorX = 0
		rectLine:setFillColor(227/255,227/255,227/255)
		groupInterface:insert(rectLine)
		local rectLineBlue = display.newRect(rectLine.x, rectLine.y, 0, rectLine.height)
		rectLineBlue.anchorX = 0
		rectLineBlue:setFillColor(171/255, 219/255, 241/255)
		groupInterface:insert(rectLineBlue)
		local circleLine = display.newCircle(rectLineBlue.x+rectLineBlue.width, rectLineBlue.y, rectLineBlue.height*2.5)
		circleLine:setFillColor(171/255, 219/255, 241/255)
		groupInterface:insert(circleLine)
		button:addEventListener("touch", touchSlider)
		button.rectLine = rectLine
		rectLine.text = textNumber
		rectLine.line = rectLineBlue
		rectLine.circle = circleLine
		rectLine.id = i
		slidersObjects[i] = rectLine
		yPos = yPos-button.height*1.25
	end

	textFieldXPos = native.newTextField(-CENTER_X, yPos, display.contentWidth/4.5, display.contentWidth/10)
	textFieldXPos:addEventListener("userInput", function(event)
		if (event.phase == "editing" and touchedPoint~=nil) then
			local value = tonumber(event.text)==nil and 0 or tonumber(event.text)
			local point = tablePoints[touchedPoint]
			point.x = math.max(math.min(value, mainImage.width/2), -mainImage.width/2)*mainImage.xScale
			tablePositions[touchedPoint*2-1] = math.max(math.min(value, mainImage.width/2), -mainImage.width/2)
			updatePolygon()
			local line = slidersObjects[1]
			line.circle.x = line.x+(point.x+mainImage.width*mainImage.xScale/2)/(mainImage.width*mainImage.xScale)*line.width
			line.line.width = line.circle.x-line.x
		end
	end)
	textFieldXPos.x = CENTER_X
	textFieldXPos.inputType = "no-emoji"
	textFieldXPos.hasBackground = false
	textFieldXPos.anchorX, textFieldXPos.anchorY = 1, 1
	groupInterface:insert(textFieldXPos)
	local line = display.newRect(CENTER_X-display.contentWidth/50, textFieldXPos.y, textFieldXPos.width, display.contentWidth/150)
	line.anchorX = 1
	line:setFillColor(171/255, 219/255, 241/255)
	groupInterface:insert(line)
	textFieldYPos = native.newTextField(-CENTER_X, yPos, textFieldXPos.width, textFieldXPos.height)
	textFieldYPos:addEventListener("userInput", function(event)
		if (event.phase == "editing" and touchedPoint~=nil) then
			local value = tonumber(event.text)==nil and 0 or tonumber(event.text)
			local point = tablePoints[touchedPoint]
			point.y = -math.max(math.min(value, mainImage.height/2), -mainImage.height/2)*mainImage.yScale
			tablePositions[touchedPoint*2] = -math.max(math.min(value, mainImage.height/2), -mainImage.height/2)
			updatePolygon()
			local line = slidersObjects[2]
			line.circle.x = line.x+(point.y+mainImage.height*mainImage.yScale/2)/(mainImage.height*mainImage.yScale)*line.width
			line.line.width = line.circle.x-line.x
		end
	end)
	textFieldYPos.x = CENTER_X
	textFieldYPos.inputType = "no-emoji"
	textFieldYPos.hasBackground = false
	textFieldYPos.anchorX, textFieldYPos.anchorY = 1, 1
	groupInterface:insert(textFieldYPos)
	local line = display.newRect(CENTER_X+display.contentWidth/3, textFieldXPos.y, textFieldXPos.width, display.contentWidth/150)
	line.anchorX = 1
	line:setFillColor(171/255, 219/255, 241/255)
	groupInterface:insert(line)
	timer.performWithDelay(0, function()
		textFieldXPos.x = CENTER_X-display.contentWidth/50
		textFieldYPos.x = CENTER_X+display.contentWidth/3
		textFieldXPos.text = "0"
		textFieldYPos.text = "0"
	end)
	local headerX = display.newText(app.words[59]..":", CENTER_X-display.contentWidth/50-textFieldXPos.width-display.contentWidth/40, textFieldXPos.y-textFieldXPos.height/2, nil, app.fontSize0)
	headerX.anchorX = 1
	groupInterface:insert(headerX)
	local headerX = display.newText(app.words[60]..":", CENTER_X+display.contentWidth/3-textFieldXPos.width-display.contentWidth/40, textFieldXPos.y-textFieldXPos.height/2, nil, app.fontSize0)
	headerX.anchorX = 1
	groupInterface:insert(headerX)

	local createButton = display.newRoundedRect(CENTER_X,textFieldXPos.y-textFieldXPos.height-display.contentWidth/20, display.contentWidth/1.5, display.contentWidth/8.5, app.roundedRect)
	createButton.anchorY = 1
	createButton:setFillColor(32/255,213/255, 0)
	groupScene:insert(createButton)
	local headerCreate = display.newText(app.words[527], createButton.x, createButton.y-createButton.height/2, nil, app.fontSize1)
	groupScene:insert(headerCreate)

	local isTouch = false
	createButton:addEventListener("touch", function(event)
		if (event.phase=="began") then
			event.target:setFillColor(72/255,223/255, 20/255)
	        display.getCurrentStage():setFocus(event.target, event.id)
	        isTouch = true
		elseif (event.phase=="moved" and (math.abs(event.x-event.xStart)>20 or math.abs(event.y-event.yStart)>20)) then
			event.target:setFillColor(32/255,213/255, 0)
			isTouch = false
		elseif (event.phase=="ended") then
			event.target:setFillColor(32/255,213/255, 0)
	        display.getCurrentStage():setFocus(event.target, nil)
	        if (isTouch) then
	        	local endPos = #tablePositions
	        	tablePositions[endPos+1] = (tablePositions[1]+tablePositions[endPos-1])/2
	        	tablePositions[endPos+2] = (tablePositions[2]+tablePositions[endPos])/2
	        	local groupPoint = display.newGroup()
				groupPoint.id = #tablePoints+1
				groupPoints:insert(groupPoint)
				groupPoint.x, groupPoint.y = tablePositions[groupPoint.id*2-1]*mainImage.xScale, tablePositions[groupPoint.id*2]*mainImage.yScale
				local point = display.newCircle(0, 0, display.contentWidth/50)
				groupPoint:insert(point)
				groupPoint.point = point
				point.strokeWidth = 5
				point:setStrokeColor(0, 0.5, 1)
				point:setFillColor(171/255, 219/255, 241/255)

				tablePoints[groupPoint.id] = groupPoint
				groupPoint:addEventListener("touch", touchPoint)
	        end
	        isTouch = false
	    end
	end)
end