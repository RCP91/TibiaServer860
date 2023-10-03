local config = {
	minPlayers = 1, -- Players online para poder invadir.
	minLevel = 50, -- Level minimo dos players online.
	warningDelay = 5, -- Delay entre mensgens de invasao (só sera mandada se nao houver nenhum player da guild dentro do castelo ao entrar)
	NW = Position(31874, 31837, 8), Position(31874, 31837, 7), Position(31874, 31837, 6), Position(31874, 31837, 5), Position(31874, 31837, 4), -- Posiçao NW do quadrado minimo envolvente do castelo.
	SE = Position(31894, 31880, 8), Position(31894, 31880, 7), Position(31894, 31880, 6), Position(31894, 31880, 5), Position(31894, 31880, 5), -- Posiçao SE do quadrado minimo envolvente do castelo.
	castleEntrance = Position(31942, 31900, 8),
	timeToKill = 10, -- Tempo em segundos para matar todos os geradores. (A diferença entre o tempo da morte de todos deve ser no maximo 60 segundos)
	generators = {
		[1] = {pos = Position(31900, 31849, 8), name = "Gate", spawn = 120},
		[2] = {pos = Position(31884, 31836, 7), name = "Gate", spawn = 120},
		[3] = {pos = Position(31884, 31848, 6), name = "Gate", spawn = 120},
		[4] = {pos = Position(31878, 31842, 5), name = "Gate", spawn = 120},
		[5] = {pos = Position(31876, 31848, 4), name = "Gate", spawn = 120},
		[6] = {pos = Position(31883, 31857, 4), name = "Castle Crystal", main = true}
	},
	teleport = {pos = Position(31884, 31874, 4), topos = Position(31885, 31874, 4), duration = 10}, -- Teleporte gerado apos morte dos geradores para terceira sala. ultima sala baixo
}

if not CASTLE then
	CASTLE = {}
	CASTLE.warnings = {}
end

function checkPlayers(guild)
	local players = Game.getPlayers()
	local total = 0
	for i = 1, #players do
		local pguild = players[i]:getGuild()
		if pguild and pguild == guild then
			if players[i]:getLevel() >= config.minLevel then
				total = total + 1
			end
		end

		if total >= config.minPlayers then
			return true
		end
	end

	return false
end

function CASTLE:getPlayersInside()
	local players = Game.getPlayers()
	local ret = {}

	for i = 1, #players do
		local pos = players[i]:getPosition()
		if pos.x >= config.NW.x and pos.y >= config.NW.y and pos.x <= config.SE.x and pos.y <= config.SE.y then
			table.insert(ret, players[i])
		end
	end

	return ret
end

function CASTLE:isGuildInside(guild)
	local players = self:getPlayersInside()

	for i = 1, #players do
		local pguild = players[i]:getGuild()
		if pguild and pguild == guild then
			return true
		end
	end

	return false
end

function CASTLE:load()
	if not self.loaded then
		self.loaded = true
		local resultId = db.storeQuery("SELECT * FROM `castle_info` WHERE `active` = 1;")
		if resultId then
			local res = result.getDataInt(resultId, "guild_id") or result.getDataInt(resultId, "name")
			if not tonumber(res) then
				self.dominant = false
			else
				self.dominant = res
			end
		else
			self.dominant = false
		end

		self:spawnGenerator()
	end
end

function CASTLE:findGenerator(cid)
	for i = 1, #self.generators do
		if self.generators[i].cid == cid then
			return self.generators[i]
		end
	end

	return false
end

function CASTLE:spawnGenerator(id)
	if not self.generators then
		self.generators = {}
	end
	if not id then
		for id, generator in ipairs(config.generators) do
			if not self.generators[id] or self.generators[id].dead then
				local creature = Game.createMonster(generator.name, generator.pos)
				if creature then
					self.generators[id] = {id = id, cid = creature:getId(), spawntime = os.time()}
					creature:registerEvent("Generator_Health")
					if generator.main then
						creature:registerEvent("MainGenerator_Death")
						self.generators[id].main = true
					else
						creature:registerEvent("Generator_Death")
					end
				else
					print("[Critical Error :: Castle 24HRS] Failed to create generator " .. id .. ".")
				end
			end
		end
	else
		if config.generators[id] and (not self.generators[id] or self.generators[id].dead) then
			local generator = config.generators[id]

			local creature = Game.createMonster(generator.name, generator.pos)
			if creature then
				self.generators[id] = {id = id, cid = creature:getId(), spawntime = os.time()}
				creature:registerEvent("Generator_Health")
				if generator.main then
					creature:registerEvent("MainGenerator_Death")
				else
					creature:registerEvent("Generator_Death")
				end
			else
				print("[Critical Error :: Castle 24HRS] Failed to create generator " .. id .. ".")
			end

		end
	end
end

function CASTLE:getDominantGuild()
	if not self.dominant or not Guild(self.dominant) then
		return false
	end

	return Guild(self.dominant)
end

function CASTLE:dominate(guild)
	local guild = Guild(guild)
	if guild then
		db.query("UPDATE `castle_info` SET `active` = 0 WHERE 1;")
		db.query(("INSERT INTO `castle_info` (`guild_id`, `timestamp`, `active`) VALUES (%d, %d, %d)"):format(guild:getId(), os.time(), 1))
	end
end

function CASTLE:teleportPlayer(player)
	local ret = "Good Luck!"
	local guild = player:getGuild()
	local dominant = self:getDominantGuild()
	if not guild then
		return "You do not have a guild at the moment."
	elseif guild:getId() ~= self.dominant and not checkPlayers(guild) then
		return "Your guild does not have " .. config.minPlayers .. " players level " .. config.minLevel .. " or greater online at the moment."
	end

	if (not dominant or dominant ~= guild) and not self:isGuildInside(guild) and (not self.warnings[guild:getId()] or self.warnings[guild:getId()] + config.warningDelay * 60 <= os.time()) then
		local dominant = self:getDominantGuild()
		Game.broadcastMessage(("[Castle 24HRS] The guild %s is invading the castle%s"):format(guild:getName(), dominant and (" of the dominant guild " .. dominant:getName() .. ".") or "."), MESSAGE_STATUS_WARNING)
		self.warnings[guild:getId()] = os.time()
	end

	player:teleportTo(config.castleEntrance)
	config.castleEntrance:sendMagicEffect(CONST_ME_TELEPORT)
	return ret
end

function CASTLE:removeTeleport()
	self:spawnGenerator()
	local teleport = Tile(config.teleport.pos):getItemById(25417)
	if teleport then
		teleport:remove()
	end

	Game.broadcastMessage("[Castle 24HRS] The teleport disappeared and the guardians were restored.", MESSAGE_STATUS_WARNING)
end

function CASTLE:createTeleport()
	local teleport = Game.createItem(25417, 1, config.teleport.pos)
	if teleport then
		teleport:setDestination(config.teleport.topos)
	end
	self.teleportevent = addEvent(CASTLE.removeTeleport, config.teleport.duration * 1000, self)
end

function CASTLE:checkGenerators()
	local maxtime = -math.huge
	local mintime = math.huge
	for _, generator in pairs(self.generators) do
		if not generator.main then
			if generator.dead then
				if generator.deathtime > maxtime then
					maxtime = generator.deathtime
				end
				if generator.deathtime < mintime then
					mintime = generator.deathtime
				end
			else
				return false
			end
		end
	end

	if math.abs(maxtime - mintime) < config.timeToKill then
		print(math.abs(maxtime - mintime))
		for _, generator in pairs(self.generators) do
			stopEvent(generator.spawnevent)
			generator.spawnevent = nil
		end
		Game.broadcastMessage("[Castle 24HRS] All the guardians were killed the teleport to the main guardian was created and " .. config.teleport.duration .. " seconds.", MESSAGE_STATUS_WARNING)
		self:createTeleport()
	else
		Game.broadcastMessage("[Castle 24HRS] All guardians were killed but teleport was not created.", MESSAGE_STATUS_WARNING)
	end
end

function CASTLE:onGeneratorDeath(creature, killer)
	local generator = self:findGenerator(creature:getId())
	if generator and config.generators[generator.id] then
		generator.dead = true
		generator.deathtime = os.time()
		generator.spawnevent = addEvent(CASTLE.spawnGenerator, config.generators[generator.id].spawn * 1000, self, generator.id)
		Game.broadcastMessage("[Castle 24HRS] One guardian was killed.", MESSAGE_STATUS_WARNING)
	end

	self:checkGenerators()
end

function CASTLE:finish()
	if self.teleportevent then
		stopEvent(self.teleportevent)
		self.teleportevent = nil

		local teleport = Tile(config.teleport.pos):getItemById(25417)
		if teleport then
			teleport:remove()
		end
	end

	local players = self:getPlayersInside()
	for i = 1, #players do
		local temple = players[i]:getTown():getTemplePosition()
		players[i]:teleportTo(temple)
		temple:sendMagicEffect(CONST_ME_TELEPORT)
	end

	self:spawnGenerator()
end

function CASTLE:onMainGeneratorDeath(creature, killer)
	local generator = self:findGenerator(creature:getId())
	generator.dead = true
	if killer:getMaster() then
		killer = killer:getMaster()
	end

	local guild = killer:getGuild()

	self:finish()
	if not guild then
		print("[Critical Error :: Castle 24HRS] Player that last hited the main generator didn't have guild something really wrong happened, exiting gracefully.")
		return false
	end
	local data = os.date("%d/%m/%Y - %H:%M:%S")
    local data1 = 1
	self:dominate(guild:getId())
	db.query("UPDATE `castle_web` SET `active` = 0 WHERE 1;")
	db.query("INSERT INTO `castle_web` (`guild_id`, `guild_name`, `player_name`, `date`, `active`) VALUES ('".. guild:getId().."', '".. guild:getName() .."', '".. killer:getName() .."', '".. data .."', '".. data1 .."');")
	Game.broadcastMessage(("[Castle 24HRS] The Castle Crystal was killed by %s of guild %s which is now the castle's dominant guild."):format(killer:getName(), guild:getName()), MESSAGE_STATUS_WARNING)
end

function CASTLE:onGeneratorChangeHealth(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if attacker:getMaster() then
		attacker = attacker:getMaster()
	end

	if attacker and attacker:isPlayer() then
		local dominant = self:getDominantGuild()
		local guild = attacker:getGuild()
		if dominant and guild and dominant == guild then
			return 0, primaryType, 0, secondaryType
		end
	end

	if primaryType == COMBAT_HEALING then
		primaryDamage = 0
	end
	if secondaryType == COMBAT_HEALING then
		secondaryDamage = 0
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end