-- сцена редактор формул

function scene_formula_editor(objectsParameter, idBlock, idParameter, blocks)
	local oldSceneBack = funBack

	SCENES["scripts"][1].alpha = 0
	local groupScene = display.newGroup()
	SCENE = "formula_editor"
	SCENES[SCENE] = {groupScene}
	local funBackObjects = {}
	local isBackScene = "back"
	local topBarArray = topBar(groupScene, words[272], nil, nil, funBackObjects)
	topBarArray[4].alpha = 0
	local block = blocks[idBlock]
	local formulas = blocks[idBlock][2][idParameter]
	local cursor = #formulas+1
	local blockObject = createBlock(block)
	blockObject.x = 0
	local containerBlock = display.newContainer(display.contentWidth, math.min(blockObject.height, display.contentHeight/6))
	containerBlock.x, containerBlock.y = CENTER_X+display.screenOriginX, topBarArray[1].y+topBarArray[1].height+containerBlock.height/2
	blockObject.y = -containerBlock.height/2+blockObject.height/2
	containerBlock:insert(blockObject)
	groupScene:insert(containerBlock)

	local scrollFormulas = widget.newScrollView({
		width=display.contentWidth,
		height=(display.contentHeight-topBarArray[1].height)/2-containerBlock.height,
		horizontalScrollDisabled=true,
		isBounceEnabled=false,
		hideBackground=true,
--backgroundColor = {0, 0, 0}
})
	scrollFormulas.x = CENTER_X
	groupScene:insert(scrollFormulas)
	scrollFormulas.anchorY=0
	scrollFormulas.y = containerBlock.y+containerBlock.height/2
	local textFormulas = display.newText({
		text = loadFormula(formulas, cursor),
		x=0,
		y=0, 
		width=display.contentWidth,
		align="left",
		fontSize=fontSize0,
	})
	textFormulas.anchorY, textFormulas.anchorX = 0, 0
	scrollFormulas:insert(textFormulas)
	local function updateFormulas(setNewCursor)
		if (setNewCursor~=nil) then
			cursor=setNewCursor
		end
		textFormulas.text = loadFormula(formulas, cursor)
		scrollFormulas:setScrollHeight(textFormulas.height)
	end

--ISCORRECTISCORRECTISCORRE
--ISCORRECTISCORRECTISCORRE
--ISCORRECTISCORRECTISCORRE
--ISCORRECTISCORRECTISCORRE
--ISCORRECTISCORRECTISCORRE
local function isCorrectFormulas()
	local lang = system.getPreference( "locale", "language" )
	local tableAnswers = calculateRedactorFormulas
	local imagesObject = json.decode(funsP["получить сохранение"](IDOBJECT.."/images"))
	tableAnswers.countImages = #imagesObject
	tableAnswers.nameImage = #imagesObject>0 and " '"..imagesObject[1][1]:gsub("'","\\'"):gsub(( isWin and "\r\n" or "\n"),"\\n").."' " or " '' "
	local myCode = ""
	for i=1, #formulas do
		local typeFormulaI= formulas[i][1]
		if (typeFormulaI=="number") then
			myCode = myCode..formulas[i][2]
		elseif (typeFormulaI=="globalArray" or typeFormulaI=="localArray") then
			myCode = myCode.." {} "
		elseif (typeFormulaI=="text") then
			myCode = myCode.." '"..formulas[i][2]:gsub("'","\\'"):gsub(( isWin and "\r\n" or "\n"),"\\n").."' "
		elseif (tableAnswers[formulas[i][2]]==nil) then
			myCode = myCode.."(0)"
		else
			myCode = myCode.." "..tableAnswers[formulas[i][2]].." "
		end
	end
	local corrValue = funsP["корректность формулы"]('('..myCode..')')
	if (corrValue~=false) then
		return(type(corrValue)=="table" and encodeList(corrValue) or type(corrValue)~="function" and corrValue or nil)
	else
		return(false)
	end
end


local function touchButtonFunctions()
	scene_arrayFormulas(words[273], "functions", updateFormulas, formulas, cursor)
end
local function touchButtonProperties()
	scene_arrayFormulas(words[291], "properties", updateFormulas, formulas, cursor) 
end
local function touchButtonDevice()
	scene_arrayFormulas(words[275], "device", updateFormulas, formulas, cursor) 
end
local function touchButtonLogics()
	scene_arrayFormulas(words[276], "logics", updateFormulas, formulas, cursor) 
end
local function touchButtonData()
	scene_arrayFormulas(words[277], "data", updateFormulas, formulas, cursor) 
end
local function touchButtonErase()
	if (cursor>1) then 
		cursor = cursor-1
		table.remove(formulas, cursor)
		updateFormulas()
	end
end
local function touchButtonABC()

--AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
	cerberus.newInputLine = function (header, placeholder, isCorrectValue, value, funEditingEnd)
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
	local group = display.newGroup()
	if (SCENE=="scripts") then
	    SCENES[SCENE][1]:insert(backgroundBlackAlpha)
	    SCENES[SCENE][1]:insert(group)
	else
	    SCENES[SCENE][#SCENES[SCENE]]:insert(backgroundBlackAlpha)
	    SCENES[SCENE][#SCENES[SCENE]]:insert(group)
	end
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
	local textHeader = display.newText({
	    text=header,
	    width=rect.width-display.contentWidth/17*2,
	    x=CENTER_X, 
	    y=CENTER_Y+display.contentWidth/17,
	    font=nil,
	    fontSize=fontSize0,
	})
	textHeader.anchorY=0
	miniGroupTop:insert(textHeader)
	local textPlaceholder = display.newText({
	    text=placeholder,
	    width=rect.width-display.contentWidth/17*2,
	    x=CENTER_X, 
	    y=textHeader.y+textHeader.height+display.contentWidth/17,
	    font=nil,
	    fontSize=fontSize2,
	})
	miniGroupTop:insert(textPlaceholder)
	local input = native.newTextBox(CENTER_X, textPlaceholder.y+textPlaceholder.height, textHeader.width, textHeader.width/10)
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
	local rectButtonOk = display.newRoundedRect(CENTER_X+textHeader.width/2, CENTER_Y, textButtonOk.width+display.contentWidth/10, textButtonOk.height+display.contentWidth/30, roundedRect)
	rectButtonOk.anchorX, rectButtonOk.anchorY = 1, 0
	textButtonOk.x, textButtonOk.y = rectButtonOk.x-rectButtonOk.width/2, rectButtonOk.y+rectButtonOk.height/2
	rectButtonOk:setFillColor(66/255,66/255, 66/255)
	miniGroupBottom:insert(rectButtonOk)
	miniGroupBottom:insert(textButtonOk)
	local textButtonCancel = display.newText(words[17], 0, 0, nil, fontSize1)
	textButtonCancel:setFillColor(171/255, 219/255, 241/255)
	local rectButtonCancel = display.newRoundedRect(rectButtonOk.x-rectButtonOk.width-display.contentWidth/40, CENTER_Y, textButtonCancel.width+display.contentWidth/20, textButtonCancel.height+display.contentWidth/30, roundedRect)
	rectButtonCancel.anchorX, rectButtonCancel.anchorY = 1, 0
	textButtonCancel.x, textButtonCancel.y = rectButtonCancel.x-rectButtonCancel.width/2, rectButtonCancel.y+rectButtonCancel.height/2
	rectButtonCancel:setFillColor(66/255,66/255, 66/255)
	miniGroupBottom:insert(rectButtonCancel)
	miniGroupBottom:insert(textButtonCancel)



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

	            transition.to(backgroundBlackAlpha, {time=200, alpha=0,onComplete=function()
	                display.remove(backgroundBlackAlpha)
	            end})
	            display.remove(input)
	            transition.to(group, {time=200, alpha=0, onComplete=function()
	                display.remove(group)
	            end})

	            if (funEditingEnd~=nil) then
	                if (event.target==rectButtonOk) then
	                    funEditingEnd({["isOk"]=true, ["value"]=input.text,})
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

	        isError(event.text)

	        if (select(2, string.gsub(event.oldText, "\n", "\n")) ~= select(2, string.gsub(event.text, "\n", "\n")) and select(2, string.gsub(event.text, "\n", "\n"))<6 ) then
	            event.target.height = textHeader.width/12*math.min(math.max(select(2, string.gsub(event.text, "\n", "\n"))+1, 1), 6)
	            rectInput.y = input.y+input.height
	            textError.y = rectInput.y+rectInput.height+display.contentWidth/34
	            updateHeightRect()
	        end
	    elseif (event.pahse=="ended") then
	    end
	end)

	end
--AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

	local isEdit = (cursor>1 and formulas[cursor-1][1]=="text")
	cerberus.newInputLine(words[isEdit and 281 or 280], words[282], nil, (isEdit and formulas[cursor-1][2] or ""), function (answer)
		if (answer.isOk) then

			if (isEdit) then
				formulas[cursor-1][2] = answer.value
			else
				table.insert(formulas, cursor, {"text",answer.value})
				cursor = cursor+1
			end
			updateFormulas()
		end
	end)
end
local function touchButtonColor()
	isBackScene = "block"
	local backgroundNoTouch = display.newRect(CENTER_X, CENTER_Y, display.contentWidth, display.contentHeight)
	backgroundNoTouch:setFillColor(0,0,0,0.5)
	groupScene:insert(backgroundNoTouch)
	backgroundNoTouch.alpha = 0
	transition.to(backgroundNoTouch, {alpha=1, time=200})
	local group = display.newGroup()
	groupScene:insert(group)
	local rect = display.newRoundedRect(CENTER_X, CENTER_Y, display.contentWidth/1.1, 100, roundedRect)
	rect.anchorY=0
	group:insert(rect)
	local rectColorOld = display.newRect(rect.x-rect.width/2+display.contentWidth/20, rect.y+display.contentWidth/20, display.contentWidth/7.5, display.contentWidth/7.5)
	rectColorOld.anchorX, rectColorOld.anchorY = 0,0
	group:insert(rectColorOld)
	local rectColorNew = display.newRect(rectColorOld.x+rectColorOld.width, rectColorOld.y, rectColorOld.width, rectColorOld.height)
	rectColorNew.anchorX, rectColorNew.anchorY = 0,0
	group:insert(rectColorNew)
	local strokeColor = display.newRoundedRect(rectColorOld.x-display.contentWidth/175, rectColorOld.y-display.contentWidth/175, rectColorOld.width*2+display.contentWidth/150, rectColorOld.height+display.contentWidth/150, roundedRect)
	strokeColor.anchorX, strokeColor.anchorY = 0, 0
	strokeColor:setFillColor(0,0,0,0)
	strokeColor.strokeWidth = display.contentWidth/150
	strokeColor:setStrokeColor(184/255,184/255,184/255)
	group:insert(strokeColor)
	local textColorOld = display.newText(words[283], rectColorOld.x+rectColorOld.width/2, rectColorOld.y+rectColorOld.height, nil, fontSize2/1.15)
	textColorOld:setFillColor(184/255,184/255,184/255)
	textColorOld.anchorY = 0
	group:insert(textColorOld)
	local textColorNew = display.newText(words[284], rectColorNew.x+rectColorNew.width/2, rectColorNew.y+rectColorNew.height, nil, fontSize2/1.15)
	textColorNew:setFillColor(184/255,184/255,184/255)
	textColorNew.anchorY = 0
	group:insert(textColorNew)
	local lineColor = display.newRect(rect.x, rectColorOld.y+rectColorOld.height+display.contentWidth/17.5, rect.width, display.contentWidth/150)
	lineColor.anchorY = 0
	lineColor:setFillColor(184/255,184/255,184/255)
	group:insert(lineColor)
	local tableTypesSelectColor = {"colors","palette","rgb"}
	local widthButtonSelect = (rect.width-display.contentWidth/10)/#tableTypesSelectColor
	local buttonsTypesSelectArray = {}
	local idTypeSelect = 1

	local isEdit = cursor>1 and formulas[cursor-1][1]=="text"
	local color = isEdit and hexToRgb(formulas[cursor-1][2]) or {0,0,0}
	rectColorOld:setFillColor(color[1],color[2],color[3])
	rectColorNew:setFillColor(color[1],color[2],color[3])

	local miniGroup = nil

	local function selectColor_rgb()
		miniGroup = display.newGroup()
		miniGroup.y = lineColor.y+lineColor.height+rect.width/6.5
		group:insert(miniGroup)
		local tableColors = {{words[285],{235/255,70/255,24/255}},{words[286],{7/255,135/255,7/255}},{words[287],{2/255,132/255,231/255}}}
		local colorsObjects = {}
		local textFieldHEX = nil

		local function touchRGB(event)
			if (event.phase=="began") then
				display.getCurrentStage():setFocus(event.target, event.id)
			elseif (event.phase=="moved") then
				local rectLine = event.target.rectLine
				local line = rectLine.line
				local circle = rectLine.circle
				local textNumber = rectLine.text
				local widthTouch = math.min(math.max(event.x-rectLine.x,0),rectLine.width)
				line.width = widthTouch
				circle.x = line.x+line.width
				textNumber.text = math.round((widthTouch/rectLine.width)*255)
				color[rectLine.idColor] = widthTouch/rectLine.width
				rectColorNew:setFillColor(color[1],color[2],color[3])
				textFieldHEX.text = rgbToHex({color[1]*255,color[2]*255,color[3]*255})
			else
				display.getCurrentStage():setFocus(event.target, nil)
			end
			return(true)
		end

		for i=1, #tableColors do
			local text = display.newText(tableColors[i][1], rectColorOld.x, display.contentWidth/8*(i-0.5), nil, fontSize2)
			text.anchorX=0
			local c = tableColors[i][2]
			text:setFillColor(c[1], c[2], c[3])
			miniGroup:insert(text)
			local button = display.newRect(rect.x, text.y, rect.width/1.75, display.contentWidth/15)
			miniGroup:insert(button)
			local rectLine = display.newRect(rect.x-rect.width/1.75/2, text.y, rect.width/1.75, display.contentWidth/150)
			rectLine.anchorX = 0
			rectLine:setFillColor(227/255,227/255,227/255)
			miniGroup:insert(rectLine)
			local rectLineBlue = display.newRect(rectLine.x, rectLine.y, color[i]*rectLine.width, rectLine.height)
			rectLineBlue.anchorX = 0
			rectLineBlue:setFillColor(171/255, 219/255, 241/255)
			miniGroup:insert(rectLineBlue)
			local textNumber = display.newText(math.round(color[i]*255), rect.x+rect.width/2-display.contentWidth/20, text.y, nil, fontSize2)
			textNumber.anchorX=1
			textNumber:setFillColor(171/255, 219/255, 241/255)
			miniGroup:insert(textNumber)
			local circleLine = display.newCircle(rectLineBlue.x+rectLineBlue.width, rectLineBlue.y, rectLineBlue.height*2.5)
			circleLine:setFillColor(171/255, 219/255, 241/255)
			miniGroup:insert(circleLine)
			button:addEventListener("touch", touchRGB)
			button.rectLine = rectLine
			rectLine.text = textNumber
			rectLine.line = rectLineBlue
			rectLine.circle = circleLine
			rectLine.idColor = i
			colorsObjects[i] = rectLine
		end

		local textHEX = display.newText(words[288], rectColorOld.x, display.contentWidth/8*(3.75), nil, fontSize2)
		textHEX.anchorX = 0
		textHEX:setFillColor(0,0,0)
		miniGroup:insert(textHEX)
		textFieldHEX = native.newTextField(rect.x, textHEX.y, rect.width/5, textHEX.height)
		textFieldHEX.font = native.newFont(nil, fontSize2)
		textFieldHEX.hasBackground = false
		textFieldHEX.text = rgbToHex({color[1]*255,color[2]*255,color[3]*255})
		miniGroup:insert(textFieldHEX)
		local lineHEX = display.newRect(textFieldHEX.x, textFieldHEX.y+textFieldHEX.height/2, textFieldHEX.width, display.contentWidth/150)
		lineHEX:setFillColor(171/255, 219/255, 241/255)
		lineHEX.anchorY = 0
		miniGroup:insert(lineHEX)
		local noVisibleRect = display.newRect(rect.x, lineHEX.y+lineHEX.height, rect.width/2, display.contentWidth/12)
		noVisibleRect.anchorY=0
		noVisibleRect:setFillColor(0,0,0,0)
		miniGroup:insert(noVisibleRect)
		textFieldHEX:addEventListener("userInput", function (event)
			if (event.phase=="editing") then
				if (isCorrectHex(textFieldHEX.text)) then
					textFieldHEX:setTextColor(0,0,0)
					color = hexToRgb(textFieldHEX.text)
					rectColorNew:setFillColor(color[1], color[2], color[3])
					for i=1, #colorsObjects do
						local rectLine = colorsObjects[i]
						rectLine.line.width = color[i]*rectLine.width
						rectLine.circle.x = rectLine.x+rectLine.line.width
						rectLine.text.text = math.round(color[i]*255)
					end
				else
					textFieldHEX:setTextColor(1,0,0)
				end
			end
		end)
	end
--selectColor_rgb()

local function selectColor_palette()
	miniGroup = display.newGroup()
	miniGroup.y = (lineColor.y+lineColor.height+rect.width/6.5)
	group:insert(miniGroup)
	local palette = display.newPickerColor(function(rgb)
		color = rgb
		rectColorNew:setFillColor(color[1],color[2],color[3])
	end)
	local sizePalette = (rect.width-display.contentWidth/10)/palette.width
	palette.xScale, palette.yScale = sizePalette, sizePalette
	palette.x, palette.y = CENTER_X, palette.height*palette.yScale/2
	miniGroup:insert(palette)
	timer.performWithDelay(0, function ()
		palette.y = CENTER_Y-((lineColor.y+lineColor.height+rect.width/6.5)-rect.y)/2+palette.height*palette.yScale/2
		miniGroup.y = -group.y
	end)
end
--selectColor_palette()

local function selectColor_colors()
	miniGroup = display.newGroup()

	local function touchSetColor(event)
		if (event.phase=="began") then
			display.getCurrentStage():setFocus(event.target, event.id)
		elseif (event.phase~="moved") then
			color = event.target.myColor
			rectColorNew:setFillColor(color[1],color[2],color[3])
			display.getCurrentStage():setFocus(event.target, nil)
		end
		return(true)
	end

	miniGroup.y = lineColor.y+lineColor.height+rect.width/6.5
	group:insert(miniGroup)
	local distance = display.contentWidth/150
	local sizeColors = rect.width-display.contentWidth/10
	local tableColors = {
		{{0,118/255,205/255},{0,180/255,241/255},{7/255,135/255,7/255},{142/255,196/255,48/255}},
		{{97/255,41/255,14/255},{168/255,72/255,24/255},{222/255,174/255,102/255},{240/255,228/255,168/255}},
		{{125/255,19/255,121/255},{167/255,67/255,209/255},{202/255,1/255,134/255},{235/255,144/255,211/255}},
		{{197/255,6/255,14/255},{235/255,70/255,24/255},{249/255,146/255,28/255},{243/255,214/255,5/255}},
		{{0,0,0},{92/255,92/255,92/255},{163/255,163/255,163/255},{1,1,1}},
	}
	local heightColor = sizeColors/#tableColors
	for i=1, #tableColors do
		local widthColor = sizeColors/#tableColors[i]
		for i2=1, #tableColors[i] do
			local button = display.newRect(rect.x-sizeColors/2+widthColor*(i2-0.5), heightColor*(i-0.5), widthColor-distance, heightColor-distance)
			local color = tableColors[i][i2]
			button.myColor = color
			if (color[1]==1 and color[2]==1 and color[3]==1) then
				button.strokeWidth = display.contentWidth/300
				button:setStrokeColor(0,0,0,0.1)
			end
			button:setFillColor(color[1],color[2],color[3])
			miniGroup:insert(button)
			button:addEventListener("touch", touchSetColor)
		end
	end
end
selectColor_colors()
local tableFuncsTypesSelects = {selectColor_colors, selectColor_palette, selectColor_rgb}

local miniGroup2 = display.newGroup()
group:insert(miniGroup2)

local function touchTypeSelect(event)
	if (event.phase=="began") then
		display.getCurrentStage():setFocus(event.target, event.id)
	elseif (event.phase~="moved") then
		if (idTypeSelect~=event.target.id) then
			transition.to(event.target.line, {yScale=2, time=100, transition=easing.outQuad})
			transition.to(buttonsTypesSelectArray[idTypeSelect].line, {yScale=1, time=100, transition=easing.outQuad})
			display.remove(miniGroup)
			idTypeSelect = event.target.id
			rect.height = 0
			tableFuncsTypesSelects[idTypeSelect]()
			miniGroup2.y = miniGroup.y+miniGroup.height+display.contentWidth/15
			rect.height = group.height+display.contentWidth/20
			group.y = -group.height/2
		end
		display.getCurrentStage():setFocus(event.target, nil)
	end
	return(true)
end
for i=1, #tableTypesSelectColor do
	local button = display.newRect(rectColorOld.x+widthButtonSelect*(i-1), lineColor.y+lineColor.height, widthButtonSelect, rect.width/6.5)
	button.anchorX, button.anchorY = 0, 0
	group:insert(button)
	local image = display.newImage("images/"..tableTypesSelectColor[i]..".png")
	image.x, image.y = button.x+button.width/2, button.y+button.height/2.25
	image.width, image.height = button.height/2, button.height/2
	group:insert(image)
	local lineTypeSelect = display.newRect(button.x+button.width/2, button.y+button.height-display.contentWidth/75, button.width-display.contentWidth/100, display.contentWidth/150)
	lineTypeSelect:setFillColor(171/255, 219/255, 241/255)
	if (i==1) then
		lineTypeSelect.yScale=2
	end
	group:insert(lineTypeSelect)
	button.line = lineTypeSelect
	button.id = i
	buttonsTypesSelectArray[i] = button
	button:addEventListener("touch", touchTypeSelect)
end
miniGroup2.y = miniGroup.y+miniGroup.height+display.contentWidth/15
local textOk = display.newText(words[290], rect.x+rect.width/2-display.contentWidth/20, 0, nil, fontSize1)
textOk.anchorX, textOk.anchorY = 1, 0
textOk:setFillColor(171/255, 219/255, 241/255)
miniGroup2:insert(textOk)
local textCancel = display.newText(words[289], textOk.x-textOk.width-display.contentWidth/20, textOk.y, nil, fontSize1)
textCancel.anchorX, textCancel.anchorY = 1, 0
textCancel:setFillColor(171/255, 219/255, 241/255)
miniGroup2:insert(textCancel)
rect.height = group.height+display.contentWidth/20
group.y = -group.height/2
group.alpha = 0
transition.to(group, {alpha=1, time=200})

local function funNoTouch(event)
	if (event.phase=="ended" and event.target ~= rect) then
		if (event.target==textOk) then
			color = {color[1]*255, color[2]*255, color[3]*255}
			if (isEdit) then
				formulas[cursor-1][2] = rgbToHex(color)
			else
				table.insert(formulas, cursor, {"text",rgbToHex(color)})
				cursor=cursor+1
			end
			updateFormulas()
		end
		isBackScene = "back"
		textOk:removeEventListener("touch", funNoTouch)
		textCancel:removeEventListener("touch", funNoTouch)
		rect:removeEventListener("touch", funNoTouch)
		backgroundNoTouch:removeEventListener("touch", funNoTouch)
		transition.to(backgroundNoTouch, {alpha=0, time=150, onComplete=function ()
			display.remove(backgroundNoTouch)
		end})
		transition.to(group, {alpha=0, time=150, onComplete=function ()
			display.remove(group)
		end})
	end
	return(true)
end
textOk:addEventListener("touch", funNoTouch)
textCancel:addEventListener("touch", funNoTouch)
rect:addEventListener("touch", funNoTouch)
backgroundNoTouch:addEventListener("touch", funNoTouch)
end

local function touchButtonCalculate()
--AAAAAAAAAAAAAAAAAAAAA
--AAAAAAAAAAAAAAAAAAAAA
--AAAAAAAAAAAAAAAAAAAAA
--AAAAAAAAAAAAAAAAAAAAA
--AAAAAAAAAAAAAAAAAAAAA
isBackScene = "block"
local backgroundNoTouch = display.newRect(CENTER_X, CENTER_Y, display.contentWidth, display.contentHeight)
backgroundNoTouch:setFillColor(0,0,0,0.5)
groupScene:insert(backgroundNoTouch)
backgroundNoTouch.alpha = 0
local group = display.newGroup()
group.alpha = 0
groupScene:insert(group)
local rectGrey = display.newRoundedRect(CENTER_X, CENTER_Y, display.contentWidth/1.2, 0, roundedRect)
rectGrey:setFillColor(66/255,66/255,66/255)
group:insert(rectGrey)
local rectLight = display.newRect(CENTER_X, CENTER_Y, display.contentWidth/1.6, 0)
group:insert(rectLight)

local answerCalculate = isCorrectFormulas()
local answerCalculate = answerCalculate==nil and words[384] or answerCalculate=="nan" and words[385] or type(answerCalculate)=="boolean" and (answerCalculate and words[373] or words[374]) or answerCalculate
local textCalculate = display.newText({
	text=(answerCalculate),
	x=CENTER_X,
	y=CENTER_Y,
	width=display.contentWidth/1.6,
	font=nil,
	fontSize=fontSize1*1.5,
	align="center",
})
textCalculate:setFillColor(0,0,0)
group:insert(textCalculate)

rectGrey.height = textCalculate.height+display.contentWidth/20
rectLight.height = rectGrey.height

local function touchNoTouch(event)
	if( event.phase == "ended") then
		backgroundNoTouch:removeEventListener("touch", touchNoTouch)
		backgroundNoTouch:addEventListener("touch", touchNoTouch)
		transition.to(backgroundNoTouch, {time=150, alpha=0, onComplete=function ()
			display.remove(backgroundNoTouch)
		end})
		transition.to(group, {time=150, alpha=0, onComplete=function ()
			display.remove(group)
		end})
		isBackScene="back"
	end
	return(true)
end
backgroundNoTouch:addEventListener("touch", touchNoTouch)
transition.to(backgroundNoTouch, {time=150, alpha=1})
transition.to(group, {time=150, alpha=1})

-- кнопка вычислить
end
local function touchButtonBack()
	if (cursor>1) then
		cursor = cursor-1
		updateFormulas()
	end
end
local function touchButtonFront()
	if (cursor<=#formulas) then
		cursor = cursor+1
		updateFormulas()
	end
end
local function touchButtonNumber(value)
	if (type(value)=="number" or value==".") then
		table.insert(formulas, cursor, {"number",value})
	else
		table.insert(formulas, cursor, {value,value})
	end
	cursor = cursor+1
	updateFormulas()
end
local tableButtons = {
	{{words[273],touchButtonFunctions},{words[274],touchButtonProperties}},
	{{words[275],touchButtonDevice}, {words[276],touchButtonLogics},{words[277], touchButtonData}},
	{{"(","("},{7,7},{8,8},{9,9},{")",")"},{"⌫",touchButtonErase, true}},
	{{words[278],touchButtonABC},{4,4},{5,5},{6,6},{"÷","÷"},{"×","×"}},
	{{"color",touchButtonColor},{1,1},{2,2},{3,3},{"-","-"},{"+","+"}},
	{{"<-",touchButtonBack, true},{"->",touchButtonFront, true},{0,0},{".","."},{"=","="},{words[279],touchButtonCalculate}},
}
local heightButton = (display.contentHeight+topBarArray[1].y-(scrollFormulas.y+scrollFormulas.height+50))/#tableButtons

local isTimerSpam = false
local timerSpam = nil
local function touchButton(event)
	if (event.phase=="began") then
		event.target.alpha = 0.75
		if (type(event.target.functional)=="function") then
			event.target.functional()
		else
			touchButtonNumber(event.target.functional)
		end
		if (event.target.isSpam==true) then
			isTimerSpam = true
			timerSpam = timer.performWithDelay(450, function ()
				timerSpam = timer.performWithDelay(50, function ()
					if (type(event.target.functional)=="function") then
						event.target.functional()
					else
						touchButtonNumber(event.target.functional)
					end
				end,0)
			end)
		end
		display.getCurrentStage():setFocus(event.target, event.id)
	elseif (event.phase~="moved") then
		if (isTimerSpam) then
			isTimerSpam = false
			timer.cancel(timerSpam)
		end
		event.target.alpha = 1
		display.getCurrentStage():setFocus(event.target, nil)
	end
	return(true)
end

for i=1, #tableButtons do
	local widthButton = display.contentWidth/#tableButtons[i]
	for i2=1, #tableButtons[i] do
		local button = display.newRect(widthButton*(i2-1)+display.screenOriginX, scrollFormulas.y+scrollFormulas.height+heightButton*(i-1), widthButton, heightButton)
		button.anchorX, button.anchorY = 0, 0
		if (i<=2) then
			button:setFillColor(0, 71/255, 93/255)
		else
			button:setFillColor(0+0.05, 71/255+0.05, 93/255+0.05)
		end
		button.strokeWidth = display.contentWidth/200
		button:setStrokeColor(4/255, 34/255, 44/255)
		groupScene:insert(button)
		button.functional = tableButtons[i][i2][2]
		button.isSpam = tableButtons[i][i2][3]
		button:addEventListener("touch",touchButton)
		local header = display.newText(tableButtons[i][i2][1], button.x+button.width/2, button.y+button.height/2, nil, fontSize1)
		groupScene:insert(header)
	end
end

funBackObjects[1] = function ()
if (isBackScene=="back" and isCorrectFormulas()~=nil) then
	objectsParameter[4].text = loadFormula(formulas)
	funsP["записать сохранение"](IDOBJECT.."/scripts", json.encode(blocks))
	funBack = oldSceneBack
	display.remove(SCENES[SCENE][2])
	display.remove(SCENES[SCENE][1])
	SCENE = "scripts"
	SCENES[SCENE][1].alpha = 1
elseif (isBackScene=="back") then
	funsP["вызвать уведомление"](words[386])
end
end

end