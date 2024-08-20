function scene_arrayFormulas(headerFormulas, typeFormulas, updateFormulas, formulas, cursor)
	local oldSceneBack = funBack
	SCENES["formula_editor"][1].alpha = 0
	local groupScene = display.newGroup()
	local groupSceneScroll = display.newGroup()
	SCENE = "arrayFormulas"
	SCENES[SCENE] = {groupScene, groupSceneScroll}
	local funBackObjects = {}
	local topBarArray = topBar(groupScene, headerFormulas, nil, nil, funBackObjects)
	topBarArray[4].alpha = 0
	local isBackScene = "back"

	local scrollProjects = widget.newScrollView({
		width=display.contentWidth,
		height=display.contentHeight-topBarArray[1].height,
		horizontalScrollDisabled=true,
		isBounceEnabled=false,
		hideBackground=true,
	})
	scrollProjects.x = CENTER_X
	groupScene:insert(scrollProjects)
	scrollProjects.anchorY=0
	scrollProjects.y = topBarArray[1].y+topBarArray[1].height
	scrollProjects:insert(groupSceneScroll)

	local namesGlobalVariables = json.decode(funsP["получить сохранение"](IDPROJECT.."/variables"))
	local namesLocalVariables = json.decode(funsP["получить сохранение"](IDOBJECT.."/variables"))
	local nameVariable = nil
	local localityVariable = "globalVariable"
	if (#namesLocalVariables>0) then
		nameVariable = namesLocalVariables[#namesLocalVariables][1]
		localityVariable = "localVariable"
	elseif (#namesGlobalVariables>0) then
		nameVariable = namesGlobalVariables[#namesGlobalVariables][1]
	end
	local namesGlobalArrays = json.decode(funsP["получить сохранение"](IDPROJECT.."/arrays"))
	local namesLocalArrays = json.decode(funsP["получить сохранение"](IDOBJECT.."/arrays"))
	local nameArray = nil
	local localityArray = "globalArray"
	if (#namesLocalArrays>0) then
		nameArray = namesLocalArrays[#namesLocalArrays][1]
		localityArray = "localArray"
	elseif (#namesGlobalArrays>0) then
		nameArray = namesGlobalArrays[#namesGlobalArrays][1]
	end

	local arrayAllFunctions = {
		functions={
			{words[292],{ {{"function","sinus"},{"function","("},{"number",9},
			{"number",0},{"function",")"}}, {{"function","cosine"},
			{"function","("},{"number",3},{"number",6},{"number",0},
			{"function",")"}}, {{"function","tangent"},{"function","("},
			{"number",4},{"number",5},{"function",")"}}, 
			{{"function","naturalLogarithm"},{"function","("},{"number",2},
			{"number","."},{"number",7},{"number",1},{"number",8},{"number",2},
			{"number",8},{"number",1},{"number",8},{"number",2},{"number",8},
			{"number",4},{"number",5},{"number",9},{"function",")"}}, 
			{{"function","decimalLogarithm"},{"function","("},{"number",1},
			{"number",0},{"function",")"}}, {{"function","pi"}}, 
			{{"function","root"},{"function","("},{"number",4},{"function",")"}}, 
			{{"function","random"},{"function","("},{"number",1},{"function",","},
			{"number",6},{"function",")"}}, {{"function","absoluteValue"},
			{"function","("},{"number",1},{"function",")"}}, 
			{{"function","round"},{"function","("},{"number",1},{"number","."},
			{"number",6},{"function",")"}}, {{"function","modulo"},
			{"function","("},{"number",3},{"function",","},{"number",2},
			{"function",")"}}, {{"function","arcsine"},{"function","("},
			{"number",0},{"number","."},{"number",5},{"function",")"}}, 
			{{"function","arccosine"},{"function","("},{"number",0},
			{"function",")"}}, {{"function","arctangent"},{"function","("},
			{"number",1},{"function",")"}}, {{"function","arctangent2"},
			{"function","("},{"function","-"},{"number",1},{"function",","},
			{"number",0},{"function",")"}}, {{"function","exponent"},
			{"function","("},{"number",1},{"function",")"}}, 
			{{"function","degree"},{"function","("},{"number",2},
			{"function",","},{"number",3},{"function",")"}}, 
			{{"function","roundDown"},{"function","("},{"number",9},
			{"number","."},{"number",0},{"function",")"}}, 
			{{"function","roundUp"},{"function","("},{"number",0},{"number","."},
			{"number",3},{"function",")"}}, {{"function","maximum"},
			{"function","("},{"number",5},{"function",","},{"number",4},
			{"function",")"}}, {{"function","minimum"},{"function","("},
			{"number",7},{"function",","},{"number",2},{"function",")"}},
			{{"function","ternaryExpression"},{"function","("},
			{"function","false"},{"function",","},{"number",2},{"function",","},
			{"number",3},{"function",")"}} 

		}},

		{words[315],{ 
			{{"function","length"},{"function","("},{"text","hello world"},{"function",")"}},
			{{"function","characterFromText"},{"function","("},{"number",1},{"function",","},{"text","hello world"},{"function",")"}}, 
			{{"function","connect"},{"function","("},{"text","hello"},{"function",","},{"text"," world"},{"function",")"}}, 
			{{"function","connect2"},{"function","("},{"text","hello"},{"function",","},{"text"," world"},{"function",","},{"text","!"},{"function",")"}}, 
			{{"function","regularExpression"},{"function","("},{"text"," an? ([^ .]+)"},{"function",","},{"text","I am a panda."},{"function",")"}} }}
		},
		properties={
			{words[327],{ --[[]]
				{{"function","transparency"}}, {{"function","brightness"}}, 
				{{"function","color"}},{{"function","numberImage"}},
				{{"function","nameImage"}},{{"function","countImages"}} }},
				{words[334], { {{"function","positionX"}},{{"function","positionY"}},
				{{"function","size"}},{{"function","direction"}},{{"function","directionView"}},
				{{"function","touchesObject"}},
				{{"function","touchesFinger"}},{{"function","speedX"}},{{"function","speedY"}},
				{{"function","angularVelocity"}} }}
			},
			device={
				{words[347],{ {{"function","displayPositionColor"},{"function","("},{"number",1},{"number",0},{"number",0},{"function",","},{"number",2},{"number",0},{"number",0},{"function",")"}}, 
				{{"function","language"}} }},
				{words[350],{ {{"function","touchDisplayX"}},{{"function","touchDisplayY"}},
				{{"function","touchDisplay"}},{{"function","touchDisplayXId"},{"function","("},{"number",1},{"function",")"}},
				{{"function","touchDisplayYId"},{"function","("},{"number",1},{"function",")"}},
				{{"function","touchDisplayId"},{"function","("},{"number",1},{"function",")"}},
				{{"function","countTouchDisplay"}},{{"function","countTouch"}},
				--[[{{"function","indexThisTouch"},{"function","("},{"number",1},{"function",")"}}]] }},
				{words[360], { {{"function","timer"}},{{"function","year"}},
				{{"function","month"}},{{"function","day"}},{{"function","dayWeek"}},
				{{"function","hour"}},{{"function","minute"}},{{"function","second"}} }}
			},
			logics={
				{words[369],{ {{"function","and"}},{{"function","or"}},
				{{"function","not"}},{{"function","true"}},{{"function","false"}}, }},
				{words[375],{ {{"function","="}},{{"function","≠"}},{{"function","<"}},
				{{"function","≤"}},{{"function",">"}},{{"function","≥"}}, {{"function",","}} }},
			},
			data={}
		}
		if (typeFormulas=="functions") then
			if (nameArray~=nil) then
				arrayAllFunctions.functions[3] = {words[321],{
					{{"function","lengthArray"},{"function","("},{localityArray,nameArray},{"function",")"}}, {{"function","elementArray"},{"function","("},{"number",1},{"function",","},{localityArray,nameArray},{"function",")"}}, {{"function","containsArray"},{"function","("},{localityArray,nameArray},{"function",","},{"number",1},{"function",")"}},  {{"function","indexArray"},{"function","("},{"number",1},{"function",","},{localityArray,nameArray},{"function",")"}},{{"function","levelingArray"},{"function","("},{localityArray,nameArray},{"function",")"}},
				}}
			else
				arrayAllFunctions.functions[3] = {words[326],{}}
			end
		elseif (typeFormulas=="data") then
			if (#namesGlobalVariables>0) then
				arrayAllFunctions.data[1] = {words[376],{}}
				local array = arrayAllFunctions.data[1][2]
				for i=1, #namesGlobalVariables do
					array[i] = {{"globalVariable",namesGlobalVariables[i][1]}}
				end
			end
			if (#namesLocalVariables>0) then
				arrayAllFunctions.data[#arrayAllFunctions.data+1] = {words[377],{}}
				local array = arrayAllFunctions.data[#arrayAllFunctions.data][2]
				for i=1, #namesLocalVariables do
					array[i] = {{"localVariable",namesLocalVariables[i][1]}}
				end
			end
			if (#namesGlobalArrays>0) then
				arrayAllFunctions.data[#arrayAllFunctions.data+1] = {words[378],{}}
				local array = arrayAllFunctions.data[#arrayAllFunctions.data][2]
				for i=1, #namesGlobalArrays do
					array[i] = {{"globalArray",namesGlobalArrays[i][1]}}
				end
			end
			if (#namesLocalArrays>0) then
				arrayAllFunctions.data[#arrayAllFunctions.data+1] = {words[379],{}}
				local array = arrayAllFunctions.data[#arrayAllFunctions.data][2]
				for i=1, #namesLocalArrays do
					array[i] = {{"localArray",namesLocalArrays[i][1]}}
				end
			end

		end
		local arrayFunctions = arrayAllFunctions[typeFormulas]

		local function touchFunction(event)
			if (event.phase=="began") then
				event.target:setFillColor(22/255,92/255,114/255)
				if (typeFormulas=="data") then
					event.target.menu:setFillColor(22/255,92/255,114/255)
				end
				display.getCurrentStage():setFocus(event.target, event.id)
			elseif (event.phase=="moved") then
				event.target:setFillColor(0, 71/255, 93/255)
				if (typeFormulas=="data") then
					event.target.menu:setFillColor(0, 71/255, 93/255)
				end
				scrollProjects:takeFocus(event)
			else
				local addFormulas = event.target.functions
				for i=1, #addFormulas do
					table.insert(formulas, cursor, addFormulas[i])
					cursor = cursor+1
				end
				updateFormulas(cursor)
				funBackObjects[1]()
				display.getCurrentStage():setFocus(event.target, nil)
			end
			return(true)
		end

		local tableObjectsList = {}
		local idPos = 0.5-1

		local function touchMenu(event)
			if (event.phase=="began") then
				display.getCurrentStage():setFocus(event.target, event.id)
			elseif (event.phase=="moved") then
				scrollProjects:takeFocus(event)
			else
				display.getCurrentStage():setFocus(event.target, nil)

				isBackScene="block"

				local notVisibleRect = cerberus.newImage("images/notVisible.png")
				notVisibleRect.x, notVisibleRect.y, notVisibleRect.width, notVisibleRect.height = CENTER_X, CENTER_Y, display.contentWidth, display.contentHeight

				local xPosScroll, yPosScroll = scrollProjects:getContentPosition()
				local groupMenu = display.newGroup()
				groupMenu.x, groupMenu.y = display.contentWidth, event.target.group.y+event.target.height/3+scrollProjects.y+yPosScroll

				groupMenu.xScale, groupMenu.yScale, groupMenu.alpha = 0.3, 0.3, 0

				local arrayButtonsFunctions = {{5, "delete"}, {6, "rename"}}

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

						local info = eventTargetMenu.info[1]
						local pathSave = nil
						if (info[1]=="globalVariable") then
							pathSave = IDPROJECT.."/variables"
						elseif (info[1]=="localVariable") then
							pathSave = IDOBJECT.."/variables"
						elseif (info[1]=="globalArray") then
							pathSave = IDPROJECT.."/arrays"
						elseif (info[1]=="localArray") then
							pathSave = IDOBJECT.."/arrays"
						end
						local arrayVarsArrs = json.decode(funsP["получить сохранение"](pathSave))

						if (event.target.typeFunction == "delete") then
							local function onCompleteFun(answer)
								if (answer.isOk) then
									table.remove(tableObjectsList, eventTargetMenu.id)
									for i=1, #arrayVarsArrs do
										if (arrayVarsArrs[i][1]==info[2]) then
											table.remove(arrayVarsArrs,i)
											break
										end
									end
									funsP["записать сохранение"](pathSave, json.encode(arrayVarsArrs))
									if (#arrayVarsArrs==0) then
										local header = tableObjectsList[eventTargetMenu.id-1][2]
										table.remove(tableObjectsList, eventTargetMenu.id-1)
										display.remove(header)
									end
									display.remove(eventTargetMenu.group)
									for i=1, #tableObjectsList do
										local tableObject = tableObjectsList[i]
										tableObject[2].y = display.contentWidth/8*(i-0.5)
										if (tableObject[1]=="button") then
											tableObject[2].menu.id = i
										end
									end
									updateFormulas()
								end
							end
							cerberus.newBannerQuestion(words[382], onCompleteFun, words[289],words[383])
						elseif (event.target.typeFunction == "rename") then

							local function isCorrectValue(value)
								if (string.len(value)==0) then
									return(words[18])
								else
									local isCorrect = true
									for i=1, #tableObjectsList do
										if (tableObjectsList[i][1]=="button" and value==tableObjectsList[i][2].menu.text.text) then
											isCorrect = false
											break
										end
									end
									return(isCorrect and "" or words[15])
								end
							end

							local function funEditingEnd(answer)
								if (answer.isOk) then
									answer.value = answer.value:gsub( (isWin and '\r\n' or '\n'), " ")
									eventTargetMenu.text.text = answer.value
									for i=1, #arrayVarsArrs do
										if (arrayVarsArrs[i][1]==info[2]) then
											arrayVarsArrs[i][2] = answer.value
											break
										end
									end
									funsP["записать сохранение"](pathSave, json.encode(arrayVarsArrs))
									updateFormulas()
								end
							end
							cerberus.newInputLine(words[6], words[250], isCorrectValue, eventTargetMenu.text.text, funEditingEnd)
						end

						for i=1, #buttons do
							buttons[i]:removeEventListener("touch", touchTypeFunction)
						end
						display.remove(notVisibleRect)
						transition.to(groupMenu, {time=200, alpha=0, onComplete=function ()
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
						transition.to(groupMenu, {time=200, alpha=0, onComplete=function ()
							display.remove(groupMenu)
						end})
					end
					return(true)
				end)


			end
			return(true)
		end

		local idParagraph = 0
		for i=1, #arrayFunctions do
			idParagraph = idParagraph+1
			idPos=idPos+1
			local group = display.newGroup()
			group.y = display.contentWidth/8*idPos
			groupSceneScroll:insert(group)
			tableObjectsList[#tableObjectsList+1] = {"header",group}
			local header = display.newText({
				text=arrayFunctions[i][1], 
				x=display.contentWidth/20, 
				y=0,
				fontSize=fontSize1/1.1,
				width=display.contentWidth-display.contentWidth/10,
				align="left",
			})
			header.anchorX=0
			group:insert(header)
			for i2=1, #arrayFunctions[i][2] do
				idParagraph = idParagraph+1
				idPos = idPos+1
				local group = display.newGroup()
				group.y = display.contentWidth/8*idPos
				groupSceneScroll:insert(group)
				local button = display.newRect(0, 0, display.contentWidth, display.contentWidth/8)
				button.anchorX = 0
				button:setFillColor(0, 71/255, 93/255)
				group:insert(button)
				button.functions = arrayFunctions[i][2][i2]
				button:addEventListener("touch", touchFunction)
				local text = display.newText(loadFormula(button.functions), header.x, 0, nil, fontSize1/1.1)
				text.anchorX = 0
				text:setFillColor(171/255, 219/255, 241/255)
				group:insert(text)
				if (typeFormulas=="data") then
					tableObjectsList[#tableObjectsList+1] = {"button",group}
					text.text = text.text:sub(2,-2)
					local menuRect = display.newRect(display.contentWidth, 0, 0, button.height)
					menuRect:setFillColor(0, 71/255, 93/255)
					menuRect.anchorX=1
					group:insert(menuRect)
					local menu = cerberus.newImage("images/menu.png")
					menu.x = display.contentWidth-display.contentWidth/20
					menu:setFillColor(171/255, 219/255, 241/255)
					menu.yScale = (button.height/menu.height)/2.75
					menu.xScale, menu.anchorX = menu.yScale, 1
					group:insert(menu)
					menuRect.width = display.contentWidth/10+menu.width*menu.xScale
					group.menu = menuRect
					menuRect.text = text
					menuRect.group = group
					menuRect.info = button.functions
					menuRect.id = idParagraph
					menuRect:addEventListener("touch", touchMenu)
					button.menu = menuRect
				end

			end
		end

		funBackObjects[1] = function ()
		if (isBackScene=="back") then
			display.remove(SCENES[SCENE][2])
			display.remove(SCENES[SCENE][1])
			SCENE = "formula_editor"
			SCENES[SCENE][1].alpha = 1
			funBack = oldSceneBack
		end
	end
	scrollProjects:setScrollHeight(groupSceneScroll.height+display.contentWidth/1.5)

end