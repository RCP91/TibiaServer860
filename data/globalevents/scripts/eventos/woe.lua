function onTime(interval)
    if os.date("%H:%M") == woe.days[os.date("%A")] then
        woe.queueEvent(woe.timeDelay+1)
    end
end