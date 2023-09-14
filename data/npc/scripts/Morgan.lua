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

	

	if msgcontains(msg, 'firebird') then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.PirateSabreAddon) == 4 then
			setPlayerStorageValue(cid, Storage.OutfitQuest.PirateSabreAddon, 5)
			doPlayerAddOutfit(cid, 151, 1)
			doPlayerAddOutfit(cid, 155, 1)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			selfSay('Ahh. So Duncan sent you, eh? You must have done something really impressive. Okay, take this fine sabre from me, mate.', cid)
		end
	elseif msgcontains(msg, 'warrior\'s sword') then
		if player:hasOutfit(player:getSex() == PLAYERSEX_FEMALE and 142 or 134, 2) then
			selfSay('You already have this outfit!', cid)
			return true
		end

		if getPlayerStorageValue(cid, Storage.OutfitQuest.WarriorSwordAddon) < 1 then
			setPlayerStorageValue(cid, Storage.OutfitQuest.WarriorSwordAddon, 1)
			selfSay('Great! Simply bring me 100 iron ore and one royal steel and I will happily {forge} it for you.', cid)
		elseif getPlayerStorageValue(cid, Storage.OutfitQuest.WarriorSwordAddon) == 1 and talkState[talkUser] == 1 then
			if getPlayerItemCount(cid, 5887) > 0 and getPlayerItemCount(cid, 5880) > 99 then
				doPlayerRemoveItem(cid, 5887, 1)
				doPlayerRemoveItem(cid, 5880, 100)
				doPlayerAddOutfit(cid, 134, 2)
				doPlayerAddOutfit(cid, 142, 2)
				setPlayerStorageValue(cid, Storage.OutfitQuest.WarriorSwordAddon, 2)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				--player:addAchievementProgress('Wild Warrior', 2)
				selfSay('Alright! As a matter of fact, I have one in store. Here you go!', cid)
			else
				selfSay('You do not have all the required items.', cid)
			end
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, 'knight\'s sword') then
		if player:hasOutfit(player:getSex() == PLAYERSEX_FEMALE and 139 or 131, 1) then
			selfSay('You already have this outfit!', cid)
			return true
		end

		if getPlayerStorageValue(cid, Storage.OutfitQuest.Knight.AddonSword) < 1 then
			setPlayerStorageValue(cid, Storage.OutfitQuest.Knight.AddonSword, 1)
			selfSay('Great! Simply bring me 100 Iron Ore and one Crude Iron and I will happily {forge} it for you.', cid)
		elseif getPlayerStorageValue(cid, Storage.OutfitQuest.Knight.AddonSword) == 1 and talkState[talkUser] == 1 then
			if getPlayerItemCount(cid, 5892) > 0 and getPlayerItemCount(cid, 5880) > 99 then
				doPlayerRemoveItem(cid, 5892, 1)
				doPlayerRemoveItem(cid, 5880, 100)
				doPlayerAddOutfit(cid, 131, 1)
				doPlayerAddOutfit(cid, 139, 1)
				setPlayerStorageValue(cid, Storage.OutfitQuest.Knight.AddonSword, 2)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				selfSay('Alright! As a matter of fact, I have one in store. Here you go!', cid)
			else
				selfSay('You do not have all the required items.', cid)
			end
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, 'forge') then
		selfSay('What would you like me to forge for you? A {knight\'s sword} or a {warrior\'s sword}?', cid)
		talkState[talkUser] = 1
	end
	return true
end

keywordHandler:addKeyword({'addon'}, StdModule.say, {npcHandler = npcHandler, text = 'I can forge the finest {weapons} for knights and warriors. They may wear them proudly and visible to everyone.'})
keywordHandler:addKeyword({'weapons'}, StdModule.say, {npcHandler = npcHandler, text = 'Would you rather be interested in a {knight\'s sword} or in a {warrior\'s sword}?'})

npcHandler:setMessage(MESSAGE_GREET, 'Hello there.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
