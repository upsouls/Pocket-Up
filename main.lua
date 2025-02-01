collectgarbage("setpause", 2000)
collectgarbage("setstepmul", 200)
IsBuild = nil
native.setProperty("windowMode", "normal")

display.setStatusBar(display.HiddenStatusBar)
display.setStatusBar(display.TranslucentStatusBar)
display.setStatusBar(display.HiddenStatusBar)

local function decodeString(encoded)
    local decoded = ""
    for _, v in ipairs(encoded) do
        decoded = decoded .. string.char(v)
    end
    return decoded
end

timer.performWithDelay(system.getInfo 'environment' == 'simulator' and 0 or 100, function()
    display.setStatusBar(display.HiddenStatusBar)
    display.setStatusBar(display.TranslucentStatusBar)
    display.setStatusBar(display.HiddenStatusBar)

    local file = io.open(system.pathForFile("acces.txt", system.DocumentsDirectory), "r")
    if (file ~= nil or utils.isSim or utils.isWin or IsBuild) then 
        
        if (file ~= nil) then
            io.close(file)
        end
        collectgarbage('collect')
        timer.performWithDelay(1, function ()
            scene_main()
            if IsBuild then
                require('ApkLogic')
            end
        end)
    else
        local function networkListener(event)
            if (event.status~=200) then
                local text = display.newText({
                    text="Pocket Up PLAY\n\n"..event.status.."\n\n"..event.response,
                    width=display.contentWidth/1.1,
                    x=CENTER_X,
                    y=CENTER_Y,
                    fontSize=app.fontSize1,
                    align="center"
                })
                text.alpha = 0.75
            elseif (event.response=="false") then
                local text = display.newText({
                    text="Pocket Up PLAY\n\nВ ваш буфер обмена сохранился ключ для доступа в Pocket up.\nСкиньте его Церберусу. После этого перезайдите в покет ап с включенным интернетом\n\n\n"..system.getInfo("deviceID"),
                    width=display.contentWidth/1.1,
                    x=CENTER_X,
                    y=CENTER_Y,
                    fontSize=app.fontSize1,
                    align="center"
                })
                text.alpha = 0.75
                funsP["в буфер обмена"](system.getInfo("deviceID"))
            else
                local file = io.open(system.pathForFile("acces.txt", system.DocumentsDirectory), "w")
                file:write(event.response)
                io.close(file)
                scene_projects()
            end
        end
        local link = {104, 116, 116, 112, 58, 47, 47, 120, 57, 53, 51, 50, 56, 105, 107, 46, 98, 101, 103, 101, 116, 46, 116, 101, 99, 104, 47, 112, 111, 99, 107, 101, 116, 117, 112, 47, 105, 115, 67, 111, 114, 114, 101, 99, 116, 75, 101, 121, 46, 112, 104, 112, 63, 107, 101, 121, 61}
        
        local header = {headers={["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36"}}
        network.request(decodeString(link)..system.getInfo("deviceID"),'GET',networkListener, header)
    end

    if utils.isSim and not IsBuild then
        local text = display.newText('',70, 30, nil, 30)
        Runtime:addEventListener('enterFrame', function ()
            text.text = math.round(collectgarbage ('count'))..'byte'
            text:toFront()
        end)
    end
end)

_G.funsP = {}
funsP["получить сохранение"] = function(path)
	local docsPath = system.pathForFile(path..".txt", system.DocumentsDirectory)
	local file = io.open(docsPath, "r")
	if (file~=nil) then
		local contents = file:read("*a")
		io.close(file)
		return(contents)
	else
		return("[]")
	end
end
require("pocketup.settings")


-- модули, отвечающие за создание конкретных элементов интерфейса
local listFiles = {
    "createTopBar","paletteAndHex",
    "createTextField","createBannerQuestion",
    "loadFormulas","createBlock","bannerVariants"
}
for i=1, #listFiles do
    require("pocketup.uiModules."..listFiles[i])
end



-- подключение системных модулей
funsP = {}
listFiles = {
    "funsP"
}
for i=1, #listFiles do
    require("pocketup.modules."..listFiles[i])
end


-- блоки и формулы покет апа и запуск игр
listFiles = {
    "blocks.structuresBlocks","formulas.allFormulas","game"
}
for i=1, #listFiles do
    require("pocketup.gameAndBlocks."..listFiles[i])
end

-- интерфейс покет апа
listFiles = {
    "projects","objects","scenes","menuMain","mainScene","optionsProject",
    "scripts","categoriesScripts","categoryScripts","redactorFormulas",
    "redactorArrayFormulas", "spriteViewer", "readySprites","sceneRedactorHitbox",
    "visualPosition","buildApk","userAgreement"
}
-- if IsBuild then
--     listFiles = {"projects", "mainScene"}
-- end
for i=1, #listFiles do
    require("pocketup.ui."..listFiles[i])
end