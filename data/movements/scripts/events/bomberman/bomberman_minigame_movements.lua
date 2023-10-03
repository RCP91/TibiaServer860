function onStepIn(creature, item, position, fromPosition)
    local cache = BOMBERMAN_MINIGAME.player_cache[creature:getId()]
    
    if cache then
        if BOMBERMAN_MINIGAME.speed_up_item.itemid == item:getId() then
            creature:changeSpeed(BOMBERMAN_MINIGAME.speed_up_item.up)
        elseif BOMBERMAN_MINIGAME.range_up_item.itemid == item:getId() then
            cache.range = cache.range+BOMBERMAN_MINIGAME.range_up_item.up
        else
            cache.bomb = cache.bomb+BOMBERMAN_MINIGAME.bomb_up_item.up
        end
        item:remove(1)
        creature:sendTextMessage(BOMBERMAN_MINIGAME.messages.movement_powerup.type, BOMBERMAN_MINIGAME.messages.movement_powerup.msg)
        creature:sendChannelMessage("", string.format(BOMBERMAN_MINIGAME.messages.channel_powerup.msg, creature:getName()), BOMBERMAN_MINIGAME.messages.channel_powerup.type, BOMBERMAN_MINIGAME.channelId)
    end
    
    return true
end