function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.actionid == 59137 then
		if player:getStorageValue(14577) <= 1 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have found Bag You Desire.')
			player:addItem(38944, 1)
			player:setStorageValue(14577, 2)
			else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'It\'s empty.')
			return false
		end	
	end
	return true
end