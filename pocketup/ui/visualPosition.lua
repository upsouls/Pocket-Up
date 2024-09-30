function scene_setPosVisual(objectsParameter, idBlock, idParameter, blocks)
	local oldSceneBack = funBack

	SCENES["scripts"][1].alpha = 0
	local groupScene = display.newGroup()
	SCENE = "formula_editor"
	SCENES[SCENE] = {groupScene}
	local funBackObjects = {}
	local isBackScene = "back"
	local topBarArray = topBar(groupScene, words[272], nil, nil, funBackObjects)
	topBarArray[1].alpha = 0.3
	topBarArray[4].fill = {
		type="image",
		filename="images/check.png"
	}
	topBarArray[3].alpha = 0.75
	local block = blocks[idBlock]
	--local formulas = blocks[idBlock][2][idParameter]

	local background = display.newImage(groupScene, IDSCENE.."/icon.png", system.DocumentsDirectory, CENTER_X, CENTER_Y)
	if (background~=nil) then
		background.width, background.height = display.contentWidth, display.contentHeight
		background:toBack()
		background.fill.effect = "filter.brightness"
		background.fill.effect.intensity = -0.25
	end

	funBackObjects[1] = function()
	end
end