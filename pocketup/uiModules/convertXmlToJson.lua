-- конвертер XML в JSON

function xmlToTable(event)

local function decodeXmlText(event)
	local symbols = {{"<","&lt;"},{">","&gt;"},{"&","&amp;"},{'"',"&quot;"},{"'","&apos;"}}
	for i=1, #symbols do
		event = plugins.utf8.gsub(event, symbols[i][2], symbols[i][1])
	end
	return(event)
end

local myJsonTable = {
{["tag"]="xml", ["attributes"]={} },
{} -- здесь будет весь xml
}
local iStart = 5
while (plugins.utf8.sub(event, iStart+1, iStart+2) ~= "?>") do
	local i = iStart+1
	local strSubAttribute = plugins.utf8.sub(event, i+1, i+1)
	while (strSubAttribute ~= "=" and strSubAttribute ~= " " and plugins.utf8.sub(event, i+1, i+2) ~= "?>") do
		i = i+1
		strSubAttribute = plugins.utf8.sub(event, i+1, i+1)
	end
	if (iStart+1 ~= i) then
		local nameAttribute = plugins.utf8.sub(event, iStart+2, i)
		local valueAttribute = ""
		if (strSubAttribute == "=") then
			iStart = i+2
			i = i+2
			while (plugins.utf8.sub(event, i+1, i+1)~='"' ) do
				i = i+1
			end
			valueAttribute = plugins.utf8.sub(event, iStart+1, i)
			iStart = i
		end
		myJsonTable[1].attributes[nameAttribute] = valueAttribute
	end
	iStart = i
end


local xmlToJson = nil

xmlToJson = function (event)
	local tableTags = {}
	local i = 1

	local lengthXmlData = plugins.utf8.len(event)
	while (i<lengthXmlData) do
		while (plugins.utf8.sub(event, i, i)=="\n" or plugins.utf8.sub(event, i, i)==" ") do
			i = i+1
		end -- игнор отступов и \n
		local iStartNameTag = i+1
		while (plugins.utf8.sub(event,i,i)~=">" and plugins.utf8.sub(event,i,i)~=" " and plugins.utf8.sub(event,i,i+1)~="/>") do
			i = i+1
		end -- узнать название тега
		local nameTag = plugins.utf8.sub(event, iStartNameTag, i-1)

		local funSearchEndTag = nil
		funSearchEndTag = function (attributes, isSearchEnd)


		local iStartValueText = i
		local iEndValueText = nil
		if (isSearchEnd) then
			local countNestings = 1
			local lenNameTag = plugins.utf8.len(nameTag)
			while (countNestings~=0) do
				if (plugins.utf8.sub(event, i, i+lenNameTag-1+2)=="<"..nameTag..">" or plugins.utf8.sub(event, i, i+lenNameTag-1+2)=="<"..nameTag.." ") then
					countNestings = countNestings+1
				elseif (plugins.utf8.sub(event, i, i+lenNameTag-1+3)=="</"..nameTag..">") then
					countNestings = countNestings-1
				end
				i = i+1
			end
			iEndValueText = i-1
			local subIEndVT = plugins.utf8.sub(event, iEndValueText, iEndValueText)
			while (subIEndVT==" " or subIEndVT=="\n" or subIEndVT=="<") do
				iEndValueText = iEndValueText-1
				subIEndVT = plugins.utf8.sub(event, iEndValueText, iEndValueText)
			end
			i = i+lenNameTag+2
		end

		tableTags[#tableTags+1] = {
		["tag"]=nameTag,
		["attributes"]=attributes,
		}
		if (isSearchEnd) then
			local valueGsub = plugins.utf8.sub(event, iStartValueText,iEndValueText )
			tableTags[#tableTags].value = (valueGsub~=plugins.utf8.gsub(valueGsub, "<","")) and xmlToJson(valueGsub) or decodeXmlText(valueGsub)
		end

	end

	local valueAttribute = nil
	if (plugins.utf8.sub(event,i,i)==">") then
		i = i+1
		funSearchEndTag(nil, true)
	elseif (plugins.utf8.sub(event,i,i+1)=="/>") then
		i = i+2
		funSearchEndTag(nil, false)
	else

		local tableAttributes = {}
		while (plugins.utf8.sub(event, i, i)~=">" and plugins.utf8.sub(event, i, i+1)~="/>") do
			while (plugins.utf8.sub(event, i, i)==" ") do
				i = i+1
			end
			local iStartNameAttribute = i 
			while (plugins.utf8.sub(event, i, i)~=" " and plugins.utf8.sub(event, i, i)~="=" and plugins.utf8.sub(event, i, i)~=">" and plugins.utf8.sub(event, i, i+1)~="/>") do
				i = i+1
			end
			local nameAttribute = plugins.utf8.sub(event, iStartNameAttribute, i-1)

			i=i+2
			iStartValueAttribute = i

			while (plugins.utf8.sub(event, i, i) ~= '"') do
				i = i+1
			end
			valueAttribute = plugins.utf8.sub(event, iStartValueAttribute, i-1)
			i=i+1
			tableAttributes[nameAttribute] = valueAttribute

		end
		if (plugins.utf8.sub(event, i, i) == ">") then
			i = i+1
			funSearchEndTag(tableAttributes, true)
		elseif (plugins.utf8.sub(event, i, i+1) == "/>") then
			i = i+2
			funSearchEndTag(tableAttributes, false)
		end

	end


end
return(tableTags)
end
---------------------------------------------------
myJsonTable[2] = xmlToJson(plugins.utf8.sub(event, iStart + 3, plugins.utf8.len(event)))

return(myJsonTable)
end