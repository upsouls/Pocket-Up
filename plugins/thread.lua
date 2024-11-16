local m = {}

local timer = require('timer')
local running = {}

m.cancelAll = function ()
    for index, value in ipairs(running) do
        pcall(function ()
            timer.cancel(value)
        end)
    end
    running = {}
end

m.cancel = function (t)
    pcall(function ()
        timer.cancel(t)
        t = nil
    end)
end

m.start = function (p)
    local listener = function ()
        coroutine.resume(p)
    end
    local t = timer.performWithDelay(0, listener, 0)
    table.insert(running, t)
    return listener, t
end

return m