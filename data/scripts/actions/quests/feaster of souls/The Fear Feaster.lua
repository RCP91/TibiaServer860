local config = {
	bossName = "The Fear Feaster",
	bossName2 = "horror",
	bossName3 = "phobia",
	bossName4 = "fear",
	summonName = "Rift Invader",
	bossPos = Position{x = 33711, y = 31467, z = 14},
	horror = Position{x = 33708, y = 31469, z = 14},
	phobia = Position{x = 33715, y = 31469, z = 14},
	fear = Position{x = 33711, y = 31472, z = 14},
	centerRoom = Position{x = 33711, y = 31470, z = 14}, -- Center Room
	exitPosition = Position{x = 33741, y = 31472, z = 14}, -- Exit Position
	newPos = Position{x = 33712, y = 31475, z = 14}, -- Player Position on room
	playerPositions = {
		Position{x = 33734, y = 31471, z = 14},
		Position{x = 33735, y = 31471, z = 14},
		Position{x = 33736, y = 31471, z = 14},
		Position{x = 33737, y = 31471, z = 14},
		Position{x = 33738, y = 31471, z = 14}
	},
	range = 20,
	time = 30, -- time in minutes to remove the player
}
local function clearFerumbrasRoom()
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
end

local TheFearLever = Action()
function TheFearLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 9825 then
		if player:getPosition() ~= Position{x = 33734, y = 31471, z = 14} then
			return true
		end

		for x = 33734, 33738 do
			for y = 31471, 31471 do
				local playerTile = Tile(Position(x, y, 14)):getTopCreature()
				if playerTile and playerTile:isPlayer() then
					if playerTile:getStorageValue(15852456643) > os.time() then
						player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You or a member in your team have to wait 20 hours to face Boss again!")
						item:transform(9826)
						return true
					end
				end
			end
		end

		local specs, spec = Game.getSpectators(config.centerRoom, false, false, 10, 10, 10, 10)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "There's someone fighting with Boss.")
				return true
			end
		end

		local spectators = Game.getSpectators(config.bossPos, false, false, 10, 10, 10, 10)
		for i = 1, #spectators do
			local spectator = spectators[i]
			if spectator:isMonster() then
				spectator:remove()
			end
		end

		for x = 33734, 33738 do
			for y = 31471, 31471 do
				local playerTile = Tile(Position(x, y, 14)):getTopCreature()
				if playerTile and playerTile:isPlayer() then
					playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
					playerTile:teleportTo(config.newPos)
					playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					playerTile:setStorageValue(15852456643, os.time() + 20 * 60 * 60) -- 14 days
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
	elseif item.itemid == 9826 then
		item:transform(9825)
		return true
	end
end

TheFearLever:aid(30004)
TheFearLever:register()