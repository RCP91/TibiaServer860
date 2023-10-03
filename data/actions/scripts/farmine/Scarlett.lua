local config = {
	bossName = "Scarlett Etzel",
	lockStorage = 5055195, -- globalstorage
	bossPos = Position(33396, 32643, 6),
	centerRoom = Position(33396, 32648, 6), -- Center Room  
	exitPosition = Position(33395, 32662, 6), -- Exit Position
	newPos = Position(33395, 32658, 9),
	range = 12,
	time = 15, -- time in minutes to remove the player	
}	

--[[local monsters = {
	{pillar = "oberons ire", pos = Position(33367, 31320, 9)},
	{pillar = "oberons spite", pos = Position(33361, 31320, 9)},
	{pillar = "oberons hate", pos = Position( 33367, 31316, 9)},
	{pillar = "oberons bile", pos = Position(33361, 31316, 9)}
}]]

local function clearOberonRoom()
	if Game.getStorageValue(config.lockStorage) == 1 then
		local spectators = Game.getSpectators(config.bossPos, false, false, 10, 10, 10, 10)
		for i = 1, #spectators do
			local spectator = spectators[i]
			if spectator:isPlayer() then
				spectator:teleportTo(config.exitPosition)
				spectator:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				spectator:say('Time out! You were teleported out by strange forces.', TALKTYPE_MONSTER_SAY)
			elseif spectator:isMonster() then
				spectator:remove()
			end
		end
		Game.setStorageValue(config.lockStorage, 0)
	end
end
-- Start Script
function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 36319 and item.actionid == 57606 then
		if player:getPosition() ~= Position(33395, 32661, 6) then
			return true
		end
			
	for x = 33395, 33395 do
	local playerTile = Tile(Position(x, 32658, 6)):getTopCreature()
		if playerTile and playerTile:isPlayer() then 
			if playerTile:getStorageValue(Storage.TheSecretLibrary.TheOrderOfTheFalcon.OberonTimer) > os.time() then
				playerTile:sendTextMessage(MESSAGE_STATUS_SMALL, "You or a member in your team have to wait 20 hours to challange Scarlett Etzel again!")
				item:transform(36319)
				return true
			end
		end
	end			
	
	local specs, spec = Game.getSpectators(config.centerRoom, false, false, 15, 15, 15, 15)
	for i = 1, #specs do
		spec = specs[i]
		if spec:isPlayer() then
			player:sendTextMessage(MESSAGE_STATUS_SMALL, "There's someone fighting with Scarlett Etzel.")
			item:transform(36319)
			return true
		end
	end	
			
	if Game.getStorageValue(config.lockStorage) == 1 then
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "You need wait 10 minutes to room cleaner!")
		return true
	end
	
	local spectators = Game.getSpectators(config.bossPos, false, false, 15, 15, 15, 15)
	for i = 1, #spectators do
		local spectator = spectators[i]
		if spectator:isMonster() then
			spectator:remove()
		end
	end
		--[[for n = 1, #monsters do
			Game.createMonster(monsters[n].pillar, monsters[n].pos, true, true)
		end]]	
	Game.createMonster(config.bossName, config.bossPos, true, true)	
	Game.setStorageValue(config.lockStorage, 1)
	for x = 33395, 33395 do
		local playerTile = Tile(Position(x, 33358, 6)):getTopCreature()
		if playerTile and playerTile:isPlayer() then 					
			playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
			playerTile:teleportTo(config.newPos)
			playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)	
			playerTile:setStorageValue(Storage.TheSecretLibrary.TheOrderOfTheFalcon.Scarlett, os.time() + 2 * 60 * 3600) -- + 20 * 60 * 3600
			addEvent(clearOberonRoom, 60 * config.time * 1000, playerTile:getId(), config.centerRoom, config.range, config.range, config.exitPosition)
			playerTile:sendTextMessage(MESSAGE_STATUS_SMALL, "You have 15 minutes to kill and loot this boss. Otherwise you will lose that chance and will be kicked out.")
			item:transform(36319)
		end
	end
	
elseif item.itemid == 36319 then
		item:transform(36319)
	end
		return true
end