function onSay(player, words, param)
	if player:getStorageValue(1234) >= os.time() then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Infor 25% xp"
 ..	"\nExpire "..os.date ("%d %B %Y %X ",player:getStorageValue(1234)))
        return true
    end
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'No have 25% XP!')
    return true
end
