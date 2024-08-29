oldBackScripts = nil
function scene_categoryScripts(category, nameCategory, funAddBlock)

	if (oldBackScripts==nil) then
		oldBackScripts=funBack
	end

	local namesFunctions = json.decode(funsP["получить сохранение"](IDSCENE.."/functions"))
	local nameFunction = nil
	if (#namesFunctions>0) then
		nameFunction = namesFunctions[#namesFunctions][1]
	else
		namesFunctions[1] = {1, words[79], 0}
		funsP["записать сохранение"](IDSCENE.."/functions", json.encode(namesFunctions))
		nameFunction = 1
	end
	local idBackgroundObject = json.decode(funsP["получить сохранение"](IDSCENE.."/objects"))[1][2]
	local namesBackgrounds = json.decode(funsP["получить сохранение"](IDSCENE.."/object_"..idBackgroundObject.."/images"))
	local nameBackground = #namesBackgrounds>0 and namesBackgrounds[1][2] or nil
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
	local namesScenes = json.decode(funsP["получить сохранение"](IDPROJECT.."/scenes"))
	local nameScene = nil
	if (#namesScenes>1) then
		if (IDSCENE~=IDPROJECT.."/scene_"..namesScenes[1][2]) then
			nameScene = namesScenes[1][2]
		else
			nameScene = namesScenes[2][2]
		end
	end
	local namesSounds = json.decode(funsP["получить сохранение"](IDOBJECT.."/sounds"))
	local nameSound = #namesSounds>0 and namesSounds[1][2] or nil
	local namesImages = json.decode(funsP["получить сохранение"](IDOBJECT.."/images"))
	local nameImage = #namesImages>0 and namesImages[1][2] or nil



	local groupScene = display.newGroup()
	local groupSceneScroll = display.newGroup()

	SCENE = "categoryScripts"
	SCENES[SCENE] = {groupScene, groupSceneScroll}
	local touchBackMenu = {function ()
		display.remove(groupScene)
		display.remove(groupSceneScroll)
		scene_categoriesScripts(funAddBlock)
	end}
	local topBarArray = topBar(groupScene, nameCategory, nil, nil, touchBackMenu)
	topBarArray[4].alpha = 0

	local scrollProjects = widget.newScrollView({
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

	local allBlocksCategories = {
		["used"]={
			{"stopScript"},
			{"continueScene",{ {"scenes", nameScene} }},
			{"removeAdaptiveSizeDevice"},
			{"toFrontLayerVar",{ {localityVariable, nameVariable} }},
			{"toBackLayerVar",{ {localityVariable, nameVariable} }},
			{"wait", {{{"number", 1}}}},
		},
		["event"]={
			{"start"},
			{"touchBack"},
			{"touchObject"},
			{"movedObject"},
			{"onTouchObject"},
			{"touchScreen"},
			{"movedScreen"},
			{"onTouchScreen"},
			{"function",{{"function",nameFunction}}},
			{"broadcastFunction",{{"function",nameFunction}}},
			{"broadcastFunctionAndWait",{{"function",nameFunction}}},
			{"broadcastFun>allObjects",{{"function",nameFunction}}},
			{"broadcastFun>allClones",{{"function",nameFunction}}},
			{"broadcastFun>objectAndClones",{{"objects",nil},{"function",nameFunction}}},
			{"broadcastFun>object",{{"objects",nil},{"function",nameFunction}}},
			{"broadcastFun>clones",{{"objects",nil},{"function",nameFunction}}},
			{"addNameClone", { {{"text",words[444]}} }},
			{"broadcastFun>nameClone",{{{"text",words[444]}},{"function",nameFunction}}},
			--{"whenTheTruth",{ {{"number", 1},{"function", "<"},{"number", 2}},  }},
			{"collision",{ {{"objects", nil}} }},
			{"endedCollision", { {{"objects", nil}} }},
			{"changeBackground",{ {"backgrounds", nameBackground} }},
			{"startClone"},
			{"clone",{{"objects",nil}}},
			{"deleteClone"},
		},
		["control"]={
			{"timer", {{{"number", 5}}, {{"number", 1}}}},
			{"wait", {{{"number", 1}}}},
			--{"wait",{ {{"number", 1}} }},
			{"commentary",{ {{"text", words[95]}} }},
			{"cycleForever"},
			{"ifElse (2)",{ {{"number", 1},{"function","<"},{"number",2}} }},
			{"if (2)",{ {{"number", 1},{"function","<"},{"number",2}} }},
			{"waitIfTrue",{ {{"number", 1},{"function","<"},{"number",2}} }},
			{"repeat",{ {{"number", 1},{"number",0}} }},
			{"repeatIsTrue",{ {{"number", 1},{"function","<"},{"number",2}} }},
			{"for",{ {{"number", 1}}, {{"number",1},{"number",0}}, {localityVariable,nameVariable}}},
			{"foreach",{ {localityArray, nameArray}, {localityVariable,nameVariable}}},
			{"continueScene",{ {"scenes", nameScene} }},
			{"runScene",{ {"scenes", nameScene} }},
			{"exitGame"},
			{"stopScript"},
			--{"waitStopScripts"},
			{"cancelAllTimers"},
			{"startClone"},
			{"clone",{{"objects",nil}}},
			{"deleteClone"},
		},
		["physic"]={
			{"setPosition",{ {{"number", 100}}, {{"number", 200}} }},
			{"setPositionX",{ {{"number", 100}} }},
			{"setPositionY",{ {{"number", 200}} }},
			{"editPositionX",{ {{"number", 10}} }},
			{"editPositionY",{ {{"number", 10}} }},
			{"goTo",{ {"goTo", "touch"} }},
			{"goSteps",{ {{"number", 10}} }},
			{"editRotateLeft",{ {{"number", 15}} }},
			{"editRotateRight",{ {{"number", 15}} }},
			{"setRotate",{ {{"number", 90}} }},
			{"setRotateToObject",{{"objects",nameObject}}},
			{"setTypeRotate",{{"typeRotate","false"}}},
			{"transitionPosition",{ {{"number",1}}, {{"number",100}}, {{"number",200}} }},
			{"toFrontLayer"},
			{"toBackLayer"},
			{"vibration",{{{"number", 1}}}},
			{"addBody", {{"typeBody", "dynamic"}}},
			{"speedStepsToSecoond",{{{"number",0}}, {{"function","-"},{"number",10}}}},
			{"rotateLeftForever",{{{"number",15}}}},
			{"rotateRightForever",{{{"number",15}}}},
			{"setGravityAllObjects",{{{"number",0}}, {{"function","-"},{"number",10}} }},
			{"setWeight",{{{"number",1}} }},
			{"setElasticity",{{{"number",20}} }},
			{"setFriction",{{{"number",80}} }},
			{"showHitboxes"},
			{"hideHitboxes"},
			{"setTextelCoarseness",{{{"number", 1}}}},
			{"jump", {{{"number", 10}}, {{"number", 20}}}},
			{"jumpX", {{{"number", 10}}}},
			{"jumpY", {{{"number", 20}}}},
			{"jumpYIf", {{{"number", 20}}}},
			{"setGravityScale", {{{"function","-"},{"number", 10}}}},
		},
		["sounds"]={
			{"playSound", {{"sounds",nameSound}}},
			--{"playSoundAndWait", {{"sounds",nameSound}}},
			{"stopSound", {{"sounds",nameSound}}},
			{"stopAllSounds"},
			{"setVolumeSound",{{{"number",60}}}},
			{"editVolumeSound", {{{"function","-"},{"number",10}}}},
		},
		["images"]={
			{"setImageToName",{{"images",nameImage}}},
			{"setImageToId",{{{"number",1}}}},
			{"nextImage"},
			{"previousImage"},
			{"setSize",{{{"number",60}}}},
			{"editSize",{{{"number",10}}}},
			{"hide"},
			{"show"},
			{"setBackgroundColor", {{{"number", 0}}, {{"number", 0}}, {{"number", 0}}}},
			{"setBackgroundColorHex", {{{"text", "#FFFFFF"}}}},
			--{"ask",{{{"text",words[161]}}, {localityVariable, nameVariable} }},
			--{"say",{{{"text",words[164]}} }},
			{"sayTime",{{{"text",words[164]}}, {{"number",1}} }},
			--{"think",{{{"text",words[168]}} }},
			{"thinkTime",{{{"text",words[168]}}, {{"number",1}} }},
			{"setAlpha", {{{"number",50}}}},
			{"editAlpha",{{{"number",25}}}},
			{"setBrightness",{{{"number",50}}}},
			{"editBrightness",{{{"number",25}}}},
			{"setColor", {{{"number",0}}}},
			{"editColor", {{{"number",25}}}},

			--{"onAdaptabilityEffect",{{"onOrOff","on"}}},
			--{"setColorParticle",{{{"text","#ff0000"}}}},
			--{"clearGraphicsEffects"},
			{"focusCameraToObject", {{{"number",0}},{{"number",0}}}},
			{"removeObjectCamera"},
			{"insertObjectCamera"},
			{"removeFocusCameraToObject"},
			{"changeBackground",{ {"backgrounds", nameBackground} }},
			{"setImageBackgroundToName",{{"backgrounds",nameBackground}}},
			{"setImageBackgroundToId",{{{"number",1}}}},
			--{"setImageBackgroundToNameAndWait",{{"backgrounds",nameBackground}}},
			--{"setImageBackgroundToIdAndWait",{{{"number",1}}}},
			{"getLinkImage",{{{"text","https://docs.coronalabs.com/images/simulator/image-mask-base2.png"}}}},
		},
		["particles"]={
			--{"setSizeParticle", {{{"text",words[417]}},{{"number",60}}}},
			{"setPositionParticle", {{{"text",words[417]}},{{"number",100}},{{"number",200}}} },
			{"editPositionXParticle",{{{"text",words[417]}},{{"number",10}}}},
			{"editPositionYParticle",{{{"text",words[417]}},{{"number",10}}}},
			{"deleteParticle", {{{"text",words[417]}}}},
			{"deleteAllParticles"},
			{"createRadialParticle",{{{"text",words[417]}},{"images",nameImage},{{"number",500}},{{"function","true"}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",2}},{{"number",0}},{{"number",20}},{{"number",0}},{{"number",5}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"text","#FFFFFF"}},{{"text","#000000"}},{{"text","#000000"}},{{"text","#000000"}},{"GL","GL_SRC_ALPHA"},{"GL","GL_ONE"} }},
			{"createLinearParticle",{{{"text",words[417]}},{"images",nameImage},{{"number",500}},{{"function","true"}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",2}},{{"number",0}},{{"number",20}},{{"number",0}},{{"number",5}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"text","#FFFFFF"}},{{"text","#000000"}},{{"text","#000000"}},{{"text","#000000"}},{"GL","GL_SRC_ALPHA"},{"GL","GL_ONE"} }},
		},
		["pen"]={
			{"lowerPen"},
			{"raisePen"},
			{"setSizePen",{{{"number",3.15}}}},
			{"setColorPen",{{{"number",0}},{{"number",0}},{{"number",255}}}},
			{"stamp"},
			{"clearPen"},
		},
		["data"]= {
			{"setVariable", {{localityVariable, nameVariable}, {{"number",0}}}},
			{"editVariable", {{localityVariable, nameVariable}, {{"number",1}}}},
			{"showVariable", {{localityVariable, nameVariable}, {{"number",100}}, {{"number",200}}}},
			{"showVariable2", {{localityVariable, nameVariable},{{"number",100}}, {{"number",200}},{{"number",120}},{{"text","#FF0000"}},{"alignText","center"}}},
			{"setAnchorVariable", {{localityVariable, nameVariable},{{"number", 0}}, {{"number",100}}}},
			{"hideVariable",{{localityVariable, nameVariable}}},
			{"insertVariableCamera", {{localityVariable, nameVariable}}},
			{"removeVariableCamera", {{localityVariable, nameVariable}}},
			{"saveVariable",{{localityVariable, nameVariable}}},
			{"readVariable",{{localityVariable, nameVariable}}},
			--{"saveVariableToFile",{{localityVariable, nameVariable}, {{"text",words[218]..".txt"}}}},
			--{"readVariableToFile",{{localityVariable, nameVariable}, {{"text",words[218]..".txt"}}, {"isDeleteFile","save"} }},
			{"addElementArray",{{{"number",1}},{localityArray, nameArray}}},
			{"deleteElementArray",{{localityArray, nameArray}, {{"number",1}} }},
			{"deleteAllElementsArray",{{localityArray, nameArray}}},
			{"pasteElementArray", {{{"number",1}},{localityArray, nameAreay}, {{"number",1}}}},
			{"replaceElementArray",{{localityArray, nameArray}, {{"number",1}},{{"number",1}}}},
			{"saveArray",{{localityArray, nameArray}}},
			{"readArray",{{localityArray, nameArray}}},
			{"columnStorageToArray",{{{"number",1}},{{"text",words[238]}},{localityArray, nameArray}}},
			{"getRequest",{{{"text","https://catrob.at/joke"}}, {localityVariable, nameVariable}}},
			{"toFrontLayerVar",{ {localityVariable, nameVariable} }},
			{"toBackLayerVar",{ {localityVariable, nameVariable} }},
		},
		["device"]={
			--{"resetTimer"},
			{"openLink",{{{"text","https://catrobat.org/"}}}},
			{"blockTouch"},
			{"blockTouchScreen"},
			--{"touchAndSwipe",{{{"function","-"},{"number",1},{"number",0},{"number",0}},{{"function","-"},{"number",2},{"number",0},{"number",0}},{{"number",1},{"number",0},{"number",0}},{{"number",2},{"number",0},{"number",0}}, {{"number",0},{"number","."},{"number",3}}}},
			{"showToast", {{{"text", words[164]}}}},
			{"lua", {{{"text", "native.showAlert(\""..words[388].."\", \""..words[389].."\", {\"OK\"})"}}}},
			{"setHorizontalOrientation"},
			{"setVerticalOrientation"},
			{"removeAdaptiveSizeDevice"},
		},
	}
	local blocksCategory = allBlocksCategories[category]
	if (blocksCategory~=nil) then
		local yTargetPos = 0
		for i=1, #blocksCategory do
			local block = createBlock(blocksCategory[i])
			block.infoBlock = json.decode(json.encode(blocksCategory[i]))
			yTargetPos = yTargetPos+block.height
			block.y = yTargetPos-block.height/2
			groupSceneScroll:insert(block)
			block:addEventListener("touch", function (event)
				if (event.phase=="began") then
					display.getCurrentStage():setFocus(event.target, event.id)
				elseif (event.phase=="moved" and (math.abs(event.y-event.yStart)>20 or math.abs(event.x-event.xStart)>20)) then
					scrollProjects:takeFocus(event)
				elseif (event.phase~="moved") then
					display.getCurrentStage():setFocus(event.target, nil)
					local infoBlock = event.target.infoBlock
					display.remove(SCENES[SCENE][1])
					display.remove(SCENES[SCENE][2])
					SCENE = "scripts"
					SCENES[SCENE][1].alpha = 1
					SCENES[SCENE][1].x = 0
					funBack = oldBackScripts
					oldBackScripts = nil
					funAddBlock(infoBlock)
				end
				return(true)
			end)

		end
	end
	scrollProjects:setScrollHeight(groupSceneScroll.height+display.contentWidth/2)
end