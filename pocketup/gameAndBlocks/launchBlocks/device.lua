return {
    openLink = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        local link = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."system.openURL("..link..")"
        return lua.."\nend)"
    end,

    blockTouch = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = ""
        lua = lua..
        'for i=1, #events_touchObject, 1 do\
        events_touchObject[i](target)\
        end'
        return lua
    end,

    blockTouchScreen = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = ""
        lua = lua..
        'for key, value in pairs(objects) do\
        for i=1, #events_touchScreen[key] do\
        events_touchScreen[key][i](value)\
        for i2=1, #value.clones do\
        events_touchScreen[key][i](value.clones[i2])\
        end\
        end\
        end'
        return lua
    end,

    showToast = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        local arg1 = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."if not utils.isSim and not utils.isWin then\
            require('plugin.toaster').shortToast("..arg1..")\
        end\n"
        return lua.."\nend)"
    end,

    runLua = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        local code = make_all_formulas(infoBlock[2][1], object)
        
        lua = lua..'pcall(function()\nloadstring('..code..')()\nend)\n'
        print(lua)
        return lua.."\nend)"
    end,

    setHorizontalOrientation = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o, mainGroup)
        local lua = "pcall(function()\n"
        lua = lua.."CENTER_X = display.contentCenterX\nCENTER_Y = display.screenOriginY+display.contentHeight/2\nplugins.orientation.lock('landscape')\nmainGroup.xScale, mainGroup.yScale = "..tostring(not options.aspectRatio and mainGroup[2] or mainGroup[1])..", "..tostring(mainGroup[1]).."\nmainGroup.x, mainGroup.y = CENTER_Y, CENTER_X\nblackRectTop.width, blackRectTop.height = display.contentHeight, display.contentWidth\nblackRectTop.x, blackRectTop.y = "..("-"..tostring(options.displayHeight/2)..",0" ).."\nblackRectTop.anchorX, blackRectTop.anchorY = 1, 0.5\nblackRectBottom.width, blackRectBottom.height = display.contentHeight, display.contentWidth\nblackRectBottom.x, blackRectBottom.y = "..(tostring(options.displayHeight/2)..",0" ).."\nblackRectBottom.anchorX, blackRectBottom.anchorY = 0, 0.5"
        return lua.."\nend)"
    end,

    setVerticalOrientation = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o, mainGroup)
        local lua = "pcall(function()\n"
        lua = lua.."CENTER_X = display.contentCenterX\nCENTER_Y = display.screenOriginY+display.contentHeight/2\nplugins.orientation.lock('portrait')\nmainGroup.xScale, mainGroup.yScale = "..tostring(mainGroup[1])..", "..tostring(not options.aspectRatio and mainGroup[2] or mainGroup[1]).."\nmainGroup.x, mainGroup.y = CENTER_X, CENTER_Y\nblackRectTop.width, blackRectTop.height = display.contentWidth, display.contentHeight\nblackRectTop.x, blackRectTop.y = "..("0,-"..tostring(options.displayHeight/2)).."\nblackRectTop.anchorY, blackRectTop.anchorX = 1, 0.5\nblackRectBottom.x, blackRectBottom.y = "..("0,"..tostring(options.displayHeight/2)).."\nblackRectBottom.anchorY, blackRectBottom.anchorX = 0, 0.5"
        return lua.."\nend)"
    end,

    removeAdaptiveSizeDevice = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = ""
        lua = lua.."mainGroup.xScale, mainGroup.yScale = 1, 1"
        return lua
    end,

    sleepScreenMode =  function(infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua .. "system.setIdleTimer("..(infoBlock[2][1][2]=="on" and "true" or "false")..")"
        return lua.."\nend)"
    end,

    setTapDelay = function(infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua .. "system.setTapDelay("..make_all_formulas(infoBlock[2][1], object)..")"
        return lua.."\nend)"
    end,
}