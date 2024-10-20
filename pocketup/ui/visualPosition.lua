function scene_setPosVisual(idBlock, idParameter, blocks, blocksObjects)
	local oldSceneBack = funBack

	local settings = plugins.json.decode(funsP["получить сохранение"](app.idProject.."/options"))
	local CENTER_X = CENTER_X
	local CENTER_Y = CENTER_Y
	if (settings.orientation=="horizontal") then
		plugins.orientation.lock('landscape')
		CENTER_X, CENTER_Y = CENTER_Y, CENTER_X
	end

	app.scenes["scripts"][1].alpha = 0
	local groupScene = display.newGroup()
	if (utils.isWin and settings.orientation=="horizontal") then
		groupScene.xScale = display.contentWidth/display.contentHeight
		--groupScene.yScale = display.contentHeight/display.contentWidth/2
		groupScene.yScale = groupScene.xScale
		groupScene.y = CENTER_X-display.contentWidth*groupScene.yScale/2
	end
	app.scene = "visual_position"
	app.scenes[app.scene] = {groupScene}
	local funBackObjects = {}
	local funMenuObjects = {}
	local isBackScene = "back"
	
	local block = blocks[idBlock]
	--local formulas = blocks[idBlock][2][idParameter]
	local xResize, yResize = display.contentWidth/settings.displayWidth, display.contentHeight/settings.displayHeight


	local background = display.newImage(groupScene, app.idScene.."/icon.png", system.DocumentsDirectory)
	if (background==nil) then
		background = display.newImage(groupScene, "images/notVisible.png")
	end
	background.width, background.height = (settings.orientation=="horizontal" and display.contentHeight or display.contentWidth), (settings.orientation=="horizontal" and display.contentWidth or display.contentHeight)
	background.x, background.y = CENTER_X, CENTER_Y
	background:toBack()
	background.fill.effect = "filter.brightness"
	background.fill.effect.intensity = -0.25
	

	local obj_id = app.idObject:gsub(app.idScene.."/object_", "")
	local objectsElements = plugins.json.decode(funsP["получить сохранение"](app.idScene.."/objects"))
	local properties
	for i=1, #objectsElements do
		if (tostring(objectsElements[i][2])==obj_id) then
			properties = objectsElements[i][3]
			break
		end
	end

	local images = plugins.json.decode(funsP["получить сохранение"](app.idObject.."/images"))
	local image
	if (true) then
		if (#images==0) then
			image = display.newImage("images/pocketup.png")
			image.width, image.height = 100, 100
		elseif (properties==nil) then
			image = display.newImage(app.idObject.."/image_"..images[1][2]..".png", system.DocumentsDirectory)
		else
			if (properties.path==nil) then
				image = display.newImage(app.idObject.."/image_"..images[1][2]..".png", system.DocumentsDirectory)
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
	
	local topBarArray = topBar(groupScene, app.words[272], funMenuObjects, nil, funBackObjects, settings.orientation=="horizontal")
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
					funsP["записать сохранение"](app.idObject.."/scripts", plugins.json.encode(blocks))
				end
				display.remove(groupScene)
				if (settings.orientation=="horizontal") then
					plugins.orientation.lock('portrait')
				end
				funBack = oldSceneBack
				app.scenes["scripts"][1].alpha = 1
				app.scene = "scripts"
			end
			app.cerberus.newBannerQuestion(app.words[609], funEditingEnd, app.words[610], app.words[611])
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
		funsP["записать сохранение"](app.idObject.."/scripts", plugins.json.encode(blocks))
		display.remove(groupScene)
		if (settings.orientation=="horizontal") then
			plugins.orientation.lock('portrait')
		end
		funBack = oldSceneBack
		app.scenes["scripts"][1].alpha = 1
		app.scene = "scripts"
	end
end