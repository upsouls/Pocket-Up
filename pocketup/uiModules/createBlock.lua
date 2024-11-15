-- создание блока как объекта

--[[ отправляемые данные
block - plugins.json таблина с информацией о блоке. пример: {"setPosition", { {{"number", 100}}, {{"number", 200}} }}
]]

--[[ получаемые данные
возвращается группа. допустим, oна называется group;
group.image1 - объект-изображение;
group.image2 - вторая часть объекта-изображения блока;
group.cells - список всех параметров блока;
group.cells[i] - массив, содержащий в себе тип параметра и все объекты(кнопки, тексты и т. д.) от этого параметра;
]]

function createBlock(block)
	local infoBlock = allBlocks[block[1]]
	if (allBlocks[block[1]]==nil) then
		infoBlock = {"block", "blocks/block_light_1.png", { {{"text", app.words[612]}} }, 109, 88, false}
	end
	local group = display.newGroup()
	group.x, group.y = CENTER_X, CENTER_Y
	local image = display.newImage(infoBlock[2])
	image.xScale = display.contentWidth/image.width/1.75/(infoBlock[1]=="event" and 1 or 412/109)
	image.yScale = image.xScale*1.4
	image.x = -CENTER_X
	image.anchorX = 0
	group:insert(image)


	local sheetOptions = {
		width=1,
		height=infoBlock[5],
		numFrames=infoBlock[4],
	}
	local imageSheet = graphics.newImageSheet(infoBlock[2], sheetOptions)
	local animates = {{
		name="stand",
		start=infoBlock[4],
		count=1,
		time=0,
		loopCount=1,
	}}

	local sprite = display.newSprite(imageSheet, animates)
	sprite.width = display.contentWidth-image.width*image.xScale
	sprite.x = image.x+(image.width-1)*image.xScale
	sprite.yScale, sprite.anchorX, sprite.height = image.yScale, 0, image.height
	group:insert(sprite)
	local formulas = infoBlock[3]
	local xF = -display.contentCenterX/1.5
	local yF = 0
	local countCells = 0
	group.image1 = image
	group.image2 = sprite
	group.cells = {}
	local group2 = display.newGroup()
	group:insert(group2)

	if (infoBlock[2]:gsub("yellow", "")~= infoBlock[2]) then
		sprite:setFillColor(0.85,0.85,0.75)
		image:setFillColor(0.85,0.85,0.75)
	end

	if (block[1]:gsub("paidBlock_", "") ~= block[1]) then
		local rect = display.newRoundedRect(-display.contentWidth/2.4, -sprite.height/2+display.contentWidth/17, 0, display.contentWidth/16, display.contentWidth/32)
		group:insert(rect)
		rect:setFillColor(0.25,0.75,0.4)
		rect.strokeWidth = 2
		rect:setStrokeColor(0.2, 0.6, 0.3)
		local text = display.newText("50₽", rect.x, rect.y, fontSize1)
		group:insert(text)
		rect.width = text.width+rect.height
	end

	for i=1, #formulas do
		for i2=1, #formulas[i] do
			local formula = plugins.json.decode(plugins.json.encode(formulas[i][i2]))

			if (formula[1]~="text") then
				countCells = countCells+1
				formula[2] = block[2][countCells]
			end

			if (formula[1]=="text") then
				local header = display.newText(formula[2], xF, yF, "fonts/font_1.ttf", app.fontSizeBlock)
				if (infoBlock[2]:gsub("light_", "")~=infoBlock[2]) then
					header:setFillColor(0, 0, 0)
				end
				header.anchorX=0
				group2:insert(header)
				xF = header.x+header.width+display.contentWidth/30
			elseif (formula[1]=="cell") then
				local button = display.newImage("images/notVisible.png")
				button.width, button.height = display.contentWidth/10*formula[3], display.contentWidth/15
				button.anchorX, button.x, button.y = 0, xF, yF
				button.alpha = 0.5
				group2:insert(button)
				local line = display.newRect(button.x+button.width/2, button.y+button.height/2, button.width, display.contentWidth/300)
				line.anchorY=0
				group2:insert(line)
				local valueCell = display.newText({
					text = loadFormula(formula[2]),
					x = button.x+button.width/2,
					y=button.y,
					width=button.width,
					height=button.height,
					align="center",
					font=nil,
					fontSize=app.fontSize1,
				})
				group2:insert(valueCell)
				group.cells[#group.cells+1] = {"cell", button, line, valueCell}
				button.idParameter = #group.cells
				button.block = group
				button.typeParameter = "cell"
				xF = button.x+button.width+display.contentWidth/30
			elseif (formula[1]=="function" or formula[1]=="objects" or formula[1]=="backgrounds" or formula[1]=="variables" or formula[1]=="arrays" or formula[1]=="scenes" or formula[1]=="scripts" or formula[1]=="goTo" or formula[1]=="typeRotate" or formula[1]=="sounds" or formula[1]=="images" or formula[1]=="effectParticle" or formula[1]=="onOrOff" or formula[1]=="alignText" or formula[1]=="isDeleteFile" or formula[1]=="typeBody" or formula[1]=="GL" or formula[1]=="inputType") then
				yF = yF-display.contentWidth/40
				local button = display.newImage("images/notVisible.png")
				button.x, button.y, button.width, button.height = -display.screenOriginX+display.contentWidth/25, yF, display.contentWidth/2.625*2, display.contentWidth/15
				group2:insert(button)
				local triangle = display.newText("◢", button.x+button.width/2, button.y, nil, app.fontSize2)
				triangle.rotation = 45
				group2:insert(triangle)

				local nameFunction = ""
				if (formula[1]=="function") then
					local namesFunctions = plugins.json.decode(funsP["получить сохранение"](app.idScene.."/functions"))
					for i=1, #namesFunctions do
						if (namesFunctions[i][1]==formula[2][2]) then
							nameFunction = namesFunctions[i][2]
							break
						end
					end
				elseif (formula[1]=="objects") then
					nameFunction = app.words[(block[1]=="collision" or block[1]=="endedCollision") and 85 or (block[1]=="clone" or block[1]~=block[1]:gsub("broadcastFun>","")) and 90 or 87]
					local namesObjects = plugins.json.decode(funsP["получить сохранение"](app.idScene.."/objects"))
					for i=1, #namesObjects do
						if (namesObjects[i][2]==formula[2][2]) then
							nameFunction = namesObjects[i][1]
							break
						end
					end
					if (nameFunction==nil) then
						nameFunction = app.words[85]
					end
				elseif (formula[1]=="backgrounds") then
					nameFunction = app.words[87]
					local idBackgroundObject = plugins.json.decode(funsP["получить сохранение"](app.idScene.."/objects"))[1][2]
					local namesBackgrounds = plugins.json.decode(funsP["получить сохранение"](app.idScene.."/object_"..idBackgroundObject.."/images"))
					for i=1, #namesBackgrounds do
						if (namesBackgrounds[i][2]==formula[2][2]) then
							nameFunction = namesBackgrounds[i][1]
							break
						end
					end
				elseif (formula[1]=="variables") then
					nameFunction = app.words[87]
					local namesVariables = nil
					if (formula[2][1]=="globalVariable") then 
						namesVariables = plugins.json.decode(funsP["получить сохранение"](app.idProject.."/variables"))
					else
						namesVariables = plugins.json.decode(funsP["получить сохранение"](app.idObject.."/variables"))
					end
					for i=1, #namesVariables do
						if (namesVariables[i][1]==formula[2][2]) then
							nameFunction = namesVariables[i][2]
						end
					end
				elseif (formula[1]=="arrays") then
					nameFunction = app.words[87]
					local namesArrays = nil
					if (formula[2][1]=="globalArray") then 
						namesArrays = plugins.json.decode(funsP["получить сохранение"](app.idProject.."/arrays"))
					else
						namesArrays = plugins.json.decode(funsP["получить сохранение"](app.idObject.."/arrays"))
					end
					for i=1, #namesArrays do
						if (namesArrays[i][1]==formula[2][2]) then
							nameFunction = namesArrays[i][2]
						end
					end
				elseif (formula[1]=="scenes") then
					nameFunction = app.words[87]
					local namesScenes = plugins.json.decode(funsP["получить сохранение"](app.idProject.."/scenes"))
					for i=1, #namesScenes do
						if (namesScenes[i][2]==formula[2][2]) then
							nameFunction = namesScenes[i][1]
							break
						end
					end
				elseif (formula[1]=="scripts") then
					local namesScripts = {["thisScript"]=app.words[114], ["allScripts"]=app.words[115], ["otherScripts"]=app.words[116]}
					nameFunction = namesScripts[formula[2][2]]
				elseif (formula[1]=="goTo") then
					if (formula[2][2]=="touch") then
						nameFunction = app.words[123]
					elseif (formula[2][2]=="random") then
						nameFunction = app.words[124]
					else
						nameFunction = app.words[123]
						local namesObjects = plugins.json.decode(funsP["получить сохранение"](app.idScene.."/objects"))
						for i=1, #namesObjects do
							if (namesObjects[i][2]==formula[2][2]) then
								nameFunction = namesObjects[i][1]
								break
							end
						end
					end
				elseif (formula[1]=="typeRotate") then
					local typesRotates = {
						["leftToRight"] = app.words[133],
						["true"] = app.words[134],
						["false"] = app.words[135]
					}
					nameFunction = typesRotates[formula[2][2]]
				elseif (formula[1]=="sounds") then
					nameFunction = app.words[87]
					local namesSounds = plugins.json.decode(funsP["получить сохранение"](app.idObject.."/sounds"))
					for i=1, #namesSounds do
						if (formula[2][2]==namesSounds[i][2]) then
							nameFunction = namesSounds[i][1]
							break
						end
					end
				elseif (formula[1]=="images") then
					nameFunction = app.words[87]
					local namesImages = plugins.json.decode(funsP["получить сохранение"](app.idObject.."/images"))
					for i=1, #namesImages do
						if (namesImages[i][2]==formula[2][2]) then
							nameFunction = namesImages[i][1]
							break
						end
					end
				elseif (formula[1]=="effectParticle") then
					local typesParticles = {
						["in"]=app.words[178],
						["out"]=app.words[179],
					}
					nameFunction = typesParticles[formula[2][2]]
				elseif (formula[1]=="onOrOff") then
					nameFunction = formula[2][2]=="on" and app.words[183] or app.words[184]
				elseif (formula[1]=="alignText") then
					local alignsText = {
						["center"]=app.words[210],
						["left"]=app.words[211],
						["right"]=app.words[212],
					}
					nameFunction = alignsText[formula[2][2]]
				elseif (formula[1]=="isDeleteFile") then
					nameFunction = formula[2][2]=="save" and app.words[222] or app.words[223]
				elseif (formula[1]=="typeBody") then
					local typesParticles = {
						["dynamic"]=app.words[393],
						["static"]=app.words[394],
						["noPhysic"]=app.words[395],
					}
					nameFunction = typesParticles[formula[2][2]]
				elseif (formula[1]=="GL") then
					nameFunction = formula[2][2]
				elseif (formula[1]=="inputType") then
					local types = {
						["default"] = app.words[498],
						["number"] = app.words[499],
						["decimal"] = app.words[500],
						["phone"] = app.words[501],
						["url"] = app.words[502],
						["email"] = app.words[503],
						["no-emoji"] = app.words[504],
					}
					nameFunction = types[formula[2][2]]
				end

				local header = display.newText(nameFunction, button.x-button.width/2, yF, nil, app.fontSize1)
				header.anchorX=0
				group2:insert(header)
				group.cells[#group.cells+1] = {"function", button, header, triangle}
				button.idParameter = #group.cells
				button.typeParameter = formula[1]
				button.block = group
				yF = yF-display.contentWidth/40
			elseif (formula[1]=="shapeHitbox") then
				local button = display.newImage("images/notVisible.png")
				button.x, button.y, button.width, button.height = -display.screenOriginX+display.contentWidth/25, yF, display.contentWidth/2.625*2, display.contentWidth/15
				group2:insert(button)
				local line = display.newRect(button.x, button.y+button.height/2, button.width, display.contentWidth/300)
				line.anchorY=0
				group2:insert(line)
				local valueCell = display.newText({
					text = formula[2][2],
					x = button.x,
					y=button.y,
					width=button.width,
					height=button.height,
					align="left",
					font=nil,
					fontSize=app.fontSize1,
				})
				group2:insert(valueCell)
				group.cells[#group.cells+1] = {"shapeHitbox", button, line, valueCell}
				button.idParameter = #group.cells
				button.block = group
				button.typeParameter = "shapeHitbox"
				yF = yF-display.contentWidth/40
			end -- elseif
		end
		yF = yF + display.contentWidth/10
		xF = -display.contentCenterX/1.5
	end
	group2.y = -group2.height/2+(infoBlock[1]=="event" and display.contentWidth/10 or display.contentWidth/40)
	for i=1, #group.cells do
		group.cells[i][2].heightParameters = group2.height
	end
	return(group)
end