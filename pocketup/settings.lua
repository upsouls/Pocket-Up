-- базовые настройки проекта
_G.app = {}
app.cerberus = {}
app.scenes = {}
app.scene = 'null'

_G.plugins = {}
_G.utils = {}

plugins.utf8 = require( "plugin.utf8" )
plugins.utf8.split = function(text, sep) local result = {} for s in text:gmatch('[^' .. sep .. ']+') do result[#result + 1] = s end return result end
plugins.json = require("json")
plugins.widget = require("widget")

plugins.lfs = require("lfs")
plugins.physics = require("physics")
plugins.orientation = require('plugin.orientation')

display.contentWidth = display.actualContentWidth
--display.contentHeight = display.safeActualContentHeight
CENTER_X = display.contentCenterX
CENTER_Y = display.screenOriginY+display.contentHeight/2

app.words = require("pocketup.modules.loadLanguage")

display.setDefault( 'minTextureFilter', 'nearest' )
display.setDefault( 'magTextureFilter', 'nearest' )

os.removeFolder = function (path)
    for file in plugins.lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local filePath = path.."/"..file
            local attr = plugins.lfs.attributes(filePath)
            if (attr~=nil) then
                if attr.mode == "directory" then
                    os.removeFolder(filePath)
                else
                    os.remove(filePath)
                end
            end
        end
    end
    plugins.lfs.rmdir(path)
end

utils.isWin = system.getInfo 'platform' ~= 'android'
utils.isSim = system.getInfo 'environment' == 'simulator'

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

app.cerberus.newImage = function(nameFile, directory, x, y)
	if (directory~=system.DocumentsDirectory) then
		return display.newImage(nameFile)
	else
		-- взять изображение из ресурсов
	end
end

app.idProject = nil
app.nmProject = nil
app.idScene = nil
app.idObject = nil
display.setDefault("background", 4/255, 34/255, 44/255)
app.scene = nil

---------------------------------------------------
utils.printText = display.newText({
	text="тест",
	x=CENTER_X,
	y=CENTER_Y*1.5,
	width=display.contentWidth,
	font=nil,
	fontSize=nil,
})
function utils.printC(event)
	utils.printText.text = event
	utils.printText:toFront()
end
utils.printText.alpha=0
---------------------------------------------------

app.fontSize1 = math.min(display.contentWidth/20, 32.5)
app.fontSize2 = math.min(display.contentWidth/24, 25)
app.fontSize0 = app.fontSize1*1.125
app.roundedRect = app.fontSize1/8



utils.select_Scroll = ''
local function moveScroll(event)
	if event.type == 'scroll' and type(utils.select_Scroll)~='string' then
		local x, y = utils.select_Scroll:getContentPosition()
		if (event.scrollY > 0 and (y + (event.scrollY /2)) <0) or (event.scrollY < 0)  then
			utils.select_Scroll:scrollToPosition({
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