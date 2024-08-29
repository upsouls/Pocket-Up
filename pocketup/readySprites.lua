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
    SCENES["scripts"][1].alpha = 1
    funBack = objs.oldFunBack
end

function scene_readySprites()
    objs.sceneGroup = display.newGroup()
    local sceneGroup = objs.sceneGroup
    local funBackObjects = {}
    objs.oldFunBack = funBack
    local topBarArray = topBar(sceneGroup, words[486], nil, nil, funBackObjects)
    topBarArray[4].alpha = 0
    local scroll = require('widget').newScrollView( {
        top=display.screenOriginY+topBarArray[1].height,
        left=display.screenOriginX,
        width=display.contentWidth,
        height=display.actualContentHeight-topBarArray[1].height,
        hideBackground=true,
        horizontalScrollDisabled=true,
        isBounceEnabled=false,
    } )

    objs.scroll = scroll

    sceneGroup:insert(scroll)

    local y = display.contentWidth/4+10
    local link = decodeString({104, 116, 116, 112, 115, 58, 47, 47, 112, 111, 99, 107, 101, 116, 45, 117, 112, 45, 115, 116, 111, 114, 97, 103, 101, 45, 100, 101, 102, 97, 117, 108, 116, 45, 114, 116, 100, 98, 46, 101, 117, 114, 111, 112, 101, 45, 119, 101, 115, 116, 49, 46, 102, 105, 114, 101, 98, 97, 115, 101, 100, 97, 116, 97, 98, 97, 115, 101, 46, 97, 112, 112})

    network.request( link..'/sprites.json', "GET", function(event)
        if not event.isError then
            -- загрузка листа готовых образов
            local sprites = json.decode(event.response)
            for i, v in pairs(sprites) do
                local params = {}
                params.progress = true
                network.download( v['link'], 'GET', function(event)
                    if event.phase == 'ended' then
                        local bg = display.newRect(CENTER_X, y, display.contentWidth, display.contentWidth/1.9)
                        bg:setFillColor(0, 71/255, 93/255)
                        scroll:insert(bg)
                        local obj = display.newImage(v['name']..'.png', system.TemporaryDirectory)
                        obj.link = v['link']
                        
                        obj.width = display.contentWidth/2
                        obj.height = display.contentWidth/2
                        local obj_bg = display.newRect(CENTER_X, y, obj.width+10, obj.height+5)
                        scroll:insert(obj_bg)
                        obj:toFront()
                        obj_bg.strokeWidth = 5
                        obj_bg:setFillColor(0, 71/255, 93/255)
                        obj_bg:setStrokeColor(171/255, 219/255, 1)

                        obj.x = bg.x
                        bg.name = v['name']
                        bg.ref = obj
                        bg.link = v['link']
                        obj.y = bg.y-25
                        scroll:insert(obj)
                        local name = display.newText(v['name'], CENTER_X, y+obj.height/2-25, native.systemFont, 35)

                        scroll:insert(name)
                        bg:addEventListener('touch', function(event)
                            if event.phase == 'began' then
                                event.target:setFillColor(24/255, 50/255, 60/255)
                            elseif event.phase == 'moved' then
                                local lc = math.abs((event.y - event.yStart))
                                if lc > 10 then
                                    event.target:setFillColor(0, 71/255, 93/255)
                                    objs.scroll:takeFocus(event)
                                end
                            elseif event.phase == 'ended' then
                                event.target:setFillColor(0/255, 71/255, 93/255)
                                local sprites = json.decode(funsP['получить сохранение'](IDOBJECT..'/images'))
                                local allocNewSprite = #sprites+1
                                local params = {}
                                params.progress = true
                                network.download( event.target.link, 'GET',  function(event)
                                    if event.phase == 'ended' then
                                        sprites[allocNewSprite] = {v['name'], allocNewSprite}
                                        funsP['записать сохранение'](IDOBJECT..'/images', json.encode(sprites))
                                        onBack()
                                    end
                                end, params, IDOBJECT..'/image_'..allocNewSprite..'.png', system.DocumentsDirectory)
                            end
                            return true
                        end)
                        y = y + bg.height
                        --obj.x = CENTER_X
                    end
                end, params, v['name']..'.png', system.TemporaryDirectory)
                --y = y + bounds.height+10
            end
        else
            print('error')
        end
    end)


    funBackObjects[1] = onBack
end