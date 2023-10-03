function onJoin(player)
    addEvent(function() player:sendChannelMessage("", BOMBERMAN_MINIGAME.messages.channel_enter.msg, BOMBERMAN_MINIGAME.messages.channel_enter.type, BOMBERMAN_MINIGAME.channelId) end, 300)
    return true
end

function onLeave(player)
    if BOMBERMAN_MINIGAME.player_cache[player:getId()] then
        player:openChannel(BOMBERMAN_MINIGAME.channelId)
        addEvent(function() player:sendChannelMessage("", BOMBERMAN_MINIGAME.messages.channel_leave.msg, BOMBERMAN_MINIGAME.messages.channel_leave.type, BOMBERMAN_MINIGAME.channelId) end, 300)
    end
end

function onSpeak(player, type, message)
    local playerAccountType = player:getAccountType()
    if playerAccountType < ACCOUNT_TYPE_GAMEMASTER then
        return false
    end
    
    if type == TALKTYPE_CHANNEL_Y then
        if playerAccountType >= ACCOUNT_TYPE_GAMEMASTER then
            type = TALKTYPE_CHANNEL_O
        end
    elseif type == TALKTYPE_CHANNEL_O then
        if playerAccountType < ACCOUNT_TYPE_GAMEMASTER then
            type = TALKTYPE_CHANNEL_Y
        end
    elseif type == TALKTYPE_CHANNEL_R1 then
        if playerAccountType < ACCOUNT_TYPE_GAMEMASTER and not getPlayerFlagValue(player, PlayerFlag_CanTalkRedChannel) then
            type = TALKTYPE_CHANNEL_Y
        end
    end
    return type
end