function startWarGame(rounds)
    if rounds == 0 then
        if #CACHE_WARGAMEPLAYERS < WarMaps_Configurations.Event_MinPlayers then
            for _, players in ipairs(CACHE_WARGAMEPLAYERS) do
                Player(players):teleportTo(Player(players):getTown():getTemplePosition())
            end
            broadcastMessage("[Ulta Event]: Not enough players to ultra event! Minimum: ".. WarMaps_Configurations.Event_MinPlayers.." players.")
        else
            for _, players in ipairs(CACHE_WARGAMEPLAYERS) do
                Player(players):setStorageValue(WarMaps_Configurations.Ammo_Configurations.Ammo_AmmoBuy, 1)
                Player(players):setStorageValue(WarMaps_Configurations.Ammo_Configurations.Ammo_PointSkill, WarMaps_Configurations.Ammo_Configurations.Ammo_Start)
                Player(players):teleportTo(CACHE_WARGAMEAREAPOSITIONS[math.random(1, #CACHE_WARGAMEAREAPOSITIONS)])
            end
            broadcastMessage("[Ulta Event]: event portal closed and event started!.")
            addEvent(Event_endWarGame, WarMaps_Configurations.Event_Duration * 60 * 1000)
        end
 
        --Item(getTileItemById(WarMaps_Configurations.Area_Configurations.Position_EventTeleport, 1387).uid):remove(1)
        Item(getTileItemById(WarMaps_Configurations.Area_Configurations.Position_ExitWaitRoom, 1387).uid):remove(1)
		local WaitRoomStart = Game.createItem(1387, 1, WarMaps_Configurations.Area_Configurations.Position_WaitRoomStart)
		WaitRoomStart:setActionId(10105)
        return true
    end
 
    if #CACHE_WARGAMEPLAYERS < WarMaps_Configurations.Event_MinPlayers then
        broadcastMessage("[Ulta Event]: will be closed in ".. rounds .. " minutes and " .. WarMaps_Configurations.Event_MinPlayers - #CACHE_WARGAMEPLAYERS .." players for start.")
    else
        broadcastMessage("[Ulta Event]: was opened and will be closed in ".. rounds .. " minutes.")
    end
    return addEvent(startWarGame, 60 * 1000, rounds - 1)
end
 
function onTime(interval)
    if not WarMaps_Configurations.Event_Days[os.date("%w") + 1] then
        return true
    end
 
    CACHE_WARGAMEPLAYERS = {}
 
    local EventTeleport = Game.createItem(1387, 1, WarMaps_Configurations.Area_Configurations.Position_EventTeleport)
    EventTeleport:setActionId(10103)
 
    local ExitWaitRoom = Game.createItem(1387, 1, WarMaps_Configurations.Area_Configurations.Position_ExitWaitRoom)
    ExitWaitRoom:setActionId(10104)
 
    broadcastMessage("[Ulta Event]: was opened, entrance through Temple of Thais!")
    addEvent(startWarGame, 60 * 1000, WarMaps_Configurations.Event_WaitGame)
    return true
end