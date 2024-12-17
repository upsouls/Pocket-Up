return {
    playSound = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if infoBlock[2][1][2]~=nil then
            local lua = "pcall(function()\n"
            lua = lua..'if not playSounds['..infoBlock[2][1][2]..'] then\n'
            lua = lua..'playSounds['..infoBlock[2][1][2]..'] = audio.loadSound(\''..obj_path..'/sound_'..infoBlock[2][1][2]..'.mp3\', system.DocumentsDirectory)\n'
            lua = lua..'end\naudio.stop(playingSounds['..infoBlock[2][1][2]..'])\n'
            lua = lua..'playingSounds['..infoBlock[2][1][2]..'] = audio.play(playSounds['.. infoBlock[2][1][2]..'])'
            return lua.."\nend)"
        end
    end,

    playSoundAndWait = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua..
        "if not playSounds["..infoBlock[2][1][2].."] then\
            playSounds["..infoBlock[2][1][2].."] = audio.loadSound('"..obj_path.."/sound_"..infoBlock[2][1][2]..".mp3', system.DocumentsDirectory)\
        end\
        pcall(function()\
            audio.stop(playingSounds["..infoBlock[2][1][2].."])\
        end)\
        playingSounds["..infoBlock[2][1][2].."] = audio.play(playSounds[".. infoBlock[2][1][2].."])"
        lua = lua.."\nend)"
        lua = lua.."\
        local time = audio.getDuration(playSounds["..infoBlock[2][1][2].."])\
        threadFun.wait(time)"
        return lua
    end,

    stopSound = function (infoBlock, object, images, sounds, make_all_formulas)
        if infoBlock[2][1][2]~=nil then
            local lua = "pcall(function()\n"
            lua = lua.."audio.stop(playingSounds["..infoBlock[2][1][2].."])\naudio.dispose(playSounds[".. infoBlock[2][1][2].."])\nplaySounds[".. infoBlock[2][1][2].."] = nil"
            return lua.."\nend)"
        end
    end,

    stopAllSounds = function ()
        local lua = "pcall(function()\n"
        lua = lua.."audio.stop()\naudio.dispose()\nplaySounds = {}"
        return lua.."\nend)"
    end,

    setVolumeSound = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        local volume = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."audio.setVolume("..volume.."/100)"
        return lua.."\nend)"
    end,

    editVolumeSound = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        local volume = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."audio.setVolume(audio.getVolume() + "..volume.."/100 )"
        return lua.."\nend)"
    end,
}