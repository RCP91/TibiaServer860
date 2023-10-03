local config = {
	bossName = "Urmahlullu the Weakened", -- Nome do Boss que será criado.
	lockStorage = 9673093555, -- globalstorage
	bossPos = Position(33919, 31642, 8), -- Posição do boss nascer. 
	centerRoom = Position(33918, 31648, 8), -- Centro da sala para parametro de limpar a sala ao final. --lockStorage = 96730935- /vou tentar coloca sem.
	exitPosition = Position(33920, 31609, 8), -- Posição para onde sera teleportado ao ser kikado.
	newPos = Position(33919, 31659, 8), -- Posição para onde sera teleportado.
	range = 10,
	time = 10, -- time in minutes to remove the player	
}	


local function clearOberonRoom()
	if Game.getStorageValue(config.lockStorage) == 1 then
		local spectators = Game.getSpectators(config.bossPos, false, false, 13, 13, 13, 13) --X = , --
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
	if item.itemid == 9825 and item.actionid == 33001 then -- ID da alavanca OU QUALQUER ITEM, e em seguida ACTION ID que está na alavanca.
		if player:getPosition() ~= Position(33918, 31626, 8) then -- Posição em frente a Alavanca
			return true
		end
			
	for x = 33918, 33922 do -- Posições que serão teleportadas, colocar quantas estão na ordenação de X ou se for  Y trocar no começo e na frase abaixo.
	local playerTile = Tile(Position(x, 31626, 8)):getTopCreature() -- Configurar a posição fixa se é X ou Y e numero do andar que está.
		if playerTile and playerTile:isPlayer() then 
			if playerTile:getStorageValue(9673093555) > os.time() then -- STORAGE para contar Horas para fazer de novo, ou impedir de fazer de novo X quest.
				playerTile:sendTextMessage(MESSAGE_STATUS_SMALL, "You or a member in your team have to wait 20 hours to challange Urmahlullu the Weakened again!")
				item:transform(9826) -- ID da alavanca OU ITEM depois de ter dado USE.
				return true
			end
		end
	end			
	
	local specs, spec = Game.getSpectators(config.centerRoom, false, false, 15, 15, 15, 15) --Tamanho da area a ser limpada ao limpar a sala ou ao entrar novo player -- 
	for i = 1, #specs do
		spec = specs[i]
		if spec:isPlayer() then
			player:sendTextMessage(MESSAGE_STATUS_SMALL, "There's someone fighting with Urmahlullu the Weakened.")
			item:transform(9826) -- ID da ALAVANCA OU ITEM deopois de ter dado USE.
			return true
		end
	end	
			
	if Game.getStorageValue(config.lockStorage) == 1 then
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "You need wait 12 minutes to room cleaner!")
		return true
	end
	
	local spectators = Game.getSpectators(config.bossPos, false, false, 15, 15, 15, 15) -- Tamanho da area a ser checada se tem alguem dentro lutando.
	for i = 1, #spectators do
		local spectator = spectators[i]
		if spectator:isMonster() then
			spectator:remove()
		end
	end

	Game.createMonster(config.bossName, config.bossPos, true, true)	
	Game.setStorageValue(config.lockStorage, 1)
	for x = 33918, 33922 do -- Posições que serão teleportadas, colocar quantas estão na ordenação de X ou se for  Y trocar no começo e na frase abaixo.
		local playerTile = Tile(Position(x, 31626, 8)):getTopCreature() -- Configurar a posição fixa se é X ou Y e numero do andar que está.
		if playerTile and playerTile:isPlayer() then 					
			playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
			playerTile:teleportTo(config.newPos)
			playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)	
			playerTile:setStorageValue(9673093555, os.time() + 20 * 3600) -- STORAGE que identifica que o player fez tal quest,  + 20 * 3600 = 20 hrs para fazer de novo.
			addEvent(clearOberonRoom, 60 * config.time * 1440, playerTile:getId(), config.centerRoom, config.range, config.range, config.exitPosition) --* 1120 = 12 minutos para matar boss e para limpar a sala.
			playerTile:sendTextMessage(MESSAGE_STATUS_SMALL, "You have 12 minutes to kill and loot this boss. Otherwise you will lose that chance and will be kicked out.")
			item:transform(9826) -- ID da alavanca OU ITEM de qualquer escolha depois de usada.
		end
	end
	
elseif item.itemid == 9826 then -- ID da alavanca OU ITEM de qualquer escolha depois de usada.
		item:transform(9825) -- ID da alavanca OU ITEM de qualquer escolha SEM DAR USE !
	end
		return true
end