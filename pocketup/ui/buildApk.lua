function scene_optionsApk(idProject, nameProject)
    local optionsProject = plugins.json.decode(funsP["получить сохранение"](idProject.."/options"))
    local groupScene = display.newGroup()
    local groupSceneScroll = display.newGroup()
    app.scene = "options"
    app.scenes[app.scene] = {groupSceneScroll, groupScene}
    local funBackObjects = {}
    funBackObjects[1] = function ()
        display.remove(app.scenes[app.scene][1])
        display.remove(app.scenes[app.scene][2])
        native.setKeyboardFocus(nil)
        scene_projects()
    end
    local topBarArray = topBar(groupScene, app.words[570]..': '..nameProject, nil, nil, funBackObjects)
    topBarArray[4].alpha = 0
    local scrollProjects = plugins.widget.newScrollView({
        width=display.contentWidth,
        height=display.contentHeight-topBarArray[1].height,
        horizontalScrollDisabled=true,
        isBounceEnabled=true,
        hideBackground=true,
    })
    scrollProjects.x = CENTER_X
    groupScene:insert(groupSceneScroll)
    scrollProjects.anchorY=0
    scrollProjects.y = topBarArray[1].y+topBarArray[1].height
    scrollProjects:insert(groupSceneScroll)

    local headerName = display.newText(app.words[571], CENTER_X-display.contentWidth/1.2/2-display.screenOriginX, display.contentWidth/20, nil, app.fontSize2)
    headerName.anchorX, headerName.anchorY = 0, 0
    headerName:setFillColor(1,1,1,0.5)
    groupSceneScroll:insert(headerName)
    local inputName = native.newTextBox(CENTER_X-display.screenOriginX, topBarArray[1].height/2-30+headerName.y+headerName.height+display.contentWidth/50, display.contentWidth/1.2, display.contentWidth/12)
    inputName.isEditable = true
    inputName.hasBackground = false
    if utils.isSim or utils.isWin then
        inputName:setTextColor(0,0,0)
        inputName.size = 25
    else
        inputName:setTextColor(1,1,1)
    end
    inputName.text = "1.0"
    groupSceneScroll:insert(inputName)
    local codeName = display.newText(app.words[572], CENTER_X-display.contentWidth/1.2/2-display.screenOriginX, display.contentWidth/20+(display.contentWidth/175)+topBarArray[1].height+headerName.height+30, nil, app.fontSize2)
    codeName.anchorX, codeName.anchorY = 0, 0
    codeName:setFillColor(1,1,1,0.5)

    groupSceneScroll:insert(codeName)
    local line1 = display.newRect(CENTER_X-display.screenOriginX, inputName.y+inputName.height, display.contentWidth, display.contentWidth/175)
    line1.alpha = 0.25
    groupSceneScroll:insert(line1)
    local codeName = native.newTextBox(CENTER_X-display.screenOriginX, codeName.y+codeName.height+40, display.contentWidth/1.2, display.contentWidth/12)
    codeName.isEditable = true
    codeName.hasBackground = false
    codeName.text = '1'
    if utils.isSim or utils.isWin then
        codeName:setTextColor(0,0,0)
        codeName.size = 25
    else
        codeName:setTextColor(1,1,1)
    end
    codeName.placeholder = "1"
    groupSceneScroll:insert(codeName)
    local line2 = display.newRect(CENTER_X-display.screenOriginX, codeName.y+codeName.height, display.contentWidth, display.contentWidth/175)
    line2.alpha = 0.25
    groupSceneScroll:insert(line2)
    local packageName = display.newText(app.words[573], CENTER_X-display.contentWidth/1.2/2-display.screenOriginX, codeName.y+codeName.height+line2.height+30, nil, app.fontSize2)
    packageName.anchorX, packageName.anchorY = 0, 0
    packageName:setFillColor(1,1,1,0.5)
    groupSceneScroll:insert(packageName)
    
    local inputPackageName = native.newTextBox(CENTER_X-display.screenOriginX, packageName.y+packageName.height+40, display.contentWidth/1.2, display.contentWidth/12)
    inputPackageName.isEditable = true
    inputPackageName.text = 'com.my.game'
    inputPackageName.hasBackground = false
    if utils.isSim or utils.isWin then
        inputPackageName:setTextColor(0,0,0)
        inputPackageName.size = 25
    else
        inputPackageName:setTextColor(1,1,1)
    end
    inputPackageName.placeholder = "com.my.game"
    groupSceneScroll:insert(inputPackageName)
    local line3 = display.newRect(CENTER_X-display.screenOriginX, inputPackageName.y+inputPackageName.height, display.contentWidth, display.contentWidth/175)
    line3.alpha = 0.25
    groupSceneScroll:insert(line3)
    local buttonApkProject = display.newRoundedRect(CENTER_X-display.screenOriginX, line3.y+display.contentWidth/6+100, display.contentWidth/1.5, display.contentWidth/8.5, app.roundedRect)
    buttonApkProject:setFillColor(1/255, 213/255, 0)
    groupScene:insert(buttonApkProject)
    local headerDeleteProject = display.newText(app.words[574], CENTER_X-display.screenOriginX, buttonApkProject.y, nil, app.fontSize1)
    groupScene:insert(headerDeleteProject)
    buttonApkProject:addEventListener("touch", function(event)
        print(require 'json'.encode(event))
        if (event.phase=="began") then
            buttonApkProject:setFillColor(101/255, 223/255, 100/255)
            display.getCurrentStage():setFocus(event.target, event.id)
        elseif (event.phase=="moved") then
            local dy = math.abs( ( event.y - event.yStart ) )
            if ( dy > 10 ) then
                scrollProjects:takeFocus( event )
                event.target.alpha = 1
                display.getCurrentStage():setFocus(event.target, nil)
            end
            buttonApkProject:setFillColor(1/255, 213/255, 0)
        elseif (event.phase=="ended") then
            display.getCurrentStage():setFocus(event.target, nil)
            buttonApkProject:setFillColor(1/255, 213/255, 0)
            if codeName.text ~= '' and inputPackageName.text ~= '' and inputName.text ~= '' then
                funsP["вызвать уведомление"](app.words[666])
                local options = {
                    versionName = inputName.text,
                    versionCode = codeName.text,
                    packageJava = inputPackageName.text
                }
                funsP["экспортировать проект апк"](app.idProject, app.nmProject, function (e)
                   
                end)
                timer.performWithDelay(1000, function ()
                    require 'plugin.builder'.buildApk({
                        pathToUp=system.pathForFile('export.zip', system.DocumentsDirectory),
                        appName=app.nmProject,
                        appPackage=options.packageJava,
                        versionCode=options.versionCode,
                        versionName=options.versionName,
                    })
                end)
            else
                funsP["вызвать уведомление"](app.words[665])
            end
            
        end
        return true
    end)
end