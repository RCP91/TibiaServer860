function startGame(rounds)
    if rounds == 0 then
        if #CACHE_GAMEPLAYERS < SnowBall_Configurations.Event_MinPlayers then
            for _, players in ipairs(CACHE_GAMEPLAYERS) do
                Player(players):teleportTo(Player(players):getTown():getTemplePosition())
            end
            broadcastMessage("[Snowball Event]: Not enough players to snowball event! Minimum: ".. SnowBall_Configurations.Event_MinPlayers.." players.")
        else
            for _, players in ipairs(CACHE_GAMEPLAYERS) do
                Player(players):setStorageValue(SnowBall_Configurations.Ammo_Configurations.Ammo_AmmoBuy, 0)
                Player(players):setStorageValue(SnowBall_Configurations.Ammo_Configurations.Ammo_PointSkill, SnowBall_Configurations.Ammo_Configurations.Ammo_Start)
                Player(players):teleportTo(CACHE_GAMEAREAPOSITIONS[math.random(1, #CACHE_GAMEAREAPOSITIONS)])
            end
            broadcastMessage("[Snowball Event]: event portal closed and event started!.")
            addEvent(Event_endGame, SnowBall_Configurations.Event_Duration * 60 * 1000)
        end
 
        Item(getTileItemById(SnowBall_Configurations.Area_Configurations.Position_EventTeleport, 25417).uid):remove(1)
        Item(getTileItemById(SnowBall_Configurations.Area_Configurations.Position_ExitWaitRoom, 25417).uid):remove(1)
        return true
    end
 
    if #CACHE_GAMEPLAYERS < SnowBall_Configurations.Event_MinPlayers then
        broadcastMessage("[Snowball Event]: will be closed in ".. rounds .. " minutes and " .. SnowBall_Configurations.Event_MinPlayers - #CACHE_GAMEPLAYERS .." players for start.")
    else
        broadcastMessage("[Snowball Event]: was opened and will be closed in ".. rounds .. " minutes.")
    end
    return addEvent(startGame, 60 * 1000, rounds - 1)
end
 
function onTime(interval)
    if not SnowBall_Configurations.Event_Days[os.date("%w") + 1] then
        return true
    end
 
    CACHE_GAMEPLAYERS = {}
 
    local EventTeleport = Game.createItem(25417, 1, SnowBall_Configurations.Area_Configurations.Position_EventTeleport)
    EventTeleport:setActionId(10101)
 
    local ExitWaitRoom = Game.createItem(25417, 1, SnowBall_Configurations.Area_Configurations.Position_ExitWaitRoom)
    ExitWaitRoom:setActionId(10102)
 
    broadcastMessage("[Snowball Event]: was opened, entrance through Temple of Thais!")
    addEvent(startGame, 60 * 1000, SnowBall_Configurations.Event_WaitGame)
    return true
end