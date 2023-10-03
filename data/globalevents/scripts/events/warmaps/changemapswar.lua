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

function onThink(interval, lastExecution) 

               if Game.getStorageValue(storage) < 6 then  
               Game.setStorageValue(storage, Game.getStorageValue(storage)+1)   
               else  
               Game.setStorageValue(storage, Game.getStorageValue(storage)-6)
               end  
               for _, pid in ipairs(Game.getPlayers()) do 
			   if pid:getStorageValue(WarMaps_Configurations.Ammo_Configurations.Ammo_AmmoBuy) >= 1 then
			   if pid:getSkull() then
			   pid:setSkull(SKULL_NONE)
				pid:setSkullTime(0)
			end
          		doPlayerRemoveLethalConditions(pid)
				pid:addHealth(pid:getMaxHealth())
				pid:addMana(pid:getMaxMana()) 
			   pid:teleportTo(info[Game.getStorageValue(storage)])
			   pid:setStorageValue(WarMaps_Configurations.Ammo_Configurations.Ammo_PointSkill, 0)
			   pid:sendTextMessage(MESSAGE_STATUS_WARNING, "The map has been changed and all players have been teleported to the respective temple. Next map change will be in 15 minutes!")
               end 
			   end
  
			for rank, players in ipairs(CACHE_WARGAMEPLAYERS) do
			if WarMaps_Configurations.Positions_Rewards[rank] then
            for item_id, item_ammount in pairs(WarMaps_Configurations.Positions_Rewards[rank]) do
                Player(players):addItem(item_id, item_ammount)
				end
			end
		end
		     return true  
end