function onUse(player, item, fromPos, itemEx, toPos) 
    local players = {}
    local maps = {}
    local map = 0
    
    for k, v in pairs(BOMBERMAN_MINIGAME.player_cache) do
        if not isInArray(maps, v.map) then
            table.insert(maps, v.map)
        end
    end
    
    for i = 1, #BOMBERMAN_MINIGAME.maps do
        if not isInArray(maps, i) then
            map = i
            break
        end
    end
    
    if map == 0 then
        player:sendTextMessage(BOMBERMAN_MINIGAME.messages.press_lever_no_map.type, BOMBERMAN_MINIGAME.messages.press_lever_no_map.msg)
        return true
    elseif BOMBERMAN_MINIGAME.rebuilding_map then
        player:sendTextMessage(BOMBERMAN_MINIGAME.messages.press_lever_rebuilding_map.type, BOMBERMAN_MINIGAME.messages.press_lever_rebuilding_map.msg)
        return true
    else
        local mp = BOMBERMAN_MINIGAME.maps[map]
        for i = 1, #BOMBERMAN_MINIGAME.player_tiles do
            local creature = Tile(BOMBERMAN_MINIGAME.player_tiles[i]):getTopCreature()
            if creature and creature:isPlayer() then
                if creature:getMoney() >= BOMBERMAN_MINIGAME.moneyCost then
                    creature:removeMoney(BOMBERMAN_MINIGAME.moneyCost)
                    table.insert(players, creature)
                else
                    creature:sendTextMessage(BOMBERMAN_MINIGAME.messages.press_lever_no_money.type, string.format(BOMBERMAN_MINIGAME.messages.press_lever_no_money.msg, BOMBERMAN_MINIGAME.moneyCost))
                    player:sendTextMessage(BOMBERMAN_MINIGAME.messages.press_lever_cant_play.type, BOMBERMAN_MINIGAME.messages.press_lever_cant_play.msg)
                    return true
                end
            else
                player:sendTextMessage(BOMBERMAN_MINIGAME.messages.press_lever_no_players.type, BOMBERMAN_MINIGAME.messages.press_lever_no_players.msg)
                return true
            end
        end
    end
    
    for i = 1, #players do
        BOMBERMAN_MINIGAME.player_cache[players[i]:getId()] = {speed = players[i]:getBaseSpeed(), range = BOMBERMAN_MINIGAME.base_range, bomb = BOMBERMAN_MINIGAME.base_bomb, bombs = {}, kill = 0, death = false, ingame = true, map = map}
        players[i]:teleportTo(BOMBERMAN_MINIGAME.maps[map].players_positions[i])
        players[i]:changeSpeed(-players[i]:getSpeed())
        players[i]:changeSpeed(BOMBERMAN_MINIGAME.base_speed)
        players[i]:sendTextMessage(BOMBERMAN_MINIGAME.messages.press_lever_enter.type, BOMBERMAN_MINIGAME.messages.press_lever_enter.msg)
        players[i]:openChannel(BOMBERMAN_MINIGAME.channelId)
    end
    
    return true
end