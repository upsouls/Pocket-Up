function scene_setPosVisual(idBlock, idParameter, blocks, blocksObjects)
	local oldSceneBack = funBack

	local settings = json.decode(funsP["получить сохранение"](IDPROJECT.."/options"))
	local CENTER_X = CENTER_X
	local CENTER_Y = CENTER_Y
	if (settings.orientation=="horizontal") then
		orientation.lock('landscape')
		CENTER_X, CENTER_Y = CENTER_Y, CENTER_X
	end

	SCENES["scripts"][1].alpha = 0
	local groupScene = display.newGroup()
	SCENE = "visual_position"
	SCENES[SCENE] = {groupScene}
	local funBackObjects = {}
	local funMenuObjects = {}
	local isBackScene = "back"
	
	local block = blocks[idBlock]
	--local formulas = blocks[idBlock][2][idParameter]
	local xResize, yResize = display.contentWidth/settings.displayWidth, display.contentHeight/settings.displayHeight


	local background = display.newImage(groupScene, IDSCENE.."/icon.png", system.DocumentsDirectory)
	if (background~=nil) then
		background.width, background.height = (settings.orientation=="horizontal" and display.contentHeight or display.contentWidth), (settings.orientation=="horizontal" and display.contentWidth or display.contentHeight)
		background.x, background.y = CENTER_X, CENTER_Y
		background:toBack()
		background.fill.effect = "filter.brightness"
		background.fill.effect.intensity = -0.25
	end
	

	local obj_id = IDOBJECT:gsub(IDSCENE.."/object_", "")
	local objectsElements = json.decode(funsP["получить сохранение"](IDSCENE.."/objects"))
	local properties
	for i=1, #objectsElements do
		if (tostring(objectsElements[i][2])==obj_id) then
			properties = objectsElements[i][3]
			break
		end
	end

	local images = json.decode(funsP["получить сохранение"](IDOBJECT.."/images"))
	local image
	if (#images~=0) then
		if (properties==nil) then
			image = display.newImage(IDOBJECT.."/image_"..images[1][2]..".png", system.DocumentsDirectory)
		else
			if (properties.path==nil) then
				image = display.newImage(IDOBJECT.."/image_"..images[1][2]..".png", system.DocumentsDirectory)
			else
				image = display.newImage(properties.path, system.DocumentsDirectory)
			end

			if (properties.rotation ~= nil) then
				image.rotation = properties.rotation
			end
			if (properties.size ~= nil) then
				image.xScale, image.yScale = properties.size, properties.size
			end
		end

		local xTable, yTable 
		if (block[1]=="setPosition") then
			xTable, yTable = block[2][1], block[2][2]
		else
			xTable, yTable = block[2][2], block[2][3]
		end
		local x, y = "", ""
		for i=1, #xTable do
			if (xTable[i][1]=="number" or (i==1 and xTable[i][2]=="-")) then
				x = x..xTable[i][2]
			else
				x = 0
				break
			end
		end
		for i=1, #yTable do
			if (yTable[i][1]=="number" or (i==1 and xTable[i][2]=="-")) then
				y = y..yTable[i][2]
			else
				y = 0
				break
			end
		end

		
		image.xScale, image.yScale = image.xScale*(display.orientation=="horizontal" and yResize or xResize), image.yScale*(display.orientation=="horizontal" and xResize or yResize)
		image.x, image.y = CENTER_X+x*(display.orientation=="horizontal" and yResize or xResize), CENTER_Y-y*(display.orientation=="horizontal" and xResize or yResize)
		groupScene:insert(image)

		local xr, yr
		background:addEventListener("touch", function(event)
			if (event.phase=="began") then
				xr, yr = event.x-image.x, event.y-image.y
				display.getCurrentStage():setFocus(event.target, event.id)
			elseif (event.phase~="moved") then
				display.getCurrentStage():setFocus(event.target, nil)
			end
			image.x, image.y = event.x-xr, event.y-yr
			return(true)
		end)
	end
	
	local topBarArray = topBar(groupScene, words[272], funMenuObjects, nil, funBackObjects, settings.orientation=="horizontal")
	topBarArray[1].alpha = 0.3
	topBarArray[4].fill = {
		type="image",
		filename="images/check.png"
	}
	topBarArray[3].alpha = 0.75
	
	funBackObjects[1] = function()
		if (isBackScene=="back") then
			local function funEditingEnd(event)
				local cellsBlockObject = blocksObjects[idBlock].cells
				if (event.isOk) then
					if (block[1]=="setPosition") then
						block[2][1] = {{"number", (image.x-CENTER_X)/(display.orientation=="horizontal" and yResize or xResize)}}
						block[2][2] = {{"number", -(image.y-CENTER_Y)/(display.orientation=="horizontal" and xResize or yResize)}}
						cellsBlockObject[1][4].text = (image.x-CENTER_X)/(display.orientation=="horizontal" and yResize or xResize)
						cellsBlockObject[2][4].text = -(image.y-CENTER_Y)/(display.orientation=="horizontal" and xResize or yResize)
					else
						block[2][2] = {{"number", (image.x-CENTER_X)/(display.orientation=="horizontal" and yResize or xResize)}}
						block[2][3] = {{"number", -(image.y-CENTER_Y)/(display.orientation=="horizontal" and xResize or yResize)}}
						cellsBlockObject[2][4].text = (image.x-CENTER_X)/(display.orientation=="horizontal" and yResize or xResize)
						cellsBlockObject[3][4].text = -(image.y-CENTER_Y)/(display.orientation=="horizontal" and xResize or yResize)
					end
					funsP["записать сохранение"](IDOBJECT.."/scripts", json.encode(blocks))
				end
				display.remove(groupScene)
				funBack = oldSceneBack
				SCENES["scripts"][1].alpha = 1
				SCENE = "scripts"
			end
			cerberus.newBannerQuestion(words[609], funEditingEnd, words[610], words[611])
			isBackScene = "block"
		end
	end
	funMenuObjects[1] = function()
		local cellsBlockObject = blocksObjects[idBlock].cells
		if (block[1]=="setPosition") then
			block[2][1] = {{"number", (image.x-CENTER_X)/(display.orientation=="horizontal" and yResize or xResize)}}
			block[2][2] = {{"number", -(image.y-CENTER_Y)/(display.orientation=="horizontal" and xResize or yResize)}}
			cellsBlockObject[1][4].text = (image.x-CENTER_X)/(display.orientation=="horizontal" and yResize or xResize)
			cellsBlockObject[2][4].text = -(image.y-CENTER_Y)/(display.orientation=="horizontal" and xResize or yResize)
		else
			block[2][2] = {{"number", (image.x-CENTER_X)/(display.orientation=="horizontal" and yResize or xResize)}}
			block[2][3] = {{"number", -(image.y-CENTER_Y)/(display.orientation=="horizontal" and xResize or yResize)}}
			cellsBlockObject[2][4].text = (image.x-CENTER_X)/(display.orientation=="horizontal" and yResize or xResize)
			cellsBlockObject[3][4].text = -(image.y-CENTER_Y)/(display.orientation=="horizontal" and xResize or yResize)
		end
		funsP["записать сохранение"](IDOBJECT.."/scripts", json.encode(blocks))
		display.remove(groupScene)
		funBack = oldSceneBack
		SCENES["scripts"][1].alpha = 1
		SCENE = "scripts"
	end
end