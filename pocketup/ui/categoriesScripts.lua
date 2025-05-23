-- сцена категории блоков

oldBackScripts = nil
function scene_categoriesScripts(funAddBlock)

	if (oldBackScripts==nil) then
		oldBackScripts = funBack
	end

	local groupScene = display.newGroup()
	local groupSceneScroll = display.newGroup()

	app.scene = "categoriesScripts"
	app.scenes[app.scene] = {groupScene, groupSceneScroll}
	local touchBackMenu = {function ()
		display.remove(groupScene)
		display.remove(groupSceneScroll)
		app.scene = "scripts"
		app.scenes[app.scene][1].alpha = 1
		app.scenes[app.scene][1].x = 0
		funBack = oldBackScripts
		oldBackScripts = nil
	end}
	local topBarArray = topBar(groupScene, app.words[66], nil, nil, touchBackMenu)
	topBarArray[4].alpha = 0

	local scrollProjects = plugins.widget.newScrollView({
		width=display.contentWidth,
		height=display.contentHeight-topBarArray[1].height,
		horizontalScrollDisabled=true,
		isBounceEnabled=false,
		hideBackground=true,
	})
	scrollProjects.x = CENTER_X
	groupScene:insert(scrollProjects)
	scrollProjects:insert(groupSceneScroll)
	scrollProjects.anchorY=0
	scrollProjects.y = topBarArray[1].y+topBarArray[1].height

	local categories = {{67,"used","orange"}, {68,"event","grown"},{69,"control","orange"}--[[,{614,"cycles","orange"}]],{70,"physic","blue"},{71,"sounds","violet"},{72,"images","green"},{427,"particles","green"},{73,"pen","darkgreen"},{74,"data","red"},{75,"device","gold"},{532,"textFields","green"},{531,"miniScenes","yellow"},{587, "elementInterface", "pink"}}

	for i=1, #categories do
		local sheetOptions = {
			width=1,
			height=142,
			numFrames=109,
		}
		local imageSheet = graphics.newImageSheet("blocks/block_"..categories[i][3].."_2.png", sheetOptions)
		local animates = {{
			name="stand",
			start=109,
			count=1,
			time=0,
			loopCount=1,
		}}

		local sprite = display.newSprite(imageSheet, animates)
		sprite.width, sprite.height = display.contentWidth, display.contentWidth/4/1.25
		sprite.anchorX = 0
		sprite.x, sprite.y = 0, sprite.height*(i-0.5)/1.0625
		groupSceneScroll:insert(sprite)
		if (i==1) then
			sprite.fill.effect = "filter.desaturate"
			sprite.fill.effect.intensity = 1
		end
		local header = display.newText(app.words[categories[i][1]], display.contentWidth/22, sprite.y, nil, app.fontSize0*1.25)
		if (categories[i][3]=="light") then
			header:setFillColor(0,0,0)
		end
		header.anchorX=0
		header.alpha = 0.75
		groupSceneScroll:insert(header)
		sprite.category = categories[i][2]
		sprite.nameCategory = categories[i][1]
		sprite:addEventListener("touch", function (event)
			if (event.phase=="began") then
				display.getCurrentStage():setFocus(event.target, event.id)
			elseif (event.phase=="moved" and (math.abs(event.y-event.yStart)>20 or math.abs(event.x-event.xStart)>20)) then
				scrollProjects:takeFocus(event)
			elseif (event.phase~="moved") then
				display.getCurrentStage():setFocus(event.target, nil)
				local myCategory = event.target.category
				local myNameCategory = event.target.nameCategory
				display.remove(app.scenes[app.scene][1])
				display.remove(app.scenes[app.scene][2])
				scene_categoryScripts(myCategory, myNameCategory, funAddBlock)
			end
			return true
		end)
	end
	scrollProjects:setScrollHeight(groupSceneScroll.height+display.contentWidth/2)
end