local m = {}

local timer = require('timer')

m.cancelAll = function ()
    timer.cancelAll()
end

m.cancel = function (t)
    timer.cancel(t)
    t = nil
end

m.start = function (p)
    local listener = function ()
        coroutine.resume(p)
    end
    local t = timer.performWithDelay(0, listener, 0)
    return listener, t
end

return m