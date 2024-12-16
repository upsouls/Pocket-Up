
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

local blockHandlers = {}
local moduleHandlers = {'data', 'control', 'textFields', 'sounds', 'physics', 'pen', 'particles', 'miniScenes', 'images', 'elementInterface', 'device'}
for _, module in ipairs(moduleHandlers) do
    for key, value in pairs(require('pocketup.gameAndBlocks.launchBlocks.'..module)) do
        blockHandlers[key] = value
    end
end

local function make_block(infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
    if infoBlock[3] == 'off' then
        return ''
    end
    nameBlock = infoBlock[1]--args[i] = make_all_formulas(infoBlock[2][i], object)
    lua = ''
    -- local waitInsert = function (time)
    --     lua = lua..'threadFun.wait('..time..'*1000)'
    -- end
    if blockHandlers[nameBlock] then
        lua = lua..(blockHandlers[nameBlock](infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o) or '')
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
    elseif nameBlock == 'setVariable' and infoBlock[2][1][2]~=nil then
        local value = make_all_formulas(infoBlock[2][2], object)
        add_pcall()
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
        end_pcall()
    elseif nameBlock == 'editVariable' and infoBlock[2][1][2]~=nil then
        local value = make_all_formulas(infoBlock[2][2], object)
        add_pcall()
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
        end_pcall()
    elseif nameBlock == 'openLink' then
        local link = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua.."system.openURL("..link..")"
        end_pcall()
    elseif nameBlock=="createRadialParticle" and infoBlock[2][2][2]~=nil then
        local idsGL = {
            GL_ZERO=0,GL_ONE=1,GL_DST_COLOR=774,GL_ONE_MINUS_DST_COLOR=775,GL_SRC_ALPHA=770,GL_ONE_MINUS_SRC_ALPHA=771,GL_DST_ALPHA=772,GL_ONE_MINUS_DST_ALPHA=773,GL_SRC_ALPHA_SATURATE=776,GL_SRC_COLOR=768,GL_ONE_MINUS_SRC_COLOR=769,SRC_COLOR=768
        }
        add_pcall()
        lua = lua.."local startRgb = utils.hexToRgb("..make_all_formulas(infoBlock[2][23], object)..")\nlocal startVarianceRgb = utils.hexToRgb("..make_all_formulas(infoBlock[2][24], object)..")\nlocal finishRgb = utils.hexToRgb("..make_all_formulas(infoBlock[2][25], object)..")\nfinishVarianceRgb = utils.hexToRgb("..make_all_formulas(infoBlock[2][26], object)..")\n"
        lua = lua.."if (objectsParticles["..make_all_formulas(infoBlock[2][1], object).."]~=nil) then\ndisplay.remove(objectsParticles["..make_all_formulas(infoBlock[2][1], object).."])\nend\npcall(function()\nlocal particle = display.newEmitter({\nemitterType=1,\ntextureFileName='"..obj_path.."/image_"..infoBlock[2][2][2]..".png',\nmaxParticles="..make_all_formulas(infoBlock[2][3], object)..",\nabsolutePosition="..make_all_formulas(infoBlock[2][4], object)..",\nangle="..make_all_formulas(infoBlock[2][5], object)..",\nangleVriance="..make_all_formulas(infoBlock[2][6], object)..",\nmaxRadius="..make_all_formulas(infoBlock[2][7], object)..",\nmaxRadiusariance="..make_all_formulas(infoBlock[2][8], object)..",\nminRadius="..make_all_formulas(infoBlock[2][9], object)..",\nminRadiusVariance="..make_all_formulas(infoBlock[2][10], object)..",\nrotatePerSecond="..make_all_formulas(infoBlock[2][11], object)..",\nrotatePerSecondVariance="..make_all_formulas(infoBlock[2][12], object)..",\nparticleLifespan="..make_all_formulas(infoBlock[2][13], object)..",\nparticleLifespanVariance="..make_all_formulas(infoBlock[2][14], object)..",\nstartParticleSize="..make_all_formulas(infoBlock[2][15], object)..",\nstartParticleSizeVariance="..make_all_formulas(infoBlock[2][16], object)..",\nfinishParticleSize="..make_all_formulas(infoBlock[2][17], object)..",\nfinishParticleSizeVariance="..make_all_formulas(infoBlock[2][18], object)..",\nrotationStart="..make_all_formulas(infoBlock[2][19], object)..",\nrotationStartVariance="..make_all_formulas(infoBlock[2][20], object)..",\nrotationEnd="..make_all_formulas(infoBlock[2][21], object)..",\nrotationEndVariance="..make_all_formulas(infoBlock[2][22], object)..",\nstartColorRed=startRgb[1],\nstartColorGreen=startRgb[2],\nstartColorBlue=startRgb[3]\n,\nstartColorVarianceRed=startVarianceRgb[1],\nstartColorVarianceGreen=startVarianceRgb[2],\nstartColorVarianceBlue=startVarianceRgb[3],\nfinishColorRed=finishRgb[1],\nfinishColorGreen=finishRgb[2],\nfinishColorBlue=finishRgb[3],\nfinishColorVarianceRed=finishVarianceRgb[1],\nfinishColorVarianceRed=finishVarianceRgb[2],\nfinishColorVariance=finishVarianceRgb[3],\nblendFuncSource="..idsGL[infoBlock[2][27][2]]..",\nblendFuncDestination="..idsGL[infoBlock[2][28][2]].."\n,startColorAlpha=1, finishColorAlpha=1, duration=-1\n}, system.DocumentsDirectory)\ncameraGroup:insert(particle)\nobjectsParticles["..make_all_formulas(infoBlock[2][1], object).."] = particle\nparticle.x, particle.y = 0, 0\nend)"
        end_pcall()
    elseif nameBlock=="createLinearParticle" and infoBlock[2][2][2]~=nil then
        local idsGL = {
            GL_ZERO=0,GL_ONE=1,GL_DST_COLOR=774,GL_ONE_MINUS_DST_COLOR=775,GL_SRC_ALPHA=770,GL_ONE_MINUS_SRC_ALPHA=771,GL_DST_ALPHA=772,GL_ONE_MINUS_DST_ALPHA=773,GL_SRC_ALPHA_SATURATE=776,GL_SRC_COLOR=768,GL_ONE_MINUS_SRC_COLOR=769,SRC_COLOR=768
        }
        add_pcall()
        lua = lua.."local startRgb = utils.hexToRgb("..make_all_formulas(infoBlock[2][27], object)..")\nlocal startVarianceRgb = utils.hexToRgb("..make_all_formulas(infoBlock[2][28], object)..")\nlocal finishRgb = utils.hexToRgb("..make_all_formulas(infoBlock[2][29], object)..")\nfinishVarianceRgb = utils.hexToRgb("..make_all_formulas(infoBlock[2][30], object)..")\n"
        lua = lua.."if (objectsParticles["..make_all_formulas(infoBlock[2][1], object).."]~=nil) then\ndisplay.remove(objectsParticles["..make_all_formulas(infoBlock[2][1], object).."])\nend\nlocal particle = display.newEmitter({\nemitterType=0,\ntextureFileName='"..obj_path.."/image_"..infoBlock[2][2][2]..".png'\n,maxParticles="..make_all_formulas(infoBlock[2][3], object)..",\nabsolutePosition="..make_all_formulas(infoBlock[2][4], object)..",\nangle="..make_all_formulas(infoBlock[2][5], object)..",\nangleVriance="..make_all_formulas(infoBlock[2][6], object)..",\nspeed="..make_all_formulas(infoBlock[2][7], object)..",\nspeedVariance="..make_all_formulas(infoBlock[2][8], object)..",\nsourcePositionVariancex="..make_all_formulas(infoBlock[2][9], object)..",\nsourcePositionVariancey="..make_all_formulas(infoBlock[2][10], object)..",\ngravityx="..make_all_formulas(infoBlock[2][11], object)..",\ngravityy=-"..make_all_formulas(infoBlock[2][12], object)..",\nradialAcceleration="..make_all_formulas(infoBlock[2][13], object)..",\nradialAccelVariance="..make_all_formulas(infoBlock[2][14], object)..",\ntangentialAcceleration="..make_all_formulas(infoBlock[2][15], object)..",\ntangentialAccelVariance="..make_all_formulas(infoBlock[2][16], object)..",\nparticleLifespan="..make_all_formulas(infoBlock[2][17], object)..",\nparticleLLifespanVariance="..make_all_formulas(infoBlock[2][18], object)..",\nstartParticleSize="..make_all_formulas(infoBlock[2][19], object)..",\nstartParticleSizeVariance="..make_all_formulas(infoBlock[2][20], object)..",\nfinishParticleSize="..make_all_formulas(infoBlock[2][21], object)..",\nfinishParticleSizeVariance="..make_all_formulas(infoBlock[2][22], object)..",\nrotationStart="..make_all_formulas(infoBlock[2][23], object)..",\nrotationStartVariance="..make_all_formulas(infoBlock[2][24], object)..",\nrotationEnd="..make_all_formulas(infoBlock[2][25], object)..",\nrotationEndVariance="..make_all_formulas(infoBlock[2][26], object)..",\nstartColorRed=startRgb[1],startColorGreen=startRgb[2],startColorBlue=startRgb[3],startColorVarianceRed=startVarianceRgb[1],startColorVarianceGreen=startVarianceRgb[2],startColorVarianceBlue=startVarianceRgb[3],finishColorRed=finishRgb[1],finishColorGreen=finishRgb[2],finishColorBlue=finishRgb[3],finishColorVarianceRed=finishVarianceRgb[1],finishColorVarianceGreen=finishVarianceRgb[2],finishColorVarianceBlue=finishVarianceRgb[3],blendFuncSource="..idsGL[infoBlock[2][31][2]]..",\nblendFuncDestination="..idsGL[infoBlock[2][32][2]]..",\nstartColorAlpha=1, finishColorAlpha=1, duration=-1\n}, system.DocumentsDirectory)\ncameraGroup:insert(particle)\nobjectsParticles["..make_all_formulas(infoBlock[2][1], object).."] = particle\nparticle.x, particle.y = 0, 0"
        end_pcall()
    elseif nameBlock=="setPositionParticle" then
        add_pcall()
        lua = lua.."local particle = objectsParticles["..make_all_formulas(infoBlock[2][1], object).."]\nif (particle~=nil) then\nparticle.x, particle.y = "..make_all_formulas(infoBlock[2][2], object)..", -"..make_all_formulas(infoBlock[2][3], object).."\nend"
        end_pcall()
    elseif nameBlock=="deleteParticle" then
        add_pcall()
        lua = lua.."local particle = objectsParticles["..make_all_formulas(infoBlock[2][1], object).."]\nif (particle~=nil) then\ndisplay.remove(particle)\nobjectsParticles["..make_all_formulas(infoBlock[2][1], object).."]=nil\nend"
        end_pcall()
    elseif nameBlock=="deleteAllParticles" then
        add_pcall()
        lua = lua.."for key, value in pairs(objectsParticles) do\ndisplay.remove(value)\nend\nobjectsParticles = {}"
        end_pcall()
    elseif nameBlock=="editPositionXParticle" then
        add_pcall()
        lua = lua.."local particle = objectsParticles["..make_all_formulas(infoBlock[2][1], object).."]\nif (particle~=nil) then\nparticle.x = particle.x+"..make_all_formulas(infoBlock[2][2], object).."\nend"
        end_pcall()
    elseif nameBlock=="editPositionYParticle" then
        add_pcall()
        lua = lua.."local particle = objectsParticles["..make_all_formulas(infoBlock[2][1], object).."]\nif (particle~=nil) then\nparticle.y = particle.y-"..make_all_formulas(infoBlock[2][2], object).."\nend"
        end_pcall()
    elseif nameBlock == 'stamp' then
        add_pcall()
        lua = lua..'local obj = #tableFeathers+1\nlocal myObj = display.newImage(target.image_path, system.DocumentsDirectory, target.x, target.y)\ntableFeathers[obj] = myObj\nstampsGroup:insert(myObj)\n'
        lua = lua..'myObj.width, myObj.height, myObj.alpha, myObj.rotation, myObj.xScale, myObj.yScale = target.width, target.height, target.alpha, target.rotation, target.xScale, target.yScale\n'
        lua = lua.."local r = pocketupFuns.sin(target.property_color-22+56)/2+0.724\nlocal g = pocketupFuns.cos(target.property_color+56)/2+0.724\nlocal b = pocketupFuns.sin(target.property_color+22+56)/2+0.724\nmyObj:setFillColor(r,g,b)\n"
        lua = lua.."if (target.property_color~=100) then\nmyObj.fill.effect = 'filter.brightness'\nmyObj.fill.effect.intensity = (target.property_brightness)/100-1\nend\n"
        end_pcall()
    elseif nameBlock == 'clearPen' then
        add_pcall()
        lua = lua..'for i = 1, #tableFeathers, 1 do\ndisplay.remove(tableFeathers[i])\nend\ntableFeathers = {}'
        end_pcall()
    elseif nameBlock == 'setColorPen' then
        local r = make_all_formulas(infoBlock[2][1], object)
        local g = make_all_formulas(infoBlock[2][2], object)
        local b = make_all_formulas(infoBlock[2][3], object)
        add_pcall()
        lua = lua..'tableFeathersOptions[2] = '..r..'\ntableFeathersOptions[3] = '..g..'\ntableFeathersOptions[4] = '..b
        end_pcall()
    elseif nameBlock == 'setSizePen' then
        local size = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..'tableFeathersOptions[1] = '..size
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
    elseif nameBlock == 'showVariable' and infoBlock[2][1][2]~=nil then
        local x = make_all_formulas(infoBlock[2][2], object)
        local y = make_all_formulas(infoBlock[2][3], object)
        add_pcall()
        if infoBlock[2][1][1] == 'globalVariable' then
            lua = lua..'if (varText_'..infoBlock[2][1][2]..'~=nil and varText_'..infoBlock[2][1][2]..'.text~=nil) then\ndisplay.remove(varText_'..infoBlock[2][1][2]..')\nend\nvarText_'..infoBlock[2][1][2]..' = display.newText(type(var_'..infoBlock[2][1][2]..')=="boolean" and (var_'..infoBlock[2][1][2]..' and app.words[373] or app.words[374]) or type(var_'..infoBlock[2][1][2]..')=="table" and encodeList(var_'..infoBlock[2][1][2]..') or var_'..infoBlock[2][1][2]..', '..x..', -'..y..', "fonts/font_1", 30)\n'
            lua = lua..'varText_'..infoBlock[2][1][2]..':setFillColor(0, 0, 0)'
            lua = lua.."\ncameraGroup:insert(varText_"..infoBlock[2][1][2]..")"
        else
            lua = lua..'if (target.varText_'..infoBlock[2][1][2]..'~=nil and target.varText_'..infoBlock[2][1][2]..'.text~=nil) then\ndisplay.remove(target.varText_'..infoBlock[2][1][2]..')\nend\ntarget.varText_'..infoBlock[2][1][2]..' = display.newText(type(target.var_'..infoBlock[2][1][2]..')=="boolean" and (target.var_'..infoBlock[2][1][2]..' and app.words[373] or app.words[374]) or type(target.var_'..infoBlock[2][1][2]..')=="table" and encodeList(target.var_'..infoBlock[2][1][2]..') or target.var_'..infoBlock[2][1][2]..', '..x..', -'..y..', "fonts/font_1", 30)\n'
            lua = lua..'target.varText_'..infoBlock[2][1][2]..':setFillColor(0, 0, 0)'
            lua = lua.."\ncameraGroup:insert(target.varText_"..infoBlock[2][1][2]..")"
        end
        end_pcall()
    elseif nameBlock == 'showVariable2' and infoBlock[2][1][2]~=nil then
        local x = make_all_formulas(infoBlock[2][2], object)
        local y = make_all_formulas(infoBlock[2][3], object)
        local size = make_all_formulas(infoBlock[2][4], object)
        local hex = make_all_formulas(infoBlock[2][5], object)
        local aligh = infoBlock[2][6][2]
        add_pcall()
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
        end_pcall()
    elseif nameBlock == 'hideVariable' and infoBlock[2][1][2]~=nil then
        add_pcall()
        if infoBlock[2][1][1] == 'globalVariable' then
            lua = lua..'display.remove(varText_'..infoBlock[2][1][2]..')\nvarText_'..infoBlock[2][1][2]..' = nil'
        else
            lua = lua..'display.remove(target.varText_'..infoBlock[2][1][2]..')\ntarget.varText_'..infoBlock[2][1][2]..' = nil'
        end
        end_pcall()
    elseif nameBlock=="removeVariableCamera" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua.."if ("..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2].."~=nil and "..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..".text ~= nil) then\nnotCameraGroup:insert("..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..")\nend"
        end_pcall()
     elseif nameBlock=="insertVariableCamera" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua.."if ("..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2].."~=nil and "..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..".text ~= nil) then\ncameraGroup:insert("..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..")\nend"
        end_pcall()
    elseif nameBlock=="saveVariable" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua..'local arrayVariables = plugins.json.decode(funsP["получить сохранение"]("'..(infoBlock[2][1][1]=="globalVariable" and app.idProject or obj_path)..'/variables"))'
        lua = lua..'\nfor i=1, #arrayVariables do\nif (arrayVariables[i][1]=='..infoBlock[2][1][2]..') then\narrayVariables[i][3] = '..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..'\nfunsP["записать сохранение"]("'..(infoBlock[2][1][1]=="globalVariable" and app.idProject or obj_path)..'/variables", plugins.json.encode(arrayVariables))\nbreak\nend\nend'
        end_pcall()
    elseif nameBlock=="readVariable" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua..'local arrayVariables = plugins.json.decode(funsP["получить сохранение"]("'..(infoBlock[2][1][1]=="globalVariable" and app.idProject or obj_path)..'/variables"))'
        lua = lua..'\nfor i=1, #arrayVariables do\nif (arrayVariables[i][1]=='..infoBlock[2][1][2]..') then\n'..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..'= arrayVariables[i][3]~=nil and arrayVariables[i][3] or 0\nbreak\nend\nend'
        lua = lua..'\nif '..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'varText_'..infoBlock[2][1][2]..' then\n '..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'varText_'..infoBlock[2][1][2]..'.text = type('..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..')=="boolean" and ('..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..' and app.words[373] or app.words[374]) or type('..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..')=="table" and encodeList('..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..') or '..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..'\nend'
        end_pcall()
    elseif nameBlock=="addElementArray" and infoBlock[2][2][2]~=nil then
        add_pcall()
        lua = lua..(infoBlock[2][2][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][2][2].."[#"..(infoBlock[2][2][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][2][2].."+1] = "..make_all_formulas(infoBlock[2][1], object)
        end_pcall()
    elseif nameBlock=="deleteElementArray" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua.."table.remove("..(infoBlock[2][1][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][1][2]..", "..make_all_formulas(infoBlock[2][2],object)..")"
        end_pcall()
    elseif nameBlock=="deleteAllElementsArray" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua..(infoBlock[2][1][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][1][2].." = {}"
        end_pcall()
    elseif nameBlock=="pasteElementArray" and infoBlock[2][2][2]~=nil then
        add_pcall()
         lua = lua.."if ("..make_all_formulas(infoBlock[2][3], object).."<=#"..(infoBlock[2][2][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][2][2].."+1 and "..make_all_formulas(infoBlock[2][3], object)..">0) then\ntable.insert("..(infoBlock[2][2][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][2][2]..", "..make_all_formulas(infoBlock[2][3], object)..", "..make_all_formulas(infoBlock[2][1], object)..")\nend"
        end_pcall()
    elseif nameBlock=="replaceElementArray" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua.."if ("..make_all_formulas(infoBlock[2][2], object).."<=#"..(infoBlock[2][1][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][1][2].."+1 and "..make_all_formulas(infoBlock[2][2], object)..">0) then\n"..(infoBlock[2][1][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][1][2].."["..make_all_formulas(infoBlock[2][2],object).."] = "..make_all_formulas(infoBlock[2][3],object).."\nend"
        end_pcall()
    elseif nameBlock=="saveArray" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua..'local arrayArrays = plugins.json.decode(funsP["получить сохранение"]("'..(infoBlock[2][1][1]=="globalArray" and app.idProject or obj_path)..'/arrays"))'
        lua = lua..'\nfor i=1, #arrayArrays do\nif (arrayArrays[i][1]=='..infoBlock[2][1][2]..') then\narrayArrays[i][3] = '..(infoBlock[2][1][1]=="globalArray" and '' or 'target.')..'list_'..infoBlock[2][1][2]..'\nfunsP["записать сохранение"]("'..(infoBlock[2][1][1]=="globalArray" and app.idProject or obj_path)..'/arrays", plugins.json.encode(arrayArrays))\nbreak\nend\nend\n'
        end_pcall()
    elseif nameBlock=="readArray" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua..'local arrayArrays = plugins.json.decode(funsP["получить сохранение"]("'..(infoBlock[2][1][1]=="globalArray" and app.idProject or obj_path)..'/arrays"))'
        lua = lua..'\nfor i=1, #arrayArrays do\nif (arrayArrays[i][1]=='..infoBlock[2][1][2]..') then\n'..(infoBlock[2][1][1]=="globalArray" and '' or 'target.')..'list_'..infoBlock[2][1][2]..'= arrayArrays[i][3]~=nil and arrayArrays[i][3] or {}\nbreak\nend\nend'
        end_pcall()
    elseif nameBlock=="columnStorageToArray" and infoBlock[2][3][2]~=nil then
        add_pcall()
        lua = lua.."local allArraysValues = plugins.json.decode('[\"'.."..make_all_formulas(infoBlock[2][2], object)..":gsub('\"','\\\\\"'):gsub('\\r\\n','\",\"'):gsub('\\n','\",\"')..'\"]')"
        lua = lua.."\nfor i=1, #allArraysValues do\nlocal values = plugins.json.decode('[\"'..allArraysValues[i]:gsub('\\\"','\\\\\"'):gsub(',','\",\"')..'\"]')\nallArraysValues[i] = values["..make_all_formulas(infoBlock[2][1], object).."]==nil and '' or values["..make_all_formulas(infoBlock[2][1], object).."]\nend"
        lua = lua.."\n"..(infoBlock[2][3][1]=="globalArray" and '' or 'target.').."list_"..infoBlock[2][3][2].." = allArraysValues"
        end_pcall()
    elseif nameBlock=="getRequest" and infoBlock[2][2][2]~=nil then
        add_pcall()
        lua = lua.."local function networkListener(event)\nif (mainGroup~=nil and mainGroup.x~=nil) then\n"..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2].." = event.response\nif ("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][2][2]..") then\n"..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][2][2]..".text = type("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..")=='boolean' and ("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2].." and app.words[373] or app.words[374]) or type("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..")=='table' and encodeList("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..") or "..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2].."\nend\nend\nend\nlocal header = {headers={[\"User-Agent\"] = \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36\"}}\n\nnetwork.request("..make_all_formulas(infoBlock[2][1],object)..",'GET',networkListener, header)"
        end_pcall()
    elseif nameBlock == 'lowerPen' then
    -- tableFeathers = {} сюда через table.insert(object) добавлять перья
    -- tableFeathersOptions[1] -размер пера
    -- tableFeathersOptions[2] - цвет r
    -- tableFeathersOptions[3] - цвет g
    -- tableFeathersOptions[4] - цвет b
        add_pcall()
        lua = lua.."if (target.isPen==nil) then\ntarget.isPen = true\nlocal line = display.newLine(target.x, target.y, target.x, target.y+1)\nline:setStrokeColor(tableFeathersOptions[2]/255,tableFeathersOptions[3]/255,tableFeathersOptions[4]/255,1)\nline.strokeWidth = tableFeathersOptions[1]\nstampsGroup:insert(line)\nline.oldX, line.oldY = target.x, target.y\nlocal timerPen\ntimerPen = timer.new(50, function()\nif (target.isPen and line.x) then\nif (math.sqrt(math.pow(target.x-line.oldX, 2) + math.pow(target.y-line.oldY, 2))>3) then\nline:append(target.x, target.y)\nline.oldX, line.oldY = target.x, target.y\nend\nelseif (line.x == nil) then\nline = display.newLine(target.x, target.y, target.x, target.y)\nline:setStrokeColor(tableFeathersOptions[2],tableFeathersOptions[3],tableFeathersOptions[4],1)\nline.strokeWidth = tableFeathersOptions[1]\ntable.insert(tableFeathers, #tableFeathers+1, line)\nstampsGroup:insert(line)\nelse\ntimer.cancel(timerPen)\nend\nend,0)\ntable.insert(tableFeathers, #tableFeathers+1, line)\nend"
        end_pcall()
    elseif nameBlock == 'raisePen' then
        lua = lua.."target.isPen=nil"
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
    elseif nameBlock == 'setAnchorVariable' and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..".anchorX, "..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..".anchorY = "..make_all_formulas(infoBlock[2][2], object).."/100, "..make_all_formulas(infoBlock[2][3], object).."/100"
        end_pcall()
    elseif nameBlock == 'toFrontLayerVar' and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..":toFront()"
        end_pcall()
    elseif nameBlock == 'toBackLayerVar' and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..":toBack()"
        end_pcall()
    elseif nameBlock == 'removeAdaptiveSizeDevice' then
        add_pcall()
        lua = lua.."mainGroup.xScale, mainGroup.yScale = 1, 1"
        end_pcall()
    end
    return lua
end

return(make_block)