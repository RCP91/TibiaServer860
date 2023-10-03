local SHOP_MSG_TYPE = MESSAGE_STATUS_CONSOLE_BLUE
local SQL_interval = 30
--- ### Outfits List ###
local femaleOutfits = { 
	["Citizen"]={136},
	["Hunter"]={137},
	["Mage"]={138},
	["Knight"]={139},
	["Noblewoman"]={140},
	["Summoner"]={141},
	["Warrior"]={142},
	["Barbarian"]={147},
	["Druid"]={148},
	["Wizard"]={149},
	["Oriental"]={150},
	["Pirate"]={155},
	["Assassin"]={156},
	["Beggar"]={157},
	["Shaman"]={158},
	["Norsewoman"]={252},
	["Nightmare"]={269},
	["Jester"]={270},
	["Brotherhood"]={279},
	["Demon Hunter"]={288},
	["Yalaharian"]={324},
	["Newly Wed"]={329},
	["Warmaster"]={336},
	["Wayfarer"]={366},
	["Afflicted"]={431},
	["Elementalist"]={433},
	["Deepling"]={464},
	["Insectoid"]={466},
	["Entrepreneur"]={471},
	["Crystal Warlord"]={513},
	["Soil Guardian"]={514},
	["Demon Outfit"]={542},
	["Cave Explorer"]={575},
	["Dream Warden"]={578},
	["Jersey"]={620},
	["Champion"]={632},
	["Conjurer"]={635},
	["Beastmaster"]={636},
	["Chaos Acolyte"]={664},
	["Death Herald"]={666},
	["Ranger"]={683},
	["Ceremonial Garb"]={694},
	["Puppeteer"]={696},
	["Spirit Caller"]={698},
	["Evoker"]={724},
	["Seaweaver"]={732},
	["Recruiter"]={745},
	["Sea Dog"]={749},
	["Royal Pumpkin"]={759},
	["Rift Warrior"]={845},
	["Winter Warden"]={852},
	["Philosopher"]={874},
	["Arena Champion"]={885},
	["Lupine Warden"]={900},
	["Grove Keeper"]={909},
	["Festive Outfit"]={929},
	["Pharaoh"]={956},
	["Trophy Hunter"]={958},
	["Herbalist"]={1020},
	["Sun Priest"]={1024},
	["Makeshift Warrior"]={1043},
	["Siege Master"]={1050},
	["Mercenary"]={1057},
	["Discoverer"]={1095},
	["Sinister Archer"]={1103},
	["Pumpkin Mummy"]={1128},
	["Dream Warrior"]={1147},
	["Percht Raider"]={1162},
	["Owl Keeper"]={1174},
	["Guidon Bearer"]={1187},
	["Void Master"]={1203},
	["Veteran Paladin"]={1205},
	["Lion of War"]={1207},
	["Golden"]={1211},
	["Tomb Assassin"]={1244},
	["Poltergeist"]={1271},
	["Herder"]={1280}
}

local maleOutfits = { 
	["Festive Outfit"]={931},
	["Beggar"]={153},
	["Assassin"]={152},
	["Nightmare"]={268},
	["Yalaharian"]={325},
	["Conjurer"]={634},
	["Death Herald"]={667},
	["Recruiter"]={746},
	["Pirate"]={151},
	["Cave Explorer"]={574},
	["Elementalist"]={432},
	["Entrepreneur"]={472},
	["Jersey"]={619},
	["Demon Outfit"]={541},
	["Deepling"]={463},
	["Winter Warden"]={853},
	["Ceremonial Garb"]={695},
	["Ranger"]={684},
	["Norseman"]={251},
	["Brotherhood"]={278},
	["Chaos Acolyte"]={665},
	["Newly Wed"]={328},
	["Seaweaver"]={733},
	["Beastmaster"]={637},
	["Dream Warden"]={577},
	["Afflicted"]={430},
	["Puppeteer"]={697},
	["Soil Guardian"]={516},
	["Shaman"]={154},
	["Ranger"]={684},
	["Crystal Warlord"]={512},
	["Rift Warrior"]={846},
	["Grove Keeper"]={908},
	["Jester"]={273},
	["Oriental"]={146},
	["Insectoid"]={465},
	["Demon Hunter"]={289},
	["Wizard"]={145},
	["Warmaster"]={335},
	["Evoker"]={725},
	["Druid"]={144},
	["Arena Champion"]={884},
	["Barbarian"]={143},
	["Champion"]={633},
	["Sun Priest"]={1023},
	["Pumpkin Mummy"]={1127},
	["Siege Master"]={1051},
	["Discoverer"]={1094},
	["Sinister Archer"]={1102},
	["Makeshift Warrior"]={1042},
	["Dream Warrior"]={1146},
	["Mercenary"]={1056},
	["Herbalist"]={1021},
	["Percht Raider"]={1161},
	["Void Master"]={1202},
	["Veteran Paladin"]={1204},
	["Lion of War"]={1206},
	["Tomb Assassin"]={1243},
	["Golden"]={1210},
	["Owl Keeper"]={1173},
	["Poltergeist"]={1270},
	["Guidon Bearer"]={1186},
	["Herder"]={1279},
	["Warrior"]={134},
	["Spirit Caller"]={699},
	["Nobleman"]={132},
	["Lupine Warden"]={899},
	["Knight"]={131},
	["Citizen"]={128},
	["Hunter"]={129},
	["Trophy Hunter"]={957},
	["Mage"]={130},
	["Royal Pumpkin"]={760},
	["Wayfarer"]={367},
	["Philosopher"]={873},
	["Pharaoh"]={955}
}

function onThink(interval, lastExecution)
    local result_plr = db.storeQuery("SELECT * FROM z_ots_comunication")
    if(result_plr ~= false) then
        repeat
		
            local id = tonumber(result.getDataInt(result_plr, "id"))
            local action = tostring(result.getDataString(result_plr, "action"))
            local delete = tonumber(result.getDataInt(result_plr, "delete_it"))
            local cid = getPlayerByName(tostring(result.getDataString(result_plr, "name")))
			local player = Player(cid)
			
			if(cid) then
			
                local itemtogive_id = tonumber(result.getDataString(result_plr, "param1"))
                local itemtogive_count = tonumber(result.getDataString(result_plr, "param2"))
				local outfit_name = tostring(result.getDataString(result_plr, "param3"))
				local itemvip = tonumber(result.getDataString(result_plr, "param4"))
				local add_item_type = tostring(result.getDataString(result_plr, "param5"))
				local add_item_name = tostring(result.getDataString(result_plr, "param6"))
				local coins = tonumber(result.getDataInt(result_plr, "param7"))
				local received_item = 0
				local full_weight = 0
				
				if(action == 'give_item') then
					full_weight = getItemWeight(itemtogive_id, itemtogive_count)
					if isItemRune(itemtogive_id) == TRUE then
						full_weight = getItemWeight(itemtogive_id, 1)
					else
						full_weight = getItemWeight(itemtogive_id, itemtogive_count)
					end
					
					local free_cap = getPlayerFreeCap(cid)

					local new_item = doCreateItemEx(itemtogive_id, itemtogive_count)
					received_item = doPlayerAddItemEx(cid, new_item)
					
					if full_weight <= free_cap then
						if received_item == RETURNVALUE_NOERROR then
							doPlayerSendTextMessage(cid, SHOP_MSG_TYPE, 'You received >> '.. add_item_name ..' << FROM SHOP.')
							db.query("DELETE FROM `z_ots_comunication` WHERE `id` = " .. id .. ";")
						        db.query("UPDATE `z_shop_history_item` SET `trans_state`='realized', `trans_real`=" .. os.time() .. " WHERE id = " .. id .. ";")
						else
							doPlayerSendTextMessage(cid, SHOP_MSG_TYPE, '>> '.. add_item_name ..' << from OTS shop is waiting for you. Please make place for this item in your backpack/hands and wait about '.. SQL_interval ..' seconds to get it.')
						end
					else
						doPlayerSendTextMessage(cid, SHOP_MSG_TYPE, '>> '.. add_item_name ..' << from OTS shop is waiting for you. It weight is '.. full_weight ..' oz., you have only '.. free_cap ..' oz. free capacity. Put some items in depot and wait about '.. SQL_interval ..' seconds to get it.')
					end
				end
				
				if(action == 'give_premday') then
--local vipDays = {
   -- [itemid] = amount of vip days
  --  ["premium15days"] = 15,
   -- ["premium30days"] = 30,
    --["premium60days"] = 60,
    --["premium90days"] = 90,
    --["premium120days"] = 120
--}

	if(add_item_name == 'Premium Account') then
	player:addPremDays(15)
	doPlayerSendTextMessage(cid, SHOP_MSG_TYPE, 'You received >> '.. add_item_name ..' << FROM SHOP.')
	db.query("DELETE FROM `z_ots_comunication` WHERE `id` = " .. id .. ";")
	db.query("UPDATE `z_shop_history_item` SET `trans_state`='realized', `trans_real`=" .. os.time() .. " WHERE id = " .. id .. ";")
	elseif add_item_name == 'VIP30days' then
	player:addPremDays(30)
	doPlayerSendTextMessage(cid, SHOP_MSG_TYPE, 'You received >> '.. add_item_name ..' << FROM SHOP.')
	db.query("DELETE FROM `z_ots_comunication` WHERE `id` = " .. id .. ";")
	db.query("UPDATE `z_shop_history_item` SET `trans_state`='realized', `trans_real`=" .. os.time() .. " WHERE id = " .. id .. ";")
	elseif add_item_name == 'VIP60days' then
	player:addPremDays(60)
	doPlayerSendTextMessage(cid, SHOP_MSG_TYPE, 'You received >> '.. add_item_name ..' << FROM SHOP.')
	db.query("DELETE FROM `z_ots_comunication` WHERE `id` = " .. id .. ";")
	db.query("UPDATE `z_shop_history_item` SET `trans_state`='realized', `trans_real`=" .. os.time() .. " WHERE id = " .. id .. ";")	
	elseif add_item_name == 'VIP90days' then
	player:addPremDays(90)
	doPlayerSendTextMessage(cid, SHOP_MSG_TYPE, 'You received >> '.. add_item_name ..' << FROM SHOP.')
	db.query("DELETE FROM `z_ots_comunication` WHERE `id` = " .. id .. ";")
	db.query("UPDATE `z_shop_history_item` SET `trans_state`='realized', `trans_real`=" .. os.time() .. " WHERE id = " .. id .. ";")	
	elseif add_item_name == 'VIP120days' then
	player:addPremDays(120)
	doPlayerSendTextMessage(cid, SHOP_MSG_TYPE, 'You received >> '.. add_item_name ..' << FROM SHOP.')
	db.query("DELETE FROM `z_ots_comunication` WHERE `id` = " .. id .. ";")
	db.query("UPDATE `z_shop_history_item` SET `trans_state`='realized', `trans_real`=" .. os.time() .. " WHERE id = " .. id .. ";")	
	end
end
		if(action == 'give_outfit') then
					if outfit_name ~= "" and maleOutfits[outfit_name] and femaleOutfits[outfit_name] then
						local add_outfit = getPlayerSex(cid) == 0 and femaleOutfits[outfit_name][1] or maleOutfits[outfit_name][1]
						if not canPlayerWearOutfit(cid, add_outfit, 3) then
							db.query("DELETE FROM `z_ots_comunication` WHERE `id` = " .. id .. ";")
							doSendMagicEffect(getCreaturePosition(cid), CONST_ME_GIFT_WRAPS)
                			doPlayerAddOutfit(cid, add_outfit, 3)
							doPlayerSendTextMessage(cid, SHOP_MSG_TYPE, "You received the outfit " .. add_item_name .. " of our Shop Online.")
						else
							doPlayerSendTextMessage(cid, SHOP_MSG_TYPE, "You already have this outfit. Your coins were returned, thank you.")
							db.query("DELETE FROM `z_ots_comunication` WHERE `id` = " .. id .. ";")
							db.query("UPDATE `accounts` SET `premium_points` = `premium_points` + " .. coins .. " WHERE `id` = " .. getAccountNumberByPlayerName(cid) .. ";")
						end
					end
				end
			end
        until not result.next(result_plr)
        result.free(result_plr)
	end
	return true
end