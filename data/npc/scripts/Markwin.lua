local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local condition = createConditionObject(CONDITION_FIRE)
setConditionParam(condition, CONDITION_PARAM_DELAYED, 1)
addDamageCondition(condition, 30, 4000, -30)

local function greetCallback(cid)
	if not npcHandler:isFocused(cid) then
		local guards = { "Minotaur Guard", "Minotaur Archer", "Minotaur Mage"}
		local position = getNpcPos() --{x = 32416, y = 32146, z = 15}
		local numMonsters = math.random(3, 5) -- Número aleatório de monstros entre 1 e 9
		selfSay("Intruder! Guards, take him down!")
		--if getStorageValue(Storage.MarkwinGreeting) < 1 then
			for i = 1, numMonsters do
				local newPosX = position.x
				local newPosY = position.y 
				local newPos = {x = newPosX, y = newPosY, z = position.z}
				doCreateMonster(guards[math.random(1, 3)], newPos, false, true)
				doSendMagicEffect(newPos, CONST_ME_TELEPORT)
			end
		--end
		
		return false
	end
	
	if getStorageValue(Storage.MarkwinGreeting) == 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Well ... you defeated my guards! Now everything is over! I guess I will have to answer your questions now.")
		setStorageValue(Storage.MarkwinGreeting, 2)
	elseif getStorageValue(Storage.MarkwinGreeting) == 2 then
		npcHandler:setMessage(MESSAGE_GREET, "Oh its you again. What du you want, hornless messenger?")
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	
	if msgcontains(msg, "letter") then
		if getStorageValue(Storage.postman.Mission10) == 1 then
			if getPlayerItemCount(2333) > 0 then
				selfSay("A letter from my Moohmy?? Do you have a letter from my Moohmy to me?", cid)
				talkState[talkUser] = 1
			end
		end
	elseif msgcontains(msg, 'cookie') then
		if getStorageValue(Storage.WhatAFoolishQuest.Questline) == 31
				and getStorageValue(Storage.WhatAFoolishQuest.CookieDelivery.Markwin) ~= 1 then
			selfSay('You bring me ... a cookie???', cid)
			talkState[talkUser] = 2
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			selfSay("Uhm, well thank you, hornless being.", cid)
			setStorageValue(Storage.postman.Mission10, 2)
			doPlayerRemoveItem(2333, 1)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 2 then
			if not doPlayerRemoveItem(8111, 1) then
				selfSay('You have no cookie that I\'d like.', cid)
				talkState[talkUser] = 0
				return true
			end

			setStorageValue(Storage.WhatAFoolishQuest.CookieDelivery.Markwin, 1)
			if getCookiesDelivered() == 10 then
				addAchievement('Allow Cookies?')
			end

			Npc():getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
			selfSay('I understand this as a peace-offering, human ... UNGH ... THIS IS AN OUTRAGE! THIS MEANS WAR!!!', cid)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		end
	elseif msgcontains(msg, "bye") then
		selfSay("Hm ... good bye.", cid)
		addCondition(condition)
		npcHandler:releaseFocus(cid)
		npcHandler:resetNpc(cid)
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
