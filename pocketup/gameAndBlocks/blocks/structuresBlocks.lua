--[[ здесь хранится вся информация о блоках: 
тип(событие или блок);
текстура;
параметры;
ширина текстуры в пикселях;
высота текстуры в пикселях;
наличие дополнительных блоков(false - нет доп. блоков, true - есть доп. блоки, "end" и "else" - тип у дополнительного блока);
]]

--[[
что насчет добавления дополнительных блоков(например блок конец или если) - в этом файле есть переменная additionallyBlocks.
в таблицуе элементы это названия блоков к которым нужно добавить другие блоки, а значения это сами блоки которые нужно добавить
]]

allBlocks = {
	["start"]={"event","blocks/event_brown_1.png",{ {{"text",words[57]}} }, 412,154, false},
	["touchObject"]={"event","blocks/event_brown_1.png",{ {{"text",words[76]}} }, 412,154, false},
	["touchScreen"]={"event","blocks/event_brown_1.png",{ {{"text",words[77]}} }, 412,154, false},
	["function"]={"event","blocks/event_brown_2.png",{ {{"text",words[78]}}, {{"function",nil}} }, 411, 206, false},
	["broadcastFunction"]={"block","blocks/block_orange_2.png",{ {{"text",words[80]}}, {{"function",nil}} }, 109, 142, false},
	["broadcastFunctionAndWait"]={"block","blocks/block_orange_2.png",{ {{"text",words[81]}}, {{"function",nil}} }, 109, 142, false},
	--["whenTheTruth"]={"event","blocks/event_brown_1.png",{ {{"text",words[82]}, {"cell",nil, 1.5}, {"text", words[83]}} }, 412,154, false},
	["collision"]={"event","blocks/event_blue_2.png",{ {{"text",words[84]}}, {{"objects",nil}} }, 411, 206, false},
	["changeBackground"]={"event","blocks/event_brown_2.png",{ {{"text",words[86]}}, {{"backgrounds",nil}} }, 411, 206, false},
	["startClone"]={"event","blocks/event_brown_1.png",{ {{"text",words[88]}} }, 412,154, false},
	["clone"]={"block","blocks/block_orange_2.png",{ {{"text",words[89]}},{{"objects",nil}} }, 109,142, false},
	["deleteClone"]={"block","blocks/block_orange_1.png",{ {{"text",words[91]}} }, 109,88, false},
	["wait"]={"block","blocks/block_orange_1.png",{ {{"text",words[92]},{"cell",nil,1.5},{"text",words[93]}} }, 109,88, false},
	["commentary"]={"block","blocks/block_orange_1.png",{ {{"text",words[94]},{"cell",nil,4.5}} }, 109,88, false},
	["cycleForever"]={"block", "blocks/block_orange_1.png", { {{"text",words[61]}} }, 109, 88, true}, 
	["endCycleForever"]={"block", "blocks/block_orange_1.png", { {{"text",words[62]}} }, 109, 88, "end"},
	["ifElse (2)"]={"block", "blocks/block_orange_2.png", { {{"text",words[96]}, {"cell",nil,1.5}, {"text",words[97]}}, {{"text", "... "..words[98].." ..."}} }, 109, 142, false},
	["if"]={"block", "blocks/block_orange_1.png", { {{"text",words[96]}, {"cell",nil,1.5}, {"text",words[97]}} }, 109, 88, true},
	["else"]={"block", "blocks/block_orange_1.png", { {{"text",words[98]}} }, 109, 88, "else"},
	["endIf"]={"block", "blocks/block_orange_1.png", { {{"text",words[99]}} }, 109, 88, "end"},
	["if (2)"]={"block", "blocks/block_orange_1.png", { {{"text",words[96]}, {"cell",nil,1.5}, {"text",words[97].." ..."}} }, 109, 88, false},
	["waitIfTrue"]={"block", "blocks/block_orange_1.png", { {{"text",words[100]}, {"cell",nil,1.5}, {"text",words[101]}} }, 109, 88, true},
	["endWait"]={"block","blocks/block_orange_1.png", {{{"text", words[446]}}}, 109, 88, "end"},
	["repeat"]={"block", "blocks/block_orange_1.png", { {{"text",words[102]}, {"cell",nil,1.5}, {"text",words[103]}} }, 109, 88, true},
	["endRepeat"]={"block", "blocks/block_orange_1.png", { {{"text",words[104]}} }, 109, 88, "end"},
	["repeatIsTrue"]={"block", "blocks/block_orange_1.png", { {{"text",words[105]}, {"cell",nil,1.5}, {"text",words[101]}} }, 109, 88, true},
	["for"]={"block", "blocks/block_orange_2.png", { {{"text",words[106]}, {"cell",nil,1.25}, {"text",words[107]}, {"cell",nil,1.25}}, {{"variables",nil}} }, 109, 142, true},
	["endFor"]={"block", "blocks/block_orange_1.png", { {{"text",words[108]}} }, 109, 88, "end"},
	["foreach"]={"block", "blocks/block_orange_3.png", { {{"text",words[109]}}, {{"arrays",nil}}, {{"text",words[110]}}, {{"variables",nil}} }, 109, 188, true},
	["endForeach"]={"block", "blocks/block_orange_1.png", { {{"text",words[108]}} }, 109, 88, "end"},
	["continueScene"]={"block", "blocks/block_orange_2.png", { {{"text",words[111]}}, {{"scenes",nil}} }, 109, 142, false},
	["runScene"]={"block", "blocks/block_orange_2.png", { {{"text",words[112]}}, {{"scenes",nil}} }, 109, 142, false},
	["stopScript"]={"block", "blocks/block_orange_1.png", { {{"text",words[113]}} }, 109, 88, false},
	--["waitStopScripts"]={"block", "blocks/block_orange_1.png", {{{"text", words[117]}}}, 109, 88, false},
	["setPosition"]={"block", "blocks/block_blue_2.png", { {{"text",words[58]}}, {{"text",words[59]..":"}, {"cell",nil, 1.5}, {"text",words[60]..":"}, {"cell",nil , 1.5}} }, 109, 142, false},
	["setPositionX"]={"block", "blocks/block_blue_1.png", { {{"text",words[118]}, {"cell",nil, 1.5}} }, 109, 88, false},
	["setPositionY"]={"block", "blocks/block_blue_1.png", { {{"text",words[119]}, {"cell",nil, 1.5}} }, 109, 88, false},
	["editPositionX"]={"block", "blocks/block_blue_1.png", { {{"text",words[120]..":"}, {"cell",nil, 1.5}} }, 109, 88, false},
	["editPositionY"]={"block", "blocks/block_blue_1.png", { {{"text",words[121]..":"}, {"cell",nil, 1.5}} }, 109, 88, false},
	["goTo"]={"block", "blocks/block_blue_2.png", { {{"text",words[122]}},{{"goTo",nil}} }, 109, 142, false},
	["goSteps"]={"block", "blocks/block_blue_1.png", { {{"text",words[125]},{"cell",nil,1.5},{"text",words[126]}} }, 109, 88, false},
	["editRotateLeft"]={"block", "blocks/block_blue_1.png", { {{"text",words[127]},{"cell",nil,1.25},{"text",words[128]}} }, 109, 88, false},
	["editRotateRight"]={"block", "blocks/block_blue_1.png", { {{"text",words[129]},{"cell",nil,1.25},{"text",words[128]}} }, 109, 88, false},
	["setRotate"]={"block", "blocks/block_blue_1.png", { {{"text",words[130]},{"cell",nil,1.25},{"text",words[128]}} }, 109, 88, false},
	["setRotateToObject"]={"block", "blocks/block_blue_2.png", { {{"text",words[131]}},{{"objects",nil,1.25}} }, 109, 142, false},
	["setTypeRotate"]={"block", "blocks/block_blue_2.png", { {{"text",words[132]}},{{"typeRotate",nil,1.25}} }, 109, 142, false},
	["transitionPosition"]={"block", "blocks/block_blue_2.png", { {{"text",words[63]}, {"cell", nil, 1.5}, {"text", words[64]}}, {{"text",words[65]..":"}, {"cell",nil, 1.5}, {"text",words[60]..":"}, {"cell",nil, 1.5}} }, 109, 142, false},
	["vibration"]={"block", "blocks/block_blue_1.png", { {{"text",words[136]}, {"cell", nil, 1.5}, {"text", words[64]}} }, 109, 88, false},
	["speedStepsToSecoond"]={"block", "blocks/block_blue_2.png", { {{"text",words[137]}}, {{"text",words[59]..":"}, {"cell", nil, 1.5}, {"text", words[60]..":"}, {"cell", nil, 1.5},{"text",words[138]}} }, 109, 142, false},
	["rotateLeftForever"]={"block", "blocks/block_blue_1.png", { {{"text",words[139]}, {"cell", nil, 1.5}, {"text", words[128]..":"}} }, 109, 88, false},
	["rotateRightForever"]={"block", "blocks/block_blue_1.png", { {{"text",words[140]}, {"cell", nil, 1.5}, {"text", words[128]..":"}} }, 109, 88, false},
	["setGravityAllObjects"]={"block", "blocks/block_blue_2.png", { {{"text",words[141]}}, {{"text",words[59]..":"}, {"cell", nil, 1.5}, {"text", words[60]..":"}, {"cell", nil, 1.5},{"text",words[138]}} }, 109, 142, false},
	["setWeight"]={"block", "blocks/block_blue_1.png", { {{"text",words[142]}, {"cell", nil, 1.5}, {"text", words[143]}} }, 109,88, false},
	["setElasticity"]={"block", "blocks/block_blue_1.png", { {{"text",words[144]}, {"cell", nil, 1.5}, {"text", "%"}} }, 109,88, false},
	["setFriction"]={"block", "blocks/block_blue_1.png", { {{"text",words[145]}, {"cell", nil, 1.5}, {"text", "%"}} }, 109,88, false},
	["playSound"]={"block", "blocks/block_violet_2.png", { {{"text",words[146]}}, {{"sounds", nil, 1.5}} }, 109,142, false},
	--["playSoundAndWait"]={"block", "blocks/block_violet_2.png", { {{"text",words[147]}}, {{"sounds", nil, 1.5}} }, 109,142, false},
	["stopSound"]={"block", "blocks/block_violet_2.png", { {{"text",words[148]}}, {{"sounds", nil, 1.5}} }, 109,142, false},
	["stopAllSounds"]={"block", "blocks/block_violet_1.png", { {{"text",words[149]}} }, 109,88, false},
	["setVolumeSound"]={"block", "blocks/block_violet_1.png", { {{"text",words[150]}, {"cell",nil,1.5},{"text","%"}} }, 109,88, false},
	["editVolumeSound"]={"block", "blocks/block_violet_1.png", { {{"text",words[151]},{"cell",nil,1.5},{"text","%"}} }, 109,88, false},
	["setImageToName"]={"block", "blocks/block_green_2.png", { {{"text",words[152]}},{{"images",nil}} }, 109,142, false},
	["setImageToId"]={"block", "blocks/block_green_1.png", { {{"text",words[153]},{"cell",nil,1.5}} }, 109,88, false},
	["nextImage"]={"block", "blocks/block_green_1.png", { {{"text",words[154]}} }, 109,88, false},
	["previousImage"]={"block", "blocks/block_green_1.png", { {{"text",words[155]}} }, 109,88, false},
	["setSize"]={"block", "blocks/block_green_1.png", { {{"text",words[156]},{"cell",nil,1.5},{"text","%"}} }, 109,88, false},
	["editSize"]={"block", "blocks/block_green_1.png", { {{"text",words[157]},{"cell",nil,1.5}} }, 109,88, false},
	["hide"]={"block", "blocks/block_green_1.png", { {{"text",words[158]}} }, 109,88, false},
	["show"]={"block", "blocks/block_green_1.png", { {{"text",words[159]}} }, 109,88, false},
	["ask"]={"block", "blocks/block_green_3_5.png", { {{"text",words[160]},{"cell",nil,4.5}}, {{"text",words[162]}}, {{"variables",nil}}, {{"text", words[487]}}, {{"function"}} }, 109,220, false},
	--["say"]={"block", "blocks/block_green_1.png", { {{"text",words[163]},{"cell",nil,4}} }, 109,88, false},
	["sayTime"]={"block", "blocks/block_green_2.png", { {{"text",words[163]},{"cell",nil,4}}, {{"text",words[165]}, {"cell", nil, 1.5}, {"text", words[166]}} }, 109,142, false},
	--["think"]={"block", "blocks/block_green_1.png", { {{"text",words[167]},{"cell",nil,3}} }, 109,88, false},
	["thinkTime"]={"block", "blocks/block_green_2.png", { {{"text",words[167]},{"cell",nil,3}}, {{"text",words[165]}, {"cell", nil, 1.5}, {"text", words[166]}} }, 109,142, false},
	["setAlpha"]={"block", "blocks/block_green_2.png", { {{"text",words[169]}},{{"text",words[170]},{"cell",nil,1}, {"text","%"}} }, 109,142, false},
	["editAlpha"]={"block", "blocks/block_green_2.png", { {{"text",words[171]}},{{"text",words[172]},{"cell",nil,1}} }, 109,142, false},
	["setBrightness"]={"block", "blocks/block_green_2.png", { {{"text",words[173]}},{{"text",words[170]},{"cell",nil,1}, {"text","%"}} }, 109,142, false},
	["editBrightness"]={"block", "blocks/block_green_2.png", { {{"text",words[174]}},{{"text",words[172]},{"cell",nil,1}} }, 109,142, false},
	["setColor"]={"block", "blocks/block_green_2.png", { {{"text",words[175]}},{{"text",words[170]},{"cell",nil,1}, {"text","%"}} }, 109,142, false},
	["editColor"]={"block", "blocks/block_green_2.png", { {{"text",words[176]}},{{"text",words[172]},{"cell",nil,1}} }, 109,142, false},
	
	["createRadialParticle"]={"block", "blocks/block_green_4.png", { {{"text",words[177]}},{{"text",words[399]},{"cell",nil,4}},{{"images"}},{{"text",words[400]},{"cell",nil,2}},{{"text",words[401]},{"cell",nil,2}},{{"text",words[402]},{"cell",nil,4}},{{"text",words[403]},{"cell",nil,4}},{{"text",words[404]},{"cell",nil,1.5}},{{"text",words[403]},{"cell",nil,4}},{{"text",words[406]},{"cell",nil,1.5}},{{"text",words[403]},{"cell",nil,4}},{{"text",words[407]},{"cell",nil,1.5}},{{"text",words[403]},{"cell",nil,4}},{{"text",words[408]},{"cell",nil,1.5}},{{"text",words[403]},{"cell",nil,4}},{{"text",words[409]},{"cell",nil,1.5}},{{"text",words[403]},{"cell",nil,4}},{{"text",words[410]},{"cell",nil,1.5}},{{"text",words[403]},{"cell",nil,4}},{{"text",words[411]},{"cell",nil,1.5}},{{"text",words[403]},{"cell",nil,4}},{{"text",words[412]},{"cell",nil,1.5}},{{"text",words[403]},{"cell",nil,4}},{{"text",words[413]},{"cell",nil,2}},{{"text",words[403]},{"cell",nil,4}},{{"text",words[414]},{"cell",nil,2}},{{"text",words[403]},{"cell",nil,4}},{{"text",words[415]}},{{"GL"}},{{"text",words[416]}},{{"GL"}}--[[{{"effectParticle",nil,1}}]] }, 109,1800, false},
	["createLinearParticle"]={"block", "blocks/block_green_4.png", { {{"text",words[405]}},{{"text",words[399]},{"cell",nil,4}},{{"images"}},{{"text",words[400]},{"cell",nil,2}},{{"text",words[401]},{"cell",nil,2}},{{"text",words[402]},{"cell",nil,4}},{{"text",words[403]},{"cell",nil,4}},{{"text",words[418]},{"cell",nil,4.5}},{{"text",words[403]},{"cell",nil,4}},{{"text",words[419]},{"cell",nil,1.5},{"text",words[420]},{"cell",nil,1.5}},{{"text",words[421]},{"cell",nil,1},{"text",words[420]},{"cell",nil,1}},{{"text",words[422]},{"cell",nil,1.5}},{{"text",words[403]},{"cell",nil,4}},{{"text",words[423]},{"cell",nil,1.5}},{{"text",words[403]},{"cell",nil,4}},{{"text",words[408]},{"cell",nil,1.5}},{{"text",words[403]},{"cell",nil,4}},{{"text",words[409]},{"cell",nil,1.5}},{{"text",words[403]},{"cell",nil,4}},{{"text",words[410]},{"cell",nil,1.5}},{{"text",words[403]},{"cell",nil,4}},{{"text",words[411]},{"cell",nil,1.5}},{{"text",words[403]},{"cell",nil,4}},{{"text",words[412]},{"cell",nil,1.5}},{{"text",words[403]},{"cell",nil,4}},{{"text",words[413]},{"cell",nil,2}},{{"text",words[403]},{"cell",nil,4}},{{"text",words[414]},{"cell",nil,2}},{{"text",words[403]},{"cell",nil,4}},{{"text",words[415]}},{{"GL"}},{{"text",words[416]}},{{"GL"}} }, 109, 1800, false},
	["deleteParticle"]={"block", "blocks/block_green_2.png", { {{"text",words[424]}}, {{"text",words[399]},{"cell",nil,4}} }, 109, 142, false},
	["deleteAllParticles"]={"block", "blocks/block_green_1.png", { {{"text",words[425]}} }, 109, 88, false},
	["setPositionParticle"]={"block", "blocks/block_green_3.png",{ {{"text",words[426]}},{{"text",words[399]},{"cell",nil,4}},{{"text",words[59]..":"},{"cell",nil,1.5},{"text",words[60]..":"},{"cell",nil,1.5}} }, 109, 188, false},
	--["setSizeParticle"]={"block","blocks/block_green_3.png", { {{"text", words[428]}},{{"text",words[399]},{"cell",nil,4}},{{"text", words[337]},{"cell",nil,4.25},{"text","%"}} }, 109, 188, false},
	["editPositionXParticle"]={"block", "blocks/block_green_3.png",{ {{"text",words[429]}},{{"text",words[430]},{"cell",nil,4}},{{"text",words[206]..":"},{"cell",nil,2}} },109,188,false},
	["editPositionYParticle"]={"block", "blocks/block_green_3.png",{ {{"text",words[429]}},{{"text",words[430]},{"cell",nil,4}},{{"text",words[431]..":"},{"cell",nil,2}} },109,188,false},

	--["onAdaptabilityEffect"]={"block", "blocks/block_green_2.png", { {{"text",words[180]}},{{"onOrOff",nil}} }, 109,142, false},
	--["setColorParticle"]={"block", "blocks/block_green_2.png", { {{"text",words[181]},{"cell",nil,2.25}} }, 109,142, false},
	--["clearGraphicsEffects"]={"block", "blocks/block_green_1.png", { {{"text",words[182]}} }, 109,88, false},
	["focusCameraToObject"]={"block", "blocks/block_green_3.png", { {{"text",words[185]}},{{"cell",nil,1.25},{"text",words[186]}},{{"cell",nil,1.25},{"text",words[187]}} }, 109,188, false},
	["setImageBackgroundToName"]={"block", "blocks/block_green_2.png", { {{"text",words[188]}},{{"backgrounds",nil}} }, 109,142, false},
	["setImageBackgroundToId"]={"block", "blocks/block_green_1.png", { {{"text",words[189]},{"cell",nil,1.5}} }, 109,88, false},
	--["setImageBackgroundToNameAndWait"]={"block", "blocks/block_green_2.png", { {{"text",words[190]}},{{"backgrounds",nil}} }, 109,142, false},
	--["setImageBackgroundToIdAndWait"]={"block", "blocks/block_green_2.png", { {{"text",words[189]},{"cell",nil,1.5}}, {{"text",words[191]}} }, 109,142, false},
	["getLinkImage"]={"block", "blocks/block_green_3.png", { {{"text",words[192]}},{{"cell",nil,8}}, {{"text",words[193]}} }, 109,188, false},
	["lowerPen"]={"block","blocks/block_darkgreen_1.png",{{{"text",words[194]}}}, 109, 88, false},
	["raisePen"]={"block","blocks/block_darkgreen_1.png",{{{"text",words[195]}}}, 109, 88, false},
	["setSizePen"]={"block","blocks/block_darkgreen_1.png",{{{"text",words[196]},{"cell",nil,1.5}}}, 109, 88, false},
	["setColorPen"]={"block","blocks/block_darkgreen_3.png",{{{"text",words[197]..":"}},{{"text",words[198]},{"cell",nil,1.25},{"text",words[199]},{"cell",nil,1.25}},{{"text",words[200]},{"cell",nil,1.25}}}, 109, 188, false},
	["stamp"]={"block","blocks/block_darkgreen_1.png", {{{"text",words[201]}}}, 109, 88, false},
	["clearPen"]={"block","blocks/block_darkgreen_1.png", {{{"text",words[202]}}}, 109, 88, false},
	["setVariable"]={"block","blocks/block_red_2.png", {{{"text",words[203]}},{{"variables",nil}},{{"text",words[170]},{"cell",nil,1.5}}}, 109, 142, false},
	["editVariable"]={"block","blocks/block_red_2.png", {{{"text",words[204]}},{{"variables",nil}},{{"text",words[172]},{"cell",nil,1.5}}}, 109, 142, false},
	["showVariable"]={"block","blocks/block_red_2.png", {{{"text",words[205]}},{{"variables",nil}},{{"text",words[206]..":"},{"cell",nil,1.5}, {"text",words[60]..":"},{"cell",nil,1.5}}}, 109, 142, false},
	["showVariable2"]={"block","blocks/block_red_4.png", {{{"text",words[205]}},{{"variables",nil}},{{"text",words[206]..":"},{"cell",nil,1.5}, {"text",words[60]..":"},{"cell",nil,1.5}}, {{"text",words[207]}, {"cell",nil,1.5}, {"text",words[208]}, {"cell",nil,2}}, {{"text",words[209]}}, {{"alignText",nil}}}, 109, 300, false},
	["hideVariable"]={"block","blocks/block_red_2.png", { {{"text",words[213]}},{{"variables",nil}} }, 109, 142, false},
	["saveVariable"]={"block","blocks/block_red_2.png", { {{"text",words[214]}},{{"variables",nil}} }, 109, 142, false},
	["readVariable"]={"block","blocks/block_red_2.png", { {{"text",words[215]}},{{"variables",nil}} }, 109, 142, false},
	--["saveVariableToFile"]={"block","blocks/block_red_3.png", { {{"text",words[216]}},{{"variables",nil}}, {{"text",words[217]},{"cell",nil,5}} }, 109, 188, false},
	--["readVariableToFile"]={"block","blocks/block_red_3.png", { {{"text",words[219]}},{{"variables",nil}}, {{"text",words[220]},{"cell",nil,5}, {"text",words[221]}}, {{"isDeleteFile",nil}} }, 109, 188, false},
	["addElementArray"]={"block","blocks/block_red_2.png", { {{"text",words[224]},{"cell",nil,1.5},{"text",words[225]}},{{"arrays",nil}} }, 109, 142, false},
	["deleteElementArray"]={"block","blocks/block_red_2.png", { {{"text",words[226]}},{{"arrays",nil}},{{"text",words[227]}, {"cell",nil,1.5}} }, 109, 142, false},
	["deleteAllElementsArray"]={"block","blocks/block_red_2.png", { {{"text",words[228]}},{{"arrays",nil}} }, 109, 142, false},
	["pasteElementArray"]={"block","blocks/block_red_2.png", { {{"text",words[229]},{"cell",nil,1.5},{"text",words[230]}},{{"arrays",nil}}, {{"text",words[231]},{"cell",nil,1.5}} }, 109, 142, false},
	["replaceElementArray"]={"block","blocks/block_red_2.png", { {{"text",words[232]}},{{"arrays",nil}}, {{"text",words[233]},{"cell",nil,1.5}, {"text",words[172]},{"cell",nil,1.5}} }, 109, 142, false},
	["saveArray"]={"block","blocks/block_red_2.png", { {{"text",words[234]}},{{"arrays",nil}} }, 109, 142, false},
	["readArray"]={"block","blocks/block_red_2.png", { {{"text",words[235]}},{{"arrays",nil}} }, 109, 142, false},
	["columnStorageToArray"]={"block","blocks/block_red_3_5.png", { {{"text",words[236]},{"cell",nil,1.5},{"text",words[179]}},{{"text",words[237]}},{{"cell",nil,8}},{{"text",words[239]}},{{"arrays",nil}} }, 109, 250, false},
	["getRequest"]={"block","blocks/block_red_3_5.png", { {{"text",words[240]}},{{"cell",nil,8}},{{"text",words[241]}},{{"variables",nil}} }, 109, 250, false},
	--["resetTimer"]={"block","blocks/block_gold_1.png", { {{"text",words[242]}} }, 109, 88, false},
	["openLink"]={"block","blocks/block_gold_2.png", { {{"text",words[243]}},{{"cell",nil,5},{"text",words[244]}} }, 109, 142, false},
	["blockTouch"]={"block","blocks/block_gold_1.png", { {{"text",words[245]}} }, 109, 88, false},
	["blockTouchScreen"]={"block","blocks/block_gold_1.png", { {{"text",words[246]}} }, 109, 88, false},
	--["touchAndSwipe"]={"block","blocks/block_gold_3_5.png", { {{"text",words[247]}},{{"text",words[248]..":"},{"cell",nil,1.5},{"text",words[60]..":"}, {"cell",nil,1.5}},{{"text",words[65]..":"},{"cell",nil,1.5},{"text",words[60]..":"}, {"cell",nil,1.5}}, {{"text",words[178]},{"cell",nil,1.5},{"text",words[166]}} }, 109, 250, false},
	["lua"]={"block", "blocks/block_gold_2.png",  {{{"text", words[387]}}, {{"cell", nil, 8}}}, 109, 142, false},
	["timer"]={'block', 'blocks/block_orange_2.png',{{{"text", words[437]}, {"cell", nil, 1.5}, {"text", words[103]}}, {{"text", words[390]}, {"cell", nil, 1.5}, {"text", words[93]}}}, 109, 142, true},
	["endTimer"]={"block", "blocks/block_orange_1.png", { {{"text",words[391]}} }, 109, 88, "end"},
	["addBody"]={"block", "blocks/block_blue_2.png", { {{"text",words[392]}}, {{"typeBody"}} }, 109, 142, false},
	["exitGame"]={"block","blocks/block_orange_1.png",{ {{"text",words[396]}} }, 109,88, false},
	["toFrontLayer"]={"block", "blocks/block_blue_1.png", { {{"text",words[397]}} }, 109, 88, false},
	["toBackLayer"]={"block", "blocks/block_blue_1.png", { {{"text",words[398]}} }, 109, 88, false},
	["removeObjectCamera"]={"block", "blocks/block_green_1.png", {{{"text",words[432]}}},109,88,false},
	["insertObjectCamera"]={"block", "blocks/block_green_1.png", {{{"text",words[433]}}},109,88,false},
	["removeFocusCameraToObject"]={"block", "blocks/block_green_1.png", {{{"text",words[434]}}},109,88,false},
	["removeVariableCamera"]={"block", "blocks/block_green_2.png", {{{"text", words[435]}},{{"variables"}}}, 109, 142, false},
	["insertVariableCamera"]={"block", "blocks/block_green_2.png", {{{"text", words[436]}},{{"variables"}}}, 109, 142, false},
	["broadcastFun>allObjects"]={"block","blocks/block_orange_2.png",{ {{"text",words[438]}}, {{"function",nil}} }, 109, 142, false},
	["broadcastFun>allClones"]={"block","blocks/block_orange_2.png",{ {{"text",words[439]}}, {{"function",nil}} }, 109, 142, false},
	["broadcastFun>objectAndClones"]={"block","blocks/block_orange_2.png",{ {{"text",words[440]}}, {{"objects",nil}}, {{"function",nil}} }, 109, 142, false},
	["broadcastFun>object"]={"block","blocks/block_orange_2.png",{ {{"text",words[441]}}, {{"objects",nil}}, {{"function",nil}} }, 109, 142, false},
	["broadcastFun>clones"]={"block","blocks/block_orange_2.png",{ {{"text",words[442]}}, {{"objects",nil}}, {{"function",nil}} }, 109, 142, false},
	["addNameClone"]={"block","blocks/block_orange_1.png",{ {{"text",words[443]..":"},{"cell", nil, 3}} }, 109, 88, false},
	["broadcastFun>nameClone"]={"block","blocks/block_orange_3.png",{ {{"text",words[445]}},{{"text",words[430]},{"cell", nil, 5}},{{"function",nil}} }, 109,188, false},
	["setBackgroundColor"]={"block", "blocks/block_green_3.png",  { {{"text", words[447]}}, {{"text", words[448]..':'}, {"cell", nil, 1}, {"text", words[450]..':'}, {"cell", nil, 1 }}, { {"text", words[449]..':'}, {"cell", nil, 1}}}, 109, 188, false},
	["setBackgroundColorHex"]={"block", "blocks/block_green_2.png", { {{"text", words[447]}}, {{"text", words[451]..':'}, {"cell", nil, 4.5} } }, 109, 142, false},
	["cancelAllTimers"]={"block", "blocks/block_orange_1.png", { {{"text", words[452]}} }, 109,88,false},
	["showToast"]={"block", "blocks/block_gold_2.png", { {{"text", words[453]}}, {{"text", words[454]}, {"cell", nil, 5}} }, 109, 142, false},
	["showHitboxes"]={"block", "blocks/block_blue_1.png", { {{"text",words[455]}} }, 109, 88, false},
	["hideHitboxes"]={"block", "blocks/block_blue_1.png", { {{"text",words[456]}} }, 109, 88, false},
	["setHorizontalOrientation"]={"block", "blocks/block_gold_1.png", { {{"text",words[457]}} }, 109, 88, false},
	["setVerticalOrientation"]={"block", "blocks/block_gold_1.png", { {{"text",words[458]}} }, 109, 88, false},
	["onTouchObject"]={"event","blocks/event_brown_1.png",{ {{"text",words[459]}} }, 412,154, false},
	["movedObject"]={"event","blocks/event_brown_1.png",{ {{"text",words[460]}} }, 412,154, false},
	["movedScreen"]={"event","blocks/event_brown_1.png",{ {{"text",words[461]}} }, 412,154, false},
	["onTouchScreen"]={"event","blocks/event_brown_1.png",{ {{"text",words[462]}} }, 412,154, false},
	["touchBack"]={"event","blocks/event_brown_1.png",{ {{"text",words[463]}} }, 412,154, false},
	["endedCollision"]={"event","blocks/event_blue_2.png",{ {{"text",words[464]}}, {{"objects",nil}} }, 411, 206, false},
	["setTextelCoarseness"]={"block", "blocks/block_blue_1.png", { {{"text",words[465]}, {"cell", nil, 1.5}} }, 109, 88, false},
	["jump"]={"block", "blocks/block_blue_1.png", { {{"text",words[467]..":"},{"cell", nil, 1.3}, {"text", words[420]..":"}, {"cell",nil,1.3}} }, 109, 88, false},
	["jumpX"]={"block", "blocks/block_blue_1.png", { {{"text",words[467]},{"cell", nil, 1.5}} }, 109, 88, false},
	["jumpY"]={"block", "blocks/block_blue_1.png", { {{"text",words[468]},{"cell", nil, 1.5}} }, 109, 88, false},
	["jumpYIf"]={"block", "blocks/block_blue_2.png", { {{"text",words[466]},{"cell", nil, 1.5},{"text",words[469]}},{{"text",words[470]}} }, 109, 142, false},
	["setGravityScale"]={"block", "blocks/block_blue_2.png", { {{"text",words[471]}},{{"text", words[472]},{"cell", nil, 3}} }, 109, 142, false},
	["setAnchorVariable"]={"block", "blocks/block_red_2.png", { {{"text",words[473]}},{{"variables"}},{{"text", words[65]},{"cell", nil, 1.5},{"text", words[420]},{"cell", nil, 1.5}} }, 109, 142, false},
	["toFrontLayerVar"]={"block", "blocks/block_blue_2.png", { {{"text",words[474]}},{{"variables"}},{{"text",words[475]}} }, 109, 142, false},
	["toBackLayerVar"]={"block", "blocks/block_blue_2.png", { {{"text",words[474]}},{{"variables"}},{{"text",words[476]}} }, 109, 142, false},
	["removeAdaptiveSizeDevice"]={"block", "blocks/block_gold_1.png", { {{"text",words[481]}} }, 109, 88, false},
	["createTextField"]={"block", "blocks/block_green_3_6.png", { {{"text", words[488]}}, {{"text", words[492]..":"}, {"cell",nil,3}}, {{"text", words[489]}}, {{"onOrOff"}}, {{"text",words[490]..":"}, {"cell", nil, 1.5}, {"text", words[491]..":"}, {"cell", nil, 1.5}}, {{"text", words[162]}}, {{"variables"}} }, 109, 350, false},
	["setPositionTextField"]={"block", "blocks/block_green_3.png", { {{"text", words[494]}}, {{"text", words[492]}, {"cell", nil, 3}}, {{"text", words[59]..":"}, {"cell", nil, 3}, {"text", words[60]..":"}, {"cell", nil, 3}} }, 109, 188, false},
	["editPositionTextField"]={"block", "blocks/block_green_3.png", { {{"text", words[495]}}, {{"text", words[492]}, {"cell", nil, 3}}, {{"text", words[59]..":"}, {"cell", nil, 3}, {"text", words[60]..":"}, {"cell", nil, 3}} }, 109, 188, false},
	["setFontSizeTextField"]={"block", "blocks/block_green_2.png", { {{"text", words[496]}}, {{"text", words[492]}, {"cell", nil, 1.5}, {"text", words[337]..":"}, {"cell", nil, 1.5}} }, 109, 142, false},
	["setTypeInputTextField"]={"block", "blocks/block_green_3.png", { {{"text", words[497]}}, {{"text", words[492]}, {"cell", nil, 3}}, {{"inputType"}} }, 109, 188, false},
	["setAlignTextField"]={"block", "blocks/block_green_3.png", { {{"text", words[505]}}, {{"text", words[492]}, {"cell", nil, 3}}, {{"alignText"}} }, 109, 188, false},
	["deleteTextField"]={"block", "blocks/block_green_2.png", { {{"text", words[506]}}, {{"text", words[492]}, {"cell", nil, 3}} }, 109, 142, false},
	["isSecureTextField"]={"block", "blocks/block_green_3.png", { {{"text", words[507]}}, {{"text", words[492]}, {"cell", nil, 3}}, {{"onOrOff"}} }, 109, 188, false},
	["placeholderTextField"]={"block", "blocks/block_green_3.png", { {{"text", words[508]}}, {{"text", words[492]}, {"cell", nil, 3}}, {{"text",words[170]}, {"cell", nil, 3}} }, 109, 188, false},
	["valueTextField"]={"block", "blocks/block_green_3.png", { {{"text", words[509]}}, {{"text", words[492]}, {"cell", nil, 3}}, {{"text",words[170]}, {"cell", nil, 3}} }, 109, 188, false},
	["setColorTextField"]={"block", "blocks/block_green_3.png", { {{"text", words[510]}}, {{"text", words[492]}, {"cell", nil, 3}}, {{"text",words[330]}, {"cell", nil, 3}} }, 109, 188, false},
	["setSelectionTextField"]={"block", "blocks/block_green_3.png", { {{"text", words[511]}}, {{"text", words[492]}, {"cell", nil, 3}}, {{"text",words[512]}, {"cell", nil, 3}}, {{"text",words[513]}, {"cell", nil, 3}} }, 109, 188, false},
	["getSelectionTextField"]={"block", "blocks/block_green_3.png", { {{"text", words[514]}}, {{"text", words[492]}, {"cell", nil, 3}}, {{"variables"}} }, 109, 188, false},
	["setKeyboardToTextField"]={"block", "blocks/block_green_2.png", { {{"text", words[515]}}, {{"text", words[492]}, {"cell", nil, 3}} }, 109, 142, false},
	["removeKeyboardToTextField"]={"block", "blocks/block_green_1.png", { {{"text", words[516]}} }, 109, 88, false},
	["insertCameraTextField"]={"block", "blocks/block_green_2.png", { {{"text", words[517]}}, {{"text", words[492]}, {"cell", nil, 3}} }, 109, 142, false},
	["removeCameraTextField"]={"block", "blocks/block_green_2.png", { {{"text", words[518]}}, {{"text", words[492]}, {"cell", nil, 3}} }, 109, 142, false},
	["setQuareHitbox"]={"block", "blocks/block_blue_1.png", { {{"text", words[519]}} }, 109, 88, false},
	["setQuareWHHitbox"]={"block", "blocks/block_blue_2.png", { {{"text", words[519]}}, {{"text", words[490]..":"}, {"cell", nil, 1.5}, {"text", words[491]..":"}, {"cell", nil, 1.5}} }, 109, 142, false},
	["setCircleHitbox"]={"block", "blocks/block_blue_2.png", { {{"text", words[520]}}, {{"text", words[521]..":"}, {"cell", nil, 1.5}} }, 109, 142, false},
	["setShapeHitbox"]={"block", "blocks/block_blue_2.png", { {{"text", words[522]}}, {{"shapeHitbox"}} }, 109, 142, false},
	["createMiniScene"]={"block", "blocks/block_yellow_2.png", { {{"text", words[528]}}, {{"text", words[529]..":"}, {"cell", nil, 3}} }, 109, 142, false},
	["deleteMiniScene"]={"block", "blocks/block_yellow_2.png", { {{"text",words[533]}},{{"text",words[529]..":"}, {"cell",nil,3}} }, 109, 142, false},
	["miniSceneInsertMiniScene"]={"block","blocks/block_yellow_2.png", { {{"text",words[534]}, {"cell", nil, 2}}, {{"text", words[535]}, {"cell",nil,2}} }, 109, 142, false},
	["miniSceneHide"]={"block", "blocks/block_yellow_2.png", { {{"text", words[536]}}, {{"text", words[529]..":"}, {"cell", nil, 3}} }, 109, 142, false},
	["miniSceneShow"]={"block", "blocks/block_yellow_2.png", { {{"text", words[537]}}, {{"text", words[529]..":"}, {"cell", nil, 3}} }, 109, 142, false},
	["miniSceneInsertCamera"]={"block", "blocks/block_yellow_2.png", { {{"text", words[538]}}, {{"text", words[529]..":"}, {"cell", nil, 3}} }, 109, 142, false},
	["miniSceneRemoveCamera"]={"block", "blocks/block_yellow_2.png", { {{"text", words[539]}}, {{"text", words[529]..":"}, {"cell", nil, 3}} }, 109, 142, false},
	["miniSceneInsert"]={"block", "blocks/block_yellow_2.png", { {{"text", words[540]}}, {{"text", words[529]..":"}, {"cell", nil, 3}} }, 109, 142, false},
	["setPositionMiniScene"]={"block", "blocks/block_yellow_3.png", { {{"text", words[541]}}, {{"text", words[529]..":"}, {"cell", nil, 3}}, {{"text", words[59]..":"}, {"cell", nil, 3}, {"text",words[60]..":"}, {"cell", nil, 1.5}} }, 109, 188, false},
	["editPositionMiniScene"]={"block", "blocks/block_yellow_3.png", { {{"text", words[542]}}, {{"text", words[529]..":"}, {"cell", nil, 3}}, {{"text", words[206]..":"}, {"cell", nil, 3}, {"text",words[420]..":"}, {"cell", nil, 1.5}} }, 109, 188, false},
	["setSizeMiniScene"]={"block", "blocks/block_yellow_3.png", { {{"text", words[543]}}, {{"text", words[529]..":"}, {"cell", nil, 3}}, {{"text", words[337]..":"}, {"cell", nil, 1.5},{"text","%"}} }, 109, 188, false},
	["editSizeMiniScene"]={"block", "blocks/block_yellow_3.png", { {{"text", words[544]}}, {{"text", words[529]..":"}, {"cell", nil, 3}}, {{"text", words[337]..":"}, {"cell", nil, 1.5},{"text","%"}} }, 109, 188, false},
	["setRotationMiniScene"]={"block", "blocks/block_yellow_3.png", { {{"text", words[545]}}, {{"text", words[529]..":"}, {"cell", nil, 3}}, {{"text", words[338]..":"}, {"cell", nil, 1.5},{"text","°"}} }, 109, 188, false},
	["editRotationMiniScene"]={"block", "blocks/block_yellow_3.png", { {{"text", words[546]}}, {{"text", words[529]..":"}, {"cell", nil, 3}}, {{"text", words[338]..":"}, {"cell", nil, 1.5},{"text","°"}} }, 109, 188, false},
	["setAlphaMiniScene"]={"block", "blocks/block_yellow_3.png", { {{"text", words[547]}}, {{"text", words[529]..":"}, {"cell", nil, 3}}, {{"text", words[328]..":"}, {"cell", nil, 1.5},{"text","%"}} }, 109, 188, false},
	["editAlphaMiniScene"]={"block", "blocks/block_yellow_3.png", { {{"text", words[548]}}, {{"text", words[529]..":"}, {"cell", nil, 3}}, {{"text", words[328]..":"}, {"cell", nil, 1.5},{"text","%"}} }, 109, 188, false},
	["setLayer"]={"block", "blocks/block_blue_1.png", { {{"text", words[551]}, {"cell", nil, 1.5}} }, 109, 88, false},
	["setAnchor"]={"block", "blocks/block_green_2.png", { {{"text", words[552]..":"}, {"cell", nil, 2}, {"text", "%"}},{{"text",words[420]..":"}, {"cell", nil, 2},{"text", "%"}} }, 109, 142, false},
	["createJoystick"]={"block", "blocks/block_pink_4.png", { {{"text", words[575]..":"}, {"cell", nil, 2}}, {{"text", words[576]..":"}}, {{"images"}}, {{"text", words[577]..":"}}, {{"images"}}, {{"text", words[578]}}, {{"variables"}}, {{"text", words[579]}}, {{"variables"}}, {{"text", words[580]}}, {{"function"}} }, 109, 450, false},
	["setPositionJoystick"]={"block", "blocks/block_pink_3.png", {{{"text", words[604]}}, {{"text", words[583]..":"}, {"cell", nil, 1.4}}, {{"text", words[59]..":"}, {"cell", nil, 1.4}, {"text", words[60]..":"}, {"cell", nil, 1.4}}}, 109, 188, false},
	["setSizeJoystick"]={"block", "blocks/block_pink_2.png", {{{"text", words[584]}}, {{"text", words[583]..":"}, {"cell", nil, 2}, {"text", words[207]..":"}, {"cell", nil, 2}}}, 109, 142, false},
	["setSizeJoystick1"]={"block", "blocks/block_pink_2.png", {{{"text", words[585]}}, {{"text", words[583]..":"}, {"cell", nil, 1.5}, {"text", words[207]..":"}, {"cell", nil, 1.5}}}, 109, 142, false},
	["setSizeJoystick2"]={"block", "blocks/block_pink_2.png", {{{"text", words[586]}}, {{"text", words[583]..":"}, {"cell", nil, 1.5}, {"text", words[207]..":"}, {"cell", nil, 1.5}}}, 109, 142, false},
	["cameraInsertJoystick"]={"block", "blocks/block_pink_2.png", {{{"text", words[603]}}, {{"text", words[583]..":"}, {"cell", nil, 1.5}}}, 109, 142, false},
	["cameraRemoveJoystick"]={"block", "blocks/block_pink_2.png", {{{"text", words[602]}}, {{"text", words[583]..":"}, {"cell", nil, 1.5}}}, 109, 142, false},
	["newWebView"]={"block", "blocks/block_pink_3_5.png", {{{"text", words[588]}},{{"text", words[583]..":"}, {"cell", nil, 1.5}, {"text",words[590]..":"}, {"cell", nil, 1.5}}, {{"text", words[59]..":"}, {"cell", nil, 1.5}, {"text", words[60]..":"}, {'cell', nil, 1.5}}, {{"text", words[490]..":"}, {"cell", nil, 1.5}, {"text", words[491]..":"}, {'cell', nil, 1.5}}}, 109, 250, false},
	["setWebViewX"]={"block", "blocks/block_pink_2.png", {{{"text", words[591]}}, {{"text", words[583]..":"}, {"cell", nil, 1.5}, {"text", words[59]..":"}, {"cell", nil, 1.5}}}, 109, 142, false},
	["setWebViewY"]={"block", "blocks/block_pink_2.png", {{{"text", words[592]}}, {{"text", words[583]..":"}, {"cell", nil, 1.5}, {"text", words[60]..":"}, {"cell", nil, 1.5}}}, 109, 142, false},
	["insertWebInMiniScene"]={"block", "blocks/block_yellow_3.png", {{{"text", words[593]}}, {{"text", words[594]..":"}, {"cell", nil, 4}}, {{"text", words[529]..":"}, {"cell", nil, 3}}}, 109, 188, false},
	["setWebViewWidth"]={"block", "blocks/block_pink_2.png", {{{"text", words[595]}}, {{"text", words[583]..":"}, {"cell", nil, 1.5}, {"text", words[490]..":"}, {"cell", nil, 1.5}}}, 109, 142, false},
	["setWebViewHeight"]={"block", "blocks/block_pink_2.png", {{{"text", words[596]}}, {{"text", words[583]..":"}, {"cell", nil, 1.5}, {"text", words[491]..":"}, {"cell", nil, 1.5}}}, 109, 142, false},
	["setLinkWebView"]={"block", "blocks/block_pink_2.png", {{{"text", words[597]}}, {{"text", words[583]..":"}, {"cell", nil, 1.5}, {"text", words[490]..":"}, {"cell", nil, 1.5}}}, 109, 142, false},
	["backWebView"]={"block", "blocks/block_pink_2.png", {{{"text", words[598]}}, {{"text", words[583]..":"}, {"cell", nil, 1.5}}}, 109, 142, false},
	["forwardWebView"]={"block", "blocks/block_pink_2.png", {{{"text", words[599]}}, {{"text", words[583]..":"}, {"cell", nil, 1.5}}}, 109, 142, false},
	["stopWebView"]={"block", "blocks/block_pink_2.png", {{{"text", words[600]}}, {{"text", words[583]..":"}, {"cell", nil, 1.5}}}, 109, 142, false},
	["reloadWebView"]={"block", "blocks/block_pink_2.png", {{{"text", words[604]}}, {{"text", words[583]..":"}, {"cell", nil, 1.5}}}, 109, 142, false},
}



additionallyBlocks = {
	["cycleForever"]={ {"endCycleForever",{},"on"} },
    ["ifElse (2)"]={ {"else",{},"on"}, {"endIf",{},"on"} },
    ["if (2)"]={ {"endIf",{},"on"} },
    ["repeat"]={ {"endRepeat",{},"on"} },
    ["repeatIsTrue"]={ {"endRepeat",{},"on"} },
    ["for"]={ {"endFor",{},"on"} },
    ["foreach"]={ {"endForeach",{},"on"} },
    ["timer"]={ {"endTimer",{},"on"} },
    ["waitIfTrue"]={ {"endWait",{},"on"} }
}