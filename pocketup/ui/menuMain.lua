local function decodeString(encoded)
    local decoded = ""
    for _, v in ipairs(encoded) do
        decoded = decoded .. string.char(v)
    end
    return decoded
end

function scene_menu()
    local groupScene = display.newGroup()
    local topBarArray = topBar(groupScene, 'Pocket Up', nil, nil, nil)
    topBarArray[2].fill = {
        type='image',
        filename='sprites/icon.png'
    }
    app.scene = "menu"
    print()
    app.scenes[app.scene] = {groupScene}
    local scrollItems = plugins.widget.newScrollView({
        width=display.contentWidth,
		height=display.contentHeight-topBarArray[1].height,
		horizontalScrollDisabled=true,
		isBounceEnabled=false,
		hideBackground=true,
    })
    scrollItems.y = CENTER_Y+topBarArray[1].height/2
    local texts = {
        {text = app.words[659], icon='images/continue.png'},
        {text = app.words[661], icon='images/programs.png'},
        {text = app.words[660], icon='images/teleg.png'},
        {text = app.words[662], icon='images/tutorials.png'},
        {text = app.words[663], icon='images/setting.png'},
    }
    local rpn = funsP["получить сохранение"]("lastProject")
    local recentProjectName = ''
    local recentProjectId = '0'
    if rpn ~= '[]' then
        local t = require 'json'.decode(rpn)
        recentProjectName = t['name']
        recentProjectId = t['id']
    end
   

    local y = 310/2+10
    for i = 1, #texts do
        if i < 2 then
            local a = display.newImageRect('images/menubutton.jpg', display.actualContentWidth, 310)
            scrollItems:insert(a)
            a.y = y
            a.x = CENTER_X 
            local icon = display.newImageRect(texts[i].icon, 128, 128)
            local arrow = display.newImage('images/arrow.png')
            local textShadow = display.newText(texts[i].text, 0, 0, nil, 35)
            local text = display.newText(texts[i].text, 0, 0, nil, 35)
            local textRecentProjectShadow = display.newText(recentProjectName, 0, 0, nil, 30)
            local textRecentProject = display.newText(recentProjectName, 0, 0, nil, 30)
            icon.y = y
            icon.x = display.screenOriginX+icon.width/2+15
            textRecentProjectShadow:setFillColor(0)

            scrollItems:insert(textRecentProjectShadow)
            scrollItems:insert(textRecentProject)
            scrollItems:insert(icon)

            text.x = display.screenOriginX+(text.width/2)+158
            textRecentProject.x = display.screenOriginX+(textRecentProject.width/2)+158
            textRecentProject.y = y+15
            textRecentProjectShadow.x = textRecentProject.x
            textRecentProjectShadow.y = textRecentProject.y+2
            textRecentProjectShadow.alpha = 0.4
            text:setFillColor(181/255, 234/255, 248/255)
            textShadow:setFillColor(0)
            text.y = y-15
            textShadow.x = text.x
            textShadow.y = text.y+2
            textShadow.alpha = 0.4
            scrollItems:insert(textShadow)
            scrollItems:insert(text)
            
            arrow.width = arrow.width/4
            arrow.height = arrow.height/4
            scrollItems:insert(arrow)
            arrow.x = display.actualContentWidth-arrow.width
            arrow.y = y
            y = y + a.height-40
            a:addEventListener('touch', function (event)
                if event.phase == 'began' then
                    event.target.alpha = 0.5
                    display.getCurrentStage():setFocus(event.target, event.id)
                    arrow.alpha = 0.5
                elseif event.phase == 'moved' then
                    local dy = math.abs( ( event.y - event.yStart ) )
                    -- If the touch on the button has moved more than 10 pixels,
                    -- pass focus back to the scroll view so it can continue scrolling
                    if ( dy > 10 ) then
                        scrollItems:takeFocus( event )
                        event.target.alpha = 1
                        arrow.alpha = 1
                    end
                elseif event.phase == 'ended' then
                    event.target.alpha = 1
                    arrow.alpha = 1
                    display.getCurrentStage():setFocus(event.target, nil)
                   
                    if recentProjectName ~= '' then
                        isBackScene='back'
                        display.remove(app.scenes[app.scene][1])
                        local scenesToProject = plugins.json.decode(funsP["получить сохранение"](recentProjectId.."/scenes"))
                        app.idProject = recentProjectId
                        app.nmProject = recentProjectName
                        scene_objects(recentProjectId.."/scene_"..scenesToProject[1][2].."/objects", recentProjectName, scenesToProject[1])
                    else
                        funsP["вызвать уведомление"](app.words[664])
                    end
                    
                end
                return 1
            end)
        else
            local a = display.newImageRect('images/menubutton.jpg', display.actualContentWidth, 220)
            scrollItems:insert(a)
            a.y = y
            a.x = CENTER_X
            local icon = display.newImageRect(texts[i].icon, 128, 128)
            
            local textShadow = display.newText(texts[i].text, 0, 0, nil, 35)
            
            local text = display.newText(texts[i].text, 0, 0, nil, 35)
            textShadow.x = text.x
            textShadow.y = y-17
            textShadow:setFillColor(0)
            text.x = display.screenOriginX+(text.width/2)+158
            text.y = y
            icon.y = y
            icon.x = display.screenOriginX+icon.width/2+15
            textShadow.x = text.x
            textShadow.y = y+2
            textShadow.alpha = 0.4
            text:setFillColor(181/255, 234/255, 248/255)
            scrollItems:insert(textShadow)
            scrollItems:insert(text)
            scrollItems:insert(icon)
            a.i = i
            
            local arrow = display.newImage('images/arrow.png')
            arrow.width = arrow.width/4
            arrow.height = arrow.height/4
            scrollItems:insert(arrow)
            arrow.x = display.actualContentWidth-arrow.width
            arrow.y = y
            a:addEventListener('touch', function (event)
                if event.phase == 'began' then
                    event.target.alpha = 0.5
                    display.getCurrentStage():setFocus(event.target, event.id)
                    arrow.alpha = 0.5
                elseif event.phase == 'moved' then
                    local dy = math.abs( ( event.y - event.yStart ) )
                    -- If the touch on the button has moved more than 10 pixels,
                    -- pass focus back to the scroll view so it can continue scrolling
                    if ( dy > 10 ) then
                        scrollItems:takeFocus( event )
                        event.target.alpha = 1
                        arrow.alpha = 1
                    end
                elseif event.phase == 'ended' then
                    event.target.alpha = 1
                    display.getCurrentStage():setFocus(event.target, nil)
                    arrow.alpha = 1
                    if event.target.i == 3 then
                        local link = {104, 116, 116, 112, 115, 58, 47, 47, 116, 46, 109, 101, 47, 112, 111, 99, 107, 101, 116, 95, 117, 112, 95, 99, 104, 97, 116}
                        system.openURL(decodeString(link))
                    elseif event.target.i == 2 then
                        isBackScene='back'
                        display.remove(app.scenes[app.scene][1])
                        scene_projects()
                    elseif event.target.i == 4 then
                        local link = {104, 116, 116, 112, 115, 58, 47, 47, 119, 119, 119, 46, 121, 111, 117, 116, 117, 98, 101, 46, 99, 111, 109, 47, 104, 97, 115, 104, 116, 97, 103, 47, 112, 111, 99, 107, 101, 116, 117, 112}
                        system.openURL(decodeString(link))
                    end
                end
                return 1
            end)
            y = y + a.height+5
        end 
    end
    groupScene:insert(scrollItems)
end