function onThink(interval)
_Lib_BloodCastle_Days = {
	["Monday"] = { -- segunda
		["12:19"] = {players = 2}
	},	
	["Tuesday"] = { -- terça
		["22:00"] = {players = 2}
	},
	["Wednesday"] = { -- quarta
		["07:49"] = {players = 2}
	},
	["Thursday"] = { -- quinta
		["21:00"] = {players = 2}
	},
	["Saturday"] = { -- sabado
		["21:00"] = {players = 2}
	},		
	["Sunday"] = { -- domingo
		["23:39"] = {players = 2}
	}
}

	if _Lib_BloodCastle_Days[os.date("%A")] then
		hours = tostring(os.date("%X")):sub(1, 5)
		tb = _Lib_BloodCastle_Days[os.date("%A")][hours]
		if tb and (tb.players % 2 == 0) then
			local tp = Game.createItem(1387, 1, _Lib_BloodCastle_Info.tpPos)
			tp:setActionId(4726)
			CheckEventBlood(_Lib_BloodCastle_Info.limit_Time)
			Game.setStorageValue(_Lib_BloodCastle_Info.storage_count, tb.players)
			broadcastMessage("[Blood Castle] Um teleport foi criado no Event Room [Templo de Thais], voces tem ".. _Lib_BloodCastle_Info.limit_Time .." minutos para entrar, apenas " .. tb.players .. " jogadores poderao entrar.", MESSAGE_EVENT_ADVANCE)
		end
	end
	return true
end