-- сцена со всеми формулами в редакторе выражений

function scene_arrayFormulas(headerFormulas, typeFormulas, updateFormulas, formulas, cursor)
	local oldSceneBack = funBack
	app.scenes["formula_editor"][1].alpha = 0
	local groupScene = display.newGroup()
	local groupSceneScroll = display.newGroup()
	app.scene = "arrayFormulas"
	app.scenes[app.scene] = {groupSceneScroll, groupScene}
	local funBackObjects = {}
	local topBarArray = topBar(groupScene, headerFormulas, nil, nil, funBackObjects)
	topBarArray[4].alpha = 0
	local isBackScene = "back"

	local scrollProjects = plugins.widget.newScrollView({
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

	local namesGlobalVariables = plugins.json.decode(funsP["получить сохранение"](app.idProject.."/variables"))
	local namesLocalVariables = plugins.json.decode(funsP["получить сохранение"](app.idObject.."/variables"))
	local nameVariable = nil
	local localityVariable = "globalVariable"
	if (#namesLocalVariables>0) then
		nameVariable = namesLocalVariables[#namesLocalVariables][1]
		localityVariable = "localVariable"
	elseif (#namesGlobalVariables>0) then
		nameVariable = namesGlobalVariables[#namesGlobalVariables][1]
	end
	local namesGlobalArrays = plugins.json.decode(funsP["получить сохранение"](app.idProject.."/arrays"))
	local namesLocalArrays = plugins.json.decode(funsP["получить сохранение"](app.idObject.."/arrays"))
	local nameArray = nil
	local localityArray = "globalArray"
	if (#namesLocalArrays>0) then
		nameArray = namesLocalArrays[#namesLocalArrays][1]
		localityArray = "localArray"
	elseif (#namesGlobalArrays>0) then
		nameArray = namesGlobalArrays[#namesGlobalArrays][1]
	end

	local arrayAllFunctions = plugins.json.decode(plugins.json.encode(allCategotiesAndFormulas))----------------------------------------------
		if (typeFormulas=="functions") then
			if (nameArray~=nil) then
				arrayAllFunctions.functions[3] = {app.words[321],{
					{{"function","lengthArray"},{"function","("},{localityArray,nameArray},{"function",")"}}, {{"function","elementArray"},{"function","("},{"number",1},{"function",","},{localityArray,nameArray},{"function",")"}}, {{"function","containsArray"},{"function","("},{localityArray,nameArray},{"function",","},{"number",1},{"function",")"}},  {{"function","indexArray"},{"function","("},{"number",1},{"function",","},{localityArray,nameArray},{"function",")"}},{{"function","levelingArray"},{"function","("},{localityArray,nameArray},{"function",")"}},--{{"function","array2json"},{"function","("},{localityArray,nameArray},{"function",")"}},{{"function","json2array"},{"function","("},{localityArray,nameArray},{"function",")"}},
				}}
			else
				arrayAllFunctions.functions[3] = {app.words[326],{}}
			end
		elseif (typeFormulas=="data") then
			if (#namesGlobalVariables>0) then
				arrayAllFunctions.data[1] = {app.words[376],{}}
				local array = arrayAllFunctions.data[1][2]
				for i=1, #namesGlobalVariables do
					array[i] = {{"globalVariable",namesGlobalVariables[i][1]}}
				end
			end
			if (#namesLocalVariables>0) then
				arrayAllFunctions.data[#arrayAllFunctions.data+1] = {app.words[377],{}}
				local array = arrayAllFunctions.data[#arrayAllFunctions.data][2]
				for i=1, #namesLocalVariables do
					array[i] = {{"localVariable",namesLocalVariables[i][1]}}
				end
			end
			if (#namesGlobalArrays>0) then
				arrayAllFunctions.data[#arrayAllFunctions.data+1] = {app.words[378],{}}
				local array = arrayAllFunctions.data[#arrayAllFunctions.data][2]
				for i=1, #namesGlobalArrays do
					array[i] = {{"globalArray",namesGlobalArrays[i][1]}}
				end
			end
			if (#namesLocalArrays>0) then
				arrayAllFunctions.data[#arrayAllFunctions.data+1] = {app.words[379],{}}
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

				local notVisibleRect = app.cerberus.newImage("images/notVisible.png")
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
							pathSave = app.idProject.."/variables"
						elseif (info[1]=="localVariable") then
							pathSave = app.idObject.."/variables"
						elseif (info[1]=="globalArray") then
							pathSave = app.idProject.."/arrays"
						elseif (info[1]=="localArray") then
							pathSave = app.idObject.."/arrays"
						end
						local arrayVarsArrs = plugins.json.decode(funsP["получить сохранение"](pathSave))

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
									funsP["записать сохранение"](pathSave, plugins.json.encode(arrayVarsArrs))
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
							app.cerberus.newBannerQuestion(app.words[382], onCompleteFun, app.words[289],app.words[383])
						elseif (event.target.typeFunction == "rename") then

							local function isCorrectValue(value)
								if (string.len(value)==0) then
									return(app.words[18])
								else
									local isCorrect = true
									for i=1, #tableObjectsList do
										if (tableObjectsList[i][1]=="button" and value==tableObjectsList[i][2].menu.text.text) then
											isCorrect = false
											break
										end
									end
									return(isCorrect and "" or app.words[15])
								end
							end

							local function funEditingEnd(answer)
								if (answer.isOk) then
									answer.value = answer.value:gsub( (utils.isWin and '\r\n' or '\n'), " ")
									eventTargetMenu.text.text = answer.value
									for i=1, #arrayVarsArrs do
										if (arrayVarsArrs[i][1]==info[2]) then
											arrayVarsArrs[i][2] = answer.value
											break
										end
									end
									funsP["записать сохранение"](pathSave, plugins.json.encode(arrayVarsArrs))
									updateFormulas()
								end
							end
							app.cerberus.newInputLine(app.words[6], app.words[250], isCorrectValue, eventTargetMenu.text.text, funEditingEnd)
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

					buttons[i].header = display.newText(app.words[arrayButtonsFunctions[i][1]], -buttons[i].width/1.1, buttons[i].y+buttons[i].height/2, nil, app.fontSize1)
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
				fontSize=app.fontSize1/1.1,
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
				local text = display.newText(loadFormula(button.functions), header.x, 0, nil, app.fontSize1/1.1)
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
					local menu = app.cerberus.newImage("images/menu.png")
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
			display.remove(app.scenes[app.scene][2])
			display.remove(app.scenes[app.scene][1])
			app.scene = "formula_editor"
			app.scenes[app.scene][1].alpha = 1
			funBack = oldSceneBack
		end
	end
	scrollProjects:setScrollHeight(groupSceneScroll.height+display.contentWidth/1.5)

end