-- базовые настройки проекта

utf8 = require( "plugin.utf8" )
utf8.split = function(text, sep) local result = {} for s in text:gmatch('[^' .. sep .. ']+') do result[#result + 1] = s end return result end
json = require("json")
widget = require("widget")
--math = require("math")
lfs = require("lfs")
physics = require("physics")
orientation = require('plugin.orientation')

words = require("pocketup.modules.loadLanguage")

display.setDefault( 'minTextureFilter', 'nearest' )
display.setDefault( 'magTextureFilter', 'nearest' )

os.removeFolder = function (path)
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local filePath = path.."/"..file
            local attr = lfs.attributes(filePath)
            if (attr~=nil) then
                if attr.mode == "directory" then
                    os.removeFolder(filePath)
                else
                    os.remove(filePath)
                end
            end
        end
    end
    lfs.rmdir(path)
end

isWin = system.getInfo 'platform' ~= 'android'
isSim = system.getInfo 'environment' == 'simulator'
_G.display = display
_G.system = system

_G.os = os
os.write = function (value , path , basedir)
    if type(path) ~= 'string' or value == nil then
        return true
    end
    local link = path
    if basedir then
        link = system.pathForFile(path , basedir)
    end
    local file = io.open(link , 'w')
    file:write(value)
    file:close()
end

os.read = function (path , mode , basedir)
    local link = path
    if type(path) ~= 'string' then
        return true
    end
    if type(mode) ~= 'string' then
        mode = '*a'
    end
    if basedir then
        link = system.pathForFile(path , basedir)
    end
    local file = io.open(link , 'r+')
    local value = file:read(mode)
    file:close()
    return value
end

display.setStatusBar(display.DefaultStatusBar)

function setFocus(object, id)
	display.getCurrentStage():setFocus( object, id )
end

cerberus = {}
cerberus.newImage = function(nameFile, directory, x, y)
	if (directory~=system.DocumentsDirectory) then
		return display.newImage(nameFile)
	else
		-- взять изображение из ресурсов
	end
end

IDPROJECT = nil
NMPROJECT = nil
IDSCENE = nil
IDOBJECT = nil
display.setDefault("background", 4/255, 34/255, 44/255)
display.contentWidth = display.actualContentWidth
--display.contentHeight = display.safeActualContentHeight
CENTER_X = display.contentCenterX
CENTER_Y = display.screenOriginY+display.contentHeight/2
SCENE = nil
SCENES = {}

---------------------------------------------------
printText = display.newText({
	text="тест",
	x=CENTER_X,
	y=CENTER_Y*1.5,
	width=display.contentWidth,
	font=nil,
	fontSize=nil,
})
function printC(event)
	printText.text = event
	printText:toFront()
end
printText.alpha=0
---------------------------------------------------

fontSize1 = math.min(display.contentWidth/20, 32.5)
fontSize2 = math.min(display.contentWidth/24, 25)
fontSize0 = fontSize1*1.125
roundedRect = fontSize1/8



_G.select_Scroll = ''
local function moveScroll(event)
	if event.type == 'scroll' and type(select_Scroll)~='string' then
		local x, y = select_Scroll:getContentPosition()
		if (event.scrollY > 0 and (y + (event.scrollY /2)) <0) or (event.scrollY < 0)  then
			select_Scroll:scrollToPosition({
				y = y + (event.scrollY),
				time = 0
			})
		end
		return true
	end
end
Runtime:addEventListener("mouse", moveScroll)

function string:split(delimiter)
    local result = { }
    local from  = 1
    local delim_from, delim_to = string.find( self, delimiter, from  )
    while delim_from do
      table.insert( result, string.sub( self, from , delim_from-1 ) )
      from  = delim_to + 1
      delim_from, delim_to = string.find( self, delimiter, from  )
    end
    table.insert( result, string.sub( self, from  ) )
    return result
end