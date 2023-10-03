function onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if player == nil then return false end
	
	if player:getLevel() < 100 then
	player:teleportTo(fromPosition)
    player:sendTextMessage(MESSAGE_INFO_DESCR, "YOU NEED LEVEL 100+ TO ENTER.")
	return false
    end	
	
	
	if player:getGroup():getId() >= 3 then
		player:teleportTo(fromPosition)
	return true
    end	

	if Game.getStorageValue(_Lib_BloodCastle_Info.storage_count) > 0 then
		player:teleportTo(_Lib_BloodCastle_Info.TeamOne.pos)
		player:setStorageValue(_Lib_BloodCastle_Info.TeamOne.storage, 1)
		Game.setStorageValue(_Lib_BloodCastle_Info.storage_count, Game.getStorageValue(_Lib_BloodCastle_Info.storage_count)-1)
	end

	if Game.getStorageValue(_Lib_BloodCastle_Info.storage_count) == 0 then
	removeBattleTp()
	broadcastMessage("Blood Castle vai comecar em 2 minutos, comece a criar sua estrategia de combate!", MESSAGE_EVENT_ADVANCE)
	addEvent(broadcastMessage, 2 * 60 * 1000 - 500, "Blood Castle vai comecar agora!", MESSAGE_EVENT_ADVANCE)
	addEvent(OpenWallGate, 2 * 60 * 1000)
	end
	return true
end