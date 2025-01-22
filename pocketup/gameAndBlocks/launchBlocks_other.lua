
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

local function make_block(infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o, mainGroup, videos)
    if infoBlock[3] == 'off' then
        return ''
    end
    nameBlock = infoBlock[1]--args[i] = make_all_formulas(infoBlock[2][i], object)
    lua = ''
    -- local waitInsert = function (time)
    --     lua = lua..'threadFun.wait('..time..'*1000)'
    -- end
    if BlocksAllHandlers[nameBlock] then
        lua = lua..(BlocksAllHandlers[nameBlock](infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o, mainGroup, videos) or '')
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
    elseif nameBlock == 'endTimer' then
        lua = lua.."coroutine.yield()\nend"
    elseif nameBlock == 'fbGetValue' then
        add_pcall()
        local idBase = make_all_formulas(infoBlock[2][2], object)
        local idKey = make_all_formulas(infoBlock[2][1], object)
        local targVar = ''
        local parentShownVar = ''
        if infoBlock[2][3][1] == 'localVariable' then
            targVar = 'target.var_'..infoBlock[2][3][2]
            parentShownVar = 'target.varText_'..infoBlock[2][3][2]
        else
            targVar = 'var_'..infoBlock[2][3][2]
            parentShownVar = 'varText_'..infoBlock[2][3][2]
        end
    
        lua = lua..[[
            local function _listener(event)
                if event.isError then
                    ]]..targVar..[[ = 'ERROR'
                    ]]..parentShownVar..[[.text = ]]..targVar..[[
                else
                    ]]..targVar..[[ = require 'json'.decode(event.response)
                    ]]..parentShownVar..[[.text = require 'json'.decode(event.response)
                end
            end
            network.request(]]..idBase..'..\'/\'..'..idKey..'..\'.json\''..[[, "GET", _listener)]].."\n"
        end_pcall()
    elseif nameBlock == 'fbSetValue' then
        local idBase = make_all_formulas(infoBlock[2][3], object)
        local idKey = make_all_formulas(infoBlock[2][2], object)
        local value = make_all_formulas(infoBlock[2][1], object)
        
        lua = lua..[[
local headers = {
    ["Content-Type"] = "application/json"
}
            
local params = {
headers = headers,
body = require "json".encode(]]..value..[[)
}
local function _listener(event)
print(require "json".encode(event))
end
network.request(]]..idBase..'..\'/\'..'..idKey..'..\'.json\''..[[, "PUT", _listener, params)
]]
    elseif nameBlock == 'fbDelValue' then
        local idBase = make_all_formulas(infoBlock[2][2], object)
        local idKey = make_all_formulas(infoBlock[2][1], object)
        lua = lua..[[
network.request(]]..idBase..'..\'/\'..'..idKey..'..\'.json\''..[[, "DELETE", nil)
        
]]
    end
    return lua
end

return(make_block)