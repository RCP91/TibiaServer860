 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = { {text = 'Hello there, adventurer! Need a deal in weapons or armor? I\'m your man!'} }
--npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
	
	if msgcontains(msg, 'adorn')
			or msgcontains(msg, 'outfit')
			or msgcontains(msg, 'addon') then
		local addonProgress = getPlayerStorageValue(cid, Storage.OutfitQuest.Knight.AddonHelmet)
		if addonProgress == 5 then
			setPlayerStorageValue(cid, Storage.OutfitQuest.Knight.MissionHelmet, 6)
			setPlayerStorageValue(cid, Storage.OutfitQuest.Knight.AddonHelmet, 6)
			setPlayerStorageValue(cid, Storage.OutfitQuest.Knight.AddonHelmetTimer, os.time() + 7200)
			selfSay('Oh, Gregor sent you? I see. It will be my pleasure to adorn your helmet. Please give me some time to finish it.', cid)
		elseif addonProgress == 6 then
			if getPlayerStorageValue(cid, Storage.OutfitQuest.Knight.AddonHelmetTimer) < os.time() then
				setPlayerStorageValue(cid, Storage.OutfitQuest.Knight.MissionHelmet, 0)
				setPlayerStorageValue(cid, Storage.OutfitQuest.Knight.AddonHelmet, 7)
				setPlayerStorageValue(cid, Storage.OutfitQuest.Ref, math.min(0, getPlayerStorageValue(cid, Storage.OutfitQuest.Ref) - 1))
				doPlayerAddOutfit(cid, 131, 2)
				doPlayerAddOutfit(cid, 139, 2)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				selfSay('Just in time, |PLAYERNAME|. Your helmet is finished, I hope you like it.', cid)
			else
				selfSay('Please have some patience, |PLAYERNAME|. Forging is hard work!', cid)
			end
		elseif addonProgress == 7 then
			selfSay('I think it\'s one of my masterpieces.', cid)
		else
			selfSay('Sorry, but without the permission of Gregor I cannot help you with this matter.', cid)
		end

	elseif msgcontains(msg, "old backpack") or msgcontains(msg, "backpack") then
		if getPlayerStorageValue(cid, Storage.SamsOldBackpack) < 1 then
			selfSay("What? Are you telling me you found my old adventurer's backpack that I lost years ago??", cid)
			talkState[talkUser] = 1
		end

	elseif msgcontains(msg, '2000 steel shields') then
		if getPlayerStorageValue(cid, Storage.WhatAFoolishQuest.Questline) ~= 29
				or getPlayerStorageValue(cid, Storage.WhatAFoolishQuest.Contract) == 2 then
			selfSay('My offers are weapons, armors, helmets, legs, and shields. If you\'d like to see my offers, ask me for a {trade}.', cid)
			return true
		end

		selfSay('What? You want to buy 2000 steel shields??', cid)
		talkState[talkUser] = 2

	elseif msgcontains(msg, 'contract') then
		if getPlayerStorageValue(cid, Storage.WhatAFoolishQuest.Contract) == 0 then
			selfSay('Have you signed the contract?', cid)
			talkState[talkUser] = 4
		end

	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			if doPlayerRemoveItem(cid, 3960, 1) then
				selfSay({
					"Thank you very much! This brings back good old memories! Please, as a reward, travel to Kazordoon and ask my old friend Kroox to provide you a special dwarven armor. ...",
					"I will mail him about you immediately. Just tell him, his old buddy Sam is sending you."
				}, cid)
				setPlayerStorageValue(cid, Storage.SamsOldBackpack, 1)
				--player:addAchievement('Backpack Tourist')
			else
				selfSay("You don't have it...", cid)
			end
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 2 then
			selfSay('I can\'t believe it. Finally I will be rich! I could move to Edron and enjoy my retirement! But ... wait a minute! I will not start working without a contract! Are you willing to sign one?', cid)
			talkState[talkUser] = 3
		elseif talkState[talkUser] == 3 then
			doPlayerAddItem(cid, 7492, 1)
			setPlayerStorageValue(cid, Storage.WhatAFoolishQuest.Contract, 1)
			selfSay('Fine! Here is the contract. Please sign it. Talk to me about it again when you\'re done.', cid)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 4 then
			if not doPlayerRemoveItem(cid, 7491, 1) then
				selfSay('You don\'t have a signed contract.', cid)
				talkState[talkUser] = 0
				return true
			end

			setPlayerStorageValue(cid, Storage.WhatAFoolishQuest.Contract, 2)
			selfSay('Excellent! I will start working right away! Now that I am going to be rich, I will take the opportunity to tell some people what I REALLY think about them!', cid)
			talkState[talkUser] = 0
		end

	elseif msgcontains(msg, "no") then
		if talkState[talkUser] == 1 then
			selfSay("Then no.", cid)
		elseif isInArray({2, 3, 4}, talkState[talkUser]) then
			selfSay("This deal sounded too good to be true anyway.", cid)
		end
		talkState[talkUser] = 0
	end
	return true
end

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I am the blacksmith. If you need weapons or armor - just ask me."})

npcHandler:setMessage(MESSAGE_GREET, "Welcome to my shop, adventurer |PLAYERNAME|! I {trade} with weapons and armor.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye and come again, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye and come again.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
