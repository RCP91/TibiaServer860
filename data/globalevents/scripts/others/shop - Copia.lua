-- ### CONFIG ###
-- message to player "type", if delivery of item debugs client, it can be because of undefinied type (type that does not exist in your server LUA)
SHOP_MSG_TYPE = MESSAGE_EVENT_ADVANCE
-- ### END OF CONFIG ###
MESSAGE_ERROR_CONTACT = "[ERRO] Shop Donate. Contate o Administrador! Erro disponível no Console."

local MountsShop = {
    -- VIP Mounts
    [80099] = 104,
    -- Normal Mounts
    [80032] = 33,
    [80040] = 41,
    [80022] = 23,
    [80008] = 9,
    [80030] = 37,
    [80033] = 34,
    [80035] = 36,
    [80043] = 45,
    [80044] = 46,
    [80045] = 47,
    [80046] = 48,
    [80047] = 49,
    [80048] = 50,
    [80049] = 51,
    [80050] = 52,
    [80051] = 53,
    [80052] = 54,
    [80053] = 55,
    [80054] = 56,
    [80055] = 57,
    [80056] = 58,
    [80057] = 59,
    [80058] = 60,
    [80060] = 62,
    [80062] = 64,
    [80063] = 65,
    [80064] = 66,
    [80065] = 67,
    [80067] = 69,
    [80068] = 70,
    [80069] = 71,
    [80071] = 73,
    [80072] = 74,
    [80073] = 75,
    [80080] = 82,
    [80081] = 83,
    [80082] = 84,
    [80087] = 89,
    [80088] = 90,
    [80089] = 91
}

local AddonsShop = {
	  --[storage] = {outfit_male, outfit_female},
	[28416] = {128, 136}, -- Citizen
	[28417] = {129, 137}, -- Hunter
	[28418] = {130, 138}, -- Mage
	[28419] = {131, 139}, -- Knight
	[28420] = {132, 140}, -- Nobleman
	[28421] = {133, 141}, -- Summoner
	[28422] = {134, 142}, -- Warrior
	[28423] = {143, 147}, -- Barbarian
	[28424] = {144, 148}, -- Druid
	[28425] = {145, 149}, -- Wizard
	[28426] = {146, 150}, -- Oriental
	[28427] = {151, 155}, -- Pirate
	[28428] = {152, 156}, -- Assassin
	[28429] = {153, 157}, -- Beggar
	[28430] = {154, 158}, -- Shaman
	[28431] = {251, 252}, -- Norseman
	[28432] = {268, 269}, -- Nightmare
	[28433] = {273, 270}, -- Jester
	[28434] = {278, 279}, -- Brotherhood
	[28435] = {289, 288}, -- Demonhunter
	[28436] = {325, 324}, -- Yalaharian
	[28437] = {328, 329}, -- Husband
	[28438] = {335, 336}, -- Warmaster
	[28439] = {367, 366}, -- Wayfarer
	[28440] = {430, 431}, -- Afflicted
	[28441] = {432, 433}, -- Elementalist
	[28442] = {463, 464}, -- Deepling
	[28443] = {465, 466}, -- Insectoid
	[28444] = {472, 471}, -- Entrepreneur
	[28445] = {512, 513}, -- Crystal Warlord
	[28446] = {516, 514}, -- Soil Guardian
	[28447] = {541, 542}, -- Demon
	[28448] = {574, 575}, -- Cave Explorer
	[28449] = {577, 578}, -- Dream Warden
	[28450] = {610, 618}, -- Glooth Engineer
	[28451] = {619, 620}, -- Jersey
	[28452] = {633, 632}, -- Champion
	[28453] = {634, 635}, -- Conjurer
	[28454] = {637, 636}, -- Beastmaster
	[28455] = {665, 664}, -- Chaos Acolyte
	[28456] = {667, 666}, -- Death Herald
	[28457] = {684, 683}, -- Ranger
	[28458] = {695, 694}, -- Ceremonial Garb
	[28459] = {697, 696}, -- Puppeteer
	[28460] = {699, 698}, -- Spirit Caller
	[28461] = {725, 724}, -- Evoker
	[28462] = {733, 732}, -- Seaweaver
	[28463] = {746, 725}, -- Recruiter
	[28464] = {750, 749}, -- Sea Dog
	[28465] = {760, 759}, -- Royal Pumpkin
	[28466] = {846, 845}, -- Rift Warrior
	[28467] = {853, 852},  -- Winter Warden
	[28468]	= {874, 873}, -- Philosopher
	[28469]	= {884, 885}, -- Arena Champion
	[28470]	= {899, 900} -- Lupine Warden
}

function onThink(interval, lastExecution)
    local resultId = db.storeQuery("SELECT * FROM z_ots_comunication")
    if resultId ~= false then
        repeat
            local transactionId = tonumber(result.getDataInt(resultId, "id"))
            local player = Player(result.getDataString(resultId, "name"))
			local action = tostring(result.getDataString(resultId, "action"))
            local delete = tonumber(result.getDataInt(resultId, "delete_it"))

            if player then

				
				local itemId = tonumber(result.getDataInt(resultId, "param1"))
local itemCount = tonumber(result.getDataInt(resultId, "param2"))
local containerId = tonumber(result.getDataString(resultId, "param3"))
local containerItemsInsideCount = tonumber(result.getDataInt(resultId, "param4"))
local shopOfferType = result.getDataString(resultId, "param5")
local shopOfferName = result.getDataString(resultId, "param6")
				local coins = tonumber(result.getDataInt(resultId, "param7"))
				local received_item = 0
				local full_weight = 0

-- DELIVER ITEM
                if shopOfferType == 'item' then
                    local newItemUID = doCreateItemEx(itemId, itemCount)
                    --  item does not exist, wrong id OR count
                    if not newItemUID then
                        player:sendTextMessage(SHOP_MSG_TYPE, 'Website Shop bugged. Contact with administrator! Error is visible in server console.')
                        print('ERROR! Website Shop (' .. player:getName() .. ') - cannot create item - invalid item ID OR count - ITEM ID: ' .. itemId .. ', ITEM COUNT: ' .. itemCount)
                        return true
                    end
                    -- change item UniqueID to object of class Item
                    local newItem = Item(newItemUID)
                    -- get player BACKPACK as container, so we can add item to it
                    local playerStoreInbox = player:getSlotItem(CONST_SLOT_BACKPACK)
                    -- cannot open BACKPACK, report problem
                    if not playerStoreInbox then
                        player:sendTextMessage(SHOP_MSG_TYPE, 'Website Shop bugged. Contact with administrator! Error is visible in server console.')
                        print('ERROR! Website Shop (' .. player:getName() .. ') - cannot open player "BACKPACK" - it is not supported in your server OR variable "CONST_SLOT_BACKPACK" is not definied in LUA')
                        return true
                    end
                    -- add container with items to BACKPACK
                    receivedItemStatus = playerStoreInbox:addItemEx(newItem)
                    if type(receivedItemStatus) == "number" and receivedItemStatus == RETURNVALUE_NOERROR then
                        player:sendTextMessage(SHOP_MSG_TYPE, 'You received ' .. shopOfferName .. ' from Website Shop. You can find your item in BACKPACK (under EQ).')
                        db.asyncQuery("DELETE FROM `z_ots_comunication` WHERE `id` = " .. transactionId)
                        db.asyncQuery("UPDATE `z_shop_history_item` SET `trans_state`= 'realized', `trans_real`=" .. os.time() .. " WHERE `id` = " .. transactionId)
                    else
                        player:sendTextMessage(SHOP_MSG_TYPE, 'Website Shop bugged. Contact with administrator! Error is visible in server console.')
                        print('ERROR! Website Shop (' .. player:getName() .. ') - cannot add item to BACKPACK - unknown reason, is it\'s size limited and it is full? - ITEM ID: ' .. itemId .. ', ITEM COUNT: ' .. itemCount)
                    end
-- DELIVER CONTAINER
                elseif shopOfferType == 'container' then
                    -- create empty container
                    local newContainerUID = doCreateItemEx(containerId, 1)
                    -- container item does not exist OR item is not Container
                    if not newContainerUID or not Container(newContainerUID) then
                        player:sendTextMessage(SHOP_MSG_TYPE, 'Website Shop bugged. Contact with administrator! Error is visible in server console.')
                        print('ERROR! Website Shop (' .. player:getName() .. ') - cannot create container - invalid container ID - CONTAINER ID:' .. containerId)
                        return true
                    end
                    -- change container UniqueID to object of class Container
                    local newContainer = Container(newContainerUID)
                    -- add items to container
                    for i = 1, containerItemsInsideCount do
                        -- create new item
                        local newItemUID = doCreateItemEx(itemId, itemCount)
                        --  item does not exist, wrong id OR count
                        if not newItemUID then
                            player:sendTextMessage(SHOP_MSG_TYPE, 'Website Shop bugged. Contact with administrator! Error is visible in server console.')
                            print('ERROR! Website Shop (' .. player:getName() .. ') - cannot create item - invalid item ID OR count - ITEM ID: ' .. itemId .. ', ITEM COUNT: ' .. itemCount)
                            return true
                        end
                        -- change item UniqueID to object of class Item
                        local newItem = Item(newItemUID)
                        -- add item to container
                        local addItemToContainerResult = newContainer:addItemEx(newItem)
                        -- report error if it's not possible to add item to container
                        if type(addItemToContainerResult) ~= "number" or addItemToContainerResult ~= RETURNVALUE_NOERROR then
                            player:sendTextMessage(SHOP_MSG_TYPE, 'Website Shop bugged. Contact with administrator! Error is visible in server console.')
                            print('ERROR! Website Shop (' .. player:getName() .. ') - cannot add item to container - item is not pickable OR variable "RETURNVALUE_NOERROR" is not definied in LUA - ITEM ID: ' .. itemId .. ', ITEM COUNT: ' .. itemCount)
                            return true
                        end
                    end
                    -- get player BACKPACK as container, so we can add item to it
                    local playerStoreInbox = player:getSlotItem(CONST_SLOT_BACKPACK)
                    -- cannot open BACKPACK, report problem
                    if not playerStoreInbox then
                        player:sendTextMessage(SHOP_MSG_TYPE, 'Website Shop bugged. Contact with administrator! Error is visible in server console.')
                        print('ERROR! Website Shop (' .. player:getName() .. ') - cannot open player "BACKPACK" - it is not supported in your server OR variable "CONST_SLOT_BACKPACK" is not definied in LUA')
                        return true
                    end
                    -- add container with items to BACKPACK
            
                    receivedItemStatus = playerStoreInbox:addItemEx(newContainer)
                    if type(receivedItemStatus) == "number" and receivedItemStatus == RETURNVALUE_NOERROR then
                        player:sendTextMessage(SHOP_MSG_TYPE, 'You received ' .. shopOfferName .. ' from Website Shop. You can find your item in BACKPACK (under EQ).')
                        db.asyncQuery("DELETE FROM `z_ots_comunication` WHERE `id` = " .. transactionId)
                        db.asyncQuery("UPDATE `z_shop_history_item` SET `trans_state`= 'realized', `trans_real`=" .. os.time() .. " WHERE `id` = " .. transactionId)
                    else
                        player:sendTextMessage(SHOP_MSG_TYPE, 'Website Shop bugged. Contact with administrator! Error is visible in server console.')
                        print('ERROR! Website Shop (' .. player:getName() .. ') - cannot add container with items to BACKPACK - unknown reason, is it\'s size limited and it is full? - ITEM ID: ' .. itemId .. ', ITEM COUNT: ' .. itemCount .. ', CONTAINER ID:' .. containerId .. ', ITEMS IN CONTAINER COUNT:' .. containerItemsInsideCount)
                    end
                    -- DELIVER YOUR CUSTOM THINGS
              -- DELIVER YOUR CUSTOM THINGS
                elseif shopOfferType == 'mount' then -- addon, mount etc.
                    player:addMount(MountsShop[itemId])
					player:setStorageValue(itemId, 1)
                    player:getPosition():sendMagicEffect(CONST_ME_HOLYDAMAGE)
                    player:sendTextMessage(SHOP_MSG_TYPE, 'Você recebeu ' .. shopOfferName .. ' do Shop Donate!')
                    db.asyncQuery("DELETE FROM `z_ots_comunication` WHERE `id` = " .. transactionId)
                    db.asyncQuery("UPDATE `z_shop_history_item` SET `trans_state`= 'realized', `trans_real`=" .. os.time() .. " WHERE `id` = " .. transactionId)    
                elseif shopOfferType == 'addon' then
                    player:addOutfit(AddonsShop[itemId].m)
                    player:addOutfitAddon(AddonsShop[itemId].m, 3)
                    if (AddonsShop[itemId].f ~= 141) then
                        player:addOutfit(AddonsShop[itemId].f)
                        player:addOutfitAddon(AddonsShop[itemId].f, 3)
                    end
					player:setStorageValue(itemId,1)
                    player:getPosition():sendMagicEffect(CONST_ME_HOLYDAMAGE)
                    player:sendTextMessage(SHOP_MSG_TYPE, 'Você recebeu ' .. shopOfferName .. ' do Shop Donate!')
                    db.asyncQuery("DELETE FROM `z_ots_comunication` WHERE `id` = " .. transactionId)
                    db.asyncQuery("UPDATE `z_shop_history_item` SET `trans_state`= 'realized', `trans_real`=" .. os.time() .. " WHERE `id` = " .. transactionId)
                end
            end
        until not result.next(resultId)
        result.free(resultId)
    end

    return true
end