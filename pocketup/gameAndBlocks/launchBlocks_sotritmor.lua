-- можешь добавлять новые параметры в функцию если потребуется
-- возвращай nil или '' если блок который ты получил тебе неизвестен
local lua

local insert = function (code)
    lua = lua..code
end

local add_pcall = function ()
    lua = lua..'\npcall(function()\n'
end
local pcall_end = function ()
    lua = lua..'\nend)\n'
end

local function make_block(infoBlock, object, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, index)
	if infoBlock[3] == 'off' then
        return ''
    end
    local nameBlock = infoBlock[1]
    lua = ''

    local function F(infoBlock)
        return make_all_formulas(infoBlock, object)
    end

    if nameBlock == 'newAnimation' then --[[1: Картинка, 2: Имя анимации, 3: Первый фрейм, 4: Последний фрейм, 5: Время, 6: Выполнить раз ]]
        -- local image = infoBlock[2][1][2]
        -- local name = F(infoBlock[2][2])
        -- local start = F(infoBlock[2][3])
        -- local max = F(infoBlock[2][4])
        -- local time = F(infoBlock[2][5])
        -- local rep = F(infoBlock[2][6])
        -- add_pcall()
    	-- insert([[
        --     local newIdImage = nil
        --     for i=1, #listImages do
        --         if (listImages[i]=="]]..image..[[") then
        --             newIdImage=i
        --             break
        --         end
        --     end
        --     if (newIdImage ~= nil) then
        --         local image_path = ]]..app.idProject..[['/scene_']]..scene_id..[['/object_']]..obj_id..[['/image_']]..image..[['.png\'
        --         Animations[name] = {}
        --     end
        -- ]]) --[[Animations - таблицу надо создать вначале кода]]
        -- pcall_end()
    elseif nameBlock == 'createMiniScene' then -- Создать мини сцену (имя сцены)
        local name = F(infoBlock[2][1])
        add_pcall()
        insert("if miniScenes["..name.."] then display.remove(miniScenes[name]) end miniScenes["..name.."] = display.newGroup()\nnotCameraGroup:insert(miniScenes["..name.."])")
        pcall_end()
    elseif nameBlock == 'deleteMiniScene' then -- Удалить мини сцену (имя сцены)
        local name = F(infoBlock[2][1])
        add_pcall()
        insert("if miniScenes["..name.."] then display.remove(miniScenes[name]) end miniScenes["..name.."] = nil")
        pcall_end()
    elseif nameBlock == 'miniSceneInsert' then -- Добавить в мини сцену (имя сцены)
        local name = F(infoBlock[2][1])
        add_pcall()
        insert("miniScenes["..name.."]:insert(target)\ntarget.group = miniScenes["..name.."]")
        pcall_end()
    elseif nameBlock == 'miniSceneHide' then -- Скрыть мини сцену (имя сцены)
        local name = F(infoBlock[2][1])
        add_pcall()
        insert("miniScenes["..name.."].isVisible = false")
        pcall_end()
    elseif nameBlock == 'miniSceneShow' then -- показать мини сцену (имя сцены)
        local name = F(infoBlock[2][1])
        add_pcall()
        insert("miniScenes["..name.."].isVisible = true")
        pcall_end()
    elseif nameBlock == 'miniSceneInsertCamera' then -- Привязать мини сцену к камере (имя сцены)
        local name = F(infoBlock[2][1])
        add_pcall()
        insert("cameraGroup:insert(miniScenes["..name.."])")
        pcall_end()
    elseif nameBlock == 'miniSceneInsertMiniScene' then -- Добавить в мини сцену мини сцену (имя сцены, имя добавляемой сцены)
        local name = F(infoBlock[2][1])
        local name2 = F(infoBlock[2][2])
        add_pcall()
        insert("miniScenes["..name.."]:insert(miniScenes["..name2.."])")
        pcall_end()
    elseif nameBlock == 'miniSceneRemoveCamera' then -- Отвязать мини сцену от камеры (имя сцены)
        local name = F(infoBlock[2][1])
        add_pcall()
        insert("notCameraGroup:insert(miniScenes["..name.."])")
        pcall_end()
    elseif nameBlock == 'newWebView' then -- имя ссылка х у ширина высота
        local name = F(infoBlock[2][1])
        local link = F(infoBlock[2][2])
        local x = F(infoBlock[2][3])
        local y = F(infoBlock[2][4])
        local width = F(infoBlock[2][5])
        local height = F(infoBlock[2][6])
        --add_pcall()
        insert("local myWeb = native.newWebView( "..x..", -"..y..", "..width..", "..height..")\
        cameraGroup:insert(myWeb)\
        myWeb:request("..link..")\
        WebViews["..name.."] = myWeb")
        --pcall_end()
    elseif nameBlock == 'setWebViewX' then -- имя , x
        local name = F(infoBlock[2][1])
        local x = F(infoBlock[2][2])
        add_pcall()
        insert("WebViews["..name.."].x = "..x)
        pcall_end()
    elseif nameBlock == 'setWebViewY' then -- имя , y
        local name = F(infoBlock[2][1])
        local y = F(infoBlock[2][2])
        add_pcall()
        insert("WebViews["..name.."].y = - ("..y..")")
        pcall_end()
    elseif nameBlock == 'insertWebInMiniScene' then -- имя мини сцены , имя
        local name = F(infoBlock[2][2])
        local name2 = F(infoBlock[2][1])
        add_pcall()
        insert("miniScenes["..name.."]:insert(WebViews["..name2.."])")
        pcall_end()
    elseif nameBlock == 'setWebViewWidth' then -- имя ширина
        local name = F(infoBlock[2][1])
        local width = F(infoBlock[2][2])
        add_pcall()
        insert("WebViews["..name.."].width = "..width.."")
        pcall_end()
    elseif nameBlock == 'setWebViewHeight' then -- имя высота
        local name = F(infoBlock[2][1])
        local height = F(infoBlock[2][2])
        add_pcall()
        insert("WebViews["..name.."].height = "..height.."")
        pcall_end()
    elseif nameBlock == 'setLinkWebView' then -- имя ссылка
        local name = F(infoBlock[2][1])
        local link = F(infoBlock[2][2])
        add_pcall()
        insert("WebViews["..name.."]:request("..link..")")
        pcall_end()
    elseif nameBlock == 'backWebView' then -- имя  (сайт назад)
        local name = F(infoBlock[2][1])
        add_pcall()
        insert("WebViews["..name.."]:back()")
        pcall_end()
    elseif nameBlock == 'forwardWebView' then -- имя  (сайт вперед)
        local name = F(infoBlock[2][1])
        add_pcall()
        insert("WebViews["..name.."]:forward()")
        pcall_end()
    elseif nameBlock == 'stopWebView' then -- имя  (остановить загрузку браузера)
        local name = F(infoBlock[2][1])
        add_pcall()
        insert("WebViews["..name.."]:stop()")
        pcall_end()
    elseif nameBlock == 'reloadWebView' then -- имя  (перегазрузить браузер)
        local name = F(infoBlock[2][1])
        add_pcall()
        insert("WebViews["..name.."]:reload()")
        pcall_end()
--     elseif nameBlock == 'timer2' then -- 3 функция
--         local rep = make_all_formulas(infoBlock[2][1], object)
--         local time = make_all_formulas(infoBlock[2][2], object)
--         lua = lua..
--         "for i=1, type("..rep..") == 'number' and "..rep.." or 0 do"
-- --             local key = target.parent_obj.nameObject\
-- -- for i=1, #events_function[key]["fun_'..infoBlock[2][3][2]..'"] do\
-- -- events_function[key]["fun_'..infoBlock[2][3][2]..'"][i](target)\
-- -- end\
-- elseif nameBlock == 'repeat2' then -- 2 функция
--     wait_type = 'repeat'
--         local rep = make_all_formulas(infoBlock[2][1], object)
--         lua = lua .. 'local _repeat\n'
--         add_pcall()
--         lua = lua..'local function onComplete()\
--                 local key = target.parent_obj.nameObject\
--                 for i=1, #events_function[key]["fun_'..infoBlock[2][2][2]..'"] do\
--                 events_function[key]["fun_'..infoBlock[2][2][2]..'"][i](target)\
--                 end\
--                 end\
--             _repeat = timer.GameNew2(0,'..rep..', onComplete, function()\
--             if not (target ~= nil and target.x ~= nil) then\
--                 pcall(function() timer.cancel(_repeat) end)\
--                 return true\
--             end\n'
--     elseif nameBlock == 'repeatIsTrue2' then -- второй функция
--         wait_type = 'repeat'
--         local condition = make_all_formulas(infoBlock[2][1], object)
--         lua = lua .. 'local _repeat\n'
--         add_pcall()
--         lua = lua..[[
--         local repeatIsTrue
--         local function onComplete()
--         local key = target.parent_obj.nameObject
--         for i=1, #events_function[key]["fun_]]..infoBlock[2][2][2]..[["] do
--         events_function[key]["fun_]]..infoBlock[2][2][2]..[["][i](target)
--         end
--         end
--         _repeat = repeatIsTrue
--         repeatIsTrue = timer.GameNew(0,0, function()
--         if not (]]..condition..[[) then
--         timer.cancel(repeatIsTrue)
--         onComplete()
--         return true
--         end
--         if not (target ~= nil and target.x ~= nil) then
--         pcall(function() timer.cancel(_repeat) end)
--         return true
--         end]]
    elseif nameBlock == 'endTimer' then
        lua = lua.."end)"
    elseif nameBlock == 'runLua' then
    local code = make_all_formulas(infoBlock[2][1], object)
    add_pcall()
    lua = lua .. 'local p1 = '..code..'\
    p1 = plugins.utf8.gsub(p1, \'setfenv\', \'print\'); p1 = plugins.utf8.gsub(p1, \'loadstring\', \'print\')\
    p1 = plugins.utf8.gsub(p1, \'currentStage\', \'fps\');p1 = plugins.utf8.gsub(p1, \'getCurrentStage\', \'getDefault\')\
    p1 = plugins.utf8.gsub(p1, \'setFocus\', \'display.getCurrentStage():setFocus\'); p1 = plugins.utf8.gsub(p1, \'settingsSave.txt\', \'\')\
    \
    __GetGlobalData = function()\
        return {\
        math = math, os = os, io = io, transition = transition, tostring = tostring, tonumber = tonumber,\
        assert = assert, debug = debug, collectgarbage = collectgarbage, display = display, module = module,\
        native = native, coroutine = coroutine, ipairs = ipairs, network = network, pcall = pcall, print = print,\
        string = string, xpcall = xpcall, package = package, table = table, unpack = unpack, setmetatable = setmetatable, next = next,\
        graphics = graphics, system = system, rawequal = rawequal,  getmetatable = getmetatable, timer = timer,\
        newproxy = newproxy, metatable = metatable, rawset = rawset, coronabaselib = coronabaselib, type = type,\
        audio = audio, pairs = pairs, select = select, rawget = rawget, Runtime = Runtime, error = error,\
        utf8 = require("plugin.utf8"), pasteboard = require("plugin.pasteboard"), androidFilePicker = require("plugin.androidFilePicker"),\
        tinyfiledialogs = require("plugin.tinyfiledialogs"), exportFile = require("plugin.exportFile"), zip = require("plugin.zip"),\
        orientation = require("plugin.orientation"), app = app, utils = utils, object = target\
        \
        }\
    end\
    loadstring("\\nlocal G = {};\\nfor key, value in pairs(__GetGlobalData()) do\\nG[key] = value\\nend\\nsetfenv(1, G)\\n"..p1)()\
    '
    pcall_end()
end

    return(lua)
end

return(make_block)