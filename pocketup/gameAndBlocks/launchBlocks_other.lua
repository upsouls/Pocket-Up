
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

-- local isEvent = {
--     start=true, touchObject=true, touchScreen=true, ["function"]=true, whenTheTruth=true, collision=true, changeBackground=true, startClone=true,
--     movedObject=true, onTouchObject=true, movedScreen=true, onTouchScreen=true, touchBack=true, endedCollision=true,
-- }

-- BlocksAllHandlers = {}
-- local moduleHandlers = {'data', 'control', 'textFields', 'sounds', 'physics', 'pen', 'particles', 'miniScenes', 'images', 'elementInterface', 'device'}
-- for _, module in ipairs(moduleHandlers) do
--     for key, value in pairs(require('pocketup.gameAndBlocks.launchBlocks.'..module)) do
--         BlocksAllHandlers[key] = value
--     end
-- end

local function make_block(infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o, mainGroup, videos)
    if infoBlock[3] == 'off' then
        return ''
    end
    nameBlock = infoBlock[1]--args[i] = make_all_formulas(infoBlock[2][i], object)
    lua = ''
    -- local waitInsert = function (time)
    --     lua = lua..'threadFun.wait('..time..'*1000)'
    -- end
    if BlocksAllHandlers[nameBlock] then
        lua = lua..(BlocksAllHandlers[nameBlock](infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o, mainGroup, videos) or '')
    elseif nameBlock == 'transitionPosition' then
        local time = make_all_formulas(infoBlock[2][1], object)
        local x = make_all_formulas(infoBlock[2][2], object)
        local y = make_all_formulas(infoBlock[2][3], object)

        add_pcall()
        lua = lua..
        "transition.to(target, {time="..time.."*1000,\
        x="..x..", y= -"..y.."})"
        end_pcall()
    elseif nameBlock == 'timer' then
        local rep = make_all_formulas(infoBlock[2][1], object)
        local time = make_all_formulas(infoBlock[2][2], object)
        lua = lua..
        "for i=1, type("..rep..") == 'number' and "..rep.." or 0 do\
        threadFun.wait(type("..time..") == 'number' and ("..time.."*1000) or 0)"
    elseif nameBlock == 'endTimer' then
        lua = lua.."coroutine.yield()\nend"
    elseif nameBlock == 'hideSysPanels' then
        lua = lua..'native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )\n'
    elseif nameBlock == 'showSysPanels' then
        lua = lua..'native.setProperty( "androidSystemUiVisibility", "default" )\n'
    elseif (nameBlock=='createJoystick') then
        add_pcall()
        print(require 'json'.encode(infoBlock[2][6]))
        pcall(function ()
            lua = lua..'\nif (joysticks['..make_all_formulas(infoBlock[2][1], object)..']~=nil) then\ndisplay.remove(joysticks['..make_all_formulas(infoBlock[2][1], object)..'])\nend\nlocal myJoystick = display.newGroup()\njoysticks['..make_all_formulas(infoBlock[2][1], object)..'] = myJoystick\ncameraGroup:insert(myJoystick)'
                lua = lua..'\nmyJoystick.joystick1 = display.newImage("'..obj_path..'/image_'..infoBlock[2][2][2]..'.png", system.DocumentsDirectory)\nmyJoystick:insert(myJoystick.joystick1)'
                lua = lua..'\nmyJoystick.joystick2 = display.newImage("'..obj_path..'/image_'..infoBlock[2][3][2]..'.png", system.DocumentsDirectory)\nmyJoystick:insert(myJoystick.joystick2)'
                lua = lua..'\nmyJoystick:addEventListener("touch", function(event)\nif (event.phase=="began") then\ndisplay.getCurrentStage():setFocus(event.target, event.id)\nelseif (event.phase=="ended") then\ndisplay.getCurrentStage():setFocus(event.target, nil)\nend\nlocal joystick = event.target.joystick2\nif (event.phase=="ended" or event.phase=="cancelled") then\njoystick.x, joystick.y = 0, 0\nelse\nlocal width = event.target.joystick1.width*event.target.joystick1.xScale/2\nlocal height = event.target.joystick1.height*event.target.joystick1.yScale/2\nlocal direction = math.atan2(event.x-event.target.x-mainGroup.x, (event.y-event.target.y-mainGroup.y))local radius = math.sqrt(math.pow(event.x-event.target.x-mainGroup.x, 2)+math.pow(event.y-event.target.y-mainGroup.y, 2))\njoystick.x, joystick.y = math.sin(direction)*math.min(radius, width*event.target.xScale)/event.target.xScale*mainGroup.xScale, math.cos(direction)*math.min(radius, height*event.target.yScale)/event.target.yScale/mainGroup.yScale\nend\n'..(infoBlock[2][4][1]=="globalVariable" and "" or "target.")..'var_'..infoBlock[2][4][2]..', '..(infoBlock[2][5][1]=="globalVariable" and "" or "target.")..'var_'..infoBlock[2][5][2]..' = joystick.x, -joystick.y\nif ('..(infoBlock[2][4][1]=="globalVariable" and "" or "target.")..'varText_'..infoBlock[2][4][2]..'~=nil) then\n'..(infoBlock[2][4][1]=="globalVariable" and "" or "target.")..'varText_'..infoBlock[2][4][2]..'.text = joystick.x\nend\nif ('..(infoBlock[2][5][1]=="globalVariable" and "" or "target.")..'varText_'..infoBlock[2][5][2]..'~=nil) then\n'..(infoBlock[2][5][1]=="globalVariable" and "" or "target.")..'varText_'..infoBlock[2][5][2]..'.text = -joystick.y\nend\nlocal key = target.parent_obj.nameObject\nfor i=1, #events_function[key]["fun_'..infoBlock[2][6][2]..'"] do\n\
                events_function[key]["fun_'..infoBlock[2][6][2]..'"][i](target)\nend\nreturn(true)\nend)'
        end)
    
        end_pcall()
    elseif (nameBlock=='setPositionJoystick') then
        add_pcall()
        lua = lua..'\nlocal joystick = joysticks['..make_all_formulas(infoBlock[2][1], object)..']\njoystick.x, joystick.y = '..make_all_formulas(infoBlock[2][2], object)..', -'..make_all_formulas(infoBlock[2][3], object)
        end_pcall()
    elseif (nameBlock=='setSizeJoystick') then
        add_pcall()
        lua = lua..'\nlocal joystick = joysticks['..make_all_formulas(infoBlock[2][1], object)..']\njoystick.xScale = '..make_all_formulas(infoBlock[2][2], object)..'/100\njoystick.yScale = joystick.xScale'
        end_pcall()
    elseif (nameBlock=='setSizeJoystick1') then
        add_pcall()
        lua = lua..'\nlocal joystick = joysticks['..make_all_formulas(infoBlock[2][1], object)..'].joystick1\njoystick.xScale = '..make_all_formulas(infoBlock[2][2], object)..'/100\njoystick.yScale = joystick.xScale'
        end_pcall()
    elseif (nameBlock=='setSizeJoystick2') then
        add_pcall()
        lua = lua..'\nlocal joystick = joysticks['..make_all_formulas(infoBlock[2][1], object)..'].joystick2\njoystick.xScale = '..make_all_formulas(infoBlock[2][2], object)..'/100\njoystick.yScale = joystick.xScale'
        end_pcall()
    elseif (nameBlock=='cameraInsertJoystick') then
        add_pcall()
        lua = lua..'\ncameraGroup:insert(joysticks['..make_all_formulas(infoBlock[2][1], object)..'])'
        end_pcall()
    elseif (nameBlock=='cameraRemoveJoystick') then
        add_pcall()
        lua = lua..'\nnotCameraGroup:insert(joysticks['..make_all_formulas(infoBlock[2][1], object)..'])'
        end_pcall()
    end
    return lua

end

return(make_block)