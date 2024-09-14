-- сцена со всеми проектами

function scene_projects()
	local groupScene = display.newGroup()
	local groupSceneScroll = display.newGroup()
	SCENE = "projects"
	SCENES[SCENE] = {groupSceneScroll, groupScene}
	local funMenuObjects={}
	local funCheckObjects = {}
	local funBackObjects = {}
	local isBackScene = "back"
	local valueHeaderTopBar = words[1]
	local topBarArray = topBar(groupScene, 1, funMenuObjects, funCheckObjects, funBackObjects)

	local scrollProjects = widget.newScrollView({
		width=display.contentWidth,
		height=display.contentHeight-topBarArray[1].height,
		horizontalScrollDisabled=true,
		isBounceEnabled=false,
		hideBackground=true,
	})
	scrollProjects.x=CENTER_X
--scrollProjects.anchorX = 0
groupScene:insert(scrollProjects)
scrollProjects.anchorY = 0
scrollProjects.y = topBarArray[1].y+topBarArray[1].height
scrollProjects:insert(groupSceneScroll)
select_Scroll = scrollProjects

local isSortProjects = funsP["прочитать сс сохранение"]("наличие сортировки проектов")=="true"
local projectsAndIds = funsP["получить проекты"](isSortProjects)
local projects = projectsAndIds.projects
local idsProjects = projectsAndIds.ids
local arraySlots = {}

local function touchOpenProject(event)
	if (event.xStart < CENTER_X+display.contentWidth/2-20) then
		if (event.phase=="began") then
			event.target:setFillColor(23/255,91/255,114/255)
		elseif (event.phase=="moved" and (math.abs(event.y-event.yStart)>20 or math.abs(event.x-event.xStart)>20)) then
			event.target:setFillColor(0, 71/255, 93/255)
			scrollProjects:takeFocus(event)
		elseif (event.phase~="moved") then
			event.target:setFillColor(0, 71/255, 93/255)

			if (isBackScene=="back") then
				local infoProject = idsProjects[event.target.idSlot]
				table.remove(idsProjects, event.target.idSlot)
				table.insert(idsProjects, 1, infoProject)
				print(json.encode(idsProjects))

				funsP["записать сс сохранение"]("сортировка проектов - дата открытия", json.encode(idsProjects))

				display.remove(SCENES[SCENE][1])
				display.remove(SCENES[SCENE][2])
				local scenesToProject = json.decode(funsP["получить сохранение"](event.target.idProject.."/scenes"))
				if (#scenesToProject==1) then
					IDPROJECT = event.target.idProject
					NMPROJECT = event.target.nameProject
					scene_objects(event.target.idProject.."/scene_"..scenesToProject[1][2].."/objects", event.target.nameProject, scenesToProject[1])
				else
					scene_scenes(event.target.idProject, event.target.nameProject)
				end
			end

		end
	end
	return true
end


local function touchMenuSlot(event)
	if (event.phase=="began") then
		display.getCurrentStage():setFocus(event.target, event.id)
	elseif (event.phase=="moved" and (math.abs(event.x-event.xStart)>20 or math.abs(event.y-event.yStart)>20)) then
		scrollProjects:takeFocus(event)
	elseif (event.phase=="ended") then
		display.getCurrentStage():setFocus(event.target, nil)

		isBackScene="block"

		local notVisibleRect = display.newImage("images/notVisible.png")
		notVisibleRect.x, notVisibleRect.y, notVisibleRect.width, notVisibleRect.height = CENTER_X, CENTER_Y, display.contentWidth, display.contentHeight

		local xPosScroll, yPosScroll = scrollProjects:getContentPosition()
		local groupMenu = display.newGroup()
		groupMenu.x, groupMenu.y = display.contentWidth, event.target.slot.myGroup.y+event.target.height/1.25+yPosScroll

		groupMenu.xScale, groupMenu.yScale, groupMenu.alpha = 0.3, 0.3, 0

		local arrayButtonsFunctions = {{4, "copy"}, {5, "delete"}, {6, "rename"},{9, "options"}}

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
			elseif (event.phase=="moved" and (math.abs(event.x-event.xStart)>20 or math.abs(event.y-event.yStart)>20)) then
				transition.to(buttonCircle, {time=150, xScale=0.25, yScale=0.25, alpha=0})
			elseif (event.phase=="ended") then

				isBackScene="back"

				local function isCorrectValue(value)
					local isCorrect = true
					for i=1, #projects do
						if (projects[i][1]==value) then
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


--здесь if на что нажали
if (event.target.typeFunction=="copy") then
	local i = eventTargetMenu.slot.idSlot
	local counterProject = tonumber(funsP["прочитать сс сохранение"]("counter_projects"))
	counterProject = counterProject+1
	local copyObject = json.decode(json.encode(projects[idsProjects[i]]))
	copyObject[1] = correctNameSlot(copyObject[1])
	copyObject[2] = "project_"..counterProject
	funsP["записать сс сохранение"]("counter_projects",counterProject)
	funsP["копировать проект"](eventTargetMenu.slot.idProject, "project_"..counterProject)
	projects[#projects+1] = copyObject

	funsP["записать сс сохранение"]("список проектов",json.encode(projects))
	table.insert(idsProjects, 1, #projects)
	local idsProjectsCreated = json.decode(funsP["прочитать сс сохранение"]("сортировка проектов - дата создания"))
	local idsProjectsOpen = json.decode(funsP["прочитать сс сохранение"]("сортировка проектов - дата открытия"))
	table.insert(idsProjectsCreated, 1, #projects)
	table.insert(idsProjectsOpen, 1, #projects)
	funsP["записать сс сохранение"]("сортировка проектов - дата открытия", json.encode(idsProjectsOpen))
	funsP["записать сс сохранение"]("сортировка проектов - дата создания", json.encode(idsProjectsCreated))

	local iSort = 1
	local i = idsProjects[iSort]
	local groupScene = display.newGroup()
	groupScene.y = display.contentWidth/3.75*(iSort-0.5)
	groupSceneScroll:insert(groupScene)
	local buttonRect = display.newRect(0, 0, display.contentWidth, display.contentWidth/3.75)
	table.insert(arraySlots, 1, buttonRect)
	buttonRect.idProject= projects[i][2]
	buttonRect.idSlot = 1
	buttonRect.nameProject = projects[i][1]
	buttonRect.anchorX = 0
	buttonRect:setFillColor(0, 71/255, 93/255)
	groupScene:insert(buttonRect)
	local strokeIcon = display.newRect(buttonRect.x+buttonRect.height*0.55, buttonRect.y, buttonRect.height/1.3, buttonRect.height/1.4)
	strokeIcon.strokeWidth = 3
	strokeIcon:setStrokeColor(171/255, 219/255, 241/255)
	strokeIcon:setFillColor(0,0,0,0)
	groupScene:insert(strokeIcon)
	local containerIcon = display.newContainer(strokeIcon.width, strokeIcon.height)
	groupScene:insert(containerIcon)
	containerIcon.x, containerIcon.y = strokeIcon.x, strokeIcon.y
	local imageIcon = display.newImage(projects[i][2].."/icon.png", system.DocumentsDirectory)
	containerIcon:insert(imageIcon)
	strokeIcon:toFront()

	local sizeIconProject = containerIcon.height/imageIcon.height
	if (imageIcon.width*sizeIconProject<containerIcon.width) then
		sizeIconProject = containerIcon.width/imageIcon.width
	end
	imageIcon.xScale, imageIcon.yScale = sizeIconProject, sizeIconProject

	local nameProject = display.newText({
		text = projects[i][1],
		x = strokeIcon.x+strokeIcon.width/1.5,
		y = strokeIcon.y,
		width = display.contentWidth/1.75,
		height = fontSize0*1.15,
		fontSize = fontSize0
	})
	nameProject.anchorX = 0
	nameProject:setFillColor(171/255, 219/255, 241/255)
	groupScene:insert(nameProject)

	local menuProject = display.newImage("images/menu.png")
	menuProject:addEventListener("touch", touchMenuSlot)
	menuProject.x, menuProject.y, menuProject.width, menuProject.height = buttonRect.x+buttonRect.width/1.11, buttonRect.y, buttonRect.height/4.5, buttonRect.height/4.5
	menuProject:setFillColor(171/255, 219/255, 241/255)
	groupScene:insert(menuProject)
	local menu2Project = display.newImage("images/checkbox_1.png")
	menu2Project.x, menu2Project.y, menu2Project.width, menu2Project.height = buttonRect.width-buttonRect.width/1.075, buttonRect.y, menuProject.width, menuProject.height
	menu2Project.alpha = 0
	groupScene:insert(menu2Project)

	buttonRect.myGroup = groupScene
	buttonRect.strokeIcon = strokeIcon
	buttonRect.containerIcon = containerIcon
	buttonRect.textNameProject = nameProject
	buttonRect.menu = menuProject
	buttonRect.menu2 = menu2Project
	menu2Project.slot = buttonRect
	menuProject.slot = buttonRect


	buttonRect:addEventListener("touch", touchOpenProject)

	for i=2, #arraySlots do
		local slot = arraySlots[i]
		slot.idSlot = i
		slot.myGroup.y = slot.height*(i-0.5)
	end


	local iEndSlot = #arraySlots
	local arSlEnd = arraySlots[iEndSlot].myGroup
	local newScrollHeight = arSlEnd.y+arSlEnd.height/2+display.contentWidth/1.5
	scrollProjects:setScrollHeight(newScrollHeight)


elseif (event.target.typeFunction=="delete") then
	local i = eventTargetMenu.slot.idSlot
	local slot = eventTargetMenu.slot
	funsP["удалить объект"](slot.idProject)
	table.remove(arraySlots, i)
	table.remove(projects, idsProjects[i])
	local idDelSave = idsProjects[i]
	table.remove(idsProjects, i)
	display.remove(slot.myGroup)

	local idsProjectsCreated = json.decode(funsP["прочитать сс сохранение"]("сортировка проектов - дата создания"))
	local idsProjectsOpen = json.decode(funsP["прочитать сс сохранение"]("сортировка проектов - дата открытия"))
	for iDelSave=1, #idsProjectsCreated do
		if (idsProjectsCreated[iDelSave]==idDelSave) then
			table.remove(idsProjectsCreated, iDelSave)
			break
		end
	end
	for iDelSave=1, #idsProjectsOpen do
		if (idsProjectsOpen[iDelSave]==idDelSave) then
			table.remove(idsProjectsOpen, iDelSave)
			break
		end
	end

	for iDelSave=1, #idsProjects do
		if(idsProjects[iDelSave]>idDelSave) then
			idsProjects[iDelSave] = idsProjects[iDelSave]-1
		end
		if(idsProjectsCreated[iDelSave]>idDelSave) then
			idsProjectsCreated[iDelSave] = idsProjectsCreated[iDelSave]-1
		end
		if(idsProjectsOpen[iDelSave]>idDelSave) then
			idsProjectsOpen[iDelSave] = idsProjectsOpen[iDelSave]-1
		end
	end

	funsP["записать сс сохранение"]("список проектов", json.encode(projects))
	funsP["записать сс сохранение"]("сортировка проектов - дата создания", json.encode(idsProjectsCreated))
	funsP["записать сс сохранение"]("сортировка проектов - дата открытия", json.encode(idsProjectsOpen))

	if (#projects==0) then
		display.remove(SCENES[SCENE][1])
		display.remove(SCENES[SCENE][2])
		scene_projects()
	else


		i=i-1
		while (i<#projects) do
			i=i+1
			local slot = arraySlots[i]
			slot.idSlot = i

			slot.myGroup.y = slot.height*(i-0.5)
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
		funsP["вызвать уведомление"](string.gsub(words[37], "<count>", 1))

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
			slot.textNameProject.text = tableAnswer.value
			slot.nameProject = tableAnswer.value
			projects[idsProjects[slot.idSlot]][1] = tableAnswer.value
			funsP["записать сс сохранение"]("список проектов", json.encode(projects))
		end
	end
	cerberus.newInputLine(words[39],words[40], isErrorCorrectNameObject, eventTargetMenu.slot.nameProject, endEditingRename)


elseif (event.target.typeFunction=="options") then
	local slot = eventTargetMenu.slot
	local idProject = slot.idProject
	local nameProject = slot.nameProject
	display.remove(SCENES[SCENE][1])
	display.remove(SCENES[SCENE][2])
	scene_options(idProject, nameProject)
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


for iSort=1, #idsProjects do
	local i = idsProjects[iSort]
	local groupScene = display.newGroup()
	groupScene.y = display.contentWidth/3.75*(iSort-0.5)
	groupSceneScroll:insert(groupScene)
	local buttonRect = display.newRect(0, 0, display.contentWidth, display.contentWidth/3.75)
	arraySlots[iSort] = buttonRect
	buttonRect.idProject= projects[i][2]
	buttonRect.idSlot = iSort
	buttonRect.nameProject = projects[i][1]
	buttonRect.anchorX = 0
	buttonRect:setFillColor(0, 71/255, 93/255)
	groupScene:insert(buttonRect)
	local strokeIcon = display.newRect(buttonRect.x+buttonRect.height*0.55, buttonRect.y, buttonRect.height/1.3, buttonRect.height/1.4)
	strokeIcon.strokeWidth = 3
	strokeIcon:setStrokeColor(171/255, 219/255, 241/255)
	strokeIcon:setFillColor(0,0,0,0)
	groupScene:insert(strokeIcon)
	local containerIcon = display.newContainer(strokeIcon.width, strokeIcon.height)
	groupScene:insert(containerIcon)
	containerIcon.x, containerIcon.y = strokeIcon.x, strokeIcon.y
	local imageIcon = display.newImage(projects[i][2].."/icon.png", system.DocumentsDirectory)
	containerIcon:insert(imageIcon)
	strokeIcon:toFront()

	local sizeIconProject = containerIcon.height/imageIcon.height
	if (imageIcon.width*sizeIconProject<containerIcon.width) then
		sizeIconProject = containerIcon.width/imageIcon.width
	end
	imageIcon.xScale, imageIcon.yScale = sizeIconProject, sizeIconProject

	local nameProject = display.newText({
		text = projects[i][1],
		x = strokeIcon.x+strokeIcon.width/1.5,
		y = strokeIcon.y,
		width = display.contentWidth/1.75,
		height = fontSize0*1.15,
		fontSize = fontSize0
	})
	nameProject.anchorX = 0
	nameProject:setFillColor(171/255, 219/255, 241/255)
	groupScene:insert(nameProject)

	local menuProject = display.newImage("images/menu.png")
	menuProject:addEventListener("touch", touchMenuSlot)
	menuProject.x, menuProject.y, menuProject.width, menuProject.height = buttonRect.x+buttonRect.width/1.11, buttonRect.y, buttonRect.height/4.5, buttonRect.height/4.5
	menuProject:setFillColor(171/255, 219/255, 241/255)
	groupScene:insert(menuProject)
	local menu2Project = display.newImage("images/checkbox_1.png")
	menu2Project.x, menu2Project.y, menu2Project.width, menu2Project.height = buttonRect.width-buttonRect.width/1.075, buttonRect.y, menuProject.width, menuProject.height
	menu2Project.alpha = 0
	groupScene:insert(menu2Project)

	buttonRect.myGroup = groupScene
	buttonRect.strokeIcon = strokeIcon
	buttonRect.containerIcon = containerIcon
	buttonRect.textNameProject = nameProject
	buttonRect.menu = menuProject
	buttonRect.menu2 = menu2Project
	menu2Project.slot = buttonRect
	menuProject.slot = buttonRect


	buttonRect:addEventListener("touch", touchOpenProject)

end
scrollProjects:setScrollHeight(groupSceneScroll.height+display.contentWidth/1.5)


local circlePlus = display.newCircle(CENTER_X+display.contentWidth/2-display.contentWidth/8, CENTER_Y+display.contentHeight/2-display.contentWidth/8-75, display.contentWidth/11.5)
circlePlus:setFillColor(1, 172/255, 8/255)
groupScene:insert(circlePlus)
local circlePlusAlpha = display.newCircle(circlePlus.x, circlePlus.y, display.contentWidth/11.5)
circlePlusAlpha:setFillColor(1,1,1,0.25)
circlePlusAlpha.xScale, circlePlusAlpha.yScale, circlePlusAlpha.alpha = 0.5, 0.5, 0
groupScene:insert(circlePlusAlpha)
circlePlus.circleAlpha = circlePlusAlpha
local circleTelegram = display.newCircle(circlePlus.x, circlePlus.y-display.contentWidth/8*1.75, display.contentWidth/11.5)
circleTelegram.fill = {
	type="image",
	filename="images/icon_telegram.jpg"
}
groupScene:insert(circleTelegram)
local circleTelegramAlpha = display.newCircle(circleTelegram.x, circleTelegram.y, display.contentWidth/11.5)
circleTelegramAlpha:setFillColor(1,1,1,0.25)
circleTelegramAlpha.xScale, circleTelegramAlpha.yScale, circleTelegramAlpha.alpha = 0.75, 0.75, 0
groupScene:insert(circleTelegramAlpha)
circleTelegram.circleAlpha = circleTelegramAlpha

local circleDiscord = display.newCircle(circlePlus.x, circleTelegram.y-display.contentWidth/8*1.75, display.contentWidth/11.5)
circleDiscord.fill = {
	type="image",
	filename="images/icon_discord.png",
}
groupScene:insert(circleDiscord)
local circleDiscordAlpha = display.newCircle(circleDiscord.x, circleDiscord.y, display.contentWidth/11.5)
circleDiscordAlpha:setFillColor(1,1,1,0.25)
circleDiscordAlpha.xScale, circleDiscordAlpha.yScale, circleDiscordAlpha.alpha = 0.75, 0.75, 0
groupScene:insert(circleDiscordAlpha)
circleDiscord.circleAlpha = circleDiscordAlpha

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
			function inputLineProject(placeholder, isCorrectValue, value, funEditingEnd)
				if (isCorrectValue==nil) then
					isCorrectValue = function()
						return("")
					end
				end
				if (value==nil) then
					value = ""
				end
				local backgroundBlackAlpha = display.newRect(CENTER_X, CENTER_Y, display.contentWidth, display.contentHeight)
				backgroundBlackAlpha:setFillColor(0,0,0,0.6)
				SCENES[SCENE][#SCENES[SCENE]]:insert(backgroundBlackAlpha)
				local group = display.newGroup()
				SCENES[SCENE][#SCENES[SCENE]]:insert(group)
				local rect = display.newRoundedRect(CENTER_X, CENTER_Y, display.contentWidth/1.08, 0, roundedRect)
				rect.anchorY=0,
				rect:setFillColor(66/255, 66/255, 66/255)
				group:insert(rect)

				backgroundBlackAlpha.alpha = 0
				rect.alpha = 0
				transition.to(backgroundBlackAlpha, {time=150, alpha=1})
				transition.to(rect, {time=150, alpha=1})

				local miniGroupTop = display.newGroup()
				group:insert(miniGroupTop)
				local miniGroupBottom = display.newGroup()
				group:insert(miniGroupBottom)
				local textPlaceholder = display.newText({
					text=placeholder,
					width=rect.width-display.contentWidth/17*2,
					x=CENTER_X, 
					y=CENTER_Y+display.contentWidth/17,
					font=nil,
					fontSize=fontSize2,
				})
				miniGroupTop:insert(textPlaceholder)
				local input = native.newTextBox(CENTER_X, textPlaceholder.y+textPlaceholder.height, textPlaceholder.width, textPlaceholder.width/10)
				input.isEditable = true
				input.hasBackground = false
				if isSim or isWin then
					input:setTextColor(0,0,0)
					input.size = 25
				else
					input:setTextColor(1,1,1)
				end
				input.anchorY=0
				miniGroupTop:insert(input)

				input.text = value
				native.setKeyboardFocus(input)
				if (value~="") then
					input:setSelection(0, utf8.len(value))
				end

				local rectInput = display.newRect(CENTER_X, input.y+input.height, input.width, display.contentWidth/150)
				rectInput.anchorY=0
				miniGroupTop:insert(rectInput)

				local textError = display.newText({
					text="--",
					width=rect.width-display.contentWidth/17*2,
					x=CENTER_X, 
					y=rectInput.y+rectInput.height+display.contentWidth/34,
					font=nil,
					fontSize=fontSize2,
				})
				textError.anchorY = 0
				textError:setFillColor(1, 113/255, 67/255)
				miniGroupTop:insert(textError)

				local textButtonOk = display.newText(words[16], 0, 0, nil, fontSize1)
				textButtonOk:setFillColor(171/255, 219/255, 241/255)
				local rectButtonOk = display.newRoundedRect(CENTER_X+textPlaceholder.width/2, CENTER_Y+textPlaceholder.width/10*2, textButtonOk.width+display.contentWidth/10, textButtonOk.height+display.contentWidth/30, roundedRect)
				rectButtonOk.anchorX, rectButtonOk.anchorY = 1, 0
				textButtonOk.x, textButtonOk.y = rectButtonOk.x-rectButtonOk.width/2, rectButtonOk.y+rectButtonOk.height/2
				rectButtonOk:setFillColor(66/255,66/255, 66/255)
				miniGroupBottom:insert(rectButtonOk)
				miniGroupBottom:insert(textButtonOk)
				local textButtonCancel = display.newText(words[17], 0, 0, nil, fontSize1)
				textButtonCancel:setFillColor(171/255, 219/255, 241/255)
				local rectButtonCancel = display.newRoundedRect(rectButtonOk.x-rectButtonOk.width-display.contentWidth/40, CENTER_Y+textPlaceholder.width/10*2, textButtonCancel.width+display.contentWidth/20, textButtonCancel.height+display.contentWidth/30, roundedRect)
				rectButtonCancel.anchorX, rectButtonCancel.anchorY = 1, 0
				textButtonCancel.x, textButtonCancel.y = rectButtonCancel.x-rectButtonCancel.width/2, rectButtonCancel.y+rectButtonCancel.height/2
				rectButtonCancel:setFillColor(66/255,66/255, 66/255)
				miniGroupBottom:insert(rectButtonCancel)
				miniGroupBottom:insert(textButtonCancel)

				local mobileVertical = display.newImage("images/mobile.png")
				mobileVertical:setFillColor(1,1,1,0.9)
				mobileVertical.width, mobileVertical.height = textPlaceholder.width/10, textPlaceholder.width/10
				mobileVertical.x, mobileVertical.y = CENTER_X-textPlaceholder.width/4, textButtonCancel.y-mobileVertical.height*2
				miniGroupBottom:insert(mobileVertical)
				local mobileHorizontal = display.newImage("images/mobile.png")
				mobileHorizontal:setFillColor(1,1,1,0.9)
				mobileHorizontal.width, mobileHorizontal.height = textPlaceholder.width/10, textPlaceholder.width/10
				mobileHorizontal.x, mobileHorizontal.y = CENTER_X+textPlaceholder.width/4, mobileVertical.y
				mobileHorizontal.rotation = 90
				miniGroupBottom:insert(mobileHorizontal)

				local checkboxVertical = display.newImage("images/circle_checkbox_2.png")
				checkboxVertical:setFillColor(171/255, 219/255, 241/255)
				checkboxVertical.width, checkboxVertical.height = textPlaceholder.width/12.5, textPlaceholder.width/12.5
				checkboxVertical.x, checkboxVertical.y = mobileVertical.x-mobileVertical.width*1.75, mobileVertical.y
				local checkboxHorizontal = display.newImage("images/circle_checkbox_1.png")
				checkboxHorizontal:setFillColor(1,1,1,0.9)
				checkboxHorizontal.width, checkboxHorizontal.height = textPlaceholder.width/12.5, textPlaceholder.width/12.5
				checkboxHorizontal.x, checkboxHorizontal.y = mobileHorizontal.x-mobileVertical.width*1.75, mobileVertical.y

				local cricleAlphaVertical = display.newCircle(checkboxVertical.x, checkboxVertical.y, checkboxVertical.width)
				cricleAlphaVertical:setFillColor(1,1,1,0.125)
				miniGroupBottom:insert(cricleAlphaVertical)
				local cricleAlphaHorizontal = display.newCircle(checkboxHorizontal.x, checkboxVertical.y, checkboxVertical.width)
				cricleAlphaHorizontal:setFillColor(1,1,1,0.125)
				miniGroupBottom:insert(cricleAlphaHorizontal)
				miniGroupBottom:insert(checkboxVertical)
				miniGroupBottom:insert(checkboxHorizontal)
				cricleAlphaVertical.xScale, cricleAlphaVertical.yScale, cricleAlphaVertical.alpha = 0.5, 0.5, 0
				cricleAlphaHorizontal.xScale, cricleAlphaHorizontal.yScale, cricleAlphaHorizontal.alpha = 0.75, 0.75, 0

				local orientationProject = "vertical"
				local function touchOrientationProject(event)
					local newOrientation = (event.target == checkboxHorizontal or event.target == mobileHorizontal) and "horizontal" or "vertical"
					local tableOrient = {
						["horizontal"]={checkboxHorizontal, cricleAlphaHorizontal, checkboxVertical},
						["vertical"]={checkboxVertical, cricleAlphaVertical, checkboxHorizontal},
					}
					tableOrient = tableOrient[newOrientation]

					if (event.phase=="began") then
						transition.to(tableOrient[2], {time=50, xScale=1, yScale=1, alpha=1, transition=easing.outSine})
					elseif (event.phase=="moved") then
						transition.to(tableOrient[2], {time=100, xScale=0.75, yScale=0.75, alpha=0, transition=easing.inSine})
					else
						transition.to(tableOrient[2], {time=100, xScale=0.75, yScale=0.75, alpha=0, transition=easing.inSine})

						if (newOrientation~=orientationProject) then
							orientationProject = newOrientation
							tableOrient[1].fill = {
								type="image",
								filename="images/circle_checkbox_2.png"
							}
							tableOrient[3].fill = {
								type="image",
								filename="images/circle_checkbox_1.png",
							}
							tableOrient[1]:setFillColor(171/255, 219/255, 241/255)
							tableOrient[3]:setFillColor(1,1,1,0.9)
						end
					end
					return(true)
				end
				checkboxHorizontal:addEventListener("touch", touchOrientationProject)
				checkboxVertical:addEventListener("touch", touchOrientationProject)
				mobileHorizontal:addEventListener("touch", touchOrientationProject)
				mobileVertical:addEventListener("touch", touchOrientationProject)



				local touchNoTouch = nil
				local function touchEditingEnd(event)
					if (event.target.textButton.alpha>0.9) then
						if (event.phase=="began") then
							event.target:setFillColor(99/255, 99/255, 99/255)
						elseif (event.phase=="moved") then
							event.target:setFillColor(66/255, 66/255, 66/255)
						else
							event.target:setFillColor(66/255, 66/255, 66/255)
							native.setKeyboardFocus(nil)
							input.isEditable = false
							rectButtonOk:removeEventListener("touch", touchEditingEnd)
							rectButtonCancel:removeEventListener("touch", touchEditingEnd)
							backgroundBlackAlpha:removeEventListener("touch",touchNoTouch)
							rect:removeEventListener("touch",touchNoTouch)

							transition.to(backgroundBlackAlpha, {time=200, alpha=0, inComplete=function()
								display.remove(backgroundBlackAlpha)
							end})
							display.remove(input)
							transition.to(group, {time=200, alpha=0, inComplete=function()
								display.remove(group)
							end})

							if (funEditingEnd~=nil) then
								if (event.target==rectButtonOk) then
									funEditingEnd({["isOk"]=true, ["value"]=input.text:gsub("^%s+", ""):gsub("%s+$", ""), ["orientation"]=orientationProject})
								else
									funEditingEnd({["isOk"]=false})
								end
							end
						end
					end
					return(true)
				end
				rectButtonOk.textButton = textButtonOk
				rectButtonCancel.textButton = textButtonCancel
				rectButtonOk:addEventListener("touch", touchEditingEnd)
				rectButtonCancel:addEventListener("touch", touchEditingEnd)

				touchNoTouch = function(event)
					if (event.phase=="ended" and event.target==backgroundBlackAlpha) then
						native.setKeyboardFocus(nil)
						input.isEditable = false
						rectButtonOk:removeEventListener("touch", touchEditingEnd)
						rectButtonCancel:removeEventListener("touch", touchEditingEnd)
						backgroundBlackAlpha:removeEventListener("touch",touchNoTouch)
						rect:removeEventListener("touch",touchNoTouch)

						transition.to(backgroundBlackAlpha, {time=200, alpha=0, inComplete=function()
							display.remove(backgroundBlackAlpha)
						end})
						display.remove(input)
						transition.to(group, {time=200, alpha=0, inComplete=function()
							display.remove(group)
						end})

						if (funEditingEnd~=nil) then
							funEditingEnd({["isOk"]=false})
						end
					end
					return(true)
				end
				backgroundBlackAlpha: addEventListener("touch",touchNoTouch)
				rect:addEventListener("touch",touchNoTouch)

				local function updateHeightRect()
					rect.height = miniGroupTop.height+miniGroupBottom.height+(textError.text~="" and display.contentWidth/10 or display.contentWidth/30)+display.contentWidth/30
					miniGroupBottom.y = miniGroupTop.height+(textError.text~="" and display.contentWidth/10 or display.contentWidth/30)
					group.y = -group.height/2
				end

				local function isError(value)
					local oldTextError = textError.text
					textError.text = isCorrectValue(value)
					if (textError.text ~= "" and oldTextError~=textError.text) then
						textPlaceholder:setFillColor(1, 113/255, 67/255)
						rectInput:setFillColor(1, 113/255, 67/255)
						updateHeightRect()
						textButtonOk.alpha = 0.25
						textButtonOk:setFillColor(1,1,1)
					elseif (textError.text == "" and oldTextError~="") then
						textPlaceholder:setFillColor(171/255, 219/255, 241/255)
						rectInput:setFillColor(171/255, 219/255, 241/255)
						updateHeightRect()
						textButtonOk.alpha = 1
						textButtonOk:setFillColor(171/255, 219/255, 241/255)
					end
				end
				isError(value)


				input:addEventListener("userInput", function (event)
					if (event.phase=="began") then
					elseif (event.phase=="editing") then

						isError(event.text:gsub("^%s+", ""):gsub("%s+$", ""))

						if (select(2, string.gsub(event.oldText, "\n", "\n")) ~= select(2, string.gsub(event.text, "\n", "\n")) and select(2, string.gsub(event.text, "\n", "\n"))<6 ) then
							input.height = input.width/12*math.min(math.max(select(2, string.gsub(input.text, "\n", "\n"))+1, 1), 6)
							rectInput.y = input.y+input.height
							textError.y = rectInput.y+rectInput.height+display.contentWidth/34
							updateHeightRect()
						end
					elseif (event.pahse=="ended") then
					end
				end)

			end


			local function isCorrectValue(value)
				if (string.len(value)==0) then
					return(words[18])
				else
					local isCorrect = true
					for i=1, #projects do
						if (projects[i][1]==value) then
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

			local function createProject(tableAnswer)
				if (tableAnswer.isOk) then
					tableAnswer.value = tableAnswer.value:gsub( (isWin and '\r\n' or '\n'), ' ')
					local counter = tonumber(funsP["прочитать сс сохранение"]("counter_projects"))+1
					funsP["записать сс сохранение"]("counter_projects", counter)
					projects[#projects+1] = {tableAnswer.value, "project_"..counter}


					funsP["записать сс сохранение"]("список проектов",json.encode(projects))

					local idsProjectsCreated = json.decode(funsP["прочитать сс сохранение"]("сортировка проектов - дата создания"))
					local idsProjectsOpen = json.decode(funsP["прочитать сс сохранение"]("сортировка проектов - дата открытия"))
					table.insert(idsProjectsCreated, 1, #projects)
					table.insert(idsProjectsOpen, 1, #projects)
					funsP["записать сс сохранение"]("сортировка проектов - дата открытия", json.encode(idsProjectsOpen))
					funsP["записать сс сохранение"]("сортировка проектов - дата создания", json.encode(idsProjectsCreated))

					funsP["создать проект"]("project_"..counter)
					funsP["записать сохранение"]("project_"..counter.."/options", json.encode({["orientation"]=tableAnswer.orientation, ["aspectRatio"]=false, ["displayWidth"]=display.contentWidth, ["displayHeight"]=display.contentHeight}))


					display.remove(SCENES[SCENE][1])
					display.remove(SCENES[SCENE][2])


					IDPROJECT = "project_"..counter
					NMPROJECT = tableAnswer.value
					scene_objects(IDPROJECT.."/scene_1/objects", NMPROJECT, {"Сцена",1})


				end
			end

			inputLineProject(words[40], isCorrectValue, correctNameSlot(words[43]), createProject)


		end
	end
	return(true)
end
circlePlus:addEventListener("touch", touchCirclePlus)

local function touchCircleTelegram(event)
	if (event.phase=="began") then
		transition.to(event.target.circleAlpha, {alpha=1, xScale=1, yScale=1, time=100})
		display.getCurrentStage():setFocus(event.target, event.id)
	elseif (event.phase=="moved") then
	else
		transition.to(event.target.circleAlpha, {alpha=0, xScale=0.75, yScale=0.75, time=100})
		display.getCurrentStage():setFocus(event.target, nil)

		system.openURL(event.target == circleTelegram and "https://t.me/pocket_up" or "https://discord.com/invite/Bd6RVj96a3")
	end
	return(true)
end
circleTelegram:addEventListener("touch", touchCircleTelegram)
circleDiscord:addEventListener("touch", touchCircleTelegram)

local functionsMenu = {}


functionsMenu["startimport"] = function ()
isBackScene = "back"
--CCCCCCCCCCCCCCCCCCCCCCCCC
--CCCCCCCCCCCCCCCCCCCCCCCCC
--CCCCCCCCCCCCCCCCCCCCCCCCC
--CCCCCCCCCCCCCCCCCCCCCCCCC
--CCCCCCCCCCCCCCCCCCCCCCCCC
funsP["импортировать проект"](function (pathProject)
	if (funsP["получить сохранение"](pathProject.."/options")==nil) then
		funsP["вызвать уведомление"](words[267])
	else
		local projects = json.decode(funsP["прочитать сс сохранение"]("список проектов"))
		local sortDate = json.decode(funsP["прочитать сс сохранение"]("сортировка проектов - дата создания"))
		local sortOpen = json.decode(funsP["прочитать сс сохранение"]("сортировка проектов - дата открытия"))

		local function isCorrectName(value)
			local isCorrect = true
			for i=1, #projects do
				if (projects[i][1]==value) then
					isCorrect = false
					break
				end
			end
			return(isCorrect)
		end
		local function correctName(value)
			if (isCorrectName(value)) then
				return(value)
			else
				local i = 1
				while (not isCorrectName(value.." ("..i..")")) do
					i = i+1
				end
				return(value.." ("..i..")")
			end
		end

		local nameProject = json.decode(funsP["получить сохранение"](pathProject.."/options"))["name"]

		projects[#projects+1] = {correctName(nameProject),pathProject}
		table.insert(sortDate, 1, #projects)
		table.insert(sortOpen, 1, #projects)
		funsP["записать сс сохранение"]("список проектов", json.encode(projects))
		funsP["записать сс сохранение"]("сортировка проектов - дата открытия", json.encode(sortOpen))
		funsP["записать сс сохранение"]("сортировка проектов - дата создания", json.encode(sortDate))
		display.remove(SCENES[SCENE][2])
		display.remove(SCENES[SCENE][1])
		scene_projects()
		funsP["вызвать уведомление"](words[266])
	end
end)
--CCCCCCCCCCCCCCCCCCCCCCCCC
--CCCCCCCCCCCCCCCCCCCCCCCCC
--CCCCCCCCCCCCCCCCCCCCCCCCC
--CCCCCCCCCCCCCCCCCCCCCCCCC
--CCCCCCCCCCCCCCCCCCCCCCCCC
end

local function correctNameScene(value)
	local isCorrect = true
	for i=1, #projects do
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
			for i=1, #projects do
				if (projects[i][1]==value.." ("..id..")") then
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

local function correctNameScene(value)
	local isCorrect = true
	for i=1, #projects do
		if (projects[i][1]==value) then
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
			for i=1, #projects do
				if (projects[i][1]==value.." ("..id..")") then
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


functionsMenu["startisSort"] = function ()
local isSort = funsP["прочитать сс сохранение"]("наличие сортировки проектов")=="true" and "false" or "true"
funsP["записать сс сохранение"]("наличие сортировки проектов", isSort)

display.remove(SCENES[SCENE][1])
display.remove(SCENES[SCENE][2])
scene_projects()
end



local function renameButton(event)
	if (event.phase=="ended") then

		local function editingEnd(tableRenameSlot)

			if (tableRenameSlot.isOk) then
				tableRenameSlot.value = tableRenameSlot.value:gsub( (isWin and '\r\n' or '\n'), ' ')
				projects[event.target.idSlot][1] = tableRenameSlot.value
				event.target.textNameProject.text = tableRenameSlot.value
				event.target.nameProject = tableRenameSlot.value
				funsP["записать сс сохранение"]("список проектов", json.encode(projects))
			end

			isBackScene = "back"
			topBarArray[4].alpha = 1
			topBarArray[3].text = valueHeaderTopBar

			for i=1, #projects do
				local slot = arraySlots[i]
				slot.menu.alpha = 1
				slot:removeEventListener("touch",renameButton)
			end

		end
		local function checkCorrectName(value)
			if (utf8.len(value)==0) then
				return(words[18])
			else
				local isCorrect = true
				for i=1, #projects do
					if (projects[i][1]==value) then
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
		cerberus.newInputLine(words[39],words[40], checkCorrectName, event.target.nameProject, editingEnd)

	end
end



functionsMenu["startrename"] = function ()
topBarArray[4].alpha = 0
topBarArray[3].text = words[6]

for i=1, #projects do
	local slot = arraySlots[i]
	slot.menu.alpha = 0
	slot:addEventListener("touch",renameButton)
end

end


local function touchMenu2CopySlot(event)
	if (event.phase=="began") then
		transition.to(event.target, {xScale=0.75, yScale=0.75, time=100})
		display.getCurrentStage():setFocus(event.target, event.id)
	elseif (event.phase=="moved" and (math.abs(event.x-event.xStart)>20 or math.abs(event.y-event.yStart)>20)) then
		transition.to(event.target, {xScale=1, yScale=1, time=200})
		scrollProjects:takeFocus(event)
	elseif (event.phase == "began") then
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
for i=1, #projects do
	local slot = arraySlots[i]
	slot.strokeIcon.x = slot.strokeIcon.x+display.contentWidth/7
	slot.containerIcon.x = slot.strokeIcon.x
	slot.textNameProject.x = slot.textNameProject.x+display.contentWidth/7

	slot.menu2.fill = {
		type="image",
		filename="images/checkbox_1.png",
	}
	slot.menu2.alpha = 1
	slot.menu2:setFillColor(171/255, 219/255, 241/255)
	slot.menu2.x = slot.menu2.x+display.contentWidth/40
	slot.menu2.isCopySlot = nil
	slot.menu2:addEventListener("touch", touchMenu2CopySlot)

	slot.menu.alpha=0
end

end
functionsMenu["startdelete"] = functionsMenu["startcopy"]

local arrayAllButtonsFunctions = {
	["back"]={"back","startmenu",{{36, "import"},{4,"copy"},{5,"delete"},{6,"rename"},{41,"isSort"}}},

	["copy"]={"copy","copyAll",{{10,"copyAll"}}},
	["delete"]={"delete","deleteAll",{{10,"deleteAll"}}},

}
arrayAllButtonsFunctions["startmenu"] = arrayAllButtonsFunctions["back"]
arrayAllButtonsFunctions["copyAll"] = arrayAllButtonsFunctions["copy"]
arrayAllButtonsFunctions["deleteAll"] = arrayAllButtonsFunctions["delete"]


functionsMenu["checkcopy"] = function ()
isBackScene = "back"
topBarArray[3].text = valueHeaderTopBar
topBarArray[5].alpha = 0
local countCopiedSlot = 0
local counter = tonumber(funsP["прочитать сс сохранение"]("counter_projects"))
local is = 0
while (is+countCopiedSlot<#projects) do
	is=is+1
	local i = is+countCopiedSlot
	local slot = arraySlots[i]
	slot.strokeIcon.x = slot.strokeIcon.x-display.contentWidth/7
	slot.containerIcon.x = slot.strokeIcon.x
	slot.textNameProject.x = slot.textNameProject.x-display.contentWidth/7

	slot.menu2:removeEventListener("touch", touchMenu2CopySlot)
	slot.menu2.alpha = 0
	slot.menu2.x = slot.menu2.x-display.contentWidth/40
	slot.menu.alpha = 1

	if (slot.menu2.isCopySlot) then
		counter = counter+1
		table.insert(projects, 1, {correctNameScene(slot.nameProject), "project_"..counter})
		funsP["копировать проект"](slot.idProject, "project_"..counter)
		table.insert(idsProjects, 1, 1)
		for i=2, #idsProjects do
			idsProjects[i] = idsProjects[i]+1
		end
		funsP["записать сс сохранение"]("список проектов", json.encode(projects))
		local idsProjects = json.decode(funsP["прочитать сс сохранение"]("сортировка проектов - дата открытия"))
		table.insert(idsProjects, 1, 1)
		for i=2, #idsProjects do
			idsProjects[i] = idsProjects[i]+1
		end
		funsP["записать сс сохранение"]("сортировка проектов - дата открытия", json.encode(idsProjects))
		local idsProjects = json.decode(funsP["прочитать сс сохранение"]("сортировка проектов - дата создания"))
		table.insert(idsProjects, 1, 1)
		for i=2, #idsProjects do
			idsProjects[i] = idsProjects[i]+1
		end
		funsP["записать сс сохранение"]("сортировка проектов - дата создания", json.encode(idsProjects))

		local iSort = 1
		local i = idsProjects[iSort]
		local groupScene = display.newGroup()
		groupSceneScroll:insert(groupScene)
		local buttonRect = display.newRect(0, 0, display.contentWidth, display.contentWidth/3.75)
		table.insert(arraySlots, iSort, buttonRect)
		buttonRect.idProject= projects[i][2]
		buttonRect.nameProject = projects[i][1]
		buttonRect.anchorX = 0
		buttonRect:setFillColor(0, 71/255, 93/255)
		groupScene:insert(buttonRect)
		local strokeIcon = display.newRect(buttonRect.x+buttonRect.height*0.55, buttonRect.y, buttonRect.height/1.3, buttonRect.height/1.4)
		strokeIcon.strokeWidth = 3
		strokeIcon:setStrokeColor(171/255, 219/255, 241/255)
		strokeIcon:setFillColor(0,0,0,0)
		groupScene:insert(strokeIcon)
		local containerIcon = display.newContainer(strokeIcon.width, strokeIcon.height)
		groupScene:insert(containerIcon)
		containerIcon.x, containerIcon.y = strokeIcon.x, strokeIcon.y
		local imageIcon = display.newImage(projects[i][2].."/icon.png", system.DocumentsDirectory)
		containerIcon:insert(imageIcon)
		strokeIcon:toFront()

		local sizeIconProject = containerIcon.height/imageIcon.height
		if (imageIcon.width*sizeIconProject<containerIcon.width) then
			sizeIconProject = containerIcon.width/imageIcon.width
		end
		imageIcon.xScale, imageIcon.yScale = sizeIconProject, sizeIconProject

		local nameProject = display.newText({
			text = projects[i][1],
			x = strokeIcon.x+strokeIcon.width/1.5,
			y = strokeIcon.y,
			width = display.contentWidth/1.75,
			height = fontSize0*1.15,
			fontSize = fontSize0
		})
		nameProject.anchorX = 0
		nameProject:setFillColor(171/255, 219/255, 241/255)
		groupScene:insert(nameProject)

		local menuProject = display.newImage("images/menu.png")
		menuProject:addEventListener("touch", touchMenuSlot)
		menuProject.x, menuProject.y, menuProject.width, menuProject.height = buttonRect.x+buttonRect.width/1.11, buttonRect.y, buttonRect.height/4.5, buttonRect.height/4.5
		menuProject:setFillColor(171/255, 219/255, 241/255)
		groupScene:insert(menuProject)
		local menu2Project = display.newImage("images/checkbox_1.png")
		menu2Project.x, menu2Project.y, menu2Project.width, menu2Project.height = buttonRect.width-buttonRect.width/1.075, buttonRect.y, menuProject.width, menuProject.height
		menu2Project.alpha = 0
		groupScene:insert(menu2Project)

		buttonRect.myGroup = groupScene
		buttonRect.strokeIcon = strokeIcon
		buttonRect.containerIcon = containerIcon
		buttonRect.textNameProject = nameProject
		buttonRect.menu = menuProject
		buttonRect.menu2 = menu2Project
		menu2Project.slot = buttonRect
		menuProject.slot = buttonRect


		buttonRect:addEventListener("touch", touchOpenProject)

		countCopiedSlot = countCopiedSlot+1
	end

end

for i=1, #arraySlots do
	local slot = arraySlots[i]
	slot.myGroup.y = display.contentWidth/3.75*(i-0.5)
	slot.idSlot = i
end

funsP["записать сс сохранение"]("counter_projects", counter )


scrollProjects:setScrollHeight(groupSceneScroll.height+display.contentWidth/1.5)
end


functionsMenu["checkdelete"] = function ()
isBackScene = "back"
topBarArray[3].text = valueHeaderTopBar
topBarArray[5].alpha = 0
local iMinus = 0
local i2 = 0

local idsProjectsCreated = json.decode(funsP["прочитать сс сохранение"]("сортировка проектов - дата создания"))
local idsProjectsOpen = json.decode(funsP["прочитать сс сохранение"]("сортировка проектов - дата открытия"))

while (i2-iMinus<#arraySlots) do
	i2 = i2+1
	local i = i2-iMinus
	local slot = arraySlots[i]
	if (not slot.menu2.isCopySlot) then
		slot.menu.alpha = 1
		slot.strokeIcon.x = slot.strokeIcon.x-display.contentWidth/7
		slot.containerIcon.x = slot.strokeIcon.x
		slot.textNameProject.x = slot.textNameProject.x-display.contentWidth/7

		slot.menu2:removeEventListener("touch", touchMenu2CopySlot)
		slot.menu2.alpha = 0
		slot.menu2.x = slot.menu2.x-display.contentWidth/40

		slot.idSlot = i
		slot.myGroup.y = slot.height*(i-0.5)

	else

		table.remove(arraySlots, i)
		funsP["удалить объект"](slot.idProject)
		display.remove(slot.myGroup)
		table.remove(projects, idsProjects[i])
		local idDelSave = idsProjects[i]
		table.remove(idsProjects, i)
		for iDelSave=1, #idsProjectsCreated do
			if (idsProjectsCreated[iDelSave]==idDelSave) then
				table.remove(idsProjectsCreated, iDelSave)
				break
			end
		end
		for iDelSave=1, #idsProjectsOpen do
			if (idsProjectsOpen[iDelSave]==idDelSave) then
				table.remove(idsProjectsOpen, iDelSave)
				break
			end
		end

		for iPlus=1, #idsProjects do
			if (idsProjects[iPlus]>idDelSave) then
				idsProjects[iPlus] = idsProjects[iPlus]-1
			end
			if (idsProjectsCreated[iPlus]>idDelSave) then
				idsProjectsCreated[iPlus] = idsProjectsCreated[iPlus]-1
			end
			if (idsProjectsOpen[iPlus]>idDelSave) then
				idsProjectsOpen[iPlus] = idsProjectsOpen[iPlus]-1
			end
		end

		iMinus = iMinus+1

	end


end

funsP["записать сс сохранение"]("сортировка проектов - дата создания", json.encode(idsProjectsCreated))
funsP["записать сс сохранение"]("сортировка проектов - дата открытия", json.encode(idsProjectsOpen))
funsP["записать сс сохранение"]("список проектов", json.encode(projects))

if (iMinus~=0) then
	funsP["вызвать уведомление"](string.gsub(words[iMinus==1 and 37 or 38], "<count>", iMinus))

	if (#arraySlots~=0) then
		local iEndSlot = #arraySlots
		local xScroll, yScroll = scrollProjects:getContentPosition()
		local arSlEnd = arraySlots[iEndSlot].myGroup
		local newScrollHeight = arSlEnd.y+arSlEnd.height/2+display.contentWidth/1.5
		scrollProjects:setScrollHeight(newScrollHeight)
		scrollProjects:scrollToPosition({
			time=0, 
			y=math.min(math.max(yScroll, -newScrollHeight+scrollProjects.height), 0)
		})
	else
		display.remove(SCENES[SCENE][1])
		display.remove(SCENES[SCENE][2])
		scene_projects()
	end
end

if (#projects==0) then

end

end


functionsMenu["back"] = function()

if (isBackScene=="back") then
	arrayAllButtonsFunctions[isBackScene][3][5][1] = funsP["прочитать сс сохранение"]("наличие сортировки проектов")=="true" and 41 or 42
end

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

		scene_main()

	elseif (isBackScene=="rename") then
		isBackScene = "back"
		topBarArray[4].alpha = 1
		topBarArray[3].text = valueHeaderTopBar

		for i=1, #projects do
			local slot = arraySlots[i]
			slot.menu.alpha = 1
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