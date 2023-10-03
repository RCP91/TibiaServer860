function onSay(player, words, param)
    local cache = BOMBERMAN_MINIGAME.player_cache[player:getId()]
    
    if not cache then
        player:sendTextMessage(BOMBERMAN_MINIGAME.messages.talkaction_not_in_minigame.type, BOMBERMAN_MINIGAME.messages.talkaction_not_in_minigame.msg)
    elseif #cache.bombs == cache.bomb then
        player:sendTextMessage(BOMBERMAN_MINIGAME.messages.talkaction_dont_have_bombs.type, BOMBERMAN_MINIGAME.messages.talkaction_dont_have_bombs.msg)
    elseif Tile(player:getPosition()):getItemById(BOMBERMAN_MINIGAME.bomb_id) then
        player:sendTextMessage(BOMBERMAN_MINIGAME.messages.talkaction_cant_place_bomb.type, BOMBERMAN_MINIGAME.messages.talkaction_cant_place_bomb.msg)
    elseif cache.death then
        player:sendTextMessage(BOMBERMAN_MINIGAME.messages.talkaction_death_place_bomb.type, BOMBERMAN_MINIGAME.messages.talkaction_death_place_bomb.msg)
    else
        player:bombermanPlantBomb()
        player:getPosition():sendMagicEffect(1)
        player:sendTextMessage(BOMBERMAN_MINIGAME.messages.talkaction_place_bomb.type, string.format(BOMBERMAN_MINIGAME.messages.talkaction_place_bomb.msg, (cache.bomb-#BOMBERMAN_MINIGAME.player_cache[player:getId()].bombs)))
    end

    return false
end