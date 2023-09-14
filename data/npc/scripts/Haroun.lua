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
	
	if isInArray({"enchanted chicken wing", "boots of haste"}, msg) then
		selfSay('Do you want to trade Boots of haste for Enchanted Chicken Wing?', cid)
		talkState[talkUser] = 1
	elseif isInArray({"warrior sweat", "warrior helmet"}, msg) then
		selfSay('Do you want to trade 4 Warrior Helmet for Warrior Sweat?', cid)
		talkState[talkUser] = 2
	elseif isInArray({"fighting spirit", "royal helmet"}, msg) then
		selfSay('Do you want to trade 2 Royal Helmet for Fighting Spirit', cid)
		talkState[talkUser] = 3
	elseif isInArray({"magic sulphur", "fire sword"}, msg) then
		selfSay('Do you want to trade 3 Fire Sword for Magic Sulphur', cid)
		talkState[talkUser] = 4
	elseif isInArray({"job", "items"}, msg) then
		selfSay('I trade Enchanted Chicken Wing for Boots of Haste, Warrior Sweat for 4 Warrior Helmets, Fighting Spirit for 2 Royal Helmet Magic Sulphur for 3 Fire Swords', cid)
		talkState[talkUser] = 0
	elseif msgcontains(msg,'yes') and talkState[talkUser] <= 4 and talkState[talkUser] >= 1 then
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
	elseif msgcontains(msg,'no') and (talkState[talkUser] >= 1 and talkState[talkUser] <= 5) then
		selfSay('Ok then.', cid)
		talkState[talkUser] = 0
		npcHandler:releaseFocus(cid)
		npcHandler:resetNpc(cid)
	end
	return true
end

local function onTradeRequest(cid)
	
	
	if getPlayerStorageValue(cid, Storage.DjinnWar.MaridFaction.Mission03) ~= 3 then
		selfSay('I\'m sorry, human. But you need Gabel\'s permission to trade with me.', cid)
		return false
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Be greeted, human |PLAYERNAME|. How can a humble djinn be of service?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Farewell! May the serene light of the enlightened one rest shine on your travels.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Farewell, human.")
npcHandler:setMessage(MESSAGE_SENDTRADE, 'At your service, just browse through my wares.')

npcHandler:setCallback(CALLBACK_ONTRADEREQUEST, onTradeRequest)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
