return {
    setPosition = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        local x = make_all_formulas(infoBlock[2][1], object)
        local y = make_all_formulas(infoBlock[2][2], object)
        lua = lua..
        "target.x = "..x.."\
        target.y = -"..y..""
        return lua .. "\nend)"
    end,

    setPositionX = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        local x = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."target.x = "..x
        return lua .. "\nend)"
    end,

    setPositionY = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        local y = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."target.y = -"..y..""
        return lua .. "\nend)"
    end,

    editPositionX = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        local x = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."target:translate("..x..", 0)"
        return lua .. "\nend)"
    end,

    editPositionY = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        local y = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."target:translate(0,-"..y..")"
        return lua .. "\nend)"
    end,

    goTo = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options)
        local lua = "pcall(function()\n"
        if infoBlock[2][1][2] == 'touch' then
            lua = lua..'target.x , target.y = globalConstants.touchX, -globalConstants.touchY'
        elseif infoBlock[2][1][2] == 'random' then
            lua = lua..'target.x, target.y = math.random(-'..(tostring(options.orientation == "vertical" and options.displayWidth/2 or options.displayHeight/2))..','..(tostring(options.orientation == "vertical" and options.displayWidth/2 or options.displayHeight/2))..'), math.random(-'..tostring(options.orientation == "vertical" and options.displayHeight/2 or options.displayWidth/2)..','..tostring(options.orientation == "vertical" and options.displayHeight/2 or options.displayWidth/2)..')'
        else
            lua = lua..'local object = objects[\'object_'..infoBlock[2][1][2]..'\']\ntarget.x, target.y = object.x, object.y'
        end
        return lua .. "\nend)"
    end,

    goSteps = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        local steps = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."target:translate(pocketupFuns.sin(target.rotation)*"..steps..",- (pocketupFuns.cos(target.rotation)*"..steps.."))"
        return lua .. "\nend)"
    end,

    editRotateLeft = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        local rotate = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."target:rotate(-"..rotate..")"
        return lua .. "\nend)"
    end,

    editRotateRight = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        local rotate = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."target:rotate("..rotate..")"
        return lua .. "\nend)"
    end,

    setRotate = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        local rotate = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."target.rotation = "..rotate
        return lua .. "\nend)"
    end,

    setRotateToObject = function (infoBlock, object, images, sounds, make_all_formulas)
        if infoBlock[2][1][2]~=nil then
            local lua = "pcall(function()\n"
            lua = lua..'if ( objects[\'object_'..infoBlock[2][1][2]..'\']~=nil) then\ntarget.rotation = pocketupFuns.atan2(objects[\'object_'..infoBlock[2][1][2]..'\'].x - target.x, target.y - objects[\'object_'..infoBlock[2][1][2]..'\'].y)\nend'
            return lua .. "\nend)"
        end
    end,

    setTypeRotate = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        if infoBlock[2][1][2] == 'true' then
            lua = lua..'target.isFixedRotation = false'
        elseif infoBlock[2][1][2] == 'false' then
            lua = lua..'target.isFixedRotation = true'
        end
        return lua .. "\nend)"
    end,

    transitionPosition2 = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        local time = make_all_formulas(infoBlock[2][1], object)
        local x = make_all_formulas(infoBlock[2][2], object)
        local y = make_all_formulas(infoBlock[2][3], object)
        lua = lua..
        "transition.to(target, {time="..time.."*1000,\
        x="..x..", y= -"..y.."})"
        lua = lua.."\nend)\nthreadFun.wait("..time.."*1000)"
        return lua
    end,

    setLayer = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        lua = lua.."target.group:insert("..make_all_formulas(infoBlock[2][1], object).."+3, target)"
        return lua .. "\nend)"
    end,

    toFrontLayer = function ()
        return "target:toFront()"
    end,

    toBackLayer = function (infoBlock, object, images, sounds, make_all_formulas)
        return "target:toBack()"
    end,

    vibration = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        local time = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."timer.new(100,function() system.vibrate('impact') end , ("..time.."*1000)/100)"
        return lua .. "\nend)"
    end,

    addBody = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        if (infoBlock[2][1][2]~="noPhysic") then
            lua = lua..'target.physicsTable = {outline = graphics.newOutline(10, target.image_path, system.DocumentsDirectory), density=3, friction=0.3, bounce=0.3}\ntarget.physicsType = \''..infoBlock[2][1][2]..'\'\n'
            lua = lua..'target.physicsReload = function(target)\nlocal oldTypeRotation = target.isFixedRotation\nplugins.physics.removeBody(target)\n'
            lua = lua.."plugins.physics.addBody(target, target.physicsType , target.physicsTable)\ntarget.isFixedRotation = oldTypeRotation\nend"
            lua = lua..'\ntarget:physicsReload()'
            lua = lua.."\ntarget:addEventListener('collision', function(event)\nif (event.phase=='began') then\nevent.target.touchesObjects['obj_'..event.other.parent_obj.idObject] = true\ntimer.new(0, function()\nfor i=1, #events_collision do\nevents_collision[i](event.target, event.other.parent_obj.nameObject)\nend\nend)\nelseif (event.phase=='ended') then\nevent.target.touchesObjects['obj_'..event.other.parent_obj.idObject] = nil\ntimer.new(0, function()\nfor i=1, #events_endedCollision do\nevents_endedCollision[i](event.target, event.other.parent_obj.nameObject)\nend\nend)\nend\nend)"
        else
            lua = lua.."plugins.physics.removeBody(target)\ntarget.physicsReload = nil\ntarget.touchesObjects = {}"
        end
        return lua .. "\nend)"
    end,

    speedStepsToSecoond = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        local x = make_all_formulas(infoBlock[2][1], object)
        local y = make_all_formulas(infoBlock[2][2], object)
        lua = lua.."target:setLinearVelocity("..x..",- ("..y.."))"
        return lua .. "\nend)"
    end,

    rotateLeftForever = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        local force = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."target:applyTorque(-("..force..")*100)"
        return lua .. "\nend)"
    end,

    rotateRightForever = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        local force = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."target:applyTorque("..force.."*100)"
        return lua .. "\nend)"
    end,

    setGravityAllObjects = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        local x = make_all_formulas(infoBlock[2][1], object)
        local y = make_all_formulas(infoBlock[2][2], object)
        lua = lua..'plugins.physics.setGravity('..x..',-'..y..' )'
        return lua .. "\nend)"
    end,

    setWeight = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        local mass = make_all_formulas(infoBlock[2][1], object)
        lua = lua..'target.physicsTable.density = '..mass..'\ntarget:physicsReload()'
        return lua .. "\nend)"
    end,

    setElasticity = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        local bounce = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."target.physicsTable.bounce = "..bounce.."/100\ntarget:physicsReload()"
        return lua .. "\nend)"
    end,

    setFriction = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        local friction = make_all_formulas(infoBlock[2][1], object)
        lua = lua..'target.physicsTable.friction = '..friction..'/100\ntarget:physicsReload()'
        return lua .. "\nend)"
    end,

    showHitboxes = function ()
        return "plugins.physics.setDrawMode('hybrid')\n"
    end,

    hideHitboxes = function ()
        return "plugins.physics.setDrawMode('normal')\n"
    end,

    jump = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        lua = lua.."target:setLinearVelocity("..make_all_formulas(infoBlock[2][1], object)..", -"..make_all_formulas(infoBlock[2][2], object)..")"
        return lua .. "\nend)"
    end,

    jumpX = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        lua = lua.."local vX, vY = target:getLinearVelocity()\ntarget:setLinearVelocity("..make_all_formulas(infoBlock[2][1], object)..", vY)"
        return lua .. "\nend)"
    end,

    jumpY = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        lua = lua.."local vX, vY = target:getLinearVelocity()\ntarget:setLinearVelocity( vX, -"..make_all_formulas(infoBlock[2][1], object)..")"
        return lua .. "\nend)"
    end,

    jumpYIf = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        lua = lua.."local vX, vY = target:getLinearVelocity()\nif (vY==0) then\ntarget:setLinearVelocity( vX, -"..make_all_formulas(infoBlock[2][1], object)..")\nend"
        return lua .. "\nend)"
    end,

    setGravityScale = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        lua = lua.."local v = "..make_all_formulas(infoBlock[2][1], object).."\ntarget.gravityScale = tonumber(v, 0)"
        return lua .. "\nend)"
    end,

    setQuareHitbox = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        lua = lua.."target.physicsTable.outline, target.physicsTable.shape, target.physicsTable.radius = nil, nil, nil\ntarget:physicsReload()"
        return lua .. "\nend)"
    end,

    setQuareWHHitbox = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        lua = lua.."local w = "..make_all_formulas(infoBlock[2][1], object).."/2\nlocal h = "..make_all_formulas(infoBlock[2][2], object).."/2\ntarget.physicsTable.outline, target.physicsTable.radius, target.physicsTable.shape = nil, nil, {-w, -h, -w, h, w, h, w, -h}\ntarget:physicsReload()"
        return lua .. "\nend)"
    end,

    setCircleHitbox = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        lua = lua.."target.physicsTable.radius, target.physicsTable.outline, target.physicsTable.shape = "..make_all_formulas(infoBlock[2][1], object)..", nil, nil\ntarget:physicsReload()"
        return lua .. "\nend)"
    end,
}