
local scene_manager = class()

function scene_manager:constructor()
	self.current_scene = nil
end

function scene_manager:open(scene, notcache)
	notcache = notcache or false
	assert(scene.isinflated, "The scene was not created")
	if self.current_scene then
		if not cache then
			self.current_scene:destroy()
		else
			self.current_scene:hide()
		end
	end

	self.current_scene = scene
	self.current_scene:show()
end

return scene_manager