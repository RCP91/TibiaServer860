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

	

	if msgcontains(msg, 'cookie') then
		if getPlayerStorageValue(cid, Storage.WhatAFoolishQuest.Questline) == 31
				and getPlayerStorageValue(cid, Storage.WhatAFoolishQuest.CookieDelivery.Lorbas) ~= 1 then
			selfSay('You want me to eat this cookie?', cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, 'yes') then
		if talkState[talkUser] == 1 then
			if not doPlayerRemoveItem(cid, 8111, 1) then
				selfSay('You have no cookie that I\'d like.', cid)
				talkState[talkUser] = 0
				return true
			end

			setPlayerStorageValue(cid, Storage.WhatAFoolishQuest.CookieDelivery.Lorbas, 1)
			if player:getCookiesDelivered() == 10 then
				--player:addAchievement('Allow Cookies?')
			end

			Npc():getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
			selfSay('Well, you don\'t mind if I play around with this antidote rune a bit ... UHHH, YOU LOU ... uhm that was so ... funny, haha ... ha. Mhm, you better leave now.', cid)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		end
	elseif msgcontains(msg, 'no') then
		if talkState[talkUser] == 1 then
			selfSay('I see.', cid)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
