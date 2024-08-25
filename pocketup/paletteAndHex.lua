function isCorrectHex(value)
	if(string.len(value)==7) then
	value = string.gsub(value, "#","")
		if (string.len(value)==6) then
			local tableSymbols = {0,1,2,3,4,5,6,7,8,9,"E","A","D","F","C","B"}
			for i=1, #tableSymbols do
				value = string.gsub(value, tableSymbols[i], "")
			end
			if (string.len(value)==0) then
				return(true)
			else
				return(false)
			end
		else
			return(false)
		end
	else
		return(false)
	end
end

display.newPickerColor = function(onComplete)

local group = display.newGroup()

	local sdvig = (500/6+50)/2

	local rectYourColor = display.newRect(-sdvig, 0, 500, 500)
	rectYourColor:setFillColor(1,0,0)
	group:insert(rectYourColor)

	rectYourColor.aim = display.newRoundedRect(rectYourColor.x+rectYourColor.width/2, rectYourColor.y-rectYourColor.height/2, 50, 50, 25)
	rectYourColor.aim:setFillColor(0,0,0,0)
	rectYourColor.aim.strokeWidth=5
	group:insert(rectYourColor.aim)

	local function touchColor(event)
		if (event.phase=="began" or event.phase=="began" and onComplete~=nil) then
			native.setKeyboardFocus( nil )
			display.getCurrentStage():setFocus( event.target, event.id )
		end
		if ((event.phase=="moved") and onComplete~=nil) then

			local function onColorSample( event )
				if (onComplete~=nil) then
					onComplete({event.r,event.g, event.b})
				end
			end
				 
			local width = event.target.width/2
			local height = event.target.height/2
			local x = group.x
			local y = group.y

				event.target.aim.x, event.target.aim.y = math.max(math.min((event.x-x)/group.xScale, width-1-sdvig), -width-sdvig+1), math.max(math.min((event.y-y)/group.yScale, height-1), -height+1)

				display.colorSample( event.target.aim.x*group.xScale+x, event.target.aim.y*group.yScale+y, onColorSample )

		elseif (onComplete~=nil) then
			display.getCurrentStage():setFocus( event.target, nil )
		end
		return(true)
	end
	rectYourColor:addEventListener("touch",touchColor)

	local rectWhite = display.newRect(-sdvig, 0, 500, 500)
	rectWhite.fill.effect = "filter.linearWipe"
	rectWhite.fill.effect.direction = { 1, 0 }
	rectWhite.fill.effect.smoothness = 1
	rectWhite.fill.effect.progress = 0.5

	group:insert(rectWhite)

	local rectBlack = display.newRect(-sdvig, 0, 500, 500)
	rectBlack:setFillColor(0,0,0)
	rectBlack.fill.effect = "filter.linearWipe"
	rectBlack.fill.effect.direction = { 0, -1 }
	rectBlack.fill.effect.smoothness = 1
	rectBlack.fill.effect.progress = 0.5

	group:insert(rectBlack)

	rectYourColor.aim:toFront()

	local tableColors = {{1,0,0},{1,0,1},{0,0,1},{0,1,1},{0,1,0},{1,1,0},{1,0,0}}
	local height = rectWhite.height/(#tableColors-1)

	local aimGradient = display.newRoundedRect(rectWhite.x+rectWhite.width/2+rectWhite.width/12+50, rectWhite.y-rectWhite.height/2, rectWhite.width/5, rectWhite.width/30,rectWhite.width/90)
	aimGradient:setFillColor(0,0,0,0)
	aimGradient.strokeWidth = 5

	local function touchGradientColor(event)
	if (event.phase=="began" and onComplete~=nil) then
		native.setKeyboardFocus( nil )
		display.getCurrentStage():setFocus( event.target, event.id )
	end

	if ((event.phase=="began" or event.phase=="moved") and onComplete~=nil) then

		local x = group.x
		local y = group.y
		local height = rectWhite.height/2
		aimGradient.y = math.max(math.min((event.y-y)/group.yScale,height-1),-height+1)

		--
		local function onColorSample( event )
		rectYourColor:setFillColor(event.r, event.g, event.b)
		touchColor({["target"]=rectYourColor, ["x"]=rectYourColor.aim.x*group.xScale+x, ["y"]=rectYourColor.aim.y*group.yScale+y, ["phase"]="moved"})
		end
		display.colorSample( x+aimGradient.x*group.xScale, y+aimGradient.y*group.yScale, onColorSample )
		--

	elseif (onComplete~=nil) then
		display.getCurrentStage():setFocus( event.target, nil )
	end
	return(true)
	end

	for i=1, #tableColors-1 do
		local gradient = {
		type = "gradient",
		color1 = {tableColors[i][1], tableColors[i][2], tableColors[i][3]},
		color2 = {tableColors[i+1][1],tableColors[i+1][2],tableColors[i+1][3]},
		direction = "down"
		}
		local rectGradient = display.newRect(rectWhite.x+rectWhite.width/2+50, rectWhite.y-rectWhite.height/2+height*(i-1), rectWhite.width/6, height )
		rectGradient.anchorX=0
		rectGradient.anchorY=0
		rectGradient:setFillColor(gradient)
		rectGradient:addEventListener("touch",touchGradientColor)
		group:insert(rectGradient)
	end

	group:insert(aimGradient)

	return(group)
end




function rgbToHex(rgb)
local hexadecimal = '#'
for key, value in pairs(rgb) do
local hex = ''
while(value > 0)do
local index = math.fmod(value, 16) + 1
value = math.floor(value / 16)
hex = string.sub('0123456789ABCDEF', index, index) .. hex
end
if(string.len(hex) == 0)then
hex = '00'
elseif(string.len(hex) == 1)then
hex = '0' .. hex
end
hexadecimal = hexadecimal .. hex
end
return hexadecimal
end



function hexToRgb(hexCode)
if (isCorrectHex(hexCode)) then
hexCode = string.upper(hexCode)
assert((#hexCode == 7) or (#hexCode == 9), "The hex value must be passed in the form of #RRGGBB or #AARRGGBB" )
local hexCode = hexCode:gsub("#","")
if (#hexCode == 6) then
hexCode = "FF"..hexCode
end
local a, r, g, b = tonumber("0x"..hexCode:sub(1,2))/255, tonumber("0x"..hexCode:sub(3,4))/255, tonumber("0x"..hexCode:sub(5,6))/255, tonumber("0x"..hexCode:sub(7,8))/255
return {r, g, b, a}
else
return {0,0,0,1}
end
end

function hex2rgb(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end