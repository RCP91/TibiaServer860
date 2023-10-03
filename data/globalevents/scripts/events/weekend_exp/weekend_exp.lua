function onThink(interval)
	if table.find(config_weekend_exp.dates, os.date("%A")) then
		get_bonus_weekend_exp()
	end
	return true
end