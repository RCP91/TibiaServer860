local config = {
	levelRequiredToAdd = 20,
	maxOffersPerPlayer = 5,
	valuePerOffer = 500,
	blockedItems = {2165, 2152, 2148, 2160, 2166, 2167, 2168, 2169, 2202, 2203, 2204, 2205, 2206, 2207, 2208, 2209, 2210, 2211, 2212, 2213, 2214, 2215, 2343, 2433, 2640, 6132, 6300, 6301, 9932, 9933}
}

function onSay(player, words, param)
	if param == '' then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Command param required.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	elseif not Tile(player:getPosition()):hasFlag(TILESTATE_PROTECTIONZONE) then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You must be in the protection zone to use these commands.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	elseif player:getExhaustion(Storage.exhaustion) > 0 then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You need to wait a time.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local word = param:split(",")
	if word[1] == "add" then
		if not word[2] or not word[3] or not word[4] then
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Command param required. Ex: !tradeoff add, ItemName, ItemCount, ItemPrice")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end
		
		local itemCount = tonumber(word[3])
		local itemValue = tonumber(word[4])
		if not itemCount or not itemValue then
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You don't set valid price or items count.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		elseif itemCount < 1 or itemValue < 1 then
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You have to type a number higher than 0.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		elseif string.len(itemCount) > 3 or string.len(itemValue) > 90 then
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "This price or item count is too high.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		elseif player:getLevel() < config.levelRequiredToAdd then
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You don't have required level ".. config.levelRequiredToAdd ..".")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end

		player:setExhaustion(Storage.exhaustion, 5)

		local offers = 0
		local playerId = player:getGuid()
		local resultId = db.storeQuery("SELECT `id` FROM `auction_system` WHERE `player_id` = " .. playerId)
		if resultId ~= false then
			repeat
				offers = offers + 1
			until not result.next(resultId)
			result.free(resultId)
		end

		if offers >= config.maxOffersPerPlayer then
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Sorry you can't add more offers (max. " .. config.maxOffersPerPlayer .. ")")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end

		-- Trim left
		word[2] = word[2]:gsub("^%s*(.-)$", "%1")

		local itemId = ItemType(word[2]):getId()
		itemCount = math.floor(itemCount)
		if itemId == 0 then
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Item wich such name does not exists.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		elseif table.contains(config.blockedItems, itemId) then
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "This item is blocked.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		elseif player:getItemCount(itemId) < itemCount then
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Sorry, you don't have this item(s).")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end

		if player:getMoney() >= config.valuePerOffer then
			if not player:removeItem(itemId, itemCount) then
				player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You do not have the necessary items!")
				player:getPosition():sendMagicEffect(CONST_ME_POFF)
				return false
			elseif not player:removeMoney(config.valuePerOffer) then
				player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You need ".. config.valuePerOffer .." gold coins to add an offer in auction system.")
				player:getPosition():sendMagicEffect(CONST_ME_POFF)
				return false
			else
				local itemName = ItemType(itemId):getName()
				itemValue = math.floor(itemValue)
				db.query("INSERT INTO `auction_system` (`player_id`, `item_name`, `item_id`, `count`, `value`, `date`) VALUES (" .. playerId .. ", \"" .. db.escapeString(itemName) .. "\", " .. itemId .. ", " .. itemCount .. ", " .. itemValue ..", " .. os.time() .. ")")
				player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You successfully add " .. itemCount .." " .. itemName .." for " .. itemValue .. " gold coins to auction system.")
			end
		else
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You need ".. config.valuePerOffer .." gold coins to add an offer in auction system.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
		end

		return false

	elseif word[1] == "buy" then

		if not word[2] then
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Command param required. Ex: /offer buy, AuctionID")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end

		local id = tonumber(word[2])
		if not id then
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Wrong ID.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end

		player:setExhaustion(Storage.exhaustion, 5)

		local resultId = db.storeQuery("SELECT * FROM `auction_system` WHERE `id` = " .. id)
		if resultId == false then
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "This offer does not exist.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end

		local playerId = result.getNumber(resultId, "player_id")
		local itemValue = result.getNumber(resultId, "value")
		local itemId = result.getNumber(resultId, "item_id")
		local itemCount = result.getNumber(resultId, "count")
		result.free(resultId)

		if player:getGuid() == playerId then
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Sorry, you can't buy your own items.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		elseif player:getFreeCapacity() < ItemType(itemId):getWeight() then
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You don't have capacity.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		elseif not player:removeMoney(itemValue) then
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You don't have enoguh gold coins.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		else
			player:addItem(itemId, itemCount)
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You bought " .. itemCount .. " ".. ItemType(itemId):getName() .. " for " .. itemValue .. " gold coins in auction system!")
			db.query("DELETE FROM `auction_system` WHERE `id` = " .. id)
			local seller = Player(playerId)
			if seller then
				seller:setBankBalance(seller:getBankBalance() + itemValue)
			else
				db.query('UPDATE `players` SET `auction_balance` = `auction_balance` + ' .. itemValue .. ' WHERE `id` = ' .. playerId)
			end
		end

		return false

	elseif word[1] == "remove" then

		if not word[2] then
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Command param required. Ex: /offer remove, AuctionID")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end

		local id = tonumber(word[2])
		if not id then
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Wrong ID.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end

		player:setExhaustion(Storage.exhaustion, 5)

		local resultId = db.storeQuery("SELECT * FROM `auction_system` WHERE `id` = " .. id)
		if resultId == false then
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "This offer does not exist.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end

		local playerId = result.getNumber(resultId, "player_id")
		local itemId = result.getNumber(resultId, "item_id")
		local itemCount = result.getNumber(resultId, "count")
		result.free(resultId)

		if player:getGuid() == playerId then
			if player:getFreeCapacity() < ItemType(itemId):getWeight() then
				player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You don't have capacity.")
				player:getPosition():sendMagicEffect(CONST_ME_POFF)
			else
				db.query("DELETE FROM `auction_system` WHERE `id` = " .. id)
				player:addItem(itemId, itemCount)
				player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Your offert has been deleted from offerts database.")
			end
		else
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "This is not your offert.")
		end

		return false

	elseif word[1] == "list" then

		player:setExhaustion(Storage.exhaustion, 5)

		local message = "Trade Offline:\n\n!tradeoff add, ItemName, ItemCount, ItemPrice\n!tradeoff buy, AuctionID\n!tradeoff remove, AuctionID\n\n"
		local resultId = db.storeQuery("SELECT * FROM `auction_system` ORDER BY `id` ASC")
		if resultId ~= false then
			repeat
				local auctionId = result.getNumber(resultId, "id")
				local itemId = result.getNumber(resultId, "item_id")
				local itemCount = result.getNumber(resultId, "count")
				local itemValue = result.getNumber(resultId, "value")
				message = ""..message.."ID: ".. auctionId .." - ".. itemCount .." ".. ItemType(itemId):getName() .." for ".. itemValue .." gold coins.\n"
			until not result.next(resultId)
			result.free(resultId)
			player:popupFYI(message)
		else
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "There is not offer in the system.")
		end
	end
	
if(word[1] == "balance") then
        local consulta = db.storeQuery("SELECT * FROM `players` WHERE `id` = " .. player:getGuid() .. ";")
        local balance = result.getNumber(consulta, "auction_balance")
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Your balance is: " .. balance .. " gps!")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Your balance is: " .. balance .. " gps!")
        return true
    end
	
if(word[1] == "withdraw") then
    if((not tonumber(word[2]))) then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Sorry, only numbers are accepted.")
        return true
    end
    local balance = db.storeQuery("SELECT * FROM `players` WHERE `id` = " .. player:getGuid() .. ";")
    local auction_balance = result.getNumber(balance, "auction_balance")
    if(auction_balance < 1) then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You do not have enough balance to withdraw.")
        result.free(balance)
        return true
    end
    local tz = auction_balance - word[2]
    player:sendTextMessage(MESSAGE_INFO_DESCR, "You got it " .. word[2] .. " gps of your sales in the market! Your balance is: "..tz.."gps.")
    player:addMoney(tz)
    db.query("UPDATE `players` SET `auction_balance` = ".. tz .." WHERE `id` = " .. player:getGuid() .. ";")
    result.free(balance)
	end
        return true
end