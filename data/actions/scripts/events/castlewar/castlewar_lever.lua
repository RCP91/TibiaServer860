local config = {
	[13111] = Position(31884, 31838, 7),
	[13112] = Position(31884, 31850, 6),
	[13113] = Position(31878, 31841, 5),
	[13114] = Position(31876, 31850, 4)
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetPosition = config[item.actionid]
	if not targetPosition then
		return true
	end

	item:transform(item.itemid == 1945 and 1946 or 1945)

	if item.itemid ~= 1945 then
		return true
	end
	
	local dominant = CASTLE:getDominantGuild()
	local guild = player:getGuild()
	
	local resultId = db.storeQuery("SELECT * FROM `castle_web` WHERE `active` = 1;")
	local ress = tostring(result.getDataString(resultId, "guild_name"))
	local guild = player:getGuild():getName()
	
	if dominant == guild then
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:teleportTo(targetPosition)
	targetPosition:sendMagicEffect(CONST_ME_TELEPORT)
		else
	player:sendCancelMessage("Apenas a guild dominate pode utilizar esta alavanca.")
	end
	return true
end
