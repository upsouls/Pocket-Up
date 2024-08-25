
local lang = class()

function lang:getTranslation(lang)
	return require('app.data.strings.' .. lang)
end

return lang