return {
    newWebView = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        local name = make_all_formulas(infoBlock[2][1], object)
        local link = make_all_formulas(infoBlock[2][2], object)
        local x = make_all_formulas(infoBlock[2][3], object)
        local y = make_all_formulas(infoBlock[2][4], object)
        local width = make_all_formulas(infoBlock[2][5], object)
        local height = make_all_formulas(infoBlock[2][6], object)

        lua = lua.."local myWeb = native.newWebView( "..x..", -"..y..", "..width..", "..height..")\
        cameraGroup:insert(myWeb)\
        myWeb:request("..link..")\
        WebViews["..name.."] = myWeb"

        return lua.."\nend)"
    end,

    setWebViewX = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        local name = make_all_formulas(infoBlock[2][1], object)
        local x = make_all_formulas(infoBlock[2][2], object)
        lua = lua.."WebViews["..name.."].x = "..x
        return lua.."\nend)"
    end,

    deleteWebView = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."\nlocal answer = "..make_all_formulas(infoBlock[2][1], object).."\ndisplay.remove(WebViews[answer])\nWebViews[answer] = nil"
        return lua.."\nend)"
    end,

    setWebViewY = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        local name = make_all_formulas(infoBlock[2][1], object)
        local y = make_all_formulas(infoBlock[2][2], object)
        lua = lua.."WebViews["..name.."].y = - ("..y..")"
        return lua.."\nend)"
    end,

    setWebViewWidth = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        local name = make_all_formulas(infoBlock[2][1], object)
        local width = make_all_formulas(infoBlock[2][2], object)
        lua = lua.."WebViews["..name.."].width = "..width
        return lua.."\nend)"
    end,

    setWebViewHeight = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        local name = make_all_formulas(infoBlock[2][1], object)
        local height = make_all_formulas(infoBlock[2][2], object)
        lua = lua.."WebViews["..name.."].height = "..height
        return lua.."\nend)"
    end,

    setLinkWebView = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        local name = make_all_formulas(infoBlock[2][1], object)
        local link = make_all_formulas(infoBlock[2][2], object)
        lua = lua.."WebViews["..name.."]:request("..link..")"
        return lua.."\nend)"
    end,

    backWebView = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        local name = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."WebViews["..name.."]:back()"
        return lua.."\nend)"
    end,

    forwardWebView = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        local name = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."WebViews["..name.."]:forward()"
        return lua.."\nend)"
    end,

    stopWebView = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        local name = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."WebViews["..name.."]:stop()"
        return lua.."\nend)"
    end,

    reloadWebView = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        local name = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."WebViews["..name.."]:reload()"
        return lua.."\nend)"
    end,
}