
local sceneManager = class()

function sceneManager:_init()
	self.scenes = {
		menu = require('app.ui.menu'),
		projects = require('app.ui.projects'),
		objects = require('app.ui.objects')
	}
	self.cached = {
		menu = self.scenes.menu()
	}

	self.currentScene = self.cached.menu
	self.currentScene:show()
end

function sceneManager:goto(scene, options)
	print(options.cache)
	if options.cache then
		self.currentScene:hide()
	else
		self.currentScene:destroy()
		table.removeByValue(self.cached, self.currentScene)
	end

	if type(scene) == "string" then
		if not self.cached[scene] then
			self.cached[scene] = self.scenes[scene](options)
		end

		self.currentScene = self.cached[scene]
		self.currentScene:show()
		return
	end

	self.currentScene = scene
	self.currentScene:show()
end

return sceneManager