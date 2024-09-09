-- можешь добавлять новые параметры в функцию если потребуется
-- возвращай nil или '' если блок который ты получил тебе неизвестен
local function make_block(infoBlock, object, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options)
	if infoBlock[3] == 'off' then
        return ''
    end
    local nameBlock = infoBlock[1]
    local lua = ''

    if (nameBlock == 'пример блока') then
    	lua = "print('привет мир!')"
    end

    return(lua)
end

return(make_block)