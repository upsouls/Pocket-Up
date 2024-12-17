lua = nil
local makeBlock_other = require("pocketup.gameAndBlocks.launchBlocks_other")
local makeBlock_cerberus = require("pocketup.gameAndBlocks.launchBlocks_cerberus")
local makeBlock_sotritmor = require("pocketup.gameAndBlocks.launchBlocks_sotritmor")
local _Vars = {}

local lang = system.getPreference( "locale", "language" )
local renameFormulas = calculateGameFormulas

function encodeList(event)
    local answer = ""
    for i=1, #event do
        if (i==1) then
            answer = event[i]
        else
            answer = answer..'\n'..event[i]
        end
    end
    return(answer)
end
local function decodeList(event)
    return(plugins.json.decode("["..event:gsub("\n",'","'):gsub("\r\n",'","').."]"))
end


local function make_all_formulas(formulas, object)
    local tableInfoObject = {
        {'size',"("..object..".property_size)"},{'direction',"("..object..".rotation)"},{'directionView',"("..object..".rotation/2)"},{'positionX',object..".x"},
        {'positionY',"(-("..object..".y))"},{'speedX', 'pocketupFuns.getLinearVelocity('..object..',"x")'},{'speedY', 'pocketupFuns.getLinearVelocity('..object..',"y")'},
        {'angularVelocity', '('..object..'.angularVelocity==nil and o or '..object..'.angularVelocity)'},{'transparency', "math.round((1-"..object..".alpha)*100)"},{"numberImage", object..".numberImage"},{"brightness",object..".property_brightness"},
        {'color', object..".property_color"},{"nameImage", "listNamesImages["..object..".numberImage]"},{"touchesFinger","("..object..".isTouch==true)"},{"touchesObject","pocketupFuns.countTouchesObjects("..object..")"},
        {'countImages', "#listNamesImages"},
    }
    for i=1, #tableInfoObject do
        renameFormulas[tableInfoObject[i][1]] = tableInfoObject[i][2]
    end

    local answer = "("
    for i=1, #formulas do
        local formula = formulas[i]
        if (formula[1]=="number") then
            if (type(formula[2])=="number" or formula[2]==".") then
                answer = answer..formula[2]
            else
                answer = answer.."0"
            end
        elseif (formula[1]=="text") then
            answer = answer.." '"..formula[2]:gsub('\r\n','\\n'):gsub('\n','\\n'):gsub("'","\\'").."' "
        elseif (formula[1]=="globalVariable") then
            answer = answer.." var_"..formula[2].." "
        elseif (formula[1]=="localVariable") then
            answer = answer.." "..object..".var_"..formula[2].." "
        elseif (formula[1]=="globalArray") then
            answer = answer.." list_"..formula[2].." "
        elseif (formula[1]=="localArray") then
            answer = answer.." "..object..".list_"..formula[2].." "
        elseif (formula[1]=="function" and formula[2]=="touchesObject2") then
            answer = answer.." ".."pocketupFuns.isTouchObject2(target, "..formula[3]..") "
        else
            answer = answer.." "..renameFormulas[formula[2]].." "
        end
    end
    answer = answer..")"
    return(answer)
end

local isEvent = {
    start=true, touchObject=true, touchScreen=true, ["function"]=true, whenTheTruth=true, collision=true, changeBackground=true, startClone=true,
    movedObject=true, onTouchObject=true, movedScreen=true, onTouchScreen=true, touchBack=true, endedCollision=true,
    keypressed=true, endKeypressed = true
}

function noremoveAllObjects()
    local stage = display.getCurrentStage()

    for i = stage.numChildren, 1, -1 do
        local child = stage[i]
        if child then
            child._notRemove = true
        end
    end
end

function removeAllObjects()
    local stage = display.getCurrentStage()

    for i = stage.numChildren, 1, -1 do
        local child = stage[i]
        if child then
            if child._notRemove ~= true then
            child:removeSelf()
            child = nil
            end
        end
    end
end


function scene_run_game(typeBack, paramsBack)
    BlocksAllHandlers = {}
    local moduleHandlers = {'data', 'control', 'textFields', 'sounds', 'physics', 'pen', 'particles', 'miniScenes', 'images', 'elementInterface', 'device'}
    for _, module in ipairs(moduleHandlers) do
        for key, value in pairs(require('pocketup.gameAndBlocks.launchBlocks.'..module)) do
            BlocksAllHandlers[key] = value
        end
    end
    --utils.isSim = false
    app.scene="game"
    app.words = {}

    native.setProperty("windowMode", "fullscreen")
    display.setDefault('background', 1, 1, 1)

    local options = plugins.json.decode(funsP['получить сохранение'](app.idProject..'/options'))
    if utils.isWin or utils.isSim then
        options.orientation = "vertical"
    end

    renameFormulas.displayWidth = "("..tostring(options.orientation == "vertical" and options.displayWidth or options.displayHeight)..")"
    renameFormulas.displayHeight = "("..tostring(options.orientation == "vertical" and options.displayHeight or options.displayWidth)..")"
    renameFormulas.displayActualWidth = "("..tostring(options.orientation == "vertical" and display.actualContentWidth or display.actualContentHeight)..")"
    renameFormulas.displayActualHeight = "("..tostring(options.orientation == "vertical" and display.actualContentHeight or display.actualContentWidth)..")"

    local isScriptsBack = false
    local dW, dH, dCX, dCY, sOX, sOY = display.actualContentWidth, display.contentHeight, CENTER_X, CENTER_Y, display.screenOriginX, display.screenOriginY


    function showOldScene()
        app.words = require("pocketup.modules.loadLanguage")
        native.setProperty("windowMode", "normal")
        display.setDefault("background", 4/255, 34/255, 44/255)

        plugins.orientation.lock('portrait')
    
        display.screenOriginX, display.screenOriginY = sOX, sOY
        display.contentWidth, display.contentHeight = dW, dH
        display.contentCenterX = dCX
        CENTER_X = dCX
        CENTER_Y = dCY
        collectgarbage('collect')
        if not IsBuild then
            if (typeBack=="scripts") then
                scene_scripts(paramsBack[1], paramsBack[2], paramsBack[3])
            elseif (typeBack=="objects") then
                scene_objects(paramsBack[1], paramsBack[2], paramsBack[3])
            elseif (typeBack=="scenes") then
                scene_scenes(paramsBack[1], paramsBack[2])
            end
        else
            os.exit()
        end
    end

    max_fors = 0

-- Запуск
lua = ''
if true then
-- Генерация lua кода
local scenes = plugins.json.decode(funsP['получить сохранение'](app.idProject..'/scenes'))

lua = lua..options.orientation=="horizontal" and "plugins.orientation.lock('landscape')" or ""
lua = lua..[==[
system.activate('multitouch')
plugins.physics.start(true)

local function getImageProperties(path, dir)
    local image = display.newImage(path, dir)
    image.alpha=0

    local width = image.width
    local height = image.height
    display.remove(image)

    return width, height
end
]==]

lua = lua..
[==[
local thread = require('plugins.thread')
local joysticks = {}
local Timers = {}
local Timers_max = 0
local globalConstants = {
    isTouch=false,
    touchX=0,
    touchY=0,
    touchId=0,
    keysTouch={},
    touchsXId={},
    touchsYId={},
    isTouchsId={}
}
]==]

lua = lua..
[==[
-- Функции покет апа
local pocketupFuns = {}
pocketupFuns.sin = function(v)
    return(math.sin(math.rad(v)))
end
pocketupFuns.cos = function(v)
    return(math.cos(math.rad(v)))
end
pocketupFuns.tan = function(v)
    return(math.tan(math.rad(v)))
end
pocketupFuns.asin = function(v)
    return(math.deg(math.asin(v)))
end
pocketupFuns.acos = function(v)
    return(math.deg(math.acos(v)))
end
pocketupFuns.atan = function(v)
    return(math.deg(math.atan(v)))
end
pocketupFuns.atan2 = function(v, v2)
    return(math.deg(math.atan2(v, v2)))
end
pocketupFuns.roundUp = function(v)
    return(math.floor(v)+1)
end
pocketupFuns.connect = function(v,v2,v3)
    return(v..v2..(v3==nil and '' or v3))
end
pocketupFuns.ternaryExpression = function(condition, answer1, answer2)
    return(condition and answer1 or answer2)
end
pocketupFuns.regularExpression = function(regular, expression)
    return(string.match(expression, regular))
end
pocketupFuns.characterFromText = function(pos, value)
    return(plugins.utf8.sub(value,pos,pos))
end

pocketupFuns.getLinearVelocity = function(object, xOrY)
    if (object.physicsReload == nil) then
        return(0)
    else
        local vx, vy = object:getLinearVelocity()
        return(xOrY=='x' and vx or vy)
    end
end
pocketupFuns.getEllementArray = function(element, array)
    return(array[element]==nil and '' or array[element])
end
pocketupFuns.containsElementArray = function(array, value)
    local isElement = false
    for i=1, #array do
        if (array[i]==value) then
            isElement = true
            break
        end
    end
    return(isElement)
end
pocketupFuns.getIndexElementArray = function(array, value)
    local index = 0
    for i=1, #array do
        if (array[i]==value) then
            index = i
            break
        end
    end
    return(index)
end
pocketupFuns.levelingArray = function(array)
    return(array)
end
pocketupFuns.displayPositionColor = function(x,y)
    local hexColor
    local function onColorSample(event)
        hexColor = utils.rgbToHex({event.r, event.g, event.b})
        return(hexColor)
    end
    display.colorSample(CENTER_X+x, CENTER_Y-y, onColorSample)
    return(hexColor)
end

globalConstants.getTouchXId = function(id)
    local answer = globalConstants.touchsXId[globalConstants.keysTouch['touch_'..id]]
    return(answer==nil and 0 or answer)
end
globalConstants.getTouchYId = function(id)
    local answer = globalConstants.touchsYId[globalConstants.keysTouch['touch_'..id]]
    return(answer==nil and 0 or answer)
end
pocketupFuns.getIsTouchId = function(id)
    return(globalConstants.isTouchsId[globalConstants.keysTouch['touch_'..id]]==true)
end
pocketupFuns.getCountTouch = function ()
    local count = 0
    for k, v in pairs(globalConstants.isTouchsId) do
        count = count + 1
    end
    return(count)
end
pocketupFuns.jsonEncode = function(table2)
    local table = nil
    pcall(function()
        table = plugins.json.decode(table2)
    end)
    if (table==nil) then
        return('')
    else
        local array = ''
        for k, v in pairs(table) do
            array = array..(array=='' and '' or '\\n')..v
        end
        return(array)
    end
end
pocketupFuns.isTouchObject2 = function(target, id)
    return(target.touchesObjects['obj_'..id]==true)
end
pocketupFuns.countTouchesObjects = function(target)
    local isTouch = false
    for v, k in pairs(target.touchesObjects) do
        isTouch = true
        break
    end
    return(isTouch)
end
]==]

-- Глобальные переменные
local globalVariables = plugins.json.decode(funsP['получить сохранение'](app.idProject..'/variables'))
for i=1, #globalVariables do
    lua = lua.."var_"..globalVariables[i][1].." = 0\n"
end

-- Глобальные массивы
local globalArrays = plugins.json.decode(funsP['получить сохранение'](app.idProject..'/arrays'))
for i=1, #globalArrays do
    lua = lua.."list_"..globalArrays[i][1].." = {}\n"
end

lua = lua..
[==[
local myScene

local WebViews = {}
local textFields = {}
local objects = {}

local events_touchBack = {}
local events_keypressed = {}
local events_endKeypressed = {}
local events_touchScreen = {}
local events_movedScreen = {}
local events_onTouchScreen = {}

local mainGroup

local playSounds = {}
local playingSounds = {}

local mouseX, mouseY = 0, 0
local mouseListener = function(event)
    mouseX, mouseY = (event.x - mainGroup.x) / mainGroup.xScale, -(event.y - mainGroup.y) / mainGroup.yScale
end
Runtime:addEventListener('mouse', mouseListener)
]==]

-- Сцены
for s=1, #scenes do
    local scene_id = scenes[s][2]
    local scene_path = app.idProject.."/scene_"..scene_id
    local xScaleMainGroup = display.contentWidth / options.displayWidth
    local yScaleMainGroup = display.contentHeight / options.displayHeight

    lua = lua..
    [[


-- Сцена
function scene_]]..scene_id..[[()
    mainGroup = display.newGroup()
    mainGroup.iscg = true

    mainGroup.xScale = ]]..tostring(options.orientation~="vertical" and not options.aspectRatio and yScaleMainGroup or xScaleMainGroup)..[[
    mainGroup.yScale = ]]..tostring(options.orientation=="vertical" and  not options.aspectRatio and yScaleMainGroup or xScaleMainGroup)..[[
    mainGroup.x, mainGroup.y = ]]..(options.orientation=="vertical" and "CENTER_X, CENTER_Y" or "CENTER_Y, CENTER_X")..[[
    

    app.scene = 'game'
    app.scenes[app.scene] = {mainGroup}

    local cameraGroup = display.newGroup()
    mainGroup:insert(cameraGroup)

    local stampsGroup = display.newGroup()
    cameraGroup:insert(stampsGroup)

    local notCameraGroup = display.newGroup()
    mainGroup:insert(notCameraGroup)

    local focusCameraObject = nil
    ]]
    lua = lua..(not options.aspectRatio and "" or "local blackRectTop = display.newRect("..(options.orientation=="vertical" and ("0,-"..tostring(options.displayHeight/2)..","..tostring(options.displayWidth)..",display.contentHeight") or ("-"..tostring(options.displayHeight/2)..",0,display.contentHeight,"..tostring(options.displayWidth) ))..")\nblackRectTop.anchor"..(options.orientation=="vertical" and "Y" or "X").." = 1\nblackRectTop:setFillColor(0,0,0)\nmainGroup:insert(blackRectTop)\nlocal blackRectBottom = display.newRect("..(options.orientation=="vertical" and ("0,"..tostring(options.displayHeight/2)..","..tostring(options.displayWidth)..",display.contentHeight") or (tostring(options.displayHeight/2)..",0,display.contentHeight,"..tostring(options.displayWidth) ))..")\nblackRectBottom.anchor"..(options.orientation=="vertical" and "Y" or "X").." = 0\nblackRectBottom:setFillColor(0,0,0)\nmainGroup:insert(blackRectBottom)")
    
    lua = lua..
    [[
    objects = {}
    local events_changeBackground = {}
    local events_function = {}
    
    local function broadcastFunction(nameFunction)
        for key, value in pairs(objects) do
            for i=1, #events_function[key][nameFunction] do
                events_function[key][nameFunction][i](value)
                for i2=1, #value.clones do
                    events_function[key][nameFunction][i](value.clones[i2])
                end
            end
        end
    end

    local tableVarShow = {}
    local tableNamesClones = {}

    local miniScenes = display.newGroup()
    cameraGroup:insert(miniScenes)

    myScene = ']]..scene_path..[['
    
    ]]
    
    -- Объекты из сцены
    local objects = plugins.json.decode(funsP['получить сохранение'](scene_path.."/objects"))
    local functions = plugins.json.decode(funsP['получить сохранение'](scene_path.."/functions"))

    for i=1, #objects do
        if type(objects[i][2]) ~= "string" then

            lua = lua.."\nevents_function['object_"..objects[i][2].."'] = {}"
            for i2=1, #functions do

                lua = lua.."\nevents_function['object_"..objects[i][2].."']['fun_"..functions[i2][1].."'] = {}"
            end
        end

        lua = lua..
        "\nevents_touchBack['object_"..objects[i][2].."'] = {}"..
        "\nevents_touchScreen['object_"..objects[i][2].."'] = {}"..
        "\nevents_movedScreen['object_"..objects[i][2].."'] = {}"..
        "\nevents_onTouchScreen['object_"..objects[i][2].."'] = {}"..
        "\nevents_changeBackground['object_"..objects[i][2].."'] = {}"..
        "\nevents_keypressed['object_"..objects[i][2].."'] = {}"..
        "\nevents_endKeypressed['object_"..objects[i][2].."'] = {}"
    end

    lua = lua..
    [==[
    local function broadcastChangeBackground(numberImage)
        for key, value in pairs(objects) do
            for i = 1, #events_changeBackground[key] do
                events_changeBackground[key][i](value, numberImage)
                for i2 = 1, #value.clones do
                    events_changeBackground[key][i](value.clones[i2], numberImage)
                end
            end
        end
    end
    ]==]

        for o = 1, #objects do
            if type(objects[o][2]) ~= "string" then

            local obj_id = objects[o][2]
            local obj_path = scene_path.."/object_"..obj_id
            local obj_images = plugins.json.decode(funsP['получить сохранение'](obj_path.."/images"))
            local obj_sounds = plugins.json.decode(funsP['получить сохранение'](obj_path.."/sounds"))
        
            lua = lua..
            [=[
            pcall(function()
                local objectsParticles = {}
                local listImages = {
            ]=]

            for i=1, #obj_images do
                lua = lua..(i == 1 and "" or ",")..obj_images[i][2]
            end
            lua = lua.."}\nlocal listNamesImages = {"
            for i=1, #obj_images do
                lua = lua..(i == 1 and "'" or "','")..obj_images[i][1]:gsub("'","\\'"):gsub(( utils.isWin and "\r\n" or "\n"),"\\n")
            end
            if (#obj_images==0) then lua = lua.."}\nlocal listSounds = {" else lua = lua.."'}\nlocal listSounds = {" end
            for i=1, #obj_sounds do
                lua = lua..(i == 1 and "" or ",")..obj_sounds[i][2]
            end
            lua = lua..
            [==[
            }

            tableFeathers = {}
            tableFeathersOptions = {3.5, 0, 0, 255}
            ]==]

            if (#obj_images>0) then
                lua = lua.."\nlocal object_"..obj_id.." = display.newImage('"..obj_path.."/image_"..obj_images[1][2]..".png', system.DocumentsDirectory)"
                lua = lua.."\nobject_"..obj_id..".image_path = '"..obj_path.."/image_"..obj_images[1][2]..".png'"
                --lua = lua.."\nobject_"..obj_id..".timers = {}"
            else
                lua = lua.."\n\nlocal object_"..obj_id.." = display.newImage('images/notVisible.png')"
            end

            lua = lua..
            [[
            object_]]..obj_id..[[.infoSaveVisPos = ]]..tostring(o)..[[

            local objectsTable = plugins.json.decode(funsP['получить сохранение'](']]..scene_path..[[/objects'))
            objectsTable[object_]]..obj_id..[[.infoSaveVisPos][3] = nil

            funsP['записать сохранение'](']]..scene_path..[[/objects', plugins.json.encode(objectsTable))
            cameraGroup:insert(object_]]..obj_id..[[)
            object_]]..obj_id..[[.touchesObjects = {}
            ]]
            if o == 1 then
                lua = lua..
                "local background = object_"..obj_id.."\
                background.listImagesBack, background.listNamesImagesBack, background.obj_pathBack = listImages, listNamesImages, '"..obj_path.."'"
            end

            lua = lua..
            "\nobject_"..obj_id..".parent_obj = object_"..obj_id.."\
            object_"..obj_id..".clones = {}\
            objects['object_"..obj_id.."'], object_"..obj_id..".idObject = object_"..obj_id..", "..obj_id.."\
            object_"..obj_id..".numberImage = 1\n\n"
            lua = lua.."object_"..obj_id..".tableVarShow, object_"..obj_id..".origWidth, object_"..obj_id..".origHeight, object_"..obj_id..".nameObject, object_"..obj_id..".property_size, object_"..obj_id..".property_brightness, object_"..obj_id..".property_color = {}, object_"..obj_id..".width, object_"..obj_id..".height, 'object_"..obj_id.."', 100, 100, 0\n"
            lua = lua.."object_"..obj_id..".countImages = "..tostring(#obj_images).."\n"

            -- Локальные переменные
            local localVariables = plugins.json.decode(funsP['получить сохранение'](obj_path.."/variables"))
            lua = lua.."object_"..obj_id..".namesVars = {}\n"
            for i = 1, #localVariables do
                lua = lua.."object_"..obj_id..".var_"..localVariables[i][1].." = 0\n"
                lua = lua.."object_"..obj_id..".namesVars["..i.."] = 'var_"..localVariables[i][1].."'\n"
            end

            -- Локальные массивы
            local localArrays = plugins.json.decode(funsP['получить сохранение'](obj_path.."/arrays"))
            lua = lua.."object_"..obj_id..".namesLists = {}\n"
            for i=1, #localArrays do
                lua = lua.."object_"..obj_id..".list_"..localArrays[i][1].." = {}\n"
                lua = lua.."object_"..obj_id..".namesLists["..i.."] = 'list_"..localArrays[i][1].."'\n"
            end

            lua = lua.."\n\nlocal events_start = {}\nlocal events_touchObject = {} object_"..obj_id..".events_touchObject = events_touchObject\n\nlocal events_movedObject = {} object_"..obj_id..".events_movedObject = events_movedObject\nlocal events_onTouchObject = {} object_"..obj_id..".events_onTouchObject = events_onTouchObject\nlocal events_collision = {} object_"..obj_id..".events_collision = events_collision\nlocal events_endedCollision = {}  object_"..obj_id..".events_endedCollision = events_endedCollision\nlocal events_startClone = {}\n object_"..obj_id..".events_startClone = events_startClone"
            lua = lua.."\nobject_"..obj_id..".group = cameraGroup"
            lua = lua..
            [[
            object_]]..obj_id..[[:addEventListener('touch', function(event)
                if (event.phase=='began') then
                    local newIdTouch=globalConstants.touchId+1
                    globalConstants.touchId = newIdTouch
                    globalConstants.keysTouch['touch_'..newIdTouch], globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = event.id, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale, true
                    globalConstants.isTouch, globalConstants.touchX, globalConstants.touchY = true, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale
                    display.getCurrentStage():setFocus(event.target, event.id)
                    event.target.isTouch = true
                    for key, value in pairs(objects) do
                        for i=1, #events_touchScreen[key] do
                            events_touchScreen[key][i](value)
                            for i2=1, #value.clones do
                                events_touchScreen[key][i](value.clones[i2])
                            end
                        end
                    end
                    for i=1, #events_touchObject do
                        events_touchObject[i](event.target)
                    end
                elseif (event.phase=='moved') then
                    globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id] = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale
                    globalConstants.touchX, globalConstants.touchY = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale
                    for key, value in pairs(objects) do
                        for i=1, #events_movedScreen[key] do
                            events_movedScreen[key][i](value)
                            for i2=1, #value.clones do
                                events_movedScreen[key][i](value.clones[i2])
                            end
                        end
                    end
                    for i=1, #events_movedObject do
                        events_movedObject[i](event.target)
                    end
                else
                    display.getCurrentStage():setFocus(event.target, nil)
                    globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = nil, nil, nil
                    if (pocketupFuns.getCountTouch(globalConstants.isTouchsId)==0) then
                        globalConstants.keysTouch = {}
                        globalConstants.isTouch = false
                    end
                    event.target.isTouch = nil
                    for key, value in pairs(objects) do
                        for i=1, #events_onTouchScreen[key] do
                            events_onTouchScreen[key][i](value)
                            for i2=1, #value.clones do
                                events_onTouchScreen[key][i](value.clones[i2])
                            end
                        end
                    end
                    for i=1, #events_onTouchObject do
                        events_onTouchObject[i](event.target)
                    end
                end
                return true
            end)
            ]]

            -- Блоки
            local blocks = plugins.json.decode(funsP['получить сохранение'](obj_path.."/scripts"))
            local oldEventName = nil
            for b=1, #blocks do
                local block = blocks[b]
                if (isEvent[block[1]]) then
                    if (b>1) then
                            lua = lua..
                            "removeTheard()\
                            end)\
                            local pStart\
                            pStart, tTheard = thread.start(p)\n"
                        if (oldEventName=="changeBackground" or oldEventName=="collision" or oldEventName=="endedCollision") then
                            lua = lua.."\nend"
                        end
                        lua = lua.."\nend\n"
                    end
                    if (block[1]=="function") then
                        lua = lua.."\nevents_function['object_"..obj_id.."']['fun_"..block[2][1][2].."'][ #events_function['object_"..obj_id.."']['fun_"..block[2][1][2].."'] + 1] = function (target)\
                            Timers_max = Timers_max+1\
                            local tTheard\
                            local removeTheard = function()\
                                thread.cancel(tTheard)\
                            end\
                            local p\
                            p = coroutine.create(function()\
                                local threadFun = require('plugins.threadFun')\n"
                    elseif block[1]=="keypressed" or block[1]=="endKeypressed" then
                        lua = lua.."\nevents_"..block[1].."['object_"..obj_id.."'][ #events_"..block[1].."['object_"..obj_id.."'] + 1] = function (e, target)\
                            local value = e.keyName\n"
                            if block[2][1][1] == 'globalVariable' then
                                lua = lua..'var_'..block[2][1][2]..' = value\n'
                                lua = lua..'if varText_'..block[2][1][2]..' then\n varText_'..block[2][1][2]..'.text = type(var_'..block[2][1][2]..')=="boolean" and (var_'..block[2][1][2]..' and app.words[373] or app.words[374]) or type(var_'..block[2][1][2]..')=="table" and encodeList(var_'..block[2][1][2]..') or var_'..block[2][1][2]..'\nend\n'
                            else
                                lua = lua..'target.var_'..block[2][1][2]..' = value\n'
                                lua = lua..'if target.varText_'..block[2][1][2]..' then\n target.varText_'..block[2][1][2]..'.text = type(target.var_'..block[2][1][2]..')=="boolean" and (target.var_'..block[2][1][2]..' and app.words[373] or app.words[374]) or type(target.var_'..block[2][1][2]..')=="table" and encodeList(target.var_'..block[2][1][2]..') or target.var_'..block[2][1][2]..'\nend\n'
                            end
                            lua = lua.."Timers_max = Timers_max+1\
                            local tTheard\
                            local removeTheard = function()\
                                thread.cancel(tTheard)\
                            end\
                            local p\
                            p = coroutine.create(function()\
                                local threadFun = require('plugins.threadFun')\n"
                    elseif (block[1]=="touchScreen" or block[1]=="movedScreen" or block[1]=="onTouchScreen" or block[1]=="touchBack") then
                        if (block[1]=="touchBack" and block[3]=="on") then
                            isScriptsBack = true
                        end
                        lua = lua.."\nevents_"..block[1].."['object_"..obj_id.."'][ #events_"..block[1].."['object_"..obj_id.."'] + 1] = function (target)\n\
                            Timers_max = Timers_max+1\
                            local tTheard\
                            local removeTheard = function()\
                                thread.cancel(tTheard)\
                            end\
                            local p\
                            p = coroutine.create(function()\
                                local threadFun = require('plugins.threadFun')\n"

                    elseif (block[1]=="changeBackground") then
                        lua = lua.."\nevents_changeBackground['object_"..obj_id.."'][ #events_changeBackground['object_"..obj_id.."'] + 1] = function (target, numberImage)\
                            if (numberImage == "..(type(block[2][1][2])=="boolean" and "'off'" or block[2][1][2])..") then\
                                Timers_max = Timers_max+1\
                                local tTheard\
                                local removeTheard = function()\
                                thread.cancel(tTheard)\
                                end\
                                local p\
                                p = coroutine.create(function()\
                                    local threadFun = require('plugins.threadFun')\n"
                    elseif (block[1]=="collision" or block[1]=="endedCollision") then
                        lua = lua.."\nevents_"..block[1].."[ #events_"..block[1].." + 1] = function (target, idObject)\
                            if ("..(block[2][1][2]==nil and "true" or "idObject == 'object_"..block[2][1][2].."'")..") then\
                                Timers_max = Timers_max+1\
                                local tTheard\
                                local removeTheard = function()\
                                    thread.cancel(tTheard)\
                                end\
                                local p\
                                p = coroutine.create(function()\
                                    local threadFun = require('plugins.threadFun')\n"
                    else
                        lua = lua.."\nevents_"..block[1].."[ #events_"..block[1].." + 1] = function (target)\
                            Timers_max = Timers_max+1\
                            local tTheard\
                            local removeTheard = function()\
                                thread.cancel(tTheard)\
                            end\
                            local p\
                            p = coroutine.create(function()\
                                local threadFun = require('plugins.threadFun')\n"
                    end
                    oldEventName = block[1]
                    -- if (oldEventName=="start") then
                    --     lua = lua.."\ntimer.new(0, function ()"
                    -- end
                else
                    local luaBlock = makeBlock_other(block, 'target', obj_images, obj_sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)..'\n'
                    if (luaBlock~=nil and luaBlock~="") then
                        lua = lua.."\n"..luaBlock..'\n'
                    else
                    local luaBlock = makeBlock_cerberus(block, 'target', make_all_formulas, obj_id, obj_path, scene_id, scene_path, options)
                    if (luaBlock~=nil and luaBlock~="") then
                        lua = lua.."\n"..luaBlock..'\n'
                    else
                    local luaBlock = makeBlock_sotritmor(block, 'target', make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, b)
                    if (luaBlock~=nil and luaBlock~="") then
                        lua = lua.."\n"..luaBlock..'\n'
                    else
                    end
                    end
                    end
                end

            end
            
            if (#blocks~=0) then
                if (oldEventName=="start") then
                    lua = lua..
                    "removeTheard()\
                    end)\
                    local pStart\
                    pStart, tTheard = thread.start(p)\
                end\n\n"
                    -- lua = lua..'\nend)\nend\n\n'
                elseif (oldEventName=="changeBackground" or oldEventName=="collision" or oldEventName=="endedCollision") then
                    lua = lua..
                    "removeTheard()\
                    end)\
                    local pStart\
                    pStart, tTheard = thread.start(p)"
                    lua = lua..'\nend\nend\n\n'
                
                else
                    lua = lua..
                    "removeTheard()\
                    end)\
                    local pStart\
                    pStart, tTheard = thread.start(p)"
                    lua = lua..'\nend\n\n'
                end
            end
            lua = lua.."\nfor i=1, #events_start do\n    events_start[i](object_"..obj_id..")\nend\n"
            lua = lua.."\nend)\n"
            end
        end

        lua = lua.."\nend"
    end
    lua = lua.."\nscene_"..scenes[1][2].."()\n"
    lua = lua.."local function touchScreenGame(event)\
        if (event.phase=='began') then\
            local newIdTouch=globalConstants.touchId+1\
            globalConstants.touchId = newIdTouch\
            globalConstants.keysTouch['touch_'..newIdTouch], globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = event.id, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale, true\
            globalConstants.isTouch, globalConstants.touchX, globalConstants.touchY = true, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\
            for key, value in pairs(objects) do\
                for i=1, #events_touchScreen[key] do\
                    events_touchScreen[key][i](value)\
                    for i2=1, #value.clones do\
                        events_touchScreen[key][i](value.clones[i2])\
                    end\
                end\
            end\
        elseif (event.phase=='moved') then\nglobalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id] = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\nglobalConstants.touchX, globalConstants.touchY = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\nfor key, value in pairs(objects) do\nfor i=1, #events_movedScreen[key] do\nevents_movedScreen[key][i](value)\nfor i2=1, #value.clones do\nevents_movedScreen[key][i](value.clones[i2])\nend\nend\nend\nelse\nglobalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = nil, nil, nil\nif (pocketupFuns.getCountTouch(globalConstants.touchsXId)==0) then\nglobalConstants.keysTouch = {}\nglobalConstants.isTouch=false\nend\nfor key, value in pairs(objects) do\nfor i=1, #events_onTouchScreen[key] do\nevents_onTouchScreen[key][i](value)\nfor i2=1, #value.clones do\nevents_onTouchScreen[key][i](value.clones[i2])\nend\nend\nend\nend\nend"
    lua = lua.."\nRuntime:addEventListener('touch', touchScreenGame)\n\n"

--[[
local newIdTouch=globalConstants.touchId+1\nglobalConstants.touchId = newIdTouch\nglobalConstants.keysTouch['touch_'..newIdTouch], globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = event.id, event.x, event.y, true
globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = event.x, event.y
globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = nil, nil, nil\nif (#globalConstants.isTouchsId==0) then\nglobalConstants.keysTouch = {}\nglobalConstants.isTouch = nil\nend
]]
lua = lua..
"\nlocal funKeyListener = function(e)\
    if e.phase == 'down' then\
        for key, value in pairs(objects) do\
            for i=1, #events_keypressed[key] do\
                events_keypressed[key][i](e, value)\
                for i2=1, #value.clones do\
                    events_keypressed[key][i](e, value.clones[i2])\
                end\
            end\
        end\
    else\
        for key, value in pairs(objects) do\
            for i=1, #events_endKeypressed[key] do\
                events_endKeypressed[key][i](e, value)\
                for i2=1, #value.clones do\
                    events_endKeypressed[key][i](e, value.clones[i2])\
                end\
            end\
        end\
    end\
    return(true)\
end\
Runtime:addEventListener('key', funKeyListener)\n"

    lua = lua.."\nfunction exitGame()\nRuntime:removeEventListener('mouse', mouseListener)\nRuntime:removeEventListener('key', funKeyListener)\nplugins.physics.setDrawMode('normal')\nsystem.deactivate('multitouch')\nplugins.physics.stop()\nRuntime:removeEventListener('touch', touchScreenGame)\nshowOldScene()\nend"
    lua = lua.."\nfunction deleteScene()\
    thread.cancelAll()\
    for key, value in pairs(objects) do\
        local target = value\
        pcall(function()\
            \nif (target.parent_obj==target) then\
                local objectsTable = plugins.json.decode(funsP['получить сохранение'](myScene..'/objects'))\
                if (objectsTable[target.infoSaveVisPos][3]==nil) then\
                    objectsTable[target.infoSaveVisPos][3] = {}\
                end\
                objectsTable[target.infoSaveVisPos][3].size = target.property_size/100\
                objectsTable[target.infoSaveVisPos][3].rotation = target.rotation\
                funsP['записать сохранение'](myScene..'/objects', plugins.json.encode(objectsTable))\
            end\
        end)\
    end\
    local events_keypressed = {}\
    local events_endKeypressed = {}\
    plugins.physics.setDrawMode('normal')\
    removeAllObjects()\
    timer.cancelAll()\
    collectgarbage('collect')\
    "..(options.orientation=="vertical" and "plugins.orientation.lock('portrait')" or "plugins.orientation.lock('landscape')").."\ndisplay.remove(mainGroup)\nfor key, value in pairs(playingSounds) do\naudio.stop(playingSounds[key])\naudio.dispose(playSounds[key])\nend\nplaySounds = {}\nplayingSounds = {}\nnative.setProperty('windowMode', 'fullscreen')\nend"
    if (isScriptsBack) then
        lua = lua.."\nfunction funBackListener(event)\nif ((event.keyName=='back' or event.keyName=='deleteBack') and event.phase=='up') then\nfor key, value in pairs(objects) do\nfor i=1, #events_touchBack[key] do\nevents_touchBack[key][i](value)\nfor i2=1, #value.clones do\nevents_touchBack[key][i](value.clones[i2])\nend\nend\nend\nend\nreturn(true)\nend\nRuntime:addEventListener('key', funBackListener)"
    else
        lua = lua.."\nfunction funBackListener(event)\nif ((event.keyName=='back' or event.keyName=='deleteBack') and event.phase=='up') then\nlocal rect = display.newImage('images/notVisible.png')\nmainGroup:insert(rect)\nrect.width, rect.height = "..(options.orientation == "vertical" and display.contentWidth or display.contentHeight)..", "..(options.orientation == "vertical" and display.contentHeight or display.contentWidth).."\nrect:toBack()\nrect.alpha = 0.004\ndisplay.save(mainGroup,{ filename=myScene..'/icon.png', baseDir=system.DocumentsDirectory, backgroundColor={1,1,1,1}})\nRuntime:removeEventListener('key',funBackListener)\naudio.stop({channel=1})\ndeleteScene()\nexitGame()\nplugins.orientation.lock('portrait')\nend\nreturn(true)\nend\nRuntime:addEventListener('key', funBackListener)"
    end
        lua = lua.."\nfunction funBackListener2(event)\nif ((event.keyName=='back' or event.keyName=='deleteBack') and event.phase=='up') then\nRuntime:removeEventListener('key',funBackListener)\naudio.stop({channel=1})\ndeleteScene()\nexitGame()\nplugins.orientation.lock('portrait')\nend\nend"
    --lua = lua.."\ntimer.new(100,function()\nif (mainGroup~=nil and mainGroup.x~=nil) then\ndisplay.save(mainGroup,{ filename=myScene..'/icon.png', baseDir=system.DocumentsDirectory, backgroundColor={1,1,1,1}})\nend\nend)\n"
    --lua = lua:gsub("prem", "prеm"):gsub("Prem", "Prеm")
else
    lua = lua .. require('pocketup.gameAndBlocks.projectCode')
end
    noremoveAllObjects()
    collectgarbage('collect')
    BlocksAllHandlers = {}
    local f, error_msg = loadstring(lua)
    --print(lua)
    if false then
        pcall(function ()
            local export = require('plugins.export')
            local file = io.open(system.pathForFile('', system.TemporaryDirectory)..'/debugCode.txt', 'w')
            file:write(lua)
            file:close()
            export.export {
                path = system.pathForFile('debugCode.txt', system.TemporaryDirectory),
                name = 'debugCode_'..app.idProject..'.lua',
                listener = function ()
                    
                end
            }
        end)
    end
    if f then
        local status, error_msg = pcall(f)
        if not status then
          local line_number = tonumber(string.match(error_msg, "%d+"))
          error("Ошибка:".. error_msg .. " строка:" .. line_number)
        else
          return error_msg
        end
      else
        local line_number = tonumber(string.match(error_msg, "%d+"))
        local table = lua:split('\n')
        print(table[line_number])
        error("Ошибка:".. error_msg .. " строка:" .. line_number)
      end
end