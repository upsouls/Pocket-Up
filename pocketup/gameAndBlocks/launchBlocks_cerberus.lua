local lua = ''
local add_pcall = function ()
    lua = lua..'\npcall(function()\n'
end
local end_pcall = function ()
    lua = lua..'\nend)\n'
end
local function make_block(infoBlock, object, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options)
	if infoBlock[3] == 'off' then
        return ''
    end
    local nameBlock = infoBlock[1]
    lua = ''

    if (nameBlock=='setShapeHitbox') then
        add_pcall()
        lua = lua.."local tableShape = plugins.json.decode('"..infoBlock[2][1][2].."')\nlocal tableResizeShape = {}\nlocal size = target.property_size/100\nfor i=1, #tableShape/2 do\ntableResizeShape[i*2-1], tableResizeShape[i*2] = tableShape[i*2-1]*size, tableShape[i*2]*size\nend\ntarget.physicsTable.radius, target.physicsTable.outline, target.physicsTable.shape = nil, nil, tableResizeShape\ntarget:physicsReload()"
        end_pcall()
    end
    return(lua)
end

return(make_block)