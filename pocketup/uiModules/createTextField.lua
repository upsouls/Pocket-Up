-- создание поля для ввода текста

--[[
header - заголовок;
placeholder - подсказка для заполнения текстового поля;
isCorrectValue - не обязательно для заполнения(nil). при вводе текста вызывается эта функция для проврки на корректность заполнения поля. если поле корректно - вернется "", если нет - "название ошибки";
value - необязательное поле для заполнения(nil). при старте установит пример-значение  в текстовое поле;
funEditingEnd - функция, вызывающаяся когда пользователь написал ответ и отправил его;
]]


app.cerberus.newInputLine = function(header, placeholder, isCorrectValue, value, funEditingEnd, isCenter)

local CENTER_X = CENTER_X
local CENTER_Y = CENTER_Y
if (app.scene=='game') then
    CENTER_X, CENTER_Y = 0, 0
end


if (isCorrectValue==nil) then
    isCorrectValue = function()
        return("")
    end
end
if (value==nil) then
    value = ""
end
local backgroundBlackAlpha = display.newRect(CENTER_X, CENTER_Y, display.contentHeight, display.contentHeight)
backgroundBlackAlpha:setFillColor(0,0,0,0.6)
local group = display.newGroup()
group.background = backgroundBlackAlpha
if (app.scene=="scripts") then
    app.scenes[app.scene][1]:insert(backgroundBlackAlpha)
    app.scenes[app.scene][1]:insert(group)
else
    app.scenes[app.scene][#app.scenes[app.scene]]:insert(backgroundBlackAlpha)
    app.scenes[app.scene][#app.scenes[app.scene]]:insert(group)
end
local rect = display.newRoundedRect(CENTER_X, CENTER_Y, display.contentWidth/1.08, 0, app.roundedRect)
rect.anchorY=0,
rect:setFillColor(66/255, 66/255, 66/255)
group:insert(rect)

backgroundBlackAlpha.alpha = 0
rect.alpha = 0
transition.to(backgroundBlackAlpha, {time=150, alpha=1})
transition.to(rect, {time=150, alpha=1})

local miniGroupTop = display.newGroup()
group:insert(miniGroupTop)
local miniGroupBottom = display.newGroup()
group:insert(miniGroupBottom)
local textHeader = display.newText({
    text=header,
    width=rect.width-display.contentWidth/17*2,
    x=CENTER_X, 
    y=CENTER_Y+display.contentWidth/17,
    font=nil,
    fontSize=app.fontSize0,
})
textHeader.anchorY=0
miniGroupTop:insert(textHeader)
local textPlaceholder = display.newText({
    text=placeholder,
    width=rect.width-display.contentWidth/17*2,
    x=CENTER_X, 
    y=textHeader.y+textHeader.height+display.contentWidth/17,
    font=nil,
    fontSize=app.fontSize2,
})
miniGroupTop:insert(textPlaceholder)
local input = native.newTextBox(-display.contentWidth, textPlaceholder.y--[[+textPlaceholder.height]], textHeader.width, textHeader.width/10)
input.isEditable = true
input.hasBackground = false
if utils.isSim or utils.isWin then
    input:setTextColor(0,0,0)
    input.size = 25
else
    input:setTextColor(1,1,1)
end
input.anchorY=0
miniGroupTop:insert(input)
input.x = CENTER_X


input.text = value
native.setKeyboardFocus(input)
if (value~="") then
    input:setSelection(0, plugins.utf8.len(value))
end

local rectInput = display.newRect(CENTER_X, input.y+input.height, input.width, display.contentWidth/150)
rectInput.anchorY=0
miniGroupTop:insert(rectInput)

local textError = display.newText({
    text="--",
    width=rect.width-display.contentWidth/17*2,
    x=CENTER_X, 
    y=rectInput.y+rectInput.height+display.contentWidth/34,
    font=nil,
    fontSize=app.fontSize2,
})
textError.anchorY = 0
textError:setFillColor(1, 113/255, 67/255)
miniGroupTop:insert(textError)

local textButtonOk = display.newText(app.words[16], 0, 0, nil, app.fontSize1)
textButtonOk:setFillColor(171/255, 219/255, 241/255)
local rectButtonOk = display.newRoundedRect(CENTER_X+textHeader.width/2, CENTER_Y, textButtonOk.width+display.contentWidth/10, textButtonOk.height+display.contentWidth/30, app.roundedRect)
rectButtonOk.anchorX, rectButtonOk.anchorY = 1, 0
textButtonOk.x, textButtonOk.y = rectButtonOk.x-rectButtonOk.width/2, rectButtonOk.y+rectButtonOk.height/2
rectButtonOk:setFillColor(66/255,66/255, 66/255)
miniGroupBottom:insert(rectButtonOk)
miniGroupBottom:insert(textButtonOk)
local textButtonCancel = display.newText(app.words[17], 0, 0, nil, app.fontSize1)
textButtonCancel:setFillColor(171/255, 219/255, 241/255)
local rectButtonCancel = display.newRoundedRect(rectButtonOk.x-rectButtonOk.width-display.contentWidth/40, CENTER_Y, textButtonCancel.width+display.contentWidth/20, textButtonCancel.height+display.contentWidth/30, app.roundedRect)
rectButtonCancel.anchorX, rectButtonCancel.anchorY = 1, 0
textButtonCancel.x, textButtonCancel.y = rectButtonCancel.x-rectButtonCancel.width/2, rectButtonCancel.y+rectButtonCancel.height/2
rectButtonCancel:setFillColor(66/255,66/255, 66/255)
miniGroupBottom:insert(rectButtonCancel)
miniGroupBottom:insert(textButtonCancel)


-- AAAAAAAAAAAAAAAAAAAAA
-- AAAAAAAAAAAAAAAAAAAAA
-- AAAAAAAAAAAAAAAAAAAAA
-- AAAAAAAAAAAAAAAAAAAAA
-- AAAAAAAAAAAAAAAAAAAAA
local touchNoTouch = nil
local function touchEditingEnd(event)
    if (event.target.textButton.alpha>0.9) then
        if (event.phase=="began") then
            event.target:setFillColor(99/255, 99/255, 99/255)
        elseif (event.phase=="moved") then
            event.target:setFillColor(66/255, 66/255, 66/255)
        else
            event.target:setFillColor(66/255, 66/255, 66/255)
            native.setKeyboardFocus(nil)
            input.isEditable = false
            rectButtonOk:removeEventListener("touch", touchEditingEnd)
            rectButtonCancel:removeEventListener("touch", touchEditingEnd)
            backgroundBlackAlpha:removeEventListener("touch",touchNoTouch)
            rect:removeEventListener("touch",touchNoTouch)

            transition.to(backgroundBlackAlpha, {time=200, alpha=0,onComplete=function()
                display.remove(backgroundBlackAlpha)
            end})
            display.remove(input)
            transition.to(group, {time=200, alpha=0, onComplete=function()
                display.remove(group)
            end})

            if (funEditingEnd~=nil) then
                if (event.target==rectButtonOk) then
                    funEditingEnd({["isOk"]=true, ["value"]=input.text:gsub("^%s+", ""):gsub("%s+$", ""),})
                else
                    funEditingEnd({["isOk"]=false})
                end
            end
        end
    end
    return(true)
end
rectButtonOk.textButton = textButtonOk
rectButtonCancel.textButton = textButtonCancel
rectButtonOk:addEventListener("touch", touchEditingEnd)
rectButtonCancel:addEventListener("touch", touchEditingEnd)

touchNoTouch = function(event)
    if (event.phase=="ended" and event.target==backgroundBlackAlpha) then
        native.setKeyboardFocus(nil)
        input.isEditable = false
        rectButtonOk:removeEventListener("touch", touchEditingEnd)
        rectButtonCancel:removeEventListener("touch", touchEditingEnd)
        backgroundBlackAlpha:removeEventListener("touch",touchNoTouch)
        rect:removeEventListener("touch",touchNoTouch)

        transition.to(backgroundBlackAlpha, {time=200, alpha=0, inComplete=function()
            display.remove(backgroundBlackAlpha)
        end})
        display.remove(input)
        transition.to(group, {time=200, alpha=0, inComplete=function()
            display.remove(group)
        end})

        if (funEditingEnd~=nil) then
            funEditingEnd({["isOk"]=false})
        end
    end
    return(true)
end
backgroundBlackAlpha: addEventListener("touch",touchNoTouch)
rect:addEventListener("touch",touchNoTouch)

local function updateHeightRect()
    rect.height = miniGroupTop.height+miniGroupBottom.height+(textError.text~="" and display.contentWidth/10 or display.contentWidth/30)+display.contentWidth/30
    miniGroupBottom.y = miniGroupTop.height+(textError.text~="" and display.contentWidth/10 or display.contentWidth/30)
    group.y = -group.height/2
end

local function isError(value)
    local oldTextError = textError.text
    textError.text = isCorrectValue(value:gsub("^%s+", ""):gsub("%s+$", ""))
    if (textError.text ~= "" and oldTextError~=textError.text) then
        textPlaceholder:setFillColor(1, 113/255, 67/255)
        rectInput:setFillColor(1, 113/255, 67/255)
        updateHeightRect()
        textButtonOk.alpha = 0.25
        textButtonOk:setFillColor(1,1,1)
    elseif (textError.text == "" and oldTextError~="") then
        textPlaceholder:setFillColor(171/255, 219/255, 241/255)
        rectInput:setFillColor(171/255, 219/255, 241/255)
        updateHeightRect()
        textButtonOk.alpha = 1
        textButtonOk:setFillColor(171/255, 219/255, 241/255)
    end
end
isError(value)


input:addEventListener("userInput", function (event)
    if (event.phase=="began") then
    elseif (event.phase=="editing") then

        isError(event.text:gsub("^%s+", ""):gsub("%s+$", ""))

        if (select(2, string.gsub(event.oldText, "\n", "\n")) ~= select(2, string.gsub(event.text, "\n", "\n")) and select(2, string.gsub(event.text, "\n", "\n"))<6 ) then
            event.target.height = textHeader.width/12*math.min(math.max(select(2, string.gsub(event.text, "\n", "\n"))+1, 1), 6)
            rectInput.y = input.y+input.height
            textError.y = rectInput.y+rectInput.height+display.contentWidth/34
            updateHeightRect()
        end
    elseif (event.pahse=="ended") then
    end
end)
return(group)
end