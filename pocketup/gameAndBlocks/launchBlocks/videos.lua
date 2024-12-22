return {
	createVideo = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        local x = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."target.x = "..x
        return lua .. "\nend)"
    end,
}