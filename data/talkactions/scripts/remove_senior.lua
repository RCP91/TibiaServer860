function onSay(player, words, param)
	if player:getAccountType() < ACCOUNT_TYPE_GOD then
		return false
	end

	local resultId = db.storeQuery("SELECT `name`, `account_id`, (SELECT `type` FROM `accounts` WHERE `accounts`.`id` = `account_id`) AS `account_type` FROM `players` WHERE `name` = " .. db.escapeString(param))
	if resultId == false then
		player:sendCancelMessage("A player with that name does not exist.")
		return false
	end

	if result.getNumber(resultId, "account_type") ~= ACCOUNT_TYPE_SENIORTUTOR then
		player:sendCancelMessage("You can only demote a Senior tutor to a normal player.")
		return false
	end

	local target = Player(param)
	if target ~= nil then
		target:setAccountType(ACCOUNT_TYPE_NORMAL)
		target:setStorageValue(15956, -1)
	else
		db.query("UPDATE `accounts` SET `type` = " .. ACCOUNT_TYPE_NORMAL .. " WHERE `id` = " .. result.getNumber(resultId, "account_id"))
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have demoted " .. result.getString(resultId, "name") .. " to a normal player.")
	result.free(resultId)
	return false
end
