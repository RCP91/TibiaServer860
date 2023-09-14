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

	
	if msgcontains(msg, 'precious necklace') then
		if getPlayerItemCount(cid, 8768) > 0 then
			selfSay('Would you like to buy my precious necklace for 5000 gold?', cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, 'mouse') then
		selfSay('Wha ... What??? Are you saying you\'ve seen a mouse here??', cid)
		talkState[talkUser] = 2
	elseif msgcontains(msg, 'yes') then
		if talkState[talkUser] == 1 then
			if doPlayerRemoveMoney(cid, 5000) then
				doPlayerRemoveItem(cid, 8768, 1)
				doPlayerAddItem(cid, 8767, 1)
				selfSay('Here you go kind sir.', cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 2 then
			if not doPlayerRemoveItem(cid, 7487, 1) then
				selfSay('There is no mouse here! Stop talking foolish things about serious issues!', cid)
				talkState[talkUser] = 0
				return true
			end

			setPlayerStorageValue(cid, Storage.WhatAFoolishQuest.ScaredCarina, 1)
			selfSay('IIIEEEEEK!', cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, 'no') then
		if talkState[talkUser] == 2 then
			selfSay('Thank goodness!', cid)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
