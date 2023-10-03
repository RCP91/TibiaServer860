function onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	
	if player:getLevel() < 400 then 
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your level is less than 400.")
	player:teleportTo(fromPosition)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return false
	end
	
	if item.actionid == 59136 then
		if player:getStorageValue(1125581945) < 1 or player:getStorageValue(1025589452) < 1 or player:getStorageValue(3558945) < 1 or player:getStorageValue(1025589455) < 1 or player:getStorageValue(58885555) < 1 or player:getStorageValue(85202714555514) < 1 then
			
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You did not kill all the bosses.")
			player:teleportTo(fromPosition)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			else
				player:teleportTo(Position(33621, 31411, 10))
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		end	
	end
	return true
end