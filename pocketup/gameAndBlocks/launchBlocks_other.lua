
timer.new = timer.performWithDelay
timer.GameNew = function (time, rep, listener)
    return timer.new(time, listener, rep)
end
timer.GameNew2 = function (time, rep, onComplete, listener)
    local i = 0
    return timer.new(time, function()
        listener()
        i = i+1
        if (i==rep) then
            onComplete()
        end
    end, rep)
end
local max_fors = 0
local nameBlock
local lua
local add_pcall = function ()
    lua = lua..'\npcall(function()\n'
end
local end_pcall = function ()
    lua = lua..'\nend)\n'
end

-- local isEvent = {
--     start=true, touchObject=true, touchScreen=true, ["function"]=true, whenTheTruth=true, collision=true, changeBackground=true, startClone=true,
--     movedObject=true, onTouchObject=true, movedScreen=true, onTouchScreen=true, touchBack=true, endedCollision=true,
-- }

-- BlocksAllHandlers = {}
-- local moduleHandlers = {'data', 'control', 'textFields', 'sounds', 'physics', 'pen', 'particles', 'miniScenes', 'images', 'elementInterface', 'device'}
-- for _, module in ipairs(moduleHandlers) do
--     for key, value in pairs(require('pocketup.gameAndBlocks.launchBlocks.'..module)) do
--         BlocksAllHandlers[key] = value
--     end
-- end

local function make_block(infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
    if infoBlock[3] == 'off' then
        return ''
    end
    nameBlock = infoBlock[1]--args[i] = make_all_formulas(infoBlock[2][i], object)
    lua = ''
    -- local waitInsert = function (time)
    --     lua = lua..'threadFun.wait('..time..'*1000)'
    -- end
    if BlocksAllHandlers[nameBlock] then
        lua = lua..(BlocksAllHandlers[nameBlock](infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o) or '')
    elseif nameBlock == 'transitionPosition' then
        local time = make_all_formulas(infoBlock[2][1], object)
        local x = make_all_formulas(infoBlock[2][2], object)
        local y = make_all_formulas(infoBlock[2][3], object)

        add_pcall()
        lua = lua..
        "transition.to(target, {time="..time.."*1000,\
        x="..x..", y= -"..y.."})"
        end_pcall()
    elseif nameBlock == 'timer' then
        local rep = make_all_formulas(infoBlock[2][1], object)
        local time = make_all_formulas(infoBlock[2][2], object)
        lua = lua..
        "for i=1, type("..rep..") == 'number' and "..rep.." or 0 do\
        threadFun.wait(type("..time..") == 'number' and ("..time.."*1000) or 0)"
    elseif nameBlock == 'openLink' then
        local link = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua.."system.openURL("..link..")"
        end_pcall()
    elseif nameBlock == 'blockTouch' then
        lua = lua..
'for i=1, #events_touchObject, 1 do\
events_touchObject[i](target)\
end'
    elseif nameBlock == 'blockTouchScreen' then
        lua = lua..
'for key, value in pairs(objects) do\
for i=1, #events_touchScreen[key] do\
events_touchScreen[key][i](value)\
for i2=1, #value.clones do\
events_touchScreen[key][i](value.clones[i2])\
end\
end\
end'
    elseif nameBlock == 'showToast' then
        add_pcall()
        local arg1 = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."if not utils.isSim and not utils.isWin then\
            require('plugin.toaster').shortToast("..arg1..")\
        end\n"
        end_pcall()
    elseif nameBlock == 'setHorizontalOrientation' then
        add_pcall()
        lua = lua.."CENTER_X = display.contentCenterX\nCENTER_Y = display.screenOriginY+display.contentHeight/2\nplugins.orientation.lock('landscape')\nmainGroup.xScale, mainGroup.yScale = "..tostring(not options.aspectRatio and yScaleMainGroup or xScaleMainGroup)..", "..tostring(xScaleMainGroup).."\nmainGroup.x, mainGroup.y = CENTER_Y, CENTER_X\nblackRectTop.width, blackRectTop.height = display.contentHeight, display.contentWidth\nblackRectTop.x, blackRectTop.y = "..("-"..tostring(options.displayHeight/2)..",0" ).."\nblackRectTop.anchorX, blackRectTop.anchorY = 1, 0.5\nblackRectBottom.width, blackRectBottom.height = display.contentHeight, display.contentWidth\nblackRectBottom.x, blackRectBottom.y = "..(tostring(options.displayHeight/2)..",0" ).."\nblackRectBottom.anchorX, blackRectBottom.anchorY = 0, 0.5"
        end_pcall()
    elseif nameBlock == 'setVerticalOrientation' then
        add_pcall()
        lua = lua.."CENTER_X = display.contentCenterX\nCENTER_Y = display.screenOriginY+display.contentHeight/2\nplugins.orientation.lock('portrait')\nmainGroup.xScale, mainGroup.yScale = "..tostring(xScaleMainGroup)..", "..tostring(not options.aspectRatio and yScaleMainGroup or xScaleMainGroup).."\nmainGroup.x, mainGroup.y = CENTER_X, CENTER_Y\nblackRectTop.width, blackRectTop.height = display.contentWidth, display.contentHeight\nblackRectTop.x, blackRectTop.y = "..("0,-"..tostring(options.displayHeight/2)).."\nblackRectTop.anchorY, blackRectTop.anchorX = 1, 0.5\nblackRectBottom.x, blackRectBottom.y = "..("0,"..tostring(options.displayHeight/2)).."\nblackRectBottom.anchorY, blackRectBottom.anchorX = 0, 0.5"
        end_pcall()
    elseif nameBlock == 'setTextelCoarseness' then
        add_pcall()
        local arg1 = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."target.physicsTable.outline = graphics.newOutline("..arg1..", target.image_path, system.DocumentsDirectory)\ntarget:physicsReload()\n"
        end_pcall()
    elseif nameBlock == 'removeAdaptiveSizeDevice' then
        add_pcall()
        lua = lua.."mainGroup.xScale, mainGroup.yScale = 1, 1"
        end_pcall()
    end
    return lua
end

return(make_block)