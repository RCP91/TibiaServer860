WarMaps_Configurations = {
	Event_Duration = 120, -- Minutos de duração do jogo.
	Event_WaitGame = 1, -- Minutos de espera para o inicio do jogo, dentro da sala.
	Event_MinPlayers = 2, -- Minimo de jogadores para o jogo começar, caso contrário, o jogo é cancelado.
	Event_GainFrags = 1, -- Ganho de frags a cada morte no jogo.
	Event_LostFrags = 0, -- Perca de frags a cada morte no jogo. // Para desativar, valor = 0.
	Event_Days = {1, 2, 3, 4, 5, 6, 7}, -- Dias que irá ocorrer o evento (seguindo a ordem de 1 = domingo, 7 = sabado)

	Area_Configurations = {
		Area_Arena = {{x = 28585, y = 28839, z = 7}, {x = 28737, y = 28974, z = 7}}, {{x = 28599, y = 29027, z = 7}, {x = 28725, y = 29153, z = 7}}, {{x = 28593, y = 29272, z = 7}, {x = 28730, y = 29476, z = 7}}, {{x = 28950, y = 29313, z = 7}, {x = 29092, y = 29423, z = 7}}, {{x = 28921, y = 29157, z = 7}, {x = 28996, y = 29253, z = 7}}, {{x = 28801, y = 28984, z = 7}, {x = 28903, y = 29167, z = 7}}, {{x = 28842, y = 28744, z = 7}, {x = 28899, y = 28821, z = 7}}, -- Area da arena do jogo, ({Canto Superior Esquerdo}, {Canto Inferior Direito})
		Position_WaitRoom = {x = 28693, y = 28880, z = 7}, -- Posição da sala de espera do jogo
		Position_ExitWaitRoom = {x = 28693, y = 28876, z = 7}, -- Posição do teleport que sairá da sala de espera do jogo
		Position_WaitRoomStart = {x = 28695, y = 28876, z = 7}, -- Posição do teleport que sairá da sala de espera do jogo com ele iniciado
		Position_EventTeleport = {x = 32374, y = 32239, z = 7}, -- Posição de onde será criado o teleport para os participantes irem para a sala de espera.
	},

	Ammo_Configurations = {
		Ammo_Start = 0, -- Quantidade de frags de cada jogador ao inicio do jogo.
		Ammo_Exhaust = 1, -- Segundos de espera para utilizar novamente o comando !rank
		Ammo_SkillExhaustion = 1011, -- storage exhaustion
		Ammo_PointSkill = 1012, -- storage frags
		Ammo_AmmoBuy = 1013, -- storage game start
	},

	Positions_Rewards = {
		[1] = { -- Prémios do primeiro lugar
			[2160] = 3,
		},
		[2] = { -- Prémios do segundo lugar
			[2160] = 2,
		},
		[3] = { -- Prémios do terceiro lugar
			[2160] = 1,
		},
		--[[ Caso queira adicionar prémios para outras posições basta seguir o exemplo:
		[Posição] = {
			[Item_ID] = Item_Ammount,
		},
		]]--
	},
}

-- ################# SnowBall Functions -- 
CACHE_WARGAMEPLAYERS = {}
CACHE_WARGAMEAREAPOSITIONS = {}

function loadMapsEvent()
    print("[Ultra Event]: Loading the arena area.")
    for newX = WarMaps_Configurations.Area_Configurations.Area_Arena[1].x, WarMaps_Configurations.Area_Configurations.Area_Arena[2].x do
        for newY = WarMaps_Configurations.Area_Configurations.Area_Arena[1].y, WarMaps_Configurations.Area_Configurations.Area_Arena[2].y do
            local AreaPos = {x = newX, y = newY, z = WarMaps_Configurations.Area_Configurations.Area_Arena[1].z}
            if getTileThingByPos(AreaPos).itemid == 0 then
                print("[Ultra Event]: There was a problem loading the location (x = " .. AreaPos.x .. " - y = " .. AreaPos.y .." - z = " .. AreaPos.z .. ") Of the event arena, please check the conditions.")
                return false
            elseif isWalkable(AreaPos) then
                table.insert(CACHE_WARGAMEAREAPOSITIONS, AreaPos)
            end
        end
    end
    print("[Ultra Event]: Loading the arena area successfully completed.")
 
    if getTileThingByPos(WarMaps_Configurations.Area_Configurations.Position_WaitRoom).itemid == 0 then
        print("[Ultra Event]: There was a problem verifying the existence of the waiting room position, please check the conditions.")
        return false
    end
 
    if getTileThingByPos(WarMaps_Configurations.Area_Configurations.Position_ExitWaitRoom).itemid == 0 then
        print("[Ultra Event]: There was a problem verifying the existence of the teleport position of the waiting room, please check the conditions.")
        return false
    end
 
    if getTileThingByPos(WarMaps_Configurations.Area_Configurations.Position_EventTeleport).itemid == 0 then
        print("[Ultra Event]: There was a problem verifying the existence of the position to create the event teleport, please check the conditions.")
        return false
    end
 
    print("[Ultra Event]: Event loading completed successfully.")
    return true
end
 
local sampleWarConfigs = {
    [0] = {dirPos = {x = 0, y = -1}},
    [1] = {dirPos = {x = 1, y = 0}},
    [2] = {dirPos = {x = 0, y = 1}},
    [3] = {dirPos = {x = -1, y = 0}},
}
 
local war_Corpses = {
    [0] = {
        [0] = {7303},
        [1] = {7306},
        [2] = {7303},
        [3] = {7306},
    },
    [1] = {
        [0] = {7305, 7307, 7309, 7311},
        [1] = {7308, 7310, 7312},
        [2] = {7305, 7307, 7309, 7311},
        [3] = {7308, 7310, 7312},
    },
}
 
function Event_sendWar(cid, pos, rounds, dir)
    local player = Player(cid)
 
    if rounds == 0 then
        return true
    end
 
    if player then
        local sampleCfg = sampleWarConfigs[dir]
 
        if sampleCfg then
            local newPos = Position(pos.x + sampleCfg.dirPos.x, pos.y + sampleCfg.dirPos.y, pos.z)
 
            if isWalkable(newPos) then
                if Tile(newPos):getTopCreature() then
                    local killed = Tile(newPos):getTopCreature()
 
                    if Player(killed:getId()) then
                        if war_Corpses[killed:getSex()] then
                            local killed_corpse = war_Corpses[killed:getSex()][killed:getDirection()][math.random(1, #war_Corpses[killed:getSex()][killed:getDirection()])]
 
                            Game.createItem(killed_corpse, 1, killed:getPosition())
                            local item = Item(getTileItemById(killed:getPosition(), killed_corpse).uid)
                            addEvent(function() item:remove(1) end, 3000)
                        end
 
                        killed:getPosition():sendMagicEffect(3)
                        killed:teleportTo(CACHE_WARGAMEAREAPOSITIONS[math.random(1, #CACHE_WARGAMEAREAPOSITIONS)])
                        killed:getPosition():sendMagicEffect(50)
                        killed:setStorageValue(11109, killed:getStorageValue(11109) - WarMaps_Configurations.Event_LostFrags)
                        killed:sendTextMessage(29, "You've been hit by the player " .. player:getName() .. " And lost -" .. WarMaps_Configurations.Event_LostFrags .." points.\nTotal of: " .. killed:getStorageValue(11109) .. " points")
 
                        player:setStorageValue(11109, player:getStorageValue(11109) + WarMaps_Configurations.Event_GainFrags)
                        player:sendTextMessage(29, "You just hit the player " .. killed:getName() .. " and won +" .. WarMaps_Configurations.Event_GainFrags .." points.\nTotal of: " .. player:getStorageValue(11109) .. " points")
 
                        if(CACHE_WARGAMEPLAYERS[2] == player:getId()) and player:getStorageValue(11109) >= Player(CACHE_WARGAMEPLAYERS[1]):getStorageValue(11109) then
                            player:getPosition():sendMagicEffect(7)
                            player:sendTextMessage(29, "You are now the leader of the SnowBall ranking, congratulations!")
                            Player(CACHE_WARGAMEPLAYERS[1]):getPosition():sendMagicEffect(16)
                            Player(CACHE_WARGAMEPLAYERS[1]):sendTextMessage(29, "You just lost the first place!")
                        end
 
                        table.sort(CACHE_WARGAMEPLAYERS, function(a, b) return Player(a):getStorageValue(11109) > Player(b):getStorageValue(11109) end)
                    else
 
                        newPos:sendMagicEffect(3)
                    end
                    return true
                end
 
                pos:sendDistanceEffect(newPos, 13)
                pos = newPos
                return addEvent(Event_sendWar, WarMaps_Configurations.Ammo_Configurations.Ammo_Speed, player:getId(), pos, rounds - 1, dir)
            end
 
            newPos:sendMagicEffect(3)
            return true
        end
    end
    return true
end
 
function Event_War(cid, pos, rounds, dir)
    local player = Player(cid)
 
    if rounds == 0 then
        return true
    end
 
    if player then
        local sampleCfg = sampleWarConfigs[dir]
 
        if sampleCfg then
            local newPos = Position(pos.x + sampleCfg.dirPos.x, pos.y + sampleCfg.dirPos.y, pos.z)
 
            if isWalkable(newPos) then
                if Tile(newPos):getTopCreature() then
                    local killed = Tile(newPos):getTopCreature()
 
                    if Player(killed:getId()) then
                        if war_Corpses[killed:getSex()] then
                            local killed_corpse = war_Corpses[killed:getSex()][killed:getDirection()][math.random(1, #war_Corpses[killed:getSex()][killed:getDirection()])]
 
                            Game.createItem(killed_corpse, 1, killed:getPosition())
                            local item = Item(getTileItemById(killed:getPosition(), killed_corpse).uid)
                            addEvent(function() item:remove(1) end, 3000)
                        end
 
                        killed:getPosition():sendMagicEffect(3)
                        killed:teleportTo(CACHE_WARGAMEAREAPOSITIONS[math.random(1, #CACHE_WARGAMEAREAPOSITIONS)])
                        killed:getPosition():sendMagicEffect(50)
                        killed:setStorageValue(11109, killed:getStorageValue(11109) - WarMaps_Configurations.Event_LostFrags)
                        killed:sendTextMessage(29, "You've been hit by the player " .. player:getName() .. " And lost -" .. WarMaps_Configurations.Event_LostFrags .." points.\nTotal of: " .. killed:getStorageValue(11109) .. " points")
 
                        player:setStorageValue(11109, player:getStorageValue(11109) + WarMaps_Configurations.Event_GainFrags)
                        player:sendTextMessage(29, "You just hit the player " .. killed:getName() .. " and won +" .. WarMaps_Configurations.Event_GainFrags .." points.\nTotal of: " .. player:getStorageValue(11109) .. " points")
 
                        if(CACHE_WARGAMEPLAYERS[2] == player:getId()) and player:getStorageValue(11109) >= Player(CACHE_WARGAMEPLAYERS[1]):getStorageValue(11109) then
                            player:getPosition():sendMagicEffect(7)
                            player:sendTextMessage(29, "You are now the leader of the SnowBall ranking, congratulations!")
                            Player(CACHE_WARGAMEPLAYERS[1]):getPosition():sendMagicEffect(16)
                            Player(CACHE_WARGAMEPLAYERS[1]):sendTextMessage(29, "You just lost the first place!")
                        end
 
                        table.sort(CACHE_WARGAMEPLAYERS, function(a, b) return Player(a):getStorageValue(11109) > Player(b):getStorageValue(11109) end)
                    else
 
                        newPos:sendMagicEffect(3)
                    end
                    return true
                end
 
                pos:sendDistanceEffect(newPos, 13)
                pos = newPos
                return addEvent(Event_War, WarMaps_Configurations.Ammo_Configurations.Ammo_Speed, player:getId(), pos, rounds - 1, dir)
            end
 
            newPos:sendMagicEffect(3)
            return true
        end
    end
    return true
end

function Event_endWarGame()
    local str = "       ## -> SnowBall Ranking <- ##\n\n"
 
    for rank, players in ipairs(CACHE_WARGAMEPLAYERS) do
        if WarMaps_Configurations.Positions_Rewards[rank] then
            for item_id, item_ammount in pairs(WarMaps_Configurations.Positions_Rewards[rank]) do
 
                Player(players):addItem(item_id, item_ammount)
            end
        end
 
        str = str .. rank .. ". " .. Player(players):getName() .. ": " .. Player(players):getStorageValue(11109) .. " points\n"
        --Player(players):teleportTo(Player(players):getTown():getTemplePosition())
    end
 
    for _, cid in ipairs(CACHE_WARGAMEPLAYERS) do
        Player(cid):popupFYI(str)
    end
 
    broadcastMessage("[Ultra Event]: The event ended.")
    return true
end
 
function isWalkable(pos)
    for i = 0, 255 do
        pos.stackpos = i
 
        local item = Item(getTileThingByPos(pos).uid)
        if item ~= nil then
            if item:hasProperty(2) or item:hasProperty(3) or item:hasProperty(7) then
                return false
            end
        end
    end
    return true
end
 
function isInWarArena(player)
    local pos = player:getPosition()
 
    if pos.z == WarMaps_Configurations.Area_Configurations.Area_Arena[1].z then
        if pos.x >= WarMaps_Configurations.Area_Configurations.Area_Arena[1].x and pos.y >= WarMaps_Configurations.Area_Configurations.Area_Arena[1].y then
            if pos.x <= WarMaps_Configurations.Area_Configurations.Area_Arena[2].x and pos.y <= WarMaps_Configurations.Area_Configurations.Area_Arena[2].y then
                return true
            end
        end
    end
    return false
end