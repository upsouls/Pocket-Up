
local handler = class()

function handler:_init()
	
end

function handler:onTouchBack(e)
	if e.phase == 'ended' then
		ctx.sceneManager:goto("menu", {cache=false})
	end
end

function handler:onTouchMenu(e)
	
end

function handler:onTouchCreateBtn(e)
	--if e.phase == 'ended' then
		ctx.sceneManager:goto("objects", {cache=false})
	--end
end

return handler