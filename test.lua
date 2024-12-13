
system.activate('multitouch')
plugins.physics.start(true)
local function getImageProperties(path, dir)
local image = display.newImage(path, dir)
image.alpha=0
local width = image.width
local height = image.height
display.remove(image)
return width, height
end
local thread = require('plugins.thread')
local joysticks = {}
local Timers = {}
local Timers_max = 0
local globalConstants = {isTouch=false, touchX=0, touchY=0, touchId=0, keysTouch={}, touchsXId={}, touchsYId={}, isTouchsId={}}
local pocketupFuns = {} pocketupFuns.sin = function(v) return(math.sin(math.rad(v))) end pocketupFuns.cos = function(v) return(math.cos(math.rad(v))) end pocketupFuns.tan = function(v) return(math.tan(math.rad(v))) end pocketupFuns.asin = function(v) return(math.deg(math.asin(v))) end pocketupFuns.acos = function(v) return(math.deg(math.acos(v))) end pocketupFuns.atan = function(v) return(math.deg(math.atan(v))) end pocketupFuns.atan2 = function(v, v2) return(math.deg(math.atan2(v, v2))) end pocketupFuns.roundUp = function(v) return(math.floor(v)+1) end pocketupFuns.connect = function(v,v2,v3) return(v..v2..(v3==nil and '' or v3)) end pocketupFuns.ternaryExpression = function(condition, answer1, answer2) return(condition and answer1 or answer2) end pocketupFuns.regularExpression = function(regular, expression) return(string.match(expression, regular)) end pocketupFuns.characterFromText = function(pos, value) return(plugins.utf8.sub(value,pos,pos)) end
pocketupFuns.getLinearVelocity = function(object, xOrY)
if (object.physicsReload == nil) then
return(0)
else
local vx, vy = object:getLinearVelocity()
return(xOrY=='x' and vx or vy)
end
end
pocketupFuns.getEllementArray = function(element, array) return(array[element]==nil and '' or array[element]) end pocketupFuns.containsElementArray = function(array, value)
local isElement = false
for i=1, #array do
if (array[i]==value) then
isElement = true
break
end
end
return(isElement)
end
pocketupFuns.getIndexElementArray = function(array, value)
 local index = 0
for i=1, #array do
if (array[i]==value) then
index = i
break
end
end
return(index)
end
pocketupFuns.levelingArray = function(array)
return(array)
end
pocketupFuns.displayPositionColor = function(x,y)
local hexColor
local function onColorSample(event)
hexColor = utils.rgbToHex({event.r, event.g, event.b})
return(hexColor)
end
display.colorSample(CENTER_X+x, CENTER_Y-y, onColorSample)
return(hexColor)
end
globalConstants.getTouchXId = function(id)
local answer = globalConstants.touchsXId[globalConstants.keysTouch['touch_'..id]]
return(answer==nil and 0 or answer)
end
globalConstants.getTouchYId = function(id)
local answer = globalConstants.touchsYId[globalConstants.keysTouch['touch_'..id]]
return(answer==nil and 0 or answer)
end
pocketupFuns.getIsTouchId = function(id)
return(globalConstants.isTouchsId[globalConstants.keysTouch['touch_'..id]]==true)
end
pocketupFuns.getCountTouch = function ()
local count = 0
for k, v in pairs(globalConstants.isTouchsId) do
count = count + 1
end
return(count)
end
pocketupFuns.jsonEncode = function(table2)
local table = nil pcall(function()
table = plugins.json.decode(table2)
end)
if (table==nil) then
return('')
else
local array = ''
for k, v in pairs(table) do
array = array..(array=='' and '' or '\n')..v
end
return(array)
end
end
pocketupFuns.isTouchObject2 = function(target, id)
return(target.touchesObjects['obj_'..id]==true)
end
pocketupFuns.countTouchesObjects = function(target)
local isTouch = false
for v, k in pairs(target.touchesObjects) do
isTouch = true
break
end
return(isTouch)
end


var_2 = 0
var_1 = 0
local myScene

local WebViews = {}
local events_keypressed = {}
local events_endKeypressed = {}
local textFields = {} local objects = {}
local events_touchBack = {}
local events_touchScreen = {}
local events_movedScreen = {}
local events_onTouchScreen = {}
local mainGroup
local playSounds = {}
local playingSounds = {}


function scene_1()

local focusCameraObject = nil
mainGroup = display.newGroup()
app.scene = 'game'
app.scenes[app.scene] = {mainGroup}
mainGroup.iscg = true
mainGroup.xScale, mainGroup.yScale = 1, 1
mainGroup.x, mainGroup.y = CENTER_X, CENTER_Y
local cameraGroup = display.newGroup()
local stampsGroup = display.newGroup()
cameraGroup:insert(stampsGroup)
mainGroup:insert(cameraGroup)
local notCameraGroup = display.newGroup()
mainGroup:insert(notCameraGroup)
objects = {}

local events_changeBackground = {}
local events_function = {}

local function broadcastFunction(nameFunction)
for key, value in pairs(objects) do
for i=1, #events_function[key][nameFunction] do
events_function[key][nameFunction][i](value)
for i2=1, #value.clones do
events_function[key][nameFunction][i](value.clones[i2])
end
end
end
end

myScene = 'project_2/scene_1'
local tableVarShow = {}
local tableNamesClones = {}
local miniScenes = display.newGroup()
cameraGroup:insert(miniScenes)
events_function['object_1'] = {}
events_function['object_1']['fun_1'] = {}
events_function['object_2'] = {}
events_function['object_2']['fun_1'] = {}
events_touchBack['object_1'] = {}
events_touchScreen['object_1'] = {}
events_movedScreen['object_1'] = {}
events_onTouchScreen['object_1'] = {}
events_changeBackground['object_1'] = {}
events_keypressed['object_1'] = {}
events_endKeypressed['object_1'] = {}
events_touchBack['object_2'] = {}
events_touchScreen['object_2'] = {}
events_movedScreen['object_2'] = {}
events_onTouchScreen['object_2'] = {}
events_changeBackground['object_2'] = {}
events_keypressed['object_2'] = {}
events_endKeypressed['object_2'] = {}
local function broadcastChangeBackground(numberImage)
for key, value in pairs(objects) do
for i=1, #events_changeBackground[key] do
events_changeBackground[key][i](value, numberImage)
for i2=1, #value.clones do
events_changeBackground[key][i](value.clones[i2], numberImage)
end
end
end
end
pcall(function()

local objectsParticles = {}
local listImages = {}
local listNamesImages = {}
local listSounds = {}
tableFeathers = {}
tableFeathersOptions = {3.5, 0, 0, 255}


local object_1 = display.newImage('images/notVisible.png')
object_1.infoSaveVisPos = 1

local objectsTable = plugins.json.decode(funsP['получить сохранение']('project_2/scene_1/objects'))
objectsTable[object_1.infoSaveVisPos][3] = nil
funsP['записать сохранение']('project_2/scene_1/objects', plugins.json.encode(objectsTable))
cameraGroup:insert(object_1)
object_1.touchesObjects = {}
local background = object_1
background.listImagesBack, background.listNamesImagesBack, background.obj_pathBack = listImages, listNamesImages, 'project_2/scene_1/object_1'
object_1.parent_obj = object_1
object_1.clones = {}
objects['object_1'], object_1.idObject = object_1, 1
object_1.numberImage = 1

object_1.tableVarShow, object_1.origWidth, object_1.origHeight, object_1.nameObject, object_1.property_size, object_1.property_brightness, object_1.property_color = {}, object_1.width, object_1.height, 'object_1', 100, 100, 0
object_1.countImages = 0
object_1.namesVars = {}
object_1.namesLists = {}


local events_start = {}
local events_touchObject = {} object_1.events_touchObject = events_touchObject
local events_keypressed = {} object_1.events_keypressed = events_keypressed
local events_endKeypressed = {} object_1.events_endKeypressed = events_endKeypressed
local events_movedObject = {} object_1.events_movedObject = events_movedObject
local events_onTouchObject = {} object_1.events_onTouchObject = events_onTouchObject
local events_collision = {} object_1.events_collision = events_collision
local events_endedCollision = {}  object_1.events_endedCollision = events_endedCollision
local events_startClone = {}
 object_1.events_startClone = events_startClone
object_1.group = cameraGroup
object_1:addEventListener('touch', function(event)
if (event.phase=='began') then
local newIdTouch=globalConstants.touchId+1
globalConstants.touchId = newIdTouch
globalConstants.keysTouch['touch_'..newIdTouch], globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = event.id, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale, true
globalConstants.isTouch, globalConstants.touchX, globalConstants.touchY = true, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale
display.getCurrentStage():setFocus(event.target, event.id)
event.target.isTouch = true
for key, value in pairs(objects) do
for i=1, #events_touchScreen[key] do
events_touchScreen[key][i](value)
for i2=1, #value.clones do
events_touchScreen[key][i](value.clones[i2])
end
end
end
for i=1, #events_touchObject do
events_touchObject[i](event.target)
end
elseif (event.phase=='moved') then
globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id] = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale
globalConstants.touchX, globalConstants.touchY = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale
for key, value in pairs(objects) do
for i=1, #events_movedScreen[key] do
events_movedScreen[key][i](value)
for i2=1, #value.clones do
events_movedScreen[key][i](value.clones[i2])
end
end
end
for i=1, #events_movedObject do
events_movedObject[i](event.target)
end
else
display.getCurrentStage():setFocus(event.target, nil)
globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = nil, nil, nil
if (pocketupFuns.getCountTouch(globalConstants.isTouchsId)==0) then
globalConstants.keysTouch = {}
globalConstants.isTouch = false
end
event.target.isTouch = nil
for key, value in pairs(objects) do
for i=1, #events_onTouchScreen[key] do
events_onTouchScreen[key][i](value)
for i2=1, #value.clones do
events_onTouchScreen[key][i](value.clones[i2])
end
end
end
for i=1, #events_onTouchObject do
events_onTouchObject[i](event.target)
end
end
return(true)
end)
for i=1, #events_start do
    events_start[i](object_1)
end

end)

pcall(function()

local objectsParticles = {}
local listImages = {1}
local listNamesImages = {'k'}
local listSounds = {}
tableFeathers = {}
tableFeathersOptions = {3.5, 0, 0, 255}


local object_2 = display.newImage('project_2/scene_1/object_2/image_1.png', system.DocumentsDirectory)
object_2.image_path = 'project_2/scene_1/object_2/image_1.png'
object_2.timers = {}
object_2.infoSaveVisPos = 2

local objectsTable = plugins.json.decode(funsP['получить сохранение']('project_2/scene_1/objects'))
objectsTable[object_2.infoSaveVisPos][3] = nil
funsP['записать сохранение']('project_2/scene_1/objects', plugins.json.encode(objectsTable))
cameraGroup:insert(object_2)
object_2.touchesObjects = {}
object_2.parent_obj = object_2
object_2.clones = {}
objects['object_2'], object_2.idObject = object_2, 2
object_2.numberImage = 1

object_2.tableVarShow, object_2.origWidth, object_2.origHeight, object_2.nameObject, object_2.property_size, object_2.property_brightness, object_2.property_color = {}, object_2.width, object_2.height, 'object_2', 100, 100, 0
object_2.countImages = 1
object_2.namesVars = {}
object_2.namesLists = {}


local events_start = {}
local events_touchObject = {} object_2.events_touchObject = events_touchObject
local events_keypressed = {} object_2.events_keypressed = events_keypressed
local events_endKeypressed = {} object_2.events_endKeypressed = events_endKeypressed
local events_movedObject = {} object_2.events_movedObject = events_movedObject
local events_onTouchObject = {} object_2.events_onTouchObject = events_onTouchObject
local events_collision = {} object_2.events_collision = events_collision
local events_endedCollision = {}  object_2.events_endedCollision = events_endedCollision
local events_startClone = {}
 object_2.events_startClone = events_startClone
object_2.group = cameraGroup
object_2:addEventListener('touch', function(event)
if (event.phase=='began') then
local newIdTouch=globalConstants.touchId+1
globalConstants.touchId = newIdTouch
globalConstants.keysTouch['touch_'..newIdTouch], globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = event.id, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale, true
globalConstants.isTouch, globalConstants.touchX, globalConstants.touchY = true, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale
display.getCurrentStage():setFocus(event.target, event.id)
event.target.isTouch = true
for key, value in pairs(objects) do
for i=1, #events_touchScreen[key] do
events_touchScreen[key][i](value)
for i2=1, #value.clones do
events_touchScreen[key][i](value.clones[i2])
end
end
end
for i=1, #events_touchObject do
events_touchObject[i](event.target)
end
elseif (event.phase=='moved') then
globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id] = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale
globalConstants.touchX, globalConstants.touchY = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale
for key, value in pairs(objects) do
for i=1, #events_movedScreen[key] do
events_movedScreen[key][i](value)
for i2=1, #value.clones do
events_movedScreen[key][i](value.clones[i2])
end
end
end
for i=1, #events_movedObject do
events_movedObject[i](event.target)
end
else
display.getCurrentStage():setFocus(event.target, nil)
globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = nil, nil, nil
if (pocketupFuns.getCountTouch(globalConstants.isTouchsId)==0) then
globalConstants.keysTouch = {}
globalConstants.isTouch = false
end
event.target.isTouch = nil
for key, value in pairs(objects) do
for i=1, #events_onTouchScreen[key] do
events_onTouchScreen[key][i](value)
for i2=1, #value.clones do
events_onTouchScreen[key][i](value.clones[i2])
end
end
end
for i=1, #events_onTouchObject do
events_onTouchObject[i](event.target)
end
end
return(true)
end)
events_start[ #events_start + 1] = function (target)
                            Timers_max = Timers_max+1
                            local tTheard
                            local removeTheard = function()
                                thread.cancel(tTheard)
                            end
                            local p
                            p = coroutine.create(function()
                                local threadFun = require('plugins.threadFun')


pcall(function()
var_2 = (0)
if varText_2 then
 varText_2.text = type(var_2)=="boolean" and (var_2 and app.words[373] or app.words[374]) or type(var_2)=="table" and encodeList(var_2) or var_2
end
end)




pcall(function()
if (varText_2~=nil and varText_2.text~=nil) then
display.remove(varText_2)
end
varText_2 = display.newText(type(var_2)=="boolean" and (var_2 and app.words[373] or app.words[374]) or type(var_2)=="table" and encodeList(var_2) or var_2, (100), -(200), "fonts/font_1", 30)
varText_2:setFillColor(0, 0, 0)
cameraGroup:insert(varText_2)
end)


removeTheard()
                        end)
                        local pStart
                        pStart, tTheard = thread.start(p)

end

events_keypressed[ #events_keypressed + 1] = function (target, idObject)
                        if (idObject == 'object_2') then
                            Timers_max = Timers_max+1
                            local tTheard
                            local removeTheard = function()
                                thread.cancel(tTheard)
                            end
                            local p
                            p = coroutine.create(function()
                                local threadFun = require('plugins.threadFun')


pcall(function()
target.property_size = (target.property_size)+((10))
target.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)
target:physicsReload()
end)


removeTheard()
                end)
                local pStart
                pStart, tTheard = thread.start(p)
end


for i=1, #events_start do
events_start[i](object_2)
end

end)

end)


function scene_2()

local focusCameraObject = nil
mainGroup = display.newGroup()
app.scene = 'game'
app.scenes[app.scene] = {mainGroup}
mainGroup.iscg = true
mainGroup.xScale, mainGroup.yScale = 1, 1
mainGroup.x, mainGroup.y = CENTER_X, CENTER_Y
local cameraGroup = display.newGroup()
local stampsGroup = display.newGroup()
cameraGroup:insert(stampsGroup)
mainGroup:insert(cameraGroup)
local notCameraGroup = display.newGroup()
mainGroup:insert(notCameraGroup)
objects = {}

local events_changeBackground = {}
local events_function = {}

local function broadcastFunction(nameFunction)
for key, value in pairs(objects) do
for i=1, #events_function[key][nameFunction] do
events_function[key][nameFunction][i](value)
for i2=1, #value.clones do
events_function[key][nameFunction][i](value.clones[i2])
end
end
end
end

myScene = 'project_2/scene_2'
local tableVarShow = {}
local tableNamesClones = {}
local miniScenes = display.newGroup()
cameraGroup:insert(miniScenes)
events_function['object_3'] = {}
events_function['object_3']['fun_1'] = {}
events_function['object_4'] = {}
events_function['object_4']['fun_1'] = {}
events_touchBack['object_3'] = {}
events_touchScreen['object_3'] = {}
events_movedScreen['object_3'] = {}
events_onTouchScreen['object_3'] = {}
events_changeBackground['object_3'] = {}
events_keypressed['object_3'] = {}
events_endKeypressed['object_3'] = {}
events_touchBack['object_4'] = {}
events_touchScreen['object_4'] = {}
events_movedScreen['object_4'] = {}
events_onTouchScreen['object_4'] = {}
events_changeBackground['object_4'] = {}
events_keypressed['object_4'] = {}
events_endKeypressed['object_4'] = {}
local function broadcastChangeBackground(numberImage)
for key, value in pairs(objects) do
for i=1, #events_changeBackground[key] do
events_changeBackground[key][i](value, numberImage)
for i2=1, #value.clones do
events_changeBackground[key][i](value.clones[i2], numberImage)
end
end
end
end
pcall(function()

local objectsParticles = {}
local listImages = {}
local listNamesImages = {}
local listSounds = {}
tableFeathers = {}
tableFeathersOptions = {3.5, 0, 0, 255}


local object_3 = display.newImage('images/notVisible.png')
object_3.infoSaveVisPos = 1

local objectsTable = plugins.json.decode(funsP['получить сохранение']('project_2/scene_2/objects'))
objectsTable[object_3.infoSaveVisPos][3] = nil
funsP['записать сохранение']('project_2/scene_2/objects', plugins.json.encode(objectsTable))
cameraGroup:insert(object_3)
object_3.touchesObjects = {}
local background = object_3
background.listImagesBack, background.listNamesImagesBack, background.obj_pathBack = listImages, listNamesImages, 'project_2/scene_2/object_3'
object_3.parent_obj = object_3
object_3.clones = {}
objects['object_3'], object_3.idObject = object_3, 3
object_3.numberImage = 1

object_3.tableVarShow, object_3.origWidth, object_3.origHeight, object_3.nameObject, object_3.property_size, object_3.property_brightness, object_3.property_color = {}, object_3.width, object_3.height, 'object_3', 100, 100, 0
object_3.countImages = 0
object_3.namesVars = {}
object_3.namesLists = {}


local events_start = {}
local events_touchObject = {} object_3.events_touchObject = events_touchObject
local events_keypressed = {} object_3.events_keypressed = events_keypressed
local events_endKeypressed = {} object_3.events_endKeypressed = events_endKeypressed
local events_movedObject = {} object_3.events_movedObject = events_movedObject
local events_onTouchObject = {} object_3.events_onTouchObject = events_onTouchObject
local events_collision = {} object_3.events_collision = events_collision
local events_endedCollision = {}  object_3.events_endedCollision = events_endedCollision
local events_startClone = {}
 object_3.events_startClone = events_startClone
object_3.group = cameraGroup
object_3:addEventListener('touch', function(event)
if (event.phase=='began') then
local newIdTouch=globalConstants.touchId+1
globalConstants.touchId = newIdTouch
globalConstants.keysTouch['touch_'..newIdTouch], globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = event.id, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale, true
globalConstants.isTouch, globalConstants.touchX, globalConstants.touchY = true, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale
display.getCurrentStage():setFocus(event.target, event.id)
event.target.isTouch = true
for key, value in pairs(objects) do
for i=1, #events_touchScreen[key] do
events_touchScreen[key][i](value)
for i2=1, #value.clones do
events_touchScreen[key][i](value.clones[i2])
end
end
end
for i=1, #events_touchObject do
events_touchObject[i](event.target)
end
elseif (event.phase=='moved') then
globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id] = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale
globalConstants.touchX, globalConstants.touchY = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale
for key, value in pairs(objects) do
for i=1, #events_movedScreen[key] do
events_movedScreen[key][i](value)
for i2=1, #value.clones do
events_movedScreen[key][i](value.clones[i2])
end
end
end
for i=1, #events_movedObject do
events_movedObject[i](event.target)
end
else
display.getCurrentStage():setFocus(event.target, nil)
globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = nil, nil, nil
if (pocketupFuns.getCountTouch(globalConstants.isTouchsId)==0) then
globalConstants.keysTouch = {}
globalConstants.isTouch = false
end
event.target.isTouch = nil
for key, value in pairs(objects) do
for i=1, #events_onTouchScreen[key] do
events_onTouchScreen[key][i](value)
for i2=1, #value.clones do
events_onTouchScreen[key][i](value.clones[i2])
end
end
end
for i=1, #events_onTouchObject do
events_onTouchObject[i](event.target)
end
end
return(true)
end)
for i=1, #events_start do
events_start[i](object_3)
end

end)

pcall(function()

local objectsParticles = {}
local listImages = {2}
local listNamesImages = {'Снимок экрана 2024-11-16 101637'}
local listSounds = {}
tableFeathers = {}
tableFeathersOptions = {3.5, 0, 0, 255}


local object_4 = display.newImage('project_2/scene_2/object_4/image_2.png', system.DocumentsDirectory)
object_4.image_path = 'project_2/scene_2/object_4/image_2.png'
object_4.timers = {}
object_4.infoSaveVisPos = 2

local objectsTable = plugins.json.decode(funsP['получить сохранение']('project_2/scene_2/objects'))
objectsTable[object_4.infoSaveVisPos][3] = nil
funsP['записать сохранение']('project_2/scene_2/objects', plugins.json.encode(objectsTable))
cameraGroup:insert(object_4)
object_4.touchesObjects = {}
object_4.parent_obj = object_4
object_4.clones = {}
objects['object_4'], object_4.idObject = object_4, 4
object_4.numberImage = 1

object_4.tableVarShow, object_4.origWidth, object_4.origHeight, object_4.nameObject, object_4.property_size, object_4.property_brightness, object_4.property_color = {}, object_4.width, object_4.height, 'object_4', 100, 100, 0
object_4.countImages = 1
object_4.namesVars = {}
object_4.namesLists = {}


local events_start = {}
local events_touchObject = {} object_4.events_touchObject = events_touchObject
local events_keypressed = {} object_4.events_keypressed = events_keypressed
local events_endKeypressed = {} object_4.events_endKeypressed = events_endKeypressed
local events_movedObject = {} object_4.events_movedObject = events_movedObject
local events_onTouchObject = {} object_4.events_onTouchObject = events_onTouchObject
local events_collision = {} object_4.events_collision = events_collision
local events_endedCollision = {}  object_4.events_endedCollision = events_endedCollision
local events_startClone = {}
 object_4.events_startClone = events_startClone
object_4.group = cameraGroup
object_4:addEventListener('touch', function(event)
if (event.phase=='began') then
local newIdTouch=globalConstants.touchId+1
globalConstants.touchId = newIdTouch
globalConstants.keysTouch['touch_'..newIdTouch], globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = event.id, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale, true
globalConstants.isTouch, globalConstants.touchX, globalConstants.touchY = true, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale
display.getCurrentStage():setFocus(event.target, event.id)
event.target.isTouch = true
for key, value in pairs(objects) do
for i=1, #events_touchScreen[key] do
events_touchScreen[key][i](value)
for i2=1, #value.clones do
events_touchScreen[key][i](value.clones[i2])
end
end
end
for i=1, #events_touchObject do
events_touchObject[i](event.target)
end
elseif (event.phase=='moved') then
globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id] = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale
globalConstants.touchX, globalConstants.touchY = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale
for key, value in pairs(objects) do
for i=1, #events_movedScreen[key] do
events_movedScreen[key][i](value)
for i2=1, #value.clones do
events_movedScreen[key][i](value.clones[i2])
end
end
end
for i=1, #events_movedObject do
events_movedObject[i](event.target)
end
else
display.getCurrentStage():setFocus(event.target, nil)
globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = nil, nil, nil
if (pocketupFuns.getCountTouch(globalConstants.isTouchsId)==0) then
globalConstants.keysTouch = {}
globalConstants.isTouch = false
end
event.target.isTouch = nil
for key, value in pairs(objects) do
for i=1, #events_onTouchScreen[key] do
events_onTouchScreen[key][i](value)
for i2=1, #value.clones do
events_onTouchScreen[key][i](value.clones[i2])
end
end
end
for i=1, #events_onTouchObject do
events_onTouchObject[i](event.target)
end
end
return(true)
end)
events_start[ #events_start + 1] = function (target)
                        Timers_max = Timers_max+1
                        local tTheard
                        local removeTheard = function()
                            thread.cancel(tTheard)
                        end
                        local p
                        p = coroutine.create(function()
                            local threadFun = require('plugins.threadFun')


pcall(function()
target.x, target.y = math.random(-360,360), math.random(-772,772)
end)


removeTheard()
                end)
                local pStart
                pStart, tTheard = thread.start(p)
            end


for i=1, #events_start do
events_start[i](object_4)
end

end)

end
scene_1()
local function touchScreenGame(event)
if (event.phase=='began') then
local newIdTouch=globalConstants.touchId+1
globalConstants.touchId = newIdTouch
globalConstants.keysTouch['touch_'..newIdTouch], globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = event.id, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale, true
globalConstants.isTouch, globalConstants.touchX, globalConstants.touchY = true, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale
for key, value in pairs(objects) do
for i=1, #events_touchScreen[key] do
events_touchScreen[key][i](value)
for i2=1, #value.clones do
events_touchScreen[key][i](value.clones[i2])
end
end
end
elseif (event.phase=='moved') then
globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id] = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale
globalConstants.touchX, globalConstants.touchY = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale
for key, value in pairs(objects) do
for i=1, #events_movedScreen[key] do
events_movedScreen[key][i](value)
for i2=1, #value.clones do
events_movedScreen[key][i](value.clones[i2])
end
end
end
else
globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = nil, nil, nil
if (pocketupFuns.getCountTouch(globalConstants.touchsXId)==0) then
globalConstants.keysTouch = {}
globalConstants.isTouch=false
end
for key, value in pairs(objects) do
for i=1, #events_onTouchScreen[key] do
events_onTouchScreen[key][i](value)
for i2=1, #value.clones do
events_onTouchScreen[key][i](value.clones[i2])
end
end
end
end
end
Runtime:addEventListener('touch', touchScreenGame)


function exitGame()
plugins.physics.setDrawMode('normal')
system.deactivate('multitouch')
plugins.physics.stop()
Runtime:removeEventListener('touch', touchScreenGame)
showOldScene()
end
function deleteScene()
thread.cancelAll()
for key, value in pairs(objects) do
    local target = value
    pcall(function()
        
if (target.parent_obj==target) then
            local objectsTable = plugins.json.decode(funsP['получить сохранение'](myScene..'/objects'))
            if (objectsTable[target.infoSaveVisPos][3]==nil) then
                objectsTable[target.infoSaveVisPos][3] = {}
            end
            objectsTable[target.infoSaveVisPos][3].size = target.property_size/100
            objectsTable[target.infoSaveVisPos][3].rotation = target.rotation
            funsP['записать сохранение'](myScene..'/objects', plugins.json.encode(objectsTable))
        end
    end)
end
plugins.physics.setDrawMode('normal')
removeAllObjects()
timer.cancelAll()
collectgarbage('collect')
plugins.orientation.lock('portrait')
display.remove(mainGroup)
for key, value in pairs(playingSounds) do
audio.stop(playingSounds[key])
audio.dispose(playSounds[key])
end
playSounds = {}
playingSounds = {}
native.setProperty('windowMode', 'fullscreen')
end
function funBackListener(event)
if ((event.keyName=='back' or event.keyName=='deleteBack') and event.phase=='up') then
local rect = display.newImage('images/notVisible.png')
mainGroup:insert(rect)
rect.width, rect.height = 720, 1544
rect:toBack()
rect.alpha = 0.004
display.save(mainGroup,{ filename=myScene..'/icon.png', baseDir=system.DocumentsDirectory, backgroundColor={1,1,1,1}})
Runtime:removeEventListener('key',funBackListener)
audio.stop({channel=1})
deleteScene()
exitGame()
plugins.orientation.lock('portrait')
end
return(true)
end
Runtime:addEventListener('key', funBackListener)
function funBackListener2(event)
if ((event.keyName=='back' or event.keyName=='deleteBack') and event.phase=='up') then
Runtime:removeEventListener('key',funBackListener)
audio.stop({channel=1})
deleteScene()
exitGame()
plugins.orientation.lock('portrait')
end
end
local funKeyListener = function(e)
    if e.phase == 'down' then
        for key, value in pairs(objects) do
            print(key)
            print(plugins.json.encode(events_keypressed))
            for i=1, #events_keypressed[key] do
                events_keypressed[key][i](value)
                for i2=1, #value.clones do
                    events_keypressed[key][i](value.clones[i2])
                end
            end
        end
    else
        for key, value in pairs(objects) do
            for i=1, #events_endKeypressed[key] do
                events_endKeypressed[key][i](value)
                for i2=1, #value.clones do
                    events_endKeypressed[key][i](value.clones[i2])
                end
            end
        end
    end
    return(true)
end
Runtime:addEventListener('key', funKeyListener)
end)
