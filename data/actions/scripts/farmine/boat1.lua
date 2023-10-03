local positionAfterEnchantment = Position(33586,32263, 7)

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
 if player:isPremium() then
	if not player then
		return
	end
	elseif not player:isPremium() then
      player:teleportTo(fromPosition)
	  player:getPosition():sendMagicEffect(CONST_ME_POFF)
      player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You do not premium.')
		return
	end
        if item.actionid == actionId then
		player:teleportTo(positionAfterEnchantment)
		player:getPosition():sendMagicEffect(CONST_ME_SMALLPLANTS)
			return true
	end
end