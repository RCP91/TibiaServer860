config_weekend_exp = {
	dates = {"Tuesday", "Wednesday", "Sunday"}, -- Dias da semana que será ativo
	rates = {
			{1, 1.05}, -- {quantidade de jogador online, taxa de bonus}
			{2, 1.10},
			{3, 1.15},
		},
	storage_bonus = 30303,
}

function get_bonus_weekend_exp()
	for _, rate in ipairs(config_weekend_exp.rates) do
		if #Game.getPlayers() >= rate[1] then
			if Game.getStorageValue(config_weekend_exp.storage_bonus) ~= 1 then
				broadcastMessage("[Weekend Exp Event] The server reached "..rate[1].." players online! The bonus of exp is now "..((rate[2] - 1)*100).."%!")
			end
			Game.setStorageValue(config_weekend_exp.storage_bonus, 1) --Bonus ativado
			return rate[2] --retornando a taxa de exp que deve ser adicionada
		else
			Game.setStorageValue(config_weekend_exp.storage_bonus, -1)
		end
	end
	return 1
end