function onThink(interval)
_Lib_Bomberman_Days = {
	["Monday"] = { -- segunda
		["14:00"] = {players = 4}
	},	
	["Tuesday"] = { -- terça
		["14:00"] = {players = 4}
	},
	["Wednesday"] = { -- quarta
		["14:00"] = {players = 4}
	},
	["Thursday"] = { -- quinta
		["14:00"] = {players = 2}
	},
	["Saturday"] = { -- sabado
		["14:00"] = {players = 4}
	},		
	["Sunday"] = { -- domingo
		["14:00"] = {players = 4}
	},
	["Friday"] = { -- sexta
		["14:00"] = {players = 4}
	}
}

	if _Lib_Bomberman_Days[os.date("%A")] then
		hours = tostring(os.date("%X")):sub(1, 5)
		tb = _Lib_Bomberman_Days[os.date("%A")][hours]
		if tb and (tb.players % 2 == 0) then
			local tp = Game.createItem(1387, 1, BOMBERMAN_MINIGAME.tpPos)
			tp:setActionId(45001)
			CheckEventBomberman(BOMBERMAN_MINIGAME.limit_Time)
			Game.setStorageValue(BOMBERMAN_MINIGAME.storage_count, tb.players)
			Game.setStorageValue(BOMBERMAN_MINIGAME.storage_bomberman, 1)
			broadcastMessage("[Bomberman] Um teleport foi criado no [Templo de Thais], voces tem 10 minutos para entrar, apenas " .. tb.players .. " jogadores poderao entrar.", MESSAGE_EVENT_ADVANCE)
		end
	end
	return true
end