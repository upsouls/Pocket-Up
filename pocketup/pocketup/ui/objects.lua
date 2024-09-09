-- сцена для просмотра всех объектов проекта

function scene_objects(pathScene, NAMEPROJECT, infoScene)
	IDSCENE = IDPROJECT.."/scene_"..infoScene[2]
	local groupScene = display.newGroup()
	local groupSceneScroll = display.newGroup()
	SCENE = "objects"
	SCENES[SCENE] = {groupSceneScroll, groupScene}

	local funMenuObjects = {}
	local funCheckObjects = {}
	local funBackObjects = {}

	local isBackScene = "back"
	local valueHeaderTopBar = NAMEPROJECT..": "..infoScene[1]
	local topBarArray = topBar(groupScene, valueHeaderTopBar, funMenuObjects, funCheckObjects, funBackObjects)

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


	local scenes = json.decode(funsP["получить сохранение"](pathScene))
	local pathObject =pathScene:sub(1, pathScene:len()-1)


	local arraySlots = {}


	local isMoveSlot = false
	local timerMoveSlot = nil
	local isTimerMoveSlot = false
	local function touchMoveSlot(event)
		if (event.phase=="began") then
			event.target:setFillColor(23/255,91/255,114/255)

			if (event.target.idSlot~=1 and type(event.target.infoScene[2]) == "number" and isBackScene=="back") then
				isTimerMoveSlot = true
				timerMoveSlot = timer.performWithDelay(250, function()
					isTimerMoveSlot = false
					isMoveSlot = true
					local groupSlot = event.target.myGroup
					local xScroll, yScroll = scrollProjects:getContentPosition()
					groupSlot.y = event.y-scrollProjects.y-yScroll
					groupSlot:toFront()
				end)
			end

			display.getCurrentStage():setFocus(event.target, event.id)
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
				local xScroll, yScroll = scrollProjects:getContentPosition()
				groupSlot.y = event.y-scrollProjects.y-yScroll

				local idOldSlot = event.target.idSlot
				local idNewSlot = idOldSlot
				if (idNewSlot>2 and event.target.aimPosY-event.target.height/2 > event.target.myGroup.y) then
					idNewSlot = idNewSlot-1
				elseif ( idNewSlot<#arraySlots and event.target.aimPosY+event.target.height/2 < event.target.myGroup.y) then
					idNewSlot = idNewSlot+1
				end


				if (idOldSlot~=idNewSlot) then

					local slot = arraySlots[idOldSlot]
					table.remove(arraySlots, idOldSlot)
					table.remove(scenes, idOldSlot)

					local plusOrMinus = idNewSlot-idOldSlot
					while (idNewSlot<#scenes and arraySlots[idNewSlot].myGroup.alpha<0.5 and plusOrMinus>0) do
						arraySlots[idNewSlot].idSlot = idNewSlot
						idNewSlot = idNewSlot+1
					end
					if (plusOrMinus<0 and arraySlots[idNewSlot].myGroup.alpha<0.5) then
						arraySlots[idNewSlot].idSlot = idNewSlot+1
						while (idNewSlot>1 and arraySlots[idNewSlot].myGroup.alpha<0.5) do
							idNewSlot = idNewSlot-1
							arraySlots[idNewSlot].idSlot = idNewSlot+1
						end
						idOldSlot = idNewSlot+1
					end

					table.insert(arraySlots, idNewSlot, slot)
					table.insert(scenes, idNewSlot, event.target.infoScene)
					funsP["записать сохранение"](pathScene, json.encode(scenes))
					local oldSlot = arraySlots[idOldSlot]
					oldSlot.idSlot = idOldSlot
					event.target.aimPosY = event.target.aimPosY+oldSlot.height*(idOldSlot<idNewSlot and 1 or -1)
					oldSlot.aimPosY = oldSlot.aimPosY+event.target.height*(idOldSlot<idNewSlot and -1 or 1)
					transition.to(oldSlot.myGroup, {time=200, y=oldSlot.aimPosY, transition=easing.inOutQuad})
					event.target.idSlot = idNewSlot
				end

			end

		elseif (event.phase~="moved") then
			event.target:setFillColor(0, 71/255, 93/255)
			display.getCurrentStage():setFocus(event.target, nil)

			if (isTimerMoveSlot or scenes[1]==event.target.infoScene) then
				if (isTimerMoveSlot) then
					timer.cancel(timerMoveSlot)
					isTimerMoveSlot = false
					printC(event.target.infoScene[2])
				end

				display.remove(SCENES[SCENE][1])
				display.remove(SCENES[SCENE][2])
				scene_scripts( event.target.infoScene[1], pathObject.."_"..event.target.infoScene[2], {pathScene, NAMEPROJECT, infoScene})

				-- открыть объект

			else

				if (type(event.target.infoScene[2]) == "number" and isBackScene=="back") then

				elseif (isBackScene=="back") then
				-- открыть/закрыть группу
				local isOpenGroup = event.target.infoScene[2]=="open"
				event.target.infoScene[2] = isOpenGroup and "closed" or "open"

				event.target.triangle.rotation = isOpenGroup and 90 or 180
				local i = event.target.idSlot
				if (not isOpenGroup) then
					local ySlotGroup = event.target.myGroup.y+event.target.height/2
					local isOpenSlot = true
					while (i<#arraySlots) do
						i = i+1
						local isString = arraySlots[i].infoScene[2]
						if (isOpenSlot or type(isString)=="string") then
							local slot = arraySlots[i]
							ySlotGroup = ySlotGroup+slot.height
							slot.myGroup.y, slot.myGroup.alpha = ySlotGroup-slot.height/2, 1
							slot.aimPosY = slot.myGroup.y
							if (type(isString)=="string") then
								isOpenSlot = isString=="open"
							end
						end
					end
				else

					local ySlotGroup = event.target.myGroup.y+event.target.height/2
					local isOpenSlot = false
					while (i<#arraySlots) do
						i=i+1
						local isString = arraySlots[i].infoScene[2]
						local slot = arraySlots[i]
						if (isOpenSlot or type(isString)=="string") then
							ySlotGroup = ySlotGroup+slot.height
							slot.myGroup.y = ySlotGroup-slot.height/2
							slot.aimPosY = slot.myGroup.y
							if (type(isString)=="string") then
								isOpenSlot = isString=="open"
							end
						else
							slot.myGroup.alpha = 0
						end
					end

				end
				funsP["записать сохранение"](pathScene, json.encode(scenes))

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
		if (isMoveSlot) then
			isMoveSlot = false
			event.target.myGroup.y = event.target.aimPosY
			if (event.target.idSlot>2 and (arraySlots[event.target.idSlot-1].myGroup.alpha<0.5 or arraySlots[event.target.idSlot-1].infoScene[2]=="closed")) then
				event.target.myGroup.alpha = 0
				local yPosSlot = event.target.myGroup.y-event.target.height/2
				local isOpenSlot = false
				for i=event.target.idSlot+1, #scenes do
					local slot = arraySlots[i]
					if (isOpenSlot or type(slot.infoScene[2])=="string") then
						yPosSlot = yPosSlot+slot.height
						slot.myGroup.y = yPosSlot-slot.height/2
						slot.aimPosY = slot.myGroup.y
						if (type(slot.infoScene[2])=="string") then
							isOpenSlot = slot.infoScene[2]=="open"
						end
					end
				end
			end

		end

	end
	return true
end


local headerNoObjects = nil

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
		groupMenu.x, groupMenu.y = display.contentWidth, event.target.slot.aimPosY+event.target.height/1.25+yPosScroll

		groupMenu.xScale, groupMenu.yScale, groupMenu.alpha = 0.3, 0.3, 0

		local arrayButtonsFunctions = {{4, "copy"}, {5, "delete"}, {6, "rename"}}
		if (type(event.target.slot.infoScene[2])=="string") then
			table.remove(arrayButtonsFunctions, 1)
		end
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
					counterProject[2] = counterProject[2]+1
					local copyObject = json.decode(json.encode(scenes[i]))
					copyObject[1] = correctNameSlot(copyObject[1])
					copyObject[2] = counterProject[2]
					funsP["записать сохранение"](IDPROJECT.."/counter",json.encode(counterProject))
					funsP["копировать объект"](pathObject.."_"..scenes[i][2], pathObject.."_"..copyObject[2], IDPROJECT)
					scenes[#scenes+1] = copyObject

					funsP["записать сохранение"](pathScene,json.encode(scenes))

					local iSlot = #arraySlots
					while (arraySlots[iSlot].myGroup.alpha<0.5) do
						iSlot=iSlot-1
					end
					local groupScene = display.newGroup()
					groupScene.y = arraySlots[iSlot].myGroup.y+arraySlots[iSlot].height/2+display.contentWidth/3.75/2
					groupSceneScroll:insert(groupScene)
					local buttonRect = display.newRect(0, 0, display.contentWidth, display.contentWidth/3.75)
					buttonRect.aimPosY = groupScene.y
					buttonRect.myGroup = groupScene
					buttonRect.infoScene = copyObject
					buttonRect.idSlot = #arraySlots+1
					arraySlots[#arraySlots+1] = buttonRect
					buttonRect.anchorX = 0
					buttonRect:setFillColor(0, 71/255, 93/255)
					buttonRect:addEventListener("touch", touchMoveSlot)
					groupScene:insert(buttonRect)
					local strokeIcon = display.newRect(buttonRect.x+buttonRect.height*0.9, buttonRect.y, buttonRect.height/1.3, buttonRect.height/1.4)
					strokeIcon.strokeWidth = 3
					strokeIcon:setStrokeColor(171/255, 219/255, 241/255)
					strokeIcon:setFillColor(0,0,0,0)
					groupScene:insert(strokeIcon)
					local containerIcon = display.newContainer(strokeIcon.width, strokeIcon.height)
					groupScene:insert(containerIcon)
					containerIcon.x, containerIcon.y = strokeIcon.x, strokeIcon.y
					if (#json.decode(funsP["получить сохранение"](pathObject.."_"..copyObject[2].."/images"))~=0) then
						pathMyObjectImage = pathObject.."_"..copyObject[2].."/image_"..json.decode(funsP["получить сохранение"](pathObject.."_"..copyObject[2].."/images"))[1][2]..".png"
						local imageIcon = display.newImage(pathMyObjectImage, system.DocumentsDirectory)
						containerIcon:insert(imageIcon)
						strokeIcon:toFront()

						local sizeIconProject = containerIcon.height/imageIcon.height
						if (imageIcon.width*sizeIconProject<containerIcon.width) then
							sizeIconProject = containerIcon.width/imageIcon.width
						end
						imageIcon.xScale, imageIcon.yScale = sizeIconProject, sizeIconProject
					end
					local nameProject = display.newText({
						text = copyObject[1],
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
					menuProject.slot = buttonRect
					menuProject:addEventListener("touch", touchMenuSlot)
					groupScene:insert(menuProject)

					local menu2Project = display.newImage("images/menu2.png")
					buttonRect.menu2 = menu2Project
					menu2Project.x, menu2Project.y, menu2Project.width, menu2Project.height = buttonRect.width-buttonRect.width/1.075, buttonRect.y, menuProject.width, menuProject.height
					menu2Project:setFillColor(0,0,0,0.5)
					groupScene:insert(menu2Project)

					buttonRect.strokeIcon = strokeIcon
					buttonRect.containerIcon = containerIcon
					buttonRect.nameProject = nameProject
					buttonRect.menu = menuProject
					buttonRect.menu2 = menu2Project

					local iEndSlot = #arraySlots
					while (arraySlots[iEndSlot].myGroup.alpha<0.5) do
						iEndSlot = iEndSlot-1
					end
					local arSlEnd = arraySlots[iEndSlot].myGroup
					local newScrollHeight = arSlEnd.y+arSlEnd.height/2+display.contentWidth/1.5
					scrollProjects:setScrollHeight(newScrollHeight)

					funsP["вызвать уведомление"](string.gsub(words[19], "<count>", 1))

				elseif (event.target.typeFunction=="delete") then
					local i = eventTargetMenu.slot.idSlot
					local slot = eventTargetMenu.slot
					local aimPosYSlot = slot.myGroup.y-slot.myGroup.height/2
					local isGroupDepos = type(slot.infoScene[2])=="string" and slot.myGroup.height or 0
					if (type(scenes[i][2])~="string") then
						funsP["удалить объект"](pathObject.."_"..scenes[i][2])
					end
					table.remove(arraySlots, i)
					table.remove(scenes, i)
					display.remove(slot.myGroup)
					if (#scenes==1) then
						headerNoObjects.alpha=1
					end
					funsP["записать сохранение"](pathScene,json.encode(scenes))

					if (type(slot.infoScene[2])=="string") then
						local iAlpha1Slot = i
						local slot
						while (iAlpha1Slot<=#arraySlots and arraySlots[iAlpha1Slot].myGroup.alpha<0.5) do
							arraySlots[iAlpha1Slot].myGroup.alpha=1
							isGroupDepos = isGroupDepos+arraySlots[iAlpha1Slot].height
							iAlpha1Slot=iAlpha1Slot+1
						end
					end

					i=i-1
					while (i<#scenes) do
						i=i+1
						local slot = arraySlots[i]
						slot.idSlot = i
						if (type(scenes[i][2])=="string") then
							aimPosYSlot = aimPosYSlot+slot.height
							slot.myGroup.y = slot.myGroup.y-slot.height*2+isGroupDepos
							slot.aimPosY = slot.myGroup.y
						elseif (slot.myGroup.alpha>0.5) then
							aimPosYSlot = aimPosYSlot+slot.height
							slot.myGroup.y = aimPosYSlot-slot.height/2
							slot.aimPosY = slot.myGroup.y
						end
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
					funsP["вызвать уведомление"](string.gsub(words[21], "<count>", 1))

				elseif (event.target.typeFunction=="rename") then 

					isBackScene = "block"

					local function isErrorCorrectNameObject(value)
						if (string.len(value)==0) then
							return(words[18])
						else
							return(isCorrectValue(value) and "" or words[15])
						end
					end
					local function endEditingRename(tableAnswer)
						isBackScene = "back"
						if (tableAnswer.isOk) then
							tableAnswer.value = string.gsub(tableAnswer.value, (isWin and '\r\n' or '\n'), " ")
							local slot = eventTargetMenu.slot
							slot.nameProject.text = tableAnswer.value
							scenes[slot.idSlot][1] = tableAnswer.value
							funsP["записать сохранение"](pathScene, json.encode(scenes))
						end
					end
					cerberus.newInputLine(words[13],words[14], isErrorCorrectNameObject, eventTargetMenu.slot.infoScene[1], endEditingRename)
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

local groupBackground = display.newGroup()
groupSceneScroll:insert(groupBackground)
local buttonRectBackground= display.newRect(0, display.contentWidth/3.75*0.5, display.contentWidth, display.contentWidth/3.75)
buttonRectBackground.infoScene = scenes[1]
buttonRectBackground.myGroup = groupBackground
arraySlots[1] = buttonRectBackground
buttonRectBackground.idSlot = 1
buttonRectBackground.anchorX = 0
buttonRectBackground:setFillColor(0, 71/255, 93/255)
buttonRectBackground: addEventListener("touch", touchMoveSlot)
groupBackground:insert(buttonRectBackground)
local strokeIcon = display.newRect(buttonRectBackground.x+buttonRectBackground.height*0.55, buttonRectBackground.y, buttonRectBackground.height/1.3, buttonRectBackground.height/1.4)
strokeIcon.strokeWidth = 3
strokeIcon:setStrokeColor(171/255, 219/255, 241/255)
strokeIcon:setFillColor(0,0,0,0)
groupBackground:insert(strokeIcon)

if (#json.decode(funsP["получить сохранение"](pathObject.."_"..scenes[1][2].."/images"))~=0) then
	local containerIcon = display.newContainer(strokeIcon.width, strokeIcon.height)
	groupBackground:insert(containerIcon)
	containerIcon.x, containerIcon.y = strokeIcon.x, strokeIcon.y

	local pathMyObjectImage = pathObject.."_"..scenes[1][2].."/image_"..json.decode(funsP["получить сохранение"](pathObject.."_"..scenes[1][2].."/images"))[1][2]..".png"
	print(pathMyObjectImage)
	local imageIcon = display.newImage(pathMyObjectImage, system.DocumentsDirectory)
	containerIcon:insert(imageIcon)
	strokeIcon:toFront()

	local sizeIconProject = containerIcon.height/imageIcon.height
	if (imageIcon.width*sizeIconProject<containerIcon.width) then
		sizeIconProject = containerIcon.width/imageIcon.width
	end
	imageIcon.xScale, imageIcon.yScale = sizeIconProject, sizeIconProject
end
local nameProject = display.newText({
	text = scenes[1][1],
	x = strokeIcon.x+strokeIcon.width/1.5,
	y = strokeIcon.y,
	width = display.contentWidth/2.12,
	height = fontSize0*1.15,
	fontSize = fontSize0
})
nameProject.anchorX = 0
nameProject:setFillColor(171/255, 219/255, 241/255)
groupBackground:insert(nameProject)

local headerActersAndObjects = display.newText(words[3], display.contentWidth/20, display.contentWidth/3.75*1.25, nil, fontSize1)
headerActersAndObjects.anchorX = 0
groupBackground:insert(headerActersAndObjects)

headerNoObjects = display.newText({
	text=words[2],
	x=CENTER_X,
	y=CENTER_Y,
	font=nil,
	fontSize=fontSize1*1.35,
	width=display.contentWidth,
	align="center",
})
headerNoObjects:setFillColor(1,1,1,0.75)
if (#scenes~=1) then
	headerNoObjects.alpha=0
end
groupSceneScroll:insert(headerNoObjects)

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
		display.getCurrentStage():setFocus(event.target , nil)

		if (isBackScene=="back") then
			if (event.target==circlePlus) then
				isBackScene="block"
				local function myFunImport(event)
					isBackScene="back"
					if (event.done=="ok") then

						local function onCompleteObject(event)
							if (event.isOk) then
								event.value = string.gsub(event.value, (isWin and '\r\n' or '\n'), " ")
								local counter = json.decode(funsP["получить сохранение"](IDPROJECT.."/counter"))
								counter[2] = counter[2]+1
								funsP["записать сохранение"](IDPROJECT.."/counter", json.encode(counter))
								funsP["создать объект"](IDPROJECT, pathObject.."_"..counter[2], event.value:gsub('\\','\\\\'))
								scenes[#scenes+1] = {event.value, counter[2]}
								funsP["записать сохранение"](pathScene, json.encode(scenes))

								--DDDDDDDDDDDDDDDDDDDD
								local iEndSlot = #arraySlots
								local i = iEndSlot+1
								while (arraySlots[iEndSlot].myGroup.alpha<0.5) do
									iEndSlot = iEndSlot-1
								end

								local groupScene = display.newGroup()
								local ySlotPosition = iEndSlot==1 and display.contentWidth/3.75*2 or arraySlots[iEndSlot].myGroup.y+arraySlots[iEndSlot].height*(type(arraySlots[iEndSlot].infoScene[2])=="string" and 1.5 or 1)

								groupScene.y = ySlotPosition
								groupSceneScroll:insert(groupScene)
								local buttonRect = display.newRect(0, 0, display.contentWidth, display.contentWidth/3.75)
								buttonRect.aimPosY = groupScene.y
								buttonRect.myGroup = groupScene
								buttonRect.infoScene = scenes[i]
								buttonRect.idSlot = i
								arraySlots[i] = buttonRect
								buttonRect.anchorX = 0
								buttonRect:setFillColor(0, 71/255, 93/255)
								buttonRect:addEventListener("touch", touchMoveSlot)
								groupScene:insert(buttonRect)
								local strokeIcon = display.newRect(buttonRect.x+buttonRect.height*0.9, buttonRect.y, buttonRect.height/1.3, buttonRect.height/1.4)
								strokeIcon.strokeWidth = 3
								strokeIcon:setStrokeColor(171/255, 219/255, 241/255)
								strokeIcon:setFillColor(0,0,0,0)
								groupScene:insert(strokeIcon)
								local containerIcon = display.newContainer(strokeIcon.width, strokeIcon.height)
								groupScene:insert(containerIcon)
								containerIcon.x, containerIcon.y = strokeIcon.x, strokeIcon.y

								pathMyObjectImage = pathObject.."_"..scenes[i][2].."/image_"..json.decode(funsP["получить сохранение"](pathObject.."_"..scenes[i][2].."/images"))[1][2]..".png"
								local imageIcon = display.newImage(pathMyObjectImage, system.DocumentsDirectory)
								containerIcon:insert(imageIcon)
								strokeIcon:toFront()

								local sizeIconProject = containerIcon.height/imageIcon.height
								if (imageIcon.width*sizeIconProject<containerIcon.width) then
									sizeIconProject = containerIcon.width/imageIcon.width
								end
								imageIcon.xScale, imageIcon.yScale = sizeIconProject, sizeIconProject

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
								menuProject.slot = buttonRect
								menuProject:addEventListener("touch", touchMenuSlot)
								groupScene:insert(menuProject)

								local menu2Project = display.newImage("images/menu2.png")
								buttonRect.menu2 = menu2Project
								menu2Project.x, menu2Project.y, menu2Project.width, menu2Project.height = buttonRect.width-buttonRect.width/1.075, buttonRect.y, menuProject.width, menuProject.height
								menu2Project:setFillColor(0,0,0,0.5)
								groupScene:insert(menu2Project)

								buttonRect.strokeIcon = strokeIcon
								buttonRect.containerIcon = containerIcon
								buttonRect.nameProject = nameProject
								buttonRect.menu = menuProject
								buttonRect.menu2 = menu2Project
								if (headerNoObjects.alpha>0.5) then
									headerNoObjects.alpha=0
								end 
								--DDDDDDDDDDDDDDDDDDDD

								scrollProjects:setScrollHeight(groupSceneScroll.height+display.contentWidth/1.5)

							end
						end

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

						cerberus.newInputLine(words[29],words[14], isCorrectValue,correctNameSlot(event.origFileName:match("(.+)%.")), onCompleteObject)
					end
				end
				funsP['импортировать изображение'](myFunImport)
			else
				if isBackScene == 'back' then
					SCENES[SCENE][2].alpha = 0
					SCENES[SCENE][1].alpha = 0
					isBackScene = 'block'
					display.remove(SCENES[SCENE][2])
					display.remove(SCENES[SCENE][1])
					scene_run_game("objects", {pathScene, NAMEPROJECT, infoScene})
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
circlePlay:addEventListener("touch", touchCirclePlus)
--ААААААААААААААААААААА
--ААААААААААААААААААААА
--ААААААААААААААААААААА
--ААААААААААААААААААААА
--ААААААААААААААААААААА
--ААААААААААААААААААААА


local i = 1
local ySlotPosition = display.contentWidth/3.75/2
local isOpenGroup = true
while (i<#scenes) do
	i = i+1
	if (type(scenes[i][2])=="number") then
		local groupScene = display.newGroup()
		if (isOpenGroup) then
			ySlotPosition = ySlotPosition+display.contentWidth/3.75
		else
			groupScene.alpha = 0
		end
		groupScene.y = ySlotPosition+display.contentWidth/3.75/2
		groupSceneScroll:insert(groupScene)
		local buttonRect = display.newRect(0, 0, display.contentWidth, display.contentWidth/3.75)
		buttonRect.aimPosY = groupScene.y
		buttonRect.myGroup = groupScene
		buttonRect.infoScene = scenes[i]
		buttonRect.idSlot = i
		arraySlots[i] = buttonRect
		buttonRect.anchorX = 0
		buttonRect:setFillColor(0, 71/255, 93/255)
		buttonRect:addEventListener("touch", touchMoveSlot)
		groupScene:insert(buttonRect)
		local strokeIcon = display.newRect(buttonRect.x+buttonRect.height*0.9, buttonRect.y, buttonRect.height/1.3, buttonRect.height/1.4)
		strokeIcon.strokeWidth = 3
		strokeIcon:setStrokeColor(171/255, 219/255, 241/255)
		strokeIcon:setFillColor(0,0,0,0)
		groupScene:insert(strokeIcon)
		local containerIcon = display.newContainer(strokeIcon.width, strokeIcon.height)
		groupScene:insert(containerIcon)
		containerIcon.x, containerIcon.y = strokeIcon.x, strokeIcon.y
		if (#json.decode(funsP["получить сохранение"](pathObject.."_"..scenes[i][2].."/images"))~=0) then
			pathMyObjectImage = pathObject.."_"..scenes[i][2].."/image_"..json.decode(funsP["получить сохранение"](pathObject.."_"..scenes[i][2].."/images"))[1][2]..".png"
			local imageIcon = display.newImage(pathMyObjectImage, system.DocumentsDirectory)
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
		menuProject.slot = buttonRect
		menuProject:addEventListener("touch", touchMenuSlot)
		groupScene:insert(menuProject)

		local menu2Project = display.newImage("images/menu2.png")
		buttonRect.menu2 = menu2Project
		menu2Project.x, menu2Project.y, menu2Project.width, menu2Project.height = buttonRect.width-buttonRect.width/1.075, buttonRect.y, menuProject.width, menuProject.height
		menu2Project:setFillColor(0,0,0,0.5)
		groupScene:insert(menu2Project)

		buttonRect.strokeIcon = strokeIcon
		buttonRect.containerIcon = containerIcon
		buttonRect.nameProject = nameProject
		buttonRect.menu = menuProject
		buttonRect.menu2 = menu2Project

elseif (type(scenes[i][2])=="string") then -- группы

ySlotPosition = ySlotPosition+display.contentWidth/3.75/2
local groupScene = display.newGroup()
groupScene.y = ySlotPosition+display.contentWidth/3.75/2*1.5
groupSceneScroll:insert(groupScene)
local buttonRect = display.newRect(0, 0, display.contentWidth, display.contentWidth/3.75/2)
buttonRect.aimPosY = groupScene.y
buttonRect.myGroup = groupScene
buttonRect.infoScene = scenes[i]
buttonRect.idSlot = i
arraySlots[i] = buttonRect
buttonRect.anchorX = 0
buttonRect:setFillColor(0, 71/255, 93/255)
buttonRect:addEventListener("touch", touchMoveSlot)
groupScene:insert(buttonRect)
local imageGroup = display.newImage("images/triangle.png")
buttonRect.triangle = imageGroup
imageGroup.x, imageGroup.y, imageGroup.width, imageGroup.height = buttonRect.width-buttonRect.width/1.1, buttonRect.y, buttonRect.height/2, buttonRect.height/2
imageGroup:setFillColor(171/255, 219/255, 241/255)
imageGroup.rotation = scenes[i][2]=="open" and 180 or 90
groupScene:insert(imageGroup)

local nameProject = display.newText({
	text = scenes[i][1],
	x = imageGroup.x+imageGroup.width*1.25,
	y = imageGroup.y,
	width = display.contentWidth/1.5,
	height = fontSize0*1.15,
	fontSize = fontSize0
})
nameProject.anchorX = 0
nameProject:setFillColor(171/255, 219/255, 241/255)
groupScene:insert(nameProject)

local menuProject = display.newImage("images/menu.png")
buttonRect.menu = menuProject
buttonRect.nameProject = nameProject
menuProject.x, menuProject.y, menuProject.width, menuProject.height = buttonRect.x+buttonRect.width/1.11, buttonRect.y, buttonRect.height/2.25, buttonRect.height/2.25
menuProject:setFillColor(171/255, 219/255, 241/255)
menuProject.slot = buttonRect
menuProject:addEventListener("touch", touchMenuSlot)
groupScene:insert(menuProject)

isOpenGroup = scenes[i][2]=="open"

end


end
scrollProjects:setScrollHeight(groupSceneScroll.height+display.contentWidth/1.5)

local function correctNameSlot(event)
	local isCorrectName=true
	for i=1, #scenes do
		if (scenes[i][1]==event) then
			isCorrectName=false
			break
		end
	end
	if (isCorrectName) then
		return event
	else
		isCorrectName=true
		local i = 0
		while (isCorrectName) do
			i = i+1
			local i2 = 1
			while (i2<=#scenes) do
				if (scenes[i2][1]==event.." ("..i..")") then
					break
				end
				i2 = i2+1
			end
			if (i2>#scenes) then
				isCorrectName=false
			end
		end
		return(event.." ("..i..")")
	end
end

local functionsMenu = {}

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
if (#scenes == 1) then
	funsP["вызвать уведомление"](words[12])
	isBackScene = "back"
else
	local arrayIdsWords = {["copy"]=4, ["delete"]=5}
	if (arrayIdsWords[isBackScene]) then
		topBarArray[3].text = words[arrayIdsWords[isBackScene]]
	else
		topBarArray[3].text = "заполни название!"
		topBarArray[3]:setFillColor(1,0,0)
	end
	topBarArray[5].alpha = 1
	for i=2, #scenes do
		local slot = arraySlots[i]
		if (type(slot.infoScene[2])~="string" and slot.myGroup.alpha>0.5) then
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

		end
		slot.menu.alpha=0
	end

end
end


functionsMenu["checkcopy"] = function ()
isBackScene = "back"
topBarArray[3].text = valueHeaderTopBar
topBarArray[5].alpha = 0
local countCopiedSlot = 0
for i=2, #scenes do
	local slot = arraySlots[i]
	if (type(slot.infoScene[2])~="string" and slot.myGroup.alpha>0.5) then
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
		if (slot.menu2.isCopySlot) then
			countCopiedSlot = countCopiedSlot+1
			local counterProject = json.decode(funsP["получить сохранение"](IDPROJECT.."/counter"))
			counterProject[2] = counterProject[2]+1
			local copyObject = json.decode(json.encode(scenes[i]))
			copyObject[1] = correctNameSlot(copyObject[1])
			copyObject[2] = counterProject[2]
			funsP["записать сохранение"](IDPROJECT.."/counter",json.encode(counterProject))
			funsP["копировать объект"](pathObject.."_"..scenes[i][2], pathObject.."_"..copyObject[2], IDPROJECT)
			scenes[#scenes+1] = copyObject
--BBBBBBBBBBBBBBBBBBBBBBB
local iSlot = #arraySlots
while (arraySlots[iSlot].myGroup.alpha<0.5) do
	iSlot=iSlot-1
end
local groupScene = display.newGroup()
groupScene.y = arraySlots[iSlot].myGroup.y+arraySlots[iSlot].height/2+display.contentWidth/3.75/2
groupSceneScroll:insert(groupScene)
local buttonRect = display.newRect(0, 0, display.contentWidth, display.contentWidth/3.75)
buttonRect.aimPosY = groupScene.y
buttonRect.myGroup = groupScene
buttonRect.infoScene = copyObject
buttonRect.idSlot = #arraySlots+1
arraySlots[#arraySlots+1] = buttonRect
buttonRect.anchorX = 0
buttonRect:setFillColor(0, 71/255, 93/255)
buttonRect:addEventListener("touch", touchMoveSlot)
groupScene:insert(buttonRect)
local strokeIcon = display.newRect(buttonRect.x+buttonRect.height*0.9, buttonRect.y, buttonRect.height/1.3, buttonRect.height/1.4)
strokeIcon.strokeWidth = 3
strokeIcon:setStrokeColor(171/255, 219/255, 241/255)
strokeIcon:setFillColor(0,0,0,0)
groupScene:insert(strokeIcon)
local containerIcon = display.newContainer(strokeIcon.width, strokeIcon.height)
groupScene:insert(containerIcon)
containerIcon.x, containerIcon.y = strokeIcon.x, strokeIcon.y
if (#json.decode(funsP["получить сохранение"](pathObject.."_"..copyObject[2].."/images"))~=0) then
	pathMyObjectImage = pathObject.."_"..copyObject[2].."/image_"..json.decode(funsP["получить сохранение"](pathObject.."_"..copyObject[2].."/images"))[1][2]..".png"
	local imageIcon = display.newImage(pathMyObjectImage, system.DocumentsDirectory)
	containerIcon:insert(imageIcon)
	strokeIcon:toFront()

	local sizeIconProject = containerIcon.height/imageIcon.height
	if (imageIcon.width*sizeIconProject<containerIcon.width) then
		sizeIconProject = containerIcon.width/imageIcon.width
	end
	imageIcon.xScale, imageIcon.yScale = sizeIconProject, sizeIconProject
end
local nameProject = display.newText({
	text = copyObject[1],
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
menuProject.slot = buttonRect
menuProject:addEventListener("touch", touchMenuSlot)
groupScene:insert(menuProject)

local menu2Project = display.newImage("images/menu2.png")
buttonRect.menu2 = menu2Project
menu2Project.x, menu2Project.y, menu2Project.width, menu2Project.height = buttonRect.width-buttonRect.width/1.075, buttonRect.y, menuProject.width, menuProject.height
menu2Project:setFillColor(0,0,0,0.5)
groupScene:insert(menu2Project)

buttonRect.strokeIcon = strokeIcon
buttonRect.containerIcon = containerIcon
buttonRect.nameProject = nameProject
buttonRect.menu = menuProject
buttonRect.menu2 = menu2Project
--BBBBBBBBBBBBBBBBBBBBBBB
slot.menu2.isCopySlot = nil
end
end
slot.menu.alpha=1
end
funsP["записать сохранение"](pathScene, json.encode(scenes))
local iEndSlot = #arraySlots
while (arraySlots[iEndSlot].myGroup.alpha<0.5) do
	iEndSlot = iEndSlot-1
end
local arSlEnd = arraySlots[iEndSlot].myGroup
local newScrollHeight = arSlEnd.y+arSlEnd.height/2+display.contentWidth/1.5
scrollProjects:setScrollHeight(newScrollHeight)

if (countCopiedSlot~=0) then
	funsP["вызвать уведомление"](string.gsub(words[countCopiedSlot==1 and 19 or 20], "<count>", countCopiedSlot))
end

end

functionsMenu["startdelete"] = functionsMenu["startcopy"]

functionsMenu["checkdelete"] = function ()
isBackScene = "back"
topBarArray[3].text = valueHeaderTopBar
topBarArray[5].alpha = 0
local iMinus = 0
local i2 = 1
while (i2-iMinus<#scenes) do
	i2 = i2+1
	local i = i2-iMinus
	local slot = arraySlots[i]
	slot.menu.alpha = 1
	if (type(scenes[i][2])=="string") then

		slot.aimPosY = (i<=2) and (display.contentWidth/3.75*1.5)+slot.height/2 or (arraySlots[i-1].aimPosY+arraySlots[i-1].height/2+slot.height/2)
		slot.myGroup.y = slot.aimPosY

	elseif (type(scenes[i][2])=="number" and not slot.menu2.isCopySlot) then
		slot.idSlot = i
		slot.aimPosY = (i<=2) and (display.contentWidth/3.75*1.5)+slot.height/2 or (arraySlots[i-1].aimPosY+arraySlots[i-1].height/2+slot.height/2)
		slot.myGroup.y = slot.aimPosY
	end
	if (type(slot.infoScene[2])~="string" and slot.myGroup.alpha>0.5) then
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
		if (slot.menu2.isCopySlot) then
			funsP["удалить объект"](pathObject.."_"..scenes[i][2])
			table.remove(arraySlots, i)
			table.remove(scenes, i)
			display.remove(slot.myGroup)
			iMinus = iMinus + 1
		end
	end
end
funsP["записать сохранение"](pathScene, json.encode(scenes))
if (#scenes == 1) then
	headerNoObjects.alpha = 1
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

if (iMinus~=0) then
	funsP["вызвать уведомление"](string.gsub(words[iMinus==1 and 21 or 22], "<count>", iMinus))
end

end


local function renameButton(event)
	if (event.phase=="ended") then

		local function editingEnd(tableRenameSlot)

			if (tableRenameSlot.isOk) then
				tableRenameSlot.value = string.gsub(tableRenameSlot.value, (isWin and '\r\n' or '\n'), " ")
				scenes[event.target.idSlot][1] = tableRenameSlot.value
				event.target.nameProject.text = tableRenameSlot.value
				funsP["записать сохранение"](pathScene, json.encode(scenes))
			end

			isBackScene = "back"
			topBarArray[4].alpha = 1
			topBarArray[3].text = valueHeaderTopBar
			arraySlots[1].myGroup.alpha = 1

			for i=2, #scenes do
				if (arraySlots[i].myGroup.alpha>0.5) then
					local slot = arraySlots[i]
					slot.myGroup.y = slot.aimPosY
					slot.menu.alpha = 1
					if (type(scenes[i][2])=="number") then
						slot.menu2.alpha = 1
						slot.strokeIcon.x = slot.strokeIcon.x+display.contentWidth/11
						slot.containerIcon.x = slot.strokeIcon.x
						slot.nameProject.x = slot.nameProject.x+display.contentWidth/11
						slot:removeEventListener("touch",renameButton)
					end
				end
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
		cerberus.newInputLine(words[13],words[14], checkCorrectName, event.target.infoScene[1], editingEnd)

	end
end

functionsMenu["startrename"] = function ()
if (#scenes == 1) then
	funsP["вызвать уведомление"](words[12])
	isBackScene = "back"
else
	topBarArray[4].alpha = 0
	arraySlots[1].myGroup.alpha = 0
	topBarArray[3].text = words[6]
	local yAimPos = arraySlots[1].y-arraySlots[1].height/2



	for i=2, #scenes do
		if (arraySlots[i].myGroup.alpha>0.5) then
			local slot = arraySlots[i]
			yAimPos = yAimPos+arraySlots[i].height
			slot.myGroup.y =  yAimPos-arraySlots[i].height/2
			slot.menu.alpha = 0
			if (type(scenes[i][2])=="number") then
				slot.menu2.alpha = 0
				slot.strokeIcon.x = slot.strokeIcon.x-display.contentWidth/11
				slot.containerIcon.x = slot.strokeIcon.x
				slot.nameProject.x = slot.nameProject.x-display.contentWidth/11
				slot:addEventListener("touch",renameButton)
			end
		end
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
end

functionsMenu["startnewGroup"] = function()
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
local function funEditingEnd(tableAnswer)
	isBackScene="back"
	if (tableAnswer.isOk) then
		tableAnswer.value = string.gsub(tableAnswer.value, (isWin and '\r\n' or '\n'), " ")

		local i = #arraySlots
		local iScene = #arraySlots+1
		while (arraySlots[i].myGroup.alpha<0.5) do
			i=i-1
		end

		scenes[iScene] = {tableAnswer.value, "open"}
		funsP["записать сохранение"](pathScene, json.encode(scenes))
		if (#scenes==2) then
			headerNoObjects.alpha = 0
		end
		local ySlotPosition = #scenes==2 and display.contentWidth/3.75*1.5 or arraySlots[i].aimPosY+arraySlots[i].height/2

		local groupScene = display.newGroup()
		groupScene.y = ySlotPosition+display.contentWidth/3.75/4
		groupSceneScroll:insert(groupScene)
		local buttonRect = display.newRect(0, 0, display.contentWidth, display.contentWidth/3.75/2)
		buttonRect.aimPosY = groupScene.y
		buttonRect.myGroup = groupScene
		buttonRect.infoScene = scenes[iScene]
		buttonRect.idSlot = iScene
		arraySlots[iScene] = buttonRect
		buttonRect.anchorX = 0
		buttonRect:setFillColor(0, 71/255, 93/255)
		buttonRect:addEventListener("touch", touchMoveSlot)
		groupScene:insert(buttonRect)
		local imageGroup = display.newImage("images/triangle.png")
		buttonRect.triangle = imageGroup
		imageGroup.x, imageGroup.y, imageGroup.width, imageGroup.height = buttonRect.width-buttonRect.width/1.1, buttonRect.y, buttonRect.height/2, buttonRect.height/2
		imageGroup:setFillColor(171/255, 219/255, 241/255)
		imageGroup.rotation = scenes[iScene][2]=="open" and 180 or 90
		groupScene:insert(imageGroup)

		local nameProject = display.newText({
			text = scenes[iScene][1],
			x = imageGroup.x+imageGroup.width*1.25,
			y = imageGroup.y,
			width = display.contentWidth/1.5,
			height = fontSize0*1.15,
			fontSize = fontSize0
		})
		nameProject.anchorX = 0
		nameProject:setFillColor(171/255, 219/255, 241/255)
		groupScene:insert(nameProject)

		local menuProject = display.newImage("images/menu.png")
		buttonRect.menu = menuProject
		buttonRect.nameProject = nameProject
		menuProject.x, menuProject.y, menuProject.width, menuProject.height = buttonRect.x+buttonRect.width/1.11, buttonRect.y, buttonRect.height/2.25, buttonRect.height/2.25
		menuProject:setFillColor(171/255, 219/255, 241/255)
		menuProject.slot = buttonRect
		menuProject:addEventListener("touch", touchMenuSlot)
		groupScene:insert(menuProject)

	end
end
cerberus.newInputLine(words[24], words[25], checkCorrectName, correctNameSlot(words[23]), funEditingEnd)
end

functionsMenu["startnewScene"] = function ()
isBackScene = "back"
local counter = json.decode(funsP["получить сохранение"](IDPROJECT.."/counter"))
local allScenes = json.decode(funsP["получить сохранение"](IDPROJECT.."/scenes"))
local function checkCorrectNameScene(value)
	if (string.len(value)==0) then
		return(words[18])
	else
		local isCorrect = true
		for i=1, #allScenes do
			if (value==allScenes[i][1]) then
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
local function endEditingInput(tableAnswer)
	if (tableAnswer.isOk) then
		tableAnswer.value = string.gsub(tableAnswer.value, (isWin and '\r\n' or '\n'), " ")
		counter[1] = counter[1]+1
		allScenes[#allScenes+1] = {tableAnswer.value, counter[1]}
		funsP["записать сохранение"](IDPROJECT.."/counter", json.encode(counter))
		funsP["записать сохранение"](IDPROJECT.."/scenes", json.encode(allScenes))

		funsP["создать сцену"](IDPROJECT, IDPROJECT.."/scene_"..counter[1])

		display.remove(SCENES[SCENE][1])
		display.remove(SCENES[SCENE][2])
		scene_scenes(IDPROJECT, NMPROJECT)

	end
end
local nameScene = words[28]
local OldNameScene = nameScene
local iNumberName = 0
while (checkCorrectNameScene(nameScene)~="") do
	iNumberName=iNumberName+1
	nameScene = OldNameScene.." ("..iNumberName..")"
end
cerberus.newInputLine(words[26], words[27], checkCorrectNameScene, nameScene, endEditingInput)
end

--AAAAAAAAAAAAAAAAAAA
--AAAAAAAAAAAAAAAAAAA
--AAAAAAAAAAAAAAAAAAA
--AAAAAAAAAAAAAAAAAAA
--AAAAAAAAAAAAAAAAAAA
local arrayAllButtonsFunctions = {
	["back"]={"back","startmenu",{{4,"copy"},{5,"delete"},{6,"rename"},{7,"newGroup"},{8,"newScene"},{9,"options"}}},

	["copy"]={"copy","copyAll",{{10,"copyAll"}}},
	["delete"]={"delete","deleteAll",{{10,"deleteAll"}}},

}
arrayAllButtonsFunctions["startmenu"] = arrayAllButtonsFunctions["back"]
arrayAllButtonsFunctions["copyAll"] = arrayAllButtonsFunctions["copy"]
arrayAllButtonsFunctions["deleteAll"] = arrayAllButtonsFunctions["delete"]

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
for i=2, #arraySlots do
	local slot = arraySlots[i]
	if (type(slot.infoScene[2])~="string" and slot.myGroup.alpha>0.5 and setIsCopy~=slot.menu2.isCopySlot) then
		slot.menu2.isCopySlot= setIsCopy
		slot.menu2.fill = {
			type="image",
			filename="images/checkbox_"..(setIsCopy and 2 or 1)..".png",
		}
		slot.menu2:setFillColor(171/255, 219/255, 241/255)
	end
end
end
functionsMenu["startdeleteAll"] = functionsMenu["startcopyAll"]

functionsMenu["copy"] =function ()
local isCancel = true
for i=2, #arraySlots do
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
if (isBackScene~="block") then
	if (isSystem==nil or isBackScene=="back") then
		if (isBackScene=="back") then
			display.remove(SCENES[SCENE][1])
			display.remove(SCENES[SCENE][2])
			if (#json.decode(funsP["получить сохранение"](IDPROJECT.."/scenes"))==1) then
				scene_projects()
			else
				scene_scenes(IDPROJECT, NMPROJECT)
			end
		elseif (isBackScene=="rename") then
			isBackScene = "back"
			topBarArray[4].alpha = 1
			topBarArray[3].text = valueHeaderTopBar
			arraySlots[1].myGroup.alpha = 1

			for i=2, #scenes do
				if (arraySlots[i].myGroup.alpha>0.5) then
					local slot = arraySlots[i]
					slot.myGroup.y = slot.aimPosY
					slot.menu.alpha = 1
					if (type(scenes[i][2])=="number") then
						slot.menu2.alpha = 1
						slot.strokeIcon.x = slot.strokeIcon.x+display.contentWidth/11
						slot.containerIcon.x = slot.strokeIcon.x
						slot.nameProject.x = slot.nameProject.x+display.contentWidth/11
						slot:removeEventListener("touch",renameButton)
					end
				end
			end
elseif (true) then -- isBackScene равен copy или delete
for i=2, #arraySlots do
	if (type(scenes[i][2])=="number") then
		arraySlots[i].menu2.isCopySlot = nil
	end
end
functionsMenu["check"..isBackScene]()
end
end

end
end
end


