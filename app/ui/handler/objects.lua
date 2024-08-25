
local handler = class()

function handler:_init()
	
end

function handler:onTouchBack(e)
	if e.phase == 'ended' then
		ctx.sceneManager:goto("projects", {cache=false})
	end
end

function handler:onTouchMenu(e)
	
end

function handler:onTouchCreateBtn(e)

end

function handler:onTouchPlayBtn(e)
	
end

-- Coming soon...
function handler:onTouchObject(e)
	
end

return handler