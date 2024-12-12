-- визуальная прогрузка формулы в блоке или редакторе выражений

--[[ отправляемы данные
event - plugins.json формула конкретного параметра в блоке
posCursor - позиция(number), на которой нужно отобразить курсор. необязательный параметр(при указании nil курсор в формуле не будет добавлен)
]]

-- получаемые данные - текст-формула(string)

function loadFormula(event, posCursor)

	local globalVariables = plugins.json.decode(funsP["получить сохранение"](app.idProject.."/variables"))
	local localVariables = plugins.json.decode(funsP["получить сохранение"](app.idObject.."/variables"))
	local allVariables = {}
	for i=1, #globalVariables do
		allVariables["globalVariable_"..globalVariables[i][1]] = globalVariables[i][2]
	end
	for i=1, #localVariables do
		allVariables["localVariable_"..localVariables[i][1]] = localVariables[i][2]
	end
	local globalArrays = plugins.json.decode(funsP["получить сохранение"](app.idProject.."/arrays"))
	local localArrays = plugins.json.decode(funsP["получить сохранение"](app.idObject.."/arrays"))
	local allArrays = {}
	for i=1, #globalArrays do
		allArrays["globalArray_"..globalArrays[i][1]] = globalArrays[i][2]
	end
	for i=1, #localArrays do
		allArrays["localArray_"..localArrays[i][1]] = localArrays[i][2]
	end

	local tableTrueSpace = {
		["-"]=true,
		["+"]=true,
		["÷"]=true,
		["×"]=true,
		["("]=true,
		[")"]=true,
		[""]=true,
	}

	local value = ""
	for i=1, #event do
		local typeFormula = event[i][1]
		local oldNameFormula = event[math.max(i-1,1)][2]
		local nameFormula = event[i][2]
		if (i>1 and nameFormula~="(" and ((typeFormula~="number" and not tableTrueSpace[nameFormula]) or (event[i-1][1]~="number" and not tableTrueSpace[oldNameFormula])) ) then
			value = value.."  "
		end

		if (posCursor==i) then
			value = value.."│"
		end

		if (typeFormula=="number") then
			value = value..event[i][2]
		elseif (typeFormula=="text") then
			value = value.."'"..event[i][2].."'"
		elseif (typeFormula=="localVariable" or typeFormula=="globalVariable") then
			local nameVar = allVariables[typeFormula.."_"..event[i][2]]
			value = value..'"'..(nameVar==nil and app.words[380] or nameVar)..'"'
		elseif (typeFormula=="localArray" or typeFormula=="globalArray") then
			local nameArr = allArrays[typeFormula.."_"..event[i][2]]
			value = value..'*'..(nameArr==nil and app.words[381] or nameArr)..'*'
		elseif (event[i][2]=="touchesObject2" and event[i][3]~=nil) then
			local tableObjects = plugins.json.decode(funsP["получить сохранение"](app.idScene.."/objects"))
			local idObject = event[i][3]
			local nameObject
			for i=1, #tableObjects do
				if (tableObjects[i][2]==idObject) then
					nameObject = tableObjects[i][1]
					break
				end
			end
			if (nameObject==nil) then
				nameObject = app.words[618]
			end
			value = value..nameFormulas[event[i][2]].."("..nameObject..")"
		else
			value = value..(nameFormulas[event[i][2]] or "error")
		end
	end
	if (posCursor==#event+1) then
		value = value.."│"
	end
	return(value)
end