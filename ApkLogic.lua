-- if utils.isSim then
--     return true
-- end

local function removeAllObjects()
    local stage = display.getCurrentStage()

    for i = stage.numChildren, 1, -1 do
        local child = stage[i]
        if child then
            child:removeSelf()
            child = nil
        end
    end
end

local launch = function ()
    app.idProject = "project_"..2
    removeAllObjects()
    scene_run_game('scripts', {nil, nil,nil})
end


if funsP["прочитать сс сохранение"]('counter_projects') >= 2 then
    launch()
    return true
end

local counterProjects = 2
funsP["записать сс сохранение"]('counter_projects', counterProjects)

local pathFolderProject = "project_"..counterProjects

plugins.lfs.mkdir(system.pathForFile(pathFolderProject, system.DocumentsDirectory))

if utils.isWin or utils.isSim then
    local zip = require 'plugin.zip'
    zip.uncompress({
        zipFile = 'importFile',
        zipBaseDir = system.ResourceDirectory,
        dstBaseDir = system.DocumentsDirectory,
        listener = function (e)
            if e.isError  then
                print('error import file exe build')
            else
                launch()
            end
        end
    })
else
    local zipAndroid = require 'plugin.zipAndroid'
    zipAndroid.uncompress {
        path=system.pathForFile("importFileAndroid", system.ResourceDirectory),
        folder=system.pathForFile(pathFolderProject, system.DocumentsDirectory),
        listener=launch
    }
end
