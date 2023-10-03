local MAXIMUM_RESERVE_TIME = 60 --minutes
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
npcHandler:setMessage(MESSAGE_GREET, "Olá |PLAYERNAME|. Você gostaria de uma {war} no Anti Entrosa, ou então você foi {convidado} para uma War, ou você quer {entrar} caso esteja rolando uma War em sua Guild?")
NpcSystem.parseParameters(npcHandler)

local arenas = {}
local selected_arena = {}
local time = {}
local wartype = {}
local playerLimit = {}
local challengedguild = {}
local guild1 = {}
local guild2 = {}
local challengedArena = {}
local challengedDuration = {}
local challengedGuild1 = {}
local enemyGuild = {}
local disablePotions = {}
local exaustSSA = {}

function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end

local function checkPlayers(guild)
	local players = Game.getPlayers()
	local total = 0
	for i = 1, #players do
		local pguild = players[i]:getGuild()
		if pguild and pguild == guild then
			if players[i]:getLevel() >= 250 then
				total = total + 1
			end
		end

		if total >= 5 then
			return true
		end
	end

	return false
end

local function greetCallback(cid)
	local player = Player(cid)
	if(player:getGuild() == 0 or player:getGuild() == nil) then
		npcHandler:say("Hmpf.", cid)
		return false
	end

	--[[if not checkPlayers(player:getGuild()) then
		npcHandler:say("Hmpf. Your guild must have more than five players online to enter talk with me.", cid)
		return false
	end]]

	npcHandler.topic[cid] = 0
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if npcHandler.topic[cid] == 0 then
		local playerGuild = player:getGuild()
		local playerGuildName = playerGuild:getName()
-------------------------------------------------------------------------------------------------
---------------------------------------------hi--------------------------------------------------
---------------------------------------------war-------------------------------------------------
		if msg == "instanced war" or msgcontains(msg, "war") or msg == "war" then
			local guildLevel = player:getGuildLevel()
			if guildLevel ~= 3 then
				npcHandler:say("Apenas líderes de Guild podem falar comigo.", cid)
				return true
			end

			if not guildIsInWar(playerGuildName) then
				npcHandler:say("Sua guild não está em War.", cid)
				return true
			end

			npcHandler:say("Qual que é o nome da {guild inimiga}?", cid)
			npcHandler.topic[cid] = 1
---------------------------------------------enter-----------------------------------------------
		elseif(msgcontains(msg, "enter") or msgcontains(msg, "entrar")) then
			if (guildIsInWar(playerGuildName)) then
				local warArenaPos = getWarArena(player)
				if warArenaPos == nil then
					npcHandler:say("O limite de jogadores na Arena ja foi atingido.", cid)
					return false
				end

				if warArenaPos == false then
					npcHandler:say("Não existe nenhuma área reservada para o seu time.", cid)
					return false
				else
					player:sendTextMessage(22, "Você foi teletranportado!")
					player:teleportTo(warArenaPos)
				end
			else
				npcHandler:say("Sua guild não está em War.", cid)
				return false
			end

			return false
---------------------------------------------invitation------------------------------------------
		elseif(msgcontains(msg, "convidado")) then
			if msg == playerGuildName then
				npcHandler:say("Você não pode convidar a sua própria Guild para War.",cid)
				npcHandler.topic[cid] = 0
				return false
			end

			local guildLevel = player:getGuildLevel()
			if guildLevel ~= 3 then
				npcHandler:say("Apenas líderes de Guild podem falar comigo.", cid)
				return false
			end

			local resultId = db.storeQuery(string.format("SELECT * FROM `guildwar_arenas` WHERE `challenger` = %d", playerGuild:getId()))
			if resultId then
			    result.free(resultId)
			    npcHandler:say("Você precisa aguardar o líder da Guild inimiga aceitar o seu pedido.", cid)
			    return false
			end

			local resultId = db.storeQuery(string.format("SELECT * FROM `guildwar_arenas` WHERE `pending` = 1 and `guild2` = %d or `guild1` = %d", playerGuild:getId(), playerGuild:getId()))
			if not resultId then
				npcHandler:say("Não existe nenhum convite de war pendente em sua Guild.", cid)
				return false
			end

			local pending = result.getNumber(resultId, "pending")
			if pending == 0 then
				npcHandler:say("Não existe nenhum convite de war pendente em sua Guild.", cid)
				result.free(resultId)
				return false
			end

			local guildOne = result.getNumber(resultId, "guild1")
			local arena = result.getString(resultId, "name")
			local wartype = result.getString(resultId, "type")
			local duration = result.getString(resultId, "duration")
			local challenger = result.getNumber(resultId, "challenger")
			local limitOfPlayers= result.getNumber(resultId, "maxplayers")
			local disablePotions = result.getNumber(resultId, "disablepotions")
			local exaustSsa = result.getNumber(resultId, "exaust_ssa")

			result.free(resultId)
			local warstring = "{padrão}"
			challengedArena[cid] = arena
			challengedDuration[cid] = duration
			challengedGuild1[cid] = guildOne
			if(wartype == 0) then
				warstring = "{padrão}"
			elseif(wartype == WAR_TYPE_NO_UE) then
				warstring = "{sem UE}"
			elseif(wartype == WAR_TYPE_SD_ONLY) then
				warstring = "{sem SD}"
			end

			if (disablePotions == 0) then
				potionString = "{habilitado}"
			else
				potionString = "{desabilitado}"
			end

			if (exaustSsa == 0) then
				exaustString = "{ilimitado}"
			else
				exaustString = "{limitado}"
			end

			if limitOfPlayers == 1000 then
				limitOfPlayers = "{ilimitado}"
			end

			npcHandler:say(string.format("Você foi convidado pela a Guild {%s} para uma war %s, a arena na qual foi escolhida foi a {%s}. A duração dessa War será de {%d minutos}, o limite de jogadores dentro da área é {%s} para cada lado e o uso de Supreme Potions está %s, e o uso de SSA é {%s}. Você {aceita}?", getGuildNameById(challenger), warstring, arena, duration, limitOfPlayers, potionString, exaustString), cid)
			npcHandler.topic[cid] = 12
			return false
		end
---------------------------------------------war-----------------------------------------------
---------------------------------------------enemy guild name----------------------------------
	elseif npcHandler.topic[cid] == 1 then
		local playerGuild = player:getGuild()
		local playerGuildName = playerGuild:getName()
		if (msg == playerGuildName) then
			npcHandler:say("Você não pode convidar sua própria Guild para War.",cid)
			npcHandler.topic[cid] = 1
			return false
		end

		if not guildExistByName(msg) then
			npcHandler:say("Essa Guild não existe em nosso servidor.",cid)
			npcHandler.topic[cid] = 0
			return false
		end

		local resultId = db.storeQuery(string.format("SELECT `status`, `guild1`, `guild2`, `name1`, `name2` FROM `guild_wars` WHERE (`name1` = %s AND `name2` = %s OR `name1` = %s AND `name2` = %s) AND `status` = 1", db.escapeString(msg), db.escapeString(playerGuildName), db.escapeString(playerGuildName), db.escapeString(msg)))
		if not resultId then
			npcHandler:say("Sua guild não está em warmode contra a ".. msg:lower() ..". Que tédio!",cid)
			npcHandler.topic[cid] = 0
			return false
		end

		guild1[cid] = result.getNumber(resultId, "guild1")
		guild2[cid] = result.getNumber(resultId, "guild2")
		local status = result.getNumber(resultId, "status")
		local name1 = result.getString(resultId, "name1")
		local name2 = result.getString(resultId, "name2")
		result.free(resultId)

		if(name2 ~= player:getGuild():getName()) then
			if(name1 ~= player:getGuild():getName()) then
				npcHandler:say("Sua guild não está em War com a " .. msg .. " atualmente.",cid)
				return false
			end
		end

		if(status == 0) then
			npcHandler:say("Sua guild não está em War. Que tédio!",cid)
			npcHandler.topic[cid] = 0
			return false
		else
			challengedguild[cid] = msg
			free_arenas_string = getFreeArenas(cid)
			if(free_arenas_string == nil or free_arenas_string == "") then
				npcHandler:say("Infelizmente agora não existem arenas disponíveis, aguarde um pouco.", cid)
				npcHandler.topic[cid] = 0
				result.free(queryResult)
			else
				npcHandler:say("As áreas livres são" .. free_arenas_string .. ". Qual você deseja?", cid)
				npcHandler.topic[cid] = 2
			end
		end
---------------------------------------------war-----------------------------------------------
---------------------------------------------enemy guild name----------------------------------
---------------------------------------------selected arena------------------------------------
	elseif npcHandler.topic[cid] == 2 then
		local isValid = false
		for arena = 0, #arenas[cid] do
			if(msgcontains(msg,arenas[cid][arena])) then
				selected_arena[cid] = arenas[cid][arena]
				isValid = true
				npcHandler:say(selected_arena[cid] .. ", ótima escolha! Quanto tempo em {minutos} você gostaria de lutar?", cid)
				npcHandler.topic[cid] = 3
			end
		end

		if(not isValid) then
			npcHandler:say("Ahn? Não existe nenhuma opção com esse nome.", cid)
			return false
		end
---------------------------------------------war-----------------------------------------------
---------------------------------------------enemy guild name----------------------------------
---------------------------------------------selected arena------------------------------------
---------------------------------------------selected time-------------------------------------
	elseif npcHandler.topic[cid] == 3 then
		if not tonumber(msg) then
			npcHandler:say("Por favor um valor.", cid)
			return false
		end

		time[cid] = tonumber(msg)
		if(time[cid] > MAXIMUM_RESERVE_TIME) then
			time[cid] = 0
			npcHandler:say("O limite máximo é de 60 minutos.", cid)
			return false
		end

		npcHandler:say("Perfeito! Qual o tipo de war que você gostaria? {padrão}, {sem UE} ou {apenas SD}?", cid)
		npcHandler.topic[cid] = 4
---------------------------------------------war-----------------------------------------------
---------------------------------------------enemy guild name----------------------------------
---------------------------------------------selected arena------------------------------------
---------------------------------------------selected time-------------------------------------
---------------------------------------------selected type-------------------------------------
	elseif npcHandler.topic[cid] == 4 then
		if(msgcontains(msg, "padrao") or msgcontains(msg, "padrão")) then
			wartype[cid] = 0
		elseif(msgcontains(msg, "UE") or msgcontains(msg, "ue")) then
			wartype[cid] = WAR_TYPE_NO_UE
		elseif(msgcontains(msg, "SD") or msgcontains(msg, "sd")) then
			wartype[cid] = WAR_TYPE_SD_ONLY
		end

		npcHandler:say("Você gostaria de desabilitar as supreme potions? Sim ou não?", cid)
		npcHandler.topic[cid] = 5
		return false
---------------------------------------------war-----------------------------------------------
---------------------------------------------enemy guild name----------------------------------
---------------------------------------------selected arena------------------------------------
---------------------------------------------selected time-------------------------------------
---------------------------------------------selected type-------------------------------------
---------------------------------------------potions-------------------------------------------
	elseif npcHandler.topic[cid] == 5 then
		if(msgcontains(msg, "disable") or msgcontains(msg, "sim") or msgcontains(msg, "yes")) then
			disablePotions[cid] = 1
		elseif(msgcontains(msg,"no") or msgcontains(msg,"nao") or msgcontains(msg,"não")) then
			disablePotions[cid] = 0
		else
			npcHandler:say("Você gostaria de desabilitar as supreme potions? Sim ou não?", cid)
			npcHandler.topic[cid] = 5
			return false
		end

		npcHandler:say("Você gostaria de colocar um {limite no SSA}? O delay é de 5 segundos. Você aceita o exaust ou não?", cid)
		npcHandler.topic[cid] = 6
		return false
---------------------------------------------war-----------------------------------------------
---------------------------------------------enemy guild name----------------------------------
---------------------------------------------selected arena------------------------------------
---------------------------------------------selected time-------------------------------------
---------------------------------------------selected type-------------------------------------
---------------------------------------------ssa-------------------------------------------
	elseif npcHandler.topic[cid] == 6 then
		if(msgcontains(msg, "sim") or msgcontains(msg, "yes")) then
			exaustSSA[cid] = 1
		elseif(msgcontains(msg,"no") or msgcontains(msg,"nao") or msgcontains(msg,"não")) then
			exaustSSA[cid] = 0
		else
			npcHandler:say("Você gostaria de colocar um {limite no SSA}? O delay é de 5 segundos. Você aceita o exaust ou não?", cid)
			npcHandler.topic[cid] = 6
			return false
		end

		npcHandler:say("E por último.. Você gostaria de um limite de jogadores para cado lado? Se sim, me fale o {número}, se não, apenas fale {não}.", cid)
		npcHandler.topic[cid] = 7
		return false
---------------------------------------------war-----------------------------------------------
---------------------------------------------enemy guild name----------------------------------
---------------------------------------------selected arena------------------------------------
---------------------------------------------selected time-------------------------------------
---------------------------------------------selected type-------------------------------------
---------------------------------------------potions-------------------------------------------
---------------------------------------------player limit--------------------------------------
	elseif npcHandler.topic[cid] == 7 then
		if(msgcontains(msg,"não") or msgcontains(msg,"nao")) then
			playerLimit[cid] = 1000
		else
			if(not tonumber(msg)) then
				playerLimit[cid] = 20
			else
				if tonumber(msg) > 100 then
					npcHandler:say('Você não pode escolher mais de 100 pessoas para cada lado.', cid)
					npcHandler.topic[cid] = 6
					return false
				end

				playerLimit[cid] = tonumber(msg)
			end
		end

		npcHandler:say(string.format("O convite de War está aberto! O líder da guild %s precisa aceitar o convite. Ele possui apenas {um minuto}, após isso o convite será expirado!", challengedguild[cid]), cid)
		registerWarInvitation(selected_arena[cid], guild1[cid], guild2[cid], time[cid], wartype[cid], cid, disablePotions[cid], exaustSSA[cid], playerLimit[cid])
		Game.broadcastMessage(string.format("O líder da Guild %s convidou a Guild %s para uma War em %s com uma duração de %d minutos. O limite de jogadores é %s para cada lado, as potions Supreme estão %s e também SSA %s exaust.", player:getGuild():getName(), challengedguild[cid], selected_arena[cid], time[cid], playerLimit[cid] == 1000 and 'ilimitado' or ''..playerLimit[cid] ..' jogadores', disablePotions[cid] == 1 and 'limitadas' or 'ilimitadas', exaustSSA[cid] == 1 and 'possui' or 'não possui'), MESSAGE_EVENT_ADVANCE)
		npcHandler.topic[cid] = 0
---------------------------------------------invitation-----------------------------------------------
	elseif npcHandler.topic[cid] == 12 then
		if(msgcontains(msg,"yes") or msgcontains(msg,"accept")) then
			local guild = player:getGuild()
			if not guild then
				return false
			end
            Game.broadcastMessage(string.format("O líder da Guild %s aceitou o convite para War Anti Entrosa em %s da guild %s.", guild:getName(), challengedArena[cid], getGuildNameById(challengedGuild1[cid])), MESSAGE_EVENT_ADVANCE)
			addEvent(freeArena, challengedDuration[cid] * 60 * 1000, challengedArena[cid], challengedGuild1[cid], player:getGuild():getId())
			db.query(string.format('UPDATE `guildwar_arenas` SET `playersOnTeamA`=0, `playersOnTeamB`=0, `start` = %d, `pending` = 0, `inuse` = 1 WHERE `name` = %s', os.time(), db.escapeString(challengedArena[cid])))
			npcHandler:say("A partir de agora a área está disponível para ambas Guilds. Basta falar {enter} para entrar.", cid)
			npcHandler.topic[cid] = 0
			return false
		elseif(msgcontains(msg,"no")) then
			db.query(string.format("UPDATE `guildwar_arenas` SET `end` = %d, `inuse` = 0, `guild1` = 0, `guild2` = 0 WHERE `name` = %s", os.time(), db.escapeString(challengedArena[cid])))
			npcHandler:say("Ok então. Recusei o seu convite!", cid)
			npcHandler.topic[cid] = 0
		end
	end

	return true
end

local function onAddFocus(cid)
	time[cid] = 0
	time[cid] = 0
	wartype[cid] = 0
	selected_arena[cid] = 0
end

local function onReleaseFocus(cid)
	time[cid] = nil
	wartype[cid] = nil
	selected_arena[cid] = nil
end

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())


---------------------------------------------------------------------
-----LIB FOR WAR SYSTEM----------------------------------------------
---------------------------------------------------------------------
function registerWarInvitation(arena, guild1, guild2, duration, wartype, cid, disablePotions, exaustSSA, playerLimit)
	local player = Player(cid)
	if not player then
		return true
	end

	db.query(string.format('UPDATE `guildwar_arenas` SET `challenger` = %d, `maxplayers` = %d, `type` = %d, `duration` = %d, `start` = %d, `end` = 0, `inuse` = 0, `pending` = 1, `guild1` = %d, `guild2` = %d, `disablepotions` = %d, `exaust_ssa` = %d WHERE `name` = %s', player:getGuild():getId(), playerLimit, wartype, duration, os.time(), guild1, guild2, disablePotions, exaustSSA, db.escapeString(arena)))
	addEvent(revokeWarInvitation, 60 * 1000, arena)
	return true
end

function revokeWarInvitation(arena)
	db.query(string.format("UPDATE `guildwar_arenas` SET `inuse` = 0, `type` = 0, `guild1` = 0, `guild2` = 0, `start` = 0, `maxplayers` = 0, `duration` = 0, `challenger` = 0, `playersOnTeamA` = 0, `playersOnTeamB` = 0, `pending` = 0, `disablepotions` = 0, `exaust_ssa` = 0 WHERE `name` = %s AND `pending` = 1", db.escapeString(arena)))
	return true
end

function freeArena(arenaName, guild1, guild2)
	local resultId = db.storeQuery(string.format("SELECT * FROM `guildwar_arenas` WHERE `name` = %s", db.escapeString(arenaName)))
	if not resultId then
		return false
	end

	local inuse = result.getNumber(resultId, "inuse")
	result.free(resultId)
	if (inuse == 0) then
		return false
	end

	for _, targetPlayer in ipairs(Game.getPlayers()) do
		if(targetPlayer:getStorageValue(STORAGE_PLAYER_IN_ARENA) == 1) then
			if((targetPlayer:getGuild():getId() == guild1 or targetPlayer:getGuild():getId() == guild2)) then
				targetPlayer:teleportTo(targetPlayer:getTown():getTemplePosition())
				targetPlayer:setStorageValue(STORAGE_PLAYER_IN_ARENA, 0)
				targetPlayer:setStorageValue(STORAGE_PLAYER_WAR_TYPE, 0)
				targetPlayer:setStorageValue(STORAGE_POTION, 0)
				targetPlayer:setStorageValue(STORAGE_POTION, 0)
			end
		end
	end

	db.query(string.format("UPDATE `guildwar_arenas` SET `end` = %d, `type` = 0, `inuse` = 0, `guild1` = 0, `exaust_ssa` = 0, `guild2` = 0, `disablepotions` = 0 WHERE `name` = %s", os.time(), db.escapeString(arenaName)))
	return true
end

function getFreeArenas(cid)
	local buffer_of_free_arenas = {}
	local arena_names = ""

	local iterator = 0
	for i, name in pairs(global_arenas) do
		local resultId = db.storeQuery(string.format("SELECT * FROM `guildwar_arenas` WHERE `name` = %s AND `pending` = 0", db.escapeString(name)))
		if resultId then
			local inuse = result.getNumber(resultId, "inuse")
			result.free(resultId)
			if (inuse == 0) then
				local ret = ','
				if i == 1 then
					ret = ''
				elseif i == #global_arenas then
					ret = ' e'
				end

				buffer_of_free_arenas[iterator] = name
				iterator = iterator + 1
				arena_names = string.format('%s%s', arena_names, ret)
				arena_names = string.format("%s {%s}", arena_names, name)
			end
		end
	end

	arenas[cid] = buffer_of_free_arenas
	result.free(resultId)
	return arena_names
end

function guildIsInWar(guildName)
	local resultId = db.storeQuery(string.format('SELECT `status`, `guild1`, `guild2` FROM `guild_wars` WHERE `name1` = %s or `name2` = %s AND `status` = 1', db.escapeString(guildName), db.escapeString(guildName)))
	if resultId then
		result.free(resultId)
		return true
	end

	return false
end

function getGuildIdByName(name)
	local resultId = db.storeQuery(string.format('SELECT `id` FROM `guilds` WHERE `name` = %s', db.escapeString(name)))
	if resultId then
		local guildId = result.getNumber(resultId, "id")
		result.free(resultId)
		return guildId
	end

	return 0
end

function getGuildNameById(id)
	local resultId = db.storeQuery(string.format('SELECT `name` FROM `guilds` WHERE `id` = %d', id))
	if resultId then
		local guildName = result.getString(resultId, "name")
		result.free(resultId)
		return guildName
	end

	return 0
end

function getWarArena(player)
	if not player then
		return true
	end

	local playerGuildId = player:getGuild():getId()
	local resultId = db.storeQuery(string.format("SELECT * FROM `guildwar_arenas` WHERE `guild1` = %d or `guild2` = %d and `inuse` = 1", playerGuildId, playerGuildId))
	if not resultId then
		return false
	end

	local arena_inuse = result.getNumber(resultId, "inuse")
	if (arena_inuse == 0) then
		result.free(resultId)
		return false
	end

	local arena_mapname = result.getString(resultId, "name")
	local numberOfPlayersOnTeamA = result.getNumber(resultId, "playersOnTeamA")
	local numberOfPlayersOnTeamB = result.getNumber(resultId, "playersOnTeamB")
	local maxPlayers = result.getNumber(resultId, "maxplayers")
	local guild1 = result.getNumber(resultId, "guild1")
	local guild2 = result.getNumber(resultId, "guild2")
	local potionValue = result.getNumber(resultId, "disablepotions")
	local arena_team_a_pos = {x = result.getNumber(resultId, "team_a_posx"), y = result.getNumber(resultId, "team_a_posy"), z = result.getNumber(resultId, "team_a_posz")}
	local arena_team_b_pos = {x = result.getNumber(resultId, "team_b_posx"), y = result.getNumber(resultId, "team_b_posy"), z = result.getNumber(resultId, "team_b_posz")}
	local war_type = result.getNumber(resultId, "type")
	local limitOfPlayers = result.getNumber(resultId,"maxplayers")
	local ssaExaust = result.getNumber(resultId, "exaust_ssa")

	result.free(resultId)

	if (playerGuildId == guild1) then
		if(numberOfPlayersOnTeamA == maxPlayers) then
			return nil
		end

		player:setStorageValue(STORAGE_POTION, potionValue)
		player:setStorageValue(STORAGE_SSAEXAUST, ssaExaust)
		player:setStorageValue(STORAGE_PLAYER_IN_ARENA, 1)
		player:setStorageValue(STORAGE_PLAYER_TEAM, 1)
		player:setStorageValue(STORAGE_PLAYER_WAR_TYPE, war_type)
		db.query(string.format("UPDATE  `guildwar_arenas` SET `playersOnTeamA` = %d WHERE `name` = %s", tonumber(numberOfPlayersOnTeamA+1), db.escapeString(arena_mapname)))
		return arena_team_a_pos
	elseif(playerGuildId == guild2) then
		if(numberOfPlayersOnTeamB == maxPlayers) then
			return nil
		end

		player:setStorageValue(STORAGE_POTION, potionValue)
		player:setStorageValue(STORAGE_SSAEXAUST, ssaExaust)
		player:setStorageValue(STORAGE_PLAYER_IN_ARENA, 1)
		player:setStorageValue(STORAGE_PLAYER_TEAM, 2)
		player:setStorageValue(STORAGE_PLAYER_WAR_TYPE, war_type)
		db.query(string.format("UPDATE  `guildwar_arenas` SET `playersOnTeamB` = %d WHERE `name` = %s", tonumber(numberOfPlayersOnTeamB+1), db.escapeString(arena_mapname)))
		return arena_team_b_pos
	else
		return false
	end

	return false
end