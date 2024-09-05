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

function scene_readySprites()
    objs.sceneGroup = display.newGroup()
    local sceneGroup = objs.sceneGroup
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

    local y = display.contentWidth/6
    local link = decodeString({104, 116, 116, 112, 115, 58, 47, 47, 112, 111, 99, 107, 101, 116, 45, 117, 112, 45, 115, 116, 111, 114, 97, 103, 101, 45, 100, 101, 102, 97, 117, 108, 116, 45, 114, 116, 100, 98, 46, 101, 117, 114, 111, 112, 101, 45, 119, 101, 115, 116, 49, 46, 102, 105, 114, 101, 98, 97, 115, 101, 100, 97, 116, 97, 98, 97, 115, 101, 46, 97, 112, 112})

    network.request( link..'/sprites.json', "GET", function(event)
        if not event.isError then
            -- загрузка листа готовых образов
            local sprites = json.decode(event.response)
            for i, v in pairs(sprites) do
                local params = {}
                params.progress = true
                if objs.gen then
                    network.download( v['link'], 'GET', function(event)
                        if event.phase == 'ended' then
                            pcall(function()
                                local bg = display.newRect(CENTER_X, y, display.contentWidth, display.contentWidth/3)
                                bg:setFillColor(0, 71/255, 93/255)
                                scroll:insert(bg)
                                bg.container = display.newContainer( display.contentWidth/4, display.contentWidth/4)
                                local obj = display.newImage(v['name']..'.png', system.TemporaryDirectory)
                                obj.link = v['link']
                                local obj_bg = display.newRect(20+bg.container.width/2, bg.y, bg.container.width, bg.container.height+5)
                                scroll:insert(obj_bg)
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
                                scroll:insert(bg.container)
                                local name = display.newText(v['name'], 0, bg.y, display.contentWidth-obj_bg.width-15, bg.height-50, native.systemFont, 35)
                                name.x = obj_bg.x + obj_bg.width/2 + name.width/2 + 15
                                name:setFillColor(170/255,218/255,240/255)

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
                            end)
                            --obj.x = CENTER_X
                        end
                    end, params, v['name']..'.png', system.TemporaryDirectory)
                else
                    break
                end
                --y = y + bounds.height+10
            end
        else
            print('error')
        end
    end)


    funBackObjects[1] = onBack
end