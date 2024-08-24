lua = nil

local _Vars = {}

-- принимает все формулы одного из параметров.
local lang = system.getPreference( "locale", "language" )
local renameFormulas = {
    ["+"]="+",["-"]="-",["÷"]="/",["×"]="*",["("]="(",[")"]=")",
        ["<"]="<",[">"]=">",["≤"]="<=",["≥"]=">=",["="]=" == ",["≠"]="~=",
        [","]=",",["true"]="true",["false"]="false",["not"]="not",
        ["and"]="and",["or"]="or",sinus="pocketupFuns.sin",cosine="pocketupFuns.cos",
        tangent="pocketupFuns.tan",naturalLogarithm="math.log",
        decimalLogarithm="math.log10",pi="math.pi",root="math.sqrt",
        random="math.random",absoluteValue="math.abs",round="math.round",
        modulo="math.fmod",arcsine="pocketupFuns.asin",arccosine="pocketupFuns.acos",
        arctangent="pocketupFuns.atan", arctangent2="pocketupFuns.atan2",exponent="math.exp",
        degree="math.pow",roundDown="math.floor",roundUp="pocketupFuns.roundUp",
        maximum="math.max",minimum="math.min",ternaryExpression="pocketupFuns.ternaryExpression"
        ,characterFromText="pocketupFuns.characterFromText",length="utf8.len",
        connect="pocketupFuns.connect",connect2="pocketupFuns.connect",regularExpression="pocketupFuns.regularExpression",
        layer="(0)",language=" '"..lang.."-"..string.upper(lang).."' ",
        lengthArray="#",elementArray="pocketupFuns.getEllementArray",containsArray="pocketupFuns.containsElementArray",
        indexArray="pocketupFuns.getIndexElementArray",levelingArray="pocketupFuns.levelingArray",
        displayPositionColor="pocketupFuns.displayPositionColor",touchDisplayX="globalConstants.touchX",touchDisplayY="globalConstants.touchY",
        touchDisplay="globalConstants.isTouch",touchDisplayXId="globalConstants.getTouchXId",touchDisplayYId="globalConstants.getTouchYId",
        touchDisplayId="pocketupFuns.getIsTouchId",countTouchDisplay="globalConstants.touchId",countTouch="pocketupFuns.getCountTouch()",
        --[[
        ,="(0)",]]
        timer="os.time()",year="os.date('%Y', os.time())",month="os.date('%m', os.time())",
        dayWeek="os.date('%w', os.time())",day="os.date('%d', os.time())",hour="os.date('%H', os.time())",
        minute="os.date('%M', os.time())",second="os.date('%S', os.time())"
}

print(os.date('%x', os.time()))

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
    return(json.decode("["..event:gsub("\n",'","'):gsub("\r\n",'","').."]"))
end


local function make_all_formulas(formulas, object)
    print(json.encode(formulas))

    local tableInfoObject = {
        {'size',"("..object..".property_size)"},{'direction',"("..object..".rotation/2)"},{'directionView',"("..object..".rotation/2)"},{'positionX',object..".x"},
        {'positionY',"(-("..object..".y))"},{'speedX', 'pocketupFuns.getLinearVelocity('..object..',"x")'},{'speedY', 'pocketupFuns.getLinearVelocity('..object..',"y")'},
        {'angularVelocity', object..'.angularVelocity'},{'transparency', "((1-"..object..".alpha)*100)"},{"numberImage", object..".numberImage"},{"brightness",object..".property_brightness"},
        {'color', object..".property_color"},{"nameImage", "listNamesImages["..object..".numberImage]"},{"touchesFinger","("..object..".isTouch==true)"},{"touchesObject","("..object..".isTouchObject==true)"},
    }
    for i=1, #tableInfoObject do
        renameFormulas[tableInfoObject[i][1]] = tableInfoObject[i][2]
    end

    local answer = "("
    for i=1, #formulas do
        local formula = formulas[i]
        if (formula[1]=="number") then
            answer = answer..formula[2]
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
        else
            answer = answer.." "..renameFormulas[formula[2]].." "
        end
    end
    answer = answer..")"
    print(answer)
    return(answer)
end

local isEvent = {
    start=true, touchObject=true, touchScreen=true, ["function"]=true, whenTheTruth=true, collision=true, changeBackground=true, startClone=true
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

timer.new = timer.performWithDelay
timer.GameNew = function (time, rep, listener)
    return timer.new(time, listener, rep)
end
local max_fors = 0

function scene_run_game(shsc)
    local options = json.decode(funsP['получить сохранение'](IDPROJECT..'/options'))

    showOldScene = shsc
    max_fors = 0
    lua = ''
    lua = lua..(options.orientation=="horizontal" and "\norientation.lock('landscape')" or "").."\nsystem.activate('multitouch')\nphysics.start(true)\nlocal function getImageProperties(path, dir)\nlocal image = display.newImage(path, dir)\nimage.alpha=0\nlocal width = image.width\nlocal height = image.height\ndisplay.remove(image)\nreturn width, height\nend"
    --local groupScene = display.newGroup()
    display.setDefault('background', 1, 1, 1)
    local scenes = json.decode(funsP['получить сохранение'](IDPROJECT..'/scenes'))

    lua = lua.."\nlocal globalConstants = {isTouch=false, touchX=0, touchY=0, touchId=0, keysTouch={}, touchsXId={}, touchsYId={}, isTouchsId={}}"
    lua = lua.."\nlocal pocketupFuns = {} pocketupFuns.sin = function(v) return(math.sin(math.rad(v))) end pocketupFuns.cos = function(v) return(math.cos(math.rad(v))) end pocketupFuns.tan = function(v) return(math.tan(math.rad(v))) end pocketupFuns.asin = function(v) return(math.deg(math.asin(v))) end pocketupFuns.acos = function(v) return(math.deg(math.acos(v))) end pocketupFuns.atan = function(v) return(math.deg(math.atan(v))) end pocketupFuns.atan2 = function(v, v2) return(math.deg(math.atan2(v, v2))) end pocketupFuns.roundUp = function(v) return(math.floor(v)+1) end pocketupFuns.connect = function(v,v2,v3) return(v..v2..(v3==nil and '' or v3)) end pocketupFuns.ternaryExpression = function(condition, answer1, answer2) return(condition and answer1 or answer2) end pocketupFuns.regularExpression = function(regular, expression) return(string.match(expression, regular)) end pocketupFuns.characterFromText = function(pos, value) return(utf8.sub(value,pos,pos)) end\npocketupFuns.getLinearVelocity = function(object, xOrY)\nlocal vx, vy = object:getLinearVelocity()\nreturn(xOrY=='x' and vx or vy)\nend\npocketupFuns.getEllementArray = function(element, array) return(array[element]==nil and '' or array[element]) end pocketupFuns.containsElementArray = function(array, value)\nlocal isElement = false\nfor i=1, #array do\nif (array[i]==value) then\nisElement = ture\nbreak\nend\nend\nreturn(isElement)\nend\npocketupFuns.getIndexElementArray = function(array, value)\n local index = 0\nfor i=1, #array do\nif (array[i]==value) then\nindex = i\nbreak\nend\nend\nreturn(index)\nend\npocketupFuns.levelingArray = function(array)\nreturn(array)\nend\npocketupFuns.displayPositionColor = function(x,y)\nlocal function onColorSample(event)\nreturn(rgbToHex({event.r, event.g, event.b}))\nend\nreturn(display.colorSample(x, y, onColorSample))\nend"
    lua = lua.."\nglobalConstants.getTouchXId = function(id)\nlocal answer = globalConstants.touchsXId[globalConstants.keysTouch['touch_'..id]]\nreturn(answer==nil and 0 or answer)\nend\nglobalConstants.getTouchYId = function(id)\nlocal answer = globalConstants.touchsYId[globalConstants.keysTouch['touch_'..id]]\nreturn(answer==nil and 0 or answer)\nend\npocketupFuns.getIsTouchId = function(id)\nreturn(globalConstants.isTouchsId[globalConstants.keysTouch['touch_'..id]]==true)\nend\npocketupFuns.getCountTouch = function ()\nlocal count = 0\nfor k, v in pairs(globalConstants.isTouchsId) do\ncount = count + 1\nend\nreturn(count)\nend\n\n\n"
    --lua = lua.."\nfunction hex2rgb(hexCode)\nif (isCorrectHex(hexCode)) then\nhexCode = string.upper(hexCode)\nassert((#hexCode == 7) or (#hexCode == 9), \"The hex value must be passed in the form of #RRGGBB or #AARRGGBB\" )\nlocal hexCode = hexCode:gsub(\"#\",\"\")\nif (#hexCode == 6) then\nhexCode = \"FF\"..hexCode\nendlocal a, r, g, b = tonumber(\"0x\"..hexCode:sub(1,2))/255, tonumber(\"0x\"..hexCode:sub(3,4))/255, tonumber(\"0x\"..hexCode:sub(5,6))/255, tonumber(\"0x\"..hexCode:sub(7,8))/255\nreturn {r, g, b, a}\nelse\nreturn {0,0,0,1}\nend\nend\n"
    local globalVariables = json.decode(funsP['получить сохранение'](IDPROJECT..'/variables'))
    for i=1, #globalVariables do
            lua = lua..'var_'..globalVariables[i][1].." = 0\n"
    end
    local globalArrays = json.decode(funsP['получить сохранение'](IDPROJECT..'/arrays'))
    for i=1, #globalArrays do
            lua = lua..'list_'..globalArrays[i][1].." = {}\n"
    end
    lua = lua.."local objects = {}\nlocal events_touchScreen = {}\nlocal mainGroup\nplaySounds = {}\nlocal playingSounds = {}"

    for s=1, #scenes do
        local scene_id = scenes[s][2]
        local scene_path = IDPROJECT.."/scene_"..scene_id
        local xScaleMainGroup = display.contentWidth/options.displayWidth
        local yScaleMainGroup = display.contentHeight/options.displayHeight
        lua = lua.."\n\n\nfunction scene_"..scene_id.."()\nlocal focusCameraObject = nil\nmainGroup = display.newGroup()\nmainGroup.xScale, mainGroup.yScale = "..tostring(options.orientation~="vertical" and not options.aspectRatio and yScaleMainGroup or xScaleMainGroup)..", "..tostring(options.orientation=="vertical" and  not options.aspectRatio and yScaleMainGroup or xScaleMainGroup).."\nmainGroup.x, mainGroup.y = "..(options.orientation=="vertical" and "CENTER_X, CENTER_Y" or "CENTER_Y, CENTER_X").."\nlocal cameraGroup = display.newGroup()\nlocal stampsGroup = display.newGroup()\ncameraGroup:insert(stampsGroup)\nmainGroup:insert(cameraGroup)\nlocal notCameraGroup = display.newGroup()\nmainGroup:insert(notCameraGroup)"..( not options.aspectRatio and "" or "\nlocal blackRectTop = display.newRect("..(options.orientation=="vertical" and ("0,-"..tostring(options.displayHeight/2)..","..tostring(options.displayWidth)..",display.contentHeight") or ("-"..tostring(options.displayHeight/2)..",0,display.contentHeight,"..tostring(options.displayWidth) ))..")\nblackRectTop.anchor"..(options.orientation=="vertical" and "Y" or "X").." = 1\nblackRectTop:setFillColor(0,0,0)\nmainGroup:insert(blackRectTop)\nlocal blackRectBottom = display.newRect("..(options.orientation=="vertical" and ("0,"..tostring(options.displayHeight/2)..","..tostring(options.displayWidth)..",display.contentHeight") or (tostring(options.displayHeight/2)..",0,display.contentHeight,"..tostring(options.displayWidth) ))..")\nblackRectBottom.anchor"..(options.orientation=="vertical" and "Y" or "X").." = 0\nblackRectBottom:setFillColor(0,0,0)\nmainGroup:insert(blackRectBottom)").."\nobjects = {}\n"
        lua = lua.."\nlocal events_changeBackground = {}\nlocal events_function = {}\nlocal function broadcastFunction(nameFunction)\nfor key, value in pairs(objects) do\nfor i=1, #events_function[key][nameFunction] do\nevents_function[key][nameFunction][i](value)\nfor i2=1, #value.clones do\nevents_function[key][nameFunction][i](value.clones[i2])\nend\nend\nend\nend\n"
        lua = lua.."\nlocal tableVarShow = {}\nlocal tableNamesClones = {}"

        local objects = json.decode(funsP['получить сохранение'](scene_path.."/objects"))
        local functions = json.decode(funsP['получить сохранение'](scene_path.."/functions"))
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
                lua = lua.."\nevents_touchScreen['object_"..objects[i][2].."'] = {}"
                lua = lua.."\nevents_changeBackground['object_"..objects[i][2].."'] = {}"
            end
        end
        lua = lua.."\nlocal function broadcastChangeBackground(numberImage)\nfor key, value in pairs(objects) do\nfor i=1, #events_changeBackground[key] do\nevents_changeBackground[key][i](value, numberImage)\nfor i2=1, #value.clones do\nevents_changeBackground[key][i](value.clones[i2], numberImage)\nend\nend\nend\nend"

        for o=1, #objects do
            if (type(objects[o][2])~="string") then
            local obj_id = objects[o][2]
            local obj_path = scene_path.."/object_"..obj_id
            local obj_images = json.decode(funsP['получить сохранение'](obj_path.."/images"))
            local obj_sounds = json.decode(funsP['получить сохранение'](obj_path.."/sounds"))
            lua = lua.."\nlocal objectsParticles = {}"
            lua = lua.."\nlocal listImages = {"
            for i=1, #obj_images do
                lua = lua..(i==1 and "" or ",")..obj_images[i][2]
            end
            lua = lua.."}\nlocal listNamesImages = {"
            for i=1, #obj_images do
                lua = lua..(i==1 and "'" or "','")..obj_images[i][1]:gsub("'","\\'"):gsub(( isWin and "\r\n" or "\n"),"\\n")
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
            else
                lua = lua.."\n\nlocal object_"..obj_id.." = display.newImage('images/notVisible.png')"
            end
            lua = lua.."cameraGroup:insert(object_"..obj_id..")"
            if (o==1) then
                lua = lua.."\nlocal background = object_"..obj_id.."\nbackground.listImagesBack, background.listNamesImagesBack, background.obj_pathBack = listImages, listNamesImages, '"..obj_path.."'"
            end
            lua = lua.."\nobject_"..obj_id..".parent_obj = object_"..obj_id.."\nobject_"..obj_id..".clones = {}\nobjects['object_"..obj_id.."'], object_"..obj_id..".idObject = object_"..obj_id..", "..obj_id.."\nobject_"..obj_id..".numberImage = 1\n\n"
            lua = lua.."object_"..obj_id..".tableVarShow, object_"..obj_id..".origWidth, object_"..obj_id..".origHeight, object_"..obj_id..".nameObject, object_"..obj_id..".property_size, object_"..obj_id..".property_brightness, object_"..obj_id..".property_color = {}, object_"..obj_id..".width, object_"..obj_id..".height, 'object_"..obj_id.."', 100, 100, 0\n"


            local localVariables = json.decode(funsP['получить сохранение'](obj_path.."/variables"))
            for i=1, #localVariables do
                lua = lua.."object_"..obj_id..".var_"..localVariables[i][1].." = 0\n"
            end
            local localArrays = json.decode(funsP['получить сохранение'](obj_path.."/arrays"))
            for i=1, #localArrays do
                lua = lua.."object_"..obj_id..".list_"..localArrays[i][1].." = {}\n"
            end

            lua = lua.."\n\nlocal events_start = {}\nlocal events_touchObject = {}\nlocal events_collision = {}\nlocal events_startClone = {}\n"
            
            lua = lua.."\nobject_"..obj_id..":addEventListener('touch', function(event)\nif (event.phase=='began') then\nlocal newIdTouch=globalConstants.touchId+1\nglobalConstants.touchId = newIdTouch\nglobalConstants.keysTouch['touch_'..newIdTouch], globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = event.id, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale, true\nglobalConstants.isTouch, globalConstants.touchX, globalConstants.touchY = true, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\ndisplay.getCurrentStage():setFocus(event.target, event.id)\nevent.target.isTouch = true\nfor key, value in pairs(objects) do\nfor i=1, #events_touchScreen[key] do\nevents_touchScreen[key][i](value)\nfor i2=1, #value.clones do\nevents_touchScreen[key][i](value.clones[i2])\nend\nend\nend\nfor i=1, #events_touchObject do\nevents_touchObject[i](event.target)\nend\nelseif (event.phase=='moved') then\nglobalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id] = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\nglobalConstants.touchX, globalConstants.touchY = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\nelse\ndisplay.getCurrentStage():setFocus(event.target, nil)\nglobalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = nil, nil, nil\nif (pocketupFuns.getCountTouch(globalConstants.isTouchsId)==0) then\nglobalConstants.keysTouch = {}\nglobalConstants.isTouch = false\nend\nevent.target.isTouch = nil\nend\nreturn(true)\nend)"

            local blocks = json.decode(funsP['получить сохранение'](obj_path.."/scripts"))
            local oldEventName = nil
            for b=1, #blocks do
                local block = blocks[b]

                if (isEvent[block[1]]) then
                    if (b>1) then
                        if (oldEventName=="start") then
                            lua = lua.."\nend)"
                        elseif (oldEventName=="changeBackground" or oldEventName=="collision") then
                            lua = lua.."\nend"
                        end
                        lua = lua.."\nend\n"
                    end
                    if (block[1]=="function") then
                        lua = lua.."\nevents_function['object_"..obj_id.."']['fun_"..block[2][1][2].."'][ #events_function['object_"..obj_id.."']['fun_"..block[2][1][2].."'] + 1] = function (target)"
                    elseif (block[1]=="touchScreen") then
                        lua = lua.."\nevents_touchScreen['object_"..obj_id.."'][ #events_touchScreen['object_"..obj_id.."'] + 1] = function (target)"
                    elseif (block[1]=="changeBackground") then
                        lua = lua.."\nevents_changeBackground['object_"..obj_id.."'][ #events_changeBackground['object_"..obj_id.."'] + 1] = function (target, numberImage)\nif (numberImage == "..(type(block[2][1][2])=="boolean" and "'off'" or block[2][1][2])..") then"
                    elseif (block[1]=="collision") then
                        lua = lua.."\nevents_collision[ #events_changeBackground + 1] = function (target, idObject)\nif ("..(block[2][1][2]==nil and "true" or "idObject == 'object_"..block[2][1][2].."'")..") then"
                    else
                        lua = lua.."\nevents_"..block[1].."[ #events_"..block[1].." + 1] = function (target)"
                    end
                    oldEventName = block[1]
                    if (oldEventName=="start") then
                        lua = lua.."\ntimer.new(0, function ()"
                    end
else
local make_block
pcall(function()
local nameBlock
local lua
local add_pcall = function ()
    lua = lua..'\npcall(function()\n'
end
local end_pcall = function ()
    lua = lua..'\nend)\n'
end

make_block = function(infoBlock, object, images, sounds)
    if infoBlock[3] == 'off' then
        return ''
    end
    nameBlock = infoBlock[1]--args[i] = make_all_formulas(infoBlock[2][i], object)
    lua = ''
    if nameBlock == '' then
    elseif nameBlock == 'setSize' or nameBlock == 'editSize' then
        local formula = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..'target.property_size = ('..(nameBlock=='setSize' and '' or 'target.property_size)+(')..formula..')\ntarget.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)'
        lua = lua.."\ntarget:physicsReload()"
        end_pcall()
    elseif nameBlock == 'setPosition' then
        local x = make_all_formulas(infoBlock[2][1], object)
        local y = make_all_formulas(infoBlock[2][2], object)
        add_pcall()
        lua = lua..'target.x = '..x..'\n'..'target.y = -('..y..')\n'
        end_pcall()
    elseif nameBlock == 'setPositionX' then
        add_pcall()
        local x = make_all_formulas(infoBlock[2][1], object)
        lua = lua..'target.x = '..x
        end_pcall()
    elseif nameBlock == 'setPositionY' then
        add_pcall()
        local y = make_all_formulas(infoBlock[2][1], object)
        lua = lua..'target.y = -('..y..')'
        end_pcall()
    elseif nameBlock == 'transitionPosition' then
        local time = make_all_formulas(infoBlock[2][1], object)
        local x = make_all_formulas(infoBlock[2][2], object)
        local y = make_all_formulas(infoBlock[2][3], object)
    
        add_pcall()
        lua = lua..'transition.to(target, {time=('.. time .. ')*1000, x=('..x..'), y=-('..y..')})\n'
        end_pcall()
    elseif nameBlock == 'lua' then
        local code = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..'loadstring('..code..')()'..'\n'
        end_pcall()
    elseif nameBlock == 'timer' then
        local rep = make_all_formulas(infoBlock[2][1], object)
        local time = make_all_formulas(infoBlock[2][2], object)
        add_pcall()
        lua = lua..'timer.GameNew(('..time..')*1000, '..rep..', function()\n'
    elseif nameBlock == 'endTimer' then
        lua = lua..'end)\n'
        end_pcall()
    elseif nameBlock == 'editRotateLeft' then
        local rotate = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..'target:rotate('..rotate..')\n'
        end_pcall()
    elseif nameBlock == 'editRotateRight' then
        local rotate = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..'target:rotate('..rotate..')\n'
        end_pcall()
    elseif nameBlock == 'editPositionX'  then
        local x = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..'target:translate('..x..', 0)\n'
        end_pcall()
    elseif nameBlock == 'editPositionY'  then
        local y = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..'target:translate(0,-('..y..'))\n'
        end_pcall()
    elseif nameBlock == 'setRotate' then
        local rotate = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..'target.rotation = '..rotate..'\n'
        end_pcall()
    elseif nameBlock == 'hide' then
        add_pcall()
        lua = lua..'target.isVisible = false\n'
        end_pcall()
    elseif nameBlock == 'show' then
        add_pcall()
        lua = lua..'target.isVisible = true\n'
        end_pcall()
    elseif nameBlock == 'setAlpha' then
        local alpha = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..'target.alpha = math.min(math.max(100-('..alpha..'),0),100)/100\n'
        end_pcall()
    elseif nameBlock == 'commentary' then
        local comment = make_all_formulas(infoBlock[2][1], object)
        lua = lua..'-- '..comment..'\n'
    elseif nameBlock == 'if' or nameBlock == 'ifElse (2)' then
        local condition = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..'if ('..condition..') then\n'
    elseif nameBlock == 'else' then
        lua = lua..'else\n'
    elseif nameBlock == 'endIf' then
        lua = lua..'end\n'
        end_pcall()
    elseif nameBlock == 'repeat' then
        local rep = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..'timer.GameNew(0,'..rep..', function()\n'
    elseif nameBlock == 'endRepeat' then
        lua = lua..'end)\n'
        end_pcall()
    elseif nameBlock == 'setVariable' and infoBlock[2][1][2]~=nil then
        local value = make_all_formulas(infoBlock[2][2], object)
        --add_pcall()
        if infoBlock[2][1][1] == 'globalVariable' then
            lua = lua..'var_'..infoBlock[2][1][2]..' = '..value..'\n'
            lua = lua..'if varText_'..infoBlock[2][1][2]..' then\n varText_'..infoBlock[2][1][2]..'.text = type(var_'..infoBlock[2][1][2]..')=="boolean" and (var_'..infoBlock[2][1][2]..' and words[373] or words[374]) or type(var_'..infoBlock[2][1][2]..')=="table" and encodeList(var_'..infoBlock[2][1][2]..') or var_'..infoBlock[2][1][2]..'\nend'
        else
            lua = lua..'target.var_'..infoBlock[2][1][2]..' = '..value..'\n'
            lua = lua..'if target.varText_'..infoBlock[2][1][2]..' then\n target.varText_'..infoBlock[2][1][2]..'.text = type(target.var_'..infoBlock[2][1][2]..')=="boolean" and (target.var_'..infoBlock[2][1][2]..' and words[373] or words[374]) or type(target.var_'..infoBlock[2][1][2]..')=="table" and encodeList(target.var_'..infoBlock[2][1][2]..') or target.var_'..infoBlock[2][1][2]..'\nend'
        end
        --end_pcall()
    elseif nameBlock == 'editVariable' and infoBlock[2][1][2]~=nil then
        local value = make_all_formulas(infoBlock[2][2], object)
        add_pcall()
        if infoBlock[2][1][1] == 'globalVariable' then
            lua = lua..'var_'..infoBlock[2][1][2]..' = type(var_'..infoBlock[2][1][2]..')=="boolean" and (var_'..infoBlock[2][1][2]..' and words[373] or words[374]) or type(var_'..infoBlock[2][1][2]..')=="table" and encodeList(var_'..infoBlock[2][1][2]..') or var_'..infoBlock[2][1][2]..'+('..make_all_formulas(infoBlock[2][2], object)..')\n'
            lua = lua..'if varText_'..infoBlock[2][1][2]..' then\n varText_'..infoBlock[2][1][2]..'.text = var_'..infoBlock[2][1][2]..'\nend'
        else
            lua = lua..'target.var_'..infoBlock[2][1][2]..' = target.var_'..infoBlock[2][1][2]..' + '..value..'\n'
            lua = lua..'if target.varText_'..infoBlock[2][1][2]..' then\n target.varText_'..infoBlock[2][1][2]..'.text = type(target.var_'..infoBlock[2][1][2]..')=="boolean" and (target.var_'..infoBlock[2][1][2]..' and words[373] or words[374]) or type(target.var_'..infoBlock[2][1][2]..')=="table" and encodeList(target.var_'..infoBlock[2][1][2]..') or target.var_'..infoBlock[2][1][2]..'\nend'
        end
        end_pcall()
    elseif nameBlock == 'openLink' then
        local link = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..'system.openURL('..link..')\n'
        end_pcall()
    elseif nameBlock == 'cycleForever' then
        add_pcall()
        lua = lua..'timer.new(0, function()\n'
    elseif nameBlock == 'endCycleForever' then
        lua = lua..'end, 0)\n'
        end_pcall()
    elseif nameBlock == 'repeatIsTrue' then
        local condition = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..'local repeatIsTrue\nrepeatIsTrue = timer.GameNew(0,0, function()\nif not ('..condition..') then\ntimer.cancel(repeatIsTrue)\nend\n'
    elseif nameBlock == 'setImageToId' and #images>0 then
        local image = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua.."local numberImage = ("..image.."-1)-math.floor((".. image.."-1)/"..#images..")*"..#images.."+1"
        lua = lua..'\ntarget.numberImage = numberImage\ntarget.image_path = \''..IDPROJECT..'/scene_'..scene_id..'/object_'..obj_id..'/image_\'..listImages[numberImage]..\'.png\'\n'
        lua = lua..'target.fill = {type = \'image\', filename = \''..IDPROJECT..'/scene_'..scene_id..'/object_'..obj_id..'/image_\'..listImages[numberImage]..\'.png\', baseDir = system.DocumentsDirectory}\n'
        lua = lua.."target.origWidth, target.origHeight = getImageProperties(target.image_path, system.DocumentsDirectory)\ntarget.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)\n"
        if (o==1) then
            lua = lua.."broadcastChangeBackground(listImages[numberImage])\n"
        end
        end_pcall()
    elseif nameBlock == 'clone' then
        add_pcall()
        if (infoBlock[2][1][2]~=nil) then
            lua = lua.."\nlocal target = objects['object_"..infoBlock[2][1][2].."']"
        end
        if (#images>0) then
            lua = lua.."\nlocal myClone = display.newImage(target.image_path, system.DocumentsDirectory, target.x, target.y)"
            lua = lua.."\nmyClone.image_path = target.image_path"
        else
            lua = lua.."\nlocal myClone = display.newImage('images/notVisible.png', target.x, target.y)"
        end
        lua = lua.."\ncameraGroup:insert(myClone)"
        lua = lua.."\nmyClone:addEventListener('touch', function(event)\nif (event.phase=='began') then\nlocal newIdTouch=globalConstants.touchId+1\nglobalConstants.touchId = newIdTouch\nglobalConstants.keysTouch['touch_'..newIdTouch], globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = event.id, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale, true\nglobalConstants.isTouch, globalConstants.touchX, globalConstants.touchY = true, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\ndisplay.getCurrentStage():setFocus(event.target, event.id)\nevent.target.isTouch = true\nfor key, value in pairs(objects) do\nfor i=1, #events_touchScreen[key] do\nevents_touchScreen[key][i](value)\nfor i2=1, #value.clones do\nevents_touchScreen[key][i](value.clones[i2])\nend\nend\nend\nfor i=1, #events_touchObject do\nevents_touchObject[i](event.target)\nend\nelseif (event.phase=='moved') then\nglobalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id] = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\nglobalConstants.touchX, globalConstants.touchY = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\nelse\ndisplay.getCurrentStage():setFocus(event.target, nil)\nevent.target.isTouch = nil\nglobalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = nil, nil, nil\nif (pocketupFuns.getCountTouch(globalConstants.isTouchsId)==0) then\nglobalConstants.keysTouch = {}\nglobalConstants.isTouch = false\nend\nend\nreturn(true)\nend)"
        lua = lua.."\nmyClone.xScale, myClone.yScale, myClone.alpha, myClone.rotation, myClone.numberImage, myClone.parent_obj = target.xScale, target.yScale, target.alpha, target.rotation, target.numberImage, target.parent_obj\ntarget.clones[#target.clones+1] = myClone\nmyClone.idClone, myClone.tableVarShow, myClone.origWidth, myClone.origHeight, myClone.width, myClone.height, myClone.property_size = #target.parent_obj, {}, target.origWidth, target.origHeight, target.width, target.height, target.property_size"
        lua = lua.."\nmyClone.isVisible = target.isVisible\nmyClone.physicsReload, myClone.physicsType , myClone.physicsTable = target.physicsReload or function(ob) end, target.physicsType or 'static' , json.decode(json.encode(target.physicsTable)) or {}\nmyClone:physicsReload()"
        lua = lua.."\nfor i=1, #events_startClone do\nevents_startClone[i](myClone)\nend\n"
        end_pcall()
    elseif nameBlock == 'deleteClone' then
        add_pcall()
        lua = "if (target.idClone ~= nil) then\ntable.remove(target.parent_obj.clones, target.idClone)\nfor i=1, #target.parent_obj.clones do\ntarget.parent_obj.clones[i].idClone = i\nend\ndisplay.remove(target)\nend\n"
        end_pcall()
    elseif (nameBlock == 'broadcastFunction' and infoBlock[2][1][2]~=nil) then
        add_pcall()
        lua = lua.."timer.new(0, function() broadcastFunction('fun_"..infoBlock[2][1][2].."')end)"
        end_pcall()
    elseif nameBlock == 'broadcastFunctionAndWait' and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua.."broadcastFunction('fun_"..infoBlock[2][1][2].."')"
        end_pcall()
    elseif nameBlock == 'vibration' then
        local time = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..'timer.new(100,function() system.vibrate("impact") end , (('..time..')*1000)/100)'
        end_pcall()
    elseif nameBlock == 'goSteps' then
        local steps = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..'target:translate(pocketupFuns.sin(target.rotation)*('..steps..'),- (pocketupFuns.cos(target.rotation)*('..steps..')))'
        end_pcall()
    elseif nameBlock == 'speedStepsToSecoond' then
        local x = make_all_formulas(infoBlock[2][1], object)
        local y = make_all_formulas(infoBlock[2][2], object)
        add_pcall()
        lua = lua..'target:setLinearVelocity('..x..',- ('..y..'))'
        end_pcall()
    elseif nameBlock == 'rotateLeftForever' then
        local force = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..'target:applyTorque(-('..force..')*100)'
        end_pcall()
    elseif nameBlock == 'rotateRightForever' then
        local force = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..'target:applyTorque(('..force..')*100)'
        end_pcall()
    elseif nameBlock == 'setBrightness' or nameBlock=='editBrightness' then
        local brig = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua.."target.fill.effect = \'filter.brightness\'\ntarget.property_brightness = math.max(math.min(("..(nameBlock=="setBrightness" and '' or 'target.property_brightness)+(')..brig.."), 200),0)\ntarget.fill.effect.intensity = (target.property_brightness)/100-1\n"
        end_pcall()
    elseif nameBlock == 'playSound' and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua..'if not playSounds['..infoBlock[2][1][2]..'] then\n'
        lua = lua..'playSounds['..infoBlock[2][1][2]..'] = audio.loadStream(\''..obj_path..'/sound_'..infoBlock[2][1][2]..'.mp3\', system.DocumentsDirectory)\n'
        lua = lua..'end\naudio.stop(playingSounds['..infoBlock[2][1][2]..'])\n'
        lua = lua..'playingSounds['..infoBlock[2][1][2]..'] = audio.play(playSounds[listSounds['.. infoBlock[2][1][2]..']])'
        end_pcall() -- проверен
    elseif nameBlock == 'stopSound' and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua..'audio.stop(playingSounds['..infoBlock[2][1][2]..'])\naudio.dispose(playSounds['.. infoBlock[2][1][2]..'])\nplaySounds['.. infoBlock[2][1][2]..'] = nil'
        end_pcall() --проверен
    elseif nameBlock == 'stopAllSounds' then
        add_pcall() -- работает
        lua = lua..'audio.stop()\naudio.dispose()\nplaySounds = {}'
        end_pcall()
    elseif nameBlock == 'setVolumeSound' then
        local volume = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..'audio.setVolume(('..volume..')/100 )'
        end_pcall()
    elseif nameBlock == 'editVolumeSound' then
        local volume = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..'audio.setVolume(audio.getVolume() + ('..volume..')/100 )'
        end_pcall()
    elseif nameBlock == 'for' then
        local one = make_all_formulas(infoBlock[2][1], object)
        local _end = make_all_formulas(infoBlock[2][2], object)
        max_fors = max_fors+1
        add_pcall()
        lua = lua..'for i'..max_fors..' = '..one..' , '.._end..', 1 do\n'
        if infoBlock[2][3][1] == 'globalVariable' then
            lua = lua..'var_'..infoBlock[2][3][2]..' = i'..max_fors..'\n'
        else
            lua = lua..'target.var_'..infoBlock[2][3][2]..' = i'..max_fors..'\n'
        end
    elseif nameBlock == 'endFor' then
        lua = lua..'end'
        end_pcall()
    elseif (nameBlock == "addBody") then
        add_pcall()
        if (infoBlock[2][1][2]~="noPhysic") then
        --    lua = lua..'local imageOutline = graphics.newOutline(10, target.image_path, system.DocumentsDirectory)\n'
            lua = lua..'target.physicsTable = {outline = graphics.newOutline(10, target.image_path, system.DocumentsDirectory), density=3, friction=0.3, bounce=0.3}\ntarget.physicsType = \''..infoBlock[2][1][2]..'\'\n'
            lua = lua..'target.physicsReload = function(target)\nphysics.removeBody(target)\n'
            lua = lua.."physics.addBody(target, target.physicsType , target.physicsTable)\nend"
            lua = lua..'\ntarget:physicsReload()'
            lua = lua.."\ntarget:addEventListener('collision', function(event)\nif (event.phase=='began') then\nevent.target.isTouchObject = true\ntimer.new(0, function()\nfor i=1, #events_collision do\nevents_collision[i](event.target, event.other.parent_obj.nameObject)\nend\nend)\nelseif (event.phase=='ended') then\nevent.target.isTouchObject = nil\nend\nend)"
        else
            lua = lua.."physics.removeBody(target)\ntarget.physicsReload = nil"
        end
        end_pcall()
    elseif nameBlock == 'setGravityAllObjects' then
        local x = make_all_formulas(infoBlock[2][1], object)
        local y = make_all_formulas(infoBlock[2][2], object)
        add_pcall()
        lua = lua..'physics.setGravity('..x..',-'..y..' )'
        end_pcall()
    elseif nameBlock == 'setWeight' then
        local mass = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..'target.physicsTable.density = '..mass..'\ntarget:physicsReload()'
        end_pcall()
    elseif nameBlock == 'setElasticity' then
        local bounce = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..'target.physicsTable.bounce = '..bounce..'/100\ntarget:physicsReload()'
        end_pcall()
    elseif nameBlock == 'setFriction' then
        local friction = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..'target.physicsTable.friction = '..friction..'/100\ntarget:physicsReload()'
        end_pcall()
    elseif nameBlock == 'setTypeRotate' then -- ["setTypeRotate",[["typeRotate","true"]],"on"]
        add_pcall()
        if infoBlock[2][1][2] == 'true' then
            lua = lua..'target.isFixedRotation = false'
        elseif infoBlock[2][1][2] == 'false' then
            lua = lua..'target.isFixedRotation = true'
        end
        end_pcall()
    elseif nameBlock == 'goTo' then -- ["goTo",[["goTo","touch"]],"on"] -- ["goTo",[["goTo",6]],"on"] -- ["goTo",[["goTo","random"]],"on"]
        add_pcall()
        if infoBlock[2][1][2] == 'touch' then
            lua = lua..'target.x , target.y = globalConstants.touchX, -globalConstants.touchY'
        elseif infoBlock[2][1][2] == 'random' then
            lua = lua..'target.x, target.y = math.random(-'..tostring(options.displayWidth/2)..','..tostring(options.displayWidth/2)..'), math.random(-'..tostring(options.displayHeight/2)..','..tostring(options.displayHeight/2)..')'
        else
            lua = lua..'local object = object_'..infoBlock[2][1][2]..'\ntarget.x, target.y = object.x, object.y'
        end
        end_pcall()
    elseif nameBlock == 'setRotateToObject' then -- ["setRotateToObject",[["objects",7]],"on"]
        add_pcall()
        lua = lua..'target.rotation = pocketupFuns.atan2(objects[\'object_'..infoBlock[2][1][2]..'\'].x - target.x, target.y - objects[\'object_'..infoBlock[2][1][2]..'\'].y)'
        end_pcall()
    elseif nameBlock == 'toFrontLayer' then
        add_pcall()
        lua = lua..'target:toFront()'
        end_pcall()
    elseif nameBlock == 'toBackLayer' then
        add_pcall()
        lua = lua..'target:toBack()'
        end_pcall()


    elseif nameBlock == 'setImageToName' and #images>0 and infoBlock[2][1][2]~=nil then
        local image = infoBlock[2][1][2]
        
        if (image~=nil) then
            add_pcall()
            lua = lua.."local newIdImage = nil\nfor i=1, #listImages do\nif (listImages[i]=="..image..") then\nnewIdImage=i\nbreak\nend\nend\nif (newIdImage ~= nil) then"
            lua = lua..'\ntarget.numberImage = newIdImage\ntarget.image_path = \''..IDPROJECT..'/scene_'..scene_id..'/object_'..obj_id..'/image_'..image..'.png\'\n'
            lua = lua..'target.fill = {type = \'image\', filename = \''..IDPROJECT..'/scene_'..scene_id..'/object_'..obj_id..'/image_'..image..'.png\', baseDir = system.DocumentsDirectory}\n'
            lua = lua.."target.origWidth, target.origHeight = getImageProperties(target.image_path, system.DocumentsDirectory)\ntarget.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)\n"
            if (o==1) then
                lua = lua.."broadcastChangeBackground(listImages[numberImage])\n"
            end
            lua = lua.."end\n"
            end_pcall()
        end
    elseif nameBlock == "nextImage" and #images>1 then
        add_pcall()
        lua = lua.."target.numberImage = target.numberImage==#listImages and 1 or target.numberImage+1\ntarget.image_path='"..IDPROJECT.."/scene_"..scene_id.."/object_"..obj_id.."/image_'..listImages[target.numberImage]..'.png'\n"
        lua = lua..'target.fill = {type = \'image\', filename = \''..IDPROJECT..'/scene_'..scene_id..'/object_'..obj_id..'/image_\'..listImages[target.numberImage]..\'.png\', baseDir = system.DocumentsDirectory}\n'
        lua = lua.."target.origWidth, target.origHeight = getImageProperties(target.image_path, system.DocumentsDirectory)\ntarget.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)\n"
        end_pcall()
    elseif nameBlock == "previousImage" and #images>1 then
        add_pcall()
        lua = lua.."target.numberImage = target.numberImage==1 and #listImages or target.numberImage-1\ntarget.image_path='"..IDPROJECT.."/scene_"..scene_id.."/object_"..obj_id.."/image_'..listImages[target.numberImage]..'.png'\n"
        lua = lua..'target.fill = {type = \'image\', filename = \''..IDPROJECT..'/scene_'..scene_id..'/object_'..obj_id..'/image_\'..listImages[target.numberImage]..\'.png\', baseDir = system.DocumentsDirectory}\n'
        lua = lua.."target.origWidth, target.origHeight = getImageProperties(target.image_path, system.DocumentsDirectory)\ntarget.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)\n"
        end_pcall()
    elseif nameBlock == "editAlpha" then
        add_pcall()
        lua = lua.."target.alpha = target.alpha - ("..make_all_formulas(infoBlock[2][1], object)..")/100"
        end_pcall()
    elseif nameBlock=="setColor" or nameBlock=="editColor" then
        add_pcall()
        lua = lua.."target.property_color = ("..(nameBlock=="setColor" and '' or "target.property_color)+(")..make_all_formulas(infoBlock[2][1],object)..")\nlocal r = pocketupFuns.sin(target.property_color-22+56)/2+0.724\nlocal g = pocketupFuns.cos(target.property_color+56)/2+0.724\nlocal b = pocketupFuns.sin(target.property_color+22+56)/2+0.724\ntarget:setFillColor(r,g,b)"
        end_pcall()
    elseif nameBlock=="createRadialParticle" and infoBlock[2][2][2]~=nil then
        local idsGL = {
            GL_ZERO=0,GL_ONE=1,GL_DST_COLOR=774,GL_ONE_MINUS_DST_COLOR=775,GL_SRC_ALPHA=770,GL_ONE_MINUS_SRC_ALPHA=771,GL_DST_ALPHA=772,GL_ONE_MINUS_DST_ALPHA=773,GL_SRC_ALPHA_SATURATE=776,GL_SRC_COLOR=768,GL_ONE_MINUS_SRC_COLOR=769
        }
        add_pcall()
        lua = lua.."local startRgb = hexToRgb("..make_all_formulas(infoBlock[2][23], object)..")\nlocal startVarianceRgb = hexToRgb("..make_all_formulas(infoBlock[2][24], object)..")\nlocal finishRgb = hexToRgb("..make_all_formulas(infoBlock[2][25], object)..")\nfinishVarianceRgb = hexToRgb("..make_all_formulas(infoBlock[2][26], object)..")\n"
        lua = lua.."if (objectsParticles["..make_all_formulas(infoBlock[2][1], object).."]~=nil) then\ndisplay.remove(objectsParticles["..make_all_formulas(infoBlock[2][1], object).."])\nend\nlocal particle = display.newEmitter({\nemitterType=1,\ntextureFileName='"..obj_path.."/image_"..infoBlock[2][2][2]..".png',\nmaxParticles="..make_all_formulas(infoBlock[2][3], object)..",\nabsolutePosition="..make_all_formulas(infoBlock[2][4], object)..",\nangle="..make_all_formulas(infoBlock[2][5], object)..",\nangleVriance="..make_all_formulas(infoBlock[2][6], object)..",\nmaxRadius="..make_all_formulas(infoBlock[2][7], object)..",\nmaxRadiusariance="..make_all_formulas(infoBlock[2][8], object)..",\nminRadius="..make_all_formulas(infoBlock[2][9], object)..",\nminRadiusVariance="..make_all_formulas(infoBlock[2][10], object)..",\nrotatePerSecond="..make_all_formulas(infoBlock[2][11], object)..",\nrotatePerSecondVariance="..make_all_formulas(infoBlock[2][12], object)..",\nparticleLifespan="..make_all_formulas(infoBlock[2][13], object)..",\nparticleLifespanVariance="..make_all_formulas(infoBlock[2][14], object)..",\nstartParticleSize="..make_all_formulas(infoBlock[2][15], object)..",\nstartParticleSizeVariance="..make_all_formulas(infoBlock[2][16], object)..",\nfinishParticleSize="..make_all_formulas(infoBlock[2][17], object)..",\nfinishParticleSizeVariance="..make_all_formulas(infoBlock[2][18], object)..",\nrotationStart="..make_all_formulas(infoBlock[2][19], object)..",\nrotationStartVariance="..make_all_formulas(infoBlock[2][20], object)..",\nrotationEnd="..make_all_formulas(infoBlock[2][21], object)..",\nrotationEndVariance="..make_all_formulas(infoBlock[2][22], object)..",\nstartColorRed=startRgb[1],\nstartColorGreen=startRgb[2],\nstartColorBlue=startRgb[3]\n,\nstartColorVarianceRed=startVarianceRgb[1],\nstartColorVarianceGreen=startVarianceRgb[2],\nstartColorVarianceBlue=startVarianceRgb[3],\nfinishColorRed=finishRgb[1],\nfinishColorGreen=finishRgb[2],\nfinishColorBlue=finishRgb[3],\nfinishColorVarianceRed=finishVarianceRgb[1],\nfinishColorVarianceRed=finishVarianceRgb[2],\nfinishColorVariance=finishVarianceRgb[3],\nblendFuncSource="..idsGL[infoBlock[2][27][2]]..",\nblendFuncDestination="..idsGL[infoBlock[2][28][2]].."\n,startColorAlpha=1, finishColorAlpha=1, duration=-1\n}, system.DocumentsDirectory)\ncameraGroup:insert(particle)\nobjectsParticles["..make_all_formulas(infoBlock[2][1], object).."] = particle\nparticle.x, particle.y = 0, 0"
        end_pcall()
    elseif nameBlock=="createLinearParticle" and infoBlock[2][2][2]~=nil then
        local idsGL = {
            GL_ZERO=0,GL_ONE=1,GL_DST_COLOR=774,GL_ONE_MINUS_DST_COLOR=775,GL_SRC_ALPHA=770,GL_ONE_MINUS_SRC_ALPHA=771,GL_DST_ALPHA=772,GL_ONE_MINUS_DST_ALPHA=773,GL_SRC_ALPHA_SATURATE=776,GL_SRC_COLOR=768,GL_ONE_MINUS_SRC_COLOR=769
        }
        add_pcall()
        lua = lua.."local startRgb = hexToRgb("..make_all_formulas(infoBlock[2][27], object)..")\nlocal startVarianceRgb = hexToRgb("..make_all_formulas(infoBlock[2][28], object)..")\nlocal finishRgb = hexToRgb("..make_all_formulas(infoBlock[2][29], object)..")\nfinishVarianceRgb = hexToRgb("..make_all_formulas(infoBlock[2][30], object)..")\n"
        lua = lua.."if (objectsParticles["..make_all_formulas(infoBlock[2][1], object).."]~=nil) then\ndisplay.remove(objectsParticles["..make_all_formulas(infoBlock[2][1], object).."])\nend\nlocal particle = display.newEmitter({\nemitterType=0,\ntextureFileName='"..obj_path.."/image_"..infoBlock[2][2][2]..".png'\n,maxParticles="..make_all_formulas(infoBlock[2][3], object)..",\nabsolutePosition="..make_all_formulas(infoBlock[2][4], object)..",\nangle="..make_all_formulas(infoBlock[2][5], object)..",\nangleVriance="..make_all_formulas(infoBlock[2][6], object)..",\nspeed="..make_all_formulas(infoBlock[2][7], object)..",\nspeedVariance="..make_all_formulas(infoBlock[2][8], object)..",\nsourcePositionVariancex="..make_all_formulas(infoBlock[2][9], object)..",\nsourcePositionVariancey="..make_all_formulas(infoBlock[2][10], object)..",\ngravityx="..make_all_formulas(infoBlock[2][11], object)..",\ngravityy=-"..make_all_formulas(infoBlock[2][12], object)..",\nradialAcceleration="..make_all_formulas(infoBlock[2][13], object)..",\nradialAccelVariance="..make_all_formulas(infoBlock[2][14], object)..",\ntangentialAcceleration="..make_all_formulas(infoBlock[2][15], object)..",\ntangentialAccelVariance="..make_all_formulas(infoBlock[2][16], object)..",\nparticleLifespan="..make_all_formulas(infoBlock[2][17], object)..",\nparticleLLifespanVariance="..make_all_formulas(infoBlock[2][18], object)..",\nstartParticleSize="..make_all_formulas(infoBlock[2][19], object)..",\nstartParticleSizeVariance="..make_all_formulas(infoBlock[2][20], object)..",\nfinishParticleSize="..make_all_formulas(infoBlock[2][21], object)..",\nfinishParticleSizeVariance="..make_all_formulas(infoBlock[2][22], object)..",\nrotationStart="..make_all_formulas(infoBlock[2][23], object)..",\nrotationStartVariance="..make_all_formulas(infoBlock[2][24], object)..",\nrotationEnd="..make_all_formulas(infoBlock[2][25], object)..",\nrotationEndVariance="..make_all_formulas(infoBlock[2][26], object)..",\nstartColorRed=startRgb[1],startColorGreen=startRgb[2],startColorBlue=startRgb[3],startColorVarianceRed=startVarianceRgb[1],startColorVarianceGreen=startVarianceRgb[2],startColorVarianceBlue=startVarianceRgb[3],finishColorRed=finishRgb[1],finishColorGreen=finishRgb[2],finishColorBlue=finishRgb[3],finishColorVarianceRed=finishVarianceRgb[1],finishColorVarianceGreen=finishVarianceRgb[2],finishColorVarianceBlue=finishVarianceRgb[3],blendFuncSource="..idsGL[infoBlock[2][31][2]]..",\nblendFuncDestination="..idsGL[infoBlock[2][32][2]]..",\nstartColorAlpha=1, finishColorAlpha=1, duration=-1\n}, system.DocumentsDirectory)\ncameraGroup:insert(particle)\nobjectsParticles["..make_all_formulas(infoBlock[2][1], object).."] = particle\nparticle.x, particle.y = 0, 0"
        end_pcall()
    elseif nameBlock=="setPositionParticle" then
        add_pcall()
        lua = lua.."local particle = objectsParticles["..make_all_formulas(infoBlock[2][1], object).."]\nif (particle~=nil) then\nparticle.x, particle.y = "..make_all_formulas(infoBlock[2][2], object)..", "..make_all_formulas(infoBlock[2][3], object).."\nend"
        end_pcall()
    elseif nameBlock=="deleteParticle" then
        add_pcall()
        lua = lua.."local particle = objectsParticles["..make_all_formulas(infoBlock[2][1], object).."]\nif (particle~=nil) then\ndisplay.remove(particle)\nobjectsParticles["..make_all_formulas(infoBlock[2][1], object).."]=nil\nend"
        end_pcall()
    elseif nameBlock=="deleteAllParticles" then
        add_pcall()
        lua = lua.."for key, value in pairs(objectsParticles) do\ndisplay.remove(value)\nend\nobjectsParticles = {}"
        end_pcall()
    elseif nameBlock=="editPositionXParticle" then
        add_pcall()
        lua = lua.."local particle = objectsParticles["..make_all_formulas(infoBlock[2][1], object).."]\nif (particle~=nil) then\nparticle.x = particle.x+"..make_all_formulas(infoBlock[2][2], object).."\nend"
        end_pcall()
    elseif nameBlock=="editPositionYParticle" then
        add_pcall()
        lua = lua.."local particle = objectsParticles["..make_all_formulas(infoBlock[2][1], object).."]\nif (particle~=nil) then\nparticle.y = particle.y-"..make_all_formulas(infoBlock[2][2], object).."\nend"
        end_pcall()
    elseif nameBlock == 'setImageBackgroundToName' and #images>0 and infoBlock[2][1][2]~=nil then
        local image = infoBlock[2][1][2]
        
        if (image~=nil) then
            add_pcall()
            lua = lua.."local newIdImage = nil\nfor i=1, #background.listImagesBack do\nif (background.listImagesBack[i]=="..image..") then\nnewIdImage=i\nbreak\nend\nend\nif (newIdImage ~= nil) then"
            lua = lua..'\nbackground.numberImage = newIdImage\nbackground.image_path = background.obj_pathBack..\'/image_'..image..'.png\'\n'
            lua = lua..'background.fill = {type = \'image\', filename = background.image_path, baseDir = system.DocumentsDirectory}\n'
            lua = lua.."background.origWidth, background.origHeight = getImageProperties(background.image_path, system.DocumentsDirectory)\nbackground.width, background.height = background.origWidth*(background.property_size/100), background.origHeight*(background.property_size/100)\n"
            if (o==1) then
                lua = lua.."broadcastChangeBackground(listImages[numberImage])\n"
            end
            lua = lua.."end\n"
            end_pcall()
        end
    elseif nameBlock == 'setImageBackgroundToId' and #images>0 then
        local image = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua.."local numberImage = ("..image.."-1)-math.floor((".. image.."-1)/#background.listImagesBack)*#background.listImagesBack+1"
        lua = lua..'\nbackground.numberImage = numberImage\nbackground.image_path = background.obj_pathBack..\'/image_\'..background.listImagesBack[numberImage]..\'.png\'\n'
        lua = lua..'background.fill = {type = \'image\', filename = background.image_path, baseDir = system.DocumentsDirectory}\n'
        lua = lua.."background.origWidth, background.origHeight = getImageProperties(background.image_path, system.DocumentsDirectory)\nbackground.width, background.height = background.origWidth*(background.property_size/100), background.origHeight*(background.property_size/100)\n"
        if (o==1) then
            lua = lua.."broadcastChangeBackground(listImages[numberImage])\n"
        end
        end_pcall()
    elseif nameBlock=='getLinkImage' then
        add_pcall()
        lua = lua.."local function networkListener(event)\ntarget.image_path = 'objectImage_"..obj_id..".png'\ntarget.fill = {type = \'image\', filename = target.image_path, baseDir=system.TemporaryDirectory}\ntarget.origWidth, target.origHeight = getImageProperties(target.image_path, system.TemporaryDirectory)\ntarget.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)\nend\nnetwork.download("..make_all_formulas(infoBlock[2][1],object)..",'GET', networkListener, 'objectImage_"..obj_id..".png', system.TemporaryDirectory)"
        end_pcall()
    elseif nameBlock == 'stamp' then
        add_pcall()
        lua = lua..'local obj = #tableFeathers+1\ntableFeathers[obj] = display.newImage(target.image_path, system.DocumentsDirectory, target.x, target.y)\nstampsGroup:insert(tableFeathers[obj])'
        lua = lua..'tableFeathers[obj].width, tableFeathers[obj].height = target.width, target.height'
        end_pcall()
    elseif nameBlock == 'clearPen' then
        add_pcall()
        lua = lua..'for i = 1, #tableFeathers, 1 do\ndisplay.remove(tableFeathers[i])\nend\ntableFeathers = {}'
        end_pcall()
    elseif nameBlock == 'setColorPen' then
        local r = make_all_formulas(infoBlock[2][1], object)
        local g = make_all_formulas(infoBlock[2][2], object)
        local b = make_all_formulas(infoBlock[2][3], object)
        add_pcall()
        lua = lua..'tableFeathersOptions[2] = '..r..'\ntableFeathersOptions[3] = '..g..'\ntableFeathersOptions[4] = '..b
        end_pcall()
    elseif nameBlock == 'setSizePen' then
        local size = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..'tableFeathersOptions[1] = '..size
        end_pcall()
    elseif nameBlock == 'blockTouch' then
        lua = lua..
'for i=1, #events_touchObject, 1 do\
events_touchObject[i](target)\
end'
    elseif nameBlock == 'blockTouchScreen' then
        lua = lua..
'for key, value in pairs(objects) do\
for i=1, #events_touchScreen[key] do\
events_touchScreen[key][i](value)\
for i2=1, #value.clones do\
events_touchScreen[key][i](value.clones[i2])\
end\
end\
end'
    elseif nameBlock == 'showVariable' and infoBlock[2][1][2]~=nil then
        local x = make_all_formulas(infoBlock[2][2], object)
        local y = make_all_formulas(infoBlock[2][3], object)
        --add_pcall()
        if infoBlock[2][1][1] == 'globalVariable' then
            lua = lua..'if (varText_'..infoBlock[2][1][2]..'~=nil and varText_'..infoBlock[2][1][2]..'.text~=nil) then\ndisplay.remove(varText_'..infoBlock[2][1][2]..'~=nil)\nend\nvarText_'..infoBlock[2][1][2]..' = display.newText(type(var_'..infoBlock[2][1][2]..')=="boolean" and (var_'..infoBlock[2][1][2]..' and words[373] or words[374]) or type(var_'..infoBlock[2][1][2]..')=="table" and encodeList(var_'..infoBlock[2][1][2]..') or var_'..infoBlock[2][1][2]..', '..x..', -'..y..', "fonts/font_1", 30)\n'
            lua = lua..'varText_'..infoBlock[2][1][2]..':setFillColor(0, 0, 0)'
            lua = lua.."\ncameraGroup:insert(varText_"..infoBlock[2][1][2]..")"
        else
            lua = lua..'if (target.varText_'..infoBlock[2][1][2]..'~=nil and target.varText_'..infoBlock[2][1][2]..'.text~=nil) then\ndisplay.remove(target.varText_'..infoBlock[2][1][2]..'~=nil)\nend\ntarget.varText_'..infoBlock[2][1][2]..' = display.newText(type(target.var_'..infoBlock[2][1][2]..')=="boolean" and (target.var_'..infoBlock[2][1][2]..' and words[373] or words[374]) or type(target.var_'..infoBlock[2][1][2]..')=="table" and encodeList(target.var_'..infoBlock[2][1][2]..') or target.var_'..infoBlock[2][1][2]..', '..x..', -'..y..', "fonts/font_1", 30)\n'
            lua = lua..'target.varText_'..infoBlock[2][1][2]..':setFillColor(0, 0, 0)'
            lua = lua.."\ncameraGroup:insert(target.varText_"..infoBlock[2][1][2]..")"
        end
        --end_pcall()
    elseif nameBlock == 'showVariable2' and infoBlock[2][1][2]~=nil then
        local x = make_all_formulas(infoBlock[2][2], object)
        local y = make_all_formulas(infoBlock[2][3], object)
        local size = make_all_formulas(infoBlock[2][4], object)
        local hex = make_all_formulas(infoBlock[2][5], object)
        local aligh = infoBlock[2][6][2]
        add_pcall()
        if infoBlock[2][1][1] == 'globalVariable' then
            lua = lua..'if (varText_'..infoBlock[2][1][2]..'~=nil and varText_'..infoBlock[2][1][2]..'.text~=nil) then\ndisplay.remove(varText_'..infoBlock[2][1][2]..'~=nil)\nend\nvarText_'..infoBlock[2][1][2]..' = display.newText({text = type(var_'..infoBlock[2][1][2]..')=="boolean" and (var_'..infoBlock[2][1][2]..' and words[373] or words[374]) or type(var_'..infoBlock[2][1][2]..')=="table" and encodeList(var_'..infoBlock[2][1][2]..') or var_'..infoBlock[2][1][2]..', align="'..aligh..'", x = '..x..', y = - '..y..', font = nil, fontSize = 30 *('..size..'/100) })\n'
            lua = lua..'local rgb = hexToRgb('..hex..')\n'
            lua = lua..'varText_'..infoBlock[2][1][2]..':setFillColor(rgb[1], rgb[2], rgb[3])'
            lua = lua.."\ncameraGroup:insert(varText_"..infoBlock[2][1][2]..")"
        else
            lua = lua..'if (target.varText_'..infoBlock[2][1][2]..'~=nil and target.varText_'..infoBlock[2][1][2]..'.text~=nil) then\ndisplay.remove(target.varText_'..infoBlock[2][1][2]..'~=nil)\nend\ntarget.varText_'..infoBlock[2][1][2]..' = display.newText({text = type(target.var_'..infoBlock[2][1][2]..')=="boolean" and (target.var_'..infoBlock[2][1][2]..' and words[373] or words[374]) or type(target.var_'..infoBlock[2][1][2]..')=="table" and encodeList(target.var_'..infoBlock[2][1][2]..') or target.var_'..infoBlock[2][1][2]..', align="'..aligh..'", x = '..x..', y = - '..y..', font = nil, fontSize = 30 *('..size..'/100) })\n'
            lua = lua..'local rgb = hexToRgb('..hex..')\n'
            lua = lua..'target.varText_'..infoBlock[2][1][2]..':setFillColor(rgb[1], rgb[2], rgb[3])'
            lua = lua.."\ncameraGroup:insert(target.varText_"..infoBlock[2][1][2]..")"
        end
        end_pcall()
    elseif nameBlock == 'hideVariable' and infoBlock[2][1][2]~=nil then
        add_pcall()
        if infoBlock[2][1][1] == 'globalVariable' then
            lua = lua..'display.remove(varText_'..infoBlock[2][1][2]..')\nvarText_'..infoBlock[2][1][2]..' = nil'
        else
            lua = lua..'display.remove(target.varText_'..infoBlock[2][1][2]..')\ntarget.varText_'..infoBlock[2][1][2]..' = nil'
        end
        end_pcall()
    elseif nameBlock == 'focusCameraToObject' then
        add_pcall()
        lua = lua.."if (focusCameraObject == nil) then\nfocusCameraObject = target\ntarget.timerCamera = timer.new(0, function()\ncameraGroup.x, cameraGroup.y = -focusCameraObject.x + math.max(math.min(focusCameraObject.x+cameraGroup.x,"..tostring(options.displayWidth/2).."/100*"..make_all_formulas(infoBlock[2][1], object).."),-"..tostring(options.displayWidth/2).."/100*"..make_all_formulas(infoBlock[2][1], object).."), -focusCameraObject.y + math.max(math.min(focusCameraObject.y+cameraGroup.y,"..tostring(options.displayHeight/2).."/100*"..make_all_formulas(infoBlock[2][2], object).."),-"..tostring(options.displayHeight/2).."/100*"..make_all_formulas(infoBlock[2][2], object)..") \nend, 0)\nelse\nfocusCameraObject = target\nend"
        end_pcall()
    elseif nameBlock=="removeObjectCamera" then
        add_pcall()
        lua = lua.."notCameraGroup:insert(target)"
        end_pcall()
    elseif nameBlock=="insertObjectCamera" then
        add_pcall()
        lua = lua.."cameraGroup:insert(target)"
        end_pcall()
    elseif nameBlock=="removeVariableCamera" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua.."notCameraGroup:insert("..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..")"
        end_pcall()
     elseif nameBlock=="insertVariableCamera" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua.."cameraGroup:insert("..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..")"
        end_pcall()
    elseif nameBlock=="removeFocusCameraToObject" then
        add_pcall()
        lua = lua.."if (focusCameraObject~=nil) then\ntimer.cancel(focusCameraObject.timerCamera)\nfocusCameraObject = nil\nend"
        end_pcall()
    elseif nameBlock=="saveVariable" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua..'local arrayVariables = json.decode(funsP["получить сохранение"]("'..(infoBlock[2][1][1]=="globalVariable" and IDPROJECT or obj_path)..'/variables"))'
        lua = lua..'\nfor i=1, #arrayVariables do\nif (arrayVariables[i][1]=='..infoBlock[2][1][2]..') then\narrayVariables[i][3] = '..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..'\nfunsP["записать сохранение"]("'..(infoBlock[2][1][1]=="globalVariable" and IDPROJECT or obj_path)..'/variables", json.encode(arrayVariables))\nbreak\nend\nend'
        end_pcall()
    elseif nameBlock=="readVariable" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua..'local arrayVariables = json.decode(funsP["получить сохранение"]("'..(infoBlock[2][1][1]=="globalVariable" and IDPROJECT or obj_path)..'/variables"))'
        lua = lua..'\nfor i=1, #arrayVariables do\nif (arrayVariables[i][1]=='..infoBlock[2][1][2]..') then\n'..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..'= arrayVariables[i][3]~=nil and arrayVariables[i][3] or 0\nbreak\nend\nend'
        end_pcall()
    elseif nameBlock=="addElementArray" and infoBlock[2][2][2]~=nil then
        add_pcall()
        lua = lua..(infoBlock[2][2][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][2][2].."[#"..(infoBlock[2][2][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][2][2].."+1] = "..make_all_formulas(infoBlock[2][1], object)
        end_pcall()
    elseif nameBlock=="deleteElementArray" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua.."table.remove("..(infoBlock[2][1][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][1][2]..", "..make_all_formulas(infoBlock[2][2],object)..")"
        end_pcall()
    elseif nameBlock=="deleteAllElementsArray" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua..(infoBlock[2][1][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][1][2].." = {}"
        end_pcall()
    elseif nameBlock=="pasteElementArray" and infoBlock[2][2][2]~=nil then
        add_pcall()
         lua = lua.."if ("..make_all_formulas(infoBlock[2][3], object).."<=#"..(infoBlock[2][2][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][2][2].."+1 and "..make_all_formulas(infoBlock[2][3], object)..">0) then\ntable.insert("..(infoBlock[2][2][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][2][2]..", "..make_all_formulas(infoBlock[2][3], object)..", "..make_all_formulas(infoBlock[2][1], object)..")\nend"
        end_pcall()
    elseif nameBlock=="replaceElementArray" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua.."if ("..make_all_formulas(infoBlock[2][2], object).."<=#"..(infoBlock[2][1][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][1][2].."+1 and "..make_all_formulas(infoBlock[2][2], object)..">0) then\n"..(infoBlock[2][1][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][1][2].."["..make_all_formulas(infoBlock[2][2],object).."] = "..make_all_formulas(infoBlock[2][3],object).."\nend"
        end_pcall()
    elseif nameBlock=="saveArray" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua..'local arrayArrays = json.decode(funsP["получить сохранение"]("'..(infoBlock[2][1][1]=="globalArray" and IDPROJECT or obj_path)..'/arrays"))'
        lua = lua..'\nfor i=1, #arrayArrays do\nif (arrayArrays[i][1]=='..infoBlock[2][1][2]..') then\narrayArrays[i][3] = '..(infoBlock[2][1][1]=="globalArray" and '' or 'target.')..'list_'..infoBlock[2][1][2]..'\nfunsP["записать сохранение"]("'..(infoBlock[2][1][1]=="globalArray" and IDPROJECT or obj_path)..'/arrays", json.encode(arrayArrays))\nbreak\nend\nend\nprint(json.encode(list_1))'
        end_pcall()
    elseif nameBlock=="readArray" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua..'local arrayArrays = json.decode(funsP["получить сохранение"]("'..(infoBlock[2][1][1]=="globalArray" and IDPROJECT or obj_path)..'/arrays"))'
        lua = lua..'\nfor i=1, #arrayArrays do\nif (arrayArrays[i][1]=='..infoBlock[2][1][2]..') then\n'..(infoBlock[2][1][1]=="globalArray" and '' or 'target.')..'list_'..infoBlock[2][1][2]..'= arrayArrays[i][3]~=nil and arrayVariables[i][3] or {}\nbreak\nend\nend'
        end_pcall()
    elseif nameBlock=="columnStorageToArray" and infoBlock[2][3][2]~=nil then
        add_pcall()
        lua = lua.."local allArraysValues = json.decode('[\"'.."..make_all_formulas(infoBlock[2][2], object)..":gsub('\"','\\\\\"'):gsub('\\r\\n','\",\"'):gsub('\\n','\",\"')..'\"]')"
        lua = lua.."\nfor i=1, #allArraysValues do\nlocal values = json.decode('[\"'..allArraysValues[i]:gsub('\\\"','\\\\\"'):gsub(',','\",\"')..'\"]')\nallArraysValues[i] = values["..make_all_formulas(infoBlock[2][1], object).."]==nil and '' or values["..make_all_formulas(infoBlock[2][1], object).."]\nend"
        lua = lua.."\n"..(infoBlock[2][3][1]=="globalArray" and '' or 'target.').."list_"..infoBlock[2][3][2].." = allArraysValues"
        end_pcall()
    elseif nameBlock=="getRequest" and infoBlock[2][2][2]~=nil then
        add_pcall()
        lua = lua.."local function networkListener(event)\n"..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2].." = event.status==200 and event.response or event.status\nif ("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][2][2]..") then\n"..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][2][2]..".text = type("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..")=='boolean' and ("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2].." and words[373] or words[374]) or type("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..")=='table' and encodeList("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..") or "..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2].."\nend\nend\nlocal header = {headers={[\"User-Agent\"] = \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36\"}}\n\nnetwork.request("..make_all_formulas(infoBlock[2][1],object)..",'GET',networkListener, header)"
        end_pcall()
    elseif nameBlock=="exitGame" then
        add_pcall()
        lua = lua.."timer.new(0, function()\nfunBackListener({keyName='deleteBack', phase='up'})\nend)"
        end_pcall()
    elseif nameBlock=="runScene" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua.."deleteScene()\nscene_"..infoBlock[2][1][2].."()"
        end_pcall()
    elseif nameBlock == 'foreach' and infoBlock[2][1][2]~=nil and infoBlock[2][2][2]~=nil then
        add_pcall()
        max_fors = max_fors+1
        lua = lua..'for key'..max_fors..', value'..max_fors..' in pairs('
        lua = lua..(infoBlock[2][1][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][1][2]..') do\n'
        lua = lua..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..' = value'..max_fors..'\n'
        lua = lua..'if '..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..' then\n target.varText_'..infoBlock[2][1][2]..'.text = type('..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..")=='boolean' and ("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2].." and words[373] or words[374]) or type("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..")=='table' and encodeList("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..") or "..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..'\nend'
    elseif nameBlock == 'endForeach' then
        lua = lua..'end'
        end_pcall()
    elseif nameBlock == 'lowerPen' then
    -- tableFeathers = {} сюда через table.insert(object) добавлять перья
    -- tableFeathersOptions[1] -размер пера
    -- tableFeathersOptions[2] - цвет r
    -- tableFeathersOptions[3] - цвет g
    -- tableFeathersOptions[4] - цвет b
        add_pcall()
        lua = lua.."if (target.isPen==nil) then\ntarget.isPen = true\nlocal line = display.newLine(target.x, target.y, target.x, target.y+1)\nline:setStrokeColor(tableFeathersOptions[2]/255,tableFeathersOptions[3]/255,tableFeathersOptions[4]/255,1)\nline.strokeWidth = tableFeathersOptions[1]\nstampsGroup:insert(line)\nlocal timerPen\ntimerPen = timer.new(50, function()\nif (target.isPen and line.x) then\nif (line.oldX~=target.x or line.oldY~=target.y) then\nline:append(target.x, target.y)\nline.oldX, line.oldY = target.x, target.y\nend\nelseif (line.x == nil) then\nprint('dddddddddddddddddddddddddddddddddd')\nline = display.newLine(target.x, target.y, target.x, target.y)\nline:setStrokeColor(tableFeathersOptions[2],tableFeathersOptions[3],tableFeathersOptions[4],1)\nline.strokeWidth = tableFeathersOptions[1]\ntable.insert(tableFeathers, #tableFeathers+1, line)\nstampsGroup:insert(line)\nelse\ntimer.cancel(timerPen)\nend\nend,0)\ntable.insert(tableFeathers, #tableFeathers+1, line)\nend"
        end_pcall()
    elseif nameBlock == 'raisePen' then
        add_pcall()
        lua = lua.."target.isPen=nil"
        end_pcall()
    elseif nameBlock == 'broadcastFun>allObjects' and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua.."local function broadcastFunction(nameFunction)\nfor key, value in pairs(objects) do\nfor i=1, #events_function[key][nameFunction] do\nevents_function[key][nameFunction][i](value)\nend\nend\nend\nbroadcastFunction('fun_"..infoBlock[2][1][2].."')"
        end_pcall()
    elseif nameBlock == 'broadcastFun>allClones' and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua.."local function broadcastFunction(nameFunction)\nfor key, value in pairs(objects) do\nfor i=1, #events_function[key][nameFunction] do\nfor i2=1, #value.clones do\nevents_function[key][nameFunction][i](value.clones[i2])\nend\nend\nend\nend\nbroadcastFunction('fun_"..infoBlock[2][1][2].."')"
        end_pcall()
    elseif nameBlock=='broadcastFun>objectAndClones' and infoBlock[2][1][2]~=nil and infoBlock[2][2][2]~=nil then
        add_pcall()
        lua = lua.."local function broadcastFunction(nameFunction)\nlocal key = 'object_"..(infoBlock[2][1][2]==nil and obj_id or infoBlock[2][1][2]).."'\nlocal value = objects[key]\nfor i=1, #events_function[key][nameFunction] do\nevents_function[key][nameFunction][i](value)\nfor i2=1, #value.clones do\nevents_function[key][nameFunction][i](value.clones[i2])\nend\nend\nend\nbroadcastFunction('fun_"..infoBlock[2][2][2].."')"
        end_pcall()
    elseif nameBlock=='broadcastFun>object' and infoBlock[2][1][2]~=nil and infoBlock[2][2][2]~=nil then
        add_pcall()
        lua = lua.."local function broadcastFunction(nameFunction)\nlocal key = 'object_"..(infoBlock[2][1][2]==nil and obj_id or infoBlock[2][1][2]).."'\nlocal value = objects[key]\nfor i=1, #events_function[key][nameFunction] do\nevents_function[key][nameFunction][i](value)\nend\nend\nbroadcastFunction('fun_"..infoBlock[2][2][2].."')"
        end_pcall()
    elseif nameBlock=='broadcastFun>clones' and infoBlock[2][1][2]~=nil and infoBlock[2][2][2]~=nil then
        add_pcall()
        lua = lua.."local function broadcastFunction(nameFunction)\nlocal key = 'object_"..(infoBlock[2][1][2]==nil and obj_id or infoBlock[2][1][2]).."'\nlocal value = objects[key]\nfor i=1, #events_function[key][nameFunction] do\nfor i2=1, #value.clones do\nevents_function[key][nameFunction][i](value.clones[i2])\nend\nend\nend\nbroadcastFunction('fun_"..infoBlock[2][2][2].."')"
        end_pcall()
    elseif nameBlock=='addNameClone' then
        add_pcall()
        lua = lua.."tableNamesClones["..make_all_formulas(infoBlock[2][1], object).."] = target\ntarget.nameObject = 'object_"..obj_id.."'"
        end_pcall()
    elseif nameBlock=='broadcastFun>nameClone' and infoBlock[2][2][2]~=nil then
        add_pcall()
        lua = lua.."local function broadcastFunction(nameFunction)\nlocal value = tableNamesClones["..make_all_formulas(infoBlock[2][1], object).."]\nlocal key = value.nameObject\nfor i=1, #events_function[key][nameFunction] do\nevents_function[key][nameFunction][i](value)\nend\nend\nbroadcastFunction('fun_"..infoBlock[2][2][2].."')"
        end_pcall()
    elseif nameBlock == 'waitIfTrue' then
        local arg1 = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..'timer.GameNew(0, 0, function()\n'
        lua = lua..'if not '..arg1..' then\nreturn true\nend'
    elseif nameBlock == 'endWait' then
        lua = lua..'end)'
        end_pcall()
    elseif nameBlock == 'setBackgroundColor' then
        add_pcall()
        local arg1 = make_all_formulas(infoBlock[2][1], object)
        local arg2 = make_all_formulas(infoBlock[2][2], object)
        local arg3 = make_all_formulas(infoBlock[2][3], object)
        lua = lua..'display.setDefault(\'background\', '..arg1..'/255, '..arg3..'/255, '..arg2..'/255)\n'
        end_pcall()
    elseif nameBlock == 'setBackgroundColorHex' then
        add_pcall()
        local arg1 = make_all_formulas(infoBlock[2][1], object)
        lua = lua..'local _hex_rgb = hexToRgb('..arg1..')\ndisplay.setDefault("background", _hex_rgb[1], _hex_rgb[2], _hex_rgb[3])\n_hex_rgb = nil\n'
        --native.showAlert('Monsler', arg1, {'OK'})
        end_pcall()
    elseif nameBlock == 'cancelAllTimers' then
        add_pcall()
        lua = lua..'timer.cancelAll()'
        end_pcall()
    elseif nameBlock == 'showToast' then
        add_pcall()
        local arg1 = make_all_formulas(infoBlock[2][1], object)
        lua = lua..'if not isSim and not isWin then require \'plugin.toaster\'.shortToast('..arg1..') end\n'
        end_pcall()
    elseif nameBlock == 'showHitboxes' then
        add_pcall()
        lua = lua..'physics.setDrawMode("hybrid")\n'
        end_pcall()
    elseif nameBlock == 'hideHitboxes' then
        add_pcall()
        lua = lua..'physics.setDrawMode("normal")\n'
        end_pcall()
    elseif nameBlock == 'setHorizontalOrientation' then
        add_pcall()
        lua = lua.."orientation.lock('landscape')\nmainGroup.xScale, mainGroup.yScale = "..tostring(not options.aspectRatio and yScaleMainGroup or xScaleMainGroup)..", "..tostring(xScaleMainGroup).."\nmainGroup.x, mainGroup.y = CENTER_Y, CENTER_X\nblackRectTop.width, blackRectTop.height = display.contentHeight, display.contentWidth\nblackRectTop.x, blackRectTop.y = "..("-"..tostring(options.displayHeight/2)..",0" ).."\nblackRectTop.anchorX, blackRectTop.anchorY = 1, 0.5\nblackRectBottom.width, blackRectBottom.height = display.contentHeight, display.contentWidth\nblackRectBottom.x, blackRectBottom.y = "..(tostring(options.displayHeight/2)..",0" ).."\nblackRectBottom.anchorX, blackRectBottom.anchorY = 0, 0.5"
        end_pcall()
    elseif nameBlock == 'setVerticalOrientation' then
        add_pcall()
        lua = lua.."orientation.lock('portrait')\nmainGroup.xScale, mainGroup.yScale = "..tostring(xScaleMainGroup)..", "..tostring(not options.aspectRatio and yScaleMainGroup or xScaleMainGroup).."\nmainGroup.x, mainGroup.y = CENTER_X, CENTER_Y\nblackRectTop.width, blackRectTop.height = display.contentWidth, display.contentHeight\nblackRectTop.x, blackRectTop.y = "..("0,-"..tostring(options.displayHeight/2)).."\nblackRectTop.anchorY, blackRectTop.anchorX = 1, 0.5\nblackRectBottom.x, blackRectBottom.y = "..("0,"..tostring(options.displayHeight/2)).."\nblackRectBottom.anchorY, blackRectBottom.anchorX = 0, 0.5"
        end_pcall()
    elseif nameBlock == 'thinkTime' then
        add_pcall()
        local arg1 = make_all_formulas(infoBlock[2][1], object)
        local arg2 = make_all_formulas(infoBlock[2][2], object)
        lua = lua..'target.think = display.newImage("sprites/thinks.png")\ntarget.think:scale(0.3, 0.3)\ntarget.think.x=CENTER_X+target.x+target.width/2+40\ntarget.think.y=CENTER_Y+target.y-target.height/2-80\ntarget.think.text = display.newText('..arg1..', 0, 0, 150, 100, native.systemFont, 25)\ntarget.think.text:setFillColor(0)\nlocal _mover = timer.performWithDelay(0, function()\ntarget.think.x=CENTER_X+target.x+target.width/2+40\ntarget.think.y=CENTER_Y+target.y-target.height/2-80\ntarget.think.text.x = target.think.x\ntarget.think.text.y = target.think.y\ntarget.think:toFront()\ntarget.think.text:toFront()\nend, -1)\ntimer.performWithDelay('..arg2..' * 1000, function()\ntimer.cancel(_mover)\ntarget.think.text:removeSelf()\ntarget.think:removeSelf()\nend)'
        end_pcall()
    elseif nameBlock == 'sayTime' then
        add_pcall()
        local arg1 = make_all_formulas(infoBlock[2][1], object)
        local arg2 = make_all_formulas(infoBlock[2][2], object)
        lua = lua..'target.think = display.newImage("sprites/says.png")\ntarget.think:scale(0.3, 0.3)\ntarget.think.x=CENTER_X+target.x+target.width/2+40\ntarget.think.y=CENTER_Y+target.y-target.height/2-80\ntarget.think.text = display.newText('..arg1..', 0, 0, 150, 100, native.systemFont, 25)\ntarget.think.text:setFillColor(0)\nlocal _mover = timer.performWithDelay(0, function()\ntarget.think.x=CENTER_X+target.x+target.width/2+40\ntarget.think.y=CENTER_Y+target.y-target.height/2-80\ntarget.think.text.x = target.think.x\ntarget.think.text.y = target.think.y\ntarget.think:toFront()\ntarget.think.text:toFront()\nend, -1)\ntimer.performWithDelay('..arg2..' * 1000, function()\ntimer.cancel(_mover)\ntarget.think.text:removeSelf()\ntarget.think:removeSelf()\nend)'
        end_pcall()
    end
--"blackRectTop.x, blackRectTop.y = "..(options.orientation=="vertical" and ("0,-"..tostring(options.displayHeight/2)) or ("-"..tostring(options.displayHeight/2)..",0" ))..")\nblackRectTop.anchor"..(options.orientation=="vertical" and "Y" or "X").." = 1\nblackRectBottom.x, blackRectBottom.y = "..(options.orientation=="vertical" and ("0,"..tostring(options.displayHeight/2)) or (tostring(options.displayHeight/2)..",0" ))..")\nblackRectBottom.anchor"..(options.orientation=="vertical" and "Y" or "X").." = 0"


--"local function broadcastFunction(nameFunction)\nlocal key = 'object_"..(infoBlock[2][1][2]==nil and obj_id or infoBlock[2][1][2]).."'\nlocal value = objects[key]\nfor i=1, #events_function[key][nameFunction] do\nevents_function[key][nameFunction][i](value)\nfor i2=1, #value.clones do\nevents_function[key][nameFunction][i](value.clones[i2])\nend\nend\nend\nbroadcastFunction('fun_"..infoBlock[2][2][2].."')"
    return lua
end
end)

lua = lua.."\n"..make_block(block, 'target', obj_images, obj_sounds)
                    -- конец
                end

            end
            
            if (#blocks~=0) then
                if (oldEventName=="start") then
                    lua = lua..'\nend)\nend\n\n'
                elseif (oldEventName=="changeBackground" or oldEventName=="collision") then
                    lua = lua..'\nend\nend\n\n'
                else
                    lua = lua..'\nend\n\n'
                end
            end
            lua = lua.."\nfor i=1, #events_start do\n    events_start[i](object_"..obj_id..")\nend\n"
            end
        end
        lua = lua.."\nend"
        
    end
    lua = lua.."\nscene_"..scenes[1][2].."()\n"
    lua = lua.."local function touchScreenGame(event)\nif (event.phase=='began') then\nlocal newIdTouch=globalConstants.touchId+1\nglobalConstants.touchId = newIdTouch\nglobalConstants.keysTouch['touch_'..newIdTouch], globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = event.id, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale, true\nglobalConstants.isTouch, globalConstants.touchX, globalConstants.touchY = true, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\nfor key, value in pairs(objects) do\nfor i=1, #events_touchScreen[key] do\nevents_touchScreen[key][i](value)\nfor i2=1, #value.clones do\nevents_touchScreen[key][i](value.clones[i2])\nend\nend\nend\nelseif (event.phase=='moved') then\nglobalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id] = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\nglobalConstants.touchX, globalConstants.touchY = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\nelse\nglobalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = nil, nil, nil\nif (pocketupFuns.getCountTouch(globalConstants.touchsXId)==0) then\nglobalConstants.keysTouch = {}\nglobalConstants.isTouch=false\nend\nend\nend"
    lua = lua.."\nRuntime:addEventListener('touch', touchScreenGame)\n\n"

--[[
local newIdTouch=globalConstants.touchId+1\nglobalConstants.touchId = newIdTouch\nglobalConstants.keysTouch['touch_'..newIdTouch], globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = event.id, event.x, event.y, true
globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = event.x, event.y
globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = nil, nil, nil\nif (#globalConstants.isTouchsId==0) then\nglobalConstants.keysTouch = {}\nglobalConstants.isTouch = nil\nend
]]
    lua = lua.."\nfunction exitGame()\nphysics.setDrawMode('normal')\nsystem.deactivate('multitouch')\nphysics.stop()\nRuntime:removeEventListener('touch', touchScreenGame)\nshowOldScene()\nend"
    lua = lua.."\nfunction deleteScene()\norientation.lock('portrait')\nphysics.setDrawMode('normal')\nremoveAllObjects()\ntimer.cancelAll()\ndisplay.remove(mainGroup)\nfor key, value in pairs(playingSounds) do\naudio.stop(playingSounds[key])\naudio.dispose(playSounds[key])\nend\nplaySounds = {}\nplayingSounds = {}\nend"
    lua = lua.."\nfunction funBackListener(event)\nif ((event.keyName=='back' or event.keyName=='deleteBack') and event.phase=='up') then\nRuntime:removeEventListener('key',funBackListener)\naudio.stop({channel=1})\ndeleteScene()\nexitGame()\nend\nend\nRuntime:addEventListener('key', funBackListener)"
    --lua = lua.."\nphysics.setDrawMode('hybrid')\n"
    print(lua)
    noremoveAllObjects()
    local f, error_msg = loadstring(lua)
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
        error("Ошибка:".. error_msg .. " строка:" .. line_number)
      end
end

