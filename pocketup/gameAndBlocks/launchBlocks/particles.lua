return {
    setPositionParticle = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."local particle = objectsParticles["..make_all_formulas(infoBlock[2][1], object).."]\nif (particle~=nil) then\nparticle.x, particle.y = "..make_all_formulas(infoBlock[2][2], object)..", -"..make_all_formulas(infoBlock[2][3], object).."\nend"
        return lua.."\nend)"
    end,

    editPositionXParticle = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."local particle = objectsParticles["..make_all_formulas(infoBlock[2][1], object).."]\nif (particle~=nil) then\nparticle.x = particle.x+"..make_all_formulas(infoBlock[2][2], object).."\nend"
        return lua.."\nend)"
    end,

    editPositionYParticle = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."local particle = objectsParticles["..make_all_formulas(infoBlock[2][1], object).."]\nif (particle~=nil) then\nparticle.y = particle.y-"..make_all_formulas(infoBlock[2][2], object).."\nend"
        return lua.."\nend)"
    end,

    deleteParticle = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."local particle = objectsParticles["..make_all_formulas(infoBlock[2][1], object).."]\nif (particle~=nil) then\ndisplay.remove(particle)\nobjectsParticles["..make_all_formulas(infoBlock[2][1], object).."]=nil\nend"
        return lua.."\nend)"
    end,

    deleteAllParticles = function ()
        local lua = "pcall(function()\n"
        lua = lua.."for key, value in pairs(objectsParticles) do\ndisplay.remove(value)\nend\nobjectsParticles = {}"
        return lua.."\nend)"
    end,

    createRadialParticle = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if infoBlock[2][2][2]~=nil then
            local idsGL = {
                GL_ZERO=0,GL_ONE=1,GL_DST_COLOR=774,GL_ONE_MINUS_DST_COLOR=775,GL_SRC_ALPHA=770,GL_ONE_MINUS_SRC_ALPHA=771,GL_DST_ALPHA=772,GL_ONE_MINUS_DST_ALPHA=773,GL_SRC_ALPHA_SATURATE=776,GL_SRC_COLOR=768,GL_ONE_MINUS_SRC_COLOR=769,SRC_COLOR=768
            }
            local lua = "pcall(function()\n"
            lua = lua.."local startRgb = utils.hexToRgb("..make_all_formulas(infoBlock[2][23], object)..")\nlocal startVarianceRgb = utils.hexToRgb("..make_all_formulas(infoBlock[2][24], object)..")\nlocal finishRgb = utils.hexToRgb("..make_all_formulas(infoBlock[2][25], object)..")\nfinishVarianceRgb = utils.hexToRgb("..make_all_formulas(infoBlock[2][26], object)..")\n"
            lua = lua.."if (objectsParticles["..make_all_formulas(infoBlock[2][1], object).."]~=nil) then\ndisplay.remove(objectsParticles["..make_all_formulas(infoBlock[2][1], object).."])\nend\npcall(function()\nlocal particle = display.newEmitter({\nemitterType=1,\ntextureFileName='"..obj_path.."/image_"..infoBlock[2][2][2]..".png',\nmaxParticles="..make_all_formulas(infoBlock[2][3], object)..",\nabsolutePosition="..make_all_formulas(infoBlock[2][4], object)..",\nangle="..make_all_formulas(infoBlock[2][5], object)..",\nangleVriance="..make_all_formulas(infoBlock[2][6], object)..",\nmaxRadius="..make_all_formulas(infoBlock[2][7], object)..",\nmaxRadiusariance="..make_all_formulas(infoBlock[2][8], object)..",\nminRadius="..make_all_formulas(infoBlock[2][9], object)..",\nminRadiusVariance="..make_all_formulas(infoBlock[2][10], object)..",\nrotatePerSecond="..make_all_formulas(infoBlock[2][11], object)..",\nrotatePerSecondVariance="..make_all_formulas(infoBlock[2][12], object)..",\nparticleLifespan="..make_all_formulas(infoBlock[2][13], object)..",\nparticleLifespanVariance="..make_all_formulas(infoBlock[2][14], object)..",\nstartParticleSize="..make_all_formulas(infoBlock[2][15], object)..",\nstartParticleSizeVariance="..make_all_formulas(infoBlock[2][16], object)..",\nfinishParticleSize="..make_all_formulas(infoBlock[2][17], object)..",\nfinishParticleSizeVariance="..make_all_formulas(infoBlock[2][18], object)..",\nrotationStart="..make_all_formulas(infoBlock[2][19], object)..",\nrotationStartVariance="..make_all_formulas(infoBlock[2][20], object)..",\nrotationEnd="..make_all_formulas(infoBlock[2][21], object)..",\nrotationEndVariance="..make_all_formulas(infoBlock[2][22], object)..",\nstartColorRed=startRgb[1],\nstartColorGreen=startRgb[2],\nstartColorBlue=startRgb[3]\n,\nstartColorVarianceRed=startVarianceRgb[1],\nstartColorVarianceGreen=startVarianceRgb[2],\nstartColorVarianceBlue=startVarianceRgb[3],\nfinishColorRed=finishRgb[1],\nfinishColorGreen=finishRgb[2],\nfinishColorBlue=finishRgb[3],\nfinishColorVarianceRed=finishVarianceRgb[1],\nfinishColorVarianceRed=finishVarianceRgb[2],\nfinishColorVariance=finishVarianceRgb[3],\nblendFuncSource="..idsGL[infoBlock[2][27][2]]..",\nblendFuncDestination="..idsGL[infoBlock[2][28][2]].."\n,startColorAlpha=1, finishColorAlpha=1, duration=-1\n}, system.DocumentsDirectory)\ncameraGroup:insert(particle)\nobjectsParticles["..make_all_formulas(infoBlock[2][1], object).."] = particle\nparticle.x, particle.y = 0, 0\nend)"
            return lua.."\nend)"
        end
    end,

    createLinearParticle = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        if infoBlock[2][2][2]~=nil then
            local idsGL = {
                GL_ZERO=0,GL_ONE=1,GL_DST_COLOR=774,GL_ONE_MINUS_DST_COLOR=775,GL_SRC_ALPHA=770,GL_ONE_MINUS_SRC_ALPHA=771,GL_DST_ALPHA=772,GL_ONE_MINUS_DST_ALPHA=773,GL_SRC_ALPHA_SATURATE=776,GL_SRC_COLOR=768,GL_ONE_MINUS_SRC_COLOR=769,SRC_COLOR=768
            }
            local lua = "pcall(function()\n"
            lua = lua.."local startRgb = utils.hexToRgb("..make_all_formulas(infoBlock[2][27], object)..")\nlocal startVarianceRgb = utils.hexToRgb("..make_all_formulas(infoBlock[2][28], object)..")\nlocal finishRgb = utils.hexToRgb("..make_all_formulas(infoBlock[2][29], object)..")\nfinishVarianceRgb = utils.hexToRgb("..make_all_formulas(infoBlock[2][30], object)..")\n"
            lua = lua.."if (objectsParticles["..make_all_formulas(infoBlock[2][1], object).."]~=nil) then\ndisplay.remove(objectsParticles["..make_all_formulas(infoBlock[2][1], object).."])\nend\nlocal particle = display.newEmitter({\nemitterType=0,\ntextureFileName='"..obj_path.."/image_"..infoBlock[2][2][2]..".png'\n,maxParticles="..make_all_formulas(infoBlock[2][3], object)..",\nabsolutePosition="..make_all_formulas(infoBlock[2][4], object)..",\nangle="..make_all_formulas(infoBlock[2][5], object)..",\nangleVriance="..make_all_formulas(infoBlock[2][6], object)..",\nspeed="..make_all_formulas(infoBlock[2][7], object)..",\nspeedVariance="..make_all_formulas(infoBlock[2][8], object)..",\nsourcePositionVariancex="..make_all_formulas(infoBlock[2][9], object)..",\nsourcePositionVariancey="..make_all_formulas(infoBlock[2][10], object)..",\ngravityx="..make_all_formulas(infoBlock[2][11], object)..",\ngravityy=-"..make_all_formulas(infoBlock[2][12], object)..",\nradialAcceleration="..make_all_formulas(infoBlock[2][13], object)..",\nradialAccelVariance="..make_all_formulas(infoBlock[2][14], object)..",\ntangentialAcceleration="..make_all_formulas(infoBlock[2][15], object)..",\ntangentialAccelVariance="..make_all_formulas(infoBlock[2][16], object)..",\nparticleLifespan="..make_all_formulas(infoBlock[2][17], object)..",\nparticleLLifespanVariance="..make_all_formulas(infoBlock[2][18], object)..",\nstartParticleSize="..make_all_formulas(infoBlock[2][19], object)..",\nstartParticleSizeVariance="..make_all_formulas(infoBlock[2][20], object)..",\nfinishParticleSize="..make_all_formulas(infoBlock[2][21], object)..",\nfinishParticleSizeVariance="..make_all_formulas(infoBlock[2][22], object)..",\nrotationStart="..make_all_formulas(infoBlock[2][23], object)..",\nrotationStartVariance="..make_all_formulas(infoBlock[2][24], object)..",\nrotationEnd="..make_all_formulas(infoBlock[2][25], object)..",\nrotationEndVariance="..make_all_formulas(infoBlock[2][26], object)..",\nstartColorRed=startRgb[1],startColorGreen=startRgb[2],startColorBlue=startRgb[3],startColorVarianceRed=startVarianceRgb[1],startColorVarianceGreen=startVarianceRgb[2],startColorVarianceBlue=startVarianceRgb[3],finishColorRed=finishRgb[1],finishColorGreen=finishRgb[2],finishColorBlue=finishRgb[3],finishColorVarianceRed=finishVarianceRgb[1],finishColorVarianceGreen=finishVarianceRgb[2],finishColorVarianceBlue=finishVarianceRgb[3],blendFuncSource="..idsGL[infoBlock[2][31][2]]..",\nblendFuncDestination="..idsGL[infoBlock[2][32][2]]..",\nstartColorAlpha=1, finishColorAlpha=1, duration=-1\n}, system.DocumentsDirectory)\ncameraGroup:insert(particle)\nobjectsParticles["..make_all_formulas(infoBlock[2][1], object).."] = particle\nparticle.x, particle.y = 0, 0"
            return lua.."\nend)"
        end
    end
}