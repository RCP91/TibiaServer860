SnowBall_Configurations = {
	Event_Duration = 5, -- Minutos de duração do jogo.
	Event_WaitGame = 2, -- Minutos de espera para o inicio do jogo, dentro da sala.
	Event_MinPlayers = 2, -- Minimo de jogadores para o jogo começar, caso contrário, o jogo é cancelado.
	Event_GainPoint = 1, -- Ganho de pontos a cada acerto no jogo.
	Event_LostPoints = 0, -- Perca de pontos a cada morte no jogo. // Para desativar, valor = 0.
	Event_Days = {1, 2, 3, 4, 5, 6, 7}, -- Dias que irá ocorrer o evento (seguindo a ordem de 1 = domingo, 7 = sabado)

	Area_Configurations = {
		Area_Arena = {{x = 31962, y = 31840, z = 7}, {x = 32008, y = 31884, z = 7}}, -- Area da arena do jogo, ({Canto Superior Esquerdo}, {Canto Inferior Direito})
		Position_WaitRoom = {x = 31986, y = 31863, z = 6}, -- Posição da sala de espera do jogo
		Position_ExitWaitRoom = {x = 31986, y = 31860, z = 6}, -- Posição do teleport que sairá da sala de espera do jogo
		Position_EventTeleport = {x = 32364, y = 32236, z = 7}, -- Posição de onde será criado o teleport para os participantes irem para a sala de espera.
	},

	Ammo_Configurations = {
		Ammo_Price = 1, -- Preço da municação em pontos do jogo.
		Ammo_Ammount = 100, -- Quantidade de ganho a cada compra.
		Ammo_Start = 100, -- Quantidade de municação de cada jogador ao inicio do jogo.
		Ammo_Restart = 50, -- Quantidade de municação do jogador, caso ele morra. // Caso queira desativar, valor = 0.
		Ammo_Speed = 150, -- Velocidade de cada tiro
		Ammo_Infinity = true, -- Se as munições serão infinitas ou não (True / False)
		Ammo_Exhaust = 1, -- Segundos de espera para utilizar novamente o comando !snowball atirar
		Ammo_Distance = 6, -- Quantidade de tiles que o tiro irá alcançars
		Ammo_SkillExhaustion = 1007, -- storage exhaustion
		Ammo_PointSkill = 1008, -- storage pontos
		Ammo_AmmoBuy = 1009, -- storage balls
	},

	Positions_Rewards = {
		[1] = { -- Prémios do primeiro lugar
			[2160] = 70,
			[15515] = 20,
		},
		[2] = { -- Prémios do segundo lugar
			[2160] = 50,
			[15515] = 15,
		},
		[3] = { -- Prémios do terceiro lugar
			[2160] = 30,
     		[15515] = 10,
		},
		--[[ Caso queira adicionar prémios para outras posições basta seguir o exemplo:
		[Posição] = {
			[Item_ID] = Item_Ammount,
		},
		]]--
	},
}

-- ################# SnowBall Functions -- Por favor, não mexer. Desenvolvido inteiramente por Tony Araújo (OrochiElf) ################# --
CACHE_GAMEPLAYERS = {}
CACHE_GAMEAREAPOSITIONS = {}

function loadEvent()
    print("[SnowBall Event]: Loading the arena area.")
    for newX = SnowBall_Configurations.Area_Configurations.Area_Arena[1].x, SnowBall_Configurations.Area_Configurations.Area_Arena[2].x do
        for newY = SnowBall_Configurations.Area_Configurations.Area_Arena[1].y, SnowBall_Configurations.Area_Configurations.Area_Arena[2].y do
            local AreaPos = {x = newX, y = newY, z = SnowBall_Configurations.Area_Configurations.Area_Arena[1].z}
            if getTileThingByPos(AreaPos).itemid == 0 then
                print("[SnowBall Event]: There was a problem loading the location (x = " .. AreaPos.x .. " - y = " .. AreaPos.y .." - z = " .. AreaPos.z .. ") Of the event arena, please check the conditions.")
                return false
            elseif isWalkable(AreaPos) then
                table.insert(CACHE_GAMEAREAPOSITIONS, AreaPos)
            end
        end
    end
    print("[SnowBall Event]: Loading the arena area successfully completed.")
 
    if getTileThingByPos(SnowBall_Configurations.Area_Configurations.Position_WaitRoom).itemid == 0 then
        print("[SnowBall Event]: There was a problem verifying the existence of the waiting room position, please check the conditions.")
        return false
    end
 
    if getTileThingByPos(SnowBall_Configurations.Area_Configurations.Position_ExitWaitRoom).itemid == 0 then
        print("[SnowBall Event]: There was a problem verifying the existence of the teleport position of the waiting room, please check the conditions.")
        return false
    end
 
    if getTileThingByPos(SnowBall_Configurations.Area_Configurations.Position_EventTeleport).itemid == 0 then
        print("[SnowBall Event]: There was a problem verifying the existence of the position to create the event teleport, please check the conditions.")
        return false
    end
 
    print("[SnowBall Event]: Event loading completed successfully.")
    return true
end
 
local sampleConfigs = {
    [0] = {dirPos = {x = 0, y = -1}},
    [1] = {dirPos = {x = 1, y = 0}},
    [2] = {dirPos = {x = 0, y = 1}},
    [3] = {dirPos = {x = -1, y = 0}},
}
 
local iced_Corpses = {
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
 
function Event_sendSnowBall(cid, pos, rounds, dir)
    local player = Player(cid)
 
    if rounds == 0 then
        return true
    end
 
    if player then
        local sampleCfg = sampleConfigs[dir]
 
        if sampleCfg then
            local newPos = Position(pos.x + sampleCfg.dirPos.x, pos.y + sampleCfg.dirPos.y, pos.z)
 
            if isWalkable(newPos) then
                if Tile(newPos):getTopCreature() then
                    local killed = Tile(newPos):getTopCreature()
 
                    if Player(killed:getId()) then
                        if iced_Corpses[killed:getSex()] then
                            local killed_corpse = iced_Corpses[killed:getSex()][killed:getDirection()][math.random(1, #iced_Corpses[killed:getSex()][killed:getDirection()])]
 
                            Game.createItem(killed_corpse, 1, killed:getPosition())
                            local item = Item(getTileItemById(killed:getPosition(), killed_corpse).uid)
                            addEvent(function() item:remove(1) end, 3000)
                        end
 
                        killed:getPosition():sendMagicEffect(3)
                        killed:teleportTo(CACHE_GAMEAREAPOSITIONS[math.random(1, #CACHE_GAMEAREAPOSITIONS)])
                        killed:getPosition():sendMagicEffect(50)
                        killed:setStorageValue(10109, killed:getStorageValue(10109) - SnowBall_Configurations.Event_LostPoints)
                        killed:setStorageValue(10108, SnowBall_Configurations.Ammo_Configurations.Ammo_Restart)
                        killed:sendTextMessage(29, "You've been hit by the player " .. player:getName() .. " And lost -" .. SnowBall_Configurations.Event_LostPoints .." points.\nTotal of: " .. killed:getStorageValue(10109) .. " points")
 
                        player:setStorageValue(10109, player:getStorageValue(10109) + SnowBall_Configurations.Event_GainPoint)
                        player:sendTextMessage(29, "You just hit the player " .. killed:getName() .. " and won +" .. SnowBall_Configurations.Event_GainPoint .." points.\nTotal of: " .. player:getStorageValue(10109) .. " points")
 
                        if(CACHE_GAMEPLAYERS[2] == player:getId()) and player:getStorageValue(10109) >= Player(CACHE_GAMEPLAYERS[1]):getStorageValue(10109) then
                            player:getPosition():sendMagicEffect(7)
                            player:sendTextMessage(29, "You are now the leader of the SnowBall ranking, congratulations!")
                            Player(CACHE_GAMEPLAYERS[1]):getPosition():sendMagicEffect(16)
                            Player(CACHE_GAMEPLAYERS[1]):sendTextMessage(29, "You just lost the first place!")
                        end
 
                        table.getn(CACHE_GAMEPLAYERS, function(a, b) return Player(a):getStorageValue(10109) > Player(b):getStorageValue(10109) end)
                    else
 
                        newPos:sendMagicEffect(3)
                    end
                    return true
                end
 
                pos:sendDistanceEffect(newPos, 13)
                pos = newPos
                return addEvent(Event_sendSnowBall, SnowBall_Configurations.Ammo_Configurations.Ammo_Speed, player:getId(), pos, rounds - 1, dir)
            end
 
            newPos:sendMagicEffect(3)
            return true
        end
    end
    return true
end
 
function Event_endGame()
    local str = "       ## -> SnowBall Ranking <- ##\n\n"
 
    for rank, players in ipairs(CACHE_GAMEPLAYERS) do
        if SnowBall_Configurations.Positions_Rewards[rank] then
            for item_id, item_ammount in pairs(SnowBall_Configurations.Positions_Rewards[rank]) do
 
                Player(players):addItem(item_id, item_ammount)
            end
        end
 
        str = str .. rank .. ". " .. Player(players):getName() .. ": " .. Player(players):getStorageValue(10109) .. " points\n"
        Player(players):teleportTo(Player(players):getTown():getTemplePosition())
    end
 
    for _, cid in ipairs(CACHE_GAMEPLAYERS) do
        Player(cid):popupFYI(str)
    end
 
    broadcastMessage("[Snowball Event]: The event ended.")
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
 
function isInArena(player)
    local pos = player:getPosition()
 
    if pos.z == SnowBall_Configurations.Area_Configurations.Area_Arena[1].z then
        if pos.x >= SnowBall_Configurations.Area_Configurations.Area_Arena[1].x and pos.y >= SnowBall_Configurations.Area_Configurations.Area_Arena[1].y then
            if pos.x <= SnowBall_Configurations.Area_Configurations.Area_Arena[2].x and pos.y <= SnowBall_Configurations.Area_Configurations.Area_Arena[2].y then
                return true
            end
        end
    end
    return false
end