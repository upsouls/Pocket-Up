funsP = {}

local pathSettingsSave = system.pathForFile("settingsSave.txt", system.DocumentsDirectory)
local fileSettingsSave = io.open(pathSettingsSave, "rb")

local isStartProject = false
if (fileSettingsSave==nil) then
	local file = io.open(pathSettingsSave, "wb")
    file:write(json.encode({
		['наличие сортировки проектов']='true',
		['counter_projects']=0,
		['список проектов']='[]',
		['сортировка проектов - дата открытия']="[]",
		['сортировка проектов - дата создания']="[]",
	}))
	isStartProject = true
	io.close(file)
else
	io.close(fileSettingsSave)
end

funsP["прочитать сс сохранение"] = function(nameSave)
	local file = io.open(pathSettingsSave, "r")
	local contents = json.decode(file:read("*a"))
	io.close(file)
	return(contents[nameSave])
end
funsP["записать сс сохранение"] = function(nameSave, value)
	local pathSettingsSave = system.pathForFile("settingsSave.txt", system.DocumentsDirectory)
	local file2 = io.open(pathSettingsSave, "r")
	local contents = json.decode(file2:read("*a"))
	io.close(file2)
	contents[nameSave] = value
	contents = json.encode(contents)
	local pathSettingsSave = system.pathForFile("settingsSave.txt", system.DocumentsDirectory)
	local file = io.open(pathSettingsSave, "w")
	file:write(contents)
	io.close(file)
	
	
end

funsP["получить проекты"] = function(isSort)
	if (isStartProject or #json.decode(funsP["прочитать сс сохранение"]("список проектов"))==0) then
		isStartProject = false
		local tableFor = {'project_1', 'project_1/scene_1', 'project_1/scene_1/object_1', 'project_1/scene_1/object_2', 'project_1/scene_1/object_3', 'project_1/scene_1/object_4'}
		local docsPath = system.pathForFile("", system.DocumentsDirectory)
		local resPath = system.pathForFile("", system.ResourceDirectory)
		for i=1, #tableFor do
			lfs.mkdir(docsPath.."/"..tableFor[i])
		end
		tableFor = {
			{"sprites/sprite_1.png","project_1/icon.png"},{"sprites/sprite_1.png","project_1/scene_1/icon.png"},
			{"sprites/sprite_2.png","project_1/scene_1/object_1/image_1.png"},{"sprites/sprite_3.png","project_1/scene_1/object_2/image_2.png"},
			{"sprites/sprite_3.png","project_1/scene_1/object_3/image_3.png"},{"sprites/sprite_4.png","project_1/scene_1/object_4/image_4.png"},
			{"sprites/sprite_5.png","project_1/scene_1/object_4/image_5.png"},
		}
		local isAndroid = isSim or  isWin
		for i=1, #tableFor do
			if (isAndroid) then
				local docsPath = system.pathForFile(tableFor[i][2], system.DocumentsDirectory)
				local resPath = system.pathForFile(tableFor[i][1], system.ResourceDirectory)
				local file = io.open(resPath, "rb")
				local contents = file:read("*a")
				io.close(file)
				local fileDoc = io.open(docsPath, "wb")
				fileDoc:write(contents)
				io.close(fileDoc)
			else
				local group = display.newGroup()
				local image = display.newImage(group, tableFor[i][1])
				display.save(group, {filename=tableFor[i][2], baseDir=system.DocumentsDirectory, captureOffscreenArea=true, backgroundColor={0,0,0,0}})
				display.remove(group)
			end
		end
		tableFor = {
			{"project_1/counter.txt","[1,4,5,0]"},
			{"project_1/scenes.txt","[[\"Сцена\",1]]"},
			{"project_1/scene_1/objects.txt","[[\"Фон\",1], [\"Облака1\",2],[\"Облака2\",3],[\"Животное\",4]]"},
			{"project_1/scene_1/object_1/images.txt","[[\"Фон\",1]]"},
			{"project_1/scene_1/object_2/images.txt","[[\"Облака\",2]]"},
			{"project_1/scene_1/object_3/images.txt","[[\"Облака\",3]]"},
			{"project_1/scene_1/object_4/images.txt","[[\"Крылья вверх\",4],[\"Крылья вниз\",5]]"},
			{"project_1/scene_1/object_1/scripts.txt","[]"},
			{"project_1/scene_1/object_2/scripts.txt",'[["start",[],"on"],["setPosition",[[["number",0]],[["number",0]]],"on"],["transitionPosition",[[["number",5]],[["-","-"],["number",7],["number",2],["number",0]],[["number",0]]],"on"],["timer",[[["number",1]],[["number",5]]],"on"],["setPosition",[[["number",7],["number",2],["number",0]],[["number",0]]],"on"],["transitionPosition",[[["number",1],["number",0]],[["-","-"],["number",7],["number",2],["number",0]],[["number",0]]],"on"],["timer",[[["number",0]],[["number",1],["number",0]]],"on"],["setPosition",[[["number",7],["number",2],["number",0]],[["number",0]]],"on"],["transitionPosition",[[["number",1],["number",0]],[["-","-"],["number",7],["number",2],["number",0]],[["number",0]]],"on"],["endTimer",[],"on"],["endTimer",[],"on"]]'},
			{"project_1/scene_1/object_3/scripts.txt",'[["start",[],"on"],["setPosition",[[["number",7],["number",2],["number",0]],[["number",0]]],"on"],["transitionPosition",[[["number",1],["number",0]],[["-","-"],["number",7],["number",2],["number",0]],[["number",0]]],"on"],["timer",[[["number",0]],[["number",1],["number",0]]],"on"],["setPosition",[[["number",7],["number",2],["number",0]],[["number",0]]],"on"],["transitionPosition",[[["number",1],["number",0]],[["-","-"],["number",7],["number",2],["number",0]],[["number",0]]],"on"],["endTimer",[],"on"]]'},
			{"project_1/scene_1/object_4/scripts.txt",'[["start",[],"on"],["transitionPosition",[[["number",1]],[["function","random"],["function","("],["-","-"],["number",3],["number",0],["number",0],["function",","],["number",3],["number",0],["number",0],["function",")"]],[["function","random"],["function","("],["-","-"],["number",2],["number",0],["number",0],["function",","],["number",2],["number",0],["number",0],["function",")"]]],"on"],["timer",[[["number",0]],[["number",1]]],"on"],["transitionPosition",[[["number",1]],[["function","random"],["function","("],["-","-"],["number",3],["number",0],["number",0],["function",","],["number",3],["number",0],["number",0],["function",")"]],[["function","random"],["function","("],["-","-"],["number",2],["number",0],["number",0],["function",","],["number",2],["number",0],["number",0],["function",")"]]],"on"],["endTimer",[],"on"],["timer",[[["number",0]],[["number",0],["number","."],["number",2]]],"on"],["nextImage",[],"on"],["endTimer",[],"on"]]'},
			{"project_1/scene_1/object_1/sounds.txt","[]"},
			{"project_1/scene_1/object_2/sounds.txt","[]"},
			{"project_1/scene_1/object_3/sounds.txt","[]"},
			{"project_1/scene_1/object_4/sounds.txt","[]"},
			{"project_1/options.txt","{\"orientation\":\"vertical\",\"aspectRatio\":false, \"displayWidth\":720, \"displayHeight\":1420}"},
			{"project_1/scene_1/functions.txt","[]"},
			{"project_1/variables.txt","[]"},
			{"project_1/arrays.txt","[]"},
			{"project_1/scene_1/object_1/variables.txt","[]"},
			{"project_1/scene_1/object_1/arrays.txt","[]"},
			{"project_1/scene_1/object_2/variables.txt","[]"},
			{"project_1/scene_1/object_2/arrays.txt","[]"},
			{"project_1/scene_1/object_3/variables.txt","[]"},
			{"project_1/scene_1/object_3/arrays.txt","[]"},
			{"project_1/scene_1/object_4/variables.txt","[]"},
			{"project_1/scene_1/object_4/arrays.txt","[]"},
		}
		for i=1, #tableFor do
			local docsPath = system.pathForFile(tableFor[i][1], system.DocumentsDirectory)
			local file = io.open(docsPath, "w")
			file:write(tableFor[i][2])
			io.close(file)
		end
		funsP["записать сс сохранение"]("список проектов",'[["'..words[43]..'","project_1"]]')
		funsP["записать сс сохранение"]("сортировка проектов - дата открытия",'[1]')
		funsP["записать сс сохранение"]("сортировка проектов - дата создания",'[1]')
		funsP["записать сс сохранение"]("counter_projects",1)
	end


	local tableReturn = {
		ids=json.decode(funsP["прочитать сс сохранение"]("сортировка проектов - дата "..(isSort and "открытия" or "создания"))),
		projects=json.decode(funsP["прочитать сс сохранение"]("список проектов"))
	}
	return(tableReturn)
end

funsP["получить сохранение"] = function(path)
	local docsPath = system.pathForFile(path..".txt", system.DocumentsDirectory)
	local file = io.open(docsPath, "r")
	if (file~=nil) then
		local contents = file:read("*a")
		io.close(file)
		return(contents)
	else
		return("[]")
	end
end
funsP["записать сохранение"] = function(path, value)
	local docsPath = system.pathForFile(path..".txt", system.DocumentsDirectory)
	local file = io.open(docsPath, "w")
	file:write(value)
	io.close(file)
end

funsP["копировать объект"] = function (pathObject, pathCopy, idProject)
	print(idTarget)
	local docsPath = system.pathForFile("", system.DocumentsDirectory)
	lfs.mkdir(docsPath.."/"..pathCopy)
	local tableFiles = {"variables", "arrays"}
	for i=1, #tableFiles do
		local answer = funsP["получить сохранение"](pathObject.."/"..tableFiles[i])
		funsP["записать сохранение"](pathCopy.."/"..tableFiles[i], answer)
	end

	local counter = json.decode(funsP["получить сохранение"](idProject.."/counter"))


	local answer = json.decode(funsP["получить сохранение"](pathObject.."/images"))
	local idsImages = {}
	for i=1,#answer do
		counter[3] = counter[3]+1
		idsImages["image"..answer[i][2]] = counter[3]
		local nameFile = "/image_"..answer[i][2]..".png"
		answer[i][2] = counter[3]
		local nameFileCopy = "/image_"..counter[3]..".png"
		local docsPath = system.pathForFile(pathObject..nameFile, system.DocumentsDirectory)
		local file2 = io.open(docsPath, "rb")
		local contents = file2:read("*a")
		io.close(file2)
		local docsPath = system.pathForFile(pathCopy..nameFileCopy, system.DocumentsDirectory)
		local file = io.open(docsPath, "wb")
		file:write(contents)
		io.close(file)
	end
	funsP["записать сохранение"](pathCopy.."/images", json.encode(answer))
	local answer = json.decode(funsP["получить сохранение"](pathObject.."/sounds"))
	local idsSounds = {}
	for i=1,#answer do
		counter[4] = counter[4]+1
		idsSounds["sound"..answer[i][2]] = counter[4]
		local nameFile = "/sound_"..answer[i][2]..".mp3"
		answer[i][2] = counter[4]
		local nameFileCopy = "/sound_"..counter[4]..".mp3"
		local docsPath = system.pathForFile(pathObject..nameFile, system.DocumentsDirectory)
		local file = io.open(docsPath, "r")
		local contents = file:read("*a")
		io.close(file)
		local docsPath = system.pathForFile(pathCopy..nameFileCopy, system.DocumentsDirectory)
		local file = io.open(docsPath, "wb")
		file:write(contents)
		io.close(file)
	end
	funsP["записать сохранение"](pathCopy.."/sounds", json.encode(answer))

	funsP["записать сохранение"](idProject.."/counter", json.encode(counter))


	local answer = json.decode(funsP["получить сохранение"](pathObject.."/scripts"))
	for i=1, #answer do
		local block = answer[i][2]
		if (block~=nil) then
			for i2=1, #block do
				if (block[i2] and block[i2][2]) then
					if (block[i2][1] == "sounds") then
						block[i2][2] = idsSounds["sound"..block[i2][2]]
					elseif (block[i2][1] == "images") then
						block[i2][2] = idsImages["image"..block[i2][2]]
					end
				end
			end
		end
	end
	funsP["записать сохранение"](pathCopy.."/scripts", json.encode(answer))
end

funsP["удалить объект"] = function(pathDir)
	local path = system.pathForFile(pathDir, system.DocumentsDirectory)
	for file in lfs.dir(path) do
		if (file~="." and file~="..") then
			if (file:find('[.]')) then
				os.remove(path.."/"..file)
			else
				funsP["удалить объект"](pathDir.."/"..file)
			end
		end
	end
	os.removeFolder(path)
end

funsP["создать сцену"] = function(idProject, pathScene)
	local pathProjectD = system.pathForFile(idProject, system.DocumentsDirectory)
	local pathSceneD = system.pathForFile(pathScene, system.DocumentsDirectory)
	--lfs.mkdir(pathSceneD)
	local counter = json.decode(funsP["получить сохранение"](idProject.."/counter"))
	counter[2] = counter[2]+1
	lfs.mkdir(pathSceneD)
	lfs.mkdir(pathSceneD.."/object_"..counter[2])
	funsP["записать сохранение"](idProject.."/counter", json.encode(counter))
	local objects = {{words[30], counter[2]}}
	funsP["записать сохранение"](pathScene.."/objects", json.encode(objects))
	funsP["записать сохранение"](pathScene.."/functions", "[]")
	funsP["записать сохранение"](pathScene.."/object_"..counter[2].."/arrays", "[]")
	funsP["записать сохранение"](pathScene.."/object_"..counter[2].."/variables", "[]")
	funsP["записать сохранение"](pathScene.."/object_"..counter[2].."/sounds", "[]")
	funsP["записать сохранение"](pathScene.."/object_"..counter[2].."/scripts", "[]")
	funsP["записать сохранение"](pathScene.."/object_"..counter[2].."/images", "[]")
end

funsP["проверить наличие файла"] = function(path)
	local path = system.pathForFile(path, system.DocumentsDirectory)
	local file = io.open(path, "r")
	local answer = file ~= nil
	if (answer) then
	io.close(file)
	end
	return(answer)
end

funsP["копировать сцену"] = function(idProject, pathScene, pathCopy)
	local path = system.pathForFile(pathCopy, system.DocumentsDirectory)
	lfs.mkdir(path)
	local contents = funsP["получить сохранение"](pathScene.."/functions")
	funsP["записать сохранение"](pathCopy.."/functions", contents)
	if (funsP["проверить наличие файла"](pathScene.."/icon.png")) then
		local path = system.pathForFile(pathScene.."/icon.png", system.DocumentsDirectory)
		local file = io.open(path, "rb")
		local contents = file:read("*a")
		io.close(file)
		local path = system.pathForFile(pathCopy.."/icon.png", system.DocumentsDirectory)
		local file = io.open(path, "wb")
		file:write(contents)
		io.close(file)
	end
	
	local objects = json.decode(funsP["получить сохранение"](pathScene.."/objects"))
	local idsObjects = {}
	for i=1, #objects do
		local counter = json.decode(funsP["получить сохранение"](idProject.."/counter"))
		counter[2] = counter[2]+1
		idsObjects["object"..objects[i][2]] = counter[2]
		funsP["записать сохранение"](idProject.."/counter", json.encode(counter))
		local oldIdObject = objects[i][2]
		objects[i][2] = counter[2]
		funsP["копировать объект"](pathScene.."/object_"..oldIdObject, pathCopy.."/object_"..objects[i][2], idProject)
	end
	funsP["записать сохранение"](pathCopy.."/objects", json.encode(objects))

	for i=1, #objects do
		local blocks = json.decode(funsP["получить сохранение"](pathCopy.."/object_"..objects[i][2].."/scripts"))
		for i2=1, #blocks do
			local formulas = blocks[i2][2]
			for i3=1, #formulas do
				if ((formulas[i3][1]=="objects" and formulas[i3][2]~=nil) or (formulas[i3][1]=="goTo" and type(formulas[i3][2])=="number")) then
					formulas[i3][2] = idsObjects["object"..formulas[i3][2]]
				end
			end
		end
		funsP["записать сохранение"](pathCopy.."/object_"..objects[i][2].."/scripts", json.encode(blocks))
	end
end

local pasteboard = require("plugin.pasteboard")
funsP["в буфер обмена"] = function(value)
	pasteboard.copy("string", value)
end

local toaster = require 'plugin.toaster'
funsP["вызвать уведомление"] = function(value)
	if (not isSim and not isWin) then
		toaster.longToast(value)
	end
end

local import = require 'plugins.import'
funsP["импортировать изображение"] = function(onCompleteImportImage)
	local isAndroid = isSim or  isWin
	local function debugOnComplete(event)
		local answer = {done=(event.isError and "error" or "ok"), isError=true, origFileName=event.filename}
		onCompleteImportImage(answer)
	end
    import.show("image/*",system.pathForFile('importfile.png' , system.DocumentsDirectory), isAndroid and onCompleteImportImage or debugOnComplete)
end

funsP["создать объект"] = function(idProject, pathObject, nameImage)
	local pathObjectD = system.pathForFile(pathObject, system.DocumentsDirectory)
	local idProjectD = system.pathForFile(idProject, system.DocumentsDirectory)
	local counter = json.decode(funsP["получить сохранение"](idProject.."/counter"))
	counter[3] = counter[3]+1
	funsP["записать сохранение"](idProject.."/counter", json.encode(counter))
	lfs.mkdir(pathObjectD)
	local file = io.open(system.pathForFile("importfile.png", system.DocumentsDirectory), "rb")
	local contents = file:read("*a")
	io.close(file)
	local file = io.open(pathObjectD.."/image_"..counter[3]..".png", "wb")
	file:write(contents)
	io.close(file)
	if isSim or isWin then
		local table = utf8.split(nameImage,'\\\\')
		nameImage = table[#table]
	else

	end
	funsP["записать сохранение"](pathObject.."/images", "[[\""..nameImage.."\","..counter[3].."]]")
	funsP["записать сохранение"](pathObject.."/scripts", "[]")
	funsP["записать сохранение"](pathObject.."/sounds", "[]")
	funsP["записать сохранение"](pathObject.."/variables", "[]")
	funsP["записать сохранение"](pathObject.."/arrays", "[]")
end

funsP["копировать проект"] = function(idProject, idCopy)
	local pathProject = system.pathForFile(idProject, system.DocumentsDirectory)
	local pathCopy = system.pathForFile(idCopy, system.DocumentsDirectory)
	lfs.mkdir(pathCopy)
	local file = io.open(pathProject.."/icon.png", "rb")
	if (file~=nil) then
		local contents = file:read("*a")
		io.close(file)
		local file = io.open(pathCopy.."/icon.png", "wb")
		file:write(contents)
		io.close(file)
	end
	local counter = json.decode(funsP["получить сохранение"](idProject.."/counter"))
	funsP["записать сохранение"](idCopy.."/counter", "["..counter[1]..",0,0,0]")
	funsP["записать сохранение"](idCopy.."/variables", funsP["получить сохранение"](idProject.."/variables"))
	funsP["записать сохранение"](idCopy.."/arrays", funsP["получить сохранение"](idProject.."/arrays"))
	funsP["записать сохранение"](idCopy.."/scenes", funsP["получить сохранение"](idProject.."/scenes"))
	funsP["записать сохранение"](idCopy.."/options", funsP["получить сохранение"](idProject.."/options"))
	local scenes = json.decode(funsP["получить сохранение"](idProject.."/scenes"))
	for i=1, #scenes do
		funsP["копировать сцену"](idCopy, idProject.."/scene_"..scenes[i][2], idCopy.."/scene_"..scenes[i][2])
	end

end

funsP["создать проект"] = function(pathProject)
	local path = system.pathForFile(pathProject, system.DocumentsDirectory)
	lfs.mkdir(path)
	lfs.mkdir(path.."/scene_1")
	lfs.mkdir(path.."/scene_1/object_1")
	funsP["записать сохранение"](pathProject.."/counter", "[1,1,0,0]")
	funsP["записать сохранение"](pathProject.."/scenes", "[[\""..words[28].."\",1]]")
	funsP["записать сохранение"](pathProject.."/scene_1/objects", "[[\""..words[30].."\",1]]")
	funsP["записать сохранение"](pathProject.."/scene_1/object_1/scripts", "[]")
	funsP["записать сохранение"](pathProject.."/scene_1/object_1/sounds", "[]")
	funsP["записать сохранение"](pathProject.."/scene_1/object_1/images", "[]")
	funsP["записать сохранение"](pathProject.."/options", "[]")
	local isAndroid = isSim or  isWin
	if (isAndroid) then
		local pathImage = system.pathForFile("sprites/icon_"..math.random(1,6)..".png", system.ResourceDirectory)
		local file = io.open(pathImage, "rb")
		local contents = file:read("*a")
		io.close(file)
		file = io.open(path.."/icon.png", "wb")
		file:write(contents)
		io.close(file)
	else
		local group = display.newGroup()
		local image = display.newImage(group, "sprites/icon_"..math.random(1,6)..".png")
		display.save(group, {filename=pathProject.."/icon.png", baseDir=system.DocumentsDirectory, captureOffscreenArea=true, backgroundColor={0,0,0,0}})
		display.remove(group)
	end
	funsP["записать сохранение"](pathProject.."/scene_1/functions", "[]")
	funsP["записать сохранение"](pathProject.."/scene_1/object_1/variables", "[]")
	funsP["записать сохранение"](pathProject.."/scene_1/object_1/arrays", "[]")
	funsP["записать сохранение"](pathProject.."/variables", "[]")
	funsP["записать сохранение"](pathProject.."/arrays", "[]")
end

funsP["добавить изображение в объект"] = function(path)

		local file = io.open(system.pathForFile("importfile.png", system.DocumentsDirectory), "rb")
		local contents = file:read("*a")
		io.close(file)
		local file = io.open(system.pathForFile(path, system.DocumentsDirectory), "wb")
		file:write(contents)
		io.close(file)
		os.remove(system.pathForFile("importfile.png", system.DocumentsDirectory))
end

funsP["импортировать звук"] = function(onComplete)
	local isAndroid = isSim or  isWin
	
	timer.performWithDelay(20, function()
		local function debugOnComplete(event)
			local answer = {done=(event.isError and "error" or "ok"), isError=true, origFileName=event.filename}
			onComplete(answer)
		end
		import.show("audio/*",system.pathForFile('fileimport.mp3' , system.DocumentsDirectory), isAndroid and onComplete or debugOnComplete)
	end)
end

funsP["добавить звук в объект"] = function(path)
	local file = io.open(system.pathForFile("fileimport.mp3", system.DocumentsDirectory), "rb")
	local contents = file:read("*a")
	io.close(file)
	local file = io.open(system.pathForFile(path, system.DocumentsDirectory), "wb")
	file:write(contents)
	io.close(file)
	--os.remove(system.pathForFile("fileimport.mp3", system.DocumentsDirectory))
end

local export = require 'plugins.export'
local zipAndroid = require 'plugin.zipAndroid'
funsP["экспортировать проект"] = function (id , name , listener)

	local options = json.decode(os.read(id..'/options.txt' , '*a' , system.DocumentsDirectory))
	options.name = name
	os.write(json.encode(options) ,id..'/options.txt' , system.DocumentsDirectory )
	if isSim or isWin then
		local zip = require( "plugin.zip" ) 
 
		local function zipListener( event )
 
    		if ( event.isError ) then
        		error('Error')
    		else
				timer.performWithDelay(20 , function ()
					export.export {
						path = system.pathForFile('export.zip', system.TemporaryDirectory),
						name = name..".up",
						listener = listener
					}
					timer.performWithDelay(20 , function ()
						os.remove(system.pathForFile('export.zip', system.TemporaryDirectory))
					end)
				end)
    		end
		end

		local zipOptions = { 
    		zipFile = "export.zip",
    		zipBaseDir = system.TemporaryDirectory,
    		srcBaseDir = system.DocumentsDirectory,
    		srcFiles = {'project_1/scenes.txt','project_1/options.txt'},
    		listener = zipListener
		}
		zip.compress( zipOptions )
	else
		zipAndroid.compress {
			level = 0,
			path = system.pathForFile('export.zip', system.TemporaryDirectory),
			folder = system.pathForFile(id, system.DocumentsDirectory),
			listener = function(e)
				if not e.isError then
					export.export {
						path = system.pathForFile('export.zip', system.TemporaryDirectory),
						name = name..'.up',
						listener = listener
					}
					timer.performWithDelay(20 , function ()
						os.remove(system.pathForFile('export.zip', system.TemporaryDirectory))
					end)
				end
			end
		}
	end
end


funsP["закрыть проект"] = function()
	os.exit()
end

funsP["корректность формулы"] = function(code)
	local answer = nil
    pcall(function()
        answer = loadstring('return '..code)()
	end)
    
    return (answer)
end

funsP["импортировать проект"] = function(onComplete)
	local isAndroid = isSim or  isWin
	local function onCompleteImportImage(event)
		if (event.done=="ok") then
			if (not isAndroid) then
				local counterProjects = funsP["прочитать сс сохранение"]('counter_projects')
				counterProjects = counterProjects+1
				funsP["записать сс сохранение"]('counter_projects', counterProjects)
				local pathFolderProject = "project_"..counterProjects
				lfs.mkdir(system.pathForFile(pathFolderProject, system.DocumentsDirectory))
				zipAndroid.uncompress {
					path=system.pathForFile("importfile.zip", system.DocumentsDirectory),
					folder=system.pathForFile(pathFolderProject, system.DocumentsDirectory),
					listener=function(event)
						onComplete(pathFolderProject)
					end
				}
			else
				-- РАСПАКОВКА ZIP НА ПК. файл зип в документах, называется importfile.zip
				-- в переменной pathFolderProjcect. в переменной написано project_id
				-- после распаковки вызови функцию onComplete(pathFolderProject)
			end
		end
	end
	local function debugOnCompleteImportImage(event)
		local answer = {done=(event.isError and "error" or "ok"), isError=true, origFileName=event.filename}
		onCompleteImportImage(answer)
	end
    import.show("*/*",system.pathForFile('importfile.zip' , system.DocumentsDirectory), isAndroid and onCompleteImportImage or debugOnCompleteImportImage)
end