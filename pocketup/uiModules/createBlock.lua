-- создание блока как объекта

--[[ отправляемые данные
block - json таблина с информацией о блоке. пример: {"setPosition", { {{"number", 100}}, {{"number", 200}} }}
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
	for i=1, #formulas do
		for i2=1, #formulas[i] do
			local formula = json.decode(json.encode(formulas[i][i2]))

			if (formula[1]~="text") then
				countCells = countCells+1
				formula[2] = block[2][countCells]
			end

			if (formula[1]=="text") then
				local header = display.newText(formula[2], xF, yF, "fonts/font_1.ttf", fontSize1)
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
					fontSize=fontSize1,
				})
				group2:insert(valueCell)
				group.cells[#group.cells+1] = {"cell", button, line, valueCell}
				button.idParameter = #group.cells
				button.block = group
				button.typeParameter = "cell"
				xF = button.x+button.width+display.contentWidth/30
			elseif (formula[1]=="function" or formula[1]=="objects" or formula[1]=="backgrounds" or formula[1]=="variables" or formula[1]=="arrays" or formula[1]=="scenes" or formula[1]=="scripts" or formula[1]=="goTo" or formula[1]=="typeRotate" or formula[1]=="sounds" or formula[1]=="images" or formula[1]=="effectParticle" or formula[1]=="onOrOff" or formula[1]=="alignText" or formula[1]=="isDeleteFile" or formula[1]=="typeBody" or formula[1]=="GL") then
				yF = yF-display.contentWidth/40
				local button = display.newImage("images/notVisible.png")
				button.x, button.y, button.width, button.height = -display.screenOriginX+display.contentWidth/25, yF, display.contentWidth/2.625*2, display.contentWidth/15
				group2:insert(button)
				local triangle = display.newText("◢", button.x+button.width/2, button.y, nil, fontSize2)
				triangle.rotation = 45
				group2:insert(triangle)

				local nameFunction = ""
				if (formula[1]=="function") then
					local namesFunctions = json.decode(funsP["получить сохранение"](IDSCENE.."/functions"))
					for i=1, #namesFunctions do
						if (namesFunctions[i][1]==formula[2][2]) then
							nameFunction = namesFunctions[i][2]
							break
						end
					end
				elseif (formula[1]=="objects") then
					nameFunction = words[(block[1]=="collision" or block[1]=="endedCollision") and 85 or (block[1]=="clone" or block[1]~=block[1]:gsub("broadcastFun>","")) and 90 or 87]
					local namesObjects = json.decode(funsP["получить сохранение"](IDSCENE.."/objects"))
					for i=1, #namesObjects do
						if (namesObjects[i][2]==formula[2][2]) then
							nameFunction = namesObjects[i][1]
							break
						end
					end
					if (nameFunction==nil) then
						nameFunction = words[85]
					end
				elseif (formula[1]=="backgrounds") then
					nameFunction = words[87]
					local idBackgroundObject = json.decode(funsP["получить сохранение"](IDSCENE.."/objects"))[1][2]
					local namesBackgrounds = json.decode(funsP["получить сохранение"](IDSCENE.."/object_"..idBackgroundObject.."/images"))
					for i=1, #namesBackgrounds do
						if (namesBackgrounds[i][2]==formula[2][2]) then
							nameFunction = namesBackgrounds[i][1]
							break
						end
					end
				elseif (formula[1]=="variables") then
					nameFunction = words[87]
					local namesVariables = nil
					if (formula[2][1]=="globalVariable") then 
						namesVariables = json.decode(funsP["получить сохранение"](IDPROJECT.."/variables"))
					else
						namesVariables = json.decode(funsP["получить сохранение"](IDOBJECT.."/variables"))
					end
					for i=1, #namesVariables do
						if (namesVariables[i][1]==formula[2][2]) then
							nameFunction = namesVariables[i][2]
						end
					end
				elseif (formula[1]=="arrays") then
					nameFunction = words[87]
					local namesArrays = nil
					if (formula[2][1]=="globalArray") then 
						namesArrays = json.decode(funsP["получить сохранение"](IDPROJECT.."/arrays"))
					else
						namesArrays = json.decode(funsP["получить сохранение"](IDOBJECT.."/arrays"))
					end
					for i=1, #namesArrays do
						if (namesArrays[i][1]==formula[2][2]) then
							nameFunction = namesArrays[i][2]
						end
					end
				elseif (formula[1]=="scenes") then
					nameFunction = words[87]
					local namesScenes = json.decode(funsP["получить сохранение"](IDPROJECT.."/scenes"))
					for i=1, #namesScenes do
						if (namesScenes[i][2]==formula[2][2]) then
							nameFunction = namesScenes[i][1]
							break
						end
					end
				elseif (formula[1]=="scripts") then
					local namesScripts = {["thisScript"]=words[114], ["allScripts"]=words[115], ["otherScripts"]=words[116]}
					nameFunction = namesScripts[formula[2][2]]
				elseif (formula[1]=="goTo") then
					if (formula[2][2]=="touch") then
						nameFunction = words[123]
					elseif (formula[2][2]=="random") then
						nameFunction = words[124]
					else
						nameFunction = words[123]
						local namesObjects = json.decode(funsP["получить сохранение"](IDSCENE.."/objects"))
						for i=1, #namesObjects do
							if (namesObjects[i][2]==formula[2][2]) then
								nameFunction = namesObjects[i][1]
								break
							end
						end
					end
				elseif (formula[1]=="typeRotate") then
					local typesRotates = {
						["leftToRight"] = words[133],
						["true"] = words[134],
						["false"] = words[135]
					}
					nameFunction = typesRotates[formula[2][2]]
				elseif (formula[1]=="sounds") then
					nameFunction = words[87]
					local namesSounds = json.decode(funsP["получить сохранение"](IDOBJECT.."/sounds"))
					for i=1, #namesSounds do
						if (formula[2][2]==namesSounds[i][2]) then
							nameFunction = namesSounds[i][1]
							break
						end
					end
				elseif (formula[1]=="images") then
					nameFunction = words[87]
					local namesImages = json.decode(funsP["получить сохранение"](IDOBJECT.."/images"))
					for i=1, #namesImages do
						if (namesImages[i][2]==formula[2][2]) then
							nameFunction = namesImages[i][1]
							break
						end
					end
				elseif (formula[1]=="effectParticle") then
					local typesParticles = {
						["in"]=words[178],
						["out"]=words[179],
					}
					nameFunction = typesParticles[formula[2][2]]
				elseif (formula[1]=="onOrOff") then
					nameFunction = formula[2][2]=="on" and words[183] or words[184]
				elseif (formula[1]=="alignText") then
					local alignsText = {
						["center"]=words[210],
						["left"]=words[211],
						["right"]=words[212],
					}
					nameFunction = alignsText[formula[2][2]]
				elseif (formula[1]=="isDeleteFile") then
					nameFunction = formula[2][2]=="save" and words[222] or words[223]
				elseif (formula[1]=="typeBody") then
					local typesParticles = {
						["dynamic"]=words[393],
						["static"]=words[394],
						["noPhysic"]=words[395],
					}
					nameFunction = typesParticles[formula[2][2]]
				elseif (formula[1]=="GL") then
					nameFunction = formula[2][2]
				end

				local header = display.newText(nameFunction, button.x-button.width/2, yF, nil, fontSize1)
				header.anchorX=0
				group2:insert(header)
				group.cells[#group.cells+1] = {"function", button, header, triangle}
				button.idParameter = #group.cells
				button.typeParameter = formula[1]
				button.block = group
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