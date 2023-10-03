local SHOP_MSG_TYPE = MESSAGE_STATUS_CONSOLE_RED
local SQL_interval = 30
function generateSerial()
  --local lettersUsedToGenerateHash = "AaBbCcDdEeFfGgHhIiJjKkLlMmOoPpQqRrSsTtUuVvWwXxYyZz"
	local lettersUsedToGenerateHash = "ABCDEFGHIJKLMOPQRSTUVWXYZ"
	local newSerial = "!"
	for k = 1, 10 do
		local l = math.random(1, string.len(lettersUsedToGenerateHash))
		newSerial = newSerial .. string.sub(lettersUsedToGenerateHash, l, l)
	end
	local newSerialInt  = math.random(999999)
	newSerial = newSerial .."-" .. newSerialInt
	-- Set TIME -> newSerial = newSerialStr .. "-" .. os.time() .. "-" .. newSerialInt
	-- length: ![10 letters]-[10 numbers (unix date)]-[6 numbers]
	-- length = 29 [always!]
	return newSerial
end 
function onThink(interval, lastExecution)
	local resultId = db.storeQuery("SELECT * FROM z_ots_comunication WHERE `type` = 'login';")
    if resultId ~= false then
		while(true) do
			local id = tonumber(result:getDataInt(resultId, "id"))
			local action = tostring(result:getDataString(resultId, "action"))
			local delete = tonumber(result:getDataInt(resultId, "delete_it"))
			local cid = getPlayerByName(tostring(result:getDataString(resultId, "name")))
			if isPlayer(cid) then
				local itemtogive_id = tonumber(result:getDataInt(resultId, "param1"))
				local itemtogive_count = tonumber(result:getDataInt(resultId, "param2"))
				local container_id = tonumber(result:getDataInt(resultId, "param3"))
				local container_count = tonumber(result:getDataInt(resultId, "param4"))
				local add_item_type = tostring(result:getDataString(resultId, "param5"))
				local add_item_name = tostring(result:getDataString(resultId, "param6"))
				local received_item = 0
				local full_weight = 0
				if add_item_type == 'container' then
					container_weight = getItemWeightById(container_id, 1)
					if isItemRune(itemtogive_id) == TRUE then
						items_weight = container_count * getItemWeightById(itemtogive_id, 1)
					else
						items_weight = container_count * getItemWeightById(itemtogive_id, itemtogive_count)
					end
					full_weight = items_weight + container_weight
				else
					full_weight = getItemWeightById(itemtogive_id, itemtogive_count)
					if isItemRune(itemtogive_id) == TRUE then
						full_weight = getItemWeightById(itemtogive_id, 1)
					else
						full_weight = getItemWeightById(itemtogive_id, itemtogive_count)
					end
				end
				local free_cap = getPlayerFreeCap(cid)
				if full_weight <= free_cap then
					if add_item_type == 'container' then
						local new_container = doCreateItemEx(container_id, 1)
						local iter = 0
						while iter ~= container_count do
							doAddContainerItem(new_container, itemtogive_id, itemtogive_count)
							iter = iter + 1
						end
						received_item = doPlayerAddItemEx(cid, new_container)
					else
						local new_item = doCreateItemEx(itemtogive_id, itemtogive_count)
						--doItemSetAttribute(new_item, "description",  "Name: ".. getPlayerName(cid) ..". Data: ".. os.date("%d %B %Y Hora: %X. ").."Serial: "..generateSerial().."")
						doItemSetAttribute(new_item, "description", "Serial: "..generateSerial().."")
						--doItemSetAttribute(new_item, "description", "This item was purchased at the shop by the player ".. getPlayerName(cid) ..".")
						--doItemSetAttribute(new_item, "aid", getPlayerGUID(cid)+10000)
						received_item = doPlayerAddItemEx(cid, new_item)
					end
					if received_item == RETURNVALUE_NOERROR then
						doPlayerSendTextMessage(cid, SHOP_MSG_TYPE, '{Shopping System} Entrega do Item '.. add_item_name ..' Feita com Sucesso!.')
						db.query("DELETE FROM `z_ots_comunication` WHERE `id` = " .. id .. ";")
						db.query("UPDATE `z_shop_history_item` SET `trans_state`='realized', `trans_real`=" .. os.time() .. " WHERE id = " .. id .. ";")
					else
						doPlayerSendTextMessage(cid, SHOP_MSG_TYPE, ' {Shopping System} Sua Backpack Nao Tem Espaco Para Receber o Item '.. add_item_name ..' Por Favor Abra Espaco em Sua Backpack, Estaremos Tentando Entregar o Item Em '.. SQL_interval ..' Segundos!.')
					end
				else
					doPlayerSendTextMessage(cid, SHOP_MSG_TYPE, '>> '.. add_item_name ..' << from OTS shop is waiting for you. It weight is '.. full_weight ..' oz., you have only '.. free_cap ..' oz. free capacity. Put some items in depot and wait about '.. SQL_interval ..' seconds to get it.')
				end
			end
			if not(result:next()) then
				break
			end
		end
		result:free()
	end
	return true
end