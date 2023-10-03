local storage = 5845
	
function onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end
	creature:teleportTo(creature:getTown():getTemplePosition())
	creature:setStorageValue(storage, os.time() + 5)

	return true
end