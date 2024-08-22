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

--[[ local function keysListener(event)
    if event == 'systemBack' then
        funBack = cache['oldfunback']
        topBar(cache['par'], cache.obj_name, nil, nil, funBack)
        display.setDefault("background", 4/255, 34/255, 44/255)
        isBackScene = 'back'
        cache['this']:removeSelf()
        cache['par'].isVisible = true
        cache = nil
    end
end
 ]]

function scene_viewsprite(idImage, parent)
    display.setDefault('background', 1, 1, 1)
    local groupScene = display.newGroup()
    cache['this'] = groupScene
    cache['par'] = parent
    cache['col'] = 'white'
    isBackScene = 'block'
    cache['oldfunback'] = funBack
    newBack = {}
    cache.obj_id = IDOBJECT:split('_')
    cache.obj_name = json.decode(funsP['получить сохранение'](IDSCENE..'/objects'))[tonumber(cache.obj_id[#cache.obj_id])][1]
    print(cache.obj_name)
    newBack[1] = keysListener
    funBack[1] = keysListener
    local sprites = json.decode(funsP['получить сохранение'](IDOBJECT..'/images'))
    local image = display.newImage(IDOBJECT..'/image_'..sprites[idImage][2]..'.png', system.DocumentsDirectory)
    image.x = CENTER_X
    image.y = CENTER_Y
    if image.width > display.actualContentWidth or image.height > display.actualContentHeight then
        image:scale((image.width/4500), (image.width/4500))
    end
    groupScene:insert(image)
    --Runtime:addEventListener('touch', touchBg)
    -- Реализуй кнопку назад
end