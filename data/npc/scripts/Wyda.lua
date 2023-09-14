local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local condition = Condition(CONDITION_FIRE)
condition:setParameter(CONDITION_PARAM_DELAYED, 1)
condition:addDamage(60, 2000, -10)

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	

	if msgcontains(msg, 'cookie') then
		if getPlayerStorageValue(cid, Storage.WhatAFoolishQuest.Questline) == 31
				and getPlayerStorageValue(cid, Storage.WhatAFoolishQuest.CookieDelivery.Wyda) ~= 1 then
			selfSay('You brought me a cookie?', cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, 'mission') or msgcontains(msg, 'quest') then
		selfSay({
			"A quest? Well, if you\'re so keen on doing me a favour... Why don\'t you try to find a {blood herb}?",
			"To be honest, I\'m drowning in blood herbs by now."
		}, cid)
		talkState[talkUser] = 0
	elseif msgcontains(msg, 'bloodherb') or msgcontains(msg, 'blood herb') then
		if getPlayerStorageValue(cid, Storage.BloodHerbQuest) == 1  then
			selfSay('Arrr... here we go again.... do you have a #$*§# blood herb for me?', cid)
			talkState[talkUser] = 2
		else
			selfSay({
				"The blood herb is very rare. This plant would be very useful for me, but I don't know any accessible places to find it.",
				"To be honest, I'm drowning in blood herbs by now. But if it helps you, well yes.. I guess I could use another blood herb..."
			}, cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, 'yes') then
		if talkState[talkUser] == 1 then
			if not doPlayerRemoveItem(cid, 8111, 1) then
				selfSay('You have no cookie that I\'d like.', cid)
				talkState[talkUser] = 0
				return true
			end

			setPlayerStorageValue(cid, Storage.WhatAFoolishQuest.CookieDelivery.Wyda, 1)
			player:addCondition(condition)
			if player:getCookiesDelivered() == 10 then
				--player:addAchievement('Allow Cookies?')
			end

			Npc():getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
			selfSay('Well, it\'s a welcome change from all that gingerbread ... AHHH HOW DARE YOU??? FEEL MY WRATH!', cid)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		elseif talkState[talkUser] == 2 then
			if doPlayerRemoveItem(cid, 2798, 1) then
				setPlayerStorageValue(cid, Storage.BloodHerbQuest, 2)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
				local TornTeddyRand = math.random(1, 100)
				if TornTeddyRand <= 70 then
					doPlayerAddItem(cid, 2324, 1) -- witchesbroom
					selfSay('Thank you -SOOO- much! No, I really mean it! Really! Here, let me give you a reward...', cid)
					talkState[talkUser] = 0
				else
					doPlayerAddItem(cid, 13774, 1) -- torn teddy
					selfSay('Thank you -SOOO- much! No, I really mean it! Really! Ah, you know what, you can have this old thing...', cid)
					talkState[talkUser] = 0
				end
			else
				selfSay('No, you don\'t have any...', cid)
				talkState[talkUser] = 0
			end
		end
	elseif msgcontains(msg, 'no') then
		if talkState[talkUser] == 1 or talkState[talkUser] == 2 then
			selfSay('I see.', cid)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
