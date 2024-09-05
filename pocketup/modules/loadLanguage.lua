local file = io.open(system.pathForFile("pocketup/languages/".."ru"..".json"), "r")
local language = json.decode(file:read("*a"))
io.close(file)
return(language)