local config = {
	bossName = "Goshnar's Cruelty",
	bossName2 = "A Greedy Eye",
	bossName3 = "Dreadful Harvester",
	bossName4 = "Mean Maw",
	bossName5 = "Mean Maw",
	bossName6 = "Poor Soul",
	bossName7 = "Poor Soul",
	bossName8 = "Poor Soul",
	bossName9 = "Mean Maw",
	summonName = "Rift Invader",
	bossPos = Position{x = 33855, y = 31863, z = 7},
	horror = Position{x = 33856, y = 31858, z = 7},
	phobia = Position{x = 33850, y = 31863, z = 7},
	fear = Position{x = 33861, y = 31863, z = 7},
	fear2 = Position{x = 33851, y = 31867, z = 7},
	fear3 = Position{x = 33860, y = 31867, z = 7},
	fear4 = Position{x = 33861, y = 31870, z = 7},
	fear5 = Position{x = 33849, y = 31870, z = 7},
	fear6 = Position{x = 33851, y = 31859, z = 7},
	centerRoom = Position{x = 33855, y = 31865, z = 7}, -- Center Room
	exitPosition = Position{x = 33862, y = 31865, z = 6}, -- Exit Position
	newPos = Position{x = 33855, y = 31869, z = 7}, -- Player Position on room
	playerPositions = {
		Position{x = 33854, y = 31853, z = 6},
		Position{x = 33855, y = 31853, z = 6},
		Position{x = 33856, y = 31853, z = 6},
		Position{x = 33857, y = 31853, z = 6},
		Position{x = 33858, y = 31853, z = 6}
	},
	range = 20,
	time = 30, -- time in minutes to remove the player
}
local function clearFerumbrasRoom()
	local spectators = Game.getSpectators(config.bossPos, false, false, 20, 20, 20, 20)
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
end

local CrueltyLever = Action()
function CrueltyLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 9825 then
		if player:getPosition() ~= Position{x = 33854, y = 31853, z = 6} then
			return true
		end

		for x = 33854, 33858 do
			for y = 31853, 31853 do
				local playerTile = Tile(Position(x, y, 6)):getTopCreature()
				if playerTile and playerTile:isPlayer() then
					if playerTile:getStorageValue(1025589455) > os.time() then
						player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You or a member in your team have to wait 20 hours to face Boss again!")
						item:transform(9826)
						return true
					end
				end
			end
		end

		local specs, spec = Game.getSpectators(config.centerRoom, false, false, 15, 15, 15, 15)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "There's someone fighting with Boss.")
				return true
			end
		end

		local spectators = Game.getSpectators(config.bossPos, false, false, 15, 15, 15, 15)
		for i = 1, #spectators do
			local spectator = spectators[i]
			if spectator:isMonster() then
				spectator:remove()
			end
		end

		for x = 33854, 33858 do
			for y = 31853, 31853 do
				local playerTile = Tile(Position(x, y, 6)):getTopCreature()
				if playerTile and playerTile:isPlayer() then
					playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
					playerTile:teleportTo(config.newPos)
					playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					playerTile:setStorageValue(1025589455, os.time() + 20 * 60 * 60) -- 14 days
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have 30 minutes to kill and loot this boss. Otherwise you will lose that chance and will be kicked out.")
					addEvent(clearFerumbrasRoom, 60 * config.time * 1000, player:getId(), config.centerRoom, config.range, config.range, config.exitPosition)

					

					
					
					item:transform(9826)
				end
			end
		end
		            Game.createMonster(config.bossName, config.bossPos, true, true)
					Game.createMonster(config.bossName2, config.horror, true, true)
					Game.createMonster(config.bossName3, config.phobia, true, true)
					Game.createMonster(config.bossName4, config.fear, true, true)
					Game.createMonster(config.bossName5, config.fear2, true, true)
					Game.createMonster(config.bossName6, config.fear3, true, true)
					Game.createMonster(config.bossName7, config.fear4, true, true)
					Game.createMonster(config.bossName8, config.fear5, true, true)
					Game.createMonster(config.bossName9, config.fear6, true, true)
	elseif item.itemid == 9826 then
		item:transform(9825)
		return true
	end
end

CrueltyLever:aid(38448)
CrueltyLever:register()