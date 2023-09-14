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

	

	if talkState[talkUser] == 0 then
		if msgcontains(msg, 'outfit') then
			selfSay({
				'I\'m tired of all these young unskilled wannabe heroes. Every Tibian can show his skills or actions by wearing a special outfit. To prove oneself worthy of the demon outfit, this is how it goes: ...',
				'The base outfit will be granted for completing the annihilator quest, which isn\'t much of a challenge nowadays, in my opinion. Anyway ...',
				'The shield however will only be granted to those adventurers who have finished the demon helmet quest. ...',
				'Well, the helmet is for those who really are tenacious and have hunted down all 6666 demons and finished the demon oak as well. ...',
				'Are you interested?'
			}, cid)
			talkState[talkUser] = 1
		elseif msgcontains(msg, 'cookie') then
			if getPlayerStorageValue(cid, Storage.WhatAFoolishQuest.Questline) == 31
					and getPlayerStorageValue(cid, Storage.WhatAFoolishQuest.CookieDelivery.AvarTar) ~= 1 then
				selfSay('Do you really think you could bribe a hero like me with a meagre cookie?', cid)
				talkState[talkUser] = 3
			end
		end
	elseif msgcontains(msg, 'yes') then
		if talkState[talkUser] == 1 then
			selfSay('So you want to have the demon outfit, hah! Let\'s have a look first if you really deserve it. Tell me: {base}, {shield} or {helmet}?', cid)
			talkState[talkUser] = 2
		elseif talkState[talkUser] == 3 then
			if not doPlayerRemoveItem(cid, 8111, 1) then
				selfSay('You have no cookie that I\'d like.', cid)
				talkState[talkUser] = 0
				return true
			end

			setPlayerStorageValue(cid, Storage.WhatAFoolishQuest.CookieDelivery.AvarTar, 1)
			if player:getCookiesDelivered() == 10 then
				--player:addAchievement('Allow Cookies?')
			end

			Npc():getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
			selfSay('Well, you won\'t! Though it looks tasty ...What the ... WHAT DO YOU THINK YOU ARE? THIS IS THE ULTIMATE INSULT! GET LOST!', cid)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		end
	elseif msgcontains(msg, 'no') then
		if talkState[talkUser] == 3 then
			selfSay('I see.', cid)
			talkState[talkUser] = 0
		end
	elseif talkState[talkUser] == 2 then
		if msgcontains(msg, 'base') then
			if getPlayerStorageValue(cid, Storage.AnnihilatorDone) == 1 then
				player:addOutfit(541)
				player:addOutfit(542)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				setPlayerStorageValue(cid, Storage.AnnihilatorDone, 2)
				selfSay('Receive the base outfit, |PLAYERNAME|.', cid)
			else
				selfSay('You need to complete annihilator quest first, |PLAYERNAME|.', cid)
				talkState[talkUser] = 2
			end
		elseif msgcontains(msg, 'shield') then
			if getPlayerStorageValue(cid, Storage.AnnihilatorDone) == 2 and getPlayerStorageValue(cid, Storage.QuestChests.DemonHelmetQuestDemonHelmet) == 1 then
				doPlayerAddOutfit(cid, 541, 1)
				doPlayerAddOutfit(cid, 542, 1)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				setPlayerStorageValue(cid, Storage.QuestChests.DemonHelmetQuestDemonHelmet, 2)
				selfSay('Receive the shield, |PLAYERNAME|.', cid)
			else
				selfSay('The shield will only be granted to those adventurers who have finished the demon helmet quest, |PLAYERNAME|.', cid)
				talkState[talkUser] = 2
			end
		elseif msgcontains(msg, 'helmet') then
			if getPlayerStorageValue(cid, Storage.AnnihilatorDone) == 2 and getPlayerStorageValue(cid, Storage.DemonOak.Done) == 3 then
				doPlayerAddOutfit(cid, 541, 2)
				doPlayerAddOutfit(cid, 542, 2)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				setPlayerStorageValue(cid, Storage.DemonOak.Done, 4)
				selfSay('Receive the helmet, |PLAYERNAME|.', cid)
			else
				selfSay('The helmet is for those who have hunted down all 6666 demons and finished the demon oak as well, |PLAYERNAME|.', cid)
				talkState[talkUser] = 2
			end
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, 'Greetings, traveller |PLAYERNAME|!')
npcHandler:setMessage(MESSAGE_FAREWELL, 'See you later, |PLAYERNAME|.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'See you later, |PLAYERNAME|.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
