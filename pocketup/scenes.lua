function scene_scenes(idProject, nameProjectScenes)
	IDPROJECT = idProject
	NMPROJECT = nameProjectScenes
	local groupScene = display.newGroup()
	local groupSceneScroll = display.newGroup()
	SCENE = "scenes"
	SCENES[SCENE] = {groupSceneScroll, groupScene}
	local isBackScene = "back"
	local funMenuObjects = {}
	local funCheckObjects = {}
	local funBackObjects = {}
	local valueHeaderTopBar = nameProjectScenes
	local topBarArray = topBar(groupScene, nameProjectScenes, funMenuObjects, funCheckObjects, funBackObjects)

	local scrollProjects = widget.newScrollView({
		width=display.contentWidth,
		height=display.contentHeight-topBarArray[1].height,
		horizontalScrollDisabled=true,
		isBounceEnabled=false,
		hideBackground=true,
	})
	scrollProjects.x=CENTER_X
	groupScene:insert(scrollProjects)
	scrollProjects.anchorY=0
	scrollProjects.y = topBarArray[1].y+topBarArray[1].height
	scrollProjects:insert(groupSceneScroll)
	select_Scroll = scrollProjects

	local scenes = json.decode(funsP["получить сохранение"](idProject.."/scenes"))
	print("работает")
	local arraySlots = {}

	local isMoveSlot = false
	local timerMoveSlot = nil
	local isTimerMoveSlot = false
	local function touchSlotOpenScene(event)
		if (event.phase=="began") then
			event.target:setFillColor(23/255,91/255,114/255)

			if (isBackScene=="back") then
				isTimerMoveSlot = true
				timerMoveSlot = timer.performWithDelay(250, function()
					isTimerMoveSlot = false
					isMoveSlot = true
					local groupSlot = event.target.myGroup
					groupSlot.y = event.y-scrollProjects.y
					groupSlot:toFront()
				end)
			end

			display.getCurrentStage():setFocus(event.target, nil)
		elseif (event.phase=="moved" and (math.abs(event.y-event.yStart)>20 or math.abs(event.x-event.xStart)>20)) then

			if isTimerMoveSlot then
				timer.cancel(timerMoveSlot)
				isTimerMoveSlot = false
			end

			if (not isMoveSlot) then
				scrollProjects:takeFocus(event)
				event.target:setFillColor(0, 71/255, 93/255)
			else
				local groupSlot = event.target.myGroup
				groupSlot.y = event.y-scrollProjects.y

				local idNewSlot = math.max(math.min(math.round(groupSlot.y/event.target.height+1), #arraySlots), 1)
				local idOldSlot = event.target.idSlot
				if (idOldSlot~=idNewSlot) then
					local slot = arraySlots[idOldSlot]
					table.remove(arraySlots, idOldSlot)
					table.insert(arraySlots, idNewSlot, slot)
					table.remove(scenes, idOldSlot)
					table.insert(scenes, idNewSlot, event.target.infoScene)
					funsP["записать сохранение"](idProject.."/scenes", json.encode(scenes))
					local oldSlot = arraySlots[idOldSlot]
					oldSlot.idSlot = idOldSlot
					transition.to(oldSlot.myGroup, {time=200, y=oldSlot.height*(oldSlot.idSlot-0.5), transition=easing.inOutQuad})
					event.target.idSlot = idNewSlot
				end

			end

		elseif (event.phase~="moved") then
			event.target:setFillColor(0, 71/255, 93/255)
			display.getCurrentStage():setFocus(event.target, nil)

			if (isTimerMoveSlot and isBackScene=="back") then
				timer.cancel(timerMoveSlot)
				isTimerMoveSlot = false

				display.remove(SCENES[SCENE][1])
				display.remove(SCENES[SCENE][2])
				scene_objects(idProject.."/scene_"..event.target.infoScene[2].."/objects", nameProjectScenes, event.target.infoScene)

			end
			if (isMoveSlot) then
				isMoveSlot = false
				event.target.myGroup.y = event.target.height*(event.target.idSlot-0.5)
			end

		end
		return true
	end


	local function touchMenuSlot(event)
		if (event.phase=="began") then
			display.getCurrentStage():setFocus(event.target, event.id)
		elseif (event.phase=="moved") then
			scrollProjects:takeFocus(event)
		else
			display.getCurrentStage():setFocus(event.target, nil)

			isBackScene="block"

			local notVisibleRect = display.newImage("images/notVisible.png")
			notVisibleRect.x, notVisibleRect.y, notVisibleRect.width, notVisibleRect.height = CENTER_X, CENTER_Y, display.contentWidth, display.contentHeight

			local xPosScroll, yPosScroll = scrollProjects:getContentPosition()
			local groupMenu = display.newGroup()
			groupMenu.x, groupMenu.y = display.contentWidth, event.target.slot.myGroup.y+event.target.height/1.25+yPosScroll

			groupMenu.xScale, groupMenu.yScale, groupMenu.alpha = 0.3, 0.3, 0

			local arrayButtonsFunctions = {{4, "copy"}, {5, "delete"}, {6, "rename"}}

			local buttons = {}
			local buttonContainer = display.newContainer(display.contentWidth/1.8, display.contentWidth/7)
			buttonContainer.anchorX, buttonContainer.anchorY = 1, 0
			groupMenu:insert(buttonContainer)
			local buttonCircle = display.newCircle(0,0,buttonContainer.width/2)
			buttonCircle:setFillColor(1,1,1,0.25)
			buttonCircle.xScale, buttonCircle.yScale, buttonCircle.alpha = 0.25, 0.25, 0
			buttonContainer:insert(buttonCircle)

			local eventTargetMenu = event.target
			local function touchTypeFunction(event)
				if (event.phase=="began") then
					buttonContainer:toFront()
					buttonContainer.y = event.target.y
					transition.to(buttonCircle, {time=150, xScale=1.1, yScale=1.1, alpha=1})
				elseif (event.phase=="moved") then
					transition.to(buttonCircle, {time=150, xScale=0.25, yScale=0.25, alpha=0})
				else

					isBackScene="back"

					local function isCorrectValue(value)
						local isCorrect = true
						for i=1, #scenes do
							if (scenes[i][1]==value) then
								isCorrect = false
								break
							end
						end
						return(isCorrect)
					end

					local function correctNameSlot(event)
						if (isCorrectValue(event)) then
							return event
						else
							local i = 1
							while (not isCorrectValue(event.." ("..i..")")) do
								i = i+1
							end
							return(event.." ("..i..")")
						end
					end


					if (event.target.typeFunction=="copy") then
						local i = eventTargetMenu.slot.idSlot
						local counterProject = json.decode(funsP["получить сохранение"](IDPROJECT.."/counter"))
						counterProject[1] = counterProject[1]+1
						local copyObject = json.decode(json.encode(scenes[i]))
						copyObject[1] = correctNameSlot(copyObject[1])
						copyObject[2] = counterProject[1]
						funsP["записать сохранение"](IDPROJECT.."/counter",json.encode(counterProject))
						funsP["копировать сцену"](IDPROJECT, IDPROJECT.."/scene_"..scenes[i][2], IDPROJECT.."/scene_"..copyObject[2])
						scenes[#scenes+1] = copyObject

						funsP["записать сохранение"](IDPROJECT.."/scenes",json.encode(scenes))

						local iSlot = #scenes

						local groupScene = display.newGroup()
						groupScene.y = display.contentWidth/3.75*(iSlot-0.5)
						groupSceneScroll:insert(groupScene)
						local buttonRect = display.newRect(0, 0, display.contentWidth, display.contentWidth/3.75)
						buttonRect.myGroup = groupScene
						buttonRect.infoScene = scenes[iSlot]
						buttonRect.idSlot = iSlot
						arraySlots[iSlot] = buttonRect
						buttonRect.anchorX = 0
						buttonRect:setFillColor(0, 71/255, 93/255)
						groupScene:insert(buttonRect)
						local strokeIcon = display.newRect(buttonRect.x+buttonRect.height*0.9, buttonRect.y, buttonRect.height/1.3, buttonRect.height/1.4)
						strokeIcon.strokeWidth = 3
						strokeIcon:setStrokeColor(171/255, 219/255, 241/255)
						strokeIcon:setFillColor(0,0,0,0)
						groupScene:insert(strokeIcon)
						local containerIcon = display.newContainer(strokeIcon.width, strokeIcon.height)
						groupScene:insert(containerIcon)
						containerIcon.x, containerIcon.y = strokeIcon.x, strokeIcon.y
						if (funsP["проверить наличие файла"](idProject.."/scene_"..scenes[iSlot][2].."/icon.png") ) then
							local imageIcon = display.newImage(idProject.."/scene_"..scenes[iSlot][2].."/icon.png", system.DocumentsDirectory)
							containerIcon:insert(imageIcon)
							strokeIcon:toFront()

							local sizeIconProject = containerIcon.height/imageIcon.height
							if (imageIcon.width*sizeIconProject<containerIcon.width) then
								sizeIconProject = containerIcon.width/imageIcon.width
							end
							imageIcon.xScale, imageIcon.yScale = sizeIconProject, sizeIconProject
						end
						local nameProject = display.newText({
							text = scenes[iSlot][1],
							x = strokeIcon.x+strokeIcon.width/1.5,
							y = strokeIcon.y,
							width = display.contentWidth/2.12,
							height = fontSize0*1.15,
							fontSize = fontSize0
						})
						nameProject.anchorX = 0
						nameProject:setFillColor(171/255, 219/255, 241/255)
						groupScene:insert(nameProject)

						local menuProject = display.newImage("images/menu.png")
						menuProject.slot = buttonRect
						menuProject:addEventListener("touch", touchMenuSlot)
						menuProject.x, menuProject.y, menuProject.width, menuProject.height = buttonRect.x+buttonRect.width/1.11, buttonRect.y, buttonRect.height/4.5, buttonRect.height/4.5
						menuProject:setFillColor(171/255, 219/255, 241/255)
						groupScene:insert(menuProject)

						local menu2Project = display.newImage("images/menu2.png")
						menu2Project.x, menu2Project.y, menu2Project.width, menu2Project.height = buttonRect.width-buttonRect.width/1.075, buttonRect.y, menuProject.width, menuProject.height
						menu2Project:setFillColor(0,0,0,0.5)
						groupScene:insert(menu2Project)

						buttonRect.strokeIcon = strokeIcon
						buttonRect.containerIcon = containerIcon
						buttonRect.menu = menuProject
						buttonRect.menu2 = menu2Project
						buttonRect.nameProject = nameProject



						buttonRect:addEventListener("touch", touchSlotOpenScene)

						local iEndSlot = #arraySlots
						local arSlEnd = arraySlots[iEndSlot].myGroup
						local newScrollHeight = arSlEnd.y+arSlEnd.height/2+display.contentWidth/1.5
						scrollProjects:setScrollHeight(newScrollHeight)

						funsP["вызвать уведомление"](string.gsub(words[32], "<count>", 1))


					elseif (event.target.typeFunction=="delete") then
						local i = eventTargetMenu.slot.idSlot
						local slot = eventTargetMenu.slot
						funsP["удалить объект"](IDPROJECT.."/scene_"..scenes[i][2])
						table.remove(arraySlots, i)
						table.remove(scenes, i)
						display.remove(slot.myGroup)

						funsP["записать сохранение"](IDPROJECT.."/scenes",json.encode(scenes))

						if (#scenes==1) then
							display.remove(SCENES[SCENE][1])
							display.remove(SCENES[SCENE][2])
							scene_objects(IDPROJECT.."/scene_"..scenes[1][2].."/objects", nameProjectScenes, scenes[1])
						else


							i=i-1
							while (i<#scenes) do
								i=i+1
								local slot = arraySlots[i]
								slot.idSlot = i

								slot.myGroup.y = slot.myGroup.y-slot.height
							end
							local iEndSlot = #arraySlots
							local xScroll, yScroll = scrollProjects:getContentPosition()
							local arSlEnd = arraySlots[iEndSlot].myGroup
							local newScrollHeight = arSlEnd.y+arSlEnd.height/2+display.contentWidth/1.5
							scrollProjects:setScrollHeight(newScrollHeight)
							scrollProjects:scrollToPosition({
								time=0, 
								y=math.min(math.max(yScroll, -newScrollHeight+scrollProjects.height), 0)
							})
							funsP["вызвать уведомление"](string.gsub(words[34], "<count>", 1))

						end

					elseif (event.target.typeFunction=="rename") then 
						local function isErrorCorrectNameObject(value)
							if (string.len(value)==0) then
								return(words[18])
							else
								return(isCorrectValue(value) and "" or words[15])
							end
						end
						local function endEditingRename(tableAnswer)
							if (tableAnswer.isOk) then
								tableAnswer.value = tableAnswer.value:gsub( (isWin and '\r\n' or '\n'), ' ')
								local slot = eventTargetMenu.slot
								slot.nameProject.text = tableAnswer.value
								scenes[slot.idSlot][1] = tableAnswer.value
								funsP["записать сохранение"](IDPROJECT.."/scenes", json.encode(scenes))
							end
						end
						cerberus.newInputLine(words[31],words[27], isErrorCorrectNameObject, eventTargetMenu.slot.infoScene[1], endEditingRename)
					end

					for i=1, #buttons do
						buttons[i]:removeEventListener("touch", touchTypeFunction)
					end
					display.remove(notVisibleRect)
					transition.to(groupMenu, {time=200, alpha=0, onComolete=function ()
						display.remove(groupMenu)
					end})
				end
				return(true)
			end

			for i=1, #arrayButtonsFunctions do
				buttons[i] = display.newRect(0, display.contentWidth/7*(i-1), display.contentWidth/1.8, display.contentWidth/7)
				buttons[i].anchorX, buttons[i].anchorY = 1, 0
				buttons[i]:setFillColor(48/255, 48/255, 48/255)
				groupMenu:insert(buttons[i])
				buttons[i].typeFunction = arrayButtonsFunctions[i][2]
				buttons[i]:addEventListener("touch",touchTypeFunction)

				buttons[i].header = display.newText(words[arrayButtonsFunctions[i][1]], -buttons[i].width/1.1, buttons[i].y+buttons[i].height/2, nil, fontSize1)
				buttons[i].header.anchorX=0
				groupMenu:insert(buttons[i].header)

			end

			transition.to(groupMenu, {time=150, xScale=1, yScale=1, alpha=1, transition=easing.outQuad})

			notVisibleRect:addEventListener("touch", function (event)
				if (event.phase=="ended") then
					isBackScene="back"
					display.remove(notVisibleRect)
					for i=1, #buttons do
						buttons[i]:removeEventListener("touch", touchTypeFunction)
					end
					transition.to(groupMenu, {time=200, alpha=0, onComolete=function ()
						display.remove(groupMenu)
					end})
				end
				return(true)
			end)


		end
		return(true)
	end



	for i=1, #scenes do
		local groupScene = display.newGroup()
		groupScene.y = display.contentWidth/3.75*(i-0.5)
		groupSceneScroll:insert(groupScene)
		local buttonRect = display.newRect(0, 0, display.contentWidth, display.contentWidth/3.75)
		buttonRect.myGroup = groupScene
		buttonRect.infoScene = scenes[i]
		buttonRect.idSlot = i
		arraySlots[i] = buttonRect
		buttonRect.anchorX = 0
		buttonRect:setFillColor(0, 71/255, 93/255)
		groupScene:insert(buttonRect)
		local strokeIcon = display.newRect(buttonRect.x+buttonRect.height*0.9, buttonRect.y, buttonRect.height/1.3, buttonRect.height/1.4)
		strokeIcon.strokeWidth = 3
		strokeIcon:setStrokeColor(171/255, 219/255, 241/255)
		strokeIcon:setFillColor(0,0,0,0)
		groupScene:insert(strokeIcon)
		local containerIcon = display.newContainer(strokeIcon.width, strokeIcon.height)
		groupScene:insert(containerIcon)
		containerIcon.x, containerIcon.y = strokeIcon.x, strokeIcon.y
		if (funsP["проверить наличие файла"](idProject.."/scene_"..scenes[i][2].."/icon.png") ) then
			local imageIcon = display.newImage(idProject.."/scene_"..scenes[i][2].."/icon.png", system.DocumentsDirectory)
			containerIcon:insert(imageIcon)
			strokeIcon:toFront()

			local sizeIconProject = containerIcon.height/imageIcon.height
			if (imageIcon.width*sizeIconProject<containerIcon.width) then
				sizeIconProject = containerIcon.width/imageIcon.width
			end
			imageIcon.xScale, imageIcon.yScale = sizeIconProject, sizeIconProject
		end
		local nameProject = display.newText({
			text = scenes[i][1],
			x = strokeIcon.x+strokeIcon.width/1.5,
			y = strokeIcon.y,
			width = display.contentWidth/2.12,
			height = fontSize0*1.15,
			fontSize = fontSize0
		})
		nameProject.anchorX = 0
		nameProject:setFillColor(171/255, 219/255, 241/255)
		groupScene:insert(nameProject)

		local menuProject = display.newImage("images/menu.png")
		menuProject.slot = buttonRect
		menuProject:addEventListener("touch", touchMenuSlot)
		menuProject.x, menuProject.y, menuProject.width, menuProject.height = buttonRect.x+buttonRect.width/1.11, buttonRect.y, buttonRect.height/4.5, buttonRect.height/4.5
		menuProject:setFillColor(171/255, 219/255, 241/255)
		groupScene:insert(menuProject)

		local menu2Project = display.newImage("images/menu2.png")
		menu2Project.x, menu2Project.y, menu2Project.width, menu2Project.height = buttonRect.width-buttonRect.width/1.075, buttonRect.y, menuProject.width, menuProject.height
		menu2Project:setFillColor(0,0,0,0.5)
		groupScene:insert(menu2Project)

		buttonRect.strokeIcon = strokeIcon
		buttonRect.containerIcon = containerIcon
		buttonRect.menu = menuProject
		buttonRect.menu2 = menu2Project
		buttonRect.nameProject = nameProject



		buttonRect:addEventListener("touch", touchSlotOpenScene)


	end
	scrollProjects:setScrollHeight(groupSceneScroll.height+display.contentWidth/1.5)

--AAAAAAAAAAAAAAAAAAAAA
local circlePlus = display.newCircle(CENTER_X+display.contentWidth/2-display.contentWidth/8, CENTER_Y+display.contentHeight/2-display.contentWidth/8-75, display.contentWidth/11.5)
circlePlus:setFillColor(1, 172/255, 8/255)
groupScene:insert(circlePlus)
local circlePlusAlpha = display.newCircle(circlePlus.x, circlePlus.y, display.contentWidth/11.5)
circlePlusAlpha:setFillColor(1,1,1,0.25)
circlePlusAlpha.xScale, circlePlusAlpha.yScale, circlePlusAlpha.alpha = 0.5, 0.5, 0
groupScene:insert(circlePlusAlpha)
circlePlus.circleAlpha = circlePlusAlpha
local circlePlay = display.newCircle(circlePlus.x, circlePlus.y-display.contentWidth/8*1.75, display.contentWidth/11.5)
circlePlay:setFillColor(1, 172/255, 8/255)
groupScene:insert(circlePlay)
local runIcon = display.newImageRect('images/play.png', fontSize0*1.75, fontSize0*1.75)
runIcon.x = circlePlay.x
runIcon.y = circlePlay.y
groupScene:insert(runIcon)
local circlePlayAlpha = display.newCircle(circlePlay.x, circlePlay.y, display.contentWidth/11.5)
circlePlayAlpha:setFillColor(1,1,1,0.25)
circlePlayAlpha.xScale, circlePlayAlpha.yScale, circlePlayAlpha.alpha = 0.75, 0.75, 0
groupScene:insert(circlePlayAlpha)
circlePlay.circleAlpha = circlePlayAlpha
circlePlusText = display.newText("+",circlePlus.x, circlePlus.y, nil, fontSize0*1.75)
groupScene:insert(circlePlusText)
local function touchCirclePlus(event)
	if (event.phase=="began") then
		transition.to(event.target.circleAlpha, {alpha=1, xScale=1, yScale=1, time=100})
		display.getCurrentStage():setFocus(event.target, event.id)
	elseif (event.phase=="moved") then
	else
		transition.to(event.target.circleAlpha, {alpha=0, xScale=0.75, yScale=0.75, time=100})
		display.getCurrentStage():setFocus(event.target, nil)

		if (isBackScene=="back") then
			if (event.target==circlePlus) then

				local function isCorrectValue(value)
					if (string.len(value)==0) then
						return(words[18])
					else
						local isCorrect = true
						for i=1, #scenes do
							if (scenes[i][1]==value) then
								isCorrect = false
								break
							end
						end
						return(isCorrect and "" or words[15])
					end
				end

				local function correctNameSlot(event)
					if (isCorrectValue(event)=="") then
						return event
					else
						local i = 1
						while (isCorrectValue(event.." ("..i..")")~="") do
							i = i+1
						end
						return(event.." ("..i..")")
					end
				end

				local function onCompleteObject(event)
					if (event.isOk) then
						event.value = event.value:gsub( (isWin and '\r\n' or '\n'), ' ')
						local counter = json.decode(funsP["получить сохранение"](IDPROJECT.."/counter"))
						counter[1] = counter[1]+1
						scenes[#scenes+1] = {event.value, counter[1]}
						funsP["записать сохранение"](IDPROJECT.."/scenes", json.encode(scenes))
						funsP["записать сохранение"](IDPROJECT.."/counter", json.encode(counter))
						funsP["создать сцену"](IDPROJECT, IDPROJECT.."/scene_"..counter[1])

						local iSlot = #scenes
						local groupScene = display.newGroup()
						groupScene.y = display.contentWidth/3.75*(iSlot-0.5)
						groupSceneScroll:insert(groupScene)
						local buttonRect = display.newRect(0, 0, display.contentWidth, display.contentWidth/3.75)
						buttonRect.myGroup = groupScene
						buttonRect.infoScene = scenes[iSlot]
						buttonRect.idSlot = iSlot
						arraySlots[iSlot] = buttonRect
						buttonRect.anchorX = 0
						buttonRect:setFillColor(0, 71/255, 93/255)
						groupScene:insert(buttonRect)
						local strokeIcon = display.newRect(buttonRect.x+buttonRect.height*0.9, buttonRect.y, buttonRect.height/1.3, buttonRect.height/1.4)
						strokeIcon.strokeWidth = 3
						strokeIcon:setStrokeColor(171/255, 219/255, 241/255)
						strokeIcon:setFillColor(0,0,0,0)
						groupScene:insert(strokeIcon)
						local containerIcon = display.newContainer(strokeIcon.width, strokeIcon.height)
						groupScene:insert(containerIcon)
						containerIcon.x, containerIcon.y = strokeIcon.x, strokeIcon.y
						if (funsP["проверить наличие файла"](idProject.."/scene_"..scenes[iSlot][2].."/icon.png") ) then
							local imageIcon = display.newImage(idProject.."/scene_"..scenes[iSlot][2].."/icon.png", system.DocumentsDirectory)
							containerIcon:insert(imageIcon)
							strokeIcon:toFront()

							local sizeIconProject = containerIcon.height/imageIcon.height
							if (imageIcon.width*sizeIconProject<containerIcon.width) then
								sizeIconProject = containerIcon.width/imageIcon.width
							end
							imageIcon.xScale, imageIcon.yScale = sizeIconProject, sizeIconProject
						end
						local nameProject = display.newText({
							text = scenes[iSlot][1],
							x = strokeIcon.x+strokeIcon.width/1.5,
							y = strokeIcon.y,
							width = display.contentWidth/2.12,
							height = fontSize0*1.15,
							fontSize = fontSize0
						})
						nameProject.anchorX = 0
						nameProject:setFillColor(171/255, 219/255, 241/255)
						groupScene:insert(nameProject)

						local menuProject = display.newImage("images/menu.png")
						menuProject.slot = buttonRect
						menuProject:addEventListener("touch", touchMenuSlot)
						menuProject.x, menuProject.y, menuProject.width, menuProject.height = buttonRect.x+buttonRect.width/1.11, buttonRect.y, buttonRect.height/4.5, buttonRect.height/4.5
						menuProject:setFillColor(171/255, 219/255, 241/255)
						groupScene:insert(menuProject)

						local menu2Project = display.newImage("images/menu2.png")
						menu2Project.x, menu2Project.y, menu2Project.width, menu2Project.height = buttonRect.width-buttonRect.width/1.075, buttonRect.y, menuProject.width, menuProject.height
						menu2Project:setFillColor(0,0,0,0.5)
						groupScene:insert(menu2Project)

						buttonRect.strokeIcon = strokeIcon
						buttonRect.containerIcon = containerIcon
						buttonRect.menu = menuProject
						buttonRect.menu2 = menu2Project
						buttonRect.nameProject = nameProject



						buttonRect:addEventListener("touch", touchSlotOpenScene)

						local iEndSlot = #arraySlots
						local arSlEnd = arraySlots[iEndSlot].myGroup
						local newScrollHeight = arSlEnd.y+arSlEnd.height/2+display.contentWidth/1.5
						scrollProjects:setScrollHeight(newScrollHeight)

					end
				end

				cerberus.newInputLine(words[26],words[27], isCorrectValue,correctNameSlot(words[28]), onCompleteObject)
			else
				if isBackScene == 'back' then
	                SCENES[SCENE][2].alpha = 0
	                SCENES[SCENE][1].alpha = 0
	                isBackScene = 'block'
	                scene_run_game(function()
	                    display.setDefault("background", 4/255, 34/255, 44/255)
	                    SCENES[SCENE][2].alpha = 1
	                    SCENES[SCENE][1].alpha = 1
	                    isBackScene = "back"
	                end)
	            end
			end
--DDDDDDDDDDDDDDDDDDDD
--DDDDDDDDDDDDDDDDDDDD
--DDDDDDDDDDDDDDDDDDDD
--DDDDDDDDDDDDDDDDDDDD
--DDDDDDDDDDDDDDDDDDDD

end
end
return(true)
end

circlePlus:addEventListener("touch", touchCirclePlus)
circlePlayAlpha:setFillColor(1,1,1,0.125)
circlePlay:addEventListener("touch", touchCirclePlus)
--AAAAAAAAAAAAAAAAAAAAA

local functionsMenu = {}

local function correctNameScene(value)
	local isCorrect = true
	for i=1, #scenes do
		if (scenes[i][1]==value) then
			isCorrect = false
			break
		end
	end
	if (isCorrect) then
		return(value)
	else
		local isUnCorrect = true
		local id = 0
		while (isUnCorrect) do
			id=id+1
			local isCorrect = true
			for i=1, #scenes do
				if (scenes[i][1]==value.." ("..id..")") then
					isCorrect = false
					break
				end
			end
			if (isCorrect) then
				isUnCorrect = false
			end
		end
		return(value.." ("..id..")")
	end
end

local arrayAllButtonsFunctions = {
	["back"]={"back","startmenu",{{4,"copy"},{5,"delete"},{6,"rename"},{9,"options"}}},

	["copy"]={"copy","copyAll",{{10,"copyAll"}}},
	["delete"]={"delete","deleteAll",{{10,"deleteAll"}}},

}
arrayAllButtonsFunctions["startmenu"] = arrayAllButtonsFunctions["back"]
arrayAllButtonsFunctions["copyAll"] = arrayAllButtonsFunctions["copy"]
arrayAllButtonsFunctions["deleteAll"] = arrayAllButtonsFunctions["delete"]

functionsMenu["startoptions"] = function()
display.remove(SCENES[SCENE][1])
display.remove(SCENES[SCENE][2])
scene_options(IDPROJECT, NMPROJECT)
end

local function touchMenu2CopySlot(event)
	if (event.phase=="began") then
		transition.to(event.target, {xScale=0.75, yScale=0.75, time=100})
		display.getCurrentStage():setFocus(event.target, event.id)
	elseif (event.phase=="moved") then
		transition.to(event.target, {xScale=1, yScale=1, time=200})
		scrollProjects:takeFocus(event)
	else
		if (event.target.isCopySlot) then
			event.target.isCopySlot=nil
		else
			event.target.isCopySlot = true
		end
		event.target.fill = {
			type="image",
			filename="images/checkbox_"..(event.target.isCopySlot and 2 or 1)..".png",
		}
		event.target:setFillColor(171/255, 219/255, 241/255)
		transition.to(event.target, {xScale=1, yScale=1, time=200})
		display.getCurrentStage():setFocus(event.target, nil)
	end
	return(true)
end


functionsMenu["startcopy"] = function()
local arrayIdsWords = {["copy"]=4, ["delete"]=5}
if (arrayIdsWords[isBackScene]) then
	topBarArray[3].text = words[arrayIdsWords[isBackScene]]
else
	topBarArray[3].text = "заполни название!"
	topBarArray[3]:setFillColor(1,0,0)
end
topBarArray[5].alpha = 1
for i=1, #scenes do
	local slot = arraySlots[i]
	slot.strokeIcon.x = slot.strokeIcon.x+display.contentWidth/20
	slot.containerIcon.x = slot.strokeIcon.x
	slot.nameProject.x = slot.nameProject.x+display.contentWidth/20

	slot.menu2.fill = {
		type="image",
		filename="images/checkbox_1.png",
	}
	slot.menu2:setFillColor(171/255, 219/255, 241/255)
	slot.menu2.x = slot.menu2.x+display.contentWidth/40
	slot.menu2.isCopySlot = nil
	slot.menu2:addEventListener("touch", touchMenu2CopySlot)

	slot.menu.alpha=0
end

end
functionsMenu["startdelete"] = functionsMenu["startcopy"]


functionsMenu["checkcopy"] = function ()
isBackScene = "back"
topBarArray[3].text = valueHeaderTopBar
topBarArray[5].alpha = 0
local countCopiedSlot = 0
for i=1, #scenes do
	local slot = arraySlots[i]
	slot.strokeIcon.x = slot.strokeIcon.x-display.contentWidth/20
	slot.containerIcon.x = slot.strokeIcon.x
	slot.nameProject.x = slot.nameProject.x-display.contentWidth/20

	slot.menu2:removeEventListener("touch", touchMenu2CopySlot)
	slot.menu2.fill = {
		type="image",
		filename="images/menu2.png",
	}
	slot.menu2:setFillColor(0,0,0,0.5)
	slot.menu2.x = slot.menu2.x-display.contentWidth/40
	slot.menu.alpha = 1

	if (slot.menu2.isCopySlot) then
		countCopiedSlot = countCopiedSlot+1
		local counter = json.decode(funsP["получить сохранение"](IDPROJECT.."/counter"))
		counter[1] = counter[1]+1
		funsP["записать сохранение"](IDPROJECT.."/counter", json.encode(counter) )
		scenes[#scenes+1] = {correctNameScene(slot.infoScene[1]), counter[1]}
		funsP["копировать сцену"](IDPROJECT, IDPROJECT.."/scene_"..slot.infoScene[2], IDPROJECT.."/scene_"..counter[1])
		funsP["записать сохранение"](IDPROJECT.."/scenes", json.encode(scenes))


		local i = #scenes
		local groupScene = display.newGroup()
		groupScene.y = display.contentWidth/3.75*(i-0.5)
		groupSceneScroll:insert(groupScene)
		local buttonRect = display.newRect(0, 0, display.contentWidth, display.contentWidth/3.75)
		buttonRect.myGroup = groupScene
		buttonRect.infoScene = scenes[i]
		buttonRect.idSlot = i
		arraySlots[i] = buttonRect
		buttonRect.anchorX = 0
		buttonRect:setFillColor(0, 71/255, 93/255)
		groupScene:insert(buttonRect)
		local strokeIcon = display.newRect(buttonRect.x+buttonRect.height*0.9, buttonRect.y, buttonRect.height/1.3, buttonRect.height/1.4)
		strokeIcon.strokeWidth = 3
		strokeIcon:setStrokeColor(171/255, 219/255, 241/255)
		strokeIcon:setFillColor(0,0,0,0)
		groupScene:insert(strokeIcon)
		local containerIcon = display.newContainer(strokeIcon.width, strokeIcon.height)
		groupScene:insert(containerIcon)
		containerIcon.x, containerIcon.y = strokeIcon.x, strokeIcon.y
		if (funsP["проверить наличие файла"](idProject.."/scene_"..scenes[i][2].."/icon.png") ) then
			local imageIcon = display.newImage(idProject.."/scene_"..scenes[i][2].."/icon.png", system.DocumentsDirectory)
			containerIcon:insert(imageIcon)
			strokeIcon:toFront()

			local sizeIconProject = containerIcon.height/imageIcon.height
			if (imageIcon.width*sizeIconProject<containerIcon.width) then
				sizeIconProject = containerIcon.width/imageIcon.width
			end
			imageIcon.xScale, imageIcon.yScale = sizeIconProject, sizeIconProject
		end
		local nameProject = display.newText({
			text = scenes[i][1],
			x = strokeIcon.x+strokeIcon.width/1.5,
			y = strokeIcon.y,
			width = display.contentWidth/2.12,
			height = fontSize0*1.15,
			fontSize = fontSize0
		})
		nameProject.anchorX = 0
		nameProject:setFillColor(171/255, 219/255, 241/255)
		groupScene:insert(nameProject)

		local menuProject = display.newImage("images/menu.png")
		menuProject.x, menuProject.y, menuProject.width, menuProject.height = buttonRect.x+buttonRect.width/1.11, buttonRect.y, buttonRect.height/4.5, buttonRect.height/4.5
		menuProject:setFillColor(171/255, 219/255, 241/255)
		groupScene:insert(menuProject)

		local menu2Project = display.newImage("images/menu2.png")
		menu2Project.x, menu2Project.y, menu2Project.width, menu2Project.height = buttonRect.width-buttonRect.width/1.075, buttonRect.y, menuProject.width, menuProject.height
		menu2Project:setFillColor(0,0,0,0.5)
		groupScene:insert(menu2Project)

		buttonRect.strokeIcon = strokeIcon
		buttonRect.containerIcon = containerIcon
		buttonRect.menu = menuProject
		buttonRect.menu2 = menu2Project
		buttonRect.nameProject = nameProject

		buttonRect:addEventListener("touch", touchSlotOpenScene)

	end

end

if (countCopiedSlot~=0) then
	funsP["вызвать уведомление"](string.gsub(words[countCopiedSlot==1 and 32 or 33], "<count>", countCopiedSlot))
end

scrollProjects:setScrollHeight(groupSceneScroll.height+display.contentWidth/1.5)
end


functionsMenu["checkdelete"] = function ()
isBackScene = "back"
topBarArray[3].text = valueHeaderTopBar
topBarArray[5].alpha = 0
local iMinus = 0
local i2 = 0
while (i2-iMinus<#scenes) do
	i2 = i2+1
	local i = i2-iMinus
	local slot = arraySlots[i]
	if (not slot.menu2.isCopySlot) then
		slot.menu.alpha = 1
		slot.strokeIcon.x = slot.strokeIcon.x-display.contentWidth/20
		slot.containerIcon.x = slot.strokeIcon.x
		slot.nameProject.x = slot.nameProject.x-display.contentWidth/20

		slot.menu2:removeEventListener("touch", touchMenu2CopySlot)
		slot.menu2.fill = {
			type="image",
			filename="images/menu2.png",
		}
		slot.menu2:setFillColor(0,0,0,0.5)
		slot.menu2.x = slot.menu2.x-display.contentWidth/40

		slot.idSlot = i
		slot.aimPosY = slot.height*(i-0.5)
		slot.myGroup.y = slot.aimPosY

	else

		table.remove(arraySlots, i)
		display.remove(slot.myGroup)
		table.remove(scenes, i)
		iMinus = iMinus+1
		funsP["удалить объект"](IDPROJECT.."/scene_"..slot.infoScene[2])
		funsP["записать сохранение"](IDPROJECT.."/scenes", json.encode(scenes))

	end


end

if (iMinus~=0) then
	funsP["вызвать уведомление"](string.gsub(words[iMinus==1 and 34 or 35], "<count>", iMinus))

	local iEndSlot = #arraySlots
	local xScroll, yScroll = scrollProjects:getContentPosition()
	local arSlEnd = arraySlots[iEndSlot].myGroup
	local newScrollHeight = arSlEnd.y+arSlEnd.height/2+display.contentWidth/1.5
	scrollProjects:setScrollHeight(newScrollHeight)
	scrollProjects:scrollToPosition({
		time=0, 
		y=math.min(math.max(yScroll, -newScrollHeight+scrollProjects.height), 0)
	})

end

if (#scenes==0) then
	scenes = {{words[28],1}}
	funsP["записать сохранение"](IDPROJECT.."/counter", "[1, 0, 0, 0]" )
	funsP["записать сохранение"](IDPROJECT.."/scenes", json.encode(scenes) )
	funsP["создать сцену"](IDPROJECT, IDPROJECT.."/scene_1")
end
if (#scenes==1) then
	display.remove(SCENES[SCENE][1])
	display.remove(SCENES[SCENE][2])
	scene_objects(idProject.."/scene_"..scenes[1][2].."/objects", nameProjectScenes, scenes[1])
end

end



local function renameButton(event)
	if (event.phase=="ended") then

		local function editingEnd(tableRenameSlot)

			if (tableRenameSlot.isOk) then
				tableRenameSlot.value = tableRenameSlot.value:gsub( (isWin and '\r\n' or '\n'), ' ')
				scenes[event.target.idSlot][1] = tableRenameSlot.value
				event.target.nameProject.text = tableRenameSlot.value
				funsP["записать сохранение"](IDPROJECT.."/scenes", json.encode(scenes))
			end

			isBackScene = "back"
			topBarArray[4].alpha = 1
			topBarArray[3].text = valueHeaderTopBar

			for i=1, #scenes do
				local slot = arraySlots[i]
				slot.menu.alpha = 1
				slot.menu2.alpha = 1
				slot.strokeIcon.x = slot.strokeIcon.x+display.contentWidth/11
				slot.containerIcon.x = slot.strokeIcon.x
				slot.nameProject.x = slot.nameProject.x+display.contentWidth/11
				slot:removeEventListener("touch",renameButton)
			end

			local xScroll, yScroll = scrollProjects:getContentPosition()
			local newScrollHeight = groupSceneScroll.height+display.contentWidth/1.5
			scrollProjects:setScrollHeight(newScrollHeight)
			scrollProjects:scrollToPosition({
				time=0, 
				y=math.min(math.max(yScroll, -newScrollHeight+scrollProjects.height), 0)
			})

		end
		local function checkCorrectName(value)
			if (utf8.len(value)==0) then
				return(words[18])
			else
				local isCorrect = true
				for i=1, #scenes do
					if (scenes[i][1]==value) then
						isCorrect = false
						break
					end
				end
				if (isCorrect) then
					return("")
				else
					return(words[15])
				end
			end
		end
		cerberus.newInputLine(words[31],words[27], checkCorrectName, event.target.infoScene[1], editingEnd)

	end
end



functionsMenu["startrename"] = function ()
topBarArray[4].alpha = 0
topBarArray[3].text = words[6]


for i=1, #scenes do
	local slot = arraySlots[i]
	slot.menu.alpha = 0
	slot.menu2.alpha = 0
	slot.strokeIcon.x = slot.strokeIcon.x-display.contentWidth/11
	slot.containerIcon.x = slot.strokeIcon.x
	slot.nameProject.x = slot.nameProject.x-display.contentWidth/11
	slot:addEventListener("touch",renameButton)
end

local iEndSlot = #arraySlots
while (arraySlots[iEndSlot].myGroup.alpha<0.5) do
	iEndSlot = iEndSlot-1
end
local xScroll, yScroll = scrollProjects:getContentPosition()
local arSlEnd = arraySlots[iEndSlot].myGroup
local newScrollHeight = arSlEnd.y+arSlEnd.height/2+display.contentWidth/1.5
scrollProjects:setScrollHeight(newScrollHeight)
scrollProjects:scrollToPosition({
	time=0, 
	y=math.min(math.max(yScroll, -newScrollHeight+scrollProjects.height), 0)
})

end


functionsMenu["back"] = function()
isBackScene = arrayAllButtonsFunctions[isBackScene][2]
local notVisibleRect = display.newImage("images/notVisible.png")
notVisibleRect.x, notVisibleRect.y, notVisibleRect.width, notVisibleRect.height = CENTER_X, CENTER_Y, display.contentWidth, display.contentHeight

local groupMenu = display.newGroup()
groupMenu.x, groupMenu.y = display.contentWidth/1.02, CENTER_Y-display.contentHeight/2+(display.contentWidth-display.contentWidth/1.02)

groupMenu.xScale, groupMenu.yScale, groupMenu.alpha = 0.3, 0.3, 0

local arrayButtonsFunctions = arrayAllButtonsFunctions[isBackScene][3]
local buttons = {}
local buttonContainer = display.newContainer(display.contentWidth/1.8, display.contentWidth/7)
buttonContainer.anchorX, buttonContainer.anchorY = 1, 0
groupMenu:insert(buttonContainer)
local buttonCircle = display.newCircle(0,0,buttonContainer.width/2)
buttonCircle:setFillColor(1,1,1,0.25)
buttonCircle.xScale, buttonCircle.yScale, buttonCircle.alpha = 0.25, 0.25, 0
buttonContainer:insert(buttonCircle)

local function touchTypeFunction(event)
	if (event.phase=="began") then
		buttonContainer:toFront()
		buttonContainer.y = event.target.y
		transition.to(buttonCircle, {time=150, xScale=1.1, yScale=1.1, alpha=1})
	elseif (event.phase=="moved") then
		transition.to(buttonCircle, {time=150, xScale=0.25, yScale=0.25, alpha=0})
	else
		isBackScene = event.target.typeFunction
		functionsMenu["start"..isBackScene]()
		for i=1, #buttons do
			buttons[i]:removeEventListener("touch", touchTypeFunction)
		end
		display.remove(notVisibleRect)
		transition.to(groupMenu, {time=200, alpha=0, onComolete=function ()
			display.remove(groupMenu)
		end})
	end
	return(true)
end

for i=1, #arrayButtonsFunctions do
	buttons[i] = display.newRect(0, display.contentWidth/7*(i-1), display.contentWidth/1.5, display.contentWidth/7)
	buttons[i].anchorX, buttons[i].anchorY = 1, 0
	buttons[i]:setFillColor(48/255, 48/255, 48/255)
	groupMenu:insert(buttons[i])
	buttons[i].typeFunction = arrayButtonsFunctions[i][2]
	buttons[i]:addEventListener("touch",touchTypeFunction)

	buttons[i].header = display.newText(words[arrayButtonsFunctions[i][1]], -buttons[i].width/1.1, buttons[i].y+buttons[i].height/2, nil, fontSize1)
	buttons[i].header.anchorX=0
	groupMenu:insert(buttons[i].header)

end

transition.to(groupMenu, {time=150, xScale=1, yScale=1, alpha=1, transition=easing.outQuad})

notVisibleRect:addEventListener("touch", function (event)
	if (event.phase=="ended") then
		isBackScene = arrayAllButtonsFunctions[isBackScene][1]
		display.remove(notVisibleRect)
		for i=1, #buttons do
			buttons[i]:removeEventListener("touch", touchTypeFunction)
		end
		transition.to(groupMenu, {time=200, alpha=0, onComolete=function ()
			display.remove(groupMenu)
		end})
	end
	return(true)
end)
end


functionsMenu["startcopyAll"] = function()
isBackScene = arrayAllButtonsFunctions[isBackScene][1]
local setIsCopy = arrayAllButtonsFunctions[isBackScene][3][1][1] == 10 and true or nil
for i=1, #arraySlots do
	local slot = arraySlots[i]

	slot.menu2.isCopySlot= setIsCopy
	slot.menu2.fill = {
		type="image",
		filename="images/checkbox_"..(setIsCopy and 2 or 1)..".png",
	}
	slot.menu2:setFillColor(171/255, 219/255, 241/255)
end
end

functionsMenu["startdeleteAll"] = functionsMenu["startcopyAll"]


functionsMenu["copy"] =function ()
local isCancel = true
for i=1, #arraySlots do
	if (arraySlots[i].menu2.isCopySlot==nil) then
		isCancel = false
		break
	end
end
if (isCancel) then
	arrayAllButtonsFunctions[isBackScene][3][1][1] = 11
else
	arrayAllButtonsFunctions[isBackScene][3][1][1] = 10
end
functionsMenu["back"]()
end

functionsMenu["delete"] = functionsMenu["copy"]

funMenuObjects[1] = function ()
functionsMenu[isBackScene]()
end
funCheckObjects[1] = function ()
functionsMenu["check"..isBackScene]()
end

funBackObjects[1] = function (isSystem)
if (isSystem==nil or isBackScene=="back") then
	if (isBackScene=="back") then
		display.remove(SCENES[SCENE][1])
		display.remove(SCENES[SCENE][2])

		scene_projects()

	elseif (isBackScene=="rename") then
		isBackScene = "back"
		topBarArray[4].alpha = 1
		topBarArray[3].text = valueHeaderTopBar

		for i=1, #scenes do
			local slot = arraySlots[i]
			slot.menu.alpha = 1
			slot.menu2.alpha = 1
			slot.strokeIcon.x = slot.strokeIcon.x+display.contentWidth/11
			slot.containerIcon.x = slot.strokeIcon.x
			slot.nameProject.x = slot.nameProject.x+display.contentWidth/11
			slot:removeEventListener("touch",renameButton)
		end
elseif (true) then -- isBackScene равен copy или delete
for i=1, #arraySlots do
	arraySlots[i].menu2.isCopySlot = nil
end
functionsMenu["check"..isBackScene]()
end
end

end
end