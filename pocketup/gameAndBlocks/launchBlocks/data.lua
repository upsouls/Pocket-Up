return {
    setVariable = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if infoBlock[2][1][2]~=nil then
            local value = make_all_formulas(infoBlock[2][2], object)
            local lua = "pcall(function()\n"
            if infoBlock[2][1][1] == 'globalVariable' then
                lua = lua..'var_'..infoBlock[2][1][2]..' = '..value..'\n'
                lua = lua..
                'if varText_'..infoBlock[2][1][2]..' then\
                varText_'..infoBlock[2][1][2]..'.text = type(var_'..infoBlock[2][1][2]..')=="boolean" and (var_'..infoBlock[2][1][2]..' and app.words[373] or app.words[374]) or type(var_'..infoBlock[2][1][2]..')=="table" and encodeList(var_'..infoBlock[2][1][2]..') or var_'..infoBlock[2][1][2]..'\
                end'
            else
                lua = lua..'target.var_'..infoBlock[2][1][2]..' = '..value..'\n'
                lua = lua..
                'if target.varText_'..infoBlock[2][1][2]..' then\
                target.varText_'..infoBlock[2][1][2]..'.text = type(target.var_'..infoBlock[2][1][2]..')=="boolean" and (target.var_'..infoBlock[2][1][2]..' and app.words[373] or app.words[374]) or type(target.var_'..infoBlock[2][1][2]..')=="table" and encodeList(target.var_'..infoBlock[2][1][2]..') or target.var_'..infoBlock[2][1][2]..'\
                end'
            end
            return lua.."\nend)"
        end
    end,

    editVariable = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if infoBlock[2][1][2]~=nil then
            local value = make_all_formulas(infoBlock[2][2], object)
            local lua = "pcall(function()\n"
            if infoBlock[2][1][1] == 'globalVariable' then
                lua = lua..'var_'..infoBlock[2][1][2]..' = type(var_'..infoBlock[2][1][2]..')=="boolean" and (var_'..infoBlock[2][1][2]..' and app.words[373] or app.words[374]) or type(var_'..infoBlock[2][1][2]..')=="table" and encodeList(var_'..infoBlock[2][1][2]..') or var_'..infoBlock[2][1][2]..'+('..make_all_formulas(infoBlock[2][2], object)..')\n'
                lua = lua..
                'if varText_'..infoBlock[2][1][2]..' then\
                varText_'..infoBlock[2][1][2]..'.text = var_'..infoBlock[2][1][2]..'\
                end'
            else
                lua = lua..'target.var_'..infoBlock[2][1][2]..' = target.var_'..infoBlock[2][1][2]..' + '..value..'\n'
                lua = lua..
                'if target.varText_'..infoBlock[2][1][2]..' then\
                target.varText_'..infoBlock[2][1][2]..'.text = type(target.var_'..infoBlock[2][1][2]..')=="boolean" and (target.var_'..infoBlock[2][1][2]..' and app.words[373] or app.words[374]) or type(target.var_'..infoBlock[2][1][2]..')=="table" and encodeList(target.var_'..infoBlock[2][1][2]..') or target.var_'..infoBlock[2][1][2]..'\
                end'
            end
            return lua.."\nend)"
        end
    end,

    showVariable = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if infoBlock[2][1][2]~=nil then
            local x = make_all_formulas(infoBlock[2][2], object)
            local y = make_all_formulas(infoBlock[2][3], object)
            local lua = "pcall(function()\n"
            if infoBlock[2][1][1] == 'globalVariable' then
                lua = lua..'if (varText_'..infoBlock[2][1][2]..'~=nil and varText_'..infoBlock[2][1][2]..'.text~=nil) then\ndisplay.remove(varText_'..infoBlock[2][1][2]..')\nend\nvarText_'..infoBlock[2][1][2]..' = display.newText(type(var_'..infoBlock[2][1][2]..')=="boolean" and (var_'..infoBlock[2][1][2]..' and app.words[373] or app.words[374]) or type(var_'..infoBlock[2][1][2]..')=="table" and encodeList(var_'..infoBlock[2][1][2]..') or var_'..infoBlock[2][1][2]..', '..x..', -'..y..', "fonts/font_1", 30)\n'
                lua = lua..'varText_'..infoBlock[2][1][2]..':setFillColor(0, 0, 0)'
                lua = lua.."\ncameraGroup:insert(varText_"..infoBlock[2][1][2]..")"
            else
                lua = lua..'if (target.varText_'..infoBlock[2][1][2]..'~=nil and target.varText_'..infoBlock[2][1][2]..'.text~=nil) then\ndisplay.remove(target.varText_'..infoBlock[2][1][2]..')\nend\ntarget.varText_'..infoBlock[2][1][2]..' = display.newText(type(target.var_'..infoBlock[2][1][2]..')=="boolean" and (target.var_'..infoBlock[2][1][2]..' and app.words[373] or app.words[374]) or type(target.var_'..infoBlock[2][1][2]..')=="table" and encodeList(target.var_'..infoBlock[2][1][2]..') or target.var_'..infoBlock[2][1][2]..', '..x..', -'..y..', "fonts/font_1", 30)\n'
                lua = lua..'target.varText_'..infoBlock[2][1][2]..':setFillColor(0, 0, 0)'
                lua = lua.."\ncameraGroup:insert(target.varText_"..infoBlock[2][1][2]..")"
            end
            return lua.."\nend)"
        end
    end,

    showVariable2 = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if infoBlock[2][1][2]~=nil then
            local x = make_all_formulas(infoBlock[2][2], object)
            local y = make_all_formulas(infoBlock[2][3], object)
            local size = make_all_formulas(infoBlock[2][4], object)
            local hex = make_all_formulas(infoBlock[2][5], object)
            local aligh = infoBlock[2][6][2]
            local lua = "pcall(function()\n"
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
            return lua.."\nend)"
        end
    end,

    setAnchorVariable = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if infoBlock[2][1][2]~=nil then
            local lua = "pcall(function()\n"
            lua = lua..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..".anchorX, "..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..".anchorY = "..make_all_formulas(infoBlock[2][2], object).."/100, "..make_all_formulas(infoBlock[2][3], object).."/100"
            return lua.."\nend)"
        end
    end,

    hideVariable = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if infoBlock[2][1][2]~=nil then
            local lua = "pcall(function()\n"
            if infoBlock[2][1][1] == 'globalVariable' then
                lua = lua..'display.remove(varText_'..infoBlock[2][1][2]..')\nvarText_'..infoBlock[2][1][2]..' = nil'
            else
                lua = lua..'display.remove(target.varText_'..infoBlock[2][1][2]..')\ntarget.varText_'..infoBlock[2][1][2]..' = nil'
            end
            return lua.."\nend)"
        end
    end,

    insertVariableCamera = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if infoBlock[2][1][2]~=nil then
            local lua = "pcall(function()\n"
            lua = lua.."if ("..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2].."~=nil and "..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..".text ~= nil) then\ncameraGroup:insert("..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..")\nend"
            return lua.."\nend)"
        end
    end,

    removeVariableCamera = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if infoBlock[2][1][2]~=nil then
            local lua = "pcall(function()\n"
            lua = lua.."if ("..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2].."~=nil and "..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..".text ~= nil) then\nnotCameraGroup:insert("..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..")\nend"
            return lua.."\nend)"
        end
    end,

    saveVariable = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if infoBlock[2][1][2]~=nil then
            local lua = "pcall(function()\n"
            lua = lua..'local arrayVariables = plugins.json.decode(funsP["получить сохранение"]("'..(infoBlock[2][1][1]=="globalVariable" and app.idProject or obj_path)..'/variables"))'
            lua = lua..'\nfor i=1, #arrayVariables do\nif (arrayVariables[i][1]=='..infoBlock[2][1][2]..') then\narrayVariables[i][3] = '..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..'\nfunsP["записать сохранение"]("'..(infoBlock[2][1][1]=="globalVariable" and app.idProject or obj_path)..'/variables", plugins.json.encode(arrayVariables))\nbreak\nend\nend'
            return lua.."\nend)"
        end
    end,

    readVariable = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if infoBlock[2][1][2]~=nil then
            local lua = "pcall(function()\n"
            lua = lua..'local arrayVariables = plugins.json.decode(funsP["получить сохранение"]("'..(infoBlock[2][1][1]=="globalVariable" and app.idProject or obj_path)..'/variables"))'
            lua = lua..'\nfor i=1, #arrayVariables do\nif (arrayVariables[i][1]=='..infoBlock[2][1][2]..') then\n'..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..'= arrayVariables[i][3]~=nil and arrayVariables[i][3] or 0\nbreak\nend\nend'
            lua = lua..'\nif '..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'varText_'..infoBlock[2][1][2]..' then\n '..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'varText_'..infoBlock[2][1][2]..'.text = type('..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..')=="boolean" and ('..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..' and app.words[373] or app.words[374]) or type('..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..')=="table" and encodeList('..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..') or '..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..'\nend'
            return lua.."\nend)"
        end
    end,

    addElementArray = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if infoBlock[2][2][2]~=nil then
            local lua = "pcall(function()\n"
            lua = lua..(infoBlock[2][2][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][2][2].."[#"..(infoBlock[2][2][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][2][2].."+1] = "..make_all_formulas(infoBlock[2][1], object)
            return lua.."\nend)"
        end
    end,

    deleteElementArray = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if infoBlock[2][1][2]~=nil then
            local lua = "pcall(function()\n"
            lua = lua.."table.remove("..(infoBlock[2][1][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][1][2]..", "..make_all_formulas(infoBlock[2][2],object)..")"
            return lua.."\nend)"
        end
    end,

    deleteAllElementsArray = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if infoBlock[2][1][2]~=nil then
            local lua = "pcall(function()\n"
            lua = lua..(infoBlock[2][1][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][1][2].." = {}"
            return lua.."\nend)"
        end
    end,

    pasteElementArray = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if infoBlock[2][2][2]~=nil then
            local lua = "pcall(function()\n"
            lua = lua.."if ("..make_all_formulas(infoBlock[2][3], object).."<=#"..(infoBlock[2][2][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][2][2].."+1 and "..make_all_formulas(infoBlock[2][3], object)..">0) then\ntable.insert("..(infoBlock[2][2][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][2][2]..", "..make_all_formulas(infoBlock[2][3], object)..", "..make_all_formulas(infoBlock[2][1], object)..")\nend"
            return lua.."\nend)"
        end
    end,

    replaceElementArray = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if infoBlock[2][1][2]~=nil then
            local lua = "pcall(function()\n"
            lua = lua.."if ("..make_all_formulas(infoBlock[2][2], object).."<=#"..(infoBlock[2][1][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][1][2].."+1 and "..make_all_formulas(infoBlock[2][2], object)..">0) then\n"..(infoBlock[2][1][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][1][2].."["..make_all_formulas(infoBlock[2][2],object).."] = "..make_all_formulas(infoBlock[2][3],object).."\nend"
            return lua.."\nend)"
        end
    end,

    saveArray = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if infoBlock[2][1][2]~=nil then
            local lua = "pcall(function()\n"
            lua = lua..'local arrayArrays = plugins.json.decode(funsP["получить сохранение"]("'..(infoBlock[2][1][1]=="globalArray" and app.idProject or obj_path)..'/arrays"))'
            lua = lua..'\nfor i=1, #arrayArrays do\nif (arrayArrays[i][1]=='..infoBlock[2][1][2]..') then\narrayArrays[i][3] = '..(infoBlock[2][1][1]=="globalArray" and '' or 'target.')..'list_'..infoBlock[2][1][2]..'\nfunsP["записать сохранение"]("'..(infoBlock[2][1][1]=="globalArray" and app.idProject or obj_path)..'/arrays", plugins.json.encode(arrayArrays))\nbreak\nend\nend\n'
            return lua.."\nend)"
        end
    end,

    readArray = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if infoBlock[2][1][2]~=nil then
            local lua = "pcall(function()\n"
            lua = lua..'local arrayArrays = plugins.json.decode(funsP["получить сохранение"]("'..(infoBlock[2][1][1]=="globalArray" and app.idProject or obj_path)..'/arrays"))'
            lua = lua..'\nfor i=1, #arrayArrays do\nif (arrayArrays[i][1]=='..infoBlock[2][1][2]..') then\n'..(infoBlock[2][1][1]=="globalArray" and '' or 'target.')..'list_'..infoBlock[2][1][2]..'= arrayArrays[i][3]~=nil and arrayArrays[i][3] or {}\nbreak\nend\nend'
            return lua.."\nend)"
        end
    end,

    columnStorageToArray = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if infoBlock[2][3][2]~=nil then
            local lua = "pcall(function()\n"
            lua = lua.."local allArraysValues = plugins.json.decode('[\"'.."..make_all_formulas(infoBlock[2][2], object)..":gsub('\"','\\\\\"'):gsub('\\r\\n','\",\"'):gsub('\\n','\",\"')..'\"]')"
            lua = lua.."\nfor i=1, #allArraysValues do\nlocal values = plugins.json.decode('[\"'..allArraysValues[i]:gsub('\\\"','\\\\\"'):gsub(',','\",\"')..'\"]')\nallArraysValues[i] = values["..make_all_formulas(infoBlock[2][1], object).."]==nil and '' or values["..make_all_formulas(infoBlock[2][1], object).."]\nend"
            lua = lua.."\n"..(infoBlock[2][3][1]=="globalArray" and '' or 'target.').."list_"..infoBlock[2][3][2].." = allArraysValues"
            return lua.."\nend)"
        end
    end,

    getRequest = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if infoBlock[2][2][2]~=nil then
            local lua = "pcall(function()\n"
            lua = lua.."local function networkListener(event)\nif (mainGroup~=nil and mainGroup.x~=nil) then\n"..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2].." = event.response\nif ("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][2][2]..") then\n"..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][2][2]..".text = type("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..")=='boolean' and ("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2].." and app.words[373] or app.words[374]) or type("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..")=='table' and encodeList("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..") or "..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2].."\nend\nend\nend\nlocal header = {headers={[\"User-Agent\"] = \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36\"}}\n\nnetwork.request("..make_all_formulas(infoBlock[2][1],object)..",'GET',networkListener, header)"
            return lua.."\nend)"
        end
    end,

    toFrontLayerVar = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if infoBlock[2][1][2]~=nil then
            local lua = "pcall(function()\n"
            lua = lua..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..":toFront()"
            return lua.."\nend)"
        end
    end,

    toBackLayerVar = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if infoBlock[2][1][2]~=nil then
            local lua = "pcall(function()\n"
            lua = lua..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..":toBack()"
            return lua.."\nend)"
        end
    end,

    fbGetValue = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        local idBase = make_all_formulas(infoBlock[2][2], object)
        local idKey = make_all_formulas(infoBlock[2][1], object)
        local targVar = ''
        local parentShownVar = ''
        if infoBlock[2][3][1] == 'localVariable' then
            targVar = 'target.var_'..infoBlock[2][3][2]
            parentShownVar = 'target.varText_'..infoBlock[2][3][2]
        else
            targVar = 'var_'..infoBlock[2][3][2]
            parentShownVar = 'varText_'..infoBlock[2][3][2]
        end

        lua = lua..[[
            local function _listener(event)
                if event.isError then
                    ]]..targVar..[[ = 'ERROR'
                    ]]..parentShownVar..[[.text = ]]..targVar..[[
                else
                    ]]..targVar..[[ = require 'json'.decode(event.response)
                    ]]..parentShownVar..[[.text = require 'json'.decode(event.response)
                end
            end
            network.request(]]..idBase..'..\'/\'..'..idKey..'..\'.json\''..[[, "GET", _listener)]].."\n"
        return lua.."\nend)"
    end,

    fbSetValue = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        local idBase = make_all_formulas(infoBlock[2][3], object)
        local idKey = make_all_formulas(infoBlock[2][2], object)
        local value = make_all_formulas(infoBlock[2][1], object)

        lua = lua..[[
        local headers = {
            ["Content-Type"] = "application/json"
        }

        local params = {
        headers = headers,
        body = require "json".encode(]]..value..[[)
        }
        local function _listener(event)
        print(require "json".encode(event))
        end
        network.request(]]..idBase..'..\'/\'..'..idKey..'..\'.json\''..[[, "PUT", _listener, params)
        ]]
        return lua.."\nend)"
    end,

    fbDelValue = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        local idBase = make_all_formulas(infoBlock[2][2], object)
        local idKey = make_all_formulas(infoBlock[2][1], object)
        lua = lua..[[
        network.request(]]..idBase..'..\'/\'..'..idKey..'..\'.json\''..[[, "DELETE", nil)
                
        ]]
        return lua.."\nend)"
    end,
}