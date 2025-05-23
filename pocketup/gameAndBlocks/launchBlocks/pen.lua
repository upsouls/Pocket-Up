return {
    lowerPen = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."if (target.isPen==nil) then\
            target.isPen = true\
            local line = display.newLine(target.x, target.y, target.x, target.y+1)\
            line:setStrokeColor(tableFeathersOptions[2]/255,tableFeathersOptions[3]/255,tableFeathersOptions[4]/255,1)\
            line.strokeWidth = tableFeathersOptions[1]\
            stampsGroup:insert(line)\
            line.oldX, line.oldY = target.x, target.y\
            local timerPen\
            timerPen = timer.new(50, function()\
                if target.isPen and line.append then\
                    if (math.sqrt(math.pow(target.x-line.oldX, 2) + math.pow(target.y-line.oldY, 2))>3) then\
                        line:append(target.x, target.y)\
                        line.oldX, line.oldY = target.x, target.y\
                    end\
                elseif (line.append == nil) then\
                    line = display.newLine(target.x, target.y, target.x, target.y+1)\
                    line:setStrokeColor(tableFeathersOptions[2],tableFeathersOptions[3],tableFeathersOptions[4],1)\
                    line.strokeWidth = tableFeathersOptions[1]\
                    table.insert(tableFeathers, line)\
                    line.oldX, line.oldY = target.x, target.y\
                    stampsGroup:insert(line)\
                else\
                    timer.cancel(timerPen)\
                end\
            end,0)\
            table.insert(tableFeathers, line)\
        end"
        return lua.."\nend)"
    end,

    raisePen = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        return "target.isPen=nil"
    end,

    setSizePen = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        local size = make_all_formulas(infoBlock[2][1], object)
        lua = lua..'tableFeathersOptions[1] = '..size
        return lua.."\nend)"
    end,

    setColorPen = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        local r = make_all_formulas(infoBlock[2][1], object)
        local g = make_all_formulas(infoBlock[2][2], object)
        local b = make_all_formulas(infoBlock[2][3], object)
        lua = lua..'tableFeathersOptions[2] = '..r..'\ntableFeathersOptions[3] = '..g..'\ntableFeathersOptions[4] = '..b
        return lua.."\nend)"
    end,

    stamp = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua..'local obj = #tableFeathers+1\nlocal myObj = display.newImage(target.image_path, system.DocumentsDirectory, target.x, target.y)\ntableFeathers[obj] = myObj\nstampsGroup:insert(myObj)\n'
        lua = lua..'myObj.width, myObj.height, myObj.alpha, myObj.rotation, myObj.xScale, myObj.yScale = target.width, target.height, target.alpha, target.rotation, target.xScale, target.yScale\n'
        lua = lua.."local r = pocketupFuns.sin(target.property_color-22+56)/2+0.724\nlocal g = pocketupFuns.cos(target.property_color+56)/2+0.724\nlocal b = pocketupFuns.sin(target.property_color+22+56)/2+0.724\nmyObj:setFillColor(r,g,b)\n"
        lua = lua.."if (target.property_color~=100) then\nmyObj.fill.effect = 'filter.brightness'\nmyObj.fill.effect.intensity = (target.property_brightness)/100-1\nend\n"
        return lua.."\nend)"
    end,

    clearPen = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua..
        '\
        for i = 1, #tableFeathers, 1 do\
            display.remove(tableFeathers[i])\
            tableFeathers[i] = nil\
        end\
        tableFeathers = {}'
        return lua.."\nend)"
    end,
}