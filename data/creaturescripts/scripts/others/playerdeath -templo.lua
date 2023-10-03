local deathListEnabled = true

function onDeath(player, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
if player:getStorageValue(STORAGE_PLAYER_IN_ARENA) == 1 then
		local playerGuildId = player:getGuild():getId()
		local resultId = db.storeQuery(string.format("SELECT * FROM `guildwar_arenas` WHERE `guild1` = %d or `guild2` = %d AND `inuse` = 1", playerGuildId, playerGuildId))
		if resultId then
			local guild1 = result.getNumber(resultId, "guild1")
			local guild2 = result.getNumber(resultId, "guild2")
			local arena_mapname = result.getString(resultId, "name")
			local numberOfPlayersOnTeamA = result.getNumber(resultId, "playersOnTeamA")
			local numberOfPlayersOnTeamB = result.getNumber(resultId, "playersOnTeamB")
			result.free(resultId)
			if (guild1 == playerGuildId) then
				db.query(string.format('UPDATE `guildwar_arenas` SET `playersOnTeamA` = %d WHERE `name` = %s', tonumber(numberOfPlayersOnTeamA - 1), db.escapeString(arena_mapname)))
			else
				db.query(string.format('UPDATE `guildwar_arenas` SET `playersOnTeamB` = %d WHERE `name` = %s', tonumber(numberOfPlayersOnTeamB - 1), db.escapeString(arena_mapname)))
			end
		end

		player:setStorageValue(STORAGE_PLAYER_IN_ARENA, 0)
		player:setStorageValue(STORAGE_PLAYER_WAR_TYPE, 0)
	end

	local playerId = player:getId()
	if nextUseStaminaTime[playerId] ~= nil then
		nextUseStaminaTime[playerId] = nil
	end

	-- teleportando o player para o templo
	player:teleportTo(player:getTown():getTemplePosition())

	-- enchenco life e mana
	player:addHealth(player:getMaxHealth())
	player:addMana(player:getMaxMana())

	-- criando efeito de teleport
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You are dead.')
	if player:getStorageValue(Storage.SvargrondArena.Pit) > 0 then
		player:setStorageValue(Storage.SvargrondArena.Pit, 0)
	end

	if not deathListEnabled then
		return
	end

	local byPlayer = 0
	local killerName
	if killer ~= nil then
		if killer:isPlayer() then
			byPlayer = 1
		else
			local master = killer:getMaster()
			if master and master ~= killer and master:isPlayer() then
				killer = master
				byPlayer = 1
			end
		end
		killerName = killer:isMonster() and killer:getType():getNameDescription() or killer:getName()
	else
		killerName = 'field item'
	end

	local byPlayerMostDamage = 0
	local mostDamageKillerName
	if mostDamageKiller ~= nil then
		if mostDamageKiller:isPlayer() then
			byPlayerMostDamage = 1
		else
			local master = mostDamageKiller:getMaster()
			if master and master ~= mostDamageKiller and master:isPlayer() then
				mostDamageKiller = master
				byPlayerMostDamage = 1
			end
		end
		mostDamageName = mostDamageKiller:isMonster() and mostDamageKiller:getType():getNameDescription() or mostDamageKiller:getName()
	else
		mostDamageName = 'field item'
	end

	local playerGuid = player:getGuid()
	db.query('INSERT INTO `player_deaths` (`player_id`, `time`, `level`, `killed_by`, `is_player`, `mostdamage_by`, `mostdamage_is_player`, `unjustified`, `mostdamage_unjustified`) VALUES (' .. playerGuid .. ', ' .. os.time() .. ', ' .. player:getLevel() .. ', ' .. db.escapeString(killerName) .. ', ' .. byPlayer .. ', ' .. db.escapeString(mostDamageName) .. ', ' .. byPlayerMostDamage .. ', ' .. (unjustified and 1 or 0) .. ', ' .. (mostDamageUnjustified and 1 or 0) .. ')')
	local resultId = db.storeQuery('SELECT `player_id` FROM `player_deaths` WHERE `player_id` = ' .. playerGuid)

	local deathRecords = 0
	local tmpResultId = resultId
	while tmpResultId ~= false do
		tmpResultId = result.next(resultId)
		deathRecords = deathRecords + 1
	end

	if resultId ~= false then
		result.free(resultId)
	end

	if byPlayer == 1 then
		local targetGuild = player:getGuild()
		targetGuild = targetGuild and targetGuild:getId() or 0
		if targetGuild ~= 0 then
			local killerGuild = killer:getGuild()
			killerGuild = killerGuild and killerGuild:getId() or 0
			if killerGuild ~= 0 and targetGuild ~= killerGuild and isInWar(playerId, killer.uid) then
				local warId = false
				resultId = db.storeQuery('SELECT `id` FROM `guild_wars` WHERE `status` = 1 AND ((`guild1` = ' .. killerGuild .. ' AND `guild2` = ' .. targetGuild .. ') OR (`guild1` = ' .. targetGuild .. ' AND `guild2` = ' .. killerGuild .. '))')
				if resultId ~= false then
					warId = result.getNumber(resultId, 'id')
					result.free(resultId)
				end

				if warId ~= false then
					db.asyncQuery('INSERT INTO `guildwar_kills` (`killer`, `target`, `killerguild`, `targetguild`, `time`, `warid`) VALUES (' .. db.escapeString(killerName) .. ', ' .. db.escapeString(player:getName()) .. ', ' .. killerGuild .. ', ' .. targetGuild .. ', ' .. os.time() .. ', ' .. warId .. ')')
				end
			end
		end
	end
end
