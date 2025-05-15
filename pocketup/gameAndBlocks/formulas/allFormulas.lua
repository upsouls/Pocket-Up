--[[ документация как создать формулу
	1. в allCategoriesAndFormulas добавьте формулу по пути: категория > мини-категория > формула.
	пример:
		function = {
			{"имя мини-категории", { {"имя формулы"}, {"function","("}, {"number",100}, {"function",")"} } }
		}

	2. в nameFormulas добавьте перевод формуле(чтобы на разных языках были свои слова)
	
	3. в calculateRedactorFormulas добавьте формуле то в какой код он конвертируется при вычислении в редакторе выражений.
	этот пункт выпонять не обязательно. если вы не укажете во что сконвертировать, то оно поумолчанию сконвертируется в '0'

	4. в calculateGameFormulas добавьте формуле то в какой код он конвертируется при вычислении в запущенной игре
]]


allCategotiesAndFormulas = {
	functions= {
		{app.words[292],{ {{"function","sinus"},{"function","("},{"number",9},
		{"number",0},{"function",")"}}, {{"function","cosine"},
		{"function","("},{"number",3},{"number",6},{"number",0},
		{"function",")"}}, {{"function","tangent"},{"function","("},
		{"number",4},{"number",5},{"function",")"}}, 
		{{"function","naturalLogarithm"},{"function","("},{"number",2},
		{"number","."},{"number",7},{"number",1},{"number",8},{"number",2},
		{"number",8},{"number",1},{"number",8},{"number",2},{"number",8},
		{"number",4},{"number",5},{"number",9},{"function",")"}}, 
		{{"function","decimalLogarithm"},{"function","("},{"number",1},
		{"number",0},{"function",")"}}, {{"function","pi"}}, 
		{{"function","root"},{"function","("},{"number",4},{"function",")"}}, 
		{{"function","random"},{"function","("},{"number",1},{"function",","},
		{"number",6},{"function",")"}}, {{"function","absoluteValue"},
		{"function","("},{"number",1},{"function",")"}}, 
		{{"function","round"},{"function","("},{"number",1},{"number","."},
		{"number",6},{"function",")"}}, {{"function","modulo"},
		{"function","("},{"number",3},{"function",","},{"number",2},
		{"function",")"}}, {{"function","arcsine"},{"function","("},
		{"number",0},{"number","."},{"number",5},{"function",")"}}, 
		{{"function","arccosine"},{"function","("},{"number",0},
		{"function",")"}}, {{"function","arctangent"},{"function","("},
		{"number",1},{"function",")"}}, {{"function","arctangent2"},
		{"function","("},{"function","-"},{"number",1},{"function",","},
		{"number",0},{"function",")"}}, {{"function","exponent"},
		{"function","("},{"number",1},{"function",")"}}, 
		{{"function","degree"},{"function","("},{"number",2},
		{"function",","},{"number",3},{"function",")"}}, 
		{{"function","roundDown"},{"function","("},{"number",9},
		{"number","."},{"number",0},{"function",")"}}, 
		{{"function","roundUp"},{"function","("},{"number",0},{"number","."},
		{"number",3},{"function",")"}}, {{"function","maximum"},
		{"function","("},{"number",5},{"function",","},{"number",4},
		{"function",")"}}, {{"function","minimum"},{"function","("},
		{"number",7},{"function",","},{"number",2},{"function",")"}},
		{{"function","ternaryExpression"},{"function","("},
		{"function","false"},{"function",","},{"number",2},{"function",","},
		{"number",3},{"function",")"}},
		{{"function","perlinNoise"},{"function","("},{"number",0},{"function",","},{"number",0},{"function",","},{"number",0},{"function",")"}}
	}},
	{app.words[315],{ 
		{{"function","length"},{"function","("},{"text","hello world"},{"function",")"}},
		{{"function","characterFromText"},{"function","("},{"number",1},{"function",","},{"text","hello world"},{"function",")"}}, 
		{{"function","connect"},{"function","("},{"text","hello"},{"function",","},{"text"," world"},{"function",")"}}, 
		{{"function","connect2"},{"function","("},{"text","hello"},{"function",","},{"text"," world"},{"function",","},{"text","!"},{"function",")"}}, 
		{{"function","regularExpression"},{"function","("},{"text"," an? ([^ .]+)"},{"function",","},{"text","I am a panda."},{"function",")"}} }}
	},
	properties={
		{app.words[327],{ --[[]]
			{{"function","transparency"}}, {{"function","brightness"}}, 
			{{"function","color"}},{{"function","numberImage"}},
			{{"function","nameImage"}},{{"function","countImages"}},
			{{"function", "myName"}} }},
		{app.words[334], { 
			{{"function","positionX"}},{{"function","positionY"}},
			{{"function","size"}},{{"function","direction"}},{{"function","directionView"}},
			{{"function","touchesObject"}},
			{{"function","touchesObject2"}},
			{{"function","touchesFinger"}},{{"function","speedX"}},{{"function","speedY"}},
			{{"function","angularVelocity"}} }}
		},
	device={
		{app.words[347],{
			{{"function","displayWidth"}},{{"function","displayHeight"}},{{"function","displayActualWidth"}},{{"function","displayActualHeight"}},
		{{"function","displayPositionColor"},{"function","("},{"number",1},{"number",0},{"number",0},{"function",","},{"number",2},{"number",0},{"number",0},{"function",")"}}, 
		{{"function","language"}} }},
		{app.words[350],{ {{"function","touchDisplayX"}},{{"function","touchDisplayY"}},
		{{"function","touchDisplay"}},{{"function","touchDisplayXId"},{"function","("},{"number",1},{"function",")"}},
		{{"function","touchDisplayYId"},{"function","("},{"number",1},{"function",")"}},
		{{"function","touchDisplayId"},{"function","("},{"number",1},{"function",")"}},
		{{"function","countTouchDisplay"}},{{"function","countTouch"}},
		{{"function","positionCameraX"}},{{"function","positionCameraY"}},
		{{"function","mouseX"}},
		{{"function","mouseY"}},
		
		--[[{{"function","indexThisTouch"},{"function","("},{"number",1},{"function",")"}}]] }},
		{app.words[360], { {{"function","timer"}},{{"function","year"}},
		{{"function","month"}},{{"function","day"}},{{"function","dayWeek"}},
		{{"function","hour"}},{{"function","minute"}},{{"function","second"}},
		 }},
	},
	logics={
		{app.words[369],{ {{"function","and"}},{{"function","or"}},
		{{"function","not"}},{{"function","true"}},{{"function","false"}}, }},
		{app.words[375],{ {{"function","="}},{{"function","≠"}},{{"function","<"}},
		{{"function","≤"}},{{"function",">"}},{{"function","≥"}}, {{"function",","}} }},
	},
	data={}
}



nameFormulas = {
	["and"]=app.words[370],["or"]=app.words[371],["not"]=app.words[372],["true"]=app.words[373],
	["false"]=app.words[374],["-"]="-",["+"]="+",["÷"]="÷",["×"]="×",["("]="(",
	[")"]=")",["="]="=",["≠"]="≠",["<"]="<",["≤"]="≤",[">"]=">",["≥"]="≥",
		perlinNoise = app.words[675],
	[","]=",",sinus=app.words[293],cosine=app.words[294],tangent=app.words[295],naturalLogarithm=app.words[296]
	,decimalLogarithm=app.words[297],pi=app.words[298],root=app.words[299],random=app.words[300],
	absoluteValue=app.words[301],round=app.words[302],modulo=app.words[303],arcsine=app.words[304],
	arccosine=app.words[305],arctangent=app.words[306],arctangent2=app.words[307],
	exponent=app.words[308],degree=app.words[309],roundDown=app.words[310],roundUp=app.words[311],
	maximum=app.words[312],minimum=app.words[313],ternaryExpression=app.words[314],length=app.words[316]
	,characterFromText=app.words[317],connect=app.words[318],connect2=app.words[318],
	regularExpression=app.words[319],levelingArray=app.words[320],lengthArray=app.words[322],
	elementArray=app.words[323],containsArray=app.words[324],indexArray=app.words[325],
	transparency=app.words[328],brightness=app.words[329],color=app.words[330],numberImage=app.words[331]
	,nameImage=app.words[332],countImages=app.words[333], positionX=app.words[335],
	positionY=app.words[336],size=app.words[337],direction=app.words[338],directionView=app.words[339]
	,touchesObject=app.words[341],touchesFinger=app.words[343]
	,speedX=app.words[344],speedY=app.words[345],angularVelocity=app.words[346],displayPositionColor=app.words[348]
	,language=app.words[349],touchDisplayX=app.words[351],touchDisplayY=app.words[352],
	touchDisplay=app.words[353],touchDisplayXId=app.words[354],touchDisplayYId=app.words[355],
	touchDisplayId=app.words[356],countTouchDisplay=app.words[357],countTouch=app.words[358],
	indexThisTouch=app.words[359],timer=app.words[361],year=app.words[362],month=app.words[363],
	day=app.words[364],dayWeek=app.words[365],hour=app.words[366],minute=app.words[367],second=app.words[368],
	displayWidth=app.words[477],displayHeight=app.words[478],displayActualWidth=app.words[479],displayActualHeight=app.words[480],
	array2json=app.words[482],json2array=app.words[483],positionCameraX=app.words[484],positionCameraY=app.words[485],
	touchesObject2=app.words[617],myName=app.words[620],mouseX=app.words[625],mouseY=app.words[626]
}




local lang = system.getPreference( "locale", "language" )
allFunsRedRorms = {}
allFunsRedRorms.random = function(v, v2) if (type(v)=="number" and type(v2)=="number") then if (v<v2) then return(math.random(v, v2)) else return(v) end end end
allFunsRedRorms.utf8 = plugins.utf8 allFunsRedRorms.math2 = math
allFunsRedRorms.sin = function(value) return(math.sin(math.rad(value))) end
allFunsRedRorms.cos = function(value) return(math.cos(math.rad(value))) end
allFunsRedRorms.tan = function(value) return(math.tan(math.rad(value))) end
allFunsRedRorms.asin = function(value) return(math.deg(math.asin(value))) end
allFunsRedRorms.acos = function(value) return(math.deg(math.acos(value))) end
allFunsRedRorms.atan = function(value) return(math.deg(math.atan(value))) end
allFunsRedRorms.atan2 = function(value, value2) return(math.deg(math.atan2(value, value2))) end
allFunsRedRorms.getHEX = function() return("#FFFFFF") end
allFunsRedRorms.getJson = function() return("{}") end
allFunsRedRorms.getNil = function() return("") end
allFunsRedRorms.getFalse = function() return(false) end 
allFunsRedRorms.get0 = function() return(0) end
allFunsRedRorms.roundUp = function(value) return(math.floor(value)+1) end
allFunsRedRorms.round = function(value) local flValue = math.floor(value) local remainder = value-flValue flValue = flValue+(remainder>=0.5 and 1 or 0) return(flValue) end
allFunsRedRorms.connect = function(value,value2,value3) local answerValue = value..value2..(value3==nil and "" or value3) return(answerValue) end
allFunsRedRorms.ternaryExpression = function(condition, answer1, answer2) return(condition and answer1 or answer2) end
allFunsRedRorms.regularExpression = function(regular, expression) return(string.match(expression, regular)) end
allFunsRedRorms.characterFromText = function(pos, value) return(plugins.utf8.sub(value,pos,pos)) end
allFunsRedRorms.perlinNoise = function(x, y, seed) return plugins.perlin.new(x, y, seed) end

calculateRedactorFormulas = {
	["+"]="+",["-"]="-",["÷"]="/",["×"]="*",["("]="(",[")"]=")",
	["<"]="<",[">"]=">",["≤"]="<=",["≥"]=">=",["="]=" == ",["≠"]="~=",
	[","]=",",["true"]="true",["false"]="false",["not"]="not",
	["and"]="and",["or"]="or",sinus="allFunsRedRorms.sin",cosine="allFunsRedRorms.cos",
	tangent="allFunsRedRorms.tan",naturalLogarithm="math.log",
	decimalLogarithm="math.log10",pi="math.pi",root="math.sqrt",
	random="allFunsRedRorms.random",absoluteValue="math.abs",round="math.round",
	modulo="math.fmod",arcsine="allFunsRedRorms.asin",arccosine="allFunsRedRorms.acos",
	arctangent="allFunsRedRorms.atan", arctangent2="allFunsRedRorms.atan2",exponent="math.exp",
	degree="math.pow",roundDown="math.floor",roundUp="allFunsRedRorms.roundUp",
	maximum="math.max",minimum="math.min",ternaryExpression="allFunsRedRorms.ternaryExpression"
	,characterFromText="allFunsRedRorms.characterFromText",length="plugins.utf8.len",
	connect="allFunsRedRorms.connect",connect2="allFunsRedRorms.connect",regularExpression="allFunsRedRorms.regularExpression",
	lengthArray="#",elementArray="allFunsRedRorms.get0",containsArray="allFunsRedRorms.getFalse",
	indexArray="allFunsRedRorms.get0",levelingArray="allFunsRedRorms.getNil",brightness='(100)',
	numberImage='(1)',size='(100)',direction='(90)',directionView='(90)',
	touchesObject="false",touchesEdge="false",touchesFinger="false",
	displayPositionColor="allFunsRedRorms.getHEX",language=" '"..lang.."-"..string.upper(lang).."' ",
	touchDisplay="false",touchDisplayXId="allFunsRedRorms.get0",touchDisplayYId="allFunsRedRorms.get0",
	touchDisplayId="allFunsRedRorms.getFalse",
	displayWidth="(720)",displayHeight="(1280)",displayActualWidth="("..tostring(display.actualContentWidth)..")",
	displayActualHeight="("..tostring(display.actualContentHeight)..")",array2json="allFunsRedRorms.getJson",json2array="allFunsRedRorms.getNil",
	touchesObject2="false",myName='"'..app.words[444]..'"',mouseX="(0)",mouseY="(0)",
		perlinNoise = "allFunsRedRorms.perlinNoise"
}




calculateGameFormulas = {
    ["+"]="+",["-"]="-",["÷"]="/",["×"]="*",["("]="(",[")"]=")",
        ["<"]="<",[">"]=">",["≤"]="<=",["≥"]=">=",["="]=" == ",["≠"]="~=",
        [","]=",",["true"]="true",["false"]="false",["not"]="not",
        ["and"]="and",["or"]="or",sinus="pocketupFuns.sin",cosine="pocketupFuns.cos",
        tangent="pocketupFuns.tan",naturalLogarithm="math.log",
        decimalLogarithm="math.log10",pi="math.pi",root="math.sqrt",
        random="math.random",absoluteValue="math.abs",round="math.round",
        modulo="math.fmod",arcsine="pocketupFuns.asin",arccosine="pocketupFuns.acos",
        arctangent="pocketupFuns.atan", arctangent2="pocketupFuns.atan2",exponent="math.exp",
        degree="math.pow",roundDown="math.floor",roundUp="pocketupFuns.roundUp",
        maximum="math.max",minimum="math.min",ternaryExpression="pocketupFuns.ternaryExpression"
        ,characterFromText="pocketupFuns.characterFromText",length="plugins.utf8.len",
        connect="pocketupFuns.connect",connect2="pocketupFuns.connect",regularExpression="pocketupFuns.regularExpression",
        layer="(0)",language=" '"..lang.."-"..string.upper(lang).."' ",
        lengthArray="#",elementArray="pocketupFuns.getEllementArray",containsArray="pocketupFuns.containsElementArray",
        indexArray="pocketupFuns.getIndexElementArray",levelingArray="pocketupFuns.levelingArray",
        displayPositionColor="pocketupFuns.displayPositionColor",touchDisplayX="globalConstants.touchX",touchDisplayY="globalConstants.touchY",
        touchDisplay="globalConstants.isTouch",touchDisplayXId="globalConstants.getTouchXId",touchDisplayYId="globalConstants.getTouchYId",
        touchDisplayId="pocketupFuns.getIsTouchId",countTouchDisplay="globalConstants.touchId",countTouch="pocketupFuns.getCountTouch()",
        timer="os.time()",year="tonumber(os.date('%Y', os.time()))",month="tonumber(os.date('%m', os.time()))",
        dayWeek="tonumber(os.date('%w', os.time()))",day="tonumber(os.date('%d', os.time()))",hour="tonumber(os.date('%H', os.time()))",
        minute="tonumber(os.date('%M', os.time()))",second="tonumber(os.date('%S', os.time()))",
        json2array="pocketupFuns.jsonEncode", array2json="plugins.json.encode",positionCameraX="(cameraGroup.x)",
        positionCameraY="(-cameraGroup.x)",myName="(target.myName==nil and 0 or target.myName)",mouseX="mouseX",mouseY="mouseY", perlinNoise = "pocketupFuns.perlinNoise",
}