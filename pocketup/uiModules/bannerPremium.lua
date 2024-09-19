function bannerPremium(groupScene, onComplete)
	if (groupScene~=nil and groupScene.x~=nil) then
		local bannerGroup = display.newGroup()
		groupScene:insert(bannerGroup)
		local backgroundBlackAlpha = display.newImage("images/notVisible.png", CENTER_X, CENTER_Y)
		backgroundBlackAlpha.width, backgroundBlackAlpha.height = display.contentWidth, display.actualContentHeight
		backgroundBlackAlpha:addEventListener("touch", function()
			return(true)
		end)
		bannerGroup:insert(backgroundBlackAlpha)
		local premiumBanner = display.newRoundedRect(CENTER_X, CENTER_Y, display.contentWidth-display.contentWidth/13, display.contentWidth, roundedRect*8)
		premiumBanner:setFillColor({
		    type = "gradient",
		    color1 = { 1, 0, 0.4 },
		    color2 = {1, 172/255, 8/255, 0.75},
		    direction = -50
		})
		premiumBanner.xScale, premiumBanner.yScale, premiumBanner.alpha = 0.1, 0.1, 0
		
		
		local header = display.newText(words[553], premiumBanner.x, premiumBanner.y-premiumBanner.height/2+premiumBanner.height/30, "fonts/font_1.ttf", premiumBanner.height/15)
		header.anchorY = 0
		header.alpha = 0
		local valueDescription = words[557].."\n\n"..words[556]
		local description = display.newText({
			text = valueDescription,
			x=premiumBanner.x,
			y = header.y+header.height,
			width = premiumBanner.width-display.contentWidth/13,
			font="fonts/font_2.ttf",
			fontSize=premiumBanner.height/20
		})
		description.anchorY = 0
		description.alpha = 0

		local buttonConnect = display.newText({
			text = words[558],
			x = premiumBanner.x+premiumBanner.width/2-display.contentWidth/13/1.5,
			y = premiumBanner.y+premiumBanner.height/2-display.contentWidth/13/1.5, 
			font = "fonts/font_1.ttf",
			fontSize = premiumBanner.height/17,
			width = premiumBanner.width/2-display.contentWidth/26,
			align = "center"
		})
		buttonConnect.anchorX, buttonConnect.anchorY = 1, 1
		local buttonRectConnect = display.newRoundedRect(buttonConnect.x-buttonConnect.width/2, buttonConnect.y-buttonConnect.height/2, buttonConnect.width+display.contentWidth/26, buttonConnect.height+display.contentWidth/26, roundedRect*6)

		local buttonCancel = display.newText({
			text = words[559], 
			x = premiumBanner.x-premiumBanner.width/2+display.contentWidth/13/1.5,
			y = premiumBanner.y+premiumBanner.height/2-display.contentWidth/13/1.5,
			font = "fonts/font_1.ttf",
			fontSize = premiumBanner.height/17,
			width = premiumBanner.width/2-display.contentWidth/13*2,
			align = "center"
		})
		buttonCancel.anchorX, buttonCancel.anchorY = 0, 1
		buttonCancel:setFillColor(1,1,1,0.75)
		local buttonRectCancel = display.newImage("images/notVisible.png", buttonCancel.x+buttonCancel.width/2, buttonCancel.y-buttonCancel.height/2)
		buttonRectCancel.width, buttonRectCancel.height = buttonCancel.width+display.contentWidth/26, buttonCancel.height+display.contentWidth/26
		

		buttonCancel.alpha = 0
		buttonConnect.alpha = 0
		buttonRectConnect.alpha = 0

		bannerGroup:insert(buttonRectConnect)
		bannerGroup:insert(premiumBanner)
		bannerGroup:insert(header)
		bannerGroup:insert(description)
		bannerGroup:insert(buttonConnect)
		bannerGroup:insert(buttonRectCancel)
		bannerGroup:insert(buttonCancel)


		transition.to(premiumBanner, {time=250, xScale=1, yScale=1, alpha=1, transition=easing.outBack})
		timer.performWithDelay(150, function()
			transition.to(header, {alpha=1, time=250})
		end)
		timer.performWithDelay(250, function()
			transition.to(description, {alpha=1, time=250})
		end)
		timer.performWithDelay(450, function()
			transition.to(buttonConnect, {alpha=1, time=250})
			transition.to(buttonRectConnect, {alpha=1, time=250})
			transition.to(buttonCancel, {alpha=1, time=250})
		end)

		local function touchButtonCancel(event)
			if (event.phase=="began") then
				display.getCurrentStage():setFocus(event.target, event.id)
				buttonCancel:setFillColor(1,1,1)
				event.target.isTouch = true
			elseif (event.phase=="moved" and (math.abs(event.target.x-event.x)>event.target.width/2 or math.abs(event.target.y-event.y)>event.target.height/2)) then
				display.getCurrentStage():setFocus(event.target, nil)
				buttonCancel:setFillColor(1,1,1, 0.75)
				event.target.isTouch = false
			elseif (event.phase=="ended" and event.target.isTouch) then
				display.getCurrentStage():setFocus(event.target, nil)
				buttonCancel:setFillColor(1,1,1, 0.75)
				event.target.isTouch = false

				buttonRectCancel:removeEventListener("touch", touchButtonCancel)
				transition.to(buttonConnect, {alpha=0, time=250})
				transition.to(buttonRectConnect, {alpha=0, time=250})
				transition.to(buttonCancel, {alpha=0, time=250})
				
				timer.performWithDelay(100, function()
					transition.to(description, {alpha=0, time=250})
				end)
				timer.performWithDelay(150, function()
					transition.to(header, {alpha=0, time=250})
					transition.to(premiumBanner, {time=250, xScale=0.1, yScale=0.1, alpha=0, transition=easing.inBack, onComplete=function()
						display.remove(bannerGroup)
						if (onComplete ~= nil) then
							onComplete()
						end
					end})
				end)
			end
			return(true)
		end
		buttonRectCancel:addEventListener("touch", touchButtonCancel)
		local function decodeString(encoded)
		    local decoded = ""
		    for _, v in ipairs(encoded) do
		        decoded = decoded .. string.char(v)
		    end
		    return decoded
		end
		local function touchButtonConnect(event)
			if (event.phase=="began") then
				display.getCurrentStage():setFocus(event.target, event.id)
				buttonRectConnect.xScale, buttonRectConnect.yScale = 1.05, 1.05
				event.target.isTouch = true
			elseif (event.phase=="moved" and (math.abs(event.target.x-event.x)>event.target.width/2 or math.abs(event.target.y-event.y)>event.target.height/2)) then
				display.getCurrentStage():setFocus(event.target, nil)
				buttonRectConnect.xScale, buttonRectConnect.yScale = 1, 1
				event.target.isTouch = false
			elseif (event.phase=="ended" and event.target.isTouch) then
				display.getCurrentStage():setFocus(event.target, nil)
				buttonRectConnect.xScale, buttonRectConnect.yScale = 1, 1
				event.target.isTouch = false

				--buttonRectCancel:removeEventListener("touch", touchButtonConnect)
				buttonCancel.alpha = 0
				buttonRectCancel.alpha = 0
				buttonConnect.alpha = 0
				buttonRectConnect.alpha = 0
				description.text = words[561]

				local link = {104, 116, 116, 112, 58, 47, 47, 120, 57, 53, 51, 50, 56, 105, 107, 46, 98, 101, 103, 101, 116, 46, 116, 101, 99, 104, 47, 112, 111, 99, 107, 101, 116, 117, 112, 47, 112, 114, 101, 109, 105, 117, 109, 47, 105, 115, 80, 114, 101, 109, 105, 117, 109, 46, 112, 104, 112, 63, 105, 100, 61}
				print(decodeString(link)..system.getInfo("deviceID"))
				local function networkListener(event)
					if (event.isError) then
						if (event.response=="Unknown error") then
							description.text = words[565]
						else
							description.text = words[564].." ("..event.response..")"
						end
					else
						if (event.response=="false") then
							description.text = words[563]
						else
							description.text = words[562]
						end
					end
				end
				local headerg = {headers={["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36"}}
		        network.request(decodeString(link)..system.getInfo("deviceID"),'GET',networkListener, headerg)
				-- transition.to(buttonConnect, {alpha=0, time=250})
				-- transition.to(buttonRectConnect, {alpha=0, time=250})
				-- transition.to(buttonCancel, {alpha=0, time=250})
				
				-- timer.performWithDelay(100, function()
				-- 	transition.to(description, {alpha=0, time=250})
				-- end)
				-- timer.performWithDelay(150, function()
				-- 	transition.to(header, {alpha=0, time=250})
				-- 	transition.to(premiumBanner, {time=250, xScale=0.1, yScale=0.1, alpha=0, transition=easing.inBack, onComplete=function()
				-- 		display.remove(bannerGroup)
				-- 		if (onComplete ~= nil) then
				-- 			onComplete()
				-- 		end
				-- 	end})
				-- end)
			end
			return(true)
		end
		buttonRectConnect:addEventListener("touch", touchButtonConnect)
	end
end