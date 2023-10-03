function onUse(cid, item, fromPosition, itemEx, toPosition) 
	local player = Player(cid)
	doPlayerAddPremiumDays(cid, 30)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have recived 30 premium days.")
	player:getPosition():sendMagicEffect(23)
	item:remove(1)
	return true
end