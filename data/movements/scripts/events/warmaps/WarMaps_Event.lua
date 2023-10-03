function onStepIn(creature, item, position, fromPosition)
	if item:getActionId() == 10103 then
		table.insert(CACHE_WARGAMEPLAYERS, creature:getId())
		creature:teleportTo(WarMaps_Configurations.Area_Configurations.Position_WaitRoom)
		elseif item:getActionId() == 10104 then
		creature:teleportTo(creature:getTown():getTemplePosition())
		creature:setStorageValue(WarMaps_Configurations.Ammo_Configurations.Ammo_PointSkill, -1)
		for pos, players in ipairs(CACHE_WARGAMEPLAYERS) do
			if creature:getId() == players then
				table.remove(CACHE_WARGAMEPLAYERS, pos)
				return true
			end
		end
	end
	return true
end