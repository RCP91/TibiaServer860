 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	

	if isInArray({"enchanted chicken wing", "boots of haste", "Enchanted Chicken Wing", "Boots of Haste"}, msg) then
		selfSay('Do you want to trade Boots of haste for Enchanted Chicken Wing?', cid)
		talkState[talkUser] = 1
	elseif isInArray({"warrior sweat", "warrior helmet", "Warrior Sweat", "Warrior Helmet"}, msg) then
		selfSay('Do you want to trade 4 Warrior Helmet for Warrior Sweat?', cid)
		talkState[talkUser] = 2
	elseif isInArray({"fighting spirit", "royal helmet", "Fighting Spirit", "Royal Helmet"}, msg) then
		selfSay('Do you want to trade 2 Royal Helmet for Fighting Spirit', cid)
		talkState[talkUser] = 3
	elseif isInArray({"magic sulphur", "fire sword", "Magic Sulphur", "Fire Sword"}, msg) then
		selfSay('Do you want to trade 3 Fire Sword for Magic Sulphur', cid)
		talkState[talkUser] = 4
	elseif isInArray({"job", "items", "Items", "Job"}, msg) then
		selfSay('I trade Enchanted Chicken Wing for Boots of Haste, Warrior Sweat for 4 Warrior Helmets, Fighting Spirit for 2 Royal Helmet Magic Sulphur for 3 Fire Swords', cid)
		talkState[talkUser] = 0
	elseif msgcontains(msg, 'cookie') then
		if getPlayerStorageValue(cid, Storage.WhatAFoolishQuest.Questline) == 31
				and getPlayerStorageValue(cid, Storage.WhatAFoolishQuest.CookieDelivery.Djinn) ~= 1 then
			selfSay('You brought cookies! How nice of you! Can I have one?', cid)
			talkState[talkUser] = 5
		end
	elseif msgcontains(msg,'yes') then
		if talkState[talkUser] >= 1 and talkState[talkUser] <= 4 then
			local trade = {
					{ NeedItem = 2195, Ncount = 1, GiveItem = 5891, Gcount = 1}, -- Enchanted Chicken Wing
					{ NeedItem = 2475, Ncount = 4, GiveItem = 5885, Gcount = 1}, -- Flask of Warrior's Sweat
					{ NeedItem = 2498, Ncount = 2, GiveItem = 5884, Gcount = 1}, -- Spirit Container
					{ NeedItem = 2392, Ncount = 3, GiveItem = 5904, Gcount = 1}  -- Magic Sulphur
			}

			if getPlayerItemCount(cid, trade[talkState[talkUser]].NeedItem) >= trade[talkState[talkUser]].Ncount then
				doPlayerRemoveItem(cid, trade[talkState[talkUser]].NeedItem, trade[talkState[talkUser]].Ncount)
				doPlayerAddItem(cid, trade[talkState[talkUser]].GiveItem, trade[talkState[talkUser]].Gcount)
				return selfSay('Here you are.', cid)
			else
				selfSay('Sorry but you don\'t have the item.', cid)
			end
		elseif talkState[talkUser] == 5 then
			if not doPlayerRemoveItem(cid, 8111, 1) then
				selfSay('You have no cookie that I\'d like.', cid)
				talkState[talkUser] = 0
				return true
			end

			setPlayerStorageValue(cid, Storage.WhatAFoolishQuest.CookieDelivery.Djinn, 1)
			if player:getCookiesDelivered() == 10 then
				--player:addAchievement('Allow Cookies?')
			end

			Npc():getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
			selfSay('You see, good deeds like this will ... YOU ... YOU SPAWN OF EVIL! I WILL MAKE SURE THE MASTER LEARNS ABOUT THIS!', cid)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		end
	elseif msgcontains(msg,'no') then
		if talkState[talkUser] >= 1 and talkState[talkUser] <= 4 then
			selfSay('Ok then.', cid)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 5 then
			selfSay('I see.', cid)
			talkState[talkUser] = 0
		end
	end
	return true
end

local function onTradeRequest(cid)
	
	
	if getPlayerStorageValue(cid, Storage.DjinnWar.EfreetFaction.Mission03) ~= 3 then
		selfSay('I\'m sorry, but you don\'t have Malor\'s permission to trade with me.', cid)
		return false
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Be greeted, human |PLAYERNAME|. How can a humble djinn be of service?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Farewell, human.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Farewell, human.")
npcHandler:setMessage(MESSAGE_SENDTRADE, 'At your service, just browse through my wares.')

npcHandler:setCallback(CALLBACK_ONTRADEREQUEST, onTradeRequest)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

local focusModule = FocusModule:new()
focusModule:addGreetMessage('hi')
focusModule:addGreetMessage('hello')
focusModule:addGreetMessage('djanni\'hah')
npcHandler:addModule(focusModule)
