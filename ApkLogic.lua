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

local appVersion = utils.isSim and "1.0" or system.getInfo("appVersionString")

local function import()
funsP["записать сс сохранение"]("appVersion", appVersion)
local counterProjects = 2
funsP["записать сс сохранение"]('counter_projects', counterProjects)

local pathFolderProject = "project_"..counterProjects

plugins.lfs.mkdir(system.pathForFile(pathFolderProject, system.DocumentsDirectory))

if utils.isWin or utils.isSim then
    local zip = require 'plugin.zip'
    timer.performWithDelay(10, function ()
    zip.uncompress({
        zipFile = 'importFile',
        zipBaseDir = system.ResourceDirectory,
        dstBaseDir = system.DocumentsDirectory,
        --password='',
        listener = function (e)
            if e.isError  then
                print('error import file exe build')
            else
                timer.performWithDelay(10, function ()
                    launch()
                end)
            end
        end
    })
    end)
else
    local zipAndroid = require 'plugin.zipAndroid'
    zipAndroid.uncompress {
        path=system.pathForFile("importFileAndroid", system.ResourceDirectory),
        folder=system.pathForFile(pathFolderProject, system.DocumentsDirectory),
        listener=launch,
        --password=''
    }
end
end

if funsP["прочитать сс сохранение"]('counter_projects') >= 2 then
    if appVersion ~= funsP["прочитать сс сохранение"]("appVersion") then
        import()
        return true
    end
    launch()
    return true
end

import()