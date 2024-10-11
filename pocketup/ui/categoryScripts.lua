-- сцена с конкретной категорией блоков

local getCategoriesBlocks = require("pocketup.gameAndBlocks.blocks.categoriesBlocks")
oldBackScripts = nil
function scene_categoryScripts(category, nameCategory, funAddBlock)

	if (oldBackScripts==nil) then
		oldBackScripts=funBack
	end

	local namesFunctions = plugins.json.decode(funsP["получить сохранение"](app.idScene.."/functions"))
	local nameFunction = nil
	if (#namesFunctions>0) then
		nameFunction = namesFunctions[#namesFunctions][1]
	else
		namesFunctions[1] = {1, app.words[79], 0}
		funsP["записать сохранение"](app.idScene.."/functions", plugins.json.encode(namesFunctions))
		nameFunction = 1
	end
	local idBackgroundObject = plugins.json.decode(funsP["получить сохранение"](app.idScene.."/objects"))[1][2]
	local namesBackgrounds = plugins.json.decode(funsP["получить сохранение"](app.idScene.."/object_"..idBackgroundObject.."/images"))
	local nameBackground = #namesBackgrounds>0 and namesBackgrounds[1][2] or nil
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
	local namesScenes = plugins.json.decode(funsP["получить сохранение"](app.idProject.."/scenes"))
	local nameScene = nil
	if (#namesScenes>1) then
		if (app.idScene~=app.idProject.."/scene_"..namesScenes[1][2]) then
			nameScene = namesScenes[1][2]
		else
			nameScene = namesScenes[2][2]
		end
	end
	local namesSounds = plugins.json.decode(funsP["получить сохранение"](app.idObject.."/sounds"))
	local nameSound = #namesSounds>0 and namesSounds[1][2] or nil
	local namesImages = plugins.json.decode(funsP["получить сохранение"](app.idObject.."/images"))
	local nameImage = #namesImages>0 and namesImages[1][2] or nil



	local groupScene = display.newGroup()
	local groupSceneScroll = display.newGroup()

	app.scene = "categoryScripts"
	app.scenes[app.scene] = {groupScene, groupSceneScroll}
	local touchBackMenu = {function ()
		display.remove(groupScene)
		display.remove(groupSceneScroll)
		scene_categoriesScripts(funAddBlock)
	end}
	local topBarArray = topBar(groupScene, nameCategory, nil, nil, touchBackMenu)
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

	local allBlocksCategories = getCategoriesBlocks(localityVariable, nameVariable, localityArray, nameArray, nameFunction, nameBackground, nameScene, nameSound, nameImage)
	local blocksCategory = allBlocksCategories[category]
	if (blocksCategory~=nil) then
		local yTargetPos = 0
		for i=1, #blocksCategory do
			local block = createBlock(blocksCategory[i])
			block.infoBlock = plugins.json.decode(plugins.json.encode(blocksCategory[i]))
			yTargetPos = yTargetPos+block.height
			block.y = yTargetPos-block.height/2
			groupSceneScroll:insert(block)
			block:addEventListener("touch", function (event)
				local function isPrem()
					local isPrem = not (funsP["прочитать сс сохранение"]("isPremium")==nil)
					if (funsP["прочитать сс сохранение"]("blockPrem")~=nil) then
						return(false)
					else
						return(isPrem)
					end
				end
				if (event.phase=="began") then
					display.getCurrentStage():setFocus(event.target, event.id)
				elseif (event.phase=="moved" and (math.abs(event.y-event.yStart)>20 or math.abs(event.x-event.xStart)>20)) then
					scrollProjects:takeFocus(event)
				elseif (event.phase~="moved") then
					local infoBlock = event.target.infoBlock
					display.getCurrentStage():setFocus(event.target, nil)
					if ((premBlocks[infoBlock[1]]==nil or isPrem())) then
						display.remove(app.scenes[app.scene][1])
						display.remove(app.scenes[app.scene][2])
						app.scene = "scripts"
						app.scenes[app.scene][1].alpha = 1
						app.scenes[app.scene][1].x = 0
						funBack = oldBackScripts
						oldBackScripts = nil
						funAddBlock(infoBlock)
					else
						bannerPremium(groupScene)
					end
				end
				return(true)
			end)

		end
	end
	scrollProjects:setScrollHeight(groupSceneScroll.height+display.contentWidth/2)
end