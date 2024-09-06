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
    	lua = lua.."local function funEditingEnd(event)\n"..(infoBlock[2][2][1]=="globalVariable" and "" or "taret.").."var_"..infoBlock[2][2][2].." = event.isOk and event.value or ''\nif ("..(infoBlock[2][2][1]=="globalVariable" and "" or "taret.").."varText_"..infoBlock[2][2][2].." ~= nil and "..(infoBlock[2][2][1]=="globalVariable" and "" or "taret.").."varText_"..infoBlock[2][2][2]..".x ~= nil) then\n"..(infoBlock[2][2][1]=="globalVariable" and "" or "taret.").."varText_"..infoBlock[2][2][2]..".text = event.isOk and event.value or ''\nlocal key = target.nameObject\nlocal value = target\nfor i=1, #events_function[key]['fun_"..infoBlock[2][3][2].."'] do\nevents_function[key]['fun_"..infoBlock[2][3][2].."'][i](value)\nend\nend\nend\ncerberus.newInputLine("..make_all_formulas(infoBlock[2][1], object)..", '', nil, '', funEditingEnd)"
        end_pcall()
    elseif (nameBlock == "createTextField" and infoBlock[2][5][2]~=nil) then
        add_pcall()
        lua = lua.."if (textFields["..make_all_formulas(infoBlock[2][1], object).."] ~= nil) then\ndisplay.remove(textFields["..make_all_formulas(infoBlock[2][1], object).."])\nend\nlocal myTextField = native.newTextField(0, 0, "..make_all_formulas(infoBlock[2][3], object)..", "..make_all_formulas(infoBlock[2][4], object)..")\nmyTextField.hasBackground = "..(infoBlock[2][2][2]=="on" and "true" or "false").."\ntextFields["..make_all_formulas(infoBlock[2][1], object).."] = myTextField\ncameraGroup:insert(myTextField)\nmyTextField:addEventListener('userInput', function(event)\nif (event.phase=='editing') then\n"..(infoBlock[2][5][1]=="localVariable" and "target." or "").."var_"..(infoBlock[2][5][2]).."=myTextField.text\nif ("..(infoBlock[2][5][1]=="localVariable" and "target." or "").."varText_"..(infoBlock[2][5][2]).."~=nil and "..(infoBlock[2][5][1]=="localVariable" and "target." or "").."varText_"..(infoBlock[2][5][2])..".x~=nil) then\n"..(infoBlock[2][5][1]=="localVariable" and "target." or "").."varText_"..(infoBlock[2][5][2])..".text=myTextField.text\nend\nend\nend)"
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
        lua = lua.."local startPos, endPos = textFields["..make_all_formulas(infoBlock[2][1], object).."]:getSelection()\n"..(infoBlock[2][2][1]=="globalVariable" and "" or "taret.").."var_"..infoBlock[2][2][2].." = utf8.sub(textFields["..make_all_formulas(infoBlock[2][1], object).."].text, startPos+1, endPos)"
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
    end
    return(lua)
end

return(make_block)