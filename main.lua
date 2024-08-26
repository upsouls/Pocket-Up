native.setProperty("windowMode", "maximized")

display.setStatusBar(display.HiddenStatusBar)
display.setStatusBar(display.TranslucentStatusBar)
display.setStatusBar(display.HiddenStatusBar)

timer.performWithDelay(system.getInfo 'environment' == 'simulator' and 0 or 100, function()
    display.setStatusBar(display.HiddenStatusBar)
    display.setStatusBar(display.TranslucentStatusBar)
    display.setStatusBar(display.HiddenStatusBar)

    local file = io.open(system.pathForFile("acces.txt", system.DocumentsDirectory), "r")
    if (file ~= nil or isSim) then 
        if (file ~= nil) then
            io.close(file)
        end
        scene_projects()
    else
        local function networkListener(event)
            if (event.status~=200) then
                local text = display.newText({
                    text="Pocket Up PLAY\n\n"..event.status.."\n\n"..event.response,
                    width=display.contentWidth/1.1,
                    x=CENTER_X,
                    y=CENTER_Y,
                    fontSize=fontSize1,
                    align="center"
                })
                text.alpha = 0.75
            elseif (event.response=="false") then
                local text = display.newText({
                    text="Pocket Up PLAY\n\nВ ваш буфер обмена сохранился ключ для доступа в Pocket up.\nСкиньте его Церберусу. После этого перезайдите в покет ап с включенным интернетом\n\n\n"..system.getInfo("deviceID"),
                    width=display.contentWidth/1.1,
                    x=CENTER_X,
                    y=CENTER_Y,
                    fontSize=fontSize1,
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
            print(event.response, event.status)
        end
        local header = {headers={["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36"}}
        network.request("http://x95328ik.beget.tech/pocketup/isCorrectKey.php?key="..system.getInfo("deviceID"),'GET',networkListener, header)
    end
    --
end)

-- интерфейс
local listFiles = {
    "settings","funsP"
    ,"paletteAndHex","createTopBar",
    "createTextField","createBannerQuestion",
    "projects","objects",
    "scenes","mainScene",
    "optionsProject","listFormulasAndBlocks",
    "createBlock","scripts",
    "categoriesScripts","categoryScripts",
    "redactorFormulas","redactorArrayFormulas", "game", "spriteViewer"
}
--в файле funsP функции сикода переделанные в solar2d код
-- require("pocketup.convertXmlToJson") плагин будем использовать
for i=1, #listFiles do
    require("pocketup."..listFiles[i])
end