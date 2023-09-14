local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, 'cigar') then
		selfSay('Oh my. Have you gotten an exquisite cigar for me, my young friend?', cid)
		talkState[talkUser] = 1
	elseif msgcontains(msg, 'yes') and talkState[talkUser] == 1 then
		
		if not doPlayerRemoveItem(cid, 7499, 1) then
			talkState[talkUser] = 0
			return true
		end

		setPlayerStorageValue(cid, Storage.WhatAFoolishQuest.Cigar, 1)
		Npc():getPosition():sendMagicEffect(CONST_ME_EXPLOSIONHIT)
		selfSay({
			'Ah what a fine blend. I really ...',
			'OUCH! What have you done you fool? How dare you???'
		}, cid)
		talkState[talkUser] = 0
	elseif msgcontains(msg, 'no') and talkState[talkUser] == 1 then
		selfSay('Oh, then there must be a misunderstanding.', cid)
		talkState[talkUser] = 0
	end

	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
