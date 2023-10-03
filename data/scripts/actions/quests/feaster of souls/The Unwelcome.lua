local config = {
	requiredLevel = 100,
	daily = true,
	centerDemonRoomPosition = Position(33708, 31538, 14),
	playerPositions = {
		Position(33736, 31537, 14),
		Position(33737, 31537, 14),
		Position(33738, 31537, 14),
		Position(33739, 31537, 14),
		Position(33740, 31537, 14),
	},
	newPositions = {
		Position(33708, 31545, 14),
	},
	demonPositions = {
		Position(33708, 31538, 14),
	},
	playerFirst = {
		Position(33736, 31537, 14),
	}
}

local leverboss = Action()

function leverboss.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 9825 then
		local storePlayers, playerTile = {}

		for i = 1, #config.playerPositions do
			playerTile = Tile(config.playerFirst[1]):getTopCreature()
			if not playerTile or not playerTile:isPlayer() then
				player:sendTextMessage(MESSAGE_STATUS_SMALL, "You need 5 players.")
				return true
			end

			if playerTile:getLevel() < config.requiredLevel then
				player:sendTextMessage(MESSAGE_STATUS_SMALL, "All the players need to be level ".. config.requiredLevel .." or higher.")
				return true
			end

			storePlayers[#storePlayers + 1] = playerTile
		end

		local specs, spec = Game.getSpectators(config.centerDemonRoomPosition, false, false, 14, 14, 13, 13)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				player:sendTextMessage(MESSAGE_STATUS_SMALL, "A team is already inside the quest room.")
				return true
			end

			spec:remove()
		end

		for i = 1, #config.demonPositions do
			Game.createMonster("The Unwelcome", config.demonPositions[i])
		end

		local players
		for i = 1, #storePlayers do
			players = storePlayers[i]
			config.playerPositions[i]:sendMagicEffect(CONST_ME_POFF)
			players:teleportTo(config.newPositions[1])
			config.newPositions[1]:sendMagicEffect(CONST_ME_ENERGYAREA)
			players:setDirection(DIRECTION_EAST)
		end
	elseif item.itemid == 9826 then
		if config.daily then
			player:sendTextMessage(MESSAGE_STATUS_SMALL, Game.getReturnMessage(RETURNVALUE_NOTPOSSIBLE))
			return true
		end
	end

	item:transform(item.itemid == 9825 and 9826 or 9825)
	return true
end

leverboss:aid(30003)
leverboss:register()
