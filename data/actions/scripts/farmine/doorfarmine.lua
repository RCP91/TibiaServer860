function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if(item.aid == 12134) then
		if(player:setStorageValue(Storage.WhiteRavenMonasteryQuest.Passage)) then
			return (player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "."))
		end
		if(player:setStorageValue(Storage.WhiteRavenMonasteryQuest.Passage)) then
			if(item.itemid == 8553) then
				player:teleportTo(toPosition, true)
				item:transform(item.itemid + 1)
			end
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "")
		end
	end
	return true
end
