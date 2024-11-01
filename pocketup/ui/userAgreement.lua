function scene_userAgreement()
	local groupScene = display.newGroup()
	local groupSceneScroll = display.newGroup()
	app.scene = "userAgreement"
	app.scenes[app.scene] = {groupSceneScroll, groupScene}
	local funBackObjects = {}
	local isBackScene = "back"
	local valueHeaderTopBar = app.words[1]
	local topBarArray = topBar(groupScene, 621, nil, nil, funBackObjects)
	topBarArray[4].alpha = 0

	local scrollText = plugins.widget.newScrollView({
		width=display.contentWidth,
		height=display.contentHeight-topBarArray[1].height,
		horizontalScrollDisabled=true,
		isBounceEnabled=false,
		hideBackground=true,
	})
	scrollText.x=CENTER_X
	groupScene:insert(scrollText)
	scrollText.anchorY = 0
	scrollText.y = topBarArray[1].y+topBarArray[1].height
	scrollText:insert(groupSceneScroll)
	utils.select_Scroll = scrollText

	local text = display.newText({
		text=app.words[622],
		width=scrollText.width/1.1,
		align="left",
		fontSize=fontSize1,
		x=CENTER_X,
		y = CENTER_X/10
	})
	groupSceneScroll:insert(text)
	text.anchorY = 0
	scrollText:setScrollHeight(groupSceneScroll.height+display.contentWidth/1.5)

	funBackObjects[1] = function()
		display.remove(groupSceneScroll)
		display.remove(groupScene)
		scene_projects()
	end
end