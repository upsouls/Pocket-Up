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

    if (nameBlock == 'ask' and infoBlock[2][2][2]~=nil and infoBlock[2][3][2]~=nil) then
        add_pcall()
    	lua = lua.."local function funEditingEnd(event)\n"..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2].." = event.isOk and event.value or ''\nif ("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][2][2].." ~= nil and "..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][2][2]..".x ~= nil) then\n"..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][2][2]..".text = event.isOk and event.value or ''\nlocal key = target.parent_obj.nameObject\nlocal value = target\nfor i=1, #events_function[key]['fun_"..infoBlock[2][3][2].."'] do\nevents_function[key]['fun_"..infoBlock[2][3][2].."'][i](value)\nend\nend\nend\ncerberus.newInputLine("..make_all_formulas(infoBlock[2][1], object)..", '', nil, '', funEditingEnd)"
        end_pcall()
    elseif (nameBlock == "createTextField" and infoBlock[2][5][2]~=nil) then
        add_pcall()
        lua = lua.."if (textFields["..make_all_formulas(infoBlock[2][1], object).."] ~= nil) then\ndisplay.remove(textFields["..make_all_formulas(infoBlock[2][1], object).."])\nend\nlocal myTextField = native.newTextField(0, 0, "..make_all_formulas(infoBlock[2][3], object)..", "..make_all_formulas(infoBlock[2][4], object)..")\nmyTextField.hasBackground = "..(infoBlock[2][2][2]=="off" and "true" or "false").."\ntextFields["..make_all_formulas(infoBlock[2][1], object).."] = myTextField\ncameraGroup:insert(myTextField)\nmyTextField:addEventListener('userInput', function(event)\nif (event.phase=='editing') then\n"..(infoBlock[2][5][1]=="localVariable" and "target." or "").."var_"..(infoBlock[2][5][2]).."=myTextField.text\nif ("..(infoBlock[2][5][1]=="localVariable" and "target." or "").."varText_"..(infoBlock[2][5][2]).."~=nil and "..(infoBlock[2][5][1]=="localVariable" and "target." or "").."varText_"..(infoBlock[2][5][2])..".x~=nil) then\n"..(infoBlock[2][5][1]=="localVariable" and "target." or "").."varText_"..(infoBlock[2][5][2])..".text=myTextField.text\nend\nend\nend)"
        end_pcall()
    elseif (nameBlock == "setPositionTextField") then
        add_pcall()
        lua = lua.."textFields["..make_all_formulas(infoBlock[2][1], object).."].x, textFields["..make_all_formulas(infoBlock[2][1], object).."].y = "..make_all_formulas(infoBlock[2][2], object)..", -"..make_all_formulas(infoBlock[2][3], object)
        end_pcall()
    elseif (nameBlock == "editPositionTextField") then
        add_pcall()
        lua = lua.."textFields["..make_all_formulas(infoBlock[2][1], object).."]:translate("..make_all_formulas(infoBlock[2][2], object)..", -"..make_all_formulas(infoBlock[2][3], object)..")"
        end_pcall()
    elseif (nameBlock=='setFontSizeTextField') then
        add_pcall()
        lua = lua.."textFields["..make_all_formulas(infoBlock[2][1], object).."].size = "..make_all_formulas(infoBlock[2][2], object)
        end_pcall()
    elseif (nameBlock=='setTypeInputTextField') then
        add_pcall()
        lua = lua.."textFields["..make_all_formulas(infoBlock[2][1], object).."].inputType = '"..infoBlock[2][2][2].."'"
        end_pcall()
    elseif (nameBlock=='setAlignTextField') then
        add_pcall()
        lua = lua.."textFields["..make_all_formulas(infoBlock[2][1], object).."].align = '"..infoBlock[2][2][2].."'"
        end_pcall()
    elseif (nameBlock=='deleteTextField') then
        add_pcall()
        lua = lua.."display.remove(textFields["..make_all_formulas(infoBlock[2][1], object).."])"
        end_pcall()
    elseif (nameBlock=='isSecureTextField') then
        add_pcall()
        lua = lua.."textFields["..make_all_formulas(infoBlock[2][1], object).."].isSecure = "..(infoBlock[2][2][2]=="on" and "true" or "false")
        end_pcall()
    elseif (nameBlock=='placeholderTextField') then
        add_pcall()
        lua = lua.."textFields["..make_all_formulas(infoBlock[2][1], object).."].placeholder = "..make_all_formulas(infoBlock[2][2], object)
        end_pcall()
    elseif (nameBlock=='valueTextField') then
        add_pcall()
        lua = lua.."textFields["..make_all_formulas(infoBlock[2][1], object).."].text = "..make_all_formulas(infoBlock[2][2], object)
        end_pcall()
    elseif (nameBlock=='setColorTextField') then
        add_pcall()
        lua = lua.."local rgb = hexToRgb("..make_all_formulas(infoBlock[2][2], object)..")\ntextFields["..make_all_formulas(infoBlock[2][1], object).."]:setTextColor(rgb[1], rgb[2], rgb[3])"
        end_pcall()
    elseif (nameBlock=='setSelectionTextField') then
        add_pcall()
        lua = lua.."native.setKeyboardFocus( textFields["..make_all_formulas(infoBlock[2][1], object).."] )\ntextFields["..make_all_formulas(infoBlock[2][1], object).."]:setSelection("..make_all_formulas(infoBlock[2][2], object).."-1, "..make_all_formulas(infoBlock[2][3], object)..")"
        end_pcall()
    elseif (nameBlock=='getSelectionTextField') then
        add_pcall()
        lua = lua.."local startPos, endPos = textFields["..make_all_formulas(infoBlock[2][1], object).."]:getSelection()\n"..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2].." = utf8.sub(textFields["..make_all_formulas(infoBlock[2][1], object).."].text, startPos+1, endPos)"
        end_pcall()
    elseif (nameBlock=='setKeyboardToTextField') then
        add_pcall()
        lua = lua.."native.setKeyboardFocus( textFields["..make_all_formulas(infoBlock[2][1], object).."] )"
        end_pcall()
    elseif (nameBlock=='removeKeyboardToTextField') then
        add_pcall()
        lua = lua.."native.setKeyboardFocus( nil )"
        end_pcall()
    elseif (nameBlock=='insertCameraTextField') then
        add_pcall()
        lua = lua.."cameraGroup:insert(textFields["..make_all_formulas(infoBlock[2][1], object).."])"
        end_pcall()
    elseif (nameBlock=='removeCameraTextField') then
        add_pcall()
        lua = lua.."notCameraGroup:insert(textFields["..make_all_formulas(infoBlock[2][1], object).."])"
        end_pcall()
    elseif (nameBlock=='setQuareHitbox') then
        add_pcall()
        lua = lua.."target.physicsTable.outline, target.physicsTable.shape, target.physicsTable.radius = nil, nil, nil\ntarget:physicsReload()"
        end_pcall()
    elseif (nameBlock=='setQuareWHHitbox') then
        add_pcall()
        lua = lua.."local w = "..make_all_formulas(infoBlock[2][1], object).."/2\nlocal h = "..make_all_formulas(infoBlock[2][2], object).."/2\ntarget.physicsTable.outline, target.physicsTable.radius, target.physicsTable.shape = nil, nil, {-w, -h, -w, h, w, h, w, -h}\ntarget:physicsReload()"
        end_pcall()
    elseif (nameBlock=='setCircleHitbox') then
        add_pcall()
        lua = lua.."target.physicsTable.radius, target.physicsTable.outline, target.physicsTable.shape = "..make_all_formulas(infoBlock[2][1], object)..", nil, nil\ntarget:physicsReload()"
        end_pcall()
    elseif (nameBlock=='setShapeHitbox') then
        add_pcall()
        lua = lua.."local tableShape = json.decode('"..infoBlock[2][1][2].."')\nlocal tableResizeShape = {}\nlocal size = target.property_size/100\nfor i=1, #tableShape/2 do\ntableResizeShape[i*2-1], tableResizeShape[i*2] = tableShape[i*2-1]*size, tableShape[i*2]*size\nend\ntarget.physicsTable.radius, target.physicsTable.outline, target.physicsTable.shape = nil, nil, tableResizeShape\ntarget:physicsReload()"
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
    elseif (nameBlock=='setLayer') then
        add_pcall()
        lua = lua.."target.group:insert("..make_all_formulas(infoBlock[2][1], object).."+3, target)"
        end_pcall()
    elseif (nameBlock=='setAnchor') then
        add_pcall()
        lua = lua.."target.anchorX, target.anchorY = "..make_all_formulas(infoBlock[2][1], object).."/100, "..make_all_formulas(infoBlock[2][2], object).."/100"
        end_pcall()
    elseif (nameBlock=='createJoystick' and infoBlock[2][2][2]~=nil and infoBlock[2][3][2]~=nil and infoBlock[2][4][2]~=nil and infoBlock[2][4][2]~=nil and infoBlock[2][5][2]~=nil and infoBlock[2][6][2]~=nil) then
        add_pcall()
        lua = lua..'if (joysticks['..make_all_formulas(infoBlock[2][1], object)..']~=nil) then\ndisplay.remove(joysticks['..make_all_formulas(infoBlock[2][1], object)..'])\nend\nlocal myJoystick = display.newGroup()\njoysticks['..make_all_formulas(infoBlock[2][1], object)..'] = myJoystick\ncameraGroup:insert(myJoystick)'
        lua = lua..'\nmyJoystick.joystick1 = display.newImage("'..obj_path..'/image_'..infoBlock[2][2][2]..'.png", system.DocumentsDirectory)\nmyJoystick:insert(myJoystick.joystick1)'
        lua = lua..'myJoystick.joystick2 = display.newImage("'..obj_path..'/image_'..infoBlock[2][3][2]..'.png", system.DocumentsDirectory)\nmyJoystick:insert(myJoystick.joystick2)'
        lua = lua..'myJoystick:addEventListener("touch", function(event)\nif (event.phase=="began") then\ndisplay.getCurrentStage():setFocus(event.target, event.id)\nelseif (event.phase=="ended") then\ndisplay.getCurrentStage():setFocus(event.target, nil)\nend\nlocal joystick = event.target.joystick2\nif (event.phase=="ended" or event.phase=="cancelled") then\njoystick.x, joystick.y = 0, 0\nelse\nlocal width = event.target.joystick1.width*event.target.joystick1.xScale/2\nlocal height = event.target.joystick1.height*event.target.joystick1.yScale/2\nlocal direction = math.atan2(event.x-event.target.x-mainGroup.x, (event.y-event.target.y-mainGroup.y))local radius = math.sqrt(math.pow(event.x-event.target.x-mainGroup.x, 2)+math.pow(event.y-event.target.y-mainGroup.y, 2))\nprint(radius)\njoystick.x, joystick.y = math.sin(direction)*math.min(radius, width*event.target.xScale)/event.target.xScale*mainGroup.xScale, math.cos(direction)*math.min(radius, height*event.target.yScale)/event.target.yScale/mainGroup.yScale\nend\n'..(infoBlock[2][4][1]=="globalVariable" and "" or "target.")..'var_'..infoBlock[2][4][2]..', '..(infoBlock[2][5][1]=="globalVariable" and "" or "target.")..'var_'..infoBlock[2][5][2]..' = joystick.x, -joystick.y\nif ('..(infoBlock[2][4][1]=="globalVariable" and "" or "target.")..'varText_'..infoBlock[2][4][2]..'~=nil) then\n'..(infoBlock[2][4][1]=="globalVariable" and "" or "target.")..'varText_'..infoBlock[2][4][2]..'.text = joystick.x\nend\nif ('..(infoBlock[2][5][1]=="globalVariable" and "" or "target.")..'varText_'..infoBlock[2][5][2]..'~=nil) then\n'..(infoBlock[2][5][1]=="globalVariable" and "" or "target.")..'varText_'..infoBlock[2][5][2]..'.text = -joystick.y\nend\nlocal key = target.parent_obj.nameObject\nfor i=1, #events_function[key]["fun_'..infoBlock[2][6][2]..'"] do\nevents_function[key]["fun_'..infoBlock[2][6][2]..'"][i](target)\nend\nreturn(true)\nend)'
        end_pcall()
    elseif (nameBlock=='setPositionJoystick') then
         add_pcall()
         lua = lua..'local joystick = joysticks['..make_all_formulas(infoBlock[2][1], object)..']\njoystick.x, joystick.y = '..make_all_formulas(infoBlock[2][2], object)..', -'..make_all_formulas(infoBlock[2][3], object)
         end_pcall()
    elseif (nameBlock=='setSizeJoystick') then
        add_pcall()
        lua = lua..'local joystick = joysticks['..make_all_formulas(infoBlock[2][1], object)..']\njoystick.xScale = '..make_all_formulas(infoBlock[2][2], object)..'/100\njoystick.yScale = joystick.xScale'
        end_pcall()
    elseif (nameBlock=='setSizeJoystick1') then
        add_pcall()
        lua = lua..'local joystick = joysticks['..make_all_formulas(infoBlock[2][1], object)..'].joystick1\njoystick.xScale = '..make_all_formulas(infoBlock[2][2], object)..'/100\njoystick.yScale = joystick.xScale'
        end_pcall()
    elseif (nameBlock=='setSizeJoystick2') then
        add_pcall()
        lua = lua..'local joystick = joysticks['..make_all_formulas(infoBlock[2][1], object)..'].joystick2\njoystick.xScale = '..make_all_formulas(infoBlock[2][2], object)..'/100\njoystick.yScale = joystick.xScale'
        end_pcall()
    elseif (nameBlock=='cameraInsertJoystick') then
        add_pcall()
        lua = lua..'cameraGroup:insert(joysticks['..make_all_formulas(infoBlock[2][1], object)..'])'
        end_pcall()
    elseif (nameBlock=='cameraRemoveJoystick') then
        add_pcall()
        lua = lua..'notCameraGroup:insert(joysticks['..make_all_formulas(infoBlock[2][1], object)..'])'
        end_pcall()
    end
    return(lua)
end

return(make_block)