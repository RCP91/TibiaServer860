function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(SnowBall_Configurations.Ammo_Configurations.Ammo_AmmoBuy) > 0 and player:getStorageValue(SnowBall_Configurations.Ammo_Configurations.Ammo_PointSkill) <= 30  then

		player:setStorageValue(SnowBall_Configurations.Ammo_Configurations.Ammo_PointSkill, player:getStorageValue(SnowBall_Configurations.Ammo_Configurations.Ammo_PointSkill) + SnowBall_Configurations.Ammo_Configurations.Ammo_Ammount)
		player:setStorageValue(SnowBall_Configurations.Ammo_Configurations.Ammo_AmmoBuy, player:getStorageValue(SnowBall_Configurations.Ammo_Configurations.Ammo_AmmoBuy) - SnowBall_Configurations.Ammo_Configurations.Ammo_Price)
		player:sendTextMessage(29, "You just bought ".. SnowBall_Configurations.Ammo_Configurations.Ammo_Ammount .." snowballs for ".. SnowBall_Configurations.Ammo_Configurations.Ammo_Price .."\nYou have ".. player:getStorageValue(SnowBall_Configurations.Ammo_Configurations.Ammo_PointSkill) .." snowballs\nYou have ".. player:getStorageValue(SnowBall_Configurations.Ammo_Configurations.Ammo_AmmoBuy) .." point(s).")
		elseif player:getStorageValue(SnowBall_Configurations.Ammo_Configurations.Ammo_AmmoBuy) < 1 then
		player:sendCancelMessage("You dont have ".. SnowBall_Configurations.Ammo_Configurations.Ammo_Price .." point(s).")
		elseif player:getStorageValue(SnowBall_Configurations.Ammo_Configurations.Ammo_PointSkill) > 30 then
		player:sendCancelMessage("You can only buy snowballs with a minimum of 30 balls.")
	end
    return true
end