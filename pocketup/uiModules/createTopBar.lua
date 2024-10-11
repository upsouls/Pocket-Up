-- создание верхнего бара с заголовком, кнопкой назад и меню

--[[ данные отправляемые в функцию topBar
group - группа, к которой привяжется верхний бар
idWord - заголовок. строка(string) или число(number. id элемента из массива app.words);
onTouchMenu - вызывает функцию при нажатии на меню
onTouchCheck - вызывает функцию при нажатии на галочку
onTouchBack - функция, вызываемая при нажатии на кнопку назад(не важно, системную или ту что в баре)
]]

-- получаемые данные это массив объектов созданных для верхнего бара

funBack = nil
local function funBackListener(event)
	if ((event.keyName=="back" or event.keyName=="deleteBack") and funBack~=nil and event.phase=="up") then
		funBack[1]("systemBack")
		return(true)
	end
end
Runtime:addEventListener("key", funBackListener)

function topBar(group, idWord, onTouchMenu, onTouchCheck, onTouchBack, isHorizontal)
	if (onTouchBack~=nil) then
		funBack = onTouchBack
	else
		funBack = nil
	end
	local CENTER_X = CENTER_X
	local CENTER_Y = CENTER_Y
	if (isHorizontal) then
		CENTER_X, CENTER_Y = CENTER_Y, CENTER_X
	end
	local rectTopBar = display.newRect(CENTER_X, CENTER_Y-(isHorizontal and display.contentWidth or display.contentHeight)/2, (isHorizontal and display.contentHeight or display.contentWidth), display.contentWidth/6.5)
	rectTopBar:addEventListener("touch", function(event)
		if (event.phase == "began") then
			display.getCurrentStage():setFocus(event.target, event.id)
		elseif (event.phase~="moved") then
			display.getCurrentStage():setFocus(event.target, nil)
		end
		return(true)
	end)
	rectTopBar.anchorY = 0
	rectTopBar:setFillColor(0, 43/255, 59/255)
	local buttonBack = display.newImage("images/back.png")
	buttonBack.x, buttonBack.y, buttonBack.width, buttonBack.height = CENTER_X-(isHorizontal and display.contentHeight or display.contentWidth)/2.3,rectTopBar.y+rectTopBar.height/2, rectTopBar.height/1.5, rectTopBar.height/1.5
	local circleTouchBack = display.newCircle(buttonBack.x, buttonBack.y, buttonBack.height/2)
	circleTouchBack.alpha, circleTouchBack.xScale, circleTouchBack.yScale = 0, 0.75, 0.75
	buttonBack.circleTouch = circleTouchBack

	local buttonCheck = display.newImage("images/check.png")
	buttonCheck.alpha = 0
	buttonCheck.x, buttonCheck.y, buttonCheck.width, buttonCheck.height = CENTER_X+(isHorizontal and display.contentHeight or display.contentWidth)/2.3-buttonBack.width/1.75*2.5, buttonBack.y, buttonBack.width/1.75, buttonBack.height/1.75
	local circleTouchBack = display.newCircle(buttonCheck.x, buttonCheck.y, buttonBack.height/2)
	circleTouchBack.alpha, circleTouchBack.xScale, circleTouchBack.yScale = 0, 0.75, 0.75
	buttonCheck.circleTouch = circleTouchBack

	local function back(event)
	if (event.phase=="began") then
		transition.to(event.target.circleTouch, {alpha=0.25, xScale=1, yScale=1, time=100})
	elseif (event.phase=="moved") then
		transition.to(event.target.circleTouch, {alpha=0, xScale=0.75, yScale=0.75, time=100})
	else
		transition.to(event.target.circleTouch, {alpha=0, xScale=0.75, yScale=0.75, time=100})


		if (event.target==buttonBack) then
			if (onTouchBack~=nil) then
				onTouchBack[1]()
			end
		elseif (event.target==buttonCheck) then
			if (onTouchCheck~=nil) then
				onTouchCheck[1]()
			end
		else
			if (onTouchMenu~=nil) then
				onTouchMenu[1]()
			end
		end

	end
	return(true)
	end
	buttonBack:addEventListener("touch",back)
	buttonCheck:addEventListener("touch",back)
	local headerBar = display.newText({
		text = type(idWord)=="number" and app.words[idWord] or idWord,
		x = buttonBack.x+buttonBack.width,
		y = buttonBack.y,
		width = display.contentWidth/1.4,
		height = app.fontSize0*1.1,
		fontSize = app.fontSize1
	})
	headerBar.anchorX = 0

	local buttonMenu = display.newImage("images/menu.png")
	buttonMenu.x, buttonMenu.y, buttonMenu.width, buttonMenu.height = CENTER_X+(isHorizontal and display.contentHeight or display.contentWidth)/2.3, buttonBack.y, buttonBack.width/1.75, buttonBack.height/1.75
	local circleTouchBack = display.newCircle(buttonMenu.x, buttonMenu.y, buttonBack.height/2)
	circleTouchBack.alpha, circleTouchBack.xScale, circleTouchBack.yScale = 0, 0.75, 0.75
	buttonMenu.circleTouch = circleTouchBack
	buttonMenu:addEventListener("touch",back)

	group:insert(rectTopBar)
	group:insert(buttonBack)
	group:insert(buttonBack.circleTouch)
	group:insert(headerBar)
	group:insert(buttonMenu)
	group:insert(buttonMenu.circleTouch)
	group:insert(buttonCheck)
	group:insert(buttonCheck.circleTouch)
	return({rectTopBar, buttonBack, headerBar, buttonMenu, buttonCheck})
end