return {
	createVideo = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o, mainGroup, videos)
        if (infoBlock[2][1][2]~=nil) then
            local lua = "pcall(function()\n"
            --local x = make_all_formulas(infoBlock[2][1], object)
            local idVideo = infoBlock[2][1][2]
            lua = lua..'if (listVideos['..idVideo..']~=nil) then\n'
            lua = lua..'display.remove(listVideos['..idVideo..'])\nend\n'
            lua = lua..'listVideos['..idVideo..'] = native.newVideo('..make_all_formulas(infoBlock[2][4], object)..', -'..make_all_formulas(infoBlock[2][5], object)..', '..make_all_formulas(infoBlock[2][2], object)..', '..make_all_formulas(infoBlock[2][3], object)..')\n'
            lua = lua..'cameraGroup:insert(listVideos['..idVideo..'])'
            lua = lua..'listVideos['..idVideo..']:load("'..obj_path..'/video_'..idVideo..'.mp4'..'", system.DocumentsDirectory)'
            return lua .. "\nend)"

        end
    end,
    setPositionVideo = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o, mainGroup, videos)
        if (infoBlock[2][1][2]~=nil) then
            local lua = "pcall(function()\n"
            local idVideo = infoBlock[2][1][2]
            lua = lua..'listVideos['..idVideo..'].x, listVideos['..idVideo..'].y = '..make_all_formulas(infoBlock[2][2], object)..', -'..make_all_formulas(infoBlock[2][3], object)..'\n'
            return lua .. "\nend)"

        end
    end,
    setPositionXVideo = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o, mainGroup, videos)
        if (infoBlock[2][1][2]~=nil) then
            local lua = "pcall(function()\n"
            lua = lua..'listVideos['..infoBlock[2][2][2]..'].x = '..make_all_formulas(infoBlock[2][1], object)..'\n'
            return lua .. "\nend)"

        end
    end,
    setPositionYVideo = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o, mainGroup, videos)
        if (infoBlock[2][1][2]~=nil) then
            local lua = "pcall(function()\n"
            lua = lua..'listVideos['..infoBlock[2][2][2]..'].y = -'..make_all_formulas(infoBlock[2][1], object)..'\n'
            return lua .. "\nend)"
        end
    end,
    editPositionXVideo = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o, mainGroup, videos)
        if (infoBlock[2][2][2]~=nil) then
            local lua = "pcall(function()\n"
            lua = lua..'listVideos['..infoBlock[2][2][2]..'].x = listVideos['..infoBlock[2][2][2]..'].x +'..make_all_formulas(infoBlock[2][1], object)..'\n'
            return lua .. "\nend)"
        end
    end,
    editPositionYVideo = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o, mainGroup, videos)
        if (infoBlock[2][2][2]~=nil) then
            local lua = "pcall(function()\n"
            lua = lua..'listVideos['..infoBlock[2][2][2]..'].y = listVideos['..infoBlock[2][2][2]..'].y - '..make_all_formulas(infoBlock[2][1], object)..'\n'
            print(lua)
            return lua .. "\nend)"
        end
    end,
    playVideo = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o, mainGroup, videos)
        if (infoBlock[2][1][2]~=nil) then
            local lua = "pcall(function()\n"
            lua = lua..'listVideos['..infoBlock[2][1][2]..']:play()\n'
            return lua .. "\nend)"

        end
    end,
    pauseVideo = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o, mainGroup, videos)
        if (infoBlock[2][1][2]~=nil) then
            local lua = "pcall(function()\n"
            lua = lua..'listVideos['..infoBlock[2][1][2]..']:pause()\n'
            return lua .. "\nend)"

        end
    end,
    seekVideo = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o, mainGroup, videos)
        if (infoBlock[2][1][2]~=nil) then
            local lua = "pcall(function()\n"
            lua = lua..'listVideos['..infoBlock[2][1][2]..']:seek('..make_all_formulas(infoBlock[2][2], object)..')\n'
            return lua .. "\nend)"
        end
    end,
    deleteVideo = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o, mainGroup, videos)
        if (infoBlock[2][1][2]~=nil) then
            local lua = "pcall(function()\n"
            lua = lua..'display.remove(listVideos['..infoBlock[2][1][2]..'])\nlistVideos['..infoBlock[2][1][2]..']=nil'
            return lua .. "\nend)"

        end
    end,
    insertVideoToMiniScene = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o, mainGroup, videos)
        if (infoBlock[2][1][2]~=nil) then
            local lua = "pcall(function()\n"
            lua = lua..'miniScenes['..make_all_formulas(infoBlock[2][2], object)..']:insert(listVideos['..infoBlock[2][1][2]..'])'
            return lua .. "\nend)"

        end
    end,
    insertVideoToCamera = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o, mainGroup, videos)
        if (infoBlock[2][1][2]~=nil) then
            local lua = "pcall(function()\n"
            lua = lua..'cameraGroup:insert(listVideos['..infoBlock[2][1][2]..'])'
            return lua .. "\nend)"

        end
    end,
    removeVideoToCamera = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o, mainGroup, videos)
        if (infoBlock[2][1][2]~=nil) then
            local lua = "pcall(function()\n"
            lua = lua..'notCameraGroup:insert(listVideos['..infoBlock[2][1][2]..'])'
            return lua .. "\nend)"

        end
    end,
}