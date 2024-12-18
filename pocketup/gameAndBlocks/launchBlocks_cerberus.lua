local lua = ''
local add_pcall = function ()
    lua = lua..'\npcall(function()\n'
end
local end_pcall = function ()
    lua = lua..'\nend)\n'
end
local function make_block(infoBlock, object, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options)
	if infoBlock[3] == 'off' then
        return ''
    end
    local nameBlock = infoBlock[1]
    lua = ''

    if (nameBlock=='setShapeHitbox') then
        add_pcall()
        lua = lua.."local tableShape = plugins.json.decode('"..infoBlock[2][1][2].."')\nlocal tableResizeShape = {}\nlocal size = target.property_size/100\nfor i=1, #tableShape/2 do\ntableResizeShape[i*2-1], tableResizeShape[i*2] = tableShape[i*2-1]*size, tableShape[i*2]*size\nend\ntarget.physicsTable.radius, target.physicsTable.outline, target.physicsTable.shape = nil, nil, tableResizeShape\ntarget:physicsReload()"
        end_pcall()
    elseif (nameBlock=='setPositionMiniScene') then
        add_pcall()
        lua = lua.."local miniScene = miniScenes["..make_all_formulas(infoBlock[2][1], object).."]\nminiScene.x, miniScene.y = "..make_all_formulas(infoBlock[2][2], object)..", -"..make_all_formulas(infoBlock[2][3], object)
        end_pcall()
    elseif (nameBlock=='editPositionMiniScene') then
        add_pcall()
        lua = lua.."miniScenes["..make_all_formulas(infoBlock[2][1], object).."]:translate("..make_all_formulas(infoBlock[2][2], object)..", -"..make_all_formulas(infoBlock[2][3], object)..")"
        end_pcall()
    elseif (nameBlock=='setSizeMiniScene') then
        add_pcall()
        lua = lua.."local miniScene = miniScenes["..make_all_formulas(infoBlock[2][1], object).."]\nminiScene.xScale = "..make_all_formulas(infoBlock[2][2], object).."/100\nminiScene.yScale=miniScene.xScale"
        end_pcall()
    elseif (nameBlock=='editSizeMiniScene') then
        add_pcall()
        lua = lua.."local miniScene = miniScenes["..make_all_formulas(infoBlock[2][1], object).."]\nminiScene.xScale = miniScene.xScale+"..make_all_formulas(infoBlock[2][2], object).."/100\nminiScene.yScale=miniScene.xScale"
        end_pcall()
    elseif (nameBlock=='setRotationMiniScene') then
        add_pcall()
        lua = lua.."miniScenes["..make_all_formulas(infoBlock[2][1], object).."].rotation = "..make_all_formulas(infoBlock[2][2], object)
        end_pcall()
    elseif (nameBlock=='editRotationMiniScene') then
        add_pcall()
        lua = lua.."miniScenes["..make_all_formulas(infoBlock[2][1], object).."]:rotate("..make_all_formulas(infoBlock[2][2], object)..")"
        end_pcall()
    elseif (nameBlock=='setAlphaMiniScene') then
        add_pcall()
        lua = lua.."miniScenes["..make_all_formulas(infoBlock[2][1], object).."].alpha = 1-("..make_all_formulas(infoBlock[2][2], object)..")/100"
        end_pcall()
    elseif (nameBlock=='editAlphaMiniScene') then
        add_pcall()
        lua = lua.."local miniScene = miniScenes["..make_all_formulas(infoBlock[2][1], object).."]\nminiScene.alpha = miniScene.alpha-("..make_all_formulas(infoBlock[2][2], object)..")/100"
        end_pcall()
    elseif (nameBlock=='createJoystick' and infoBlock[2][2][2]~=nil and infoBlock[2][3][2]~=nil and infoBlock[2][4][2]~=nil and infoBlock[2][4][2]~=nil and infoBlock[2][5][2]~=nil and infoBlock[2][6][2]~=nil) then
        add_pcall()
        lua = lua..'\nif (joysticks['..make_all_formulas(infoBlock[2][1], object)..']~=nil) then\ndisplay.remove(joysticks['..make_all_formulas(infoBlock[2][1], object)..'])\nend\nlocal myJoystick = display.newGroup()\njoysticks['..make_all_formulas(infoBlock[2][1], object)..'] = myJoystick\ncameraGroup:insert(myJoystick)'
        lua = lua..'\nmyJoystick.joystick1 = display.newImage("'..obj_path..'/image_'..infoBlock[2][2][2]..'.png", system.DocumentsDirectory)\nmyJoystick:insert(myJoystick.joystick1)'
        lua = lua..'\nmyJoystick.joystick2 = display.newImage("'..obj_path..'/image_'..infoBlock[2][3][2]..'.png", system.DocumentsDirectory)\nmyJoystick:insert(myJoystick.joystick2)'
        lua = lua..'\nmyJoystick:addEventListener("touch", function(event)\nif (event.phase=="began") then\ndisplay.getCurrentStage():setFocus(event.target, event.id)\nelseif (event.phase=="ended") then\ndisplay.getCurrentStage():setFocus(event.target, nil)\nend\nlocal joystick = event.target.joystick2\nif (event.phase=="ended" or event.phase=="cancelled") then\njoystick.x, joystick.y = 0, 0\nelse\nlocal width = event.target.joystick1.width*event.target.joystick1.xScale/2\nlocal height = event.target.joystick1.height*event.target.joystick1.yScale/2\nlocal direction = math.atan2(event.x-event.target.x-mainGroup.x, (event.y-event.target.y-mainGroup.y))local radius = math.sqrt(math.pow(event.x-event.target.x-mainGroup.x, 2)+math.pow(event.y-event.target.y-mainGroup.y, 2))\njoystick.x, joystick.y = math.sin(direction)*math.min(radius, width*event.target.xScale)/event.target.xScale*mainGroup.xScale, math.cos(direction)*math.min(radius, height*event.target.yScale)/event.target.yScale/mainGroup.yScale\nend\n'..(infoBlock[2][4][1]=="globalVariable" and "" or "target.")..'var_'..infoBlock[2][4][2]..', '..(infoBlock[2][5][1]=="globalVariable" and "" or "target.")..'var_'..infoBlock[2][5][2]..' = joystick.x, -joystick.y\nif ('..(infoBlock[2][4][1]=="globalVariable" and "" or "target.")..'varText_'..infoBlock[2][4][2]..'~=nil) then\n'..(infoBlock[2][4][1]=="globalVariable" and "" or "target.")..'varText_'..infoBlock[2][4][2]..'.text = joystick.x\nend\nif ('..(infoBlock[2][5][1]=="globalVariable" and "" or "target.")..'varText_'..infoBlock[2][5][2]..'~=nil) then\n'..(infoBlock[2][5][1]=="globalVariable" and "" or "target.")..'varText_'..infoBlock[2][5][2]..'.text = -joystick.y\nend\nlocal key = target.parent_obj.nameObject\nfor i=1, #events_function[key]["fun_'..infoBlock[2][6][2]..'"] do\n\
        events_function[key]["fun_'..infoBlock[2][6][2]..'"][i](target)\
        \nend\nreturn(true)\nend)'
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
    elseif (nameBlock == 'deleteWebView') then
        add_pcall()
        lua = lua.."\nlocal answer = "..make_all_formulas(infoBlock[2][1], object).."\ndisplay.remove(WebViews[answer])\nWebViews[answer] = nil"
        end_pcall()
    elseif (nameBlock=='isSensor') then
        add_pcall()
        lua = lua.."\ntarget.isSensor = "..(infoBlock[2][1][2]=="on" and "false" or "true")
        end_pcall()
    end
    return(lua)
end

return(make_block)