function onPrepareDeath(creature, lastHitKiller, mostDamageKiller)
	if creature:isPlayer() and creature:getStorageValue(_Lib_Battle_Info.TeamOne.storage) >= 1 then
		creature:sendTextMessage(MESSAGE_INFO_DESCR, "[Blood Castle] You are dead.")
		creature:teleportTo(creature:getTown():getTemplePosition())
		creature:addHealth(creature:getMaxHealth())
	end
	return true
end