local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	if(msgcontains(msg, "report")) then
		if(getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 8 or getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 12) then
			selfSay("Hicks! I... I... <he is obviously drunk and his report more than confusing>. ", cid)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) + 1)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission02, getPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission02) + 1) -- StorageValue for Questlog "Mission 02: Watching the Watchmen"
			talkState[talkUser] = 0
		end
	elseif(msgcontains(msg, "pass")) then
		selfSay("You can {pass} either to the {Arena Quarter} or {Alchemist Quarter}. Which one will it be?", cid)
		talkState[talkUser] = 1
	elseif(msgcontains(msg, "arena")) then
		if(talkState[talkUser] == 1) then
			local destination = Position(32688, 31193, 7)
			player:teleportTo(destination)
			destination:sendMagicEffect(CONST_ME_TELEPORT)
			talkState[talkUser] = 0
		end
	elseif(msgcontains(msg, "alchemist")) then
		if(talkState[talkUser] == 1) then
			local destination = Position(32688, 31188, 7)
			player:teleportTo(destination)
			destination:sendMagicEffect(CONST_ME_TELEPORT)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
