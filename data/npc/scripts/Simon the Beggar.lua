 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{ text = 'Alms! Alms for the poor!' },
	{ text = 'Sir, Ma\'am, have a gold coin to spare?' },
	{ text = 'I need help! Please help me!' }
}

--npcHandler:addModule(VoiceModule:new(voices))

function BeggarFirst(cid, message, keywords, parameters, node)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	if player:isPremium() then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.BeggarFirstAddon) == -1 then
			if getPlayerItemCount(cid, 5883) >= 100 and getPlayerBalance(cid) + getPlayerBalance(cid) >= 20000 then
				if doPlayerRemoveItem(cid, 5883, 100) and doPlayerRemoveMoney(cid, 20000) then
					selfSay("Ah, right! The beggar beard or beggar dress! Here you go.", cid)
					player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
					setPlayerStorageValue(cid, Storage.OutfitQuest.BeggarFirstAddon, 1)
					doPlayerAddOutfit(cid, 153, 1)
					doPlayerAddOutfit(cid, 157, 1)
				end
			else
				selfSay("You do not have all the required items.", cid)
			end
		else
			selfSay("It seems you already have this addon, don't you try to mock me son!", cid)
		end
	end
end

function BeggarSecond(cid, message, keywords, parameters, node)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	if player:isPremium() then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.BeggarSecondAddon) == -1 then
			if getPlayerItemCount(cid, 6107) >= 1 then
				if doPlayerRemoveItem(cid, 6107, 1) then
					selfSay("Ah, right! The beggar staff! Here you go.", cid)
					player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
					setPlayerStorageValue(cid, Storage.OutfitQuest.BeggarSecondAddon, 1)
					doPlayerAddOutfit(cid, 153, 2)
					doPlayerAddOutfit(cid, 157, 2)
				end
			else
				selfSay("You do not have all the required items.", cid)
			end
		else
			selfSay("It seems you already have this addon, don't you try to mock me son!", cid)
		end
	end
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	

	if msgcontains(msg, 'cookie') then
		if getPlayerStorageValue(cid, Storage.WhatAFoolishQuest.Questline) == 31
				and getPlayerStorageValue(cid, Storage.WhatAFoolishQuest.CookieDelivery.SimonTheBeggar) ~= 1 then
			selfSay('Have you brought a cookie for the poor?', cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, 'help') then
		selfSay('I need gold. Can you spare 100 gold pieces for me?', cid)
		talkState[talkUser] = 2
	elseif msgcontains(msg, 'yes') then
		if talkState[talkUser] == 1 then
			if not doPlayerRemoveItem(cid, 8111, 1) then
				selfSay('You have no cookie that I\'d like.', cid)
				talkState[talkUser] = 0
				return true
			end

			setPlayerStorageValue(cid, Storage.WhatAFoolishQuest.CookieDelivery.SimonTheBeggar, 1)
			if player:getCookiesDelivered() == 10 then
				--player:addAchievement('Allow Cookies?')
			end

			Npc():getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
			selfSay('Well, it\'s the least you can do for those who live in dire poverty. A single cookie is a bit less than I\'d expected, but better than ... WHA ... WHAT?? MY BEARD! MY PRECIOUS BEARD! IT WILL TAKE AGES TO CLEAR IT OF THIS CONFETTI!', cid)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		elseif talkState[talkUser] == 2 then
			if not doPlayerRemoveMoney(cid, 100) then
				selfSay('You haven\'t got enough money for me.', cid)
				talkState[talkUser] = 0
				return true
			end

			selfSay('Thank you very much. Can you spare 500 more gold pieces for me? I will give you a nice hint.', cid)
			talkState[talkUser] = 3
		elseif talkState[talkUser] == 3 then
			if not doPlayerRemoveMoney(cid, 500) then
				selfSay('Sorry, that\'s not enough.', cid)
				talkState[talkUser] = 0
				return true
			end

			selfSay('That\'s great! I have stolen something from Dermot. You can buy it for 200 gold. Do you want to buy it?', cid)
			talkState[talkUser] = 4
		elseif talkState[talkUser] == 4 then
			if not doPlayerRemoveMoney(cid, 200) then
				selfSay('Pah! I said 200 gold. You don\'t have that much.', cid)
				talkState[talkUser] = 0
				return true
			end

			local key = doPlayerAddItem(cid, 2087, 1)
			if key then
				key:setActionId(3940)
			end
			selfSay('Now you own the hot key.', cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, 'no') and talkState[talkUser] ~= 0 then
		if talkState[talkUser] == 1 then
			selfSay('I see.', cid)
		elseif talkState[talkUser] == 2 then
			selfSay('Hmm, maybe next time.', cid)
		elseif talkState[talkUser] == 3 then
			selfSay('It was your decision.', cid)
		elseif talkState[talkUser] == 4 then
			selfSay('Ok. No problem. I\'ll find another buyer.', cid)
		end
		talkState[talkUser] = 0
	end
	return true
end

node1 = keywordHandler:addKeyword({'addon'}, StdModule.say, {npcHandler = npcHandler, text = 'For the small fee of 20000 gold pieces I will help you mix this potion. Just bring me 100 pieces of ape fur, which are necessary to create this potion. ...Do we have a deal?'})
node1:addChildKeyword({'yes'}, BeggarSecond, {})
node1:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'Alright then. Come back when you got all neccessary items.', reset = true})

node2 = keywordHandler:addKeyword({'dress'}, StdModule.say, {npcHandler = npcHandler, text = 'For the small fee of 20000 gold pieces I will help you mix this potion. Just bring me 100 pieces of ape fur, which are necessary to create this potion. ...Do we have a deal?'})
node2:addChildKeyword({'yes'}, BeggarFirst, {})
node2:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'Alright then. Come back when you got all neccessary items.', reset = true})

node3 = keywordHandler:addKeyword({'staff'}, StdModule.say, {npcHandler = npcHandler, text = 'To get beggar staff you need to give me simon the beggar\'s staff. Do you have it with you?'})
node3:addChildKeyword({'yes'}, BeggarSecond, {})
node3:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'Alright then. Come back when you got all neccessary items.', reset = true})

node4 = keywordHandler:addKeyword({'outfit'}, StdModule.say, {npcHandler = npcHandler, text = 'For the small fee of 20000 gold pieces I will help you mix this potion. Just bring me 100 pieces of ape fur, which are necessary to create this potion. ...Do we have a deal?'})
node4:addChildKeyword({'yes'}, BeggarFirst, {})
node4:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'Alright then. Come back when you got all neccessary items.', reset = true})


npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|. I am a poor man. Please help me.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Have a nice day.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Have a nice day.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
