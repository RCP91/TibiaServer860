function onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() or not creature:isPremium() then
		creature:teleportTo(fromPosition)
		creature:getPosition():sendMagicEffect(CONST_ME_POFF)
		creature:sendCancelMessage("No have Premium.")
		return false
	end
	creature:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	return true
end