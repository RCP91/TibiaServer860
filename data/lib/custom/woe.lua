woe = {
    eventName = "[WOE]",
    timeDelay = 1, -- minutes before event starts
    bcMsg = " is starting in ",
    doors = {
        {name = "Castle Gate", id = 6257, pos = {x = 1021, y = 1028, z = 7} },
        {name = "Castle Gate", id = 6257, pos = {x = 1022, y = 1028, z = 7} }
    },
    actionid = 33542, -- for the doors
    crystal = {id = 9784, name="Emperium", pos = {x = 1022, y = 1020, z = 7} },
    castle = {x = 1012, y = 1027, z = 7}, -- just has to be one of the housetiles of the castle
    days = {
        -- to enable a day for the globalevent do ["Weekday"] = time
        -- for example: ["Monday"] = 18:00,
    },

    queueEvent = function(x)
        x = x - 1
        if x > 0 then
            broadcastMessage(woe.eventName..woe.bcMsg..x..(x > 1 and "minutes!" or "minute!"), MESSAGE_EVENT_ADVANCE)
            addEvent(woe.queueEvent, x * 60 * 1000, x)
        else
            woe.startEvent()
        end
    end,

    startEvent = function()
        for k,v in pairs(woe.doors) do
            local item = Tile(v.pos):getItemById(v.id)
            if item ~= nil then
                item:remove()
                Game.createMonster(v.name, v.pos, false, true)
            else
                print("WOE GATE POSITION INVALID OR MISSING [x:"..v.pos.x.." | y:"..v.pos.y.." | z:"..v.pos.z.."]")
            end
        end
        local c = woe.crystal
        local item = Tile(c.pos):getItemById(c.id)
        if item ~= nil then
            item:remove()
            Game.createMonster(c.name, c.pos, false, true)
        else
            print("WOE CRYSTAL POSITION INVALID OR MISSING [x:"..c.pos.x.." | y:"..c.pos.y.." | z:"..c.pos.z.."]")
        end
    end,

}