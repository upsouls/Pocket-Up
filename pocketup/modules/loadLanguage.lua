local file = io.open(system.pathForFile("pocketup/languages/".."ru"..".json"), "r")
local language = plugins.json.decode(file:read("*a"))
io.close(file)
return(language)