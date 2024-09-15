-- можешь добавлять новые параметры в функцию если потребуется
-- возвращай nil или '' если блок который ты получил тебе неизвестен
local lua;

local insert = function (code)
    lua = lua..code;
end

local add_pcall = function ()
    lua = lua..'\npcall(function()\n';
end
local pcall_end = function ()
    lua = lua..'\nend)\n';
end

local function make_block(infoBlock, object, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options)
	if infoBlock[3] == 'off' then
        return '';
    end
    local nameBlock = infoBlock[1];
    lua = '';

    local function F(infoBlock)
        return make_all_formulas(infoBlock, object)
    end

    if nameBlock == 'newAnimation' then --[[1: Картинка, 2: Имя анимации, 3: Первый фрейм, 4: Последний фрейм, 5: Время, 6: Выполнить раз ]]
        -- local image = infoBlock[2][1][2];
        -- local name = F(infoBlock[2][2]);
        -- local start = F(infoBlock[2][3]);
        -- local max = F(infoBlock[2][4]);
        -- local time = F(infoBlock[2][5]);
        -- local rep = F(infoBlock[2][6]);
        -- add_pcall();
    	-- insert([[
        --     local newIdImage = nil
        --     for i=1, #listImages do
        --         if (listImages[i]=="]]..image..[[") then
        --             newIdImage=i
        --             break
        --         end
        --     end
        --     if (newIdImage ~= nil) then
        --         local image_path = ]]..IDPROJECT..[['/scene_']]..scene_id..[['/object_']]..obj_id..[['/image_']]..image..[['.png\'
        --         Animations[name] = {}
        --     end
        -- ]]); --[[Animations - таблицу надо создать вначале кода]]
        -- pcall_end();
    elseif nameBlock == 'createMiniScene' then -- Создать мини сцену (имя сцены)
        local name = F(infoBlock[2][1]);
        add_pcall();
        insert("if miniScenes["..name.."] then display.remove(miniScenes[name]); end miniScenes["..name.."] = display.newGroup()\nnotCameraGroup:insert(miniScenes["..name.."])");
        pcall_end();
    elseif nameBlock == 'deleteMiniScene' then -- Удалить мини сцену (имя сцены)
        local name = F(infoBlock[2][1]);
        add_pcall();
        insert("if miniScenes["..name.."] then display.remove(miniScenes[name]); end miniScenes["..name.."] = nil");
        pcall_end();
    elseif nameBlock == 'miniSceneInsert' then -- Добавить в мини сцену (имя сцены)
        local name = F(infoBlock[2][1]);
        add_pcall();
        insert("miniScenes["..name.."]:insert(target)\ntarget.group = miniScenes["..name.."]");
        pcall_end();
    elseif nameBlock == 'miniSceneHide' then -- Скрыть мини сцену (имя сцены)
        local name = F(infoBlock[2][1]);
        add_pcall();
        insert("miniScenes["..name.."].isVisible = false");
        pcall_end();
    elseif nameBlock == 'miniSceneShow' then -- показать мини сцену (имя сцены)
        local name = F(infoBlock[2][1]);
        add_pcall();
        insert("miniScenes["..name.."].isVisible = true");
        pcall_end();
    elseif nameBlock == 'miniSceneInsertCamera' then -- Привязать мини сцену к камере (имя сцены)
        local name = F(infoBlock[2][1]);
        add_pcall();
        insert("cameraGroup:insert(miniScenes["..name.."])");
        pcall_end();
    elseif nameBlock == 'miniSceneInsertMiniScene' then -- Добавить в мини сцену мини сцену (имя сцены, имя добавляемой сцены)
        local name = F(infoBlock[2][1]);
        local name2 = F(infoBlock[2][2]);
        add_pcall();
        insert("miniScenes["..name.."]:insert(miniScenes["..name2.."])");
        pcall_end();
    elseif nameBlock == 'miniSceneRemoveCamera' then -- Отвязать мини сцену от камеры (имя сцены)
        local name = F(infoBlock[2][1]);
        add_pcall();
        insert("notCameraGroup:insert(miniScenes["..name.."])");
        pcall_end();
    end

    return(lua);
end

return(make_block);