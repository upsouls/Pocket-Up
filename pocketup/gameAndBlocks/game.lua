lua = nil
local makeBlock_other = require("pocketup.gameAndBlocks.launchBlocks_other")
local makeBlock_cerberus = require("pocketup.gameAndBlocks.launchBlocks_cerberus")
local makeBlock_sotritmor = require("pocketup.gameAndBlocks.launchBlocks_sotritmor")
local makeBlock_terra = require("pocketup.gameAndBlocks.launchBlocks_terra")

local _Vars = {}

-- принимает все формулы одного из параметров.
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
    app.scene="game"
    wait_type = 'wait'
    wait_table = {_ends = 0, event = 0}
    local options = plugins.json.decode(funsP['получить сохранение'](app.idProject..'/options'))
    
    if utils.isWin or utils.isSim then
        options.orientation = "vertical"
    end
    renameFormulas.displayWidth, renameFormulas.displayHeight, renameFormulas.displayActualWidth, renameFormulas.displayActualHeight = "("..tostring(options.orientation == "vertical" and options.displayWidth or options.displayHeight)..")", "("..tostring(options.orientation == "vertical" and options.displayHeight or options.displayWidth)..")", "("..tostring(options.orientation == "vertical" and display.actualContentWidth or display.actualContentHeight)..")", "("..tostring(options.orientation == "vertical" and display.actualContentHeight or display.actualContentWidth)..")"

    local isScriptsBack = false
    local dW, dH, dCX, dCY, sOX, sOY = display.actualContentWidth, display.contentHeight, CENTER_X, CENTER_Y, display.screenOriginX, display.screenOriginY

    native.setProperty("windowMode", "fullscreen")
    function showOldScene()
        display.setDefault("background", 4/255, 34/255, 44/255)
        plugins.orientation.lock('portrait')
        display.screenOriginX, display.screenOriginY = sOX, sOY
        display.contentWidth, display.contentHeight = dW, dH
        display.contentCenterX = dCX
        CENTER_X = dCX
        CENTER_Y = dCY
        if (typeBack=="scripts") then
            scene_scripts(paramsBack[1], paramsBack[2], paramsBack[3])
        elseif (typeBack=="objects") then
            scene_objects(paramsBack[1], paramsBack[2], paramsBack[3])
        elseif (typeBack=="scenes") then
            scene_scenes(paramsBack[1], paramsBack[2])
        end
    end
    max_fors = 0
    lua = ''
    lua = lua..(options.orientation=="horizontal" and "\nplugins.orientation.lock('landscape')" or "").."\nsystem.activate('multitouch')\nplugins.physics.start(true)\nlocal function getImageProperties(path, dir)\nlocal image = display.newImage(path, dir)\nimage.alpha=0\nlocal width = image.width\nlocal height = image.height\ndisplay.remove(image)\nreturn width, height\nend"
    --local groupScene = display.newGroup()
    display.setDefault('background', 1, 1, 1)
    local scenes = plugins.json.decode(funsP['получить сохранение'](app.idProject..'/scenes'))

    lua = lua.."\nlocal thread = require('plugins.thread')\nlocal joysticks = {}\nlocal Timers = {}\nlocal Timers_max = 0\nlocal globalConstants = {isTouch=false, touchX=0, touchY=0, touchId=0, keysTouch={}, touchsXId={}, touchsYId={}, isTouchsId={}}"
    lua = lua.."\nlocal pocketupFuns = {} pocketupFuns.sin = function(v) return(math.sin(math.rad(v))) end pocketupFuns.cos = function(v) return(math.cos(math.rad(v))) end pocketupFuns.tan = function(v) return(math.tan(math.rad(v))) end pocketupFuns.asin = function(v) return(math.deg(math.asin(v))) end pocketupFuns.acos = function(v) return(math.deg(math.acos(v))) end pocketupFuns.atan = function(v) return(math.deg(math.atan(v))) end pocketupFuns.atan2 = function(v, v2) return(math.deg(math.atan2(v, v2))) end pocketupFuns.roundUp = function(v) return(math.floor(v)+1) end pocketupFuns.connect = function(v,v2,v3) return(v..v2..(v3==nil and '' or v3)) end pocketupFuns.ternaryExpression = function(condition, answer1, answer2) return(condition and answer1 or answer2) end pocketupFuns.regularExpression = function(regular, expression) return(string.match(expression, regular)) end pocketupFuns.characterFromText = function(pos, value) return(plugins.utf8.sub(value,pos,pos)) end\npocketupFuns.getLinearVelocity = function(object, xOrY)\nif (object.physicsReload == nil) then\nreturn(0)\nelse\nlocal vx, vy = object:getLinearVelocity()\nreturn(xOrY=='x' and vx or vy)\nend\nend\npocketupFuns.getEllementArray = function(element, array) return(array[element]==nil and '' or array[element]) end pocketupFuns.containsElementArray = function(array, value)\nlocal isElement = false\nfor i=1, #array do\nif (array[i]==value) then\nisElement = true\nbreak\nend\nend\nreturn(isElement)\nend\npocketupFuns.getIndexElementArray = function(array, value)\n local index = 0\nfor i=1, #array do\nif (array[i]==value) then\nindex = i\nbreak\nend\nend\nreturn(index)\nend\npocketupFuns.levelingArray = function(array)\nreturn(array)\nend\npocketupFuns.displayPositionColor = function(x,y)\nlocal hexColor\nlocal function onColorSample(event)\nhexColor = utils.rgbToHex({event.r, event.g, event.b})\nreturn(hexColor)\nend\ndisplay.colorSample(CENTER_X+x, CENTER_Y-y, onColorSample)\nreturn(hexColor)\nend"
    lua = lua.."\nglobalConstants.getTouchXId = function(id)\nlocal answer = globalConstants.touchsXId[globalConstants.keysTouch['touch_'..id]]\nreturn(answer==nil and 0 or answer)\nend\nglobalConstants.getTouchYId = function(id)\nlocal answer = globalConstants.touchsYId[globalConstants.keysTouch['touch_'..id]]\nreturn(answer==nil and 0 or answer)\nend\npocketupFuns.getIsTouchId = function(id)\nreturn(globalConstants.isTouchsId[globalConstants.keysTouch['touch_'..id]]==true)\nend\npocketupFuns.getCountTouch = function ()\nlocal count = 0\nfor k, v in pairs(globalConstants.isTouchsId) do\ncount = count + 1\nend\nreturn(count)\nend\npocketupFuns.jsonEncode = function(table2)\nlocal table = nil pcall(function()\ntable = plugins.json.decode(table2)\nend)\nif (table==nil) then\nreturn('')\nelse\nlocal array = ''\nfor k, v in pairs(table) do\narray = array..(array=='' and '' or '\\n')..v\nend\nreturn(array)\nend\nend\npocketupFuns.isTouchObject2 = function(target, id)\nreturn(target.touchesObjects['obj_'..id]==true)\nend\npocketupFuns.countTouchesObjects = function(target)\nlocal isTouch = false\nfor v, k in pairs(target.touchesObjects) do\nisTouch = true\nbreak\nend\nreturn(isTouch)\nend\n\n\n"
    --lua = lua.."\nfunction hex2rgb(hexCode)\nif (utils.isCorrectHex(hexCode)) then\nhexCode = string.upper(hexCode)\nassert((#hexCode == 7) or (#hexCode == 9), \"The hex value must be passed in the form of #RRGGBB or #AARRGGBB\" )\nlocal hexCode = hexCode:gsub(\"#\",\"\")\nif (#hexCode == 6) then\nhexCode = \"FF\"..hexCode\nendlocal a, r, g, b = tonumber(\"0x\"..hexCode:sub(1,2))/255, tonumber(\"0x\"..hexCode:sub(3,4))/255, tonumber(\"0x\"..hexCode:sub(5,6))/255, tonumber(\"0x\"..hexCode:sub(7,8))/255\nreturn {r, g, b, a}\nelse\nreturn {0,0,0,1}\nend\nend\n"
    local globalVariables = plugins.json.decode(funsP['получить сохранение'](app.idProject..'/variables'))
    for i=1, #globalVariables do
            lua = lua..'var_'..globalVariables[i][1].." = 0\n"
    end
    local globalArrays = plugins.json.decode(funsP['получить сохранение'](app.idProject..'/arrays'))
    for i=1, #globalArrays do
            lua = lua..'list_'..globalArrays[i][1].." = {}\n"
    end
    lua = lua.."local myScene\nlocal WebViews = {} local textFields = {} local objects = {}\nlocal events_touchBack = {}\nlocal events_touchScreen = {}\nlocal events_movedScreen = {}\nlocal events_onTouchScreen = {}\nlocal mainGroup\nlocal playSounds = {}\nlocal playingSounds = {}"

    local level_blocks = {}
    for s=1, #scenes do
        local scene_id = scenes[s][2]
        level_blocks[scene_id] = {}
        local scene_path = app.idProject.."/scene_"..scene_id
        local xScaleMainGroup = display.contentWidth/options.displayWidth
        local yScaleMainGroup = display.contentHeight/options.displayHeight
        lua = lua.."\n\n\nfunction scene_"..scene_id.."()\nlocal focusCameraObject = nil\nmainGroup = display.newGroup()\napp.scene = 'game'\napp.scenes[app.scene] = {mainGroup}\nmainGroup.iscg = true\nmainGroup.xScale, mainGroup.yScale = "..tostring(options.orientation~="vertical" and not options.aspectRatio and yScaleMainGroup or xScaleMainGroup)..", "..tostring(options.orientation=="vertical" and  not options.aspectRatio and yScaleMainGroup or xScaleMainGroup).."\nmainGroup.x, mainGroup.y = "..(options.orientation=="vertical" and "CENTER_X, CENTER_Y" or "CENTER_Y, CENTER_X").."\nlocal cameraGroup = display.newGroup()\nlocal stampsGroup = display.newGroup()\ncameraGroup:insert(stampsGroup)\nmainGroup:insert(cameraGroup)\nlocal notCameraGroup = display.newGroup()\nmainGroup:insert(notCameraGroup)"..( not options.aspectRatio and "" or "\nlocal blackRectTop = display.newRect("..(options.orientation=="vertical" and ("0,-"..tostring(options.displayHeight/2)..","..tostring(options.displayWidth)..",display.contentHeight") or ("-"..tostring(options.displayHeight/2)..",0,display.contentHeight,"..tostring(options.displayWidth) ))..")\nblackRectTop.anchor"..(options.orientation=="vertical" and "Y" or "X").." = 1\nblackRectTop:setFillColor(0,0,0)\nmainGroup:insert(blackRectTop)\nlocal blackRectBottom = display.newRect("..(options.orientation=="vertical" and ("0,"..tostring(options.displayHeight/2)..","..tostring(options.displayWidth)..",display.contentHeight") or (tostring(options.displayHeight/2)..",0,display.contentHeight,"..tostring(options.displayWidth) ))..")\nblackRectBottom.anchor"..(options.orientation=="vertical" and "Y" or "X").." = 0\nblackRectBottom:setFillColor(0,0,0)\nmainGroup:insert(blackRectBottom)").."\nobjects = {}\n"
        lua = lua.."\nlocal events_changeBackground = {}\nlocal events_function = {}\nlocal function broadcastFunction(nameFunction)\nfor key, value in pairs(objects) do\nfor i=1, #events_function[key][nameFunction] do\nevents_function[key][nameFunction][i](value)\nfor i2=1, #value.clones do\nevents_function[key][nameFunction][i](value.clones[i2])\nend\nend\nend\nend\n"
        lua = lua.."\nmyScene = '"..scene_path.."'\nlocal tableVarShow = {}\nlocal tableNamesClones = {}\nlocal miniScenes = display.newGroup()\ncameraGroup:insert(miniScenes)"
        local objects = plugins.json.decode(funsP['получить сохранение'](scene_path.."/objects"))
        local functions = plugins.json.decode(funsP['получить сохранение'](scene_path.."/functions"))
        for i=1, #objects do
            if (type(objects[i][2])~="string") then
                lua = lua.."\nevents_function['object_"..objects[i][2].."'] = {}"
                for i2=1, #functions do
                    lua = lua.."\nevents_function['object_"..objects[i][2].."']['fun_"..functions[i2][1].."'] = {}"
                end
            end
            
        end
        for i=1, #objects do
            if (type(objects[i][2])~="string") then
                lua = lua.."\nevents_touchBack['object_"..objects[i][2].."'] = {}"
                lua = lua.."\nevents_touchScreen['object_"..objects[i][2].."'] = {}"
                lua = lua.."\nevents_movedScreen['object_"..objects[i][2].."'] = {}"
                lua = lua.."\nevents_onTouchScreen['object_"..objects[i][2].."'] = {}"
                lua = lua.."\nevents_changeBackground['object_"..objects[i][2].."'] = {}"
            end
        end
        lua = lua.."\nlocal function broadcastChangeBackground(numberImage)\nfor key, value in pairs(objects) do\nfor i=1, #events_changeBackground[key] do\nevents_changeBackground[key][i](value, numberImage)\nfor i2=1, #value.clones do\nevents_changeBackground[key][i](value.clones[i2], numberImage)\nend\nend\nend\nend"

        for o=1, #objects do
            if (type(objects[o][2])~="string") then

            wait_type = 'wait'
            wait_table = {_ends = 0, event = 0}

            lua = lua.."\npcall(function()\n"

            local obj_id = objects[o][2]
            local obj_path = scene_path.."/object_"..obj_id
            local obj_images = plugins.json.decode(funsP['получить сохранение'](obj_path.."/images"))
            local obj_sounds = plugins.json.decode(funsP['получить сохранение'](obj_path.."/sounds"))
            lua = lua.."\nlocal objectsParticles = {}"
            lua = lua.."\nlocal listImages = {"
            for i=1, #obj_images do
                lua = lua..(i==1 and "" or ",")..obj_images[i][2]
            end
            lua = lua.."}\nlocal listNamesImages = {"
            for i=1, #obj_images do
                lua = lua..(i==1 and "'" or "','")..obj_images[i][1]:gsub("'","\\'"):gsub(( utils.isWin and "\r\n" or "\n"),"\\n")
            end
            if (#obj_images==0) then
                lua = lua.."}\nlocal listSounds = {"
                else
                lua = lua.."'}\nlocal listSounds = {"
                end
            for i=1, #obj_sounds do
                lua = lua..(i==1 and "" or ",")..obj_sounds[i][2]
            end
            lua = lua.."}\n"

            lua = lua..'tableFeathers = {}\n'
            lua = lua..'tableFeathersOptions = {3.5, 0, 0, 255}\n'

            if (#obj_images>0) then
                lua = lua.."\n\nlocal object_"..obj_id.." = display.newImage('"..obj_path.."/image_"..obj_images[1][2]..".png', system.DocumentsDirectory)"
                lua = lua.."\nobject_"..obj_id..".image_path = '"..obj_path.."/image_"..obj_images[1][2]..".png'"
                lua = lua.."\nobject_"..obj_id..".timers = {}"
            else
                lua = lua.."\n\nlocal object_"..obj_id.." = display.newImage('images/notVisible.png')"
            end
            lua = lua.."\nobject_"..obj_id..".infoSaveVisPos = "..tostring(o).."\n"
            lua = lua.."\nlocal objectsTable = plugins.json.decode(funsP['получить сохранение']('"..scene_path.."/objects'))\nobjectsTable[object_"..obj_id..".infoSaveVisPos][3] = nil\nfunsP['записать сохранение']('"..scene_path.."/objects', plugins.json.encode(objectsTable))\n"
            lua = lua.."cameraGroup:insert(object_"..obj_id..")\nobject_"..obj_id..".touchesObjects = {}"
            if (o==1) then
                lua = lua.."\nlocal background = object_"..obj_id.."\nbackground.listImagesBack, background.listNamesImagesBack, background.obj_pathBack = listImages, listNamesImages, '"..obj_path.."'"
            end
            lua = lua.."\nobject_"..obj_id..".parent_obj = object_"..obj_id.."\nobject_"..obj_id..".clones = {}\nobjects['object_"..obj_id.."'], object_"..obj_id..".idObject = object_"..obj_id..", "..obj_id.."\nobject_"..obj_id..".numberImage = 1\n\n"
            lua = lua.."object_"..obj_id..".tableVarShow, object_"..obj_id..".origWidth, object_"..obj_id..".origHeight, object_"..obj_id..".nameObject, object_"..obj_id..".property_size, object_"..obj_id..".property_brightness, object_"..obj_id..".property_color = {}, object_"..obj_id..".width, object_"..obj_id..".height, 'object_"..obj_id.."', 100, 100, 0\n"
            lua = lua.."object_"..obj_id..".countImages = "..tostring(#obj_images).."\n"

            local localVariables = plugins.json.decode(funsP['получить сохранение'](obj_path.."/variables"))
            lua = lua.."object_"..obj_id..".namesVars = {}\n"
            for i=1, #localVariables do
                lua = lua.."object_"..obj_id..".var_"..localVariables[i][1].." = 0\n"
                lua = lua.."object_"..obj_id..".namesVars["..i.."] = 'var_"..localVariables[i][1].."'\n"
            end
            local localArrays = plugins.json.decode(funsP['получить сохранение'](obj_path.."/arrays"))
            lua = lua.."object_"..obj_id..".namesLists = {}\n"
            for i=1, #localArrays do
                lua = lua.."object_"..obj_id..".list_"..localArrays[i][1].." = {}\n"
                lua = lua.."object_"..obj_id..".namesLists["..i.."] = 'list_"..localArrays[i][1].."'\n"
            end

            lua = lua.."\n\nlocal events_start = {}\nlocal events_touchObject = {} object_"..obj_id..".events_touchObject = events_touchObject\nlocal events_movedObject = {} object_"..obj_id..".events_movedObject = events_movedObject\nlocal events_onTouchObject = {} object_"..obj_id..".events_onTouchObject = events_onTouchObject\nlocal events_collision = {} object_"..obj_id..".events_collision = events_collision\nlocal events_endedCollision = {}  object_"..obj_id..".events_endedCollision = events_endedCollision\nlocal events_startClone = {}\n object_"..obj_id..".events_startClone = events_startClone"
            
            lua = lua.."\nobject_"..obj_id..".group = cameraGroup"
            lua = lua.."\nobject_"..obj_id..":addEventListener('touch', function(event)\nif (event.phase=='began') then\nlocal newIdTouch=globalConstants.touchId+1\nglobalConstants.touchId = newIdTouch\nglobalConstants.keysTouch['touch_'..newIdTouch], globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = event.id, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale, true\nglobalConstants.isTouch, globalConstants.touchX, globalConstants.touchY = true, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\ndisplay.getCurrentStage():setFocus(event.target, event.id)\nevent.target.isTouch = true\nfor key, value in pairs(objects) do\nfor i=1, #events_touchScreen[key] do\nevents_touchScreen[key][i](value)\nfor i2=1, #value.clones do\nevents_touchScreen[key][i](value.clones[i2])\nend\nend\nend\nfor i=1, #events_touchObject do\nevents_touchObject[i](event.target)\nend\nelseif (event.phase=='moved') then\nglobalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id] = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\nglobalConstants.touchX, globalConstants.touchY = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\nfor key, value in pairs(objects) do\nfor i=1, #events_movedScreen[key] do\nevents_movedScreen[key][i](value)\nfor i2=1, #value.clones do\nevents_movedScreen[key][i](value.clones[i2])\nend\nend\nend\nfor i=1, #events_movedObject do\nevents_movedObject[i](event.target)\nend\nelse\ndisplay.getCurrentStage():setFocus(event.target, nil)\nglobalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = nil, nil, nil\nif (pocketupFuns.getCountTouch(globalConstants.isTouchsId)==0) then\nglobalConstants.keysTouch = {}\nglobalConstants.isTouch = false\nend\nevent.target.isTouch = nil\nfor key, value in pairs(objects) do\nfor i=1, #events_onTouchScreen[key] do\nevents_onTouchScreen[key][i](value)\nfor i2=1, #value.clones do\nevents_onTouchScreen[key][i](value.clones[i2])\nend\nend\nend\nfor i=1, #events_onTouchObject do\nevents_onTouchObject[i](event.target)\nend\nend\nreturn(true)\nend)"


--"for key, value in pairs(objects) do\nfor i=1, #events_onTouchScreen[key] do\nevents_onTouchScreen[key][i](value)\nfor i2=1, #value.clones do\nevents_onTouchScreen[key][i](value.clones[i2])\nend\nend\nend"


            local blocks = plugins.json.decode(funsP['получить сохранение'](obj_path.."/scripts"))

            level_blocks[scene_id][obj_id] = {}
            -- if true then
            --     local level = 1
            --     for i, value in ipairs(blocks) do
            --         if blocks[i][3] ~= 'off' then
            --         local block = blocks[i]
            --         local nameBlock = block[1]
            --         local table = {'if','timer','repeat','ifElse (2)','waitIfTrue',
            --         'foreach','cycleForever','for','repeatIsTrue','timer2','repeat2','repeatIsTrue2'}

            --         local table_end = {'endIf','endTimer','endRepeat','ifElse (2)',
            --         'endFor','endForeach','endCycleForever','endWait'}
            --         for _, value in ipairs(table) do
            --             if nameBlock == value then
            --                 level = level+1
            --             end
            --         end
            --         level_blocks[scene_id][obj_id][i] = level
            --         for _, value in ipairs(table_end) do
            --             if nameBlock == value then
            --                 level = level-1
            --             end
            --         end                          
            --         end
            --     end    
            -- end

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
                                timer.cancel(tTheard)\
                            end\
                            local p = coroutine.create(function()\
                                local threadFun = require('plugins.threadFun')\n"

                    elseif (block[1]=="touchScreen" or block[1]=="movedScreen" or block[1]=="onTouchScreen" or block[1]=="touchBack") then
                        if (block[1]=="touchBack" and block[3]=="on") then
                            isScriptsBack = true
                        end
                        lua = lua.."\nevents_"..block[1].."['object_"..obj_id.."'][ #events_"..block[1].."['object_"..obj_id.."'] + 1] = function (target)\n\
                            Timers_max = Timers_max+1\
                            local tTheard\
                            local removeTheard = function()\
                                timer.cancel(tTheard)\
                            end\
                            local p = coroutine.create(function()\
                                local threadFun = require('plugins.threadFun')\n"

                    elseif (block[1]=="changeBackground") then
                        lua = lua.."\nevents_changeBackground['object_"..obj_id.."'][ #events_changeBackground['object_"..obj_id.."'] + 1] = function (target, numberImage)\
                            if (numberImage == "..(type(block[2][1][2])=="boolean" and "'off'" or block[2][1][2])..") then\
                                Timers_max = Timers_max+1\
                                local tTheard\
                                local removeTheard = function()\
                                    timer.cancel(tTheard)\
                                end\
                                local p = coroutine.create(function()\
                                    local threadFun = require('plugins.threadFun')\n"
                    elseif (block[1]=="collision" or block[1]=="endedCollision") then
                        lua = lua.."\nevents_"..block[1].."[ #events_"..block[1].." + 1] = function (target, idObject)\
                            if ("..(block[2][1][2]==nil and "true" or "idObject == 'object_"..block[2][1][2].."'")..") then\
                                Timers_max = Timers_max+1\
                                local tTheard\
                                local removeTheard = function()\
                                    timer.cancel(tTheard)\
                                end\
                                local p = coroutine.create(function()\
                                    local threadFun = require('plugins.threadFun')\n"
                    else
                        lua = lua.."\nevents_"..block[1].."[ #events_"..block[1].." + 1] = function (target)\
                            Timers_max = Timers_max+1\
                            local tTheard\
                            local removeTheard = function()\
                                timer.cancel(tTheard)\
                            end\
                            local p = coroutine.create(function()\
                                local threadFun = require('plugins.threadFun')\n"
                    end
                    oldEventName = block[1]
                    -- if (oldEventName=="start") then
                    --     lua = lua.."\ntimer.new(0, function ()"
                    -- end
                else
                    local luaBlock = makeBlock_cerberus(block, 'target', make_all_formulas, obj_id, obj_path, scene_id, scene_path, options)
                    if (luaBlock~=nil and luaBlock~="") then
                        lua = lua.."\n"..luaBlock..'\n'
                    else
                    local luaBlock = makeBlock_sotritmor(block, 'target', make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, b)
                    if (luaBlock~=nil and luaBlock~="") then
                        lua = lua.."\n"..luaBlock..'\n'
                    else
                    local luaBlock = makeBlock_terra(block, 'target', make_all_formulas, obj_id, obj_path, scene_id, scene_path, options)
                    if (luaBlock~=nil and luaBlock~="") then
                        lua = lua.."\n"..luaBlock..'\n'
                    else
                    local luaBlock = makeBlock_other(block, 'target', obj_images, obj_sounds, b, blocks, level_blocks, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options)..'\n'
                    if (luaBlock~=nil and luaBlock~="") then
                        lua = lua.."\n"..luaBlock..'\n'
                    else
                    end
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
                    pStart, tTheard = thread.start(p)\n"
                    lua = lua..'\nend\nend\n\n'
                else
                    lua = lua..
                    "removeTheard()\
                    end)\
                    local pStart\
                    pStart, tTheard = thread.start(p)\n"
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
    lua = lua.."local function touchScreenGame(event)\nif (event.phase=='began') then\nlocal newIdTouch=globalConstants.touchId+1\nglobalConstants.touchId = newIdTouch\nglobalConstants.keysTouch['touch_'..newIdTouch], globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = event.id, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale, true\nglobalConstants.isTouch, globalConstants.touchX, globalConstants.touchY = true, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\nfor key, value in pairs(objects) do\nfor i=1, #events_touchScreen[key] do\nevents_touchScreen[key][i](value)\nfor i2=1, #value.clones do\nevents_touchScreen[key][i](value.clones[i2])\nend\nend\nend\nelseif (event.phase=='moved') then\nglobalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id] = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\nglobalConstants.touchX, globalConstants.touchY = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\nfor key, value in pairs(objects) do\nfor i=1, #events_movedScreen[key] do\nevents_movedScreen[key][i](value)\nfor i2=1, #value.clones do\nevents_movedScreen[key][i](value.clones[i2])\nend\nend\nend\nelse\nglobalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = nil, nil, nil\nif (pocketupFuns.getCountTouch(globalConstants.touchsXId)==0) then\nglobalConstants.keysTouch = {}\nglobalConstants.isTouch=false\nend\nfor key, value in pairs(objects) do\nfor i=1, #events_onTouchScreen[key] do\nevents_onTouchScreen[key][i](value)\nfor i2=1, #value.clones do\nevents_onTouchScreen[key][i](value.clones[i2])\nend\nend\nend\nend\nend"
    lua = lua.."\nRuntime:addEventListener('touch', touchScreenGame)\n\n"

--[[
local newIdTouch=globalConstants.touchId+1\nglobalConstants.touchId = newIdTouch\nglobalConstants.keysTouch['touch_'..newIdTouch], globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = event.id, event.x, event.y, true
globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = event.x, event.y
globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = nil, nil, nil\nif (#globalConstants.isTouchsId==0) then\nglobalConstants.keysTouch = {}\nglobalConstants.isTouch = nil\nend
]]
    lua = lua.."\nfunction exitGame()\nplugins.physics.setDrawMode('normal')\nsystem.deactivate('multitouch')\nplugins.physics.stop()\nRuntime:removeEventListener('touch', touchScreenGame)\nshowOldScene()\nend"
    lua = lua.."\nfunction deleteScene()\nplugins.physics.setDrawMode('normal')\nremoveAllObjects()\ntimer.cancelAll()\n"..(options.orientation=="vertical" and "plugins.orientation.lock('portrait')" or "plugins.orientation.lock('landscape')").."\ndisplay.remove(mainGroup)\nfor key, value in pairs(playingSounds) do\naudio.stop(playingSounds[key])\naudio.dispose(playSounds[key])\nend\nplaySounds = {}\nplayingSounds = {}\nnative.setProperty('windowMode', 'normal')\nend"
    if (isScriptsBack) then
        lua = lua.."\nfunction funBackListener(event)\nif ((event.keyName=='back' or event.keyName=='deleteBack') and event.phase=='up') then\nfor key, value in pairs(objects) do\nfor i=1, #events_touchBack[key] do\nevents_touchBack[key][i](value)\nfor i2=1, #value.clones do\nevents_touchBack[key][i](value.clones[i2])\nend\nend\nend\nend\nreturn(true)\nend\nRuntime:addEventListener('key', funBackListener)"
    else
        lua = lua.."\nfunction funBackListener(event)\nif ((event.keyName=='back' or event.keyName=='deleteBack') and event.phase=='up') then\nlocal rect = display.newImage('images/notVisible.png')\nmainGroup:insert(rect)\nrect.width, rect.height = "..(options.orientation == "vertical" and display.contentWidth or display.contentHeight)..", "..(options.orientation == "vertical" and display.contentHeight or display.contentWidth).."\nrect:toBack()\nrect.alpha = 0.004\ndisplay.save(mainGroup,{ filename=myScene..'/icon.png', baseDir=system.DocumentsDirectory, backgroundColor={1,1,1,1}})\nRuntime:removeEventListener('key',funBackListener)\naudio.stop({channel=1})\ndeleteScene()\nexitGame()\nplugins.orientation.lock('portrait')\nend\nreturn(true)\nend\nRuntime:addEventListener('key', funBackListener)"
    end
        lua = lua.."\nfunction funBackListener2(event)\nif ((event.keyName=='back' or event.keyName=='deleteBack') and event.phase=='up') then\nRuntime:removeEventListener('key',funBackListener)\naudio.stop({channel=1})\ndeleteScene()\nexitGame()\nplugins.orientation.lock('portrait')\nend\nend"

    --lua = lua.."\ntimer.new(100,function()\nif (mainGroup~=nil and mainGroup.x~=nil) then\ndisplay.save(mainGroup,{ filename=myScene..'/icon.png', baseDir=system.DocumentsDirectory, backgroundColor={1,1,1,1}})\nend\nend)\n"
    --lua = lua:gsub("prem", "prеm"):gsub("Prem", "Prеm")
    noremoveAllObjects()
    local f, error_msg = loadstring(lua)
    print(lua)
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