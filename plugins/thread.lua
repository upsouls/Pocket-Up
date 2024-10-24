local m = {}

local timer = require('timer')
m.start = function (p)
    local listener = function ()
        coroutine.resume(p)
    end
    local t = timer.performWithDelay(1000/60, listener, 0)
    return listener, t
end

return m