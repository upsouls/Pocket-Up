-- сцена для просмотра бесплатных текстур из интернета

local objs = {}

local function decodeString(encoded)
    local decoded = ""
    for _, v in ipairs(encoded) do
        decoded = decoded .. string.char(v)
    end
    return decoded
end

local function onBack()
    display.remove(objs.sceneGroup)
    objs.gen = false
    SCENES["scripts"][1].alpha = 1
    funBack = objs.oldFunBack
end

function scene_readySprites( funAddImage )
    objs.sceneGroup = display.newGroup()
    local sceneGroup = objs.sceneGroup
    local groupSceneScroll
    local funBackObjects = {}
    objs.oldFunBack = funBack
    local topBarArray = topBar(sceneGroup, words[486], nil, nil, funBackObjects)
    topBarArray[4].alpha = 0
    local scroll = require('widget').newScrollView( {
        width=display.contentWidth,
        height=display.contentHeight-topBarArray[1].height,
        hideBackground=true,
        horizontalScrollDisabled=true,
        isBounceEnabled=false,
    } )
    scroll.anchorY = 0
    scroll.y = topBarArray[1].y+topBarArray[1].height

    objs.scroll = scroll
    objs.gen = true

    sceneGroup:insert(scroll)
    local headerLoad = display.newText({
        text = words[549],
        x=CENTER_X, y=scroll.height/2.25,
        width=display.contentWidth,
        align="center",
        fontSize=fontSize1*1.35,
    })
    headerLoad.alpha=0.75
    scroll:insert(headerLoad)

    local y = display.contentWidth/6
    local link = decodeString({104, 116, 116, 112, 115, 58, 47, 47, 112, 111, 99, 107, 101, 116, 45, 117, 112, 45, 115, 116, 111, 114, 97, 103, 101, 45, 100, 101, 102, 97, 117, 108, 116, 45, 114, 116, 100, 98, 46, 101, 117, 114, 111, 112, 101, 45, 119, 101, 115, 116, 49, 46, 102, 105, 114, 101, 98, 97, 115, 101, 100, 97, 116, 97, 98, 97, 115, 101, 46, 97, 112, 112})

    network.request( link..'/sprites.json', "GET", function(event)
        if not event.isError then
            -- загрузка листа готовых образов
            local sprites = json.decode(event.response)
            local spritesArray = {}
            for i, v in pairs(sprites) do
                spritesArray[#spritesArray+1] = {i, v}
            end
            headerLoad.alpha = 0
            print(json.encode(spritesArray))
            local function loadList(startId, endId)
                local y = display.contentWidth/6
                if (groupSceneScroll~=nil) then
                    display.remove(groupSceneScroll)
                end
                local myGroup = display.newGroup()
                groupSceneScroll = myGroup
                scroll:insert(groupSceneScroll)
                for i=startId, endId do
                    if (spritesArray[i]~=nil) then
                        local v = spritesArray[i][2]
                        local i = spritesArray[i][1]
                        ----
                        local params = {}
                        params.progress = true
                        if objs.gen then
                            network.download( v['link'], 'GET', function(event)
                                if event.phase == 'ended' and sceneGroup~=nil and sceneGroup.x~=nil and myGroup~=nil and myGroup.x~=nil then
                                    pcall(function()
                                        local bg = display.newRect(CENTER_X, y, display.contentWidth, display.contentWidth/3)
                                        bg:setFillColor(0, 71/255, 93/255)
                                        groupSceneScroll:insert(bg)
                                        bg.container = display.newContainer( display.contentWidth/4, display.contentWidth/4)
                                        local obj = display.newImage(v['name']..'.png', system.TemporaryDirectory)
                                        obj.link = v['link']
                                        local obj_bg = display.newRect(20+bg.container.width/2, bg.y, bg.container.width, bg.container.height+5)
                                        groupSceneScroll:insert(obj_bg)
                                        obj:toFront()
                                        local sizeIconProject = bg.container.height/obj.height
                                        if (obj.width*sizeIconProject<bg.container.width) then
                                            sizeIconProject = bg.container.width/obj.width
                                        end
                                        obj.xScale, obj.yScale = sizeIconProject, sizeIconProject
                                        obj_bg.strokeWidth = 5
                                        obj_bg:setFillColor(0, 71/255, 93/255)
                                        obj_bg:setStrokeColor(171/255, 219/255, 1)

                                        bg.container.x = obj_bg.x
                                        bg.name = v['name']
                                        bg.ref = obj
                                        bg.link = v['link']
                                        bg.container.y = bg.y
                                        bg.container:insert(obj)
                                        groupSceneScroll:insert(bg.container)
                                        local name = display.newText(v['name'], 0, bg.y, display.contentWidth-obj_bg.width-15, bg.height-50, native.systemFont, 35)
                                        name.x = obj_bg.x + obj_bg.width/2 + name.width/2 + 15
                                        name:setFillColor(170/255,218/255,240/255)

                                        groupSceneScroll:insert(name)
                                        bg:addEventListener('touch', function(event)
                                            if event.phase == 'began' then
                                                event.target:setFillColor(24/255, 50/255, 60/255)
                                                display.getCurrentStage():setFocus(event.target, event.id)
                                            elseif event.phase == 'moved' and (math.abs(event.x-event.xStart)>20 or math.abs(event.y-event.yStart)>20) then
                                                event.target:setFillColor(0, 71/255, 93/255)
                                                objs.scroll:takeFocus(event)
                                            elseif event.phase == 'ended' then
                                                display.getCurrentStage():setFocus(event.target, nil)
                                                event.target:setFillColor(0/255, 71/255, 93/255)
                                                local sprites = json.decode(funsP['получить сохранение'](IDOBJECT..'/images'))
                                                local counter = json.decode(funsP['получить сохранение'](IDPROJECT..'/counter'))
                                                local allocNewSprite = counter[3]+1
                                                counter[3] = allocNewSprite
                                                funsP['записать сохранение'](IDPROJECT..'/counter', json.encode(counter))
                                                local params = {}
                                                params.progress = true
                                                network.download( event.target.link, 'GET',  function(event)
                                                    if event.phase == 'ended' then
                                                        sprites[allocNewSprite] = {v['name'], allocNewSprite}
                                                        funsP['записать сохранение'](IDOBJECT..'/images', json.encode(sprites))
                                                        funAddImage()
                                                        onBack()
                                                    end
                                                end, params, IDOBJECT..'/image_'..allocNewSprite..'.png', system.DocumentsDirectory)
                                            end
                                            return true
                                        end)
                                        scroll:setScrollHeight(groupSceneScroll.height+display.contentWidth/1.5)
                                        y = y + bg.height
                                    end)
                                    --obj.x = CENTER_X
                                end
                            end, params, v['name']..'.png', system.TemporaryDirectory)
                        else
                            break
                        end
                        --y = y + bounds.height+10
                        ----
                    end
                end
            end
            loadList(1, math.min(#spritesArray,10))

            local listId = 1
            local circleFront = display.newCircle(CENTER_X+display.contentWidth/2-display.contentWidth/8, CENTER_Y+display.contentHeight/2-display.contentWidth/8-75, display.contentWidth/11.5)
            circleFront:setFillColor(1, 172/255, 8/255)
            sceneGroup:insert(circleFront)
            local circleFrontAlpha = display.newCircle(circleFront.x, circleFront.y, display.contentWidth/11.5)
            circleFrontAlpha:setFillColor(1,1,1,0.25)
            circleFrontAlpha.xScale, circleFrontAlpha.yScale, circleFrontAlpha.alpha = 0.5, 0.5, 0
            sceneGroup:insert(circleFrontAlpha)
            circleFront.circleAlpha = circleFrontAlpha
            local circleFrontText = display.newImage("images/back.png", circleFront.x, circleFront.y)
            circleFrontText.xScale, circleFrontText.yScale = -display.contentWidth/1000, display.contentWidth/800
            sceneGroup:insert(circleFrontText)
            local circleBack = display.newCircle(CENTER_X-display.contentWidth/2+display.contentWidth/8, CENTER_Y+display.contentHeight/2-display.contentWidth/8-75, display.contentWidth/11.5)
            circleBack:setFillColor(1, 172/255, 8/255)
            sceneGroup:insert(circleBack)
            local circleBackAlpha = display.newCircle(circleBack.x, circleBack.y, display.contentWidth/11.5)
            circleBackAlpha:setFillColor(1,1,1,0.25)
            circleBackAlpha.xScale, circleBackAlpha.yScale, circleBackAlpha.alpha = 0.5, 0.5, 0
            sceneGroup:insert(circleBackAlpha)
            circleBack.circleAlpha = circleBackAlpha
            local circleBackText =  display.newImage("images/back.png", circleBack.x, circleBack.y)
            circleBackText.xScale, circleBackText.yScale = display.contentWidth/1000, display.contentWidth/800
            sceneGroup:insert(circleBackText)
            local function touchCircleList(event)
                if (true) then
                    if (event.phase=="began") then
                        transition.to(event.target.circleAlpha, {alpha=1, xScale=1, yScale=1, time=100})
                        display.getCurrentStage():setFocus(event.target, event.id)
                    elseif (event.phase=="moved") then
                    else
                        transition.to(event.target.circleAlpha, {alpha=0, xScale=0.75, yScale=0.75, time=100})
                        display.getCurrentStage():setFocus(event.target, nil)

                        if (event.target.alpha>0.75) then
                            if (event.target==circleFront) then
                                listId = listId + 1
                                circleBack.alpha = 1
                                circleBackText.alpha = 1
                                if (spritesArray[(listId-1)*10+12]==nil) then
                                    circleFront.alpha = 0.5
                                    circleFrontText.alpha = 0.5
                                end
                            else
                                listId = listId - 1
                                circleFront.alpha = 1
                                circleFrontText.alpha = 1
                                if (listId==1) then
                                    circleBack.alpha = 0.5
                                    circleBackText.alpha = 0.5
                                end
                            end
                            scroll:scrollToPosition({
                                y=0, time=0
                            })
                            loadList((listId-1)*10+1, (listId-1)*10+11)
                        end
                    end
                end
                return(true)
            end
            circleFront:addEventListener("touch", touchCircleList)
            circleBack:addEventListener("touch", touchCircleList)
            circleBack.alpha = 0.5
            circleBackText.alpha = 0.5
            if (#spritesArray<10) then
                circleFront.alpha = 0.5
                circleFrontText.alpha = 0.5
            end
        else
            onBack()
            cerberus.newBannerQuestion(words[550], nil, "", words[16])
        end
    end)


    funBackObjects[1] = onBack
end