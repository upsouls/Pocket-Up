--[[
	
]]

--TODO: Сделать _getScreenArea()

local prefrences = require 'core.preferences'

local application = class()

-- Конструктор
function application:constructor()
	self.context = {}
	self.context.scenes = {}
	self.context.scene_manager = require('core.scene_manager')()
	self.context.preferences = prefrences()
	self:_getSystemInfo()
	self:_getScreenSafeArea()
end

function application:_getScreenSafeArea()
	-- Размеры экрана
	self.context.x = display.contentCenterX
	self.context.y = display.contentCenterY
	self.context.height = 720 * display.pixelHeight / display.pixelWidth
	self.context.width = 720

	local topInset, leftInset, bottomInset, rightInset = display.getSafeAreaInsets()
	self.context.topInset = topInset
	self.context.leftInset = leftInset
	self.context.rightInset = rightInset
	self.context.bottomInset = bottomInset
	--[[
		left, top, right, bottom координаты одноименных сторон экрана
	]]
	self.context.left = self.context.x - self.context.width / 2 + leftInset
	self.context.top = self.context.y - self.context.height / 2 + topInset
	self.context.right = self.context.x + self.context.width / 2 - rightInset
	self.context.bottom = self.context.y + self.context.height / 2 - bottomInset

end

function application:_getSystemInfo()
	self.context.buildcode = 2
	self.context.lang = system.getPreference('locale', 'language'):lower()
	self.context.deviceId = system.getInfo('deviceID')
	self.context.isAndroid = system.getInfo('platform') == 'android'
	self.context.isSim = system.getInfo('environment') == 'simulator'
	self.context.isWin = system.getInfo('platform') == "win32"
	self.context.docDir = system.pathForFile('', system.DocumentsDirectory) .. '/'
end

-- При создании
-- Вызывается когда приложение готово к старту
function application:create()
	
end

function application:getcontext()
	return self.context
end

function application:launch()
	self:create()
end

return application