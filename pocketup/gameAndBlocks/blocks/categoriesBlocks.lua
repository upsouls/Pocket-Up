-- здесь добавляются блоки в категории

local function f(localityVariable, nameVariable, localityArray, nameArray, nameFunction, nameBackground, nameScene, nameSound, nameImage, nameVideo)
	print(nameVideo , "dbfdf")
	local myTable = {
		["used"]={
			{"whenTheTruth",{ {{"number", 1},{"function", "<"},{"number", 2}} }},

			{"createVideo", { {"videos", nameVideo}, {{"number", 200}}, {{"number", 300}}, {{"number", 100}}, {{"number", 200}} }},
			{"setPositionVideo", {{"videos", nameVideo},{{"number", 100}}, {{"number", 200}} }},
			{"setPositionXVideo", {{{"number", 100}},{"videos", nameVideo}}},
			{"setPositionYVideo", {{{"number", 200}},{"videos", nameVideo}}},
			{"editPositionXVideo", {{{"number", 10}},{"videos", nameVideo}}},
			{"editPositionYVideo", {{{"number", 20}},{"videos", nameVideo}}},
			{"playVideo", {{"videos", nameVideo}}},
			{"pauseVideo", {{"videos", nameVideo}}},
			{"seekVideo", {{"videos", nameVideo}, {{"number", 16}}}},
			{"deleteVideo", {{"videos", nameVideo}}},
			{"insertVideoToCamera", {{"videos", nameVideo}}},
			{"removeVideoToCamera", {{"videos", nameVideo}}},
			{"insertVideoToMiniScene", {{"videos", nameVideo}, {{"text", app.words[530]}}}},
			{"eventListenerVideo", {{"videos", nameVideo}, {localityVariable, nameVariable}}},
			
			{"continueScene",{ {"scenes", nameScene} }},
			{"deleteScene",{ {"scenes", nameScene} }},
			
			{"runLua",{ {{"text", 'local a = display.newRect(100, 100, 50, 50)'}} }},
			
			{"removeCameraTextField", {{{"text", app.words[493]}}}},
			{"insertCameraTextField", {{{"text", app.words[493]}}}},
			{"setPositionTextField", {{{"text", app.words[493]}}, {{"number", 100}}, {{"number", 200}}}},
			{"editPositionTextField", {{{"text", app.words[493]}}, {{"number", 10}}, {{"number", 20}}}},
			{"setFontSizeTextField", {{{"text", app.words[493]}}, {{"number", 16}}}},
			{"setTypeInputTextField", {{{"text", app.words[493]}}, {"inputType", "phone"}}},
			{"setAlignTextField", {{{"text", app.words[493]}}, {"alignText", "center"}}},
			{"isSecureTextField", {{{"text", app.words[493]}}, {{"onOrOff", "on"}}}},
			{"placeholderTextField", {{{"text", app.words[493]}}, {{"text", app.words[164]}}}},
			{"valueTextField", {{{"text", app.words[493]}}, {{"text", app.words[164]}}}},
			{"setColorTextField", {{{"text", app.words[493]}}, {{"text", "#FF0000"}}}},
			{"setSelectionTextField", {{{"text", app.words[493]}}, {{"number", 2}}, {{"number", 4}}}},
			{"getSelectionTextField", {{{"text", app.words[493]}}, {{"globalVariable"}}, {{"globalVariable"}}}},
			{"setKeyboardToTextField", {{{"text", app.words[493]}}}},
			{"removeKeyboardToTextField", {{{"text", app.words[493]}}}},
		},
		["event"]={
			{"keypressed",{{localityVariable, nameVariable}}},
			{"endKeypressed",{{localityVariable, nameVariable}}},
			{"start"},
			{"touchBack"},
			{"touchObject"},
			{"movedObject"},
			{"onTouchObject"},
			{"touchScreen"},
			{"movedScreen"},
			{"onTouchScreen"},
			{"function",{{"function",nameFunction}}},
			{"broadcastFunction",{{"function",nameFunction}}},
			{"broadcastFunctionAndWait",{{"function",nameFunction}}},
			{"broadcastFun>allObjects",{{"function",nameFunction}}},
			{"broadcastFun>allClones",{{"function",nameFunction}}},
			{"broadcastFun>objectAndClones",{{"objects",nil},{"function",nameFunction}}},
			{"broadcastFun>object",{{"objects",nil},{"function",nameFunction}}},
			{"broadcastFun>clones",{{"objects",nil},{"function",nameFunction}}},
			{"addNameClone", { {{"text",app.words[444]}} }},
			{"broadcastFun>nameClone",{{{"text",app.words[444]}},{"function",nameFunction}}},
			{"whenTheTruth",{ {{"number", 1},{"function", "<"},{"number", 2}} }},
			{"collision",{ {{"objects", nil}} }},
			{"endedCollision", { {{"objects", nil}} }},
			{"changeBackground",{ {"backgrounds", nameBackground} }},
			{"startClone"},
			{"clone",{{"objects",nil}}},
			{"deleteClone"},
		},
		["control"]={
			{"timer3", {{{"number", 5}}, {{"number", 1}}}},
			{"wait", {{{"number", 1}}}},
			--{"wait",{ {{"number", 1}} }},
			{"commentary",{ {{"text", app.words[95]}} }},
			{"cycleForever"},
			{"ifElse (2)",{ {{"number", 1},{"function","<"},{"number",2}} }},
			{"if (2)",{ {{"number", 1},{"function","<"},{"number",2}} }},
			-- {"waitIfTrue",{ {{"number", 1},{"function","<"},{"number",2}} }},
			{"waitIfTrue2",{ {{"number", 1},{"function","<"},{"number",2}} }},
			{"repeat",{ {{"number", 1},{"number",0}} }},
			{"repeatIsTrue",{ {{"number", 1},{"function","<"},{"number",2}} }},
			{"for",{ {{"number", 1}}, {{"number",1},{"number",0}}, {localityVariable,nameVariable}}},
			{"foreach",{ {localityArray, nameArray}, {localityVariable,nameVariable}}},
			{"continueScene",{ {"scenes", nameScene} }},
			{"deleteScene",{ {"scenes", nameScene} }},
			{"runScene",{ {"scenes", nameScene} }},
			{"exitGame"},
			{"stopScript"},
			--{"waitStopScripts"},
			-- {"cancelAllTimers"},
			{"startClone"},
			{"clone",{{"objects",nil}}},
			{"deleteClone"},
		},
		["physic"]={
			{"setPosition",{ {{"number", 100}}, {{"number", 200}} }},
			{"setPositionX",{ {{"number", 100}} }},
			{"setPositionY",{ {{"number", 200}} }},
			{"editPositionX",{ {{"number", 10}} }},
			{"editPositionY",{ {{"number", 10}} }},
			{"goTo",{ {"goTo", "touch"} }},
			{"goSteps",{ {{"number", 10}} }},
			{"editRotateLeft",{ {{"number", 15}} }},
			{"editRotateRight",{ {{"number", 15}} }},
			{"setRotate",{ {{"number", 90}} }},
			{"setRotateToObject",{{"objects",nameObject}}},
			{"setTypeRotate",{{"typeRotate","false"}}},
			{"transitionPosition2",{ {{"number",1}}, {{"number",100}}, {{"number",200}} }},
			{"setLayer", {{{"number", 2}}}},
			{"toFrontLayer"},
			{"isSensor", {{{"onOrOff", "off"}}}},
			{"toBackLayer"},
			{"vibration",{{{"number", 1}}}},
			{"addBody", {{"typeBody", "dynamic"}}},
			{"speedStepsToSecoond",{{{"number",0}}, {{"function","-"},{"number",10}}}},
			{"rotateLeftForever",{{{"number",15}}}},
			{"rotateRightForever",{{{"number",15}}}},
			{"setGravityAllObjects",{{{"number",0}}, {{"function","-"},{"number",10}} }},
			{"setWeight",{{{"number",1}} }},
			{"setElasticity",{{{"number",20}} }},
			{"setFriction",{{{"number",80}} }},
			{"showHitboxes"},
			{"hideHitboxes"},
			{"setTextelCoarseness",{{{"number", 1}}}},
			{"jump", {{{"number", 10}}, {{"number", 20}}}},
			{"jumpX", {{{"number", 10}}}},
			{"jumpY", {{{"number", 20}}}},
			{"jumpYIf", {{{"number", 20}}}},
			{"setGravityScale", {{{"function","-"},{"number", 10}}}},
			{"setQuareHitbox"},
			{"setQuareWHHitbox", {{{"number", 100}}, {{"number", 200}}}},
			{"setCircleHitbox", {{{"number", 200}}}},
		},
		["sounds"]={
			{"playSound", {{"sounds",nameSound}}},
			{"playSoundAndWait", {{"sounds",nameSound}}},
			--{"playSoundAndWait", {{"sounds",nameSound}}},
			{"stopSound", {{"sounds",nameSound}}},
			{"stopAllSounds"},
			{"setVolumeSound",{{{"number",60}}}},
			{"editVolumeSound", {{{"function","-"},{"number",10}}}},

			{"createVideo", { {"videos", nameVideo}, {{"number", 200}}, {{"number", 300}}, {{"number", 100}}, {{"number", 200}} }},
			{"setPositionVideo", {{"videos", nameVideo},{{"number", 100}}, {{"number", 200}} }},
			{"setPositionXVideo", {{{"number", 100}},{"videos", nameVideo}}},
			{"setPositionYVideo", {{{"number", 200}},{"videos", nameVideo}}},
			{"editPositionXVideo", {{{"number", 10}},{"videos", nameVideo}}},
			{"editPositionYVideo", {{{"number", 20}},{"videos", nameVideo}}},
			{"playVideo", {{"videos", nameVideo}}},
			{"pauseVideo", {{"videos", nameVideo}}},
			{"seekVideo", {{"videos", nameVideo}, {{"number", 16}}}},
			{"deleteVideo", {{"videos", nameVideo}}},
			{"insertVideoToCamera", {{"videos", nameVideo}}},
			{"removeVideoToCamera", {{"videos", nameVideo}}},
			{"insertVideoToMiniScene", {{"videos", nameVideo}, {{"text", app.words[530]}}}},
			{"eventListenerVideo", {{"videos", nameVideo}, {localityVariable, nameVariable}}},
		},
		["images"]={
			{"setImageToName",{{"images",nameImage}}},
			{"setImageToId",{{{"number",1}}}},
			{"nextImage"},
			{"previousImage"},
			{"setSize",{{{"number",60}}}},
			{"editSize",{{{"number",10}}}},
			{"hide"},
			{"show"},
			{"setBackgroundColor", {{{"number", 0}}, {{"number", 0}}, {{"number", 0}}}},
			{"setBackgroundColorHex", {{{"text", "#FFFFFF"}}}},
			{"ask",{{{"text",app.words[161]}}, {localityVariable, nameVariable}, {"function",nameFunction} }},
			--{"say",{{{"text",app.words[164]}} }},
			{"sayTime",{{{"text",app.words[164]}}, {{"number",1}} }},
			--{"think",{{{"text",app.words[168]}} }},
			{"thinkTime",{{{"text",app.words[168]}}, {{"number",1}} }},
			{"setAlpha", {{{"number",50}}}},
			{"editAlpha",{{{"number",25}}}},
			{"setBrightness",{{{"number",50}}}},
			{"editBrightness",{{{"number",25}}}},
			{"setColor", {{{"number",0}}}},
			{"editColor", {{{"number",25}}}},

			--{"onAdaptabilityEffect",{{"onOrOff","on"}}},
			--{"setColorParticle",{{{"text","#ff0000"}}}},
			--{"clearGraphicsEffects"},
			{"focusCameraToObject", {{{"number",0}},{{"number",0}}}},
			{"removeObjectCamera"},
			{"insertObjectCamera"},
			{"removeFocusCameraToObject"},
			{"changeBackground",{ {"backgrounds", nameBackground} }},
			{"setImageBackgroundToName",{{"backgrounds",nameBackground}}},
			{"setImageBackgroundToId",{{{"number",1}}}},
			--{"setImageBackgroundToNameAndWait",{{"backgrounds",nameBackground}}},
			--{"setImageBackgroundToIdAndWait",{{{"number",1}}}},
			{"getLinkImage",{{{"text","https://docs.coronalabs.com/images/simulator/image-mask-base2.png"}}}},
			{"setAnchor", {{{"number", 0}}, {{"number", 100}}}},
		},
		["particles"]={
			--{"setSizeParticle", {{{"text",app.words[417]}},{{"number",60}}}},
			{"setPositionParticle", {{{"text",app.words[417]}},{{"number",100}},{{"number",200}}} },
			{"editPositionXParticle",{{{"text",app.words[417]}},{{"number",10}}}},
			{"editPositionYParticle",{{{"text",app.words[417]}},{{"number",10}}}},
			{"deleteParticle", {{{"text",app.words[417]}}}},
			{"deleteAllParticles"},
			{"createRadialParticle",{{{"text",app.words[417]}},{"images",nameImage},{{"number",500}},{{"function","true"}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",2}},{{"number",0}},{{"number",20}},{{"number",0}},{{"number",5}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"text","#FFFFFF"}},{{"text","#000000"}},{{"text","#000000"}},{{"text","#000000"}},{"GL","GL_SRC_ALPHA"},{"GL","GL_ONE"} }},
			{"createLinearParticle",{{{"text",app.words[417]}},{"images",nameImage},{{"number",500}},{{"function","true"}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",2}},{{"number",0}},{{"number",20}},{{"number",0}},{{"number",5}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"text","#FFFFFF"}},{{"text","#000000"}},{{"text","#000000"}},{{"text","#000000"}},{"GL","GL_SRC_ALPHA"},{"GL","GL_ONE"} }},
		},
		["pen"]={
			{"lowerPen"},
			{"raisePen"},
			{"setSizePen",{{{"number",3.15}}}},
			{"setColorPen",{{{"number",0}},{{"number",0}},{{"number",255}}}},
			{"stamp"},
			{"clearPen"},
		},
		["data"]= {
			{"setVariable", {{localityVariable, nameVariable}, {{"number",0}}}},
			{"editVariable", {{localityVariable, nameVariable}, {{"number",1}}}},
			{"showVariable", {{localityVariable, nameVariable}, {{"number",100}}, {{"number",200}}}},
			{"showVariable2", {{localityVariable, nameVariable},{{"number",100}}, {{"number",200}},{{"number",120}},{{"text","#FF0000"}},{"alignText","center"}}},
			{"setAnchorVariable", {{localityVariable, nameVariable},{{"number", 0}}, {{"number",100}}}},
			{"fbGetValue", {{{"text", app.words[652]}}, {{"text", app.words[651]}}, {{"number", 0}}}},
			{"fbSetValue", {{{"text", app.words[654]}}, {{"text", app.words[652]}}, {{"text", app.words[651]}}}},
			{"fbDelValue", {{{"text", app.words[652]}}, {{"text", app.words[651]}}}},
			{"hideVariable",{{localityVariable, nameVariable}}},
			{"insertVariableCamera", {{localityVariable, nameVariable}}},
			{"removeVariableCamera", {{localityVariable, nameVariable}}},
			{"saveVariable",{{localityVariable, nameVariable}}},
			{"readVariable",{{localityVariable, nameVariable}}},
			--{"saveVariableToFile",{{localityVariable, nameVariable}, {{"text",app.words[218]..".txt"}}}},
			--{"readVariableToFile",{{localityVariable, nameVariable}, {{"text",app.words[218]..".txt"}}, {"isDeleteFile","save"} }},
			{"addElementArray",{{{"number",1}},{localityArray, nameArray}}},
			{"deleteElementArray",{{localityArray, nameArray}, {{"number",1}} }},
			{"deleteAllElementsArray",{{localityArray, nameArray}}},
			{"pasteElementArray", {{{"number",1}},{localityArray, nameAreay}, {{"number",1}}}},
			{"replaceElementArray",{{localityArray, nameArray}, {{"number",1}},{{"number",1}}}},
			{"saveArray",{{localityArray, nameArray}}},
			{"readArray",{{localityArray, nameArray}}},
			{"columnStorageToArray",{{{"number",1}},{{"text",app.words[238]}},{localityArray, nameArray}}},
			{"getRequest",{{{"text","https://catrob.at/joke"}}, {localityVariable, nameVariable}}},
			{"toFrontLayerVar",{ {localityVariable, nameVariable} }},
			{"toBackLayerVar",{ {localityVariable, nameVariable} }},
		},
		["device"]={
			--{"resetTimer"},
			{"openLink",{{{"text","https://catrobat.org/"}}}},
			{"blockTouch"},
			{"blockTouchScreen"},
			--{"touchAndSwipe",{{{"function","-"},{"number",1},{"number",0},{"number",0}},{{"function","-"},{"number",2},{"number",0},{"number",0}},{{"number",1},{"number",0},{"number",0}},{{"number",2},{"number",0},{"number",0}}, {{"number",0},{"number","."},{"number",3}}}},
			{"showToast", {{{"text", app.words[164]}}}},
			{"runLua",{ {{"text", 'local a = display.newRect(100, 100, 50, 50); a:setFillColor(1, 0, 0)'}} }},
			--{"lua", {{{"text", "native.showAlert(\""..app.words[388].."\", \""..app.words[389].."\", {\"OK\"})"}}}},
			{"setHorizontalOrientation"},
			{"setVerticalOrientation"},
			{"removeAdaptiveSizeDevice"},
		},
		["textFields"]={
			{"ask",{{{"text",app.words[161]}}, {localityVariable, nameVariable}, {"function",nameFunction} }},
			{"createTextField", { {{"text", app.words[493]}}, {"onOrOff","on"}, {{"number",300}}, {{"number", 100}}, {localityVariable, nameVariable} }},
			{"deleteTextField", { {{"text", app.words[493]}} }},
			{"removeCameraTextField", {{{"text", app.words[493]}}}},
			{"insertCameraTextField", {{{"text", app.words[493]}}}},
			{"setPositionTextField", {{{"text", app.words[493]}}, {{"number", 100}}, {{"number", 200}}}},
			{"editPositionTextField", {{{"text", app.words[493]}}, {{"number", 10}}, {{"number", 20}}}},
			{"setFontSizeTextField", {{{"text", app.words[493]}}, {{"number", 16}}}},
			{"setTypeInputTextField", {{{"text", app.words[493]}}, {"inputType", "phone"}}},
			{"setAlignTextField", {{{"text", app.words[493]}}, {"alignText", "center"}}},
			{"isSecureTextField", {{{"text", app.words[493]}}, {{"onOrOff", "on"}}}},
			{"placeholderTextField", {{{"text", app.words[493]}}, {{"text", app.words[164]}}}},
			{"valueTextField", {{{"text", app.words[493]}}, {{"text", app.words[164]}}}},
			{"setColorTextField", {{{"text", app.words[493]}}, {{"text", "#FF0000"}}}},
			{"setSelectionTextField", {{{"text", app.words[493]}}, {{"number", 2}}, {{"number", 4}}}},
			{"getSelectionTextField", {{{"text", app.words[493]}}, {{"globalVariable"}}, {{"globalVariable"}}}},
			{"setKeyboardToTextField", {{{"text", app.words[493]}}}},
			{"removeKeyboardToTextField", {{{"text", app.words[493]}}}}
		},
		["miniScenes"]={
			{"createMiniScene", {{{"text",app.words[530]}}}},
			{"deleteMiniScene", {{{"text", app.words[530]}}}},
			{"miniSceneInsert", {{{"text",app.words[530]}}}},
			{"setPositionMiniScene", { {{"text",app.words[530]}}, {{"number", 100}}, {{"number", 200}} }},
			{"setSizeMiniScene", { {{"text",app.words[530]}}, {{"number", 60}} }},
			{"editSizeMiniScene", { {{"text",app.words[530]}}, {{"number", 10}} }},
			{"editPositionMiniScene", { {{"text",app.words[530]}}, {{"number", 10}}, {{"number", 20}} }},
			{"setRotationMiniScene", { {{"text",app.words[530]}}, {{"number", 90}} }},
			{"editRotationMiniScene", { {{"text",app.words[530]}}, {{"number", 90}} }},
			{"setAlphaMiniScene", { {{"text",app.words[530]}}, {{"number", 60}} }},
			{"editAlphaMiniScene", { {{"text",app.words[530]}}, {{"number", 10}} }},
			{"miniSceneHide", {{{"text",app.words[530]}}}},
			{"miniSceneShow", {{{"text",app.words[530]}}}},
			{"miniSceneInsertMiniScene", {{{"text", app.words[530]}}, {{"text", app.words[530].." 2"}} }},
			{"miniSceneInsertCamera", {{{"text",app.words[530]}}}},
			{"miniSceneRemoveCamera", {{{"text",app.words[530]}}}},
			{"insertVideoToMiniScene", {{"videos", nameVideo}, {{"text", app.words[530]}}}},
		},
		["elementInterface"] = {
			{"newWebView", {{{"text", app.words[589]}}, {{"text", "https://example.com"}}, {{"number", 100}}, {{"number", 200}}, {{"number", 400}}, {{"number", 800}}}},
			{"deleteWebView", {{{"text", app.words[589]}}}},
			{"setWebViewX", {{{"text", app.words[589]}}, {{"number", -100}}}},
			{"setWebViewY", {{{"text", app.words[589]}}, {{"number", -200}}}},
			{"insertWebInMiniScene", {{{"text", app.words[589]}}, {{"text", app.words[530]}}}},
			{"setWebViewWidth", {{{"text", app.words[589]}}, {{"number", 200}}}},
			{"setWebViewHeight", {{{"text", app.words[589]}}, {{"number", 300}}}},
			{"setLinkWebView", {{{"text", app.words[589]}}, {{"text", "https://google.com"}}}},
			{"backWebView", {{{"text", app.words[589]}}}},
			{"forwardWebView", {{{"text", app.words[589]}}}},
			{"stopWebView", {{{"text", app.words[589]}}}},
			{"reloadWebView", {{{"text", app.words[589]}}}},
		},
	}
	return(myTable)
end



premBlocks = {
}
paidBlocks = {
	
}


return(f)