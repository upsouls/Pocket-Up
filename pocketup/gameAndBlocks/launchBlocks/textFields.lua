return {
    createTextField = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if infoBlock[2][5][2]~=nil then
            local lua = "pcall(function()\n"
            lua = lua.."if (textFields["..make_all_formulas(infoBlock[2][1], object).."] ~= nil) then\ndisplay.remove(textFields["..make_all_formulas(infoBlock[2][1], object).."])\nend\nlocal myTextField = native.newTextField(0, 0, "..make_all_formulas(infoBlock[2][3], object)..", "..make_all_formulas(infoBlock[2][4], object)..")\nmyTextField.hasBackground = "..(infoBlock[2][2][2]=="off" and "true" or "false").."\ntextFields["..make_all_formulas(infoBlock[2][1], object).."] = myTextField\ncameraGroup:insert(myTextField)\nmyTextField:addEventListener('userInput', function(event)\nif (event.phase=='editing') then\n"..(infoBlock[2][5][1]=="localVariable" and "target." or "").."var_"..(infoBlock[2][5][2]).."=myTextField.text\nif ("..(infoBlock[2][5][1]=="localVariable" and "target." or "").."varText_"..(infoBlock[2][5][2]).."~=nil and "..(infoBlock[2][5][1]=="localVariable" and "target." or "").."varText_"..(infoBlock[2][5][2])..".x~=nil) then\n"..(infoBlock[2][5][1]=="localVariable" and "target." or "").."varText_"..(infoBlock[2][5][2])..".text=myTextField.text\nend\nend\nend)"
            return lua.."\nend)"
        end
    end,

    deleteTextField = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."display.remove(textFields["..make_all_formulas(infoBlock[2][1], object).."])"
        return lua.."\nend)"
    end,

    removeCameraTextField = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."notCameraGroup:insert(textFields["..make_all_formulas(infoBlock[2][1], object).."])"
        return lua.."\nend)"
    end,

    insertCameraTextField = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."cameraGroup:insert(textFields["..make_all_formulas(infoBlock[2][1], object).."])"
        return lua.."\nend)"
    end,

    setPositionTextField = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."textFields["..make_all_formulas(infoBlock[2][1], object).."].x, textFields["..make_all_formulas(infoBlock[2][1], object).."].y = "..make_all_formulas(infoBlock[2][2], object)..", -"..make_all_formulas(infoBlock[2][3], object)
        return lua.."\nend)"
    end,

    editPositionTextField = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."textFields["..make_all_formulas(infoBlock[2][1], object).."]:translate("..make_all_formulas(infoBlock[2][2], object)..", -"..make_all_formulas(infoBlock[2][3], object)..")"
        return lua.."\nend)"
    end,

    setFontSizeTextField = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."textFields["..make_all_formulas(infoBlock[2][1], object).."].size = "..make_all_formulas(infoBlock[2][2], object)
        return lua.."\nend)"
    end,

    setTypeInputTextField = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."textFields["..make_all_formulas(infoBlock[2][1], object).."].inputType = '"..infoBlock[2][2][2].."'"
        return lua.."\nend)"
    end,

    setAlignTextField = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."textFields["..make_all_formulas(infoBlock[2][1], object).."].align = '"..infoBlock[2][2][2].."'"
        return lua.."\nend)"
    end,

    isSecureTextField = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."textFields["..make_all_formulas(infoBlock[2][1], object).."].isSecure = "..(infoBlock[2][2][2]=="on" and "true" or "false")
        return lua.."\nend)"
    end,

    placeholderTextField = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."textFields["..make_all_formulas(infoBlock[2][1], object).."].placeholder = "..make_all_formulas(infoBlock[2][2], object)
        return lua.."\nend)"
    end,

    valueTextField = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."textFields["..make_all_formulas(infoBlock[2][1], object).."].text = "..make_all_formulas(infoBlock[2][2], object)
        return lua.."\nend)"
    end,

    setColorTextField = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."local rgb = utils.hexToRgb("..make_all_formulas(infoBlock[2][2], object)..")\ntextFields["..make_all_formulas(infoBlock[2][1], object).."]:setTextColor(rgb[1], rgb[2], rgb[3])"
        return lua.."\nend)"
    end,

    setSelectionTextField = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."native.setKeyboardFocus( textFields["..make_all_formulas(infoBlock[2][1], object).."] )\ntextFields["..make_all_formulas(infoBlock[2][1], object).."]:setSelection("..make_all_formulas(infoBlock[2][2], object).."-1, "..make_all_formulas(infoBlock[2][3], object)..")"
        return lua.."\nend)"
    end,

    getSelectionTextField = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."local startPos, endPos = textFields["..make_all_formulas(infoBlock[2][1], object).."]:getSelection()\n"..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2].." = plugins.utf8.sub(textFields["..make_all_formulas(infoBlock[2][1], object).."].text, startPos+1, endPos)"
        return lua.."\nend)"
    end,

    setKeyboardToTextField = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."native.setKeyboardFocus( textFields["..make_all_formulas(infoBlock[2][1], object).."] )"
        return lua.."\nend)"
    end,

    removeKeyboardToTextField = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = ""
        lua = lua.."native.setKeyboardFocus( nil )"
        return lua
    end,
}