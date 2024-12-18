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

    if nameBlock == 'newWebView' then -- имя ссылка х у ширина высота
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
    elseif nameBlock == 'endTimer' then
        lua = lua.."end)"
end

    return(lua)
end

return(make_block)