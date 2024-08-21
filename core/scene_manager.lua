
local cls = require 'core.class'

local scene_manager = cls.class()

function scene_manager:constructor()
	self.current_scene = nil
end

function scene_manager:open(scene)
	assert(scene.isinflated, "The scene was not created")
	if self.current_scene then
		self.current_scene:destroy()
	end

	self.current_scene = scene
	self.current_scene:show()
end

return scene_manager