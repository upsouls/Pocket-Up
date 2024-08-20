local Library = require 'CoronaLibrary'

local lib = Library:new{name = 'plugin.zipAndroid', publisherId = 'com.ganin'}

local function showUnsupportedMessage()
	native.showAlert('Not Supported', 'The zipAndroid plugin is not supported on the simulator, please build for Android device', {'OK'})
end

function lib.extractFile()
	showUnsupportedMessage()
end

function lib.removeFile()
	showUnsupportedMessage()
end

function lib.addFolder()
	showUnsupportedMessage()
end

function lib.addFile()
	showUnsupportedMessage()
end

function lib.uncompress()
	showUnsupportedMessage()
end

function lib.compress()
	showUnsupportedMessage()
end

return lib
