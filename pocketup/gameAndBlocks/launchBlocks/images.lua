return {
    setImageToName = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if #images > 0 and infoBlock[2][1][2] ~= nil then
            local image = infoBlock[2][1][2]
            if image~=nil then
                local lua = "pcall(function()\n"
                lua = lua.."local newIdImage = nil\nfor i=1, #listImages do\nif (listImages[i]=="..image..") then\nnewIdImage=i\nbreak\nend\nend\nif (newIdImage ~= nil) then"
                lua = lua..'\ntarget.numberImage = newIdImage\ntarget.image_path = \''..app.idProject..'/scene_'..scene_id..'/object_'..obj_id..'/image_'..image..'.png\'\n'
                lua = lua..'target.fill = {type = \'image\', filename = \''..app.idProject..'/scene_'..scene_id..'/object_'..obj_id..'/image_'..image..'.png\', baseDir = system.DocumentsDirectory}\n'
                lua = lua.."target.origWidth, target.origHeight = getImageProperties(target.image_path, system.DocumentsDirectory)\ntarget.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)\n"
                lua = lua.."local r = pocketupFuns.sin(target.property_color-22+56)/2+0.724\nlocal g = pocketupFuns.cos(target.property_color+56)/2+0.724\nlocal b = pocketupFuns.sin(target.property_color+22+56)/2+0.724\ntarget:setFillColor(r,g,b)\n"
                lua = lua.."if (target.property_color~=100) then\ntarget.fill.effect = 'filter.brightness'\ntarget.fill.effect.intensity = (target.property_brightness)/100-1\nend\n"
                if (o==1) then
                    lua = lua.."broadcastChangeBackground(listImages[numberImage])\n"
                end
                lua = lua.."end\n"
                return lua.."\nend)"
            end
        end
    end,

    setImageToId = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if #images > 0 then
            local image = make_all_formulas(infoBlock[2][1], object)
            local lua = "pcall(function()\n"
            lua = lua.."local numberImage = ("..image.."-1)-math.floor((".. image.."-1)/"..#images..")*"..#images.."+1"
            lua = lua..'\ntarget.numberImage = numberImage\ntarget.image_path = \''..app.idProject..'/scene_'..scene_id..'/object_'..obj_id..'/image_\'..listImages[numberImage]..\'.png\'\n'
            lua = lua..'target.fill = {type = \'image\', filename = \''..app.idProject..'/scene_'..scene_id..'/object_'..obj_id..'/image_\'..listImages[numberImage]..\'.png\', baseDir = system.DocumentsDirectory}\n'
            lua = lua.."target.origWidth, target.origHeight = getImageProperties(target.image_path, system.DocumentsDirectory)\ntarget.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)\n"
            lua = lua.."local r = pocketupFuns.sin(target.property_color-22+56)/2+0.724\nlocal g = pocketupFuns.cos(target.property_color+56)/2+0.724\nlocal b = pocketupFuns.sin(target.property_color+22+56)/2+0.724\ntarget:setFillColor(r,g,b)\n"
            lua = lua.."if (target.property_color~=100) then\ntarget.fill.effect = 'filter.brightness'\ntarget.fill.effect.intensity = (target.property_brightness)/100-1\nend\n"
            if (o==1) then
                lua = lua.."broadcastChangeBackground(listImages[numberImage])\n"
            end
            return lua.."\nend)"
        end
    end,

    nextImage = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if #images > 1 then
            local lua = "pcall(function()\n"
            lua = lua.."target.numberImage = target.numberImage==#listImages and 1 or target.numberImage+1\ntarget.image_path='"..app.idProject.."/scene_"..scene_id.."/object_"..obj_id.."/image_'..listImages[target.numberImage]..'.png'\n"
            lua = lua..'target.fill = {type = \'image\', filename = \''..app.idProject..'/scene_'..scene_id..'/object_'..obj_id..'/image_\'..listImages[target.numberImage]..\'.png\', baseDir = system.DocumentsDirectory}\n'
            lua = lua.."target.origWidth, target.origHeight = getImageProperties(target.image_path, system.DocumentsDirectory)\ntarget.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)\n"
            lua = lua.."local r = pocketupFuns.sin(target.property_color-22+56)/2+0.724\nlocal g = pocketupFuns.cos(target.property_color+56)/2+0.724\nlocal b = pocketupFuns.sin(target.property_color+22+56)/2+0.724\ntarget:setFillColor(r,g,b)\n"
            lua = lua.."if (target.property_color~=100) then\ntarget.fill.effect = 'filter.brightness'\ntarget.fill.effect.intensity = (target.property_brightness)/100-1\nend\n"
            return lua.."\nend)"
        end
    end,

    previousImage = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if #images > 1 then
            local lua = "pcall(function()\n"
            lua = lua.."target.numberImage = target.numberImage==1 and #listImages or target.numberImage-1\ntarget.image_path='"..app.idProject.."/scene_"..scene_id.."/object_"..obj_id.."/image_'..listImages[target.numberImage]..'.png'\n"
            lua = lua..'target.fill = {type = \'image\', filename = \''..app.idProject..'/scene_'..scene_id..'/object_'..obj_id..'/image_\'..listImages[target.numberImage]..\'.png\', baseDir = system.DocumentsDirectory}\n'
            lua = lua.."target.origWidth, target.origHeight = getImageProperties(target.image_path, system.DocumentsDirectory)\ntarget.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)\n"
            lua = lua.."local r = pocketupFuns.sin(target.property_color-22+56)/2+0.724\nlocal g = pocketupFuns.cos(target.property_color+56)/2+0.724\nlocal b = pocketupFuns.sin(target.property_color+22+56)/2+0.724\ntarget:setFillColor(r,g,b)\n"
            lua = lua.."if (target.property_color~=100) then\ntarget.fill.effect = 'filter.brightness'\ntarget.fill.effect.intensity = (target.property_brightness)/100-1\nend\n"
            return lua.."\nend)"
        end
    end,

    setSize = function (infoBlock, object, images, sounds, make_all_formulas)
        local formula = make_all_formulas(infoBlock[2][1], object)
        local lua = "pcall(function()\n"
        lua = lua..
        "target.property_size = "..formula.."\
        target.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)\
        target:physicsReload()"
        return lua.."\nend)"
    end,

    editSize = function (infoBlock, object, images, sounds, make_all_formulas)
        local formula = make_all_formulas(infoBlock[2][1], object)
        local lua = "pcall(function()\n"
        lua = lua..
        "target.property_size = target.property_size + "..formula.."\
        target.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)\
        target:physicsReload()"
        return lua.."\nend)"
    end,

    hide = function ()
        return "target.isVisible = false"
    end,

    show = function ()
        return "target.isVisible = true"
    end,

    setBackgroundColor = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        local arg1 = make_all_formulas(infoBlock[2][1], object)
        local arg2 = make_all_formulas(infoBlock[2][2], object)
        local arg3 = make_all_formulas(infoBlock[2][3], object)
        lua = lua..'display.setDefault(\'background\', '..arg1..'/255, '..arg3..'/255, '..arg2..'/255)\n'
        return lua.."\nend)"
    end,

    setBackgroundColorHex = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        local arg1 = make_all_formulas(infoBlock[2][1], object)
        lua = lua..'local _hex_rgb = utils.hexToRgb('..arg1..')\ndisplay.setDefault("background", _hex_rgb[1], _hex_rgb[2], _hex_rgb[3])\n_hex_rgb = nil\n'
        return lua.."\nend)"
    end,

    ask = function (infoBlock, object, images, sounds, make_all_formulas)
        if infoBlock[2][2][2]~=nil and infoBlock[2][3][2]~=nil then
            local lua = "pcall(function()\n"
            lua = lua.."local function funEditingEnd(event)\
                "..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2].." = event.isOk and event.value or ''\
                if ("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][2][2].." ~= nil and "..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][2][2]..".x ~= nil) then\
                    "..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][2][2]..".text = event.isOk and event.value or ''\
                end\
                local key = target.parent_obj.nameObject\
                local value = target\
                for i=1, #events_function[key]['fun_"..infoBlock[2][3][2].."'] do\
                    events_function[key]['fun_"..infoBlock[2][3][2].."'][i](value)\
                end\
            end\
            local background = display.newRect(mainGroup, 0, 0, 4000, 2000)\
            background:setFillColor(0,0,0,0.6)\
            \
            local textField = native.newTextBox(0, -50, 400,80)\
            textField.text = ''\
            textField:setTextColor(0,0,0,1)\
            textField.size = 30\
            textField.isEditable = true\
            mainGroup:insert(textField)\
            \
            local ok = display.newRect(mainGroup, 120, 50, 200, 70)\
            ok:setFillColor(0,0,0,0.8)\
            local okText = display.newText(mainGroup, 'Принять', ok.x, ok.y, nil, app.fontSize1)\
            local back = display.newRect(mainGroup, -120, 50, 200, 70)\
            back:setFillColor(0,0,0,0.8)\
            local backText = display.newText(mainGroup, 'Отмена', back.x, back.y, nil, app.fontSize1)\
            local headerText = display.newText(mainGroup, "..make_all_formulas(infoBlock[2][1], object)..", 0, -200, nil, app.fontSize1)\
            local remove = function()\
                display.remove(background)\
                display.remove(textField)\
                display.remove(ok)\
                display.remove(okText)\
                display.remove(back)\
                display.remove(backText)\
                display.remove(headerText)\
            end\
            back:addEventListener('tap', function()\
                remove()\
            end)\
            ok:addEventListener('tap', function()\
                funEditingEnd(\
                {\
                ['isOk']=true,\
                ['value']=textField.text,\
                }\
            )\
                remove()\
            end)\
            --app.cerberus.newInputLine("..make_all_formulas(infoBlock[2][1], object)..", '', nil, '', funEditingEnd)"
            return lua.."\nend)"
        end
    end,

    sayTime = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        local arg1 = make_all_formulas(infoBlock[2][1], object)
        local arg2 = make_all_formulas(infoBlock[2][2], object)
        lua = lua..'if (target.think ~= nil) then\ndisplay.remove(target.think.carbon)\ndisplay.remove(target.think.text)\ndisplay.remove(target.think)\nend\ntarget.think = display.newRoundedRect(0, 0, 200, 200, 15)\ntarget.group:insert(target.think)\ntarget.think.carbon = display.newImage("sprites/says.png", CENTER_X, CENTER_Y)\ntarget.group:insert(target.think.carbon)\ntarget.think.carbon:scale(0.17, 0.17)\ntarget.think.text = display.newText('..arg1..', 0, 0, 190, 190, native.systemFont, 25)\ntarget.group:insert(target.think.text)\ntarget.think.text:setFillColor(0)\n\ntarget.think.x = target.x + (target.width/2) + 100 target.think.y = target.y - target.width/2 - 100 target.think.text.x = target.think.x+10 target.think.text.y = target.think.y+10 \ntarget.think.carbon.x = target.think.x - target.think.width/2+23\ntarget.think.carbon.y = target.think.y + target.think.height/2+15\nlocal _mover = timer.performWithDelay(0, function()\nif (target.think~=nil and target.think.x ~=nil) then\ntarget.think.x = target.x + (target.width/2) + 100 target.think.y = target.y - target.width/2 - 100 target.think.text.x = target.think.x+10 target.think.text.y = target.think.y+10 \ntarget.think.carbon.x = target.think.x - target.think.width/2+23\ntarget.think.carbon.y = target.think.y + target.think.height/2+15\nend\nend, -1)\ntimer.performWithDelay('..arg2..'*1000, function()\nif (target.think~=nil and target.think.x ~=nil) then\ntimer.cancel(_mover) target.think:removeSelf() target.think.text:removeSelf() target.think.carbon:removeSelf() \nelse\ntimer.cancel(_mover)\nend\nend)'
        return lua.."\nend)"
    end,

    thinkTime = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        local arg1 = make_all_formulas(infoBlock[2][1], object)
        local arg2 = make_all_formulas(infoBlock[2][2], object)
        lua = lua..'if (target.think ~= nil) then\ndisplay.remove(target.think.carbon)\ndisplay.remove(target.think.text)\ndisplay.remove(target.think)\nend\ntarget.think = display.newRoundedRect(0, 0, 200, 200, 15)\ntarget.group:insert(target.think)\ntarget.think.carbon = display.newImage("sprites/thinks.png", CENTER_X, CENTER_Y)\ntarget.group:insert(target.think.carbon)\ntarget.think.carbon:scale(0.17, 0.17)\ntarget.think.text = display.newText('..arg1..', 0, 0, 190, 190, native.systemFont, 25)\ntarget.group:insert(target.think.text)\ntarget.think.text:setFillColor(0)\ntarget.think.x = target.x + (target.width/2) + 100 target.think.y = target.y - target.width/2 - 100 target.think.text.x = target.think.x+10 target.think.text.y = target.think.y+10 \ntarget.think.carbon.x = target.think.x - target.think.width/2+23\ntarget.think.carbon.y = target.think.y + target.think.height/2+20\nlocal _mover = timer.performWithDelay(0, function()\nif (target.think~=nil and target.think.x ~=nil) then\ntarget.think.x = target.x + (target.width/2) + 100 target.think.y = target.y - target.width/2 - 100 target.think.text.x = target.think.x+10 target.think.text.y = target.think.y+10 \ntarget.think.carbon.x = target.think.x - target.think.width/2+23\ntarget.think.carbon.y = target.think.y + target.think.height/2+20\nend\nend, -1)\ntimer.performWithDelay('..arg2..'*1000, function()\nif (target.think~=nil and target.think.x ~=nil) then\ntimer.cancel(_mover) target.think:removeSelf() target.think.text:removeSelf() target.think.carbon:removeSelf() \nelse\ntimer.cancel(_mover)\nend\nend)'
        return lua.."\nend)"
    end,

    setAlpha = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        local alpha = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."target.alpha = math.min(math.max(100-"..alpha..",0),100)/100"
        return lua.."\nend)"
    end,

    editAlpha = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        lua = lua.."target.alpha = target.alpha - ("..make_all_formulas(infoBlock[2][1], object)..")/100"
        return lua.."\nend)"
    end,

    editBrightness = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        local brig = make_all_formulas(infoBlock[2][1], object)
        lua = lua..
        "target.fill.effect = 'filter.brightness'\
        target.property_brightness = math.max(math.min(target.property_brightness+"..brig..", 200),0)\
        target.fill.effect.intensity = (target.property_brightness)/100-1"
        return lua.."\nend)"
    end,

    setBrightness = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        local brig = make_all_formulas(infoBlock[2][1], object)
        lua = lua..
        "target.fill.effect = 'filter.brightness'\
        target.property_brightness = math.max(math.min("..brig..", 200),0)\
        target.fill.effect.intensity = (target.property_brightness)/100-1"
        return lua.."\nend)"
    end,

    setColor = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        lua = lua.."target.property_color = "..make_all_formulas(infoBlock[2][1],object).."\nlocal r = pocketupFuns.sin(target.property_color-22+56)/2+0.724\nlocal g = pocketupFuns.cos(target.property_color+56)/2+0.724\nlocal b = pocketupFuns.sin(target.property_color+22+56)/2+0.724\ntarget:setFillColor(r,g,b)"
        return lua.."\nend)"
    end,

    editColor = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        lua = lua.."target.property_color = target.property_color - "..make_all_formulas(infoBlock[2][1],object).."\nlocal r = pocketupFuns.sin(target.property_color-22+56)/2+0.724\nlocal g = pocketupFuns.cos(target.property_color+56)/2+0.724\nlocal b = pocketupFuns.sin(target.property_color+22+56)/2+0.724\ntarget:setFillColor(r,g,b)"
        return lua.."\nend)"
    end,

    focusCameraToObject = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."if (focusCameraObject == nil) then\nfocusCameraObject = target\ntarget.timerCamera = timer.new(0, function()\ncameraGroup.x, cameraGroup.y = -focusCameraObject.x + math.max(math.min(focusCameraObject.x+cameraGroup.x,"..tostring(options.displayWidth/2).."/100*"..make_all_formulas(infoBlock[2][1], object).."),-"..tostring(options.displayWidth/2).."/100*"..make_all_formulas(infoBlock[2][1], object).."), -focusCameraObject.y + math.max(math.min(focusCameraObject.y+cameraGroup.y,"..tostring(options.displayHeight/2).."/100*"..make_all_formulas(infoBlock[2][2], object).."),-"..tostring(options.displayHeight/2).."/100*"..make_all_formulas(infoBlock[2][2], object)..") \nend, 0)\nelse\nfocusCameraObject = target\nend"
        return lua.."\nend)"    
    end,

    removeObjectCamera = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        lua = lua.."notCameraGroup:insert(target)\ntarget.group = notCameraGroup"
        return lua.."\nend)"
    end,

    insertObjectCamera = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        lua = lua.."cameraGroup:insert(target)\ntarget.group = cameraGroup"
        return lua.."\nend)"
    end,

    removeFocusCameraToObject = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        lua = lua.."if (focusCameraObject~=nil) then\ntimer.cancel(focusCameraObject.timerCamera)\nfocusCameraObject = nil\nend"
        return lua.."\nend)"
    end,

    setImageBackgroundToName = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if #images>0 and infoBlock[2][1][2]~=nil then
            local image = infoBlock[2][1][2]
        
            if (image~=nil) then
                local lua = "pcall(function()\n"
                lua = lua.."local newIdImage = nil\nfor i=1, #background.listImagesBack do\nif (background.listImagesBack[i]=="..image..") then\nnewIdImage=i\nbreak\nend\nend\nif (newIdImage ~= nil) then"
                lua = lua..'\nbackground.numberImage = newIdImage\nbackground.image_path = background.obj_pathBack..\'/image_'..image..'.png\'\n'
                lua = lua..'background.fill = {type = \'image\', filename = background.image_path, baseDir = system.DocumentsDirectory}\n'
                lua = lua.."background.origWidth, background.origHeight = getImageProperties(background.image_path, system.DocumentsDirectory)\nbackground.width, background.height = background.origWidth*(background.property_size/100), background.origHeight*(background.property_size/100)\n"
                lua = lua.."local r = pocketupFuns.sin(background.property_color-22+56)/2+0.724\nlocal g = pocketupFuns.cos(background.property_color+56)/2+0.724\nlocal b = pocketupFuns.sin(background.property_color+22+56)/2+0.724\nbackground:setFillColor(r,g,b)\n"
                lua = lua.."if (background.property_color~=100) then\nbackground.fill.effect = 'filter.brightness'\nbackground.fill.effect.intensity = (background.property_brightness)/100-1\nend\n"
                if (o==1) then
                    lua = lua.."broadcastChangeBackground(listImages[numberImage])\n"
                end
                lua = lua.."end\n"
                return lua.."\nend)"
            end
        end
    end,

    setImageBackgroundToId = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if #images>0 then
            local image = make_all_formulas(infoBlock[2][1], object)
            local lua = "pcall(function()\n"
            lua = lua.."local numberImage = ("..image.."-1)-math.floor((".. image.."-1)/#background.listImagesBack)*#background.listImagesBack+1"
            lua = lua..'\nbackground.numberImage = numberImage\nbackground.image_path = background.obj_pathBack..\'/image_\'..background.listImagesBack[numberImage]..\'.png\'\n'
            lua = lua..'background.fill = {type = \'image\', filename = background.image_path, baseDir = system.DocumentsDirectory}\n'
            lua = lua.."background.origWidth, background.origHeight = getImageProperties(background.image_path, system.DocumentsDirectory)\nbackground.width, background.height = background.origWidth*(background.property_size/100), background.origHeight*(background.property_size/100)\n"
            lua = lua.."local r = pocketupFuns.sin(background.property_color-22+56)/2+0.724\nlocal g = pocketupFuns.cos(background.property_color+56)/2+0.724\nlocal b = pocketupFuns.sin(background.property_color+22+56)/2+0.724\nbackground:setFillColor(r,g,b)\n"
            lua = lua.."if (background.property_color~=100) then\nbackground.fill.effect = 'filter.brightness'\nbackground.fill.effect.intensity = (background.property_brightness)/100-1\nend\n"
            if (o==1) then
                lua = lua.."broadcastChangeBackground(listImages[numberImage])\n"
            end
            return lua.."\nend)"
        end
    end,

    getLinkImage = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."local function networkListener(event)\nif (target~=nil and target.x~=nil) then\ntarget.image_path = 'objectImage_"..obj_id..".png'\ntarget.fill = {type = \'image\', filename = target.image_path, baseDir=system.TemporaryDirectory}\ntarget.origWidth, target.origHeight = getImageProperties(target.image_path, system.TemporaryDirectory)\ntarget.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)\nend\nend\nnetwork.download("..make_all_formulas(infoBlock[2][1],object)..",'GET', networkListener, 'objectImage_"..obj_id..".png', system.TemporaryDirectory)"
        return lua.."\nend)"
    end,

    setAnchor = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."target.anchorX, target.anchorY = "..make_all_formulas(infoBlock[2][1], object).."/100, "..make_all_formulas(infoBlock[2][2], object).."/100"
        return lua.."\nend)"
    end
}