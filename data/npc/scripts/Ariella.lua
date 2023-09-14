local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = { {text = 'Have a drink in Meriana\'s only tavern!'} }
--npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	

	if msgcontains(msg, 'cookie') then
		if getPlayerStorageValue(cid, Storage.WhatAFoolishQuest.Questline) == 31
				and getPlayerStorageValue(cid, Storage.WhatAFoolishQuest.CookieDelivery.Ariella) ~= 1 then
			selfSay('So you brought a cookie to a pirate?', cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, 'addon') and getPlayerStorageValue(cid, Storage.OutfitQuest.PirateBaseOutfit) == 1 then
		selfSay('To get pirate hat you need give me Brutus Bloodbeard\'s Hat, Lethal Lissy\'s Shirt, Ron the Ripper\'s Sabre and Deadeye Devious\' Eye Patch. Do you have them with you?', cid)
		talkState[talkUser] = 2
	elseif msgcontains(msg, 'yes') then
		if talkState[talkUser] == 1 then
			if not doPlayerRemoveItem(cid, 8111, 1) then
				selfSay('You have no cookie that I\'d like.', cid)
				talkState[talkUser] = 0
				return true
			end

			setPlayerStorageValue(cid, Storage.WhatAFoolishQuest.CookieDelivery.Ariella, 1)
			if player:getCookiesDelivered() == 10 then
				--player:addAchievement('Allow Cookies?')
			end

			Npc():getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
			selfSay('How sweet of you ... Uhh ... OH NO ... Bozo did it again. Tell this prankster I\'ll pay him back.', cid)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		elseif talkState[talkUser] == 2 then
			if getPlayerStorageValue(cid, Storage.OutfitQuest.PirateHatAddon) == -1 then
				if getPlayerItemCount(cid, 6101) > 0 and getPlayerItemCount(cid, 6102) > 0 and getPlayerItemCount(cid, 6100) > 0 and getPlayerItemCount(cid, 6099) > 0 then
					if doPlayerRemoveItem(cid, 6101, 1) and doPlayerRemoveItem(cid, 6102, 1) and doPlayerRemoveItem(cid, 6100, 1) and doPlayerRemoveItem(cid, 6099, 1) then
						selfSay("Ah, right! The pirate hat! Here you go.", cid)
						player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
						setPlayerStorageValue(cid, Storage.OutfitQuest.PirateHatAddon, 1)
						doPlayerAddOutfit(cid, 155, 2)
						doPlayerAddOutfit(cid, 151, 2)
					end
				else
					selfSay("You do not have all the required items.", cid)
				end
			else
				selfSay("It seems you already have this addon, don\'t you try to mock me son!", cid)
			end
		end
	elseif msgcontains(msg, 'no') then
		if talkState[talkUser] == 1 then
			selfSay('I see.', cid)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 2 then
			selfSay('Alright then. Come back when you got all neccessary items.', cid)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
