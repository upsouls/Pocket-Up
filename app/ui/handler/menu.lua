
local handler = class()

function handler:_init()
	
end

function handler:onTouchMyProjects(e)
	if e.phase == 'ended' then
		ctx.sceneManager:goto("projects", {cache=true})
	end
end

function handler:onTouchMenu(e)
	
end

function handler:onTouchHelp(e)

end

function handler:onTouchUpsouls(e)

end

function handler:onTouchCreateBtn(e)
	
end

return handler