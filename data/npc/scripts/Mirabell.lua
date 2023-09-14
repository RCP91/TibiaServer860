local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = { {text = 'The Horn of Plenty is always open for tired adventurers.'} }
--npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	

	if msgcontains(msg, 'pies') then
		if getPlayerStorageValue(cid, Storage.WhatAFoolishQuest.PieBuying) == -1 then
			selfSay('Oh you\'ve heard about my excellent pies, didn\'t you? I am flattered. Unfortunately I\'m completely out of flour. I need 2 portions of flour for one pie. Just tell me when you have enough flour for your pies.', cid)
			return true
		end

		selfSay('For 12 pies this is 240 gold. Do you want to buy them?', cid)
		talkState[talkUser] = 2
	elseif msgcontains(msg, 'flour') then
		selfSay('Do you bring me the flour needed for your pies?', cid)
		talkState[talkUser] = 1
	elseif msgcontains(msg, 'yes') then
		if talkState[talkUser] == 1 then
			if not doPlayerRemoveItem(cid, 2692, 24) then
				selfSay('I think you are confusing the dust in your pockets with flour. You certainly do not have enough flour for 12 pies.', cid)
				talkState[talkUser] = 0
				return true
			end

			setPlayerStorageValue(cid, Storage.WhatAFoolishQuest.PieBuying, getPlayerStorageValue(cid, Storage.WhatAFoolishQuest.PieBuying) + 1)
			selfSay('Excellent. Now I can start baking the pies. As you helped me, I will make you a good price for them.', cid)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 2 then
			if not doPlayerRemoveMoney(cid, 240) then
				selfSay('You don\'t have enough money, don\'t try to fool me.', cid)
				talkState[talkUser] = 0
				return true
			end

			doPlayerAddItem(cid, 7484, 1)
			setPlayerStorageValue(cid, Storage.WhatAFoolishQuest.PieBuying, getPlayerStorageValue(cid, Storage.WhatAFoolishQuest.PieBuying) - 1)
			setPlayerStorageValue(cid, Storage.WhatAFoolishQuest.PieBoxTimer, os.time() + 1200) -- 20 minutes to deliver
			selfSay({
				'Here they are. Wait! Two things you should know: Firstly, they won\'t last long in the sun so you better get them to their destination as quickly as possible ...',
				'Secondly, since my pies are that delicious it is forbidden to leave the town with them. We can\'t afford to attract more tourists to Edron.'
			}, cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, 'no') then
		if talkState[talkUser] == 1 then
			selfSay('Without flour I can\'t do anything, sorry.', cid)
		elseif talkState[talkUser] == 2 then
			selfSay('What are you? Some kind of fool?', cid)
		end
		talkState[talkUser] = 0
	end

	return true
end

keywordHandler:addKeyword({'drink'}, StdModule.say, {npcHandler = npcHandler, text = 'I can offer you beer, wine, lemonade and water. If you\'d like to see my offers, ask me for a {trade}.'})
keywordHandler:addKeyword({'food'}, StdModule.say, {npcHandler = npcHandler, text = 'Are you looking for food? I have bread, cheese, ham, and meat. If you\'d like to see my offers, ask me for a {trade}.'})

npcHandler:setMessage(MESSAGE_GREET, "Welcome to the Horn of Plenty, |PLAYERNAME|. Sit down, have a {drink} or some {food}!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Come back soon, traveller.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Come back soon, traveller.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Of course, take a look at my tasty offers.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
