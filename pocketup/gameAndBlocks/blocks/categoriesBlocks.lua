-- здесь добавляются блоки в категории

local function f(localityVariable, nameVariable, localityArray, nameArray, nameFunction, nameBackground, nameScene, nameSound, nameImage)
	local myTable = {
		["used"]={
			{"newWebView", {{{"text", words[589]}}, {{"text", "https://example.com"}}, {{"number", 100}}, {{"number", 200}}, {{"number", 400}}, {{"number", 800}}}},
			{"setWebViewX", {{{"text", words[589]}}, {{"number", -100}}}},
			{"setWebViewY", {{{"text", words[589]}}, {{"number", -200}}}},
			{"insertWebInMiniScene", {{{"text", words[589]}}, {{"text", words[530]}}}},
			{"setWebViewWidth", {{{"text", words[589]}}, {{"number", 200}}}},
			{"setWebViewHeight", {{{"text", words[589]}}, {{"number", 300}}}},
			{"setLinkWebView", {{{"text", words[589]}}, {{"text", "https://google.com"}}}},
			{"backWebView", {{{"text", words[589]}}}},
			{"forwardWebView", {{{"text", words[589]}}}},
			{"stopWebView", {{{"text", words[589]}}}},
			{"reloadWebView", {{{"text", words[589]}}}},

			{"createJoystick", { {{"text", words[581]}}, {"images", nameImage}, {"images", nameImage}, {localityVariable, nameVariable}, {localityVariable, nameVariable},{"function", nameFunction} }},
			{"cameraInsertJoystick", {{{"text", words[581]}}}},
			{"cameraRemoveJoystick", {{{"text", words[581]}}}},
			{"setPositionJoystick", {{{"text", words[581]}}, {{"number", 100}}, {{"number", 200}} }},
			{"setSizeJoystick", {{{"text", words[581]}}, {{"number", 60}} }},
			{"setSizeJoystick1", {{{"text", words[581]}}, {{"number", 60}} }},
			{"setSizeJoystick2", {{{"text", words[581]}}, {{"number", 60}} }},

			{"setAnchor", {{{"number", 0}}, {{"number", 100}}}},
			{"setLayer", {{{"number", 2}}}},

			{"createMiniScene", {{{"text",words[530]}}}},
			{"deleteMiniScene", {{{"text", words[530]}}}},
			{"miniSceneInsert", {{{"text",words[530]}}}},
			{"setPositionMiniScene", { {{"text",words[530]}}, {{"number", 100}}, {{"number", 200}} }},
			{"setSizeMiniScene", { {{"text",words[530]}}, {{"number", 60}} }},
			{"editSizeMiniScene", { {{"text",words[530]}}, {{"number", 10}} }},
			{"editPositionMiniScene", { {{"text",words[530]}}, {{"number", 10}}, {{"number", 20}} }},
			{"setRotationMiniScene", { {{"text",words[530]}}, {{"number", 90}} }},
			{"editRotationMiniScene", { {{"text",words[530]}}, {{"number", 90}} }},
			{"setAlphaMiniScene", { {{"text",words[530]}}, {{"number", 60}} }},
			{"editAlphaMiniScene", { {{"text",words[530]}}, {{"number", 10}} }},
			{"miniSceneHide", {{{"text",words[530]}}}},
			{"miniSceneShow", {{{"text",words[530]}}}},
			{"miniSceneInsertMiniScene", {{{"text", words[530]}}, {{"text", words[530].." 2"}} }},
			{"miniSceneInsertCamera", {{{"text",words[530]}}}},
			{"miniSceneRemoveCamera", {{{"text",words[530]}}}},
			

			{"setQuareHitbox"},
			{"setQuareWHHitbox", {{{"number", 100}}, {{"number", 200}}}},
			{"setCircleHitbox", {{{"number", 200}}}},
			{"setShapeHitbox", { {"shapeHitbox", "[-50, -100, -100, 100, 150, 125, 100, -100]"} }},


			{"ask",{{{"text",words[161]}}, {localityVariable, nameVariable}, {"function",nameFunction} }},
			{"createTextField", { {{"text", words[493]}}, {"onOrOff","on"}, {{"number",300}}, {{"number", 100}}, {localityVariable, nameVariable} }},
			{"removeCameraTextField", {{{"text", words[493]}}}},
			{"insertCameraTextField", {{{"text", words[493]}}}},
			{"setPositionTextField", { {{"text",words[493]}}, {{"number", 100}}, {{"number", 200}} }},
			{"editPositionTextField", { {{"text",words[493]}}, {{"number", 10}}, {{"number", 20}} }},
			{"setFontSizeTextField", { {{"text", words[493]}}, {{"number", 16}} }},
			{"setTypeInputTextField", { {{"text", words[493]}}, {"typeInput", "phone"} }},
			{"setAlignTextField", { {{"text", words[493]}}, {"alignText", "center"} }},
			{"deleteTextField", { {{"text", words[493]}} }},
			{"isSecureTextField", { {{"text", words[493]}}, {"onOrOff","on"} }},
			{"placeholderTextField", { {{"text", words[493]}}, {{"text", words[164]}} }},
			{"valueTextField", { {{"text", words[493]}}, {{"text", words[164]}} }},
			{"setColorTextField", { {{"text", words[493]}}, {{"text", "#FF0000"}} }},
			{"setSelectionTextField", { {{"text", words[493]}}, {{"number", 2}}, {{"number", 4}} }},
			{"getSelectionTextField", { {{"text", words[493]}}, {localityVariable, nameVariable}, {localityVariable, nameVariable} }},
			{"setKeyboardToTextField", {{{"text", words[493]}}}},
			{"removeKeyboardToTextField"},
		},
		["event"]={
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
			{"addNameClone", { {{"text",words[444]}} }},
			{"broadcastFun>nameClone",{{{"text",words[444]}},{"function",nameFunction}}},
			--{"whenTheTruth",{ {{"number", 1},{"function", "<"},{"number", 2}},  }},
			{"collision",{ {{"objects", nil}} }},
			{"endedCollision", { {{"objects", nil}} }},
			{"changeBackground",{ {"backgrounds", nameBackground} }},
			{"startClone"},
			{"clone",{{"objects",nil}}},
			{"deleteClone"},
		},
		["control"]={
			{"timer", {{{"number", 5}}, {{"number", 1}}}},
			{"wait", {{{"number", 1}}}},
			--{"wait",{ {{"number", 1}} }},
			{"commentary",{ {{"text", words[95]}} }},
			{"cycleForever"},
			{"ifElse (2)",{ {{"number", 1},{"function","<"},{"number",2}} }},
			{"if (2)",{ {{"number", 1},{"function","<"},{"number",2}} }},
			{"waitIfTrue",{ {{"number", 1},{"function","<"},{"number",2}} }},
			{"repeat",{ {{"number", 1},{"number",0}} }},
			{"repeatIsTrue",{ {{"number", 1},{"function","<"},{"number",2}} }},
			{"for",{ {{"number", 1}}, {{"number",1},{"number",0}}, {localityVariable,nameVariable}}},
			{"foreach",{ {localityArray, nameArray}, {localityVariable,nameVariable}}},
			--{"continueScene",{ {"scenes", nameScene} }},
			{"runScene",{ {"scenes", nameScene} }},
			{"exitGame"},
			{"stopScript"},
			--{"waitStopScripts"},
			{"cancelAllTimers"},
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
			{"setLayer", {{{"number", 2}}}},
			{"goTo",{ {"goTo", "touch"} }},
			{"goSteps",{ {{"number", 10}} }},
			{"editRotateLeft",{ {{"number", 15}} }},
			{"editRotateRight",{ {{"number", 15}} }},
			{"setRotate",{ {{"number", 90}} }},
			{"setRotateToObject",{{"objects",nameObject}}},
			{"setTypeRotate",{{"typeRotate","false"}}},
			{"transitionPosition",{ {{"number",1}}, {{"number",100}}, {{"number",200}} }},
			{"setLayer", {{{"number", 2}}}},
			{"toFrontLayer"},
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
			{"setShapeHitbox", { {"shapeHitbox", "[-50, -100, -100, 100, 150, 125, 100, -100]"} }},
		},
		["sounds"]={
			{"playSound", {{"sounds",nameSound}}},
			--{"playSoundAndWait", {{"sounds",nameSound}}},
			{"stopSound", {{"sounds",nameSound}}},
			{"stopAllSounds"},
			{"setVolumeSound",{{{"number",60}}}},
			{"editVolumeSound", {{{"function","-"},{"number",10}}}},
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
			{"ask",{{{"text",words[161]}}, {localityVariable, nameVariable}, {"function",nameFunction} }},
			--{"say",{{{"text",words[164]}} }},
			{"sayTime",{{{"text",words[164]}}, {{"number",1}} }},
			--{"think",{{{"text",words[168]}} }},
			{"thinkTime",{{{"text",words[168]}}, {{"number",1}} }},
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
			{"setAnchor", {{{"number", 0}}, {{"number", 100}}}},
		},
		["particles"]={
			--{"setSizeParticle", {{{"text",words[417]}},{{"number",60}}}},
			{"setPositionParticle", {{{"text",words[417]}},{{"number",100}},{{"number",200}}} },
			{"editPositionXParticle",{{{"text",words[417]}},{{"number",10}}}},
			{"editPositionYParticle",{{{"text",words[417]}},{{"number",10}}}},
			{"deleteParticle", {{{"text",words[417]}}}},
			{"deleteAllParticles"},
			{"createRadialParticle",{{{"text",words[417]}},{"images",nameImage},{{"number",500}},{{"function","true"}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",2}},{{"number",0}},{{"number",20}},{{"number",0}},{{"number",5}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"text","#FFFFFF"}},{{"text","#000000"}},{{"text","#000000"}},{{"text","#000000"}},{"GL","GL_SRC_ALPHA"},{"GL","GL_ONE"} }},
			{"createLinearParticle",{{{"text",words[417]}},{"images",nameImage},{{"number",500}},{{"function","true"}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",2}},{{"number",0}},{{"number",20}},{{"number",0}},{{"number",5}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"number",0}},{{"text","#FFFFFF"}},{{"text","#000000"}},{{"text","#000000"}},{{"text","#000000"}},{"GL","GL_SRC_ALPHA"},{"GL","GL_ONE"} }},
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
			{"hideVariable",{{localityVariable, nameVariable}}},
			{"insertVariableCamera", {{localityVariable, nameVariable}}},
			{"removeVariableCamera", {{localityVariable, nameVariable}}},
			{"saveVariable",{{localityVariable, nameVariable}}},
			{"readVariable",{{localityVariable, nameVariable}}},
			--{"saveVariableToFile",{{localityVariable, nameVariable}, {{"text",words[218]..".txt"}}}},
			--{"readVariableToFile",{{localityVariable, nameVariable}, {{"text",words[218]..".txt"}}, {"isDeleteFile","save"} }},
			{"addElementArray",{{{"number",1}},{localityArray, nameArray}}},
			{"deleteElementArray",{{localityArray, nameArray}, {{"number",1}} }},
			{"deleteAllElementsArray",{{localityArray, nameArray}}},
			{"pasteElementArray", {{{"number",1}},{localityArray, nameAreay}, {{"number",1}}}},
			{"replaceElementArray",{{localityArray, nameArray}, {{"number",1}},{{"number",1}}}},
			{"saveArray",{{localityArray, nameArray}}},
			{"readArray",{{localityArray, nameArray}}},
			{"columnStorageToArray",{{{"number",1}},{{"text",words[238]}},{localityArray, nameArray}}},
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
			{"showToast", {{{"text", words[164]}}}},
			--{"lua", {{{"text", "native.showAlert(\""..words[388].."\", \""..words[389].."\", {\"OK\"})"}}}},
			{"setHorizontalOrientation"},
			{"setVerticalOrientation"},
			{"removeAdaptiveSizeDevice"},
		},
		["textFields"]={
			{"ask",{{{"text",words[161]}}, {localityVariable, nameVariable}, {"function",nameFunction} }},
			{"createTextField", { {{"text", words[493]}}, {"onOrOff","on"}, {{"number",300}}, {{"number", 100}}, {localityVariable, nameVariable} }},
			{"removeCameraTextField", {{{"text", words[493]}}}},
			{"insertCameraTextField", {{{"text", words[493]}}}},
			{"setPositionTextField", { {{"text",words[493]}}, {{"number", 100}}, {{"number", 200}} }},
			{"editPositionTextField", { {{"text",words[493]}}, {{"number", 10}}, {{"number", 20}} }},
			{"setFontSizeTextField", { {{"text", words[493]}}, {{"number", 16}} }},
			{"setTypeInputTextField", { {{"text", words[493]}}, {"typeInput", "phone"} }},
			{"setAlignTextField", { {{"text", words[493]}}, {"alignText", "center"} }},
			{"deleteTextField", { {{"text", words[493]}} }},
			{"isSecureTextField", { {{"text", words[493]}}, {"onOrOff","on"} }},
			{"placeholderTextField", { {{"text", words[493]}}, {{"text", words[164]}} }},
			{"valueTextField", { {{"text", words[493]}}, {{"text", words[164]}} }},
			{"setColorTextField", { {{"text", words[493]}}, {{"text", "#FF0000"}} }},
			{"setSelectionTextField", { {{"text", words[493]}}, {{"number", 2}}, {{"number", 4}} }},
			{"getSelectionTextField", { {{"text", words[493]}}, {localityVariable, nameVariable}, {localityVariable, nameVariable} }},
			{"setKeyboardToTextField", {{{"text", words[493]}}}},
			{"removeKeyboardToTextField"},
		},
		["miniScenes"]={
			{"createMiniScene", {{{"text",words[530]}}}},
			{"deleteMiniScene", {{{"text", words[530]}}}},
			{"miniSceneInsert", {{{"text",words[530]}}}},
			{"setPositionMiniScene", { {{"text",words[530]}}, {{"number", 100}}, {{"number", 200}} }},
			{"setSizeMiniScene", { {{"text",words[530]}}, {{"number", 60}} }},
			{"editSizeMiniScene", { {{"text",words[530]}}, {{"number", 10}} }},
			{"editPositionMiniScene", { {{"text",words[530]}}, {{"number", 10}}, {{"number", 20}} }},
			{"setRotationMiniScene", { {{"text",words[530]}}, {{"number", 90}} }},
			{"editRotationMiniScene", { {{"text",words[530]}}, {{"number", 90}} }},
			{"setAlphaMiniScene", { {{"text",words[530]}}, {{"number", 60}} }},
			{"editAlphaMiniScene", { {{"text",words[530]}}, {{"number", 10}} }},
			{"miniSceneHide", {{{"text",words[530]}}}},
			{"miniSceneShow", {{{"text",words[530]}}}},
			{"miniSceneInsertMiniScene", {{{"text", words[530]}}, {{"text", words[530].." 2"}} }},
			{"miniSceneInsertCamera", {{{"text",words[530]}}}},
			{"miniSceneRemoveCamera", {{{"text",words[530]}}}},
		},
		["elementInterface"] = {
			{"newWebView", {{{"text", words[589]}}, {{"text", "https://example.com"}}, {{"number", 100}}, {{"number", 200}}, {{"number", 400}}, {{"number", 800}}}},
			{"setWebViewX", {{{"text", words[589]}}, {{"number", -100}}}},
			{"setWebViewY", {{{"text", words[589]}}, {{"number", -200}}}},
			{"insertWebInMiniScene", {{{"text", words[589]}}, {{"text", words[530]}}}},
			{"setWebViewWidth", {{{"text", words[589]}}, {{"number", 200}}}},
			{"setWebViewHeight", {{{"text", words[589]}}, {{"number", 300}}}},
			{"setLinkWebView", {{{"text", words[589]}}, {{"text", "https://google.com"}}}},
			{"backWebView", {{{"text", words[589]}}}},
			{"forwardWebView", {{{"text", words[589]}}}},
			{"stopWebView", {{{"text", words[589]}}}},
			{"reloadWebView", {{{"text", words[589]}}}},
			
			{"createJoystick", { {{"text", words[581]}}, {"images", nameImage}, {"images", nameImage}, {localityVariable, nameVariable}, {localityVariable, nameVariable},{"function", nameFunction} }},
			{"cameraInsertJoystick", {{{"text", words[581]}}}},
			{"cameraRemoveJoystick", {{{"text", words[581]}}}},
			{"setPositionJoystick", {{{"text", words[581]}}, {{"number", 100}}, {{"number", 200}} }},
			{"setSizeJoystick", {{{"text", words[581]}}, {{"number", 60}} }},
			{"setSizeJoystick1", {{{"text", words[581]}}, {{"number", 60}} }},
			{"setSizeJoystick2", {{{"text", words[581]}}, {{"number", 60}} }},
			{"setPositionJoystick", {{{"text", words[581]}}, {{"number", 100}}, {{"number", 200}} }},
		},
	}
	return(myTable)
end



premBlocks = {
	createJoystick=true,
	setPositionJoystick=true,
	setSizeJoystick=true,
	setSizeJoystick1=true,
	setSizeJoystick2=true,
	setShapeHitbox=true,
	removeCameraTextField=true,
	insertCameraTextField=true,
	setPositionTextField=true,
	editPositionTextField=true,
	setFontSizeTextField=true,
	setTypeInputTextField=true,
	setAlignTextField=true,
	--deleteTextField=true,
	isSecureTextField=true,
	placeholderTextField=true,
	valueTextField=true,
	setColorTextField=true,
	setSelectionTextField=true,
	getSelectionTextField=true,
	setKeyboardToTextField=true,
	removeKeyboardToTextField=true,
}


return(f)