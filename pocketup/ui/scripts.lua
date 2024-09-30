-- сцена с системой скриптов, просмотра образов и звуков

function scene_scripts(headerBar, pathObject, infoSceneObjects)

    IDOBJECT = pathObject

    local blocks = json.decode(funsP["получить сохранение"](pathObject.."/scripts"))
    if (false) then
        blocks = {
            {"start",{ {{"number",0}, {"text", "привет"}} }},
        }
    end


    local groupScene = display.newGroup()

    SCENE = "scripts"
    SCENES[SCENE] = {groupScene}
    local isBackScene = "back"
    local funMenuObjects = {}
    local funCheckObjects = {}
    local funBackObjects = {}
    local topBarArray = topBar(groupScene, headerBar, funMenuObjects, funCheckObjects, funBackObjects)
    local switchBar = display.newImage("images/barSwitch.png")
    switchBar.width = display.contentWidth
    switchBar.height = 97*(switchBar.width/720)
    switchBar.x, switchBar.y, switchBar.anchorY = CENTER_X, topBarArray[1].y+topBarArray[1].height, 0
    groupScene:insert(switchBar)
    local switchBarRect = display.newRect(CENTER_X-display.contentWidth/3, switchBar.y+switchBar.height, switchBar.width/3, switchBar.height/20)
    switchBarRect:setFillColor(171/255, 219/255, 241/255)
    switchBarRect.anchorY = 1
    groupScene:insert(switchBarRect)


    local scrollProjects = widget.newScrollView({
        width=display.contentWidth,
        height=display.contentHeight-topBarArray[1].height,
        horizontalScrollDisabled=true,
        isBounceEnabled=false,
        hideBackground=true,
    })
    scrollProjects.x=CENTER_X
    groupScene:insert(scrollProjects)
    scrollProjects.anchorY=0
    scrollProjects.y = switchBar.y+switchBar.height
    select_Scroll = scrollProjects

    local funAddImage = nil
    local funAddBlock = nil
    local touchBlock = nil
    local isBlockTouchBlock = false
    local function compartmentScripts()
        local groupSceneScroll = display.newGroup()
        scrollProjects:insert(groupSceneScroll)
        SCENES[SCENE][2] = groupSceneScroll


        local yTargetPos = 0
        local blocksObjects = {}

        local yScrollDepos = -((CENTER_Y-display.contentHeight/2)-scrollProjects.y)
        local isMoveBlock = false
        local function touchParameter(event)
            if (event.target.text == nil) then
                if (not isMoveBlock) then
                    local block = event.target.block
                    local objectsParameter = block.cells[event.target.idParameter]
                    if (event.phase=="began") then
                        if (objectsParameter[1]=="cell" or objectsParameter[1]=="shapeHitbox") then
                            objectsParameter[3].yScale = 2
                        end
                        display.getCurrentStage():setFocus(event.target, event.id)
                    elseif (event.phase=="moved" and (math.abs(event.y-event.yStart)>20 or math.abs(event.x-event.xStart)>20)) then
                        if (objectsParameter[1]=="cell" or objectsParameter[1]=="shapeHitbox") then
                            objectsParameter[3].yScale = 1
                        end
                        scrollProjects:takeFocus(event)
                    elseif (event.phase~="moved") then
                        local idParameter = event.target.typeParameter

                        local function isPrem()
                            local isPrem = not (funsP["прочитать сс сохранение"]("isPremium")==nil)
                            if (funsP["прочитать сс сохранение"]("blockPrem")~=nil) then
                                return(false)
                            else
                                return(isPrem)
                            end
                        end
                        if (premBlocks[blocks[block.id][1]]~=nil and not isPrem()) then
                            bannerPremium(groupScene)
                            if (idParameter=="cell" or idParameter=="shapeHitbox") then
                                objectsParameter[3].yScale = 1
                            end
                        else

                            if (idParameter=="cell") then
                                objectsParameter[3].yScale = 1
                                scene_formula_editor(objectsParameter, event.target.block.id, event.target.idParameter,blocks)
                            elseif (idParameter=="variables" or idParameter=="arrays" or idParameter=="function" or idParameter=="objects" or idParameter=="backgrounds" or idParameter=="images" or idParameter=="sounds" or idParameter=="scenes" or idParameter=="scripts" or idParameter == "goTo" or idParameter == "typeRotate" or idParameter == "effectParticle" or idParameter == "onOrOff" or idParameter == "alignText" or idParameter == "isDeleteFile" or idParameter == "typeBody" or idParameter=="GL" or idParameter=="inputType") then
                                local tableAnswers = {}
                                -- {вызуальный ответ, {тип функции, значение}}
                                local functionOnComplete = nil
                                -- в функции вызывается таблица {тип функции, значение}

                                if (idParameter=="scripts" or idParameter == "typeRotate" or idParameter == "effectParticle" or idParameter == "onOrOff" or idParameter == "alignText" or idParameter == "isDeleteFile" or idParameter == "typeBody" or idParameter=="GL" or idParameter=="inputType") then
                                    local allAnswers = {
                                        scripts = {{words[114], {"scripts","thisScript"}},{words[115], {"scripts","allScripts"}},{words[116], {"scripts","otherScripts"}}},
                                        typeRotate = {{words[134],{"typeRotate","true"}},{words[135],{"typeRotate","false"}}},
                                        effectParticle = {{words[178],{"effectParticle","in"}},{words[179],{"effectParticle","out"}}},
                                        onOrOff = {{words[183],{"onOrOff","on"}},{words[184],{"onOrOff","off"}}},
                                        alignText = {{words[210], {"alignText","center"}},{words[211], {"alignText","left"}},{words[212], {"alignText","right"}}},
                                        isDeleteFile={{words[222],{"isDeleteFile", "save"}},{words[223],{"isDeleteFile","delete"}}},
                                        typeBody={{words[393],{"typeBody","dynamic"}}, {words[394],{"typeBody","static"}}, {words[395],{"typeBody","noPhysic"}}},
                                        GL={{"GL_ONE",{"GL","GL_ONE"}},{"GL_ZERO",{"GL","GL_DST_COLOR"}},{"GL_ONE_MINUS_DST_COLOR",{"GL","GL_ONE_MINUS_DST_COLOR"}},{"GL_SRC_ALPHA",{"GL","GL_SRC_ALPHA"}},{"GL_ONE_MINUS_SRC_ALPHA",{"GL","GL_ONE_MINUS_SRC_ALPHA"}},{"GL_DST_ALPHA",{"GL","GL_DST_ALPHA"}},{"GL_ONE_MINUS_DST_ALPHA",{"GL","GL_ONE_MINUS_DST_ALPHA"}},{"GL_SRC_ALPHA_SATURATE",{"GL","GL_SRC_ALPHA_SATURATE"}},{"GL_SRC_COLOR",{"GL","SRC_COLOR"}},{"GL_ONE_MINUS_SRC_COLOR",{"GL","GL_ONE_MINUS_SRC_COLOR"}}},
                                        inputType={{words[498], {"inputType", "default"}}, {words[499], {"inputType", "number"}}, {words[500], {"inputType", "decimal"}}, {words[501], {"inputType", "phone"}}, {words[502], {"inputType", "url"}}, {words[503], {"inputType", "email"}}, {words[504], {"inputType", "no-emoji"}}},
                                    }
                                    tableAnswers = allAnswers[idParameter]
                                    functionOnComplete = function (answer)
                                        for i=1, #tableAnswers do
                                            if (tableAnswers[i][2][2]==answer[2]) then
                                                objectsParameter[3].text = tableAnswers[i][1]
                                                break
                                            end
                                        end
                                        blocks[block.id][2][event.target.idParameter] = answer
                                        funsP["записать сохранение"](IDOBJECT.."/scripts", json.encode(blocks))
                                    end
                                elseif (idParameter == "goTo") then
                                    tableAnswers[1] = {words[123], {"goTo", "touch"}}
                                    tableAnswers[2] = {words[124], {"goTo", "random"}}
                                    local arrayObjects = json.decode(funsP["получить сохранение"](IDSCENE.."/objects"))
                                    for i=2, #arrayObjects do
                                        if (IDSCENE.."/object_"..arrayObjects[i][2]~=IDOBJECT) then
                                            tableAnswers[#tableAnswers+1] = {arrayObjects[i][1], {"goTo", arrayObjects[i][2]}}
                                        end
                                    end
                                    functionOnComplete = function (answer)
                                        for i=1, #tableAnswers do
                                            if (tableAnswers[i][2][2]==answer[2]) then
                                                objectsParameter[3].text = tableAnswers[i][1]
                                                break
                                            end
                                        end
                                        blocks[block.id][2][event.target.idParameter] = answer
                                        funsP["записать сохранение"](IDOBJECT.."/scripts", json.encode(blocks))
                                    end
                                elseif (idParameter=="scenes") then
                                    tableAnswers[1] = {words[87], {"scenes", nil}}
                                    local arrayScenes = json.decode(funsP["получить сохранение"](IDPROJECT.."/scenes"))
                                    for i=1, #arrayScenes do
                                        if (IDSCENE~=IDPROJECT.."/scene_"..arrayScenes[i][2]) then
                                            tableAnswers[#tableAnswers+1] = {arrayScenes[i][1], {"scenes",arrayScenes[i][2]}}
                                        end
                                    end

                                    functionOnComplete = function (answer)
                                        if (answer[2]==nil) then
                                            local function isCorrectValue(value)
                                                if (string.len(value)==0) then
                                                    return(words[18])
                                                else
                                                    local isCorrect = true
                                                    for i=1, #arrayScenes do
                                                        if (arrayScenes[i][1]==value) then 
                                                            isCorrect = false
                                                            break
                                                        end
                                                    end
                                                    return(isCorrect and "" or words[15])
                                                end
                                            end
                                            local function correctValue(value)
                                                if (isCorrectValue(value)=="") then
                                                    return(value)
                                                else
                                                    local i=1
                                                    while (isCorrectValue(value.." ("..i..")")~="") do
                                                        i = i+1
                                                    end
                                                    return(value.." ("..i..")")
                                                end
                                            end
                                            cerberus.newInputLine(words[26], words[27], isCorrectValue, correctValue(words[28]), function (answer)
                                                if (answer.isOk) then
                                                    answer.value = string.gsub(answer.value, (isWin and '\r\n' or '\n'), " ")
                                                    local counter = json.decode(funsP["получить сохранение"](IDPROJECT.."/counter"))
                                                    counter[1] = counter[1]+1
                                                    funsP["записать сохранение"](IDPROJECT.."/counter", json.encode(counter))

                                                    funsP["создать сцену"](IDPROJECT, IDPROJECT.."/scene_"..counter[1])
                                                    table.insert(arrayScenes, #arrayScenes+1, {answer.value, counter[1]})
                                                    funsP["записать сохранение"](IDPROJECT.."/scenes", json.encode(arrayScenes))

                                                    blocks[block.id][2][event.target.idParameter][2] = counter[1]
                                                    funsP["записать сохранение"](IDOBJECT.."/scripts", json.encode(blocks))
                                                    objectsParameter[3].text = answer.value

                                                end
                                            end)
                                        else
                                            blocks[block.id][2][event.target.idParameter] = answer
                                            funsP["записать сохранение"](IDOBJECT.."/scripts", json.encode(blocks))
                                            for i=1, #arrayScenes do
                                                if (arrayScenes[i][2]==answer[2]) then
                                                    objectsParameter[3].text = arrayScenes[i][1]
                                                    break
                                                end
                                            end
                                        end
                                    end

                                elseif (idParameter=="backgrounds" or idParameter=="images" or idParameter=="sounds") then
                                    tableAnswers[1] = {words[87], {idParameter, nil}}
                                    local idBackground = idParameter=="backgrounds" and (IDSCENE.."/object_"..json.decode(funsP["получить сохранение"](IDSCENE.."/objects"))[1][2]) or IDOBJECT
                                    local arrayBackgrounds = json.decode(funsP["получить сохранение"](idBackground.."/"..(idParameter=="sounds" and "sounds" or "images") ))
                                    for i=1, #arrayBackgrounds do
                                        tableAnswers[#tableAnswers+1] = {arrayBackgrounds[i][1], {idParameter, arrayBackgrounds[i][2]}}
                                    end
                                    functionOnComplete = function(answer)
                                        if (answer[2]==nil) then
                                            funsP[(idParameter=="sounds" and "импортировать звук" or "импортировать изображение")](function (answer)
                                                if (answer.done=="ok") then
                                                    local fileName = answer.origFileName:match("(.+)%.") or answer.origFileName
                                                    local counter = json.decode(funsP["получить сохранение"](IDPROJECT.."/counter"))
                                                    local idCounter = idParameter=="sounds" and 4 or 3
                                                    counter[idCounter] = counter[idCounter]+1
                                                    funsP["записать сохранение"](IDPROJECT.."/counter", json.encode(counter))
                                                    funsP[(idParameter=="sounds" and "добавить звук в объект" or "добавить изображение в объект")](idBackground.."/"..(idParameter=="sounds" and "sound" or "image").."_"..counter[idCounter].."."..(idParameter=="sounds" and "mp3" or "png") )
                                                    local arrayImages = json.decode(funsP["получить сохранение"](idBackground.."/"..(idParameter=="sounds" and "sounds" or "images") ))
                                                    local function correctValue(value)
                                                        local function isCorrect(value)
                                                            local isCorrect = true
                                                            for i=1, #arrayImages do
                                                                if (arrayImages[i][1]==value) then
                                                                    isCorrect = false
                                                                    break
                                                                end
                                                            end
                                                            return(isCorrect)
                                                        end

                                                        if (isCorrect(value)) then
                                                            return(value)
                                                        else
                                                            local i = 1
                                                            while (not isCorrect(value.." ("..i..")")) do
                                                                i = i+1
                                                            end
                                                            return(value.." ("..i..")")
                                                        end
                                                    end
                                                    objectsParameter[3].text = correctValue(fileName)
                                                    arrayImages[#arrayImages+1] = {correctValue(fileName), counter[idCounter]}
                                                    funsP["записать сохранение"](idBackground.."/"..(idParameter=="sounds" and "sounds" or "images"), json.encode(arrayImages))

                                                    blocks[block.id][2][event.target.idParameter][2] = counter[idCounter]
                                                    funsP["записать сохранение"](IDOBJECT.."/scripts", json.encode(blocks))

                                                end
                                            end)
                                        else
                                            blocks[block.id][2][event.target.idParameter] = answer
                                            funsP["записать сохранение"](IDOBJECT.."/scripts", json.encode(blocks))
                                            for i=1, #tableAnswers do
                                                if (tableAnswers[i][2] == answer) then
                                                    objectsParameter[3].text = tableAnswers[i][1]
                                                    break
                                                end
                                            end
                                        end
                                    end

                                elseif (idParameter=="objects") then
                                    local collOrClone = blocks[block.id][1] == "collision" or blocks[block.id][1] == "endedCollision"
                                    tableAnswers[1] = {words[collOrClone and 85 or 90], {"objects", nil}}
                                    local arrayObjects = json.decode(funsP["получить сохранение"](IDSCENE.."/objects"))
                                    for i=(collOrClone and 1 or 2), #arrayObjects do
                                        if (collOrClone or IDSCENE.."/object_"..arrayObjects[i][2]~=IDOBJECT) then
                                            tableAnswers[#tableAnswers+1] = {arrayObjects[i][1],{"objects", arrayObjects[i][2]}}
                                        end
                                    end
                                    functionOnComplete = function (answer)
                                        blocks[block.id][2][event.target.idParameter] = answer
                                        funsP["записать сохранение"](IDOBJECT.."/scripts", json.encode(blocks))

                                        for i=1, #tableAnswers do
                                            if (tableAnswers[i][2] == answer) then
                                                objectsParameter[3].text = tableAnswers[i][1]
                                                break
                                            end
                                        end

                                    end

                                elseif (idParameter=="function") then
                                    tableAnswers[1] = {words[87],{"functions","new"}}
                                    tableAnswers[2] = {words[256],{"functions","edit"}}
                                    local arrayFunctions = json.decode(funsP["получить сохранение"](IDSCENE.."/functions"))
                                    for i=1, #arrayFunctions do
                                        tableAnswers[#tableAnswers+1] = {arrayFunctions[i][2], {"function",arrayFunctions[i][1]}}
                                    end

                                    functionOnComplete = function(answer)
                                        local function isCorrectValue(value)
                                            if (string.len(value)==0) then
                                                return(words[18])
                                            else
                                                local isCorrectValue = true
                                                for i=3, #tableAnswers do
                                                    if (tableAnswers[i][1]==value) then
                                                        isCorrectValue = false
                                                        break
                                                    end
                                                end
                                                return(isCorrectValue and "" or words[15])
                                            end
                                        end
                                        local function correctValue(value)
                                            if (isCorrectValue(value)=="") then
                                                return(value)
                                            else
                                                local i=1
                                                while (isCorrectValue(value.." ("..i..")")~="") do
                                                    i=i+1
                                                end
                                                return(value.." ("..i..")")
                                            end
                                        end
                                        if (answer[2]=="new") then
                                            cerberus.newInputLine(words[257], words[258], isCorrectValue, correctValue(words[259]), function(answer)
                                                if (answer.isOk) then
                                                    answer.value = string.gsub(answer.value, (isWin and '\r\n' or '\n'), " ")
                                                    local oldIdFunction = blocks[block.id][2][event.target.idParameter][2]
                                                    local newIdFunction = arrayFunctions[1][1]+1
                                                    table.insert(arrayFunctions, 1, {newIdFunction, answer.value,1})

                                                    blocks[block.id][2][event.target.idParameter][2] = newIdFunction
                                                    
                                                    funsP["записать сохранение"](IDOBJECT.."/scripts", json.encode(blocks))
                                                    funsP["записать сохранение"](IDSCENE.."/functions", json.encode(arrayFunctions))
                                                    block.cells[1][3].text = answer.value
                                                end
                                            end)
                                        elseif (answer[2]=="edit") then
                                            cerberus.newInputLine(words[260], "", isCorrectValue, objectsParameter[3].text, function(answer)
                                                if (answer.isOk) then
                                                    answer.value = string.gsub(answer.value, (isWin and '\r\n' or '\n'), " ")
                                                    local myIdFunction = blocks[block.id][2][event.target.idParameter][2]
                                                    for i=1, #arrayFunctions do
                                                        if (arrayFunctions[i][1]==myIdFunction) then

                                                            arrayFunctions[i][2] = answer.value
                                                            break
                                                        end
                                                    end
                                                    for i=1, #blocks do
                                                        local tableBlock = blocks[i][2]
                                                        for i2=1, #tableBlock do
                                                            if (tableBlock[i2][2]==myIdFunction and tableBlock[i2][1]=="function") then
                                                                blocksObjects[i].cells[i2][3].text = answer.value
                                                            end
                                                        end 
                                                    end
                                                    funsP["записать сохранение"](IDSCENE.."/functions", json.encode(arrayFunctions))

                                                end
                                            end)
                                        else
                                            local oldIdFunction = blocks[block.id][2][event.target.idParameter][2]
                                            if (answer[2]~=oldIdFunction) then
                                                blocks[block.id][2][event.target.idParameter] = answer


                                                for i=1, #arrayFunctions do
                                                    if (arrayFunctions[i][1]==answer[2]) then
                                                        arrayFunctions[i][3] = arrayFunctions[i][3]+1
                                                        break
                                                    end
                                                end

                                                for i=1, #arrayFunctions do
                                                    if (arrayFunctions[i][1]==oldIdFunction) then
                                                        arrayFunctions[i][3] = arrayFunctions[i][3]-1
                                                        if (arrayFunctions[i][3]<1) then
                                                            table.remove(arrayFunctions, i)
                                                        end
                                                        break
                                                    end
                                                end


                                                funsP["записать сохранение"](IDOBJECT.."/scripts", json.encode(blocks))
                                                funsP["записать сохранение"](IDSCENE.."/functions", json.encode(arrayFunctions))

                                                for i=3, #tableAnswers do
                                                    if (tableAnswers[i][2]==answer) then
                                                        objectsParameter[3].text = tableAnswers[i][1]
                                                        break
                                                    end
                                                end

                                            end

                                        end
                                    end

                                elseif (idParameter=="variables" or idParameter=="arrays") then
                                    local varOrArr = idParameter=="variables" and "Variable" or "Array"
                                    local localVariables = json.decode(funsP["получить сохранение"](IDOBJECT.."/"..idParameter))
                                    local globalVariables = json.decode(funsP["получить сохранение"](IDPROJECT.."/"..idParameter))

                                    tableAnswers[1] = {words[87], "global"..varOrArr, nil}
                                    for i=1, #localVariables do
                                        tableAnswers[#tableAnswers+1] = {localVariables[i][2], {"local"..varOrArr, localVariables[i][1]}}
                                    end
                                    for i=1, #globalVariables do
                                        tableAnswers[#tableAnswers+1] = {globalVariables[i][2], {"global"..varOrArr, globalVariables[i][1]}}
                                    end
                                    functionOnComplete = function(answer)
                                        if (answer[2]==nil) then

                                            local function createVariableTextInput(header, placeholder, isCorrectValue, value, funEditingEnd)
                                                if (isCorrectValue==nil) then
                                                    isCorrectValue = function()
                                                        return("")
                                                    end
                                                end
                                                if (value==nil) then
                                                    value = ""
                                                end
                                                local backgroundBlackAlpha = display.newRect(CENTER_X, CENTER_Y, display.contentWidth, display.contentHeight)
                                                backgroundBlackAlpha:setFillColor(0,0,0,0.6)
                                                SCENES[SCENE][1]:insert(backgroundBlackAlpha)
                                                local group = display.newGroup()
                                                SCENES[SCENE][1]:insert(group)
                                                local rect = display.newRoundedRect(CENTER_X, CENTER_Y, display.contentWidth/1.08, 0, roundedRect)
                                                rect.anchorY=0,
                                                rect:setFillColor(66/255, 66/255, 66/255)
                                                group:insert(rect)

                                                backgroundBlackAlpha.alpha = 0
                                                rect.alpha = 0
                                                transition.to(backgroundBlackAlpha, {time=150, alpha=1})
                                                transition.to(rect, {time=150, alpha=1})

                                                local miniGroupTop = display.newGroup()
                                                group:insert(miniGroupTop)
                                                local miniGroupBottom = display.newGroup()
                                                group:insert(miniGroupBottom)
                                                local textHeader = display.newText({
                                                    text=header,
                                                    width=rect.width-display.contentWidth/17*2,
                                                    x=CENTER_X, 
                                                    y=CENTER_Y+display.contentWidth/17,
                                                    font=nil,
                                                    fontSize=fontSize0,
                                                })
                                                textHeader.anchorY=0
                                                miniGroupTop:insert(textHeader)
                                                local textPlaceholder = display.newText({
                                                    text=placeholder,
                                                    width=rect.width-display.contentWidth/17*2,
                                                    x=CENTER_X, 
                                                    y=textHeader.y+textHeader.height+display.contentWidth/17,
                                                    font=nil,
                                                    fontSize=fontSize2,
                                                })
                                                miniGroupTop:insert(textPlaceholder)
                                                local input = native.newTextBox(CENTER_X, textPlaceholder.y+textPlaceholder.height, textHeader.width, textHeader.width/10)
                                                input.isEditable = true
                                                input.hasBackground = false
                                                if isSim or isWin then
                                                    input:setTextColor(0,0,0)
                                                    input.size = 25
                                                else
                                                    input:setTextColor(1,1,1)
                                                end
                                                input.anchorY=0
                                                miniGroupTop:insert(input)

                                                input.text = value
                                                native.setKeyboardFocus(input)
                                                if (value~="") then
                                                    input:setSelection(0, utf8.len(value))
                                                end

                                                local rectInput = display.newRect(CENTER_X, input.y+input.height, input.width, display.contentWidth/150)
                                                rectInput.anchorY=0
                                                miniGroupTop:insert(rectInput)

                                                local textError = display.newText({
                                                    text="--",
                                                    width=rect.width-display.contentWidth/17*2,
                                                    x=CENTER_X, 
                                                    y=rectInput.y+rectInput.height+display.contentWidth/34,
                                                    font=nil,
                                                    fontSize=fontSize2,
                                                })
                                                textError.anchorY = 0
                                                textError:setFillColor(1, 113/255, 67/255)
                                                miniGroupTop:insert(textError)

                                                local textButtonOk = display.newText(words[16], 0, 0, nil, fontSize1)
                                                textButtonOk:setFillColor(171/255, 219/255, 241/255)
                                                local rectButtonOk = display.newRoundedRect(CENTER_X+textHeader.width/2, CENTER_Y, textButtonOk.width+display.contentWidth/10, textButtonOk.height+display.contentWidth/30, roundedRect)
                                                rectButtonOk.anchorX, rectButtonOk.anchorY = 1, 0
                                                textButtonOk.x, textButtonOk.y = rectButtonOk.x-rectButtonOk.width/2, rectButtonOk.y+rectButtonOk.height/2
                                                rectButtonOk:setFillColor(66/255,66/255, 66/255)
                                                miniGroupBottom:insert(rectButtonOk)
                                                miniGroupBottom:insert(textButtonOk)
                                                local textButtonCancel = display.newText(words[17], 0, 0, nil, fontSize1)
                                                textButtonCancel:setFillColor(171/255, 219/255, 241/255)
                                                local rectButtonCancel = display.newRoundedRect(rectButtonOk.x-rectButtonOk.width-display.contentWidth/40, CENTER_Y, textButtonCancel.width+display.contentWidth/20, textButtonCancel.height+display.contentWidth/30, roundedRect)
                                                rectButtonCancel.anchorX, rectButtonCancel.anchorY = 1, 0
                                                textButtonCancel.x, textButtonCancel.y = rectButtonCancel.x-rectButtonCancel.width/2, rectButtonCancel.y+rectButtonCancel.height/2
                                                rectButtonCancel:setFillColor(66/255,66/255, 66/255)
                                                miniGroupBottom:insert(rectButtonCancel)
                                                miniGroupBottom:insert(textButtonCancel)


                                                local textCheckboxGlobal = display.newText({
                                                    text=words[252],
                                                    x=CENTER_X*1.1,
                                                    y=rectButtonCancel.y,
                                                    width=display.contentWidth/1.4,
                                                    fontSize=fontSize1,
                                                })
                                                textCheckboxGlobal.anchorY=0
                                                miniGroupBottom:insert(textCheckboxGlobal)
                                                local checkboxGlobal = display.newImage("images/circle_checkbox_2.png")
                                                checkboxGlobal:setFillColor(171/255, 219/255, 241/255)
                                                checkboxGlobal.width, checkboxGlobal.height = textPlaceholder.width/12.5, textPlaceholder.width/12.5
                                                checkboxGlobal.x, checkboxGlobal.y = CENTER_X-display.contentWidth/2.75, textCheckboxGlobal.y+textCheckboxGlobal.height/2
                                                miniGroupBottom:insert(checkboxGlobal)

                                                local textCheckboxLocal = display.newText({
                                                    text=words[253],
                                                    x=CENTER_X*1.1,
                                                    y = textCheckboxGlobal.y+textCheckboxGlobal.height,
                                                    width=display.contentWidth/1.4,
                                                    fontSize=fontSize1,
                                                })
                                                textCheckboxLocal.anchorY=0
                                                miniGroupBottom:insert(textCheckboxLocal)
                                                local checkboxLocal = display.newImage("images/circle_checkbox_1.png")
                                                checkboxLocal.width, checkboxLocal.height = textPlaceholder.width/12.5, textPlaceholder.width/12.5
                                                checkboxLocal.x, checkboxLocal.y = CENTER_X-display.contentWidth/2.75, textCheckboxLocal.y+textCheckboxLocal.height/2
                                                miniGroupBottom:insert(checkboxLocal)

                                                rectButtonCancel.y = textCheckboxLocal.y+textCheckboxLocal.height+display.contentWidth/10
                                                textButtonCancel.y = rectButtonCancel.y+rectButtonCancel.height/2
                                                rectButtonOk.y = rectButtonCancel.y
                                                textButtonOk.y = textButtonCancel.y
                                                checkboxLocal.locality = "local"
                                                checkboxGlobal.locality = "global"
                                                textCheckboxLocal.locality = "local"
                                                textCheckboxGlobal.locality = "global"
                                                checkboxLocal.otherObject = checkboxGlobal
                                                checkboxGlobal.otherObject = checkboxLocal
                                                textCheckboxLocal.otherObject = checkboxGlobal
                                                textCheckboxGlobal.otherObject = checkboxLocal
                                                checkboxLocal.targetObject = checkboxLocal
                                                checkboxGlobal.targetObject = checkboxGlobal
                                                textCheckboxLocal.targetObject = checkboxLocal
                                                textCheckboxGlobal.targetObject = checkboxGlobal
                                                local myLocality = "global"
                                                local function touchTypeLocality(event)
                                                    if (event.phase == "ended" and myLocality ~= event.target.locality) then
                                                        myLocality = event.target.locality
                                                        event.target.targetObject.fill = {
                                                            type="image",
                                                            filename="images/circle_checkbox_2.png",
                                                        }
                                                        event.target.targetObject:setFillColor(171/255, 219/255, 241/255)
                                                        event.target.otherObject.fill = {
                                                            type="image",
                                                            filename="images/circle_checkbox_1.png",
                                                        }
                                                    end
                                                    return(true)
                                                end
                                                checkboxLocal:addEventListener("touch", touchTypeLocality)
                                                checkboxGlobal:addEventListener("touch", touchTypeLocality)
                                                textCheckboxLocal:addEventListener("touch", touchTypeLocality)
                                                textCheckboxGlobal:addEventListener("touch", touchTypeLocality)
                                                local touchNoTouch = nil
                                                local function touchEditingEnd(event)
                                                    if (event.target.textButton.alpha>0.9) then
                                                        if (event.phase=="began") then
                                                            event.target:setFillColor(99/255, 99/255, 99/255)
                                                        elseif (event.phase=="moved") then
                                                            event.target:setFillColor(66/255, 66/255, 66/255)
                                                        else
                                                            event.target:setFillColor(66/255, 66/255, 66/255)
                                                            native.setKeyboardFocus(nil)
                                                            input.isEditable = false
                                                            rectButtonOk:removeEventListener("touch", touchEditingEnd)
                                                            rectButtonCancel:removeEventListener("touch", touchEditingEnd)
                                                            backgroundBlackAlpha:removeEventListener("touch",touchNoTouch)
                                                            rect:removeEventListener("touch",touchNoTouch)

                                                            transition.to(backgroundBlackAlpha, {time=200, alpha=0, inComplete=function()
                                                                display.remove(backgroundBlackAlpha)
                                                            end})
                                                            display.remove(input)
                                                            transition.to(group, {time=200, alpha=0, inComplete=function()
                                                                display.remove(group)
                                                            end})

                                                            if (funEditingEnd~=nil) then
                                                                if (event.target==rectButtonOk) then
                                                                    funEditingEnd({["isOk"]=true, ["value"]=input.text,
                                                                    ["locality"]=myLocality})
                                                                else
                                                                    funEditingEnd({["isOk"]=false})
                                                                end
                                                            end
                                                        end
                                                    end
                                                    return(true)
                                                end
                                                rectButtonOk.textButton = textButtonOk
                                                rectButtonCancel.textButton = textButtonCancel
                                                rectButtonOk:addEventListener("touch", touchEditingEnd)
                                                rectButtonCancel:addEventListener("touch", touchEditingEnd)

                                                touchNoTouch = function(event)
                                                    if (event.phase=="ended" and event.target==backgroundBlackAlpha) then
                                                        native.setKeyboardFocus(nil)
                                                        input.isEditable = false
                                                        rectButtonOk:removeEventListener("touch", touchEditingEnd)
                                                        rectButtonCancel:removeEventListener("touch", touchEditingEnd)
                                                        backgroundBlackAlpha:removeEventListener("touch",touchNoTouch)
                                                        rect:removeEventListener("touch",touchNoTouch)

                                                        transition.to(backgroundBlackAlpha, {time=200, alpha=0, inComplete=function()
                                                            display.remove(backgroundBlackAlpha)
                                                        end})
                                                        display.remove(input)
                                                        transition.to(group, {time=200, alpha=0, inComplete=function()
                                                            display.remove(group)
                                                        end})

                                                        if (funEditingEnd~=nil) then
                                                            funEditingEnd({["isOk"]=false})
                                                        end
                                                    end
                                                    return(true)
                                                end
                                                backgroundBlackAlpha: addEventListener("touch",touchNoTouch)
                                                rect:addEventListener("touch",touchNoTouch)

                                                local function updateHeightRect()
                                                    rect.height = miniGroupTop.height+miniGroupBottom.height+(textError.text~="" and display.contentWidth/10 or display.contentWidth/30)+display.contentWidth/30
                                                    miniGroupBottom.y = miniGroupTop.height+(textError.text~="" and display.contentWidth/10 or display.contentWidth/30)
                                                    group.y = -group.height/2
                                                end

                                                local function isError(value)
                                                    local oldTextError = textError.text
                                                    textError.text = isCorrectValue(value)
                                                    if (textError.text ~= "" and oldTextError~=textError.text) then
                                                        textPlaceholder:setFillColor(1, 113/255, 67/255)
                                                        rectInput:setFillColor(1, 113/255, 67/255)
                                                        updateHeightRect()
                                                        textButtonOk.alpha = 0.25
                                                        textButtonOk:setFillColor(1,1,1)
                                                    elseif (textError.text == "" and oldTextError~="") then
                                                        textPlaceholder:setFillColor(171/255, 219/255, 241/255)
                                                        rectInput:setFillColor(171/255, 219/255, 241/255)
                                                        updateHeightRect()
                                                        textButtonOk.alpha = 1
                                                        textButtonOk:setFillColor(171/255, 219/255, 241/255)
                                                    end
                                                end
                                                isError(value)


                                                input:addEventListener("userInput", function (event)
                                                    if (event.phase=="began") then
                                                    elseif (event.phase=="editing") then

                                                        isError(event.text)

                                                        if (select(2, string.gsub(event.oldText, "\n", "\n")) ~= select(2, string.gsub(event.text, "\n", "\n")) and select(2, string.gsub(event.text, "\n", "\n"))<6 ) then
                                                            event.target.height = textHeader.width/12*math.min(math.max(select(2, string.gsub(event.text, "\n", "\n"))+1, 1), 6)
                                                            rectInput.y = input.y+input.height
                                                            textError.y = rectInput.y+rectInput.height+display.contentWidth/34
                                                            updateHeightRect()
                                                        end
                                                    elseif (event.pahse=="ended") then
                                                    end
                                                end)

                                            end

                                            local function isCorrectValue(event)
                                                if (string.len(event)==0) then
                                                    return(words[18])
                                                else
                                                    local isCorrect = true
                                                    for i=2, #tableAnswers do
                                                        if (tableAnswers[i][1]==event) then
                                                            isCorrect = false
                                                            break
                                                        end
                                                    end
                                                    return(isCorrect and "" or words[15])
                                                end
                                            end
                                            local function correctValue(event)
                                                if (isCorrectValue(event)=="") then
                                                    return(event)
                                                else
                                                    local i=1
                                                    while (isCorrectValue(event.." ("..i..")")~="") do
                                                        i = i+1
                                                    end
                                                    return(event.." ("..i..")")
                                                end
                                            end

                                            createVariableTextInput(words[idParameter=="variables" and 249 or 254], words[250], isCorrectValue, correctValue(words[(idParameter=="variables") and 251 or 255]), function (answer)
                                                if (answer.isOk) then
                                                    answer.value = string.gsub(answer.value, (isWin and '\r\n' or '\n')," ")
                                                    local variables = json.decode(funsP["получить сохранение"]((answer.locality == "global" and IDPROJECT or IDOBJECT).."/"..idParameter))
                                                    local idVariable = nil
                                                    if (#variables==0) then
                                                        table.insert(variables, 1, {1, answer.value})
                                                        idVariable = 1
                                                    else
                                                        idVariable = variables[1][1]+1
                                                        table.insert(variables, 1, {idVariable, answer.value})
                                                    end
                                                    funsP["записать сохранение"]((answer.locality == "global" and IDPROJECT or IDOBJECT).."/"..idParameter, json.encode(variables))
                                                    objectsParameter[3].text = answer.value
                                                    blocks[block.id][2][event.target.idParameter] = {answer.locality..varOrArr,idVariable}
                                                    funsP["записать сохранение"](IDOBJECT.."/scripts", json.encode(blocks))

                                                end
                                            end)

                                        else
                                            for i=2, #tableAnswers do
                                                if (tableAnswers[i][2]==answer) then
                                                    objectsParameter[3].text = tableAnswers[i][1]
                                                    break
                                                end
                                            end 

                                            blocks[block.id][2][event.target.idParameter] = answer
                                            funsP["записать сохранение"](IDOBJECT.."/scripts", json.encode(blocks))
                                        end
                                    end
                            end -- elseif


                            local backgroundNotTouch = display.newImage("images/notVisible.png")
                            backgroundNotTouch.width, backgroundNotTouch.height = display.contentWidth, display.contentHeight
                            backgroundNotTouch.x, backgroundNotTouch.y = CENTER_X, CENTER_Y
                            local  group = display.newGroup()
                            local scrollfunctions = widget.newScrollView({
                                width=display.contentWidth/1.45,
                                height=math.min(display.contentWidth/8*#tableAnswers,display.contentHeight/3),
                                horizontalScrollDisabled=true,
                                isBounceEnabled=false,
                                hideBackground=true,
                            })
                            local xS, yS = scrollProjects:getContentPosition()
                            scrollfunctions.anchorY= 0
                            scrollfunctions.x, scrollfunctions.y = CENTER_X, event.target.block.y+yS+scrollProjects.y-event.target.heightParameters/2+event.target.y
                            scrollfunctions:insert(group)
                            scrollfunctions.xScale, scrollfunctions.yScale, scrollfunctions.alpha = 0.25, 0.25, 0
                            transition.to(scrollfunctions, {time=100, xScale=1, yScale=1, alpha=1, transition=easing.outQuad})

                            local buttonsFunctions = {}
                            local function touchAnswerFunction(event)
                                if (event.phase=="began") then
                                    event.target:setFillColor(55/255,55/255,55/255)
                                elseif (event.phase=="moved" and (math.abs(event.x-event.xStart)>20 or math.abs(event.y-event.yStart)>20)) then
                                    event.target:setFillColor(48/255,48/255,48/255)
                                    scrollfunctions:takeFocus(event)
                                elseif (event.phase=="ended") then
                                    isBlockTouchBlock = false
                                    event.target:setFillColor(48/255,48/255,48/255)
                                    functionOnComplete(event.target.answer)
                                    for i=1, #buttonsFunctions do
                                        buttonsFunctions[i]:removeEventListener("touch", touchAnswerFunction)
                                    end
                                    transition.to(scrollfunctions, {time=200, alpha=0,onComplete=function ()
                                        display.remove(group)
                                        display.remove(scrollfunctions)
                                    end})
                                    display.remove(backgroundNotTouch)
                                end
                                
                                return(true)
                            end
                            isBlockTouchBlock = true
                            for i=1, #tableAnswers do
                                local button = display.newRect(0, display.contentWidth/8*(i-1), scrollfunctions.width, display.contentWidth/8)
                                button.anchorX, button.anchorY = 0,0
                                button:setFillColor(48/255,48/255,48/255)
                                button:addEventListener("touch", touchAnswerFunction)
                                group:insert(button)
                                local header = display.newText(tableAnswers[i][1], display.contentWidth/50, button.y+button.height/2, nil, fontSuze2)
                                header.anchorX = 0
                                group:insert(header)
                                button.answer = tableAnswers[i][2]
                                buttonsFunctions[i] = button
                            end

                            backgroundNotTouch:addEventListener("touch", function(event)
                                if (event.phase=="ended") then
                                    for i=1, #buttonsFunctions do
                                        buttonsFunctions[i]:removeEventListener("touch", touchAnswerFunction)
                                    end
                                    transition.to(scrollfunctions, {time=100, alpha=0,onComplete=function ()
                                        display.remove(group)
                                        display.remove(scrollfunctions)
                                    end})
                                    display.remove(backgroundNotTouch)
                                    isBlockTouchBlock = false
                                end
                                return(true)
                            end)
                        elseif (idParameter=="shapeHitbox") then
                            objectsParameter[3].yScale = 1
                            local file = io.open(system.pathForFile(IDOBJECT.."/images.txt", system.DocumentsDirectory), 'r')
                            local contents = json.decode(file:read("*a"))
                            io.close(file)
                            if (#contents>0) then
                                SCENES[SCENE][1].alpha = 0
                                scene_redactorShapeHitbox(blocks[event.target.block.id][2][event.target.idParameter], objectsParameter[4], contents, blocks)
                            else
                                isBackScene = "block"
                                local function funEditingEnd()
                                    isBackScene = "back"
                                end
                                cerberus.newBannerQuestion(words[524], funEditingEnd)
                            end
                        end
                    end
                    display.getCurrentStage():setFocus(event.target, nil)
                end
                return (true)
            end
        elseif (event.phase=="moved") then
            scrollProjects:takeFocus(event)
        end
    end
--AAAAAAAAAAAAAAAAAAAAA
--AAAAAAAAAAAAAAAAAAAAA
--AAAAAAAAAAAAAAAAAAAAA
--AAAAAAAAAAAAAAAAAAAAA

local isTimerMoveBlock = false
local timerMoveBlock = nil
local yNewMoveSlot = nil
local isTouchBlock = false
touchBlock = function(event)
    if (event.phase=="ended" or event.phase=="cancelled") then
        timer.performWithDelay(0, function()
            display.getCurrentStage():setFocus(event.target, nil)
        end)
    end
    if ((event.phase~="began" or not isMoveBlock) and isBackScene=="back") and (event.phase~="moved" or (math.abs(event.y-event.yStart)>20 or math.abs(event.x-event.xStart)>20)) or event.phase=="ended" then
        print(event.phase)
        if (event.phase=="began") then
            yNewMoveSlot = event.y
            isTouchBlock = true

            if (type(allBlocks[blocks[event.target.id][1]][6])=="boolean") then
                isTimerMoveBlock = true
                timerMoveBlock = timer.performWithDelay(event.autoMove==nil and 200 or 0, function ()
                    
                    local function isPrem()
                        local isPrem = not (funsP["прочитать сс сохранение"]("isPremium")==nil)
                        if (funsP["прочитать сс сохранение"]("blockPrem")~=nil) then
                            return(false)
                        else
                            return(isPrem)
                        end
                    end

                    if (premBlocks[blocks[event.target.id][1]]==nil or isPrem()) then
                    
                    local backgroundAlpha = display.newRect(CENTER_X-display.screenOriginX, 0, display.contentWidth,  math.max(groupSceneScroll.height+display.contentWidth/1.5, (scrollProjects~=nil and scrollProjects.height~=nil and scrollProjects.height or display.contentHeight)))
                    backgroundAlpha:setFillColor(0, 0,0, 0.5)
                    backgroundAlpha.anchorY = 0
                    groupSceneScroll:insert(backgroundAlpha)
                    event.target:toFront()
                    backgroundAlpha:addEventListener("touch", function ()
                        return(true)
                    end)
                    event.target.backgroundAlpha = backgroundAlpha

                    if (allBlocks[blocks[event.target.id][1]][1]=="event") then
                        if (event.autoMove==nil) then 
                            event.target.investBlocks = {}
                            local i = event.target.id+1
                            while (i<=#blocksObjects and allBlocks[blocks[i][1]][1]~="event") do
                                blocksObjects[i].alpha = 0
                                event.target.investBlocks[#event.target.investBlocks+1] = {blocks[i], blocksObjects[i]}
                                table.remove(blocks, i)
                                table.remove(blocksObjects, i)
                            end
                            local yTargetPos = event.target.yGoalPos+event.target.height/2
                            for i = event.target.id+1, #blocksObjects do
                                yTargetPos = yTargetPos+blocksObjects[i].height-display.contentWidth/60
                                blocksObjects[i].id = i
                                blocksObjects[i].yGoalPos = yTargetPos-blocksObjects[i].height/2
                                blocksObjects[i].y = blocksObjects[i].yGoalPos
                            end
                        end

                        local i = 0
                        while (i<#blocksObjects) do
                            i=i+1
                            if (allBlocks[blocks[i][1]][6]==true) then

                                local hideBlock = blocksObjects[i]
                                i = i+1
                                hideBlock.investBlocks = {}
                                local counter = 1
                                while (#hideBlock.investBlocks~=0 and allBlocks[hideBlock.investBlocks[#hideBlock.investBlocks][1][1]][6] ~= "end" or counter~=0) do
                                    if (allBlocks[blocks[i][1]][6] == true) then
                                        counter=counter+1
                                    elseif (allBlocks[blocks[i][1]][6] == "end") then
                                        counter=counter-1
                                    end
                                    blocksObjects[i].alpha = 0
                                    hideBlock.investBlocks[#hideBlock.investBlocks+1] = {blocks[i], blocksObjects[i]}
                                    table.remove(blocks, i)
                                    table.remove(blocksObjects, i)
                                end
                                i=i-1
                            end
                        end
                        local yTargetPos = 0
                        for i=1, #blocksObjects do
                            yTargetPos = yTargetPos+blocksObjects[i].height-display.contentWidth/60
                            blocksObjects[i].id = i
                            blocksObjects[i].yGoalPos = yTargetPos-blocksObjects[i].height/2
                            blocksObjects[i].y = blocksObjects[i].yGoalPos
                        end



                        local endBlock = blocksObjects[#blocksObjects]
                        scrollProjects:setScrollHeight(endBlock.yGoalPos+endBlock.height/2+display.contentWidth/1.5)
                        event.target.backgroundAlpha.height = math.max(endBlock.yGoalPos+endBlock.height/2+display.contentWidth/1.5, scrollProjects.height)
                    end

                    if (allBlocks[blocks[event.target.id][1]][6]==true and event.autoMove==nil) then
                        event.target.investBlocks = {}
                        local i = event.target.id+1
                        local counter = 1
                        while (#event.target.investBlocks~=0 and allBlocks[event.target.investBlocks[#event.target.investBlocks][1][1]][6] ~= "end" or counter~=0) do
                            if (allBlocks[blocks[i][1]][6] == true) then
                                counter=counter+1
                            elseif (allBlocks[blocks[i][1]][6] == "end") then
                                counter=counter-1
                            end
                            blocksObjects[i].alpha = 0
                            event.target.investBlocks[#event.target.investBlocks+1] = {blocks[i], blocksObjects[i]}
                            table.remove(blocks, i)
                            table.remove(blocksObjects, i)
                        end
                        local yTargetPos = event.target.yGoalPos+event.target.height/2
                        for i = event.target.id+1, #blocksObjects do
                            yTargetPos = yTargetPos+blocksObjects[i].height-display.contentWidth/60
                            blocksObjects[i].id = i
                            blocksObjects[i].yGoalPos = yTargetPos-blocksObjects[i].height/2
                            blocksObjects[i].y = blocksObjects[i].yGoalPos
                        end
                        local endBlock = blocksObjects[#blocksObjects]
                        scrollProjects:setScrollHeight(endBlock.yGoalPos+endBlock.height+display.contentWidth/1.5)
                        event.target.backgroundAlpha.height = math.max(endBlock.yGoalPos+endBlock.height+display.contentWidth/1.5, scrollProjects.height)
                    end

                    local xS, yS = scrollProjects:getContentPosition()
                    if (event.autoMove~=nil and event.target.id~=1) then
                        event.target.y = blocksObjects[event.target.id-1].yGoalPos+blocksObjects[event.target.id-1].height/2+event.target.height/2
                    end
                    scrollProjects:scrollToPosition({
                        time=0,
                        y = math.min(math.max((event.autoMove == nil and yS or -event.target.y+scrollProjects.height/2), -event.target.backgroundAlpha.height+scrollProjects.height),0),
                        onComplete = function()

                            isTimerMoveBlock = false
                            isMoveBlock = true
                            timerMoveBlock = timer.performWithDelay(0, function ()
                                local xS, yS = scrollProjects:getContentPosition()
                                if (event.target.y>-yS+scrollProjects.height/2+scrollProjects.height/4 or event.target.y<-yS+scrollProjects.height/2-scrollProjects.height/4) then
                                    local yPlus = nil
                                    if (event.target.y>-yS+scrollProjects.height/2) then
                                        yPlus = event.target.y-(-yS+scrollProjects.height/2+scrollProjects.height/4)
                                    else
                                        yPlus = event.target.y-(-yS+scrollProjects.height/2-scrollProjects.height/4)
                                    end
                                    scrollProjects:scrollToPosition({
                                        time = 0,
                                        y = math.min(math.max(yS-yPlus/5, -event.target.backgroundAlpha.height+scrollProjects.height),0),
                                        onComplete=function ()
                                            touchBlock({["target"]=event.target, ["phase"]="moved", ["id"]=event.id, ["y"]=yNewMoveSlot,
                                                ["yStart"]=yNewMoveSlot-40,
                                            })
                                        end
                                    })

                                end
                            end, 0)

                        end
                    })

                    end
                end)
end
display.getCurrentStage():setFocus(event.target, event.id)
elseif (event.phase=="moved") then

    --if (event.target.isFocus == false) then
    --    event.target.isFocus = nil
    display.getCurrentStage():setFocus(event.target, event.id)
    --end


    if (isTimerMoveBlock) then
        isTimerMoveBlock = false
        timer.cancel(timerMoveBlock)
        scrollProjects:takeFocus(event)
        isTouchBlock = false
    end
    if (type(allBlocks[blocks[event.target.id][1]][6])~="boolean") then
        scrollProjects:takeFocus(event)
    end
    if (isMoveBlock) then
        local xS, yS = scrollProjects:getContentPosition()
        yNewMoveSlot = event.y
        event.target.y = event.y-scrollProjects.y-yS
        local heightBlockScale = event.target.height
        if (event.target.id < #blocks and event.target.y>blocksObjects[event.target.id+1].yGoalPos or event.target.id>(allBlocks[blocks[event.target.id][1]][1]=="block" and 2 or 1) and event.target.y<blocksObjects[event.target.id-1].yGoalPos ) then
            local topOrBottom = (event.target.y>event.target.yGoalPos) and 1 or -1
            local newId = event.target.id + topOrBottom
            local oldId = event.target.id
            local myBlockTable = blocks[oldId]
            local myBlockObject = blocksObjects[oldId]
            table.remove(blocks, oldId)
            table.remove(blocksObjects, oldId)
            table.insert(blocks, newId, myBlockTable)
            table.insert(blocksObjects, newId, myBlockObject)
            local transitionBlock = blocksObjects[oldId]
            transitionBlock.id = oldId
            event.target.id = newId
            transitionBlock.yGoalPos = transitionBlock.yGoalPos-(heightBlockScale-display.contentWidth/60)*topOrBottom
            transition.to(transitionBlock, {time=200, y=transitionBlock.yGoalPos, transition=easing.inOutGuad})
            event.target.yGoalPos = event.target.yGoalPos+(transitionBlock.height-display.contentWidth/60)*topOrBottom
        end


    end
elseif ((event.phase=="ended" or event.phase=="cancelled") and isTouchBlock) then
    isTouchBlock = false
    if (type(allBlocks[blocks[event.target.id][1]][6])=="boolean") then
        local function isPrem()
            local isPrem = not (funsP["прочитать сс сохранение"]("isPremium")==nil)
            if (funsP["прочитать сс сохранение"]("blockPrem")~=nil) then
                return(false)
            else
                return(isPrem)
            end
        end
        if (isTimerMoveBlock and (premBlocks[blocks[event.target.id][1]]==nil or isPrem())) then
            isTimerMoveBlock = false
            timer.cancel(timerMoveBlock)

            local backgroundNoTouch = display.newRect(CENTER_X, CENTER_Y, display.contentWidth, display.contentHeight )
            backgroundNoTouch:setFillColor(0,0,0,0.5)
            backgroundNoTouch.alpha = 0
            SCENES[SCENE][1]:insert(backgroundNoTouch)
            local group = display.newGroup()
            SCENES[SCENE][1]:insert(group)
            group.alpha = 0
            local rect = display.newRect(CENTER_X, CENTER_Y, display.contentWidth/1.1, 0)
            rect.anchorY=0
            rect:setFillColor(66/255,66/255,66/255)
            group:insert(rect)

            local block = createBlock(blocks[event.target.id])
            block.xScale = 1/1.1
            block.yScale = block.xScale
            block.x = 0
            local containerBlock = display.newContainer(display.contentWidth, math.min(block.height*block.yScale,display.contentHeight/5))
            containerBlock.x, containerBlock.y = CENTER_X+display.screenOriginX, CENTER_Y+containerBlock.height/2
            block.y = -containerBlock.height/2+block.height*block.yScale/2
            containerBlock:insert(block)
            group:insert(containerBlock)

            local arrayButtons = {
                {words[261], "copy"},
                {words[262],"delete"},
                {words[blocks[event.target.id][3]=="on" and 263 or 264], "off"},
            }
            local buttons = {}
            local tBlock = event.target
            local funTouchNoTouch = nil
            local function funTouchButton(event)
                if (event.phase == "began") then
                    event.target:setFillColor(72/255,72/255,72/255)
                elseif (event.phase == "moved") then
                    event.target:setFillColor(66/255,66/255,66/255)
                else
                    event.target:setFillColor(66/255,66/255,66/255)

                    if (event.target.nameFunction == "off") then
                        local onOrOff = blocks[tBlock.id][3]
                        blocks[tBlock.id][3] = onOrOff=="on" and "off" or "on"


                        if (onOrOff~="off") then
                            tBlock.image1.fill.effect = "filter.desaturate"
                            tBlock.image1.fill.effect.intensity = 1
                            tBlock.image2.fill.effect = "filter.desaturate"
                            tBlock.image2.fill.effect.intensity = 1
                        else
                            tBlock.image1.fill.effect = nil
                            tBlock.image2.fill.effect = nil
                        end
                        if (allBlocks[blocks[tBlock.id][1]][1]=="event") then
                            local i = tBlock.id+1
                            while (i<=#blocks and allBlocks[blocks[i][1]][1]~="event") do
                                local tBlock = blocksObjects[i]
                                local arBlock = blocks[i]
                                if (onOrOff~="off") then
                                    arBlock[3] = "off"
                                    tBlock.image1.fill.effect = "filter.desaturate"
                                    tBlock.image1.fill.effect.intensity = 1
                                    tBlock.image2.fill.effect = "filter.desaturate"
                                    tBlock.image2.fill.effect.intensity = 1
                                else
                                    arBlock[3] = "on"
                                    tBlock.image1.fill.effect = nil
                                    tBlock.image2.fill.effect = nil
                                end
                                i = i+1
                            end
                        end

                        if (allBlocks[blocks[tBlock.id][1]][6]==true) then
                            local i = tBlock.id
                            local attachments = 1
                            while (allBlocks[blocks[i][1]][6]~="end" or attachments~=0) do
                                i=i+1
                                if (allBlocks[blocks[i][1]][6]==true) then
                                    attachments = attachments+1
                                elseif (allBlocks[blocks[i][1]][6]=="end") then
                                    attachments = attachments-1
                                end
                                local tBlock = blocksObjects[i]
                                local arBlock = blocks[i]
                                if (onOrOff~="off") then
                                    arBlock[3] = "off"
                                    tBlock.image1.fill.effect = "filter.desaturate"
                                    tBlock.image1.fill.effect.intensity = 1
                                    tBlock.image2.fill.effect = "filter.desaturate"
                                    tBlock.image2.fill.effect.intensity = 1
                                else
                                    arBlock[3] = "on"
                                    tBlock.image1.fill.effect = nil
                                    tBlock.image2.fill.effect = nil
                                end
                            end

                        end
                        funsP["записать сохранение"](IDOBJECT.."/scripts", json.encode(blocks))
                    elseif (event.target.nameFunction == "delete") then
                        local idBlock = tBlock.id
                        local isEvent = allBlocks[blocks[idBlock][1]][1]=="event"
                        local isAttachments = allBlocks[blocks[idBlock][1]][6]==true
                        table.remove(blocks, idBlock)
                        table.remove(blocksObjects, idBlock)

                        if (isEvent) then
                            local i = idBlock
                            while (i<=#blocks and allBlocks[blocks[i][1]][1]~="event") do
                                table.remove(blocks, i)
                                local block = blocksObjects[i]
                                table.remove(blocksObjects, i)
                                display.remove(block)
                            end
                        end
                        if (isAttachments) then
                            local i = idBlock
                            local attachments = 1
                            while (attachments~=0) do
                                if (allBlocks[blocks[i][1]][6]==true) then
                                    attachments = attachments+1
                                elseif (allBlocks[blocks[i][1]][6]=="end") then
                                    attachments = attachments-1
                                end
                                table.remove(blocks, i)
                                local block = blocksObjects[i]
                                table.remove(blocksObjects, i)
                                display.remove(block)
                            end
                        end

                        display.remove(tBlock)
                        local yTargetPos = idBlock==1 and 0 or blocksObjects[idBlock-1].yGoalPos+blocksObjects[idBlock-1].height/2
                        for i=idBlock, #blocks do
                            local block = blocksObjects[i]
                            block.id = i
                            yTargetPos = yTargetPos+block.height-display.contentWidth/60
                            block.yGoalPos = yTargetPos-block.height/2
                            block.y = block.yGoalPos
                        end
                        funsP["записать сохранение"](IDOBJECT.."/scripts", json.encode(blocks))

                        local xS, yS = scrollProjects:getContentPosition()
                        scrollProjects:setScrollHeight(groupSceneScroll.height+display.contentWidth/1.5)
                        if (-yS+scrollProjects.height>groupSceneScroll.height+display.contentWidth/1.5) then
                            scrollProjects:scrollToPosition({
                                time=0,
                                y=-math.max(groupSceneScroll.height-scrollProjects.height+display.contentWidth/1.5,0)
                            })
                        end

                    elseif (event.target.nameFunction == "copy") then

                        isBlockTouchBlock = true
                        local idBlock = tBlock.id
                        local tableBlock = json.decode(json.encode(blocks[idBlock]))
                        local block = createBlock(tableBlock)
                        if (tableBlock[3]=="off") then
                            block.image1.fill.effect = "filter.desaturate"
                            block.image1.fill.effect.intensity = 1
                            block.image2.fill.effect = "filter.desaturate"
                            block.image2.fill.effect.intensity = 1
                        end
                        block.yGoalPos = tBlock.yGoalPos
                        block.y = tBlock.yGoalPos
                        block.id = idBlock
                        groupSceneScroll:insert(block)
                        table.insert(blocks, idBlock, tableBlock)
                        table.insert(blocksObjects, idBlock, block)
                        block:addEventListener("touch", touchBlock)
                        for i=1, #block.cells do
                            block.cells[i][2]:addEventListener("touch",touchParameter)
                        end

                        local idOldBlock = tBlock.id+1
                        if (allBlocks[blocks[idOldBlock][1]][1]=="event") then
                            block.investBlocks = {}
                            local i = idOldBlock+1
                            while (i<=#blocks and allBlocks[blocks[i][1]][1]~="event") do
                                local mTableBlock = json.decode(json.encode(blocks[i]))
                                local mBlock = createBlock(mTableBlock)
                                if (mTableBlock[3]=="off") then
                                    mBlock.image1.fill.effect = "filter.desaturate"
                                    mBlock.image1.fill.effect.intensity = 1
                                    mBlock.image2.fill.effect = "filter.desaturate"
                                    mBlock.image2.fill.effect.intensity = 1
                                end
                                mBlock.alpha = 0
                                mBlock:addEventListener("touch", touchBlock)
                                groupSceneScroll:insert(mBlock)
                                for i=1, #mBlock.cells do
                                    mBlock.cells[i][2]:addEventListener("touch",touchParameter)
                                end
                                block.investBlocks[#block.investBlocks+1] = {mTableBlock, mBlock}
                                i = i+1
                            end

                        end

                        local yTargetPos = block.y+block.height/2
                        for i=idBlock+1, #blocks do
                            local block = blocksObjects[i]
                            block.id = i
                            yTargetPos = yTargetPos+block.height-display.contentWidth/60
                            block.yGoalPos = yTargetPos-block.height/2
                            block.y = block.yGoalPos
                        end

                        if (allBlocks[blocks[idOldBlock][1]][6]==true) then
                            block.investBlocks = {}
                            local i = idOldBlock+1
                            local attachments = 1
                            while (attachments~=0) do
                                if (allBlocks[blocks[i][1]][6]==true) then
                                    attachments = attachments+1
                                elseif (allBlocks[blocks[i][1]][6]=="end") then
                                    attachments = attachments-1
                                end
                                local mTableBlock = json.decode(json.encode(blocks[i]))
                                local mBlock = createBlock(mTableBlock)
                                if (mTableBlock[3]=="off") then
                                    mBlock.image1.fill.effect = "filter.desaturate"
                                    mBlock.image1.fill.effect.intensity = 1
                                    mBlock.image2.fill.effect = "filter.desaturate"
                                    mBlock.image2.fill.effect.intensity = 1
                                end
                                mBlock.alpha = 0
                                mBlock:addEventListener("touch", touchBlock)
                                groupSceneScroll:insert(mBlock)
                                for i=1, #mBlock.cells do
                                    mBlock.cells[i][2]:addEventListener("touch",touchParameter)
                                end
                                block.investBlocks[#block.investBlocks+1] = {mTableBlock, mBlock}
                                i = i+1
                            end

                        end

                        local yTargetPos = block.y+block.height/2
                        for i=idBlock+1, #blocks do
                            local block = blocksObjects[i]
                            block.id = i
                            yTargetPos = yTargetPos+block.height-display.contentWidth/60
                            block.yGoalPos = yTargetPos-block.height/2
                            block.y = block.yGoalPos
                        end

                        local xS, yS = scrollProjects:getContentPosition()
                        touchBlock({
                            ["target"] = block,
                            ["phase"] = "began",
                            ["y"] = block.y+yS+scrollProjects.y,
                            ["autoMove"]=true
                        })
                    end
                    funTouchNoTouch({["target"]=backgroundNoTouch, ["phase"]="ended"})
                end
                return(true)
            end
            for i=1, #arrayButtons do
                button = display.newRect(rect.x, containerBlock.y+containerBlock.height/2+display.contentWidth/8*(i-0.5), rect.width, display.contentWidth/8)
                button.nameFunction = arrayButtons[i][2]
                button:setFillColor(66/255,66/255,66/255)
                button:addEventListener("touch", funTouchButton)
                group:insert(button)
                local header = display.newText(arrayButtons[i][1], button.x-button.width/2.3, button.y, nil, fontSize1/1.1 )
                header.anchorX = 0
                group:insert(header)
                buttons[i] = button
            end


            rect.height = group.height+display.contentWidth/40
            group.y = -rect.height/2
            funTouchNoTouch = function (event)
                if (event.phase=="ended" and event.target==backgroundNoTouch ) then
                    backgroundNoTouch:removeEventListener("touch",funTouchNoTouch)
                    rect:removeEventListener("touch",funTouchNoTouch)
                    for i=1, #buttons do
                        buttons[i]:removeEventListener("touch",funTouchButton)
                    end
                    transition.to(group, {time=200, alpha=0, onComplete=function ()
                        display.remove(group)
                    end})
                    transition.to(backgroundNoTouch, {time=200, alpha=0, transition=function()
                        display.remove(backgroundNoTouch)
                    end})
                end
                return(true)
            end
            rect:addEventListener("touch", funTouchNoTouch)
            transition.to(group, {time=100, alpha=1})
            backgroundNoTouch:addEventListener("touch", funTouchNoTouch)
            transition.to(backgroundNoTouch, {time=100, alpha=1})
        elseif (isTimerMoveBlock) then
            isTimerMoveBlock = false
            timer.cancel(timerMoveBlock)
            if (premBlocks[blocks[event.target.id][1]]~=nil and not isPrem()) then
                bannerPremium(groupScene)
            end
        else
            local oldYPosBlock = event.target.y
            event.target.y = event.target.yGoalPos


            isMoveBlock = false
            timer.cancel(timerMoveBlock)
            display.remove(event.target.backgroundAlpha)

            if (event.target.investBlocks~=nil) then
                local setId = event.target.id
                local yTargetPos = event.target.yGoalPos+event.target.height/2
                for i=1, #event.target.investBlocks do
                    local block = event.target.investBlocks[i]
                    setId = setId+1
                    table.insert(blocks, setId, block[1])
                    table.insert(blocksObjects, setId, block[2])
                    block[2].alpha, block[2].id =1, setId
                    yTargetPos = yTargetPos+block[2].height-display.contentWidth/60
                    block[2].yGoalPos = yTargetPos-block[2].height/2
                    block[2].y = block[2].yGoalPos
                end
                event.target.investBlocks =nil


                if (allBlocks[blocks[event.target.id][1]][1]=="event") then
                    local i = 0
                    while (i<#blocks) do
                        i = i+1
                        local showBlock = blocksObjects[i]
                        if (showBlock.investBlocks~=nil) then
                            local setId = i
                            for i=1, #showBlock.investBlocks do
                                local block = showBlock.investBlocks[i]
                                setId = setId+1
                                table.insert(blocks, setId, block[1])
                                table.insert(blocksObjects, setId, block[2])
                                block[2].alpha, block[2].id =1, setId
                                yTargetPos = yTargetPos+block[2].height-display.contentWidth/60
                                block[2].yGoalPos = yTargetPos-block[2].height/2
                                block[2].y = block[2].yGoalPos
                            end
                            showBlock.investBlocks = nil
                        end
                    end
                    yTargetPos = 0
                end
                for i=(yTargetPos==0) and 1 or setId+1, #blocksObjects do
                    local block = blocksObjects[i]
                    block.id = i
                    yTargetPos = yTargetPos+block.height-display.contentWidth/60
                    block.yGoalPos = yTargetPos-block.height/2
                    transition.cancel(block)
                    block.y = block.yGoalPos
                end
                scrollProjects:setScrollHeight(groupSceneScroll.height+display.contentWidth/1.5)
            end

            local xS, yS = scrollProjects:getContentPosition()
            local ysdv = event.y-scrollProjects.y- scrollProjects.height/2
            scrollProjects:scrollToPosition({
                time=0,
                y = math.min(math.max( -event.target.y+scrollProjects.height/2+ysdv, -(groupSceneScroll.height+display.contentWidth/1.5)),0)
            })
            funsP["записать сохранение"](pathObject.."/scripts", json.encode(blocks))
        end
        display.getCurrentStage():setFocus(event.target, nil)
        isBlockTouchBlock = false
    end
else
    isBlockTouchBlock = false
    display.getCurrentStage():setFocus(event.target, nil)
    if (isTimerMoveBlock) then
        isTimerMoveBlock = false
        timer.cancel(timerMoveBlock)
    end
end
end
return true
end


for i=1, #blocks do
    local block = createBlock(blocks[i])
    if (blocks[i][3]=="off") then
        block.image1.fill.effect = "filter.desaturate"
        block.image1.fill.effect.intensity = 1
        block.image2.fill.effect = "filter.desaturate"
        block.image2.fill.effect.intensity = 1
    end
    yTargetPos = yTargetPos+block.height-display.contentWidth/60
    block.y= yTargetPos-block.height/2
    block.yGoalPos = block.y
    block.id = i
    blocksObjects[i] = block
    groupSceneScroll:insert(block)
    block:addEventListener("touch", touchBlock)

    for i=1, #block.cells do
        block.cells[i][2]:addEventListener("touch",touchParameter)
    end
end
scrollProjects:setScrollHeight(groupSceneScroll.height+display.contentWidth/1.5)

local functionsMenu = {}

local arrayAllButtonsFunctions = {
    ["back"]={"back","startmenu",{{5,"delete"},{265,"off"}}},
}
arrayAllButtonsFunctions["startmenu"] = arrayAllButtonsFunctions["back"]

functionsMenu["checkoff"] = function()
isBackScene="back"
topBarArray[3].text = headerBar
topBarArray[4].alpha = 1
topBarArray[5].alpha = 0
switchBar.alpha=1
switchBarRect.alpha=1
scrollProjects.y = switchBar.y+switchBar.height
for i=1, #blocks do
    local block = blocksObjects[i]
    block.alpha = 1
    block.x = CENTER_X
    if (block.checkbox~=nil) then
        display.remove(block.checkbox)
    end
    if (block.isCheck) then
        blocks[i][3] = blocks[i][3] == "on" and "off" or "on"
        if (blocks[i][3]=="off") then
            block.image1.fill.effect = "filter.desaturate"
            block.image1.fill.effect.intensity = 1
            block.image2.fill.effect = "filter.desaturate"
            block.image2.fill.effect.intensity = 1
        else
            block.image1.fill.effect = nil
            block.image2.fill.effect = nil
        end
    end
    block.isCheck = nil
end
funsP["записать сохранение"](IDOBJECT.."/scripts", json.encode(blocks))
end

functionsMenu["checkdelete"] = function()
isBackScene="back"
topBarArray[3].text = headerBar
topBarArray[4].alpha = 1
topBarArray[5].alpha = 0
switchBar.alpha=1
switchBarRect.alpha=1
scrollProjects.y = switchBar.y+switchBar.height
local yTargetPos = 0
local iMinus = 0
for i2=1, #blocks do
    local i = i2-iMinus
    local block = blocksObjects[i]
    block.x = CENTER_X
    if (block.checkbox~=nil) then
        display.remove(block.checkbox)
    end
    if (block.isCheck) then
        table.remove(blocks, i)
        table.remove(blocksObjects, i)
        display.remove(block)
        iMinus = iMinus+1
    else
        yTargetPos = yTargetPos+block.height-display.contentWidth/60
        block.id = i
        block.yGoalPos = yTargetPos-block.height/2
        block.y = block.yGoalPos
    end
end
funsP["записать сохранение"](IDOBJECT.."/scripts", json.encode(blocks))
local xS, yS = scrollProjects:getContentPosition()
scrollProjects:setScrollHeight(groupSceneScroll.height+display.contentWidth/1.5)
if (-yS+scrollProjects.height>groupSceneScroll.height+display.contentWidth/1.5) then
    scrollProjects:scrollToPosition({
        time=0,
        y=-math.max(groupSceneScroll.height-scrollProjects.height+display.contentWidth/1.5,0)
    })
end
end

local function touchCheckboxBlock(event)
    if (event.phase=="began") then
        display.getCurrentStage():setFocus(event.target, event.id)
    elseif (event.phase=="moved") then
        scrollProjects:takeFocus(event)
    elseif (event.target.alpha>0.9) then
        if (event.target.block.isCheck==true) then
            event.target.block.isCheck = nil
        else
            event.target.block.isCheck = true
        end
        event.target.fill = {
            type="image",
            filename="images/checkbox_"..(event.target.block.isCheck and 2 or 1)..".png",
        }
        if (event.target.block.isCheck) then 
            event.target:setFillColor(171/255, 219/255, 241/255)
        end

        local block = event.target.block
        if (allBlocks[blocks[block.id][1]][1]=="event") then
            local isCheck = event.target.block.isCheck
            local i = block.id+1
            while (i<=#blocks and allBlocks[blocks[i][1]][1]~="event") do
                local block = blocksObjects[i]
                block.isCheck = isCheck
                local isBoolean = type(allBlocks[blocks[i][1]][6])=="boolean"
                if (isCheck) then
                    block.alpha = 0.75
                    if (isBoolean) then
                        block.checkbox.alpha = 0.25
                    end
                else
                    block.alpha = 1
                    if (isBoolean) then
                        block.checkbox.alpha = 1
                    end
                end
                if (isBoolean) then
                    block.checkbox.fill = {
                        type="image",
                        filename="images/checkbox_"..(isCheck and 2 or 1)..".png",
                    }
                    if (isCheck) then 
                        block.checkbox:setFillColor(171/255, 219/255, 241/255)
                    end
                end
                i=i+1
            end
        end
        if (allBlocks[blocks[block.id][1]][6]==true) then
            local isCheck = event.target.block.isCheck
            local i = block.id
            local attachments = 1
            while (allBlocks[blocks[i][1]][6]~="end" or attachments~=0) do
                i = i+1
                if (allBlocks[blocks[i][1]][6]==true) then
                    attachments = attachments+1
                elseif (allBlocks[blocks[i][1]][6]=="end") then
                    attachments = attachments-1
                end
                local block = blocksObjects[i]
                block.isCheck = isCheck
                local isBoolean = type(allBlocks[blocks[i][1]][6])=="boolean"
                if (isCheck) then
                    block.alpha = 0.75
                    if (isBoolean) then
                        block.checkbox.alpha = 0.25
                    end
                else
                    block.alpha = 1
                    if (isBoolean) then
                        block.checkbox.alpha = 1
                    end
                end
                if (isBoolean) then
                    block.checkbox.fill = {
                        type="image",
                        filename="images/checkbox_"..(isCheck and 2 or 1)..".png",
                    }
                    if (isCheck) then 
                        block.checkbox:setFillColor(171/255, 219/255, 241/255)
                    end
                end

            end
        end

        display.getCurrentStage():setFocus(event.target, nil)
    end
    return(true)
end

functionsMenu["startdelete"] = function()
if (#blocks==0) then
    funsP["вызвать уведомление"](words[12])
    isBackScene="back"
else
    local arrayHeaders = {
        copy=4,
        delete=5,
        off=265
    }
    topBarArray[3].text = words[arrayHeaders[isBackScene]]
    topBarArray[4].alpha = 0
    topBarArray[5].alpha = 1
    topBarArray[5].x = topBarArray[4].x
    topBarArray[5].circleTouch.x = topBarArray[4].x
    switchBar.alpha=0
    switchBarRect.alpha=0
    scrollProjects.y = switchBar.y
    for i=1, #blocks do
        local block = blocksObjects[i]
        block.x = block.x+display.contentWidth/10
        if (type(allBlocks[blocks[i][1]][6])=="boolean") then
            block.checkbox = display.newImage("images/checkbox_1.png")
            block.checkbox.width, block.checkbox.height = display.contentWidth/20, display.contentWidth/20
            block.checkbox.x, block.checkbox.y = display.contentWidth/20, block.y
            block.isCheck = nil
            block.checkbox.block = block
            block.checkbox:addEventListener("touch", touchCheckboxBlock)
            groupSceneScroll:insert(block.checkbox)
        end
    end
end
end

functionsMenu["back"] = function()
isBackScene = arrayAllButtonsFunctions[isBackScene][2]
local notVisibleRect = display.newImage("images/notVisible.png")
notVisibleRect.x, notVisibleRect.y, notVisibleRect.width, notVisibleRect.height = CENTER_X, CENTER_Y, display.contentWidth, display.contentHeight

local groupMenu = display.newGroup()
groupMenu.x, groupMenu.y = display.contentWidth/1.02, CENTER_Y-display.contentHeight/2+(display.contentWidth-display.contentWidth/1.02)

groupMenu.xScale, groupMenu.yScale, groupMenu.alpha = 0.3, 0.3, 0

local arrayButtonsFunctions = arrayAllButtonsFunctions[isBackScene][3]
local buttons = {}
local buttonContainer = display.newContainer(display.contentWidth/1.8, display.contentWidth/7)
buttonContainer.anchorX, buttonContainer.anchorY = 1, 0
SCENES[SCENE][1]:insert(buttonContainer)
local buttonCircle = display.newCircle(0,0,buttonContainer.width/2)
buttonCircle:setFillColor(1,1,1,0.25)
buttonCircle.xScale, buttonCircle.yScale, buttonCircle.alpha = 0.25, 0.25, 0
buttonContainer:insert(buttonCircle)

local function touchTypeFunction(event)
    if (event.phase=="began") then
        buttonContainer:toFront()
        buttonContainer.y = event.target.y
        transition.to(buttonCircle, {time=150, xScale=1.1, yScale=1.1, alpha=1})
    elseif (event.phase=="moved") then
        transition.to(buttonCircle, {time=150, xScale=0.25, yScale=0.25, alpha=0})
    else
        isBackScene = event.target.typeFunction
        functionsMenu["start"..isBackScene]()
        for i=1, #buttons do
            buttons[i]:removeEventListener("touch", touchTypeFunction)
        end
        display.remove(notVisibleRect)
        transition.to(groupMenu, {time=200, alpha=0, onComolete=function ()
            display.remove(groupMenu)
        end})
    end
    return(true)
end

for i=1, #arrayButtonsFunctions do
    buttons[i] = display.newRect(0, display.contentWidth/7*(i-1), display.contentWidth/1.5, display.contentWidth/7)
    buttons[i].anchorX, buttons[i].anchorY = 1, 0
    buttons[i]:setFillColor(48/255, 48/255, 48/255)
    groupMenu:insert(buttons[i])
    buttons[i].typeFunction = arrayButtonsFunctions[i][2]
    buttons[i]:addEventListener("touch",touchTypeFunction)

    buttons[i].header = display.newText(words[arrayButtonsFunctions[i][1]], -buttons[i].width/1.1, buttons[i].y+buttons[i].height/2, nil, fontSize1)
    buttons[i].header.anchorX=0
    groupMenu:insert(buttons[i].header)

end

transition.to(groupMenu, {time=150, xScale=1, yScale=1, alpha=1, transition=easing.outQuad})

notVisibleRect:addEventListener("touch", function (event)
    if (event.phase=="ended") then
        isBackScene = arrayAllButtonsFunctions[isBackScene][1]
        display.remove(notVisibleRect)
        for i=1, #buttons do
            buttons[i]:removeEventListener("touch", touchTypeFunction)
        end
        transition.to(groupMenu, {time=200, alpha=0, onComolete=function ()
            display.remove(groupMenu)
        end})
    end
    return(true)
end)
end
functionsMenu["startoff"] = functionsMenu["startdelete"]


funMenuObjects[1] = function ()
if ( not isBlockTouchBlock) then
    functionsMenu[isBackScene]()
end
end
funCheckObjects[1] = function ()
functionsMenu["check"..isBackScene]()
end
funBackObjects[1] = function ()
if ( not isBlockTouchBlock and isBackScene~="block") then
    if (isBackScene == "back") then
        display.remove(groupSceneScroll)
        display.remove(groupScene)
        scene_objects(infoSceneObjects[1],infoSceneObjects[2],infoSceneObjects[3])
    else
        for i=1, #blocks do
            blocksObjects[i].isCheck = nil
            blocksObjects[i].alpha = 1
        end
        functionsMenu["check"..isBackScene]()
    end
end
end

funAddBlock = function (blockTable)
    if (#blockTable==1) then
        blockTable[2] = {}
    end
    blockTable[3]="on"

    for i=1, #blockTable[2] do
        if (blockTable[2][i][1]=="function") then
            local arrFunctions = json.decode(funsP["получить сохранение"](IDSCENE.."/functions"))
            local idFunction = blockTable[2][i][2]
            for i=1, #arrFunctions do
                if (arrFunctions[i][1]==idFunction) then
                    arrFunctions[i][3] = arrFunctions[i][3]+1
                    break
                end
            end
            funsP["записать сохранение"](IDSCENE.."/functions", json.encode(arrFunctions))
            break
        end
    end

    local tableReplacementBlocks = {
        ["ifElse (2)"]={"if", { {{"number",1},{"function","<"},{"number",2}} }, "on"},
        ["if (2)"]={"if", { {{"number",1},{"function","<"},{"number",2}} }, "on"},
    }
    local originalName = blockTable[1]
    if (tableReplacementBlocks[blockTable[1]] ~= nil) then
        blockTable = tableReplacementBlocks[blockTable[1]]
    end
    local function funAdditionallyBlock(event)
        local answer = {}
        for i = 1, #event do
            local block = createBlock(event[i])
            for i2=1, #block.cells do
                block.cells[i2][2]:addEventListener("touch",touchParameter)
            end
            groupSceneScroll:insert(block)
            block.alpha = 0
            answer[i] = {event[i], block}
        end
        return(answer)
    end
    local tableInvestBlocks = json.decode(json.encode(additionallyBlocks))

    if (#blocksObjects==0 and allBlocks[blockTable[1]][1]~="event") then
        local startBlock = createBlock({"start",{}})
        startBlock.yGoalPos = startBlock.height/2-display.contentWidth/60
        startBlock.y = startBlock.yGoalPos
        startBlock.id = 1
        startBlock:addEventListener("touch", touchBlock)
        for i=1, #startBlock.cells do
            startBlock.cells[i][2]:addEventListener("touch",touchParameter)
        end
        groupSceneScroll:insert(startBlock)
        blocks[1] = {"start", {},"on"}
        blocksObjects[1] = startBlock
    end
    local block = createBlock(blockTable)
    for i=1, #block.cells do
        block.cells[i][2]:addEventListener("touch",touchParameter)
    end
    block.investBlocks = allBlocks[originalName][1]=="event" and {} or tableInvestBlocks[originalName]~=nil and funAdditionallyBlock(tableInvestBlocks[originalName]) or nil
    groupSceneScroll:insert(block)
    if (#blocksObjects==1 and allBlocks[blockTable[1]][1]~="event") then
        block.y = blocksObjects[1].y+blocksObjects[1].height/2+block.height/2-display.contentWidth/60
        block.yGoalPos = block.y
        block.id = 2
        blocksObjects[2] = block
        blocks[2] = blockTable
        block:addEventListener("touch", touchBlock)
        
        if (block.investBlocks~=nil) then
            for i=1, #block.investBlocks do
                local blockTable = block.investBlocks[i][1]
                local block = block.investBlocks[i][2]
                block.y = blocksObjects[#blocksObjects].y+blocksObjects[#blocksObjects].height/2+block.height/2-display.contentWidth/60
                block.alpha = 1
                block.yGoalPos = block.y
                block.id = #blocksObjects+1
                blocksObjects[block.id] = block
                blocks[block.id] = blockTable
                block:addEventListener("touch", touchBlock)
            end
        end
        block.investBlocks = nil
        funsP["записать сохранение"](pathObject.."/scripts", json.encode(blocks))
    elseif (#blocksObjects==0 and allBlocks[blockTable[1]][1]=="event") then
        block.y = block.height/2-display.contentWidth/60
        block.yGoalPos = block.y
        block.id = 1
        blocks[1] = blockTable
        blocksObjects[1] = block
        block:addEventListener("touch", touchBlock)
        funsP["записать сохранение"](pathObject.."/scripts", json.encode(blocks))
    else
-- разместить блок (старт)
local xS, yS = scrollProjects:getContentPosition()
local i = 1
local countNesting = 0
while (i<=#blocks and (blocksObjects[i].y<-yS+scrollProjects.height/2 or countNesting~=0)) do
    if (allBlocks[blocks[i][1]][6]==true) then
        countNesting = countNesting+1
    elseif (allBlocks[blocks[i][1]][6]=="end") then
        countNesting = countNesting-1
    end
    i=i+1
end

block.y = blocksObjects[i-1].y+blocksObjects[i-1].height/2-display.contentWidth/60+block.height/2
block.yGoalPos = block.y
table.insert(blocks, i, blockTable)
table.insert(blocksObjects, i, block)
block.id = i
block:addEventListener("touch", touchBlock)

local yTargetPos = block.y+block.height/2
for i=i+1, #blocksObjects do
    local block = blocksObjects[i]
    yTargetPos = yTargetPos+block.height-display.contentWidth/60
    block.id = i
    block.y = yTargetPos-block.height/2
    block.yGoalPos = block.y
end



isBlockTouchBlock = true
block.isFocus = false
touchBlock({
    ["target"] = block,
    ["phase"] = "began",
    ["y"] = block.y+yS+scrollProjects.y,
    ["autoMove"]=true
})
-- разместить блок (конец)
end
scrollProjects:setScrollHeight(groupSceneScroll.height+display.contentWidth/1.5)
end

end
compartmentScripts()

local function compartmentImages()
    local groupSceneScroll = display.newGroup()
    scrollProjects:insert(groupSceneScroll)
    SCENES[SCENE][2] = groupSceneScroll
    local images = json.decode(funsP["получить сохранение"](IDOBJECT.."/images"))
    local arraySlots = {}

    local function touchMenuSlot(event)
        if (event.phase=="began") then
            display.getCurrentStage():setFocus(event.target, event.id)
        elseif (event.phase=="moved") then
            scrollProjects:takeFocus(event)
        else
            display.getCurrentStage():setFocus(event.target, nil)

            isBackScene="block"

            local notVisibleRect = display.newImage("images/notVisible.png")
            notVisibleRect.x, notVisibleRect.y, notVisibleRect.width, notVisibleRect.height = CENTER_X, CENTER_Y, display.contentWidth, display.contentHeight

            local xPosScroll, yPosScroll = scrollProjects:getContentPosition()
            local groupMenu = display.newGroup()
            groupMenu.x, groupMenu.y = display.contentWidth, event.target.slot.myGroup.y+event.target.height/1.25+yPosScroll+switchBar.height

            groupMenu.xScale, groupMenu.yScale, groupMenu.alpha = 0.3, 0.3, 0

            local arrayButtonsFunctions = {{5, "delete"}, {6, "rename"}}

            local buttons = {}
            local buttonContainer = display.newContainer(display.contentWidth/1.8, display.contentWidth/7)
            buttonContainer.anchorX, buttonContainer.anchorY = 1, 0
            groupMenu:insert(buttonContainer)
            local buttonCircle = display.newCircle(0,0,buttonContainer.width/2)
            buttonCircle:setFillColor(1,1,1,0.25)
            buttonCircle.xScale, buttonCircle.yScale, buttonCircle.alpha = 0.25, 0.25, 0
            buttonContainer:insert(buttonCircle)

            local eventTargetMenu = event.target
            local function touchTypeFunction(event)
                print(1)
                if (event.phase=="began") then
                    buttonContainer:toFront()
                    buttonContainer.y = event.target.y
                    transition.to(buttonCircle, {time=150, xScale=1.1, yScale=1.1, alpha=1})
                elseif (event.phase=="moved") then
                    transition.to(buttonCircle, {time=150, xScale=0.25, yScale=0.25, alpha=0})
                else

                    isBackScene="back"

                    if (event.target.typeFunction == "delete") then
                        local idSlot = eventTargetMenu.slot.idSlot
                        os.remove(system.pathForFile(IDOBJECT.."/image_"..images[idSlot][2]..".png", system.DocumentsDirectory))
                        table.remove(images, idSlot)
                        table.remove(arraySlots, idSlot)
                        display.remove(eventTargetMenu.slot.myGroup)
                        for i=1, #images do
                            local slot = arraySlots[i]
                            slot.yGoalPos = display.contentWidth/3.75*(i-0.5)
                            slot.myGroup.y = slot.yGoalPos
                            slot.idSlot = i
                        end
                        funsP["записать сохранение"](IDOBJECT.."/images", json.encode(images))
                    elseif (event.target.typeFunction == "rename") then
                        local function isCorrectValue(value)
                            if (string.len(value)==0) then
                                return(words[18])
                            else
                                local isCorrect = true
                                for i=1, #images do
                                    if (images[i][1]==value) then
                                        isCorrect=false
                                        break
                                    end
                                end
                                return(isCorrect and "" or words[15])
                            end
                        end
                        local slot = eventTargetMenu.slot
                        cerberus.newInputLine(words[268], words[269], isCorrectValue, images[slot.idSlot][1], function(answer)
                            if (answer.isOk) then
                                answer.value = string.gsub(answer.value, (isWin and '\r\n' or '\n'), " ")
                                slot.nameProject.text = answer.value
                                images[slot.idSlot][1] = answer.value
                                funsP["записать сохранение"](IDOBJECT.."/images", json.encode(images))
                            end
                        end)
                    end

                    for i=1, #buttons do
                        buttons[i]:removeEventListener("touch", touchTypeFunction)
                    end
                    display.remove(notVisibleRect)
                    transition.to(groupMenu, {time=200, alpha=0, onComplete=function ()
                        display.remove(groupMenu)
                    end})
                end
                return(true)
            end

            for i=1, #arrayButtonsFunctions do
                buttons[i] = display.newRect(0, display.contentWidth/7*(i-1), display.contentWidth/1.8, display.contentWidth/7)
                buttons[i].anchorX, buttons[i].anchorY = 1, 0
                buttons[i]:setFillColor(48/255, 48/255, 48/255)
                groupMenu:insert(buttons[i])
                buttons[i].typeFunction = arrayButtonsFunctions[i][2]
                buttons[i]:addEventListener("touch",touchTypeFunction)

                buttons[i].header = display.newText(words[arrayButtonsFunctions[i][1]], -buttons[i].width/1.1, buttons[i].y+buttons[i].height/2, nil, fontSize1)
                buttons[i].header.anchorX=0
                groupMenu:insert(buttons[i].header)

            end

            transition.to(groupMenu, {time=150, xScale=1, yScale=1, alpha=1, transition=easing.outQuad})

            notVisibleRect:addEventListener("touch", function (event)
                if (event.phase=="ended") then
                    isBackScene="back"
                    display.remove(notVisibleRect)
                    for i=1, #buttons do
                        buttons[i]:removeEventListener("touch", touchTypeFunction)
                    end
                    transition.to(groupMenu, {time=200, alpha=0, onComplete=function ()
                        display.remove(groupMenu)
                    end})
                end
                return(true)
            end)


        end
        return(true)
    end
    local timerMoveSlot = nil
    local isTimerMoveSlot = false
    local isMoveSlot = false
    local function touchOpenImage(event)
        if (event.phase == "began") then
            event.target:setFillColor(23/255,91/255,114/255)
            display.getCurrentStage():setFocus(event.target, event.id)
            isTimerMoveSlot = true
            timerMoveSlot = timer.performWithDelay(250, function ()
                isTimerMoveSlot = false
                isMoveSlot = true
                event.target.myGroup:toFront()
            end)
        elseif (event.phase=="moved") then
            if (isTimerMoveSlot) then
                isTimerMoveSlot = false
                timer.cancel(timerMoveSlot)
                event.target:setFillColor(0, 71/255, 93/255)
                scrollProjects:takeFocus(event)
            end
            if (isMoveSlot) then
                local xS, yS = scrollProjects:getContentPosition()
                local group = event.target.myGroup
                local button = event.target
                group.y = event.y-scrollProjects.y-yS
                local newId = nil
                if (group.y>button.yGoalPos+button.height/2 and button.idSlot<#images) then
                    newId = 1
                elseif (group.y<button.yGoalPos-button.height/2 and button.idSlot>1) then
                    newId = -1
                end
                if (newId~=nil) then
                    local tableImage = images[button.idSlot]
                    local transitionImage = arraySlots[button.idSlot+newId]
                    table.remove(images, button.idSlot)
                    table.remove(arraySlots, button.idSlot)
                    table.insert(images, button.idSlot+newId, tableImage)
                    table.insert(arraySlots, button.idSlot+newId, button)
                    transitionImage.yGoalPos = transitionImage.yGoalPos-transitionImage.height*newId
                    transitionImage.idSlot = transitionImage.idSlot-newId
                    transition.to(transitionImage.myGroup, {y=transitionImage.yGoalPos, time=200, transition=easing.outQuad})
                    button.idSlot = button.idSlot+newId
                    button.yGoalPos = button.yGoalPos+button.height*newId
                end
            end
        else
            event.target:setFillColor(0, 71/255, 93/255)
            display.getCurrentStage():setFocus(event.target, nil)
            if (isTimerMoveSlot) then
                isTimerMoveSlot = false
                timer.cancel(timerMoveSlot)
                groupScene.alpha = 0
                scene_viewsprite(event.target.pathImage, event.target.nameProject.text)
                -- на объект нажали
            end
            if (isMoveSlot) then
                isMoveSlot=false
                event.target.myGroup.y = event.target.yGoalPos
                funsP["записать сохранение"](IDOBJECT.."/images", json.encode(images))
            end
        end
        return(true)
    end

    for i=1, #images do
        local group = display.newGroup()
        group.y = display.contentWidth/3.75*(i-0.5)
        groupSceneScroll:insert(group)
        local buttonRect = display.newRect(0, 0, display.contentWidth, display.contentWidth/3.75)
        arraySlots[i] = buttonRect
        buttonRect.idProject= images[i][2]
        buttonRect.idSlot = i
        buttonRect.yGoalPos = group.y
        buttonRect.anchorX = 0
        buttonRect:setFillColor(0, 71/255, 93/255)
        group:insert(buttonRect)
        local strokeIcon = display.newRect(buttonRect.x+buttonRect.height*0.55, buttonRect.y, buttonRect.height/1.3, buttonRect.height/1.4)
        strokeIcon.strokeWidth = 3
        strokeIcon:setStrokeColor(171/255, 219/255, 241/255)
        strokeIcon:setFillColor(0,0,0,0)
        group:insert(strokeIcon)
        local containerIcon = display.newContainer(strokeIcon.width, strokeIcon.height)
        group:insert(containerIcon)
        containerIcon.x, containerIcon.y = strokeIcon.x, strokeIcon.y
        buttonRect.pathImage = IDOBJECT.."/image_"..images[i][2]..".png"
        local imageIcon = display.newImage(buttonRect.pathImage, system.DocumentsDirectory)
        containerIcon:insert(imageIcon)
        strokeIcon:toFront()

        local sizeIconProject = containerIcon.height/imageIcon.height
        if (imageIcon.width*sizeIconProject<containerIcon.width) then
            sizeIconProject = containerIcon.width/imageIcon.width
        end
        imageIcon.xScale, imageIcon.yScale = sizeIconProject, sizeIconProject

        local nameProject = display.newText({
            text = images[i][1],
            x = strokeIcon.x+strokeIcon.width/1.5,
            y = strokeIcon.y,
            width = display.contentWidth/1.75,
            height = fontSize0*1.15,
            fontSize = fontSize0
        })
        nameProject.anchorX = 0
        nameProject:setFillColor(171/255, 219/255, 241/255)
        group:insert(nameProject)

        local menuProject = display.newImage("images/menu.png")
        menuProject:addEventListener("touch", touchMenuSlot)
        menuProject.x, menuProject.y, menuProject.width, menuProject.height = buttonRect.x+buttonRect.width/1.11, buttonRect.y, buttonRect.height/4.5, buttonRect.height/4.5
        menuProject:setFillColor(171/255, 219/255, 241/255)
        group:insert(menuProject)
        buttonRect.myGroup = group
        menuProject.slot = buttonRect
        buttonRect.nameProject = nameProject


        buttonRect:addEventListener("touch", touchOpenImage)
    end
    scrollProjects:setScrollHeight(groupSceneScroll.height+display.contentWidth/1.5)

    funAddImage = function (event)
        if (event.done=="ok") then

            local function isCorrectName(value)
                local isCorrect = true
                for i=1, #images do
                    if (value==images[i][1]) then
                        isCorrect = false
                        break
                    end
                end
                return(isCorrect)
            end
            local function correctName(value)
                if (isCorrectName(value)) then
                    return (value)
                else
                    local i = 1
                    while (not isCorrectName(value.." ("..i..")")) do
                        i = i+1
                    end
                    return(value.." ("..i..")")
                end
            end

            local imageName = event.origFileName:match("(.+)%.") or event.origFileName
            if isSim then
            -- Фикс имён на винде
            local elems = imageName:split('\\')
            imageName = elems[#elems]
        end
        local counter = json.decode(funsP["получить сохранение"](IDPROJECT.."/counter"))
        counter[3] = counter[3]+1
        funsP["записать сохранение"](IDPROJECT.."/counter", json.encode(counter))
        images[#images+1] = {correctName(imageName), counter[3]}
        funsP["записать сохранение"](IDOBJECT.."/images", json.encode(images))
        funsP["добавить изображение в объект"](IDOBJECT.."/image_"..counter[3]..".png")

        local i = #images
        local group = display.newGroup()
        group.y = display.contentWidth/3.75*(i-0.5)
        groupSceneScroll:insert(group)
        local buttonRect = display.newRect(0, 0, display.contentWidth, display.contentWidth/3.75)
        arraySlots[i] = buttonRect
        buttonRect.idProject= images[i][2]
        buttonRect.idSlot = i
        buttonRect.yGoalPos = group.y
        buttonRect.anchorX = 0
        buttonRect:setFillColor(0, 71/255, 93/255)
        group:insert(buttonRect)
        local strokeIcon = display.newRect(buttonRect.x+buttonRect.height*0.55, buttonRect.y, buttonRect.height/1.3, buttonRect.height/1.4)
        strokeIcon.strokeWidth = 3
        strokeIcon:setStrokeColor(171/255, 219/255, 241/255)
        strokeIcon:setFillColor(0,0,0,0)
        group:insert(strokeIcon)
        local containerIcon = display.newContainer(strokeIcon.width, strokeIcon.height)
        group:insert(containerIcon)
        containerIcon.x, containerIcon.y = strokeIcon.x, strokeIcon.y
        buttonRect.pathImage = IDOBJECT.."/image_"..images[i][2]..".png"
        local imageIcon = display.newImage(buttonRect.pathImage, system.DocumentsDirectory)
        containerIcon:insert(imageIcon)
        strokeIcon:toFront()

        local sizeIconProject = containerIcon.height/imageIcon.height
        if (imageIcon.width*sizeIconProject<containerIcon.width) then
            sizeIconProject = containerIcon.width/imageIcon.width
        end
        imageIcon.xScale, imageIcon.yScale = sizeIconProject, sizeIconProject

        local nameProject = display.newText({
            text = images[i][1],
            x = strokeIcon.x+strokeIcon.width/1.5,
            y = strokeIcon.y,
            width = display.contentWidth/1.75,
            height = fontSize0*1.15,
            fontSize = fontSize0
        })
        nameProject.anchorX = 0
        nameProject:setFillColor(171/255, 219/255, 241/255)
        group:insert(nameProject)

        local menuProject = display.newImage("images/menu.png")
        menuProject:addEventListener("touch", touchMenuSlot)
        menuProject.x, menuProject.y, menuProject.width, menuProject.height = buttonRect.x+buttonRect.width/1.11, buttonRect.y, buttonRect.height/4.5, buttonRect.height/4.5
        menuProject:setFillColor(171/255, 219/255, 241/255)
        group:insert(menuProject)
        buttonRect.myGroup = group
        menuProject.slot = buttonRect
        buttonRect.nameProject = nameProject

        buttonRect:addEventListener("touch", touchOpenImage)
        scrollProjects:setScrollHeight(groupSceneScroll.height+display.contentWidth/1.5)

    end
end

local functionsMenu = {}

local arrayAllButtonsFunctions = {
    ["back"]={"back","startmenu",{{486,"readySprites"}}},
}
arrayAllButtonsFunctions["startmenu"] = arrayAllButtonsFunctions["back"]



functionsMenu["startreadySprites"] = function()
isBackScene="back"
groupScene.alpha = 0
local function funAddImage()
    images = json.decode(funsP["получить сохранение"](IDOBJECT.."/images"))
    local i = #images
    local group = display.newGroup()
    group.y = display.contentWidth/3.75*(i-0.5)
    groupSceneScroll:insert(group)
    local buttonRect = display.newRect(0, 0, display.contentWidth, display.contentWidth/3.75)
    arraySlots[i] = buttonRect
    buttonRect.idProject= images[i][2]
    buttonRect.idSlot = i
    buttonRect.yGoalPos = group.y
    buttonRect.anchorX = 0
    buttonRect:setFillColor(0, 71/255, 93/255)
    group:insert(buttonRect)
    local strokeIcon = display.newRect(buttonRect.x+buttonRect.height*0.55, buttonRect.y, buttonRect.height/1.3, buttonRect.height/1.4)
    strokeIcon.strokeWidth = 3
    strokeIcon:setStrokeColor(171/255, 219/255, 241/255)
    strokeIcon:setFillColor(0,0,0,0)
    group:insert(strokeIcon)
    local containerIcon = display.newContainer(strokeIcon.width, strokeIcon.height)
    group:insert(containerIcon)
    containerIcon.x, containerIcon.y = strokeIcon.x, strokeIcon.y
    buttonRect.pathImage = IDOBJECT.."/image_"..images[i][2]..".png"
    local imageIcon = display.newImage(buttonRect.pathImage, system.DocumentsDirectory)
    containerIcon:insert(imageIcon)
    strokeIcon:toFront()

    local sizeIconProject = containerIcon.height/imageIcon.height
    if (imageIcon.width*sizeIconProject<containerIcon.width) then
        sizeIconProject = containerIcon.width/imageIcon.width
    end
    imageIcon.xScale, imageIcon.yScale = sizeIconProject, sizeIconProject

    local nameProject = display.newText({
        text = images[i][1],
        x = strokeIcon.x+strokeIcon.width/1.5,
        y = strokeIcon.y,
        width = display.contentWidth/1.75,
        height = fontSize0*1.15,
        fontSize = fontSize0
    })
    nameProject.anchorX = 0
    nameProject:setFillColor(171/255, 219/255, 241/255)
    group:insert(nameProject)

    local menuProject = display.newImage("images/menu.png")
    menuProject:addEventListener("touch", touchMenuSlot)
    menuProject.x, menuProject.y, menuProject.width, menuProject.height = buttonRect.x+buttonRect.width/1.11, buttonRect.y, buttonRect.height/4.5, buttonRect.height/4.5
    menuProject:setFillColor(171/255, 219/255, 241/255)
    group:insert(menuProject)
    buttonRect.myGroup = group
    menuProject.slot = buttonRect
    buttonRect.nameProject = nameProject

    buttonRect:addEventListener("touch", touchOpenImage)
    scrollProjects:setScrollHeight(groupSceneScroll.height+display.contentWidth/1.5)
end
scene_readySprites(funAddImage)
end


functionsMenu["back"] = function()
isBackScene = arrayAllButtonsFunctions[isBackScene][2]
local notVisibleRect = display.newImage("images/notVisible.png")
notVisibleRect.x, notVisibleRect.y, notVisibleRect.width, notVisibleRect.height = CENTER_X, CENTER_Y, display.contentWidth, display.contentHeight

local groupMenu = display.newGroup()
groupMenu.x, groupMenu.y = display.contentWidth/1.02, CENTER_Y-display.contentHeight/2+(display.contentWidth-display.contentWidth/1.02)

groupMenu.xScale, groupMenu.yScale, groupMenu.alpha = 0.3, 0.3, 0

local arrayButtonsFunctions = arrayAllButtonsFunctions[isBackScene][3]
local buttons = {}
local buttonContainer = display.newContainer(display.contentWidth/1.8, display.contentWidth/7)
buttonContainer.anchorX, buttonContainer.anchorY = 1, 0
SCENES[SCENE][1]:insert(buttonContainer)
local buttonCircle = display.newCircle(0,0,buttonContainer.width/2)
buttonCircle:setFillColor(1,1,1,0.25)
buttonCircle.xScale, buttonCircle.yScale, buttonCircle.alpha = 0.25, 0.25, 0
buttonContainer:insert(buttonCircle)

local function touchTypeFunction(event)
    if (event.phase=="began") then
        buttonContainer:toFront()
        buttonContainer.y = event.target.y
        transition.to(buttonCircle, {time=150, xScale=1.1, yScale=1.1, alpha=1})
    elseif (event.phase=="moved") then
        transition.to(buttonCircle, {time=150, xScale=0.25, yScale=0.25, alpha=0})
    else
        isBackScene = event.target.typeFunction
        functionsMenu["start"..isBackScene]()
        for i=1, #buttons do
            buttons[i]:removeEventListener("touch", touchTypeFunction)
        end
        display.remove(notVisibleRect)
        transition.to(groupMenu, {time=200, alpha=0, onComolete=function ()
            display.remove(groupMenu)
        end})
    end
    return(true)
end

for i=1, #arrayButtonsFunctions do
    buttons[i] = display.newRect(0, display.contentWidth/7*(i-1), display.contentWidth/1.5, display.contentWidth/7)
    buttons[i].anchorX, buttons[i].anchorY = 1, 0
    buttons[i]:setFillColor(48/255, 48/255, 48/255)
    groupMenu:insert(buttons[i])
    buttons[i].typeFunction = arrayButtonsFunctions[i][2]
    buttons[i]:addEventListener("touch",touchTypeFunction)

    buttons[i].header = display.newText(words[arrayButtonsFunctions[i][1]], -buttons[i].width/1.1, buttons[i].y+buttons[i].height/2, nil, fontSize1)
    buttons[i].header.anchorX=0
    groupMenu:insert(buttons[i].header)

end

transition.to(groupMenu, {time=150, xScale=1, yScale=1, alpha=1, transition=easing.outQuad})

notVisibleRect:addEventListener("touch", function (event)
    if (event.phase=="ended") then
        isBackScene = arrayAllButtonsFunctions[isBackScene][1]
        display.remove(notVisibleRect)
        for i=1, #buttons do
            buttons[i]:removeEventListener("touch", touchTypeFunction)
        end
        transition.to(groupMenu, {time=200, alpha=0, onComolete=function ()
            display.remove(groupMenu)
        end})
    end
    return(true)
end)
end

funMenuObjects[1] = function()
if (functionsMenu[isBackScene]~=nil) then
    functionsMenu[isBackScene]()
end
end

end

local objectPlay = nil
local playSound = nil
local touchPlaySound = nil
local function compartmentSounds()
    local groupSceneScroll = display.newGroup()
    scrollProjects:insert(groupSceneScroll)
    SCENES[SCENE][2] = groupSceneScroll
    local sounds = json.decode(funsP["получить сохранение"](IDOBJECT.."/sounds"))
    local arraySlots = {}

--BBBBBBBBBBBBBBBBBBBBBBB
--BBBBBBBBBBBBBBBBBBBBBBB
--BBBBBBBBBBBBBBBBBBBBBBB
--BBBBBBBBBBBBBBBBBBBBBBB
--BBBBBBBBBBBBBBBBBBBBBBB
touchPlaySound = function(event)
    if (event.phase=="began") then
        display.getCurrentStage():setFocus(event.target, event.id)
    elseif (event.phase=="moved") then
        scrollProjects:takeFocus(event)
    else
        if (objectPlay~=nil and objectPlay~=event.target) then
            objectPlay.fill = {
                type="image",
                filename="images/play.png",
            }
            objectPlay = nil
            audio.stop(playSound)
        end
        if (objectPlay == event.target) then
            event.target.fill = {
                type="image",
                filename="images/play.png",
            }
            objectPlay = nil
            audio.stop(playSound)
        else
            event.target.fill = {
                type="image",
                filename="images/stop.png",
            }
            objectPlay = event.target
            local loadSound = audio.loadStream(event.target.pathSound, system.DocumentsDirectory)
            playSound = audio.play(loadSound,{onComplete=function ()
                if (objectPlay==event.target) then
                    event.target.fill = {
                        type="image",
                        filename="images/play.png",
                    }
                    objectPlay = nil
                end
            end})
            audio.dispose(loadSound)
        end
        display.getCurrentStage():setFocus(event.target, nil)
    end
    return(true)
end

local function touchMenuSlot(event)
    if (event.phase=="began") then
        display.getCurrentStage():setFocus(event.target, event.id)
    elseif (event.phase=="moved") then
        scrollProjects:takeFocus(event)
    else
        display.getCurrentStage():setFocus(event.target, nil)

        isBackScene="block"

        local notVisibleRect = display.newImage("images/notVisible.png")
        notVisibleRect.x, notVisibleRect.y, notVisibleRect.width, notVisibleRect.height = CENTER_X, CENTER_Y, display.contentWidth, display.contentHeight

        local xPosScroll, yPosScroll = scrollProjects:getContentPosition()
        local groupMenu = display.newGroup()
        groupMenu.x, groupMenu.y = display.contentWidth, event.target.slot.myGroup.y+event.target.height/1.25+yPosScroll+switchBar.height

        groupMenu.xScale, groupMenu.yScale, groupMenu.alpha = 0.3, 0.3, 0

        local arrayButtonsFunctions = {{5, "delete"}, {6, "rename"}}

        local buttons = {}
        local buttonContainer = display.newContainer(display.contentWidth/1.8, display.contentWidth/7)
        buttonContainer.anchorX, buttonContainer.anchorY = 1, 0
        groupMenu:insert(buttonContainer)
        local buttonCircle = display.newCircle(0,0,buttonContainer.width/2)
        buttonCircle:setFillColor(1,1,1,0.25)
        buttonCircle.xScale, buttonCircle.yScale, buttonCircle.alpha = 0.25, 0.25, 0
        buttonContainer:insert(buttonCircle)

        local eventTargetMenu = event.target
        local function touchTypeFunction(event)
            if (event.phase=="began") then
                buttonContainer:toFront()
                buttonContainer.y = event.target.y
                transition.to(buttonCircle, {time=150, xScale=1.1, yScale=1.1, alpha=1})
            elseif (event.phase=="moved") then
                transition.to(buttonCircle, {time=150, xScale=0.25, yScale=0.25, alpha=0})
            else

                isBackScene="back"

                if (event.target.typeFunction == "delete") then
                    local idSlot = eventTargetMenu.slot.idSlot
                    os.remove(system.pathForFile(IDOBJECT.."/sound_"..sounds[idSlot][2]..".MP3", system.DocumentsDirectory))
                    table.remove(sounds, idSlot)
                    table.remove(arraySlots, idSlot)
                    display.remove(eventTargetMenu.slot.myGroup)
                    for i=1, #sounds do
                        local slot = arraySlots[i]
                        slot.yGoalPos = display.contentWidth/3.75*(i-0.5)
                        slot.myGroup.y = slot.yGoalPos
                        slot.idSlot = i
                    end
                    funsP["записать сохранение"](IDOBJECT.."/sounds", json.encode(sounds))
                elseif (event.target.typeFunction == "rename") then
                    local function isCorrectValue(value)
                        if (string.len(value)==0) then
                            return(words[18])
                        else
                            local isCorrect = true
                            for i=1, #sounds do
                                if (sounds[i][1]==value) then
                                    isCorrect=false
                                    break
                                end
                            end
                            return(isCorrect and "" or words[15])
                        end
                    end
                    local slot = eventTargetMenu.slot
                    cerberus.newInputLine(words[270], words[271], isCorrectValue, sounds[slot.idSlot][1], function(answer)
                        if (answer.isOk) then
                            answer.value = string.gsub(answer.value, (isWin and '\r\n' or '\n'), " ")
                            slot.nameProject.text = answer.value
                            sounds[slot.idSlot][1] = answer.value
                            funsP["записать сохранение"](IDOBJECT.."/sounds", json.encode(sounds))
                        end
                    end)
                end

                for i=1, #buttons do
                    buttons[i]:removeEventListener("touch", touchTypeFunction)
                end
                display.remove(notVisibleRect)
                transition.to(groupMenu, {time=200, alpha=0, onComplete=function ()
                    display.remove(groupMenu)
                end})
            end
            return(true)
        end

        for i=1, #arrayButtonsFunctions do
            buttons[i] = display.newRect(0, display.contentWidth/7*(i-1), display.contentWidth/1.8, display.contentWidth/7)
            buttons[i].anchorX, buttons[i].anchorY = 1, 0
            buttons[i]:setFillColor(48/255, 48/255, 48/255)
            groupMenu:insert(buttons[i])
            buttons[i].typeFunction = arrayButtonsFunctions[i][2]
            buttons[i]:addEventListener("touch",touchTypeFunction)

            buttons[i].header = display.newText(words[arrayButtonsFunctions[i][1]], -buttons[i].width/1.1, buttons[i].y+buttons[i].height/2, nil, fontSize1)
            buttons[i].header.anchorX=0
            groupMenu:insert(buttons[i].header)

        end

        transition.to(groupMenu, {time=150, xScale=1, yScale=1, alpha=1, transition=easing.outQuad})

        notVisibleRect:addEventListener("touch", function (event)
            if (event.phase=="ended") then
                isBackScene="back"
                display.remove(notVisibleRect)
                for i=1, #buttons do
                    buttons[i]:removeEventListener("touch", touchTypeFunction)
                end
                transition.to(groupMenu, {time=200, alpha=0, onComplete=function ()
                    display.remove(groupMenu)
                end})
            end
            return(true)
        end)


    end
    return(true)
end

local timerMoveSlot = nil
local isTimerMoveSlot = false
local isMoveSlot = false

local function touchOpenImage(event)
    if (event.phase == "began") then
        event.target:setFillColor(23/255,91/255,114/255)
        display.getCurrentStage():setFocus(event.target, event.id)
        isTimerMoveSlot = true
        timerMoveSlot = timer.performWithDelay(250, function ()
            isTimerMoveSlot = false
            isMoveSlot = true
            event.target.myGroup:toFront()
        end)
    elseif (event.phase=="moved") then
        if (isTimerMoveSlot) then
            isTimerMoveSlot = false
            timer.cancel(timerMoveSlot)
            event.target:setFillColor(0, 71/255, 93/255)
            scrollProjects:takeFocus(event)
        end
        if (isMoveSlot) then
            local xS, yS = scrollProjects:getContentPosition()
            local group = event.target.myGroup
            local button = event.target
            group.y = event.y-scrollProjects.y-yS
            local newId = nil
            if (group.y>button.yGoalPos+button.height/2 and button.idSlot<#sounds) then
                newId = 1
            elseif (group.y<button.yGoalPos-button.height/2 and button.idSlot>1) then
                newId = -1
            end
            if (newId~=nil) then
                local tableSound = sounds[button.idSlot]
                local transitionSound = arraySlots[button.idSlot+newId]
                table.remove(sounds, button.idSlot)
                table.remove(arraySlots, button.idSlot)
                table.insert(sounds, button.idSlot+newId, tableSound)
                table.insert(arraySlots, button.idSlot+newId, button)
                transitionSound.yGoalPos = transitionSound.yGoalPos-transitionSound.height*newId
                transitionSound.idSlot = transitionSound.idSlot-newId
                transition.to(transitionSound.myGroup, {y=transitionSound.yGoalPos, time=200, transition=easing.outQuad})
                button.idSlot = button.idSlot+newId
                button.yGoalPos = button.yGoalPos+button.height*newId
            end
        end
    else
        event.target:setFillColor(0, 71/255, 93/255)
        display.getCurrentStage():setFocus(event.target, nil)
        if (isTimerMoveSlot) then
            isTimerMoveSlot = false
            timer.cancel(timerMoveSlot)
-- на объект нажали
end
if (isMoveSlot) then
    isMoveSlot=false
    event.target.myGroup.y = event.target.yGoalPos
    funsP["записать сохранение"](IDOBJECT.."/sounds", json.encode(sounds))
end
end
return(true)
end

for i=1, #sounds do
--
local group = display.newGroup()
group.y = display.contentWidth/3.75*(i-0.5)
groupSceneScroll:insert(group)
local buttonRect = display.newRect(0, 0, display.contentWidth, display.contentWidth/3.75)
arraySlots[i] = buttonRect
buttonRect.idSlot = i
buttonRect.yGoalPos = group.y
buttonRect.anchorX = 0
buttonRect:setFillColor(0, 71/255, 93/255)
group:insert(buttonRect)
local strokeIcon = display.newRect(buttonRect.x+buttonRect.height*0.55, buttonRect.y, buttonRect.height/1.3, buttonRect.height/1.4)
strokeIcon.strokeWidth = 3
strokeIcon:setStrokeColor(171/255, 219/255, 241/255)
strokeIcon:setFillColor(0,0,0,0)
group:insert(strokeIcon)
local containerIcon = display.newContainer(strokeIcon.width, strokeIcon.height)
group:insert(containerIcon)
containerIcon.x, containerIcon.y = strokeIcon.x, strokeIcon.y
local imageIcon = display.newImage("images/play.png")
containerIcon:insert(imageIcon)
strokeIcon:toFront()
imageIcon.pathSound = IDOBJECT.."/sound_"..sounds[i][2]..".mp3"
imageIcon:addEventListener("touch", touchPlaySound)
imageIcon.slot = buttonRect

local sizeIconProject = containerIcon.height/imageIcon.height
if (imageIcon.width*sizeIconProject<containerIcon.width) then
    sizeIconProject = containerIcon.width/imageIcon.width
end
imageIcon.xScale, imageIcon.yScale = sizeIconProject, sizeIconProject

local nameProject = display.newText({
    text = sounds[i][1],
    x = strokeIcon.x+strokeIcon.width/1.5,
    y = strokeIcon.y,
    width = display.contentWidth/1.75,
    height = fontSize0*1.15,
    fontSize = fontSize0
})
nameProject.anchorX = 0
nameProject:setFillColor(171/255, 219/255, 241/255)
group:insert(nameProject)

local menuProject = display.newImage("images/menu.png")
menuProject:addEventListener("touch", touchMenuSlot)
menuProject.x, menuProject.y, menuProject.width, menuProject.height = buttonRect.x+buttonRect.width/1.11, buttonRect.y, buttonRect.height/4.5, buttonRect.height/4.5
menuProject:setFillColor(171/255, 219/255, 241/255)
group:insert(menuProject)
buttonRect.myGroup = group
menuProject.slot = buttonRect
buttonRect.nameProject = nameProject


buttonRect:addEventListener("touch", touchOpenImage)
--
end
scrollProjects:setScrollHeight(groupSceneScroll.height+display.contentWidth/1.5)

funAddSound = function (event)
    if (event.done=="ok") then

        local function isCorrectName(value)
            local isCorrect = true
            for i=1, #sounds do
                if (value==sounds[i][1]) then
                    isCorrect = false
                    break
                end
            end
            return(isCorrect)
        end
        local function correctName(value)
            if (isCorrectName(value)) then
                return (value)
            else
                local i = 1
                while (not isCorrectName(value.." ("..i..")")) do
                    i = i+1
                end
                return(value.." ("..i..")")
            end
        end

        local soundName = event.origFileName:match("(.+)%.") or event.origFileName
        local counter = json.decode(funsP["получить сохранение"](IDPROJECT.."/counter"))
        counter[4] = counter[4]+1
        funsP["записать сохранение"](IDPROJECT.."/counter", json.encode(counter))
        sounds[#sounds+1] = {correctName(soundName), counter[4]}
        funsP["записать сохранение"](IDOBJECT.."/sounds", json.encode(sounds))
        funsP["добавить звук в объект"](IDOBJECT.."/sound_"..counter[4]..".mp3")

        local i = #sounds
        local group = display.newGroup()
        group.y = display.contentWidth/3.75*(i-0.5)
        groupSceneScroll:insert(group)
        local buttonRect = display.newRect(0, 0, display.contentWidth, display.contentWidth/3.75)
        arraySlots[i] = buttonRect
        buttonRect.idProject= sounds[i][2]
        buttonRect.idSlot = i
        buttonRect.yGoalPos = group.y
        buttonRect.anchorX = 0
        buttonRect:setFillColor(0, 71/255, 93/255)
        group:insert(buttonRect)
        local strokeIcon = display.newRect(buttonRect.x+buttonRect.height*0.55, buttonRect.y, buttonRect.height/1.3, buttonRect.height/1.4)
        strokeIcon.strokeWidth = 3
        strokeIcon:setStrokeColor(171/255, 219/255, 241/255)
        strokeIcon:setFillColor(0,0,0,0)
        group:insert(strokeIcon)
        local containerIcon = display.newContainer(strokeIcon.width, strokeIcon.height)
        group:insert(containerIcon)
        containerIcon.x, containerIcon.y = strokeIcon.x, strokeIcon.y
        local imageIcon = display.newImage("images/play.png")
        containerIcon:insert(imageIcon)
        strokeIcon:toFront()
        imageIcon.pathSound = IDOBJECT.."/sound_"..sounds[i][2]..".mp3"
        imageIcon:addEventListener("touch", touchPlaySound)
        imageIcon.slot = buttonRect

        local sizeIconProject = containerIcon.height/imageIcon.height
        if (imageIcon.width*sizeIconProject<containerIcon.width) then
            sizeIconProject = containerIcon.width/imageIcon.width
        end
        imageIcon.xScale, imageIcon.yScale = sizeIconProject, sizeIconProject

        local nameProject = display.newText({
            text = sounds[i][1],
            x = strokeIcon.x+strokeIcon.width/1.5,
            y = strokeIcon.y,
            width = display.contentWidth/1.75,
            height = fontSize0*1.15,
            fontSize = fontSize0
        })
        nameProject.anchorX = 0
        nameProject:setFillColor(171/255, 219/255, 241/255)
        group:insert(nameProject)

        local menuProject = display.newImage("images/menu.png")
        menuProject:addEventListener("touch", touchMenuSlot)
        menuProject.x, menuProject.y, menuProject.width, menuProject.height = buttonRect.x+buttonRect.width/1.11, buttonRect.y, buttonRect.height/4.5, buttonRect.height/4.5
        menuProject:setFillColor(171/255, 219/255, 241/255)
        group:insert(menuProject)
        buttonRect.myGroup = group
        menuProject.slot = buttonRect
        buttonRect.nameProject = nameProject

        buttonRect:addEventListener("touch", touchOpenImage)
        scrollProjects:setScrollHeight(groupSceneScroll.height+display.contentWidth/1.5)
    end
end

funBackObjects[1] = function ()
if (isBackScene == "back") then
    display.remove(groupSceneScroll)
    display.remove(groupScene)
    scene_objects(infoSceneObjects[1],infoSceneObjects[2],infoSceneObjects[3])
    if (objectPlay ~= nil) then
        audio.stop(playSound)
        local objectPlay = nil
    end
end
end

end

--AAAAAAAAAAAAAAAAAAAAA
--AAAAAAAAAAAAAAAAAAAAA
--AAAAAAAAAAAAAAAAAAAAA
--AAAAAAAAAAAAAAAAAAAAA
--AAAAAAAAAAAAAAAAAAAAA
local tableFunctionsCompartments = {compartmentScripts, compartmentImages, compartmentSounds}
local typeFunctionCompartment = 0
switchBarRect.xGoalPos = switchBarRect.x
switchBar:addEventListener("touch", function (event)
    if (not isBlockTouchBlock) then
        if (event.phase=="began") then
            display.getCurrentStage():setFocus(event.target, event.id)
        elseif (event.phase~="moved") then
            local oldIdCategory = math.round((switchBarRect.xGoalPos-CENTER_X)/(display.contentWidth/3))+1
            local idCategory = math.round((event.x-CENTER_X)/(display.contentWidth/3))+1
            typeFunctionCompartment = idCategory
            if (oldIdCategory~=idCategory) then
                if (idCategory~=2) then
                    topBarArray[4].alpha = 1
                else
                    topBarArray[4].alpha = 0
                end
                if (oldIdCategory==2) then
                    audio.stop(playSound)
                    local objectPlay = nil
                end
                switchBarRect.xGoalPos = CENTER_X+((idCategory-1)*display.contentWidth/3)
                transition.to(switchBarRect, {x=switchBarRect.xGoalPos, time=200, transition=easing.outQuad})
                display.remove(SCENES[SCENE][2])
                if (tableFunctionsCompartments[idCategory+1]~=nil) then
                    tableFunctionsCompartments[idCategory+1]()
                end
                scrollProjects:scrollToPosition({y=0, time=0})
            end
            display.getCurrentStage():setFocus(event.target, nil)
        end
        return(true)
    end
end)


local circlePlus = display.newCircle(CENTER_X+display.contentWidth/2-display.contentWidth/8, CENTER_Y+display.contentHeight/2-display.contentWidth/8-75, display.contentWidth/11.5)
circlePlus:setFillColor(1, 172/255, 8/255)
groupScene:insert(circlePlus)
local circlePlusAlpha = display.newCircle(circlePlus.x, circlePlus.y, display.contentWidth/11.5)
circlePlusAlpha:setFillColor(1,1,1,0.25)
circlePlusAlpha.xScale, circlePlusAlpha.yScale, circlePlusAlpha.alpha = 0.5, 0.5, 0
groupScene:insert(circlePlusAlpha)
circlePlus.circleAlpha = circlePlusAlpha
local circlePlay = display.newCircle(circlePlus.x, circlePlus.y-display.contentWidth/8*1.75, display.contentWidth/11.5)
circlePlay:setFillColor(1, 172/255, 8/255)
groupScene:insert(circlePlay)
local runIcon = display.newImageRect('images/play.png', fontSize0*1.75, fontSize0*1.75)
runIcon.x = circlePlay.x
runIcon.y = circlePlay.y
groupScene:insert(runIcon)
local circlePlayAlpha = display.newCircle(circlePlay.x, circlePlay.y, display.contentWidth/11.5)
circlePlayAlpha:setFillColor(1,1,1,0.25)
circlePlayAlpha.xScale, circlePlayAlpha.yScale, circlePlayAlpha.alpha = 0.75, 0.75, 0
groupScene:insert(circlePlayAlpha)
circlePlay.circleAlpha = circlePlayAlpha
circlePlusText = display.newText("+",circlePlus.x, circlePlus.y, nil, fontSize0*1.75)
groupScene:insert(circlePlusText)
local function touchCirclePlus(event)
    if (not isBlockTouchBlock) then
        if (event.phase=="began") then
            transition.to(event.target.circleAlpha, {alpha=1, xScale=1, yScale=1, time=100})
            display.getCurrentStage():setFocus(event.target, event.id)
        elseif (event.phase=="moved") then
        else
            transition.to(event.target.circleAlpha, {alpha=0, xScale=0.75, yScale=0.75, time=100})
            display.getCurrentStage():setFocus(event.target, nil)

            if (isBackScene=="back") then
                if (typeFunctionCompartment==0) then
                    SCENES[SCENE][1].alpha = 0
                    SCENES[SCENE][1].x = display.contentWidth
                    scene_categoriesScripts(funAddBlock)
                elseif (typeFunctionCompartment==1) then
                    funsP["импортировать изображение"](funAddImage)
                elseif (typeFunctionCompartment==2) then
                    funsP["импортировать звук"](funAddSound)
                end
            end
        end
    end
    return(true)
end

local function touchCirclePlay(event)
    if (not isBlockTouchBlock) then
        if event.phase == 'began' then
            transition.to(event.target.circleAlpha, {alpha=1, xScale=1, yScale=1, time=100})
            display.getCurrentStage():setFocus(event.target, event.id)
        elseif event.phase ~= 'moved' and event.phase ~= 'began' then
            transition.to(event.target.circleAlpha, {alpha=0, xScale=0.75, yScale=0.75, time=100})
            display.getCurrentStage():setFocus(event.target, nil)
            if isBackScene == 'back' then
                SCENES[SCENE][2].alpha = 0
                SCENES[SCENE][1].alpha = 0
                isBackScene = 'block'
                if (objectPlay~=nil) then
                    audio.stop(playSound)
                    objectPlay.fill = {
                        type="image",
                        filename="images/play.png"
                    }
                    objectPlay = nil
                end
                display.remove(SCENES[SCENE][2])
                display.remove(SCENES[SCENE[1]])
                scene_run_game('scripts', {headerBar, pathObject, infoSceneObjects})
            end
        end
    end
    return true
end

circlePlus:addEventListener("touch", touchCirclePlus)
circlePlay:addEventListener("touch", touchCirclePlay)
--AAAAAAAAAAAAAAAAAAAAA
--AAAAAAAAAAAAAAAAAAAAA
--AAAAAAAAAAAAAAAAAAAAA
--AAAAAAAAAAAAAAAAAAAAA
--AAAAAAAAAAAAAAAAAAAAA


end