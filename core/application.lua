--[[
	
]]

local application = class()

-- Конструктор
function application:_init()
	ctx = {}
	ctx.app = {}

	self:_getSystemInfo()
	self:_getScreenSafeArea()

	ctx.preferences = require('core.preferences')()
end

function application:_getScreenSafeArea()
	-- Размеры экрана
	ctx.app.x = display.contentCenterX
	ctx.app.y = display.contentCenterY
	ctx.app.height = 720 * display.pixelHeight / display.pixelWidth
	ctx.app.width = 720

	local topInset, leftInset, bottomInset, rightInset = display.getSafeAreaInsets()
	ctx.app.topInset = topInset
	ctx.app.leftInset = leftInset
	ctx.app.rightInset = rightInset
	ctx.app.bottomInset = bottomInset
	
	ctx.app.left = ctx.app.x - ctx.app.width / 2 + leftInset
	ctx.app.top = ctx.app.y - ctx.app.height / 2 + topInset
	ctx.app.right = ctx.app.x + ctx.app.width / 2 - rightInset
	ctx.app.bottom = ctx.app.y + ctx.app.height / 2 - bottomInset
	ctx.app.actionBarSize = ctx.app.height * 0.06 -- not ctx.app.isSim and display.statusBarHeight * 1.55 or 55 * 1.55
end

function application:_getSystemInfo()
	ctx.app.buildcode = 5
	ctx.app.lang = system.getPreference('locale', 'language'):lower()
	ctx.app.deviceId = system.getInfo('deviceID')
	ctx.app.isAndroid = system.getInfo('platform') == 'android'
	ctx.app.isSim = system.getInfo('environment') == 'simulator'
	ctx.app.isWin = system.getInfo('platform') == "win32"
	ctx.app.docDir = system.pathForFile('', system.DocumentsDirectory) .. '/'
end

-- При создании
-- Вызывается когда приложение готово к старту
function application:create()
	
end

function application:launch()
	ctx.sceneManager = require('core.sceneManager')()
	self:create()
end

return application