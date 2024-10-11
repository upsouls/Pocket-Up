-- сцена опци проекта

function scene_options(idProject, nameProject)
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
local topBarArray = topBar(groupScene, app.words[9], nil, nil, funBackObjects)
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
scrollProjects.anchorY=0
scrollProjects.y = topBarArray[1].y+topBarArray[1].height
scrollProjects:insert(groupSceneScroll)

local headerName = display.newText(app.words[40], CENTER_X-display.contentWidth/1.2/2-display.screenOriginX, display.contentWidth/20, nil, app.fontSize2)
headerName.anchorX, headerName.anchorY = 0, 0
headerName:setFillColor(1,1,1,0.5)
groupSceneScroll:insert(headerName)
local inputName = native.newTextBox(CENTER_X-display.screenOriginX, headerName.y+headerName.height+display.contentWidth/50, display.contentWidth/1.2, display.contentWidth/12)
inputName.isEditable = true
inputName.hasBackground = false
if utils.isSim or utils.isWin then
    inputName:setTextColor(0,0,0)
    inputName.size = 25
else
    inputName:setTextColor(1,1,1)
end
inputName.anchorY=0
groupSceneScroll:insert(inputName)


local miniGroup1 = display.newGroup()
groupSceneScroll:insert(miniGroup1)

inputName.text = nameProject

local rectInputName = display.newRect(CENTER_X-display.screenOriginX, inputName.y+inputName.height, inputName.width, display.contentWidth/150)
rectInputName:setFillColor(1,1,1,0.75)
rectInputName.anchorY=0
miniGroup1:insert(rectInputName)
local errorName = display.newText({
    text="",
    x=headerName.x,
    y=rectInputName.y+rectInputName.height+display.contentWidth/50,
    font=nil,
    fontSize=app.fontSize2/1.05,
    width = inputName.width,
})
errorName.anchorX, errorName.anchorY = 0,0
errorName:setFillColor(1, 113/255, 67/255)
miniGroup1:insert(errorName)


local allProjects = plugins.json.decode(funsP["прочитать сс сохранение"]("список проектов"))
local idSlotProject = 1
while (allProjects[idSlotProject][2]~=idProject and idSlotProject<#allProjects) do
    idSlotProject = idSlotProject+1
end
local namesAllProjects = {}
for i=1, #allProjects do
    namesAllProjects[allProjects[i][1]] = true
end
namesAllProjects[nameProject] = nil

inputName:addEventListener("userInput", function (event)
    if (event.phase=="began") then
        if (event.text~="") then
            inputName:setSelection(0, plugins.utf8.len(inputName.text))
        end
        if (errorName.text=="") then
            headerName:setFillColor(171/255, 219/255, 241/255)
            rectInputName:setFillColor(171/255, 219/255, 241/255)
        end
    elseif (event.phase=="editing") then
        if (event.text:gsub("^%s+", ""):gsub("%s+$", "")=="") then
            errorName.text = app.words[18]
            headerName:setFillColor(1, 113/255, 67/255)
            rectInputName:setFillColor(1, 113/255, 67/255)
        elseif (namesAllProjects[event.text:gsub("^%s+", ""):gsub("%s+$", "")]) then
            errorName.text = app.words[15]
            headerName:setFillColor(1, 113/255, 67/255)
            rectInputName:setFillColor(1, 113/255, 67/255)
        else
            errorName.text = ""
            headerName:setFillColor(171/255, 219/255, 241/255)
            rectInputName:setFillColor(171/255, 219/255, 241/255)
            allProjects[idSlotProject][1] = event.text:gsub("^%s+", ""):gsub("%s+$", "")
            funsP["записать сс сохранение"]("список проектов", plugins.json.encode(allProjects))
        end
    else
        if (errorName.text=="") then
            headerName:setFillColor(1,1,1,0.5)
            rectInputName:setFillColor(1,1,1,0.75)
        end
    end
end)


local line1 = display.newRect(CENTER_X-display.screenOriginX, errorName.y+errorName.height, display.contentWidth, display.contentWidth/200)
line1.alpha = 0.25
miniGroup1:insert(line1)

local headerDescription = display.newText(app.words[44], headerName.x, line1.y+line1.height+display.contentWidth/20, nil, app.fontSize2)
headerDescription.anchorX, headerDescription.anchorY = 0, 0
headerDescription:setFillColor(1,1,1,0.5)
miniGroup1:insert(headerDescription)
local inputDescription = native.newTextBox(CENTER_X-display.screenOriginX, headerDescription.y+headerDescription.height+display.contentWidth/50, display.contentWidth/1.2, display.contentWidth/12*4)
if (optionsProject.description~=nil) then
    inputDescription.text = optionsProject.description
end
inputDescription.isEditable = true
inputDescription.hasBackground = false
if utils.isSim or utils.isWin then
    inputDescription:setTextColor(0,0,0)
    inputDescription.size = 25
else
    inputDescription:setTextColor(1,1,1)
end
inputDescription.anchorY=0
miniGroup1:insert(inputDescription)

local miniGroup2 = display.newGroup()
miniGroup1:insert(miniGroup2)

local rectInputDescription = display.newRect(CENTER_X-display.screenOriginX, inputDescription.y+inputDescription.height, inputDescription.width, display.contentWidth/150)
rectInputDescription:setFillColor(1,1,1,0.75)
rectInputDescription.anchorY=0
miniGroup2:insert(rectInputDescription)

local line2 = display.newRect(CENTER_X-display.screenOriginX, rectInputDescription.y+rectInputDescription.height+display.contentWidth/50+errorName.height, display.contentWidth, display.contentWidth/200)
line2.alpha = 0.25
miniGroup2:insert(line2)


local headerNote = display.newText(app.words[45], headerName.x, line2.y+line2.height+display.contentWidth/20, nil, app.fontSize2)
headerNote.anchorX, headerNote.anchorY = 0, 0
headerNote:setFillColor(1,1,1,0.5)
miniGroup2:insert(headerNote)
local inputNote = native.newTextBox(CENTER_X-display.screenOriginX, headerNote.y+headerNote.height+display.contentWidth/50, display.contentWidth/1.2, display.contentWidth/12*2)
if (optionsProject.note~=nil) then
    inputNote.text = optionsProject.note
end
inputNote.isEditable = true
inputNote.hasBackground = false
if utils.isSim or utils.isWin then
    inputNote:setTextColor(0,0,0)
    inputNote.size = 25
else
    inputNote:setTextColor(1,1,1)
end
inputNote.anchorY=0
miniGroup2:insert(inputNote)

local miniGroup3 = display.newGroup()
miniGroup2:insert(miniGroup3)

local rectInputNote = display.newRect(CENTER_X-display.screenOriginX, inputNote.y+inputNote.height, inputNote.width, display.contentWidth/150)
rectInputNote:setFillColor(1,1,1,0.75)
rectInputNote.anchorY=0
miniGroup3:insert(rectInputNote)

local line3 = display.newRect(CENTER_X-display.screenOriginX, rectInputNote.y+rectInputNote.height+display.contentWidth/50+errorName.height, display.contentWidth, display.contentWidth/200)
line3.alpha = 0.25
miniGroup3:insert(line3)


local function editingInput(event)
    if (event.phase=="began") then
        if (event.text~="") then
            event.target:setSelection(0, plugins.utf8.len(event.target.text))
        end
        event.target.header:setFillColor(171/255, 219/255, 241/255)
        event.target.rect:setFillColor(171/255, 219/255, 241/255)
    elseif (event.phase=="editing") then
        optionsProject[event.target.nameSave] = event.text
        funsP["записать сохранение"](idProject.."/options", plugins.json.encode(optionsProject))
    else
        event.target.header:setFillColor(1,1,1,0.5)
        event.target.rect:setFillColor(1,1,1,0.75)
    end
end
inputNote.nameSave = "note"
inputDescription.nameSave = "description"
inputNote.header = headerNote
inputNote.rect = rectInputNote
inputDescription.header = headerDescription
inputDescription.rect = rectInputDescription
inputDescription:addEventListener("userInput", editingInput)
inputNote:addEventListener("userInput", editingInput)


local buttonIsAspectRatio = display.newRect(CENTER_X, line3.y+line3.height/2, display.contentWidth, line1.y)
buttonIsAspectRatio.anchorY=0
buttonIsAspectRatio:setFillColor(4/255, 34/255, 44/255)
miniGroup3:insert(buttonIsAspectRatio)
local headerAspectRatio = display.newText({
    text=app.words[46],
    x=headerName.x,
    y = buttonIsAspectRatio.y+buttonIsAspectRatio.height/2,
    font=nil,
    fontSize=app.fontSize1,
    width=display.contentWidth/2,
    align="left",
})
headerAspectRatio.anchorX=0
headerAspectRatio:setFillColor(1,1,1,0.75)
miniGroup3:insert(headerAspectRatio)
local checkboxAspectRatio1 = display.newRoundedRect(display.contentWidth/1.25, headerAspectRatio.y, display.contentWidth/10, display.contentWidth/20, display.contentWidth/20)
if (optionsProject.aspectRatio) then
    checkboxAspectRatio1:setFillColor(53/255,91/255,104/255)
else
    checkboxAspectRatio1:setFillColor(81/255,101/255,108/255)
end
miniGroup3:insert(checkboxAspectRatio1)
local checkboxAspectRatio2alpha = display.newCircle(checkboxAspectRatio1.x+checkboxAspectRatio1.width/4*(optionsProject.aspectRatio and 1 or -1), checkboxAspectRatio1.y, checkboxAspectRatio1.height*1.25)
if (optionsProject.aspectRatio) then
    checkboxAspectRatio2alpha:setFillColor(171/255, 219/255, 241/255,0.25)
else
    checkboxAspectRatio2alpha:setFillColor(1,1,1,0.25)
end
checkboxAspectRatio2alpha.xScale, checkboxAspectRatio2alpha.yScale, checkboxAspectRatio2alpha.alpha = 0.5, 0.5, 0
miniGroup3:insert(checkboxAspectRatio2alpha)
local checkboxAspectRatio2 = display.newCircle(checkboxAspectRatio2alpha.x, checkboxAspectRatio2alpha.y, checkboxAspectRatio1.height/1.5)
if (optionsProject.aspectRatio) then
    checkboxAspectRatio2:setFillColor(171/255, 219/255, 241/255)
else
    checkboxAspectRatio2:setFillColor(185/255,185/255,185/255)
end
miniGroup3:insert(checkboxAspectRatio2)


buttonIsAspectRatio:addEventListener("touch", function (event)
    if (event.phase=="began") then
        transition.to(checkboxAspectRatio2alpha, { time=100, xScale=1, yScale=1, alpha=1, transition=easing.outSine})
        display.getCurrentStage():setFocus(event.target, event.id)
    elseif (event.phase=="moved") then
        transition.to(checkboxAspectRatio2alpha, { time=150, xScale=0.5, yScale=0.5, alpha=0, transition=easing.outSine})
        scrollProjects:takeFocus(event)
    else
        display.getCurrentStage():setFocus(event.target, nil)
        optionsProject.aspectRatio= not optionsProject.aspectRatio
        funsP["записать сохранение"](idProject.."/options", plugins.json.encode(optionsProject))
        local plusOrMinus = optionsProject.aspectRatio and 1 or -1
        transition.to(checkboxAspectRatio2alpha, { time=200, x=checkboxAspectRatio1.x+checkboxAspectRatio1.width/4*plusOrMinus, transition=easing.inOutSine, onComplete=function()
            transition.to(checkboxAspectRatio2alpha, { time=150, xScale=0.5, yScale=0.5, alpha=0, transition=easing.outSine})
        end})
        transition.to(checkboxAspectRatio2, { time=200, x=checkboxAspectRatio1.x+checkboxAspectRatio1.width/4*plusOrMinus, transition=easing.inOutSine})
        if (optionsProject.aspectRatio) then
            checkboxAspectRatio1:setFillColor(53/255,91/255,104/255)
            checkboxAspectRatio2:setFillColor(171/255, 219/255, 241/255)
            checkboxAspectRatio2alpha:setFillColor(171/255, 219/255, 241/255,0.25)
        else
            checkboxAspectRatio1:setFillColor(81/255,101/255,108/255)
            checkboxAspectRatio2:setFillColor(185/255,185/255,185/255)
            checkboxAspectRatio2alpha:setFillColor(1,1,1,0.25)
        end

    end
    return(true)
end)

local line4 = display.newRect(CENTER_X-display.screenOriginX, buttonIsAspectRatio.y+buttonIsAspectRatio.height, display.contentWidth, display.contentWidth/200)
line4.alpha = 0.25
miniGroup3:insert(line4)

local buttonPublicProject = display.newRect(CENTER_X-display.screenOriginX, line4.y+line4.height, buttonIsAspectRatio.width, buttonIsAspectRatio.height)
buttonPublicProject.anchorY=0
buttonPublicProject:setFillColor(4/255, 34/255, 44/255)
miniGroup3:insert(buttonPublicProject)
local headerPublicProject = display.newText(app.words[47], headerName.x, buttonPublicProject.y+buttonPublicProject.height/2, nil, app.fontSize1)
headerPublicProject.anchorX=0
headerPublicProject:setFillColor(1,1,1,0.75)
miniGroup3:insert(headerPublicProject)
local line5 = display.newRect(CENTER_X-display.screenOriginX, buttonPublicProject.y+buttonPublicProject.height, display.contentWidth, display.contentWidth/200)
line5.alpha = 0.25
miniGroup3:insert(line5)


local buttonExportProject = display.newRect(CENTER_X-display.screenOriginX, line5.y+line5.height, buttonIsAspectRatio.width, buttonIsAspectRatio.height)
buttonExportProject.anchorY=0
buttonExportProject:setFillColor(4/255, 34/255, 44/255)
miniGroup3:insert(buttonExportProject)
local headerExportProject = display.newText(app.words[48], headerName.x, buttonExportProject.y+buttonExportProject.height/2, nil, app.fontSize1)
headerExportProject.anchorX=0
headerExportProject:setFillColor(1,1,1,0.75)
miniGroup3:insert(headerExportProject)
local line6 = display.newRect(CENTER_X-display.screenOriginX, buttonExportProject.y+buttonExportProject.height, display.contentWidth, display.contentWidth/200)
line6.alpha = 0.25
miniGroup3:insert(line6)


local buttonMoreDetails = display.newRect(CENTER_X-display.screenOriginX, line6.y+line6.height, buttonIsAspectRatio.width, buttonIsAspectRatio.height)
buttonMoreDetails.anchorY=0
buttonMoreDetails:setFillColor(4/255, 34/255, 44/255)
miniGroup3:insert(buttonMoreDetails)
local headerMoreDetails = display.newText(app.words[49], headerName.x, buttonMoreDetails.y+buttonMoreDetails.height/2, nil, app.fontSize1)
headerMoreDetails.anchorX=0
headerMoreDetails:setFillColor(1,1,1,0.75)
miniGroup3:insert(headerMoreDetails)
local line7 = display.newRect(CENTER_X-display.screenOriginX, buttonMoreDetails.y+buttonMoreDetails.height, display.contentWidth, display.contentWidth/200)
line7.alpha = 0.25
miniGroup3:insert(line7)
--AAAAAAAAAAAAAAAAAAAAA
--AAAAAAAAAAAAAAAAAAAAA
--AAAAAAAAAAAAAAAAAAAAA
--AAAAAAAAAAAAAAAAAAAAA
--AAAAAAAAAAAAAAAAAAAAA

local function funTouchOption(event)
    if (event.phase=="began") then
        event.target:setFillColor(23/255, 91/255, 114/255)
        display.getCurrentStage():setFocus(event.target, event.id)
    elseif (event.phase=="moved") then
        event.target:setFillColor(4/255, 34/255, 44/255)
        scrollProjects:takeFocus(event)
    else
        event.target:setFillColor(4/255, 34/255, 44/255)

        if (event.target==buttonPublicProject) then
-- СДЕЛАТЬ ПУБЛИКАЦИЮ ПРОЕ
-- СДЕЛАТЬ ПУБЛИКАЦИЮ ПРОЕ
-- СДЕЛАТЬ ПУБЛИКАЦИЮ ПРОЕ
-- СДЕЛАТЬ ПУБЛИКАЦИЮ ПРОЕ
-- СДЕЛАТЬ ПУБЛИКАЦИЮ ПРОЕ
-- СДЕЛАТЬ ПУБЛИКАЦИЮ ПРОЕ
funsP["вызвать уведомление"](app.words[51])
elseif (event.target==buttonExportProject) then
    local function onCompleteExport()
        funsP["вызвать уведомление"](app.words[53])
    end
    print(allProjects[idSlotProject][1])
    funsP["экспортировать проект"](idProject, allProjects[idSlotProject][1], onCompleteExport)
    funsP["вызвать уведомление"](app.words[52])
elseif (event.target==buttonMoreDetails) then
--СДЕЛАТЬ СЦЕНУ ПОДРОБНЕЕ
--СДЕЛАТЬ СЦЕНУ ПОДРОБНЕЕ
--СДЕЛАТЬ СЦЕНУ ПОДРОБНЕЕ
--СДЕЛАТЬ СЦЕНУ ПОДРОБНЕЕ
--СДЕЛАТЬ СЦЕНУ ПОДРОБНЕЕ
funsP["вызвать уведомление"](app.words[51])
end

display.getCurrentStage():setFocus(event.target, nil)
end
return(true)
end
buttonPublicProject:addEventListener("touch", funTouchOption)
buttonExportProject:addEventListener("touch", funTouchOption)
buttonMoreDetails:addEventListener("touch", funTouchOption)

local buttonDeleteProject = display.newRoundedRect(CENTER_X-display.screenOriginX, line7.y+display.contentWidth/6, display.contentWidth/1.5, display.contentWidth/8.5, app.roundedRect)
buttonDeleteProject:setFillColor(213/255, 1/255, 0)
miniGroup3:insert(buttonDeleteProject)
local headerDeleteProject = display.newText(app.words[50], CENTER_X-display.screenOriginX, buttonDeleteProject.y, nil, app.fontSize1)
miniGroup3:insert(headerDeleteProject)
scrollProjects:setScrollHeight(buttonDeleteProject.y+display.contentWidth/6)

buttonDeleteProject:addEventListener("touch", function(event)
    if (event.phase=="began") then
        buttonDeleteProject:setFillColor(221/255, 51/255, 51/255)
        display.getCurrentStage():setFocus(event.target, event.id)
    elseif (event.phase=="moved") then
        buttonDeleteProject:setFillColor(213/255, 1/255, 0)
        scrollProjects:takeFocus(event)
    else
        buttonDeleteProject:setFillColor(213/255, 1/255, 0)
        display.getCurrentStage():setFocus(event.target, nil)

        app.cerberus.newBannerQuestion(app.words[54], function (tableAnswer)
            if(tableAnswer.isOk) then
                table.remove(allProjects, idSlotProject)
                funsP["записать сс сохранение"]("список проектов",plugins.json.encode(allProjects))
                local idsProjectsCreated = plugins.json.decode(funsP["прочитать сс сохранение"]("сортировка проектов - дата создания"))
                local idsProjectsOpen = plugins.json.decode(funsP["прочитать сс сохранение"]("сортировка проектов - дата открытия"))
                for i=1, #idsProjectsCreated do
                    if (idsProjectsCreated[i] == idSlotProject) then
                        table.remove(idsProjectsCreated, i)
                        break
                    end
                end
                for i=1, #idsProjectsOpen do
                    if (idsProjectsOpen[i] == idSlotProject) then
                        table.remove(idsProjectsOpen, i)
                        break
                    end
                end
                for i=1, #idsProjectsOpen do
                    if (idsProjectsCreated[i] > idSlotProject) then
                        idsProjectsCreated[i]=idsProjectsCreated[i]-1
                    end
                    if (idsProjectsOpen[i] > idSlotProject) then
                        idsProjectsOpen[i]=idsProjectsOpen[i]-1
                    end
                end
                funsP["записать сс сохранение"]("сортировка проектов - дата открытия", plugins.json.encode(idsProjectsOpen))
                funsP["записать сс сохранение"]("сортировка проектов - дата создания", plugins.json.encode(idsProjectsCreated))
                funsP["удалить объект"](idProject)
                display.remove(app.scenes[app.scene][1])
                display.remove(app.scenes[app.scene][2])
                scene_projects()
            end
        end)

    end
    return(true)
end)

end