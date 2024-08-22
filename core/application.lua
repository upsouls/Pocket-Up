--[[
	
]]

--TODO: Сделать _getScreenArea()

local cls = require 'core.class'
local prefrences = require 'core.preferences'

local application = cls.class()

-- Конструктор
function application:constructor()
	self.context = {}
	self.context.scenes = {}
	self.context.scene_manager = require('core.scene_manager')()
	self.context.preferences = prefrences()
	self:_getSystemInfo()
end

function application:_getSystemInfo()
	self.context.buildcode = 1
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