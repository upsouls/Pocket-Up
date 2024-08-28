
local handler = class()
local alertDialog = require 'core.ui.alertDialog'

function handler:_init()
	
end

function handler:onTouchMyProjects(e)
	if e.phase == 'ended' then
		ctx.sceneManager:goto("projects", {cache=false})
	end
end

function handler:onTouchMenu(e)
	
end

function handler:onTouchHelp(e)

end

function handler:onTouchUpsouls(e)

end

function handler:onTouchCreateBtn(e)
	if e.phase == "began" then
		dialog = alertDialog()
		dialog:show()
	end
end

return handler