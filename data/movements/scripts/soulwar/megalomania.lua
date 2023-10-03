function onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	
	if item.actionid == 59135 then			
		if player:getStorageValue(14561) > os.time() then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have to wait a while to challenge this boss again!")
			player:teleportTo(fromPosition)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)	
			else
				player:teleportTo(Position{x = 33680, y = 31634, z = 14})
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)		
		end	
	end	
	return true
end