local cache = {}

local function touchBg(event)
    if event.phase == 'began' then
        if cache['col'] == 'black' then
            display.setDefault('background', 1, 1, 1)
            cache['col'] = 'white'
        else
            display.setDefault('background', 0, 0, 0)
            cache['col'] = 'black'
        end
    end
end


function scene_viewsprite(pathImage, nameImage)

    local groupScene = display.newGroup()
    local funBackObjects = {}
    local oldFunBack = funBack
    local topBarArray = topBar(groupScene, nameImage, nil, nil, funBackObjects)
    topBarArray[4].alpha = 0


    display.setDefault('background', 0, 0, 0)
    cache['col'] = 'black'
    local image = display.newImage(pathImage, system.DocumentsDirectory)
    image.x = CENTER_X
    image.y = CENTER_Y
    if image.width > display.actualContentWidth or image.height > display.actualContentHeight then
        image:scale((image.width/4500), (image.width/4500))
    end
    groupScene:insert(image)
    Runtime:addEventListener('touch', touchBg)
    -- Реализуй кнопку назад

    funBackObjects[1] = function()
        Runtime:removeEventListener('touch', touchBg)
        display.remove(groupScene)
        funBack = oldFunBack
        SCENES["scripts"][1].alpha = 1
        display.setDefault("background", 4/255, 34/255, 44/255)
    end
end