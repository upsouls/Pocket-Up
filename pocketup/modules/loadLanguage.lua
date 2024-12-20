--require('pocketup.uiModules.bannerVariants')
local language = funsP['получить сохранение']('selectLanguage')
if language == '[]' then
    language = 'Русский'
end
local path = {
    English = 'eng',
    ['Русский'] = 'ru'
}
print(language)
local file = io.open(system.pathForFile("pocketup/languages/"..path[language]..".json"), "r")
local language = plugins.json.decode(file:read("*a"))
print(#language)
io.close(file)
return(language)