function onSay(player, words, param)
	if not isInArena(player) then
		return false
	end

	if param == "atirar" then
		if player:getExhaustion(SnowBall_Configurations.Ammo_Configurations.Ammo_SkillExhaustion) > 1 then
			return true
		end

		if not SnowBall_Configurations.Ammo_Configurations.Ammo_Infinity then
			if player:getStorageValue(SnowBall_Configurations.Ammo_Configurations.Ammo_PointSkill) > 0 then
				player:setStorageValue(SnowBall_Configurations.Ammo_Configurations.Ammo_PointSkill, player:getStorageValue(SnowBall_Configurations.Ammo_Configurations.Ammo_PointSkill) - 1)
				player:sendCancelMessage("Ainda restam ".. player:getStorageValue(SnowBall_Configurations.Ammo_Configurations.Ammo_PointSkill) .." snowballs.")
			else
				player:sendCancelMessage("You do not have snowballs.")
				return true
			end
		end

		player:setExhaustion(SnowBall_Configurations.Ammo_Configurations.Ammo_SkillExhaustion, SnowBall_Configurations.Ammo_Configurations.Ammo_Exhaust)
		Event_sendSnowBall(player:getId(), player:getPosition(), SnowBall_Configurations.Ammo_Configurations.Ammo_Distance, player:getDirection())
		return false
		elseif param == "info" then
		local str = "     ## -> Player Infos <- ##\n\nPoints: ".. player:getStorageValue(SnowBall_Configurations.Ammo_Configurations.Ammo_PointSkill) .."\nSnowballs: ".. player:getStorageValue(SnowBall_Configurations.Ammo_Configurations.Ammo_PointSkill)

		str = str .. "\n\n          ## -> Ranking <- ##\n\n"
		for i = 1, 5 do
			if CACHE_GAMEPLAYERS[i] then
				str  = str .. i .. ". " .. Player(CACHE_GAMEPLAYERS[i]):getName() .."\n"
			end
		end
		for pos, players in ipairs(CACHE_GAMEPLAYERS) do
			if player:getId() == players then
				str = str .. "My Ranking Pos: " .. pos
			end
		end

		player:popupFYI(str)
		return false
	end
end