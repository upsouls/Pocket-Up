return {
	createVideo = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o, mainGroup, videos)
        if (infoBlock[2][1][2]~=nil) then
            local lua = "pcall(function()\n"
            --local x = make_all_formulas(infoBlock[2][1], object)
            local idVideo = infoBlock[2][1][2]
            lua = lua..'if (listVideos['..idVideo..']~=nil) then\n'
            lua = lua..'display.remove(listVideos['..idVideo..'])\nend\n'
            lua = lua..'listVideos['..idVideo..'] = native.newVideo('..make_all_formulas(infoBlock[2][4], object)..', -'..make_all_formulas(infoBlock[2][5], object)..', '..make_all_formulas(infoBlock[2][2], object)..', '..make_all_formulas(infoBlock[2][3], object)..')\n'
            lua = lua..'cameraGroup:insert(listVideos['..idVideo..'])\n'
            lua = lua..'listVideos['..idVideo..']:load("'..obj_path..'/video_'..idVideo..'.mp4'..'", system.DocumentsDirectory)\n'
            lua = lua..'listVideos['..idVideo..']:play()\n'
            lua = lua..'listVideos['..idVideo..']:addEventListener("video", function(event)\n'
            lua = lua..'local funsEvents = listEventsVideos['..idVideo..']\nif (funsEvents~=nil) then\nfor i=1, #funsEvents do\n'
            lua = lua..'funsEvents[i](event.phase)\n'
            lua = lua..'end\nend\nend)'
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
    eventListenerVideo = function(infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o, mainGroup, videos)
        if (infoBlock[2][1][2]~=nil) then
            local idVideo = infoBlock[2][1][2]
            local lua = "pcall(function()\n"
            lua = lua..'if (listEventsVideos['..idVideo..']==nil) then\nlistEventsVideos['..idVideo..']={}\nend\n'
            lua = lua..'listEventsVideos['..idVideo..'][#listEventsVideos['..idVideo..']+1] = function(phase)\n'
            if infoBlock[2][2][1] == 'globalVariable' then
                lua = lua..'var_'..tostring(infoBlock[2][2][2])..' = phase\n'
                lua = lua..
                'if varText_'..tostring(infoBlock[2][2][2])..' then\
                varText_'..tostring(infoBlock[2][2][2])..'.text = type(var_'..tostring(infoBlock[2][2][2])..')=="boolean" and (var_'..tostring(infoBlock[2][2][2])..' and app.words[373] or app.words[374]) or type(var_'..tostring(infoBlock[2][2][2])..')=="table" and encodeList(var_'..tostring(infoBlock[2][2][2])..') or var_'..tostring(infoBlock[2][2][2])..'\
                end\n'
            else
                lua = lua..'target.var_'..tostring(infoBlock[2][2][2])..' = phase\n'
                lua = lua..
                'if target.varText_'..tostring(infoBlock[2][2][2])..' then\
                target.varText_'..tostring(infoBlock[2][2][2])..'.text = type(target.var_'..tostring(infoBlock[2][2][2])..')=="boolean" and (target.var_'..tostring(infoBlock[2][2][2])..' and app.words[373] or app.words[374]) or type(target.var_'..tostring(infoBlock[2][2][2])..')=="table" and encodeList(target.var_'..tostring(infoBlock[2][2][2])..') or target.var_'..tostring(infoBlock[2][2][2])..'\
                end\n'
            end
            lua = lua..'end'
            return lua .. "\nend)"
        end
    end,
    whenTheTruth = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o, mainGroup, videos)
            local lua = "pcall(function()\n"
            --lua = lua..'timer.performWithDelay(0, function())d'
            print("hi")
            return lua.."\nend)"
    end,
}