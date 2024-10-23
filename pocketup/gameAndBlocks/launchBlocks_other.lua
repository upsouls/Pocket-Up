
timer.new = timer.performWithDelay
timer.GameNew = function (time, rep, listener)
    return timer.new(time, listener, rep)
end
timer.GameNew2 = function (time, rep, onComplete, listener)
    local i = 0
    return timer.new(time, function()
        listener()
        i = i+1
        if (i==rep) then
            onComplete()
        end
    end, rep)
end
local max_fors = 0
local nameBlock
local lua
local add_pcall = function ()
    lua = lua..'\npcall(function()\n'
end
local end_pcall = function ()
    lua = lua..'\nend)\n'
end

local isEvent = {
    start=true, touchObject=true, touchScreen=true, ["function"]=true, whenTheTruth=true, collision=true, changeBackground=true, startClone=true,
    movedObject=true, onTouchObject=true, movedScreen=true, onTouchScreen=true, touchBack=true, endedCollision=true,
}

local function make_block(infoBlock, object, images, sounds, index, blocks, level_blocks, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options)
    if infoBlock[3] == 'off' then
        return ''
    end
    nameBlock = infoBlock[1]--args[i] = make_all_formulas(infoBlock[2][i], object)
    lua = ''
    local waitInsert = function (time)
        local endWait = true
        for i = index+1, #blocks, 1 do
            if blocks[i][3] ~= 'off' then
                local block = blocks[i]
                local nameBlock = block[1]
                if block[3] == 'off' then
                    nameBlock = ''
                end
                local _break = false
                if nameBlock == 'wait' or nameBlock == 'transitionPosition' and
                level_blocks[scene_id][obj_id][index] == level_blocks[scene_id][obj_id][i] then
                    _break = true
                    endWait = false
                end
                local table_end = {'endIf','endTimer','endRepeat','ifElse (2)',
                    'endFor','endForeach','endCycleForever','endWait'}
                local _break = false
                for i2, value in ipairs(table_end) do
                    if nameBlock == value and level_blocks[scene_id][obj_id][index] == level_blocks[scene_id][obj_id][i] then
                        _break = true
                        break
                    end
                end
                if _break then
                    break
                end
            end
        end
        local oldType = wait_type
        if wait_type == 'wait' then
            lua = lua..
            "local name = 'wait"..index.."_"..obj_id.."_"..scene_id.."_'.. Timers_max\
            if not Timers[name] then\
                timer.new("..time.."*1000, function()\
                    Timers[name] = nil\
                end)\
            Timers[name] = timer.new("..time.."*1000, function()\
                    if not (target ~= nil and target.x ~= nil) then\
                        pcall(function() timer.cancel(Timers[name]) end)\
                        return true\
                    end"
            elseif wait_type == 'repeat' then
            lua = lua..
            "local name = 'wait"..index.."_"..obj_id.."_"..scene_id.."_'.. Timers_max\
            if not Timers[name] then\
                pcall(function() timer.pause(_repeat) end)\
                timer.new("..time.."*1000, function()\
                    Timers[name] = nil\
                    "..(endWait and "pcall(function() timer.resume(_repeat) end)" or "").."\
                end)\
            Timers[name] = timer.new("..time.."*1000, function()\
                    if not (target ~= nil and target.x ~= nil) then\
                        pcall(function() timer.cancel(Timers[name]) end)\
                        return true\
                    end"
            wait_type = 'wait'
        end
        local numbers = wait_table['block:'..index] or 1
        wait_end = true
        if level_blocks[scene_id][obj_id][index] == 1 then
            wait_table.event = wait_table.event + 1
        else
            for i = index+1, #blocks, 1 do
                if blocks[i][3] ~= 'off' then
                    local block = blocks[i]
                    local nameBlock = block[1]
                    if block[3] == 'off' then
                        nameBlock = ''
                    end
                    if nameBlock == 'wait' or nameBlock == 'transitionPosition' and
                    level_blocks[scene_id][obj_id][index] == level_blocks[scene_id][obj_id][i] then
                        numbers = numbers + 1
                        wait_table['block:'..i] = numbers
                        wait_type = oldType
                    end
                    local table_end = {'endIf','endTimer','endRepeat','ifElse (2)',
                    'endFor','endForeach','endCycleForever','endWait'}
                    local _break = false
                    for i2, value in ipairs(table_end) do
                        if nameBlock == value and level_blocks[scene_id][obj_id][index] == level_blocks[scene_id][obj_id][i] then
                            wait_table['block:'..i] = numbers
                            wait_end = false
                            wait_table['_ends'] = wait_table['_ends'] + 1
                            _break = true
                            break
                        end
                    end
                    if _break then
                        break
                    end
                end
            end
        end
    end
    if nameBlock == '' then
    elseif nameBlock == 'wait' then
        local time = make_all_formulas(infoBlock[2][1], object)
        waitInsert(time)
    elseif nameBlock == 'setSize' or nameBlock == 'editSize' then
        local formula = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..'target.property_size = ('..(nameBlock=='setSize' and '' or 'target.property_size)+(')..formula..')\ntarget.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)'
        lua = lua.."\nif (target.parent_obj==target) then\nlocal objectsTable = plugins.json.decode(funsP['получить сохранение']('"..scene_path.."/objects'))\nif (objectsTable[target.infoSaveVisPos][3]==nil) then\nobjectsTable[target.infoSaveVisPos][3] = {}\nend\nobjectsTable[target.infoSaveVisPos][3].size = target.property_size/100\nfunsP['записать сохранение']('"..scene_path.."/objects', plugins.json.encode(objectsTable))\nend"
        lua = lua.."\ntarget:physicsReload()"
        end_pcall()
    elseif nameBlock == 'setPosition' then
        local x = make_all_formulas(infoBlock[2][1], object)
        local y = make_all_formulas(infoBlock[2][2], object)
        add_pcall()
        lua = lua..'target.x = '..x..'\n'..'target.y = -('..y..')\n'
        end_pcall()
    elseif nameBlock == 'transitionPosition' then
        local time = make_all_formulas(infoBlock[2][1], object)
        local x = make_all_formulas(infoBlock[2][2], object)
        local y = make_all_formulas(infoBlock[2][3], object)

        add_pcall()
        lua = lua..
        "transition.to(target, {time="..time.."*1000,\
        x="..x..", y= -"..y.."})"
        end_pcall()
        lua = lua.."\n"
        waitInsert(time)
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
    -- elseif nameBlock == 'lua' then
    --     local code = make_all_formulas(infoBlock[2][1], object)
    --     add_pcall()
    --     lua = lua..'loadstring('..code..')()'..'\n'
    --     end_pcall()
    elseif nameBlock == 'timer' then
        local rep = make_all_formulas(infoBlock[2][1], object)
        local time = make_all_formulas(infoBlock[2][2], object)
        lua = lua .. 'local _repeat\n'
        add_pcall()
        lua = lua ..
'local name = \'Timer'..index..'\'..\'_\'..Timers_max\
if not Timers[name] then\
timer.new(('..time..'*1000)*'..rep..', function()\
Timers[name] = nil\
end)\
Timers[name] = timer.GameNew(('..time..')*1000, '..rep..', function()\nif not (target ~= nil and target.x ~= nil) then\npcall(function() timer.cancel(Timers[name]) end)\nreturn true\nend\n'
    elseif nameBlock == 'endTimer' then
                if wait_table['block:'..index] then
            for i = 1, wait_table['block:'..index], 1 do
                lua = lua .. 'end)\nend\n'
            end
        end
        lua = lua..'end)_repeat = Timers[name]\nend'
        end_pcall()
    elseif nameBlock == 'editRotateLeft' then
        local rotate = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..'target:rotate(-'..rotate..')\n'
        lua = lua.."\nif (target.parent_obj==target) then\nlocal objectsTable = plugins.json.decode(funsP['получить сохранение']('"..scene_path.."/objects'))\nif (objectsTable[target.infoSaveVisPos][3]==nil) then\nobjectsTable[target.infoSaveVisPos][3] = {}\nend\nobjectsTable[target.infoSaveVisPos][3].rotation = target.rotation\nfunsP['записать сохранение']('"..scene_path.."/objects', plugins.json.encode(objectsTable))\nend"
        end_pcall()
    elseif nameBlock == 'editRotateRight' then
        local rotate = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..'target:rotate('..rotate..')\n'
        lua = lua.."\nif (target.parent_obj==target) then\nlocal objectsTable = plugins.json.decode(funsP['получить сохранение']('"..scene_path.."/objects'))\nif (objectsTable[target.infoSaveVisPos][3]==nil) then\nobjectsTable[target.infoSaveVisPos][3] = {}\nend\nobjectsTable[target.infoSaveVisPos][3].rotation = target.rotation\nfunsP['записать сохранение']('"..scene_path.."/objects', plugins.json.encode(objectsTable))\nend"
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
        lua = lua.."\nif (target.parent_obj==target) then\nlocal objectsTable = plugins.json.decode(funsP['получить сохранение']('"..scene_path.."/objects'))\nif (objectsTable[target.infoSaveVisPos][3]==nil) then\nobjectsTable[target.infoSaveVisPos][3] = {}\nend\nobjectsTable[target.infoSaveVisPos][3].rotation = target.rotation\nfunsP['записать сохранение']('"..scene_path.."/objects', plugins.json.encode(objectsTable))\nend"
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
        if wait_table['block:'..index] then
            for i = 1, wait_table['block:'..index], 1 do
                wait_table['_ends'] = wait_table['_ends'] - 1
                lua = lua .. 'end)\nend\n'
            end
        end
        lua = lua..'else\n'
    elseif nameBlock == 'endIf' then
        if wait_table['block:'..index] then
            for i = 1, wait_table['block:'..index], 1 do
                wait_table['_ends'] = wait_table['_ends'] - 1
                lua = lua .. 'end)\nend\n'
            end
        end
        lua = lua..'end\n'
        end_pcall()
    elseif nameBlock == 'repeat' then
        wait_type = 'repeat'
        local rep = make_all_formulas(infoBlock[2][1], object)
        lua = lua .. 'local _repeat\n'
        add_pcall()
        lua = lua..'_repeat = timer.GameNew(0,'..rep..', function()\nif not (target ~= nil and target.x ~= nil) then\npcall(function() timer.cancel(_repeat) end)\nreturn true\nend\n'
    elseif nameBlock == 'endRepeat' then
                if wait_table['block:'..index] then
            for i = 1, wait_table['block:'..index], 1 do
                lua = lua .. 'end)\nend\n'
            end
        end
        lua = lua..'end)\n'
        end_pcall()
    elseif nameBlock == 'setVariable' and infoBlock[2][1][2]~=nil then
        local value = make_all_formulas(infoBlock[2][2], object)
        add_pcall()
        if infoBlock[2][1][1] == 'globalVariable' then
            lua = lua..'var_'..infoBlock[2][1][2]..' = '..value..'\n'
            lua = lua..'if varText_'..infoBlock[2][1][2]..' then\n varText_'..infoBlock[2][1][2]..'.text = type(var_'..infoBlock[2][1][2]..')=="boolean" and (var_'..infoBlock[2][1][2]..' and app.words[373] or app.words[374]) or type(var_'..infoBlock[2][1][2]..')=="table" and encodeList(var_'..infoBlock[2][1][2]..') or var_'..infoBlock[2][1][2]..'\nend'
        else
            lua = lua..'target.var_'..infoBlock[2][1][2]..' = '..value..'\n'
            lua = lua..'if target.varText_'..infoBlock[2][1][2]..' then\n target.varText_'..infoBlock[2][1][2]..'.text = type(target.var_'..infoBlock[2][1][2]..')=="boolean" and (target.var_'..infoBlock[2][1][2]..' and app.words[373] or app.words[374]) or type(target.var_'..infoBlock[2][1][2]..')=="table" and encodeList(target.var_'..infoBlock[2][1][2]..') or target.var_'..infoBlock[2][1][2]..'\nend'
        end
        end_pcall()
    elseif nameBlock == 'editVariable' and infoBlock[2][1][2]~=nil then
        local value = make_all_formulas(infoBlock[2][2], object)
        add_pcall()
        if infoBlock[2][1][1] == 'globalVariable' then
            lua = lua..'var_'..infoBlock[2][1][2]..' = type(var_'..infoBlock[2][1][2]..')=="boolean" and (var_'..infoBlock[2][1][2]..' and app.words[373] or app.words[374]) or type(var_'..infoBlock[2][1][2]..')=="table" and encodeList(var_'..infoBlock[2][1][2]..') or var_'..infoBlock[2][1][2]..'+('..make_all_formulas(infoBlock[2][2], object)..')\n'
            lua = lua..'if varText_'..infoBlock[2][1][2]..' then\n varText_'..infoBlock[2][1][2]..'.text = var_'..infoBlock[2][1][2]..'\nend'
        else
            lua = lua..'target.var_'..infoBlock[2][1][2]..' = target.var_'..infoBlock[2][1][2]..' + '..value..'\n'
            lua = lua..'if target.varText_'..infoBlock[2][1][2]..' then\n target.varText_'..infoBlock[2][1][2]..'.text = type(target.var_'..infoBlock[2][1][2]..')=="boolean" and (target.var_'..infoBlock[2][1][2]..' and app.words[373] or app.words[374]) or type(target.var_'..infoBlock[2][1][2]..')=="table" and encodeList(target.var_'..infoBlock[2][1][2]..') or target.var_'..infoBlock[2][1][2]..'\nend'
        end
        end_pcall()
    elseif nameBlock == 'openLink' then
        local link = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..'system.openURL('..link..')\n'
        end_pcall()
    elseif nameBlock == 'cycleForever' then
        lua = lua .. 'local _repeat\n'
        wait_type = 'repeat'
        
        add_pcall()
        lua = lua..'_repeat = timer.new(0, function()\nif not (target ~= nil and target.x ~= nil) then\npcall(function() timer.cancel(_repeat) end)\nreturn true\nend\n'
    elseif nameBlock == 'endCycleForever' then
        if wait_table['block:'..index] then
            for i = 1, wait_table['block:'..index], 1 do
                lua = lua .. 'end)\nend\n'
            end
        end
        lua = lua..'end, 0)\n'
        end_pcall()
    elseif nameBlock == 'repeatIsTrue' then
        wait_type = 'repeat'
        local condition = make_all_formulas(infoBlock[2][1], object)
        lua = lua .. 'local _repeat\n'
        add_pcall()
        lua = lua..[[
local repeatIsTrue
_repeat = repeatIsTrue
repeatIsTrue = timer.GameNew(0,0, function()
if not (]]..condition..[[) then
timer.cancel(repeatIsTrue)
return true
end
if not (target ~= nil and target.x ~= nil) then
pcall(function() timer.cancel(_repeat) end)
return true
end]]
    elseif nameBlock == 'setImageToId' and #images>0 then
        local image = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua.."local numberImage = ("..image.."-1)-math.floor((".. image.."-1)/"..#images..")*"..#images.."+1"
        lua = lua..'\ntarget.numberImage = numberImage\ntarget.image_path = \''..app.idProject..'/scene_'..scene_id..'/object_'..obj_id..'/image_\'..listImages[numberImage]..\'.png\'\n'
        lua = lua..'target.fill = {type = \'image\', filename = \''..app.idProject..'/scene_'..scene_id..'/object_'..obj_id..'/image_\'..listImages[numberImage]..\'.png\', baseDir = system.DocumentsDirectory}\n'
        lua = lua.."target.origWidth, target.origHeight = getImageProperties(target.image_path, system.DocumentsDirectory)\ntarget.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)\n"
        lua = lua.."local r = pocketupFuns.sin(target.property_color-22+56)/2+0.724\nlocal g = pocketupFuns.cos(target.property_color+56)/2+0.724\nlocal b = pocketupFuns.sin(target.property_color+22+56)/2+0.724\ntarget:setFillColor(r,g,b)\n"
        lua = lua.."if (target.property_color~=100) then\ntarget.fill.effect = 'filter.brightness'\ntarget.fill.effect.intensity = (target.property_brightness)/100-1\nend\n"
        if (o==1) then
            lua = lua.."broadcastChangeBackground(listImages[numberImage])\n"
        end
        lua = lua.."\nif (target.parent_obj==target) then\nlocal objectsTable = plugins.json.decode(funsP['получить сохранение']('"..scene_path.."/objects'))\nif (objectsTable[target.infoSaveVisPos][3]==nil) then\nobjectsTable[target.infoSaveVisPos][3] = {}\nend\nobjectsTable[target.infoSaveVisPos][3].path = target.image_path\nfunsP['записать сохранение']('"..scene_path.."/objects', plugins.json.encode(objectsTable))\nend"
        end_pcall()
    elseif nameBlock == 'clone' then
        --add_pcall()
        if (infoBlock[2][1][2]~=nil) then
            lua = lua.."\nlocal target = objects['object_"..infoBlock[2][1][2].."']"
        end
        lua = lua.."\nlocal myClone\nif (target.parent_obj.countImages>0) then"
        lua = lua.."\nmyClone = display.newImage(target.image_path, system.DocumentsDirectory, target.x, target.y)"
        lua = lua.."\nmyClone.image_path = target.image_path\nfor k, v in pairs(target.parent_obj.namesVars) do\nmyClone[v] = 0\nend\nfor k, v in pairs(target.parent_obj.namesLists) do\nmyClone[v] = {}\nend"
        lua = lua.."\nelse"
        lua = lua.."\nmyClone = display.newImage('images/notVisible.png', target.x, target.y)"
        lua = lua.."\nend"
        lua = lua.."\ntarget.group:insert(myClone)\nmyClone.group = target.group"
        lua = lua.."\nmyClone:addEventListener('touch', function(event)\nif (event.phase=='began') then\nlocal newIdTouch=globalConstants.touchId+1\nglobalConstants.touchId = newIdTouch\nglobalConstants.keysTouch['touch_'..newIdTouch], globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = event.id, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale, true\nglobalConstants.isTouch, globalConstants.touchX, globalConstants.touchY = true, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\ndisplay.getCurrentStage():setFocus(event.target, event.id)\nevent.target.isTouch = true\nfor key, value in pairs(objects) do\nfor i=1, #events_touchScreen[key] do\nevents_touchScreen[key][i](value)\nfor i2=1, #value.clones do\nevents_touchScreen[key][i](value.clones[i2])\nend\nend\nend\nfor i=1, #myClone.parent_obj.events_touchObject do\nmyClone.parent_obj.events_touchObject[i](event.target)\nend\nelseif (event.phase=='moved') then\nglobalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id] = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\nglobalConstants.touchX, globalConstants.touchY = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\nfor key, value in pairs(objects) do\nfor i=1, #events_movedScreen[key] do\nevents_movedScreen[key][i](value)\nfor i2=1, #value.clones do\nevents_movedScreen[key][i](value.clones[i2])\nend\nend\nend\nfor i=1, #myClone.parent_obj.events_movedObject do\nmyClone.parent_obj.events_movedObject[i](event.target)\nend\nelse\ndisplay.getCurrentStage():setFocus(event.target, nil)\nevent.target.isTouch = nil\nglobalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = nil, nil, nil\nif (pocketupFuns.getCountTouch(globalConstants.isTouchsId)==0) then\nglobalConstants.keysTouch = {}\nglobalConstants.isTouch = false\nend\nfor key, value in pairs(objects) do\nfor i=1, #events_onTouchScreen[key] do\nevents_onTouchScreen[key][i](value)\nfor i2=1, #value.clones do\nevents_onTouchScreen[key][i](value.clones[i2])\nend\nend\nend\nfor i=1, #myClone.parent_obj.events_onTouchObject do\nmyClone.parent_obj.events_onTouchObject[i](event.target)\nend\nend\nreturn(true)\nend)"
        lua = lua.."\nmyClone.xScale, myClone.yScale, myClone.alpha, myClone.rotation, myClone.numberImage, myClone.parent_obj = target.xScale, target.yScale, target.alpha, target.rotation, target.numberImage, target.parent_obj"
        lua = lua.."\nmyClone.fill.effect = 'filter.brightness'\nmyClone.property_brightness = target.property_brightness\nmyClone.fill.effect.intensity = (target.property_brightness)/100-1"


        lua = lua.."\nmyClone.parent_obj = target\ntarget.parent_obj.clones[#target.parent_obj.clones+1] = myClone\nmyClone.idClone, myClone.tableVarShow, myClone.origWidth, myClone.origHeight, myClone.width, myClone.height, myClone.property_size = #target.parent_obj, {}, target.origWidth, target.origHeight, target.width, target.height, target.property_size"
        lua = lua.."\nmyClone.isVisible = target.isVisible\nmyClone.physicsReload, myClone.physicsType , myClone.physicsTable = target.physicsReload or function(ob) end, target.physicsType or 'static' , plugins.json.decode(plugins.json.encode(target.physicsTable)) or {}\nmyClone:physicsReload()"
        lua = lua.."\nmyClone.property_color = target.property_color\nlocal r = pocketupFuns.sin(target.property_color-22+56)/2+0.724\nlocal g = pocketupFuns.cos(target.property_color+56)/2+0.724\nlocal b = pocketupFuns.sin(target.property_color+22+56)/2+0.724\nmyClone:setFillColor(r,g,b)\nmyClone.touchesObjects = {}"
        lua = lua.."\ntimer.new(0, function()\nmyClone:addEventListener('collision', function(event)\nif (event.phase=='began') then\nevent.target.touchesObjects['obj_'..event.other.parent_obj.idObject] = true\ntimer.new(0, function()\nfor i=1, #myClone.parent_obj.events_collision do\nmyClone.parent_obj.events_collision[i](event.target, event.other.parent_obj.nameObject)\nend\nend)\nelseif (event.phase=='ended') then\nevent.target.touchesObjects['obj_'..event.other.parent_obj.idObject] = nil\ntimer.new(0, function()\nfor i=1, #myClone.parent_obj.events_endedCollision do\nmyClone.parent_obj.events_endedCollision[i](event.target, event.other.parent_obj.nameObject)\nend\nend)\nend\nend)"
        lua = lua.."\nmyClone.gravityScale, myClone.isSensor = target.gravityScale, target.isSensor"
        lua = lua.."\ntimer.new(0, function()\nfor i=1, #myClone.parent_obj.events_startClone do\nmyClone.parent_obj.events_startClone[i](myClone)\nend\n"
        lua = lua.."\nend) end)"
        --end_pcall()
    elseif nameBlock == 'deleteClone' then
        add_pcall()
        lua = lua.."if (target) then\ntable.remove(target.parent_obj.clones, target.idClone)\nfor i=1, #target.parent_obj.clones do\ntarget.parent_obj.clones[i].idClone = i\nend\ndisplay.remove(target)\n\nend\n"
        end_pcall()
        add_pcall()
        lua = lua.."if true then pcall(function() timer.cancel(_repeat) end) return true end"
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
        lua = lua..'playSounds['..infoBlock[2][1][2]..'] = audio.loadSound(\''..obj_path..'/sound_'..infoBlock[2][1][2]..'.mp3\', system.DocumentsDirectory)\n'
        lua = lua..'end\naudio.stop(playingSounds['..infoBlock[2][1][2]..'])\n'
        lua = lua..'playingSounds['..infoBlock[2][1][2]..'] = audio.play(playSounds['.. infoBlock[2][1][2]..'])'
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
        if (infoBlock[2][3][2]~=nil) then
            if infoBlock[2][3][1] == 'globalVariable' then
                lua = lua..'var_'..infoBlock[2][3][2]..' = i'..max_fors..'\n'
            else
                lua = lua..'target.var_'..infoBlock[2][3][2]..' = i'..max_fors..'\n'
            end
        end
    elseif nameBlock == 'endFor' then
        if wait_table['block:'..index] then
            for i = 1, wait_table['block:'..index], 1 do
                for i = 1, wait_table['block:'..index], 1 do
                    lua = lua .. 'end)\nend\n'
                end
            end
        end
        lua = lua..'end'
        end_pcall()
    elseif (nameBlock == "addBody") then
        add_pcall()
        if (infoBlock[2][1][2]~="noPhysic") then
        --    lua = lua..'local imageOutline = graphics.newOutline(10, target.image_path, system.DocumentsDirectory)\n'
            lua = lua..'target.physicsTable = {outline = graphics.newOutline(10, target.image_path, system.DocumentsDirectory), density=3, friction=0.3, bounce=0.3}\ntarget.physicsType = \''..infoBlock[2][1][2]..'\'\n'
            lua = lua..'target.physicsReload = function(target)\nlocal oldTypeRotation = target.isFixedRotation\nplugins.physics.removeBody(target)\n'
            lua = lua.."plugins.physics.addBody(target, target.physicsType , target.physicsTable)\ntarget.isFixedRotation = oldTypeRotation\nend"
            lua = lua..'\ntarget:physicsReload()'
            lua = lua.."\ntarget:addEventListener('collision', function(event)\nif (event.phase=='began') then\nevent.target.touchesObjects['obj_'..event.other.parent_obj.idObject] = true\ntimer.new(0, function()\nfor i=1, #events_collision do\nevents_collision[i](event.target, event.other.parent_obj.nameObject)\nend\nend)\nelseif (event.phase=='ended') then\nevent.target.touchesObjects['obj_'..event.other.parent_obj.idObject] = nil\ntimer.new(0, function()\nfor i=1, #events_endedCollision do\nevents_endedCollision[i](event.target, event.other.parent_obj.nameObject)\nend\nend)\nend\nend)"
        else
            lua = lua.."plugins.physics.removeBody(target)\ntarget.physicsReload = nil\ntarget.touchesObjects = {}"
        end
        end_pcall()
    elseif nameBlock == 'setGravityAllObjects' then
        local x = make_all_formulas(infoBlock[2][1], object)
        local y = make_all_formulas(infoBlock[2][2], object)
        add_pcall()
        lua = lua..'plugins.physics.setGravity('..x..',-'..y..' )'
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
            lua = lua..'target.x, target.y = math.random(-'..(tostring(options.orientation == "vertical" and options.displayWidth/2 or options.displayHeight/2))..','..(tostring(options.orientation == "vertical" and options.displayWidth/2 or options.displayHeight/2))..'), math.random(-'..tostring(options.orientation == "vertical" and options.displayHeight/2 or options.displayWidth/2)..','..tostring(options.orientation == "vertical" and options.displayHeight/2 or options.displayWidth/2)..')'
        else
            lua = lua..'local object = objects[\'object_'..infoBlock[2][1][2]..'\']\ntarget.x, target.y = object.x, object.y'
        end
        end_pcall()
    elseif nameBlock == 'setRotateToObject' and infoBlock[2][1][2]~=nil then -- ["setRotateToObject",[["objects",7]],"on"]
        add_pcall()
        lua = lua..'if ( objects[\'object_'..infoBlock[2][1][2]..'\']~=nil) then\ntarget.rotation = pocketupFuns.atan2(objects[\'object_'..infoBlock[2][1][2]..'\'].x - target.x, target.y - objects[\'object_'..infoBlock[2][1][2]..'\'].y)\nend'
        lua = lua.."\nif (target.parent_obj==target) then\nlocal objectsTable = plugins.json.decode(funsP['получить сохранение']('"..scene_path.."/objects'))\nif (objectsTable[target.infoSaveVisPos][3]==nil) then\nobjectsTable[target.infoSaveVisPos][3] = {}\nend\nobjectsTable[target.infoSaveVisPos][3].rotation = target.rotation\nfunsP['записать сохранение']('"..scene_path.."/objects', plugins.json.encode(objectsTable))\nend"
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
            lua = lua..'\ntarget.numberImage = newIdImage\ntarget.image_path = \''..app.idProject..'/scene_'..scene_id..'/object_'..obj_id..'/image_'..image..'.png\'\n'
            lua = lua..'target.fill = {type = \'image\', filename = \''..app.idProject..'/scene_'..scene_id..'/object_'..obj_id..'/image_'..image..'.png\', baseDir = system.DocumentsDirectory}\n'
            lua = lua.."target.origWidth, target.origHeight = getImageProperties(target.image_path, system.DocumentsDirectory)\ntarget.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)\n"
            lua = lua.."local r = pocketupFuns.sin(target.property_color-22+56)/2+0.724\nlocal g = pocketupFuns.cos(target.property_color+56)/2+0.724\nlocal b = pocketupFuns.sin(target.property_color+22+56)/2+0.724\ntarget:setFillColor(r,g,b)\n"
            lua = lua.."if (target.property_color~=100) then\ntarget.fill.effect = 'filter.brightness'\ntarget.fill.effect.intensity = (target.property_brightness)/100-1\nend\n"
            if (o==1) then
                lua = lua.."broadcastChangeBackground(listImages[numberImage])\n"
            end
            lua = lua.."end\n"
            lua = lua.."\nif (target.parent_obj==target) then\nlocal objectsTable = plugins.json.decode(funsP['получить сохранение']('"..scene_path.."/objects'))\nif (objectsTable[target.infoSaveVisPos][3]==nil) then\nobjectsTable[target.infoSaveVisPos][3] = {}\nend\nobjectsTable[target.infoSaveVisPos][3].path = target.image_path\nfunsP['записать сохранение']('"..scene_path.."/objects', plugins.json.encode(objectsTable))\nend"
            end_pcall()
        end
    elseif nameBlock == "nextImage" and #images>1 then
        add_pcall()
        lua = lua.."target.numberImage = target.numberImage==#listImages and 1 or target.numberImage+1\ntarget.image_path='"..app.idProject.."/scene_"..scene_id.."/object_"..obj_id.."/image_'..listImages[target.numberImage]..'.png'\n"
        lua = lua..'target.fill = {type = \'image\', filename = \''..app.idProject..'/scene_'..scene_id..'/object_'..obj_id..'/image_\'..listImages[target.numberImage]..\'.png\', baseDir = system.DocumentsDirectory}\n'
        lua = lua.."target.origWidth, target.origHeight = getImageProperties(target.image_path, system.DocumentsDirectory)\ntarget.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)\n"
        lua = lua.."local r = pocketupFuns.sin(target.property_color-22+56)/2+0.724\nlocal g = pocketupFuns.cos(target.property_color+56)/2+0.724\nlocal b = pocketupFuns.sin(target.property_color+22+56)/2+0.724\ntarget:setFillColor(r,g,b)\n"
        lua = lua.."if (target.property_color~=100) then\ntarget.fill.effect = 'filter.brightness'\ntarget.fill.effect.intensity = (target.property_brightness)/100-1\nend\n"
        lua = lua.."\nif (target.parent_obj==target) then\nlocal objectsTable = plugins.json.decode(funsP['получить сохранение']('"..scene_path.."/objects'))\nif (objectsTable[target.infoSaveVisPos][3]==nil) then\nobjectsTable[target.infoSaveVisPos][3] = {}\nend\nobjectsTable[target.infoSaveVisPos][3].path = target.image_path\nfunsP['записать сохранение']('"..scene_path.."/objects', plugins.json.encode(objectsTable))\nend"
        end_pcall()
    elseif nameBlock == "previousImage" and #images>1 then
        add_pcall()
        lua = lua.."target.numberImage = target.numberImage==1 and #listImages or target.numberImage-1\ntarget.image_path='"..app.idProject.."/scene_"..scene_id.."/object_"..obj_id.."/image_'..listImages[target.numberImage]..'.png'\n"
        lua = lua..'target.fill = {type = \'image\', filename = \''..app.idProject..'/scene_'..scene_id..'/object_'..obj_id..'/image_\'..listImages[target.numberImage]..\'.png\', baseDir = system.DocumentsDirectory}\n'
        lua = lua.."target.origWidth, target.origHeight = getImageProperties(target.image_path, system.DocumentsDirectory)\ntarget.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)\n"
        lua = lua.."local r = pocketupFuns.sin(target.property_color-22+56)/2+0.724\nlocal g = pocketupFuns.cos(target.property_color+56)/2+0.724\nlocal b = pocketupFuns.sin(target.property_color+22+56)/2+0.724\ntarget:setFillColor(r,g,b)\n"
        lua = lua.."if (target.property_color~=100) then\ntarget.fill.effect = 'filter.brightness'\ntarget.fill.effect.intensity = (target.property_brightness)/100-1\nend\n"
        lua = lua.."\nif (target.parent_obj==target) then\nlocal objectsTable = plugins.json.decode(funsP['получить сохранение']('"..scene_path.."/objects'))\nif (objectsTable[target.infoSaveVisPos][3]==nil) then\nobjectsTable[target.infoSaveVisPos][3] = {}\nend\nobjectsTable[target.infoSaveVisPos][3].path = target.image_path\nfunsP['записать сохранение']('"..scene_path.."/objects', plugins.json.encode(objectsTable))\nend"
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
            GL_ZERO=0,GL_ONE=1,GL_DST_COLOR=774,GL_ONE_MINUS_DST_COLOR=775,GL_SRC_ALPHA=770,GL_ONE_MINUS_SRC_ALPHA=771,GL_DST_ALPHA=772,GL_ONE_MINUS_DST_ALPHA=773,GL_SRC_ALPHA_SATURATE=776,GL_SRC_COLOR=768,GL_ONE_MINUS_SRC_COLOR=769,SRC_COLOR=768
        }
        add_pcall()
        lua = lua.."local startRgb = utils.hexToRgb("..make_all_formulas(infoBlock[2][23], object)..")\nlocal startVarianceRgb = utils.hexToRgb("..make_all_formulas(infoBlock[2][24], object)..")\nlocal finishRgb = utils.hexToRgb("..make_all_formulas(infoBlock[2][25], object)..")\nfinishVarianceRgb = utils.hexToRgb("..make_all_formulas(infoBlock[2][26], object)..")\n"
        lua = lua.."if (objectsParticles["..make_all_formulas(infoBlock[2][1], object).."]~=nil) then\ndisplay.remove(objectsParticles["..make_all_formulas(infoBlock[2][1], object).."])\nend\npcall(function()\nlocal particle = display.newEmitter({\nemitterType=1,\ntextureFileName='"..obj_path.."/image_"..infoBlock[2][2][2]..".png',\nmaxParticles="..make_all_formulas(infoBlock[2][3], object)..",\nabsolutePosition="..make_all_formulas(infoBlock[2][4], object)..",\nangle="..make_all_formulas(infoBlock[2][5], object)..",\nangleVriance="..make_all_formulas(infoBlock[2][6], object)..",\nmaxRadius="..make_all_formulas(infoBlock[2][7], object)..",\nmaxRadiusariance="..make_all_formulas(infoBlock[2][8], object)..",\nminRadius="..make_all_formulas(infoBlock[2][9], object)..",\nminRadiusVariance="..make_all_formulas(infoBlock[2][10], object)..",\nrotatePerSecond="..make_all_formulas(infoBlock[2][11], object)..",\nrotatePerSecondVariance="..make_all_formulas(infoBlock[2][12], object)..",\nparticleLifespan="..make_all_formulas(infoBlock[2][13], object)..",\nparticleLifespanVariance="..make_all_formulas(infoBlock[2][14], object)..",\nstartParticleSize="..make_all_formulas(infoBlock[2][15], object)..",\nstartParticleSizeVariance="..make_all_formulas(infoBlock[2][16], object)..",\nfinishParticleSize="..make_all_formulas(infoBlock[2][17], object)..",\nfinishParticleSizeVariance="..make_all_formulas(infoBlock[2][18], object)..",\nrotationStart="..make_all_formulas(infoBlock[2][19], object)..",\nrotationStartVariance="..make_all_formulas(infoBlock[2][20], object)..",\nrotationEnd="..make_all_formulas(infoBlock[2][21], object)..",\nrotationEndVariance="..make_all_formulas(infoBlock[2][22], object)..",\nstartColorRed=startRgb[1],\nstartColorGreen=startRgb[2],\nstartColorBlue=startRgb[3]\n,\nstartColorVarianceRed=startVarianceRgb[1],\nstartColorVarianceGreen=startVarianceRgb[2],\nstartColorVarianceBlue=startVarianceRgb[3],\nfinishColorRed=finishRgb[1],\nfinishColorGreen=finishRgb[2],\nfinishColorBlue=finishRgb[3],\nfinishColorVarianceRed=finishVarianceRgb[1],\nfinishColorVarianceRed=finishVarianceRgb[2],\nfinishColorVariance=finishVarianceRgb[3],\nblendFuncSource="..idsGL[infoBlock[2][27][2]]..",\nblendFuncDestination="..idsGL[infoBlock[2][28][2]].."\n,startColorAlpha=1, finishColorAlpha=1, duration=-1\n}, system.DocumentsDirectory)\ncameraGroup:insert(particle)\nobjectsParticles["..make_all_formulas(infoBlock[2][1], object).."] = particle\nparticle.x, particle.y = 0, 0\nend)"
        end_pcall()
    elseif nameBlock=="createLinearParticle" and infoBlock[2][2][2]~=nil then
        local idsGL = {
            GL_ZERO=0,GL_ONE=1,GL_DST_COLOR=774,GL_ONE_MINUS_DST_COLOR=775,GL_SRC_ALPHA=770,GL_ONE_MINUS_SRC_ALPHA=771,GL_DST_ALPHA=772,GL_ONE_MINUS_DST_ALPHA=773,GL_SRC_ALPHA_SATURATE=776,GL_SRC_COLOR=768,GL_ONE_MINUS_SRC_COLOR=769,SRC_COLOR=768
        }
        add_pcall()
        lua = lua.."local startRgb = utils.hexToRgb("..make_all_formulas(infoBlock[2][27], object)..")\nlocal startVarianceRgb = utils.hexToRgb("..make_all_formulas(infoBlock[2][28], object)..")\nlocal finishRgb = utils.hexToRgb("..make_all_formulas(infoBlock[2][29], object)..")\nfinishVarianceRgb = utils.hexToRgb("..make_all_formulas(infoBlock[2][30], object)..")\n"
        lua = lua.."if (objectsParticles["..make_all_formulas(infoBlock[2][1], object).."]~=nil) then\ndisplay.remove(objectsParticles["..make_all_formulas(infoBlock[2][1], object).."])\nend\nlocal particle = display.newEmitter({\nemitterType=0,\ntextureFileName='"..obj_path.."/image_"..infoBlock[2][2][2]..".png'\n,maxParticles="..make_all_formulas(infoBlock[2][3], object)..",\nabsolutePosition="..make_all_formulas(infoBlock[2][4], object)..",\nangle="..make_all_formulas(infoBlock[2][5], object)..",\nangleVriance="..make_all_formulas(infoBlock[2][6], object)..",\nspeed="..make_all_formulas(infoBlock[2][7], object)..",\nspeedVariance="..make_all_formulas(infoBlock[2][8], object)..",\nsourcePositionVariancex="..make_all_formulas(infoBlock[2][9], object)..",\nsourcePositionVariancey="..make_all_formulas(infoBlock[2][10], object)..",\ngravityx="..make_all_formulas(infoBlock[2][11], object)..",\ngravityy=-"..make_all_formulas(infoBlock[2][12], object)..",\nradialAcceleration="..make_all_formulas(infoBlock[2][13], object)..",\nradialAccelVariance="..make_all_formulas(infoBlock[2][14], object)..",\ntangentialAcceleration="..make_all_formulas(infoBlock[2][15], object)..",\ntangentialAccelVariance="..make_all_formulas(infoBlock[2][16], object)..",\nparticleLifespan="..make_all_formulas(infoBlock[2][17], object)..",\nparticleLLifespanVariance="..make_all_formulas(infoBlock[2][18], object)..",\nstartParticleSize="..make_all_formulas(infoBlock[2][19], object)..",\nstartParticleSizeVariance="..make_all_formulas(infoBlock[2][20], object)..",\nfinishParticleSize="..make_all_formulas(infoBlock[2][21], object)..",\nfinishParticleSizeVariance="..make_all_formulas(infoBlock[2][22], object)..",\nrotationStart="..make_all_formulas(infoBlock[2][23], object)..",\nrotationStartVariance="..make_all_formulas(infoBlock[2][24], object)..",\nrotationEnd="..make_all_formulas(infoBlock[2][25], object)..",\nrotationEndVariance="..make_all_formulas(infoBlock[2][26], object)..",\nstartColorRed=startRgb[1],startColorGreen=startRgb[2],startColorBlue=startRgb[3],startColorVarianceRed=startVarianceRgb[1],startColorVarianceGreen=startVarianceRgb[2],startColorVarianceBlue=startVarianceRgb[3],finishColorRed=finishRgb[1],finishColorGreen=finishRgb[2],finishColorBlue=finishRgb[3],finishColorVarianceRed=finishVarianceRgb[1],finishColorVarianceGreen=finishVarianceRgb[2],finishColorVarianceBlue=finishVarianceRgb[3],blendFuncSource="..idsGL[infoBlock[2][31][2]]..",\nblendFuncDestination="..idsGL[infoBlock[2][32][2]]..",\nstartColorAlpha=1, finishColorAlpha=1, duration=-1\n}, system.DocumentsDirectory)\ncameraGroup:insert(particle)\nobjectsParticles["..make_all_formulas(infoBlock[2][1], object).."] = particle\nparticle.x, particle.y = 0, 0"
        end_pcall()
    elseif nameBlock=="setPositionParticle" then
        add_pcall()
        lua = lua.."local particle = objectsParticles["..make_all_formulas(infoBlock[2][1], object).."]\nif (particle~=nil) then\nparticle.x, particle.y = "..make_all_formulas(infoBlock[2][2], object)..", -"..make_all_formulas(infoBlock[2][3], object).."\nend"
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
            lua = lua.."local r = pocketupFuns.sin(background.property_color-22+56)/2+0.724\nlocal g = pocketupFuns.cos(background.property_color+56)/2+0.724\nlocal b = pocketupFuns.sin(background.property_color+22+56)/2+0.724\nbackground:setFillColor(r,g,b)\n"
            lua = lua.."if (background.property_color~=100) then\nbackground.fill.effect = 'filter.brightness'\nbackground.fill.effect.intensity = (background.property_brightness)/100-1\nend\n"
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
        lua = lua.."local r = pocketupFuns.sin(background.property_color-22+56)/2+0.724\nlocal g = pocketupFuns.cos(background.property_color+56)/2+0.724\nlocal b = pocketupFuns.sin(background.property_color+22+56)/2+0.724\nbackground:setFillColor(r,g,b)\n"
        lua = lua.."if (background.property_color~=100) then\nbackground.fill.effect = 'filter.brightness'\nbackground.fill.effect.intensity = (background.property_brightness)/100-1\nend\n"
        if (o==1) then
            lua = lua.."broadcastChangeBackground(listImages[numberImage])\n"
        end
        end_pcall()
    elseif nameBlock=='getLinkImage' then
        add_pcall()
        lua = lua.."local function networkListener(event)\nif (target~=nil and target.x~=nil) then\ntarget.image_path = 'objectImage_"..obj_id..".png'\ntarget.fill = {type = \'image\', filename = target.image_path, baseDir=system.TemporaryDirectory}\ntarget.origWidth, target.origHeight = getImageProperties(target.image_path, system.TemporaryDirectory)\ntarget.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)\nend\nend\nnetwork.download("..make_all_formulas(infoBlock[2][1],object)..",'GET', networkListener, 'objectImage_"..obj_id..".png', system.TemporaryDirectory)"
        end_pcall()
    elseif nameBlock == 'stamp' then
        add_pcall()
        lua = lua..'local obj = #tableFeathers+1\nlocal myObj = display.newImage(target.image_path, system.DocumentsDirectory, target.x, target.y)\ntableFeathers[obj] = myObj\nstampsGroup:insert(myObj)\n'
        lua = lua..'myObj.width, myObj.height, myObj.alpha, myObj.rotation, myObj.xScale, myObj.yScale = target.width, target.height, target.alpha, target.rotation, target.xScale, target.yScale\n'
        lua = lua.."local r = pocketupFuns.sin(target.property_color-22+56)/2+0.724\nlocal g = pocketupFuns.cos(target.property_color+56)/2+0.724\nlocal b = pocketupFuns.sin(target.property_color+22+56)/2+0.724\nmyObj:setFillColor(r,g,b)\n"
        lua = lua.."if (target.property_color~=100) then\nmyObj.fill.effect = 'filter.brightness'\nmyObj.fill.effect.intensity = (target.property_brightness)/100-1\nend\n"
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
        add_pcall()
        if infoBlock[2][1][1] == 'globalVariable' then
            lua = lua..'if (varText_'..infoBlock[2][1][2]..'~=nil and varText_'..infoBlock[2][1][2]..'.text~=nil) then\ndisplay.remove(varText_'..infoBlock[2][1][2]..')\nend\nvarText_'..infoBlock[2][1][2]..' = display.newText(type(var_'..infoBlock[2][1][2]..')=="boolean" and (var_'..infoBlock[2][1][2]..' and app.words[373] or app.words[374]) or type(var_'..infoBlock[2][1][2]..')=="table" and encodeList(var_'..infoBlock[2][1][2]..') or var_'..infoBlock[2][1][2]..', '..x..', -'..y..', "fonts/font_1", 30)\n'
            lua = lua..'varText_'..infoBlock[2][1][2]..':setFillColor(0, 0, 0)'
            lua = lua.."\ncameraGroup:insert(varText_"..infoBlock[2][1][2]..")"
        else
            lua = lua..'if (target.varText_'..infoBlock[2][1][2]..'~=nil and target.varText_'..infoBlock[2][1][2]..'.text~=nil) then\ndisplay.remove(target.varText_'..infoBlock[2][1][2]..')\nend\ntarget.varText_'..infoBlock[2][1][2]..' = display.newText(type(target.var_'..infoBlock[2][1][2]..')=="boolean" and (target.var_'..infoBlock[2][1][2]..' and app.words[373] or app.words[374]) or type(target.var_'..infoBlock[2][1][2]..')=="table" and encodeList(target.var_'..infoBlock[2][1][2]..') or target.var_'..infoBlock[2][1][2]..', '..x..', -'..y..', "fonts/font_1", 30)\n'
            lua = lua..'target.varText_'..infoBlock[2][1][2]..':setFillColor(0, 0, 0)'
            lua = lua.."\ncameraGroup:insert(target.varText_"..infoBlock[2][1][2]..")"
        end
        end_pcall()
    elseif nameBlock == 'showVariable2' and infoBlock[2][1][2]~=nil then
        local x = make_all_formulas(infoBlock[2][2], object)
        local y = make_all_formulas(infoBlock[2][3], object)
        local size = make_all_formulas(infoBlock[2][4], object)
        local hex = make_all_formulas(infoBlock[2][5], object)
        local aligh = infoBlock[2][6][2]
        add_pcall()
        if infoBlock[2][1][1] == 'globalVariable' then
            lua = lua..'if (varText_'..infoBlock[2][1][2]..'~=nil and varText_'..infoBlock[2][1][2]..'.text~=nil) then\ndisplay.remove(varText_'..infoBlock[2][1][2]..')\nend\nvarText_'..infoBlock[2][1][2]..' = display.newText({text = type(var_'..infoBlock[2][1][2]..')=="boolean" and (var_'..infoBlock[2][1][2]..' and app.words[373] or app.words[374]) or type(var_'..infoBlock[2][1][2]..')=="table" and encodeList(var_'..infoBlock[2][1][2]..') or var_'..infoBlock[2][1][2]..', align="'..aligh..'", x = '..x..', y = - '..y..', font = nil, fontSize = 30 *('..size..'/100) })\n'
            lua = lua..'local rgb = utils.hexToRgb('..hex..')\n'
            lua = lua..'varText_'..infoBlock[2][1][2]..':setFillColor(rgb[1], rgb[2], rgb[3])'
            lua = lua.."\ncameraGroup:insert(varText_"..infoBlock[2][1][2]..")"
        else
            lua = lua..'if (target.varText_'..infoBlock[2][1][2]..'~=nil and target.varText_'..infoBlock[2][1][2]..'.text~=nil) then\ndisplay.remove(target.varText_'..infoBlock[2][1][2]..')\nend\ntarget.varText_'..infoBlock[2][1][2]..' = display.newText({text = type(target.var_'..infoBlock[2][1][2]..')=="boolean" and (target.var_'..infoBlock[2][1][2]..' and app.words[373] or app.words[374]) or type(target.var_'..infoBlock[2][1][2]..')=="table" and encodeList(target.var_'..infoBlock[2][1][2]..') or target.var_'..infoBlock[2][1][2]..', align="'..aligh..'", x = '..x..', y = - '..y..', font = nil, fontSize = 30 *('..size..'/100) })\n'
            lua = lua..'local rgb = utils.hexToRgb('..hex..')\n'
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
        lua = lua.."notCameraGroup:insert(target)\ntarget.group = notCameraGroup"
        end_pcall()
    elseif nameBlock=="insertObjectCamera" then
        add_pcall()
        lua = lua.."cameraGroup:insert(target)\ntarget.group = cameraGroup"
        end_pcall()
    elseif nameBlock=="removeVariableCamera" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua.."if ("..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2].."~=nil and "..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..".text ~= nil) then\nnotCameraGroup:insert("..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..")\nend"
        end_pcall()
     elseif nameBlock=="insertVariableCamera" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua.."if ("..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2].."~=nil and "..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..".text ~= nil) then\ncameraGroup:insert("..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..")\nend"
        end_pcall()
    elseif nameBlock=="removeFocusCameraToObject" then
        add_pcall()
        lua = lua.."if (focusCameraObject~=nil) then\ntimer.cancel(focusCameraObject.timerCamera)\nfocusCameraObject = nil\nend"
        end_pcall()
    elseif nameBlock=="saveVariable" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua..'local arrayVariables = plugins.json.decode(funsP["получить сохранение"]("'..(infoBlock[2][1][1]=="globalVariable" and app.idProject or obj_path)..'/variables"))'
        lua = lua..'\nfor i=1, #arrayVariables do\nif (arrayVariables[i][1]=='..infoBlock[2][1][2]..') then\narrayVariables[i][3] = '..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..'\nfunsP["записать сохранение"]("'..(infoBlock[2][1][1]=="globalVariable" and app.idProject or obj_path)..'/variables", plugins.json.encode(arrayVariables))\nbreak\nend\nend'
        end_pcall()
    elseif nameBlock=="readVariable" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua..'local arrayVariables = plugins.json.decode(funsP["получить сохранение"]("'..(infoBlock[2][1][1]=="globalVariable" and app.idProject or obj_path)..'/variables"))'
        lua = lua..'\nfor i=1, #arrayVariables do\nif (arrayVariables[i][1]=='..infoBlock[2][1][2]..') then\n'..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..'= arrayVariables[i][3]~=nil and arrayVariables[i][3] or 0\nbreak\nend\nend'
        lua = lua..'\nif '..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'varText_'..infoBlock[2][1][2]..' then\n '..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'varText_'..infoBlock[2][1][2]..'.text = type('..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..')=="boolean" and ('..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..' and app.words[373] or app.words[374]) or type('..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..')=="table" and encodeList('..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..') or '..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..'\nend'
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
        lua = lua..'local arrayArrays = plugins.json.decode(funsP["получить сохранение"]("'..(infoBlock[2][1][1]=="globalArray" and app.idProject or obj_path)..'/arrays"))'
        lua = lua..'\nfor i=1, #arrayArrays do\nif (arrayArrays[i][1]=='..infoBlock[2][1][2]..') then\narrayArrays[i][3] = '..(infoBlock[2][1][1]=="globalArray" and '' or 'target.')..'list_'..infoBlock[2][1][2]..'\nfunsP["записать сохранение"]("'..(infoBlock[2][1][1]=="globalArray" and app.idProject or obj_path)..'/arrays", plugins.json.encode(arrayArrays))\nbreak\nend\nend\n'
        end_pcall()
    elseif nameBlock=="readArray" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua..'local arrayArrays = plugins.json.decode(funsP["получить сохранение"]("'..(infoBlock[2][1][1]=="globalArray" and app.idProject or obj_path)..'/arrays"))'
        lua = lua..'\nfor i=1, #arrayArrays do\nif (arrayArrays[i][1]=='..infoBlock[2][1][2]..') then\n'..(infoBlock[2][1][1]=="globalArray" and '' or 'target.')..'list_'..infoBlock[2][1][2]..'= arrayArrays[i][3]~=nil and arrayArrays[i][3] or {}\nbreak\nend\nend'
        end_pcall()
    elseif nameBlock=="columnStorageToArray" and infoBlock[2][3][2]~=nil then
        add_pcall()
        lua = lua.."local allArraysValues = plugins.json.decode('[\"'.."..make_all_formulas(infoBlock[2][2], object)..":gsub('\"','\\\\\"'):gsub('\\r\\n','\",\"'):gsub('\\n','\",\"')..'\"]')"
        lua = lua.."\nfor i=1, #allArraysValues do\nlocal values = plugins.json.decode('[\"'..allArraysValues[i]:gsub('\\\"','\\\\\"'):gsub(',','\",\"')..'\"]')\nallArraysValues[i] = values["..make_all_formulas(infoBlock[2][1], object).."]==nil and '' or values["..make_all_formulas(infoBlock[2][1], object).."]\nend"
        lua = lua.."\n"..(infoBlock[2][3][1]=="globalArray" and '' or 'target.').."list_"..infoBlock[2][3][2].." = allArraysValues"
        end_pcall()
    elseif nameBlock=="getRequest" and infoBlock[2][2][2]~=nil then
        add_pcall()
        lua = lua.."local function networkListener(event)\nif (mainGroup~=nil and mainGroup.x~=nil) then\n"..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2].." = event.response\nif ("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][2][2]..") then\n"..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][2][2]..".text = type("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..")=='boolean' and ("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2].." and app.words[373] or app.words[374]) or type("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..")=='table' and encodeList("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..") or "..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2].."\nend\nend\nend\nlocal header = {headers={[\"User-Agent\"] = \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36\"}}\n\nnetwork.request("..make_all_formulas(infoBlock[2][1],object)..",'GET',networkListener, header)"
        end_pcall()
    elseif nameBlock=="exitGame" then
        add_pcall()
        lua = lua.."timer.new(0, function()\ndisplay.save(mainGroup,{ filename=myScene..'/icon.png', baseDir=system.DocumentsDirectory, backgroundColor={1,1,1,1}})\nfunBackListener2({keyName='deleteBack', phase='up'})\nend)"
        end_pcall()
    elseif nameBlock=="runScene" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua.."deleteScene()\nscene_"..infoBlock[2][1][2].."()"
        end_pcall()
    elseif nameBlock == 'foreach'then
        add_pcall()
        max_fors = max_fors+1
        if (infoBlock[2][1][2]==nil or infoBlock[2][2][2]==nil ) then
            infoBlock[2][1][2] = "nil"
            infoBlock[2][2][2] = "nil"
        end
        lua = lua..'for key'..max_fors..', value'..max_fors..' in pairs('
        lua = lua..(infoBlock[2][1][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][1][2]..') do\n'
        lua = lua..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..' = value'..max_fors..'\n'
        lua = lua..'if '..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..' then\n target.varText_'..infoBlock[2][1][2]..'.text = type('..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..")=='boolean' and ("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2].." and app.words[373] or app.words[374]) or type("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..")=='table' and encodeList("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..") or "..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..'\nend'
    elseif nameBlock == 'endForeach' then
        if wait_table['block:'..index] then
            for i = 1, wait_table['block:'..index], 1 do
                lua = lua .. 'end)\nend\n'
            end
        end
        lua = lua..'end'
        end_pcall()
    elseif nameBlock == 'lowerPen' then
    -- tableFeathers = {} сюда через table.insert(object) добавлять перья
    -- tableFeathersOptions[1] -размер пера
    -- tableFeathersOptions[2] - цвет r
    -- tableFeathersOptions[3] - цвет g
    -- tableFeathersOptions[4] - цвет b
        add_pcall()
        lua = lua.."if (target.isPen==nil) then\ntarget.isPen = true\nlocal line = display.newLine(target.x, target.y, target.x, target.y+1)\nline:setStrokeColor(tableFeathersOptions[2]/255,tableFeathersOptions[3]/255,tableFeathersOptions[4]/255,1)\nline.strokeWidth = tableFeathersOptions[1]\nstampsGroup:insert(line)\nline.oldX, line.oldY = target.x, target.y\nlocal timerPen\ntimerPen = timer.new(50, function()\nif (target.isPen and line.x) then\nif (math.sqrt(math.pow(target.x-line.oldX, 2) + math.pow(target.y-line.oldY, 2))>3) then\nline:append(target.x, target.y)\nline.oldX, line.oldY = target.x, target.y\nend\nelseif (line.x == nil) then\nline = display.newLine(target.x, target.y, target.x, target.y)\nline:setStrokeColor(tableFeathersOptions[2],tableFeathersOptions[3],tableFeathersOptions[4],1)\nline.strokeWidth = tableFeathersOptions[1]\ntable.insert(tableFeathers, #tableFeathers+1, line)\nstampsGroup:insert(line)\nelse\ntimer.cancel(timerPen)\nend\nend,0)\ntable.insert(tableFeathers, #tableFeathers+1, line)\nend"
        end_pcall()
    elseif nameBlock == 'raisePen' then
        lua = lua.."target.isPen=nil"
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
        lua = lua..'local _repeat\n_repeat = timer.GameNew(0, 0, function()\n'
        lua = lua..'if '..arg1..' then\ntimer.cancel(_repeat)\nend\nif not '..arg1..' then return true end\nif not (target ~= nil and target.x ~= nil) then\npcall(function() timer.cancel(_repeat) end)\nreturn true\nend'
    elseif nameBlock == 'endWait' then
        if wait_table['block:'..index] then
            for i = 1, wait_table['block:'..index], 1 do
                lua = lua .. 'end)\nend\n'
            end
        end
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
        lua = lua..'local _hex_rgb = utils.hexToRgb('..arg1..')\ndisplay.setDefault("background", _hex_rgb[1], _hex_rgb[2], _hex_rgb[3])\n_hex_rgb = nil\n'
        --native.showAlert('Monsler', arg1, {'OK'})
        end_pcall()
    elseif nameBlock == 'cancelAllTimers' then
        add_pcall()
        lua = lua..
'for key, value in pairs(Timers) do\
    timer.cancel(Timers[key])\nTimers[key] = nil\
end'
        end_pcall()
    elseif nameBlock == 'showToast' then
        add_pcall()
        local arg1 = make_all_formulas(infoBlock[2][1], object)
        lua = lua..'if not utils.isSim and not utils.isWin then require \'plugin.toaster\'.shortToast('..arg1..') end\n'
        end_pcall()
    elseif nameBlock == 'showHitboxes' then
        add_pcall()
        lua = lua..'plugins.physics.setDrawMode("hybrid")\n'
        end_pcall()
    elseif nameBlock == 'hideHitboxes' then
        add_pcall()
        lua = lua..'plugins.physics.setDrawMode("normal")\n'
        end_pcall()
    elseif nameBlock == 'setHorizontalOrientation' then
        add_pcall()
        lua = lua.."CENTER_X = display.contentCenterX\nCENTER_Y = display.screenOriginY+display.contentHeight/2\nplugins.orientation.lock('landscape')\nmainGroup.xScale, mainGroup.yScale = "..tostring(not options.aspectRatio and yScaleMainGroup or xScaleMainGroup)..", "..tostring(xScaleMainGroup).."\nmainGroup.x, mainGroup.y = CENTER_Y, CENTER_X\nblackRectTop.width, blackRectTop.height = display.contentHeight, display.contentWidth\nblackRectTop.x, blackRectTop.y = "..("-"..tostring(options.displayHeight/2)..",0" ).."\nblackRectTop.anchorX, blackRectTop.anchorY = 1, 0.5\nblackRectBottom.width, blackRectBottom.height = display.contentHeight, display.contentWidth\nblackRectBottom.x, blackRectBottom.y = "..(tostring(options.displayHeight/2)..",0" ).."\nblackRectBottom.anchorX, blackRectBottom.anchorY = 0, 0.5"
        end_pcall()
    elseif nameBlock == 'setVerticalOrientation' then
        add_pcall()
        lua = lua.."CENTER_X = display.contentCenterX\nCENTER_Y = display.screenOriginY+display.contentHeight/2\nplugins.orientation.lock('portrait')\nmainGroup.xScale, mainGroup.yScale = "..tostring(xScaleMainGroup)..", "..tostring(not options.aspectRatio and yScaleMainGroup or xScaleMainGroup).."\nmainGroup.x, mainGroup.y = CENTER_X, CENTER_Y\nblackRectTop.width, blackRectTop.height = display.contentWidth, display.contentHeight\nblackRectTop.x, blackRectTop.y = "..("0,-"..tostring(options.displayHeight/2)).."\nblackRectTop.anchorY, blackRectTop.anchorX = 1, 0.5\nblackRectBottom.x, blackRectBottom.y = "..("0,"..tostring(options.displayHeight/2)).."\nblackRectBottom.anchorY, blackRectBottom.anchorX = 0, 0.5"
        end_pcall()
    elseif nameBlock == 'thinkTime' then
        add_pcall()
        local arg1 = make_all_formulas(infoBlock[2][1], object)
        local arg2 = make_all_formulas(infoBlock[2][2], object)
        lua = lua..'if (target.think ~= nil) then\ndisplay.remove(target.think.carbon)\ndisplay.remove(target.think.text)\ndisplay.remove(target.think)\nend\ntarget.think = display.newRoundedRect(0, 0, 200, 200, 15)\ntarget.group:insert(target.think)\ntarget.think.carbon = display.newImage("sprites/thinks.png", CENTER_X, CENTER_Y)\ntarget.group:insert(target.think.carbon)\ntarget.think.carbon:scale(0.17, 0.17)\ntarget.think.text = display.newText('..arg1..', 0, 0, 190, 190, native.systemFont, 25)\ntarget.group:insert(target.think.text)\ntarget.think.text:setFillColor(0)\ntarget.think.x = target.x + (target.width/2) + 100 target.think.y = target.y - target.width/2 - 100 target.think.text.x = target.think.x+10 target.think.text.y = target.think.y+10 \ntarget.think.carbon.x = target.think.x - target.think.width/2+23\ntarget.think.carbon.y = target.think.y + target.think.height/2+20\nlocal _mover = timer.performWithDelay(0, function()\nif (target.think~=nil and target.think.x ~=nil) then\ntarget.think.x = target.x + (target.width/2) + 100 target.think.y = target.y - target.width/2 - 100 target.think.text.x = target.think.x+10 target.think.text.y = target.think.y+10 \ntarget.think.carbon.x = target.think.x - target.think.width/2+23\ntarget.think.carbon.y = target.think.y + target.think.height/2+20\nend\nend, -1)\ntimer.performWithDelay('..arg2..'*1000, function()\nif (target.think~=nil and target.think.x ~=nil) then\ntimer.cancel(_mover) target.think:removeSelf() target.think.text:removeSelf() target.think.carbon:removeSelf() \nelse\ntimer.cancel(_mover)\nend\nend)'
        end_pcall()
    elseif nameBlock == 'sayTime' then
        add_pcall()
        local arg1 = make_all_formulas(infoBlock[2][1], object)
        local arg2 = make_all_formulas(infoBlock[2][2], object)
        lua = lua..'if (target.think ~= nil) then\ndisplay.remove(target.think.carbon)\ndisplay.remove(target.think.text)\ndisplay.remove(target.think)\nend\ntarget.think = display.newRoundedRect(0, 0, 200, 200, 15)\ntarget.group:insert(target.think)\ntarget.think.carbon = display.newImage("sprites/says.png", CENTER_X, CENTER_Y)\ntarget.group:insert(target.think.carbon)\ntarget.think.carbon:scale(0.17, 0.17)\ntarget.think.text = display.newText('..arg1..', 0, 0, 190, 190, native.systemFont, 25)\ntarget.group:insert(target.think.text)\ntarget.think.text:setFillColor(0)\n\ntarget.think.x = target.x + (target.width/2) + 100 target.think.y = target.y - target.width/2 - 100 target.think.text.x = target.think.x+10 target.think.text.y = target.think.y+10 \ntarget.think.carbon.x = target.think.x - target.think.width/2+23\ntarget.think.carbon.y = target.think.y + target.think.height/2+15\nlocal _mover = timer.performWithDelay(0, function()\nif (target.think~=nil and target.think.x ~=nil) then\ntarget.think.x = target.x + (target.width/2) + 100 target.think.y = target.y - target.width/2 - 100 target.think.text.x = target.think.x+10 target.think.text.y = target.think.y+10 \ntarget.think.carbon.x = target.think.x - target.think.width/2+23\ntarget.think.carbon.y = target.think.y + target.think.height/2+15\nend\nend, -1)\ntimer.performWithDelay('..arg2..'*1000, function()\nif (target.think~=nil and target.think.x ~=nil) then\ntimer.cancel(_mover) target.think:removeSelf() target.think.text:removeSelf() target.think.carbon:removeSelf() \nelse\ntimer.cancel(_mover)\nend\nend)'
        end_pcall()
    elseif nameBlock == 'setTextelCoarseness' then
        add_pcall()
        local arg1 = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."target.physicsTable.outline = graphics.newOutline("..arg1..", target.image_path, system.DocumentsDirectory)\ntarget:physicsReload()\n"
        end_pcall()
    elseif nameBlock == 'jump' then
        add_pcall()
        lua = lua.."target:setLinearVelocity("..make_all_formulas(infoBlock[2][1], object)..", -"..make_all_formulas(infoBlock[2][2], object)..")"
        end_pcall()
    elseif nameBlock == 'jumpX' then
        add_pcall()
        lua = lua.."local vX, vY = target:getLinearVelocity()\ntarget:setLinearVelocity("..make_all_formulas(infoBlock[2][1], object)..", vY)"
        end_pcall()
    elseif nameBlock == 'jumpY' then
        add_pcall()
        lua = lua.."local vX, vY = target:getLinearVelocity()\ntarget:setLinearVelocity( vX, -"..make_all_formulas(infoBlock[2][1], object)..")"
        end_pcall()
    elseif nameBlock == 'jumpYIf' then
        add_pcall()
        lua = lua.."local vX, vY = target:getLinearVelocity()\nif (vY==0) then\ntarget:setLinearVelocity( vX, -"..make_all_formulas(infoBlock[2][1], object)..")\nend"
        end_pcall()
    elseif nameBlock == 'setGravityScale' then
        add_pcall()
        lua = lua.."local v = "..make_all_formulas(infoBlock[2][1], object).."\ntarget.gravityScale = tonumber(v, 0)"
        end_pcall()
    elseif nameBlock == 'setAnchorVariable' and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..".anchorX, "..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..".anchorY = "..make_all_formulas(infoBlock[2][2], object).."/100, "..make_all_formulas(infoBlock[2][3], object).."/100"
        end_pcall()
    elseif nameBlock == 'toFrontLayerVar' and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..":toFront()"
        end_pcall()
    elseif nameBlock == 'toBackLayerVar' and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..":toBack()"
        end_pcall()
    elseif nameBlock == 'removeAdaptiveSizeDevice' then
        add_pcall()
        lua = lua.."mainGroup.xScale, mainGroup.yScale = 1, 1"
        end_pcall()
    elseif nameBlock == 'stopScript' then
        lua = lua..'if true then pcall(function() timer.cancel(_repeat) end) return true end'
    end
    return lua
end

return(make_block)