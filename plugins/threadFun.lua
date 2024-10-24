local m = {}

m.wait = function(time)
    local startTime = system.getTimer()
    while (system.getTimer() - startTime) < time do
        coroutine.yield()
    end
end

return m