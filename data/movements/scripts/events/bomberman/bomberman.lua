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

	if Game.getStorageValue(BOMBERMAN_MINIGAME.storage_bomberman) > 0 then
		Game.setStorageValue(BOMBERMAN_MINIGAME.storage_count, Game.getStorageValue(BOMBERMAN_MINIGAME.storage_count)-1)
		player:teleportTo(BOMBERMAN_MINIGAME.leverRoom)
end

	if Game.getStorageValue(BOMBERMAN_MINIGAME.storage_count) == 0 then
	removeBombermanTp()
	broadcastMessage("Team completo, bom jogo!", MESSAGE_EVENT_ADVANCE)
	end
	return true
end