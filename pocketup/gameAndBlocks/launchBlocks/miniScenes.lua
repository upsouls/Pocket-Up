return {
    createMiniScene = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        local name = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."if miniScenes["..name.."] then display.remove(miniScenes[name]) end miniScenes["..name.."] = display.newGroup()\nnotCameraGroup:insert(miniScenes["..name.."])"
        return lua.."\nend)"
    end,

    deleteMiniScene = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        local name = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."if miniScenes["..name.."] then display.remove(miniScenes[name]) end miniScenes["..name.."] = nil"
        return lua.."\nend)"
    end,

    miniSceneInsert = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        local name = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."miniScenes["..name.."]:insert(target)\ntarget.group = miniScenes["..name.."]"
        return lua.."\nend)"
    end,

    setPositionMiniScene = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."local miniScene = miniScenes["..make_all_formulas(infoBlock[2][1], object).."]\nminiScene.x, miniScene.y = "..make_all_formulas(infoBlock[2][2], object)..", -"..make_all_formulas(infoBlock[2][3], object)
        return lua.."\nend)"
    end,

    setSizeMiniScene = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."local miniScene = miniScenes["..make_all_formulas(infoBlock[2][1], object).."]\nminiScene.xScale = "..make_all_formulas(infoBlock[2][2], object).."/100\nminiScene.yScale=miniScene.xScale"
        return lua.."\nend)"
    end,

    editSizeMiniScene = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."local miniScene = miniScenes["..make_all_formulas(infoBlock[2][1], object).."]\nminiScene.xScale = miniScene.xScale+"..make_all_formulas(infoBlock[2][2], object).."/100\nminiScene.yScale=miniScene.xScale"
        return lua.."\nend)"
    end,

    editPositionMiniScene = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."miniScenes["..make_all_formulas(infoBlock[2][1], object).."]:translate("..make_all_formulas(infoBlock[2][2], object)..", -"..make_all_formulas(infoBlock[2][3], object)..")"
        return lua.."\nend)"
    end,

    setRotationMiniScene = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."miniScenes["..make_all_formulas(infoBlock[2][1], object).."].rotation = "..make_all_formulas(infoBlock[2][2], object)
        return lua.."\nend)"
    end,

    editRotationMiniScene = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."miniScenes["..make_all_formulas(infoBlock[2][1], object).."]:rotate("..make_all_formulas(infoBlock[2][2], object)..")"
        return lua.."\nend)"
    end,

    setAlphaMiniScene = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."miniScenes["..make_all_formulas(infoBlock[2][1], object).."].alpha = 1-("..make_all_formulas(infoBlock[2][2], object)..")/100"
        return lua.."\nend)"
    end,

    editAlphaMiniScene = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."local miniScene = miniScenes["..make_all_formulas(infoBlock[2][1], object).."]\nminiScene.alpha = miniScene.alpha-("..make_all_formulas(infoBlock[2][2], object)..")/100"
        return lua.."\nend)"
    end,

    miniSceneHide = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = ""
        local name = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."miniScenes["..name.."].isVisible = false"
        return lua
    end,

    miniSceneShow = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = ""
        local name = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."miniScenes["..name.."].isVisible = true"
        return lua
    end,

    miniSceneInsertMiniScene = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        local name = make_all_formulas(infoBlock[2][1], object)
        local name2 = make_all_formulas(infoBlock[2][2], object)
        lua = lua.."miniScenes["..name.."]:insert(miniScenes["..name2.."])"
        return lua.."\nend)"
    end,

    miniSceneInsertCamera = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        local name = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."cameraGroup:insert(miniScenes["..name.."])"
        return lua.."\nend)"
    end,

    miniSceneRemoveCamera = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        local name = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."notCameraGroup:insert(miniScenes["..name.."])"
        return lua.."\nend)"
    end,
}