function onLogin(player)
	player:registerEvent("warmapslogin")
	if player:getStorageValue(WarMaps_Configurations.Ammo_Configurations.Ammo_AmmoBuy) >= 1 then
		player:setStorageValue(WarMaps_Configurations.Ammo_Configurations.Ammo_AmmoBuy, -1)
		player:setStorageValue(WarMaps_Configurations.Ammo_Configurations.Ammo_PointSkill, -1)
		player:teleportTo(player:getTown():getTemplePosition())
	end
		--for pos, players in ipairs(CACHE_WARGAMEPLAYERS) do
			--if player:getId() == players then
				--table.remove(CACHE_WARGAMEPLAYERS, pos)
				--return true
			--end
		--end
	return true
end

function onPrepareDeath(creature, killer)
info = {  
[0] = {x=28650,y=29090,z=7},
[1] = {x=28656,y=29373,z=7},
[2] = {x=28981,y=29358,z=7},
[3] = {x=28960,y=29172,z=7},
[4] = {x=28847,y=29149,z=7},
[5] = {x=28874,y=28780,z=7},
[6] = {x=28862,y=28926,z=7}
}

storage = 789520
			   if creature:getStorageValue(WarMaps_Configurations.Ammo_Configurations.Ammo_AmmoBuy) >= 1 then
			   if creature:getSkull() then
			   creature:setSkull(SKULL_NONE)
			   creature:setSkullTime(0)
			   end
			   creature:sendTextMessage(MESSAGE_INFO_DESCR, "[Ultra War] You are dead.")
				creature:addHealth(creature:getMaxHealth())
				creature:addMana(creature:getMaxMana()) 
				creature:teleportTo(info[Game.getStorageValue(storage)])
				killer:setStorageValue(WarMaps_Configurations.Ammo_Configurations.Ammo_PointSkill, killer:getStorageValue(WarMaps_Configurations.Ammo_Configurations.Ammo_PointSkill) + WarMaps_Configurations.Event_GainFrags)
				table.sort(CACHE_WARGAMEPLAYERS, function(a, b) return Player(a):getStorageValue(1012) > Player(b):getStorageValue(1012) end)
                     if(CACHE_WARGAMEPLAYERS[2] == killer:getId()) and killer:getStorageValue(1012) >= Player(CACHE_WARGAMEPLAYERS[1]):getStorageValue(1012) then
                            killer:getPosition():sendMagicEffect(7)
                            killer:sendTextMessage(29, "You are now the leader of the Ultra Event ranking, congratulations!")
                            Player(CACHE_WARGAMEPLAYERS[1]):getPosition():sendMagicEffect(16)
                            Player(CACHE_WARGAMEPLAYERS[1]):sendTextMessage(29, "You just lost the first place!")
                        end
               end 
	return true
end