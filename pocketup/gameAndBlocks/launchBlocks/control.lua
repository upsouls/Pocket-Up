return {
    ["timer3"] = function(infoBlock, object, images, sounds, make_all_formulas)
        local rep = make_all_formulas(infoBlock[2][1], object)
        local time = make_all_formulas(infoBlock[2][2], object)
        return "for i=1, type("..rep..") == 'number' and "..rep.." or 0 do\
            threadFun.wait(type("..time..") == 'number' and ("..time.."*1000) or 0)"
    end,

    ["endTimer2"] = function ()
        return "coroutine.yield()\nend"
    end,

    ["wait"] = function(infoBlock, object, images, sounds, make_all_formulas)
        local time = make_all_formulas(infoBlock[2][1], object)
        return "threadFun.wait("..time.."*1000)"
    end,

    ["commentary"] = function()
    end,

    ["cycleForever"] = function()
        return "while true do"
    end,

    ["endCycleForever"] = function ()
        return 
        "coroutine.yield()\
        end"
    end,

    ["ifElse (2)"] = function(infoBlock, object, images, sounds, make_all_formulas)
        local condition = make_all_formulas(infoBlock[2][1], object)
        return "if "..condition.." then"
    end,

    ["if"] = function(infoBlock, object, images, sounds, make_all_formulas)
        local condition = make_all_formulas(infoBlock[2][1], object)
        return "if "..condition.." then"
    end,

    ["else"] = function()
        return "else"
    end,

    ["endIf"] = function()
        return "end"
    end,

    ["repeatIsTrue"] = function (infoBlock, object, images, sounds, make_all_formulas)
        local condition = make_all_formulas(infoBlock[2][1], object)
        return "while "..condition.." do"
    end,

    ["repeat"] = function(infoBlock, object, images, sounds, make_all_formulas)
        local rep = make_all_formulas(infoBlock[2][1], object)
        return "for i=1, type("..rep..") == 'number' and "..rep.." or 0, 1 do"
    end,

    ["endRepeat"] = function()
        return "coroutine.yield()\
        end"
    end,

    ["waitIfTrue2"] = function(infoBlock, object, images, sounds, make_all_formulas)
        local arg1 = make_all_formulas(infoBlock[2][1], object)
        return "while not "..arg1.." do\
        coroutine.yield()\
        end"
    end,

    ["for"] = function (infoBlock, object, images, sounds, make_all_formulas)
        local one = make_all_formulas(infoBlock[2][1], object)
        local _end = make_all_formulas(infoBlock[2][2], object)
        max_fors = max_fors+1
        local lua = ''
        lua = lua .. "for i"..max_fors.." = (type("..one..") == 'number' and "..one.." or 0) , type(".._end..") == 'number' and ".._end.." or 0, 1 do\n"
        if (infoBlock[2][3][2]~=nil) then
            if infoBlock[2][3][1] == "globalVariable" then
                lua = lua .. "var_"..infoBlock[2][3][2].." = i"..max_fors.."\n"
            else
                lua = lua .."target.var_"..infoBlock[2][3][2].." = i"..max_fors.."\n"
            end
        end
        return lua
    end,

    ["endFor"] = function ()
        return "coroutine.yield()\
        end"
    end,

    ["foreach"] = function (infoBlock, object, images, sounds, make_all_formulas)
        max_fors = max_fors+1
        if (infoBlock[2][1][2]==nil or infoBlock[2][2][2]==nil ) then
            infoBlock[2][1][2] = "nil"
            infoBlock[2][2][2] = "nil"
        end
        local lua = ''
        lua = lua .. 'for key'..max_fors..', value'..max_fors..' in pairs('
        lua = lua .. (infoBlock[2][1][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][1][2]..') do\n'
        lua = lua .. (infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..' = value'..max_fors..'\n'
        lua = lua .. 'if '..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..' then\n target.varText_'..infoBlock[2][1][2]..'.text = type('..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..")=='boolean' and ("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2].." and app.words[373] or app.words[374]) or type("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..")=='table' and encodeList("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..") or "..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..'\nend'

        return lua
    end,

    ["endForeach"] = function ()
        return "end"
    end,

    ["deleteScene"] = function (infoBlock, object, images, sounds, make_all_formulas)
        if infoBlock[2][1][2]==nil then
            return ''
        end
        local lua = "pcall(function()\n"
        lua = lua.."deleteScene("..infoBlock[2][1][2]..")"
        lua = lua.."\nend)"
        return lua
    end,

    ["continueScene"] = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if infoBlock[2][1][2]==nil then
            return ''
        end
        local id = infoBlock[2][1][2]

        local lua = "pcall(function()\n"
        lua = lua..
        "moveScene()\
        if not Scenes["..id.."] then\
            scene_"..infoBlock[2][1][2].."()\
            return true\
        end\
        \
        local scene = Scenes["..id.."]\
        Scenes.select = scene\
        \
        globalConstants.touchX = scene.globalConstants.touchX\
        globalConstants.touchY = scene.globalConstants.touchY\
        globalConstants.isTouch = false\
        \
        thread.timers = scene.threads\
        for i = 1 , #thread.timers do\
            timer.resume(thread.timers[i])\
        end\
        mainGroup = scene.mainGroup\
        mainGroup.isVisible = true\
        \
        \
        WebViews = scene.WebViews\
        textFields = scene.textFields\
        objects = scene.objects\
        \
        events_touchBack = scene.events_touchBack\
        events_keypressed = scene.events_keypressed\
        events_endKeypressed = scene.events_endKeypressed\
        events_touchScreen = scene.events_touchScreen\
        events_movedScreen = scene.events_movedScreen\
        events_onTouchScreen = scene.events_onTouchScreen\
        events_whenTheTruth = scene.events_whenTheTruth\
        playSounds = scene.playSounds\
        playingSounds = scene.playingSounds\
        \
        joysticks = scene.joysticks\
        Timers = {}\
        Timers_max = 0\
        \
        \
        for key, value in pairs(objects) do\
            pcall(function()\
                transition.resume(value)\
            end)\
            pcall(function()\
                if value.physicsReload then\
                    value:physicsReload()\
                end\
            end)\
        end\
        for key, value in pairs(playingSounds) do\
            audio.resume(playingSounds[key])\
        end\
        "
        return lua.."\nend)\
        removeTheard()\ncoroutine.yield()"
    end,

    ["runScene"] = function (infoBlock, object, images, sounds, make_all_formulas)
        if infoBlock[2][1][2]==nil then
            return ''
        end
        local lua = "pcall(function()\n"
        lua = lua..
        "moveScene()\
        if Scenes["..infoBlock[2][1][2].."] then\
            deleteScene("..infoBlock[2][1][2]..")\
        end\
        scene_"..infoBlock[2][1][2].."()"
        lua = lua.."\nend)\
        removeTheard()\ncoroutine.yield()"
        return lua
    end,

    ["exitGame"] = function ()
        local lua = "pcall(function()\n"
        lua = lua.."timer.new(0, function()\ndisplay.save(mainGroup,{ filename=myScene..'/icon.png', baseDir=system.DocumentsDirectory, backgroundColor={1,1,1,1}})\nfunBackListener2({keyName='deleteBack', phase='up'})\nend)"
        return lua.."\nend)"
    end,

    ["stopScript"] = function ()
        return "removeTheard()\ncoroutine.yield()"
    end,

    ["clone"] = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        if (infoBlock[2][1][2]~=nil) then
            lua = lua.."\nlocal target = objects['object_"..infoBlock[2][1][2].."']"
        end
        lua = lua.."\nlocal myClone\
        if (target.parent_obj.countImages>0) then"
        lua = lua.."\nmyClone = display.newImage(target.image_path, system.DocumentsDirectory, target.x, target.y)"
        lua = lua.."\nmyClone.image_path = target.image_path\
        for k, v in pairs(target.parent_obj.namesVars) do\
            myClone[v] = 0\
        end\
        for k, v in pairs(target.parent_obj.namesLists) do\
            myClone[v] = {}\
        end"
        lua = lua.."\nelse"
        lua = lua.."\nmyClone = display.newImage('images/notVisible.png', target.x, target.y)"
        lua = lua.."\nend"
        lua = lua.."\ntarget.group:insert(myClone)\
        myClone.group = target.group"
        lua = lua.."\nmyClone:addEventListener('touch', function(event)\
        if (event.phase=='began') then\
            local newIdTouch=globalConstants.touchId+1\
            globalConstants.touchId = newIdTouch\
            globalConstants.keysTouch['touch_'..newIdTouch], globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = event.id, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale, true\
            globalConstants.isTouch, globalConstants.touchX, globalConstants.touchY = true, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\
            display.getCurrentStage():setFocus(event.target, event.id)\
            event.target.isTouch = true\
            for key, value in pairs(objects) do\
                for i=1, #events_touchScreen[key] do\
                    events_touchScreen[key][i](value)\
                    for i2=1, #value.clones do\
                        events_touchScreen[key][i](value.clones[i2])\
                    end\
                end\
            end\
            for i=1, #myClone.parent_obj.events_touchObject do\
                myClone.parent_obj.events_touchObject[i](event.target)\
            end\
        elseif (event.phase=='moved') then\
            globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id] = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\nglobalConstants.touchX, globalConstants.touchY = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\
            for key, value in pairs(objects) do\
                for i=1, #events_movedScreen[key] do\
                    events_movedScreen[key][i](value)\
                    for i2=1, #value.clones do\
                        events_movedScreen[key][i](value.clones[i2])\
                    end\
                end\
            end\
            for i=1, #myClone.parent_obj.events_movedObject do\
                myClone.parent_obj.events_movedObject[i](event.target)\
            end\
        else\
            display.getCurrentStage():setFocus(event.target, nil)\
            event.target.isTouch = nil\
            globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = nil, nil, nil\
            if (pocketupFuns.getCountTouch(globalConstants.isTouchsId)==0) then\
                globalConstants.keysTouch = {}\
                globalConstants.isTouch = false\
            end\
            for key, value in pairs(objects) do\
                for i=1, #events_onTouchScreen[key] do\
                    events_onTouchScreen[key][i](value)\
                    for i2=1, #value.clones do\
                        events_onTouchScreen[key][i](value.clones[i2])\
                    end\
                end\
            end\
            for i=1, #myClone.parent_obj.events_onTouchObject do\
                myClone.parent_obj.events_onTouchObject[i](event.target)\
            end\
        end\
        return(true)\
        end)"
        lua = lua.."\nmyClone.xScale, myClone.yScale, myClone.alpha, myClone.rotation, myClone.numberImage, myClone.parent_obj = target.xScale, target.yScale, target.alpha, target.rotation, target.numberImage, target.parent_obj"
        lua = lua.."\nmyClone.fill.effect = 'filter.brightness'\
        myClone.property_brightness = target.property_brightness\
        myClone.fill.effect.intensity = (target.property_brightness)/100-1"


        lua = lua.."\nmyClone.parent_obj = target.parent_obj or target"

        lua = lua.."\ntarget.parent_obj.clones[#target.parent_obj.clones+1] = myClone\nmyClone.idClone, myClone.tableVarShow, myClone.origWidth, myClone.origHeight, myClone.width, myClone.height, myClone.property_size = #target.parent_obj, {}, target.origWidth, target.origHeight, target.width, target.height, target.property_size"
        lua = lua.."\nmyClone.isVisible = target.isVisible\nmyClone.physicsReload, myClone.physicsType , myClone.physicsTable = target.physicsReload or function(ob) end, target.physicsType or 'static' , plugins.json.decode(plugins.json.encode(target.physicsTable)) or {}\nmyClone:physicsReload()"
        lua = lua.."\nmyClone.property_color = target.property_color\nlocal r = pocketupFuns.sin(target.property_color-22+56)/2+0.724\nlocal g = pocketupFuns.cos(target.property_color+56)/2+0.724\nlocal b = pocketupFuns.sin(target.property_color+22+56)/2+0.724\nmyClone:setFillColor(r,g,b)\nmyClone.touchesObjects = {}"
        lua = lua.."\ntimer.new(0, function()\nmyClone:addEventListener('collision', function(event)\nif (event.phase=='began') then\nevent.target.touchesObjects['obj_'..event.other.parent_obj.idObject] = true\ntimer.new(0, function()\nfor i=1, #myClone.parent_obj.events_collision do\nmyClone.parent_obj.events_collision[i](event.target, event.other.parent_obj.nameObject)\nend\nend)\nelseif (event.phase=='ended') then\nevent.target.touchesObjects['obj_'..event.other.parent_obj.idObject] = nil\ntimer.new(0, function()\nfor i=1, #myClone.parent_obj.events_endedCollision do\nmyClone.parent_obj.events_endedCollision[i](event.target, event.other.parent_obj.nameObject)\nend\nend)\nend\nend)"
        lua = lua.."\nmyClone.gravityScale, myClone.isSensor = target.gravityScale, target.isSensor\n myClone.parent_obj.events_startClone = myClone.parent_obj.events_startClone or (events_startClone or {})"
        lua = lua.."\ntimer.new(0, function()\nfor i=1, #myClone.parent_obj.events_startClone do\nmyClone.parent_obj.events_startClone[i](myClone)\nend\n"
        lua = lua.."\nend) end)"
        return lua.."\nend)"
    end,

    ["deleteClone"] = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        lua = lua..
        "if (target) then\
            table.remove(target.parent_obj.clones, target.idClone)\
            for i=1, #target.parent_obj.clones do\
                target.parent_obj.clones[i].idClone = i\
            end\
            display.remove(target)\
        end"
        lua = lua.."\nend)\n"
        lua = lua.."pcall(function()\n"
        lua = lua.."if true then pcall(function() timer.cancel(_repeat) end) return true end"
        lua = lua.."\nend)"
        return lua
    end,

    ["broadcastFunction"] = function (infoBlock, object, images, sounds, make_all_formulas)
        if infoBlock[2][1][2]~=nil then
            local lua = "pcall(function()\n"
            lua = lua.."timer.new(0, function() broadcastFunction('fun_"..infoBlock[2][1][2].."')end)"
            return lua.."\nend)"
        end
    end,

    ["broadcastFunctionAndWait"] = function (infoBlock, object, images, sounds, make_all_formulas)
        if infoBlock[2][1][2]~=nil then
            local lua = "pcall(function()\n"
            lua = lua.."broadcastFunction('fun_"..infoBlock[2][1][2].."')"
            return lua.."\nend)"
        end
    end,

    ["broadcastFun>allObjects"] = function (infoBlock, object, images, sounds, make_all_formulas)
        if infoBlock[2][1][2]~=nil then
            local lua = "pcall(function()\n"
            lua = lua.."local function broadcastFunction(nameFunction)\nfor key, value in pairs(objects) do\nfor i=1, #events_function[key][nameFunction] do\nevents_function[key][nameFunction][i](value)\nend\nend\nend\nbroadcastFunction('fun_"..infoBlock[2][1][2].."')"
            return lua.."\nend)"
        end
    end,

    ["broadcastFun>allClones"] = function (infoBlock, object, images, sounds, make_all_formulas)
        if infoBlock[2][1][2]~=nil then
            local lua = "pcall(function()\n"
            lua = lua.."local function broadcastFunction(nameFunction)\nfor key, value in pairs(objects) do\nfor i=1, #events_function[key][nameFunction] do\nfor i2=1, #value.clones do\nevents_function[key][nameFunction][i](value.clones[i2])\nend\nend\nend\nend\nbroadcastFunction('fun_"..infoBlock[2][1][2].."')"
            return lua.."\nend)"
        end
    end,

    ["broadcastFun>objectAndClones"] = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if infoBlock[2][2][2]~=nil then
            local lua = "pcall(function()\n"
            lua = lua.."local function broadcastFunction(nameFunction)\nlocal key = 'object_"..(infoBlock[2][1][2]==nil and obj_id or infoBlock[2][1][2]).."'\nlocal value = objects[key]\nfor i=1, #events_function[key][nameFunction] do\nevents_function[key][nameFunction][i](value)\nfor i2=1, #value.clones do\nevents_function[key][nameFunction][i](value.clones[i2])\nend\nend\nend\nbroadcastFunction('fun_"..infoBlock[2][2][2].."')"
            return lua.."\nend)"
        end
    end,

    ["broadcastFun>object"] = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if infoBlock[2][2][2]~=nil then
            local lua = "pcall(function()\n"
            lua = lua.."local function broadcastFunction(nameFunction)\nlocal key = 'object_"..(infoBlock[2][1][2]==nil and obj_id or infoBlock[2][1][2]).."'\nlocal value = objects[key]\nfor i=1, #events_function[key][nameFunction] do\nevents_function[key][nameFunction][i](value)\nend\nend\nbroadcastFunction('fun_"..infoBlock[2][2][2].."')"
            return lua.."\nend)"
        end
    end,

    ["broadcastFun>clones"] = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if infoBlock[2][2][2]~=nil then
            local lua = "pcall(function()\n"
            lua = lua.."local function broadcastFunction(nameFunction)\nlocal key = 'object_"..(infoBlock[2][1][2]==nil and obj_id or infoBlock[2][1][2]).."'\nlocal value = objects[key]\nfor i=1, #events_function[key][nameFunction] do\nfor i2=1, #value.clones do\nevents_function[key][nameFunction][i](value.clones[i2])\nend\nend\nend\nbroadcastFunction('fun_"..infoBlock[2][2][2].."')"
            return lua.."\nend)"
        end
    end,

    ["addNameClone"] = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."target.myName = "..make_all_formulas(infoBlock[2][1], object).."\ntableNamesClones[target.myName] = target\ntarget.nameObject = 'object_"..obj_id.."'"
        return lua.."\nend)"
    end,

    ["broadcastFun>nameClone"] = function (infoBlock, object, images, sounds, make_all_formulas)
        if infoBlock[2][2][2]~=nil then
            local lua = "pcall(function()\n"
            lua = lua..
            "local function broadcastFunction(nameFunction)\
                local value = tableNamesClones["..make_all_formulas(infoBlock[2][1], object).."]\
                local key = value.nameObject\
                for i=1, #events_function[key][nameFunction] do\
                    events_function[key][nameFunction][i](value)\
                end\
            end\
            broadcastFunction('fun_"..infoBlock[2][2][2].."')"
            return lua.."\nend)"
        end
    end,
    
    ["whenTheTruth"] = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o, mainGroup, videos)
        local lua = "pcall(function()\n"
        return lua.."\nend)"
    end,
    ["endWhenTheTruth"] = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o, mainGroup, videos)
        local lua = "pcall(function()\n"
        return lua.."\nend)"
    end,
}