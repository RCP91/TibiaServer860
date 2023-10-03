function onStepIn(creature, item, position, fromPosition)
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
	if item:getActionId() == 10105 then
		--table.insert(CACHE_WARGAMEPLAYERS, creature:getId())
		creature:setStorageValue(WarMaps_Configurations.Ammo_Configurations.Ammo_PointSkill, 0)
		creature:setStorageValue(WarMaps_Configurations.Ammo_Configurations.Ammo_AmmoBuy, 1)
		creature:teleportTo(info[Game.getStorageValue(storage)])
	end
	return true
end
