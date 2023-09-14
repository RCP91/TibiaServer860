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
		if(getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 10 or getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 11) then
			selfSay("You have NO idea what we have to endure each day .. <gives a shocking and disturbing report>. ", cid)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) + 1)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission02, getPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission02) + 1) -- StorageValue for Questlog "Mission 02: Watching the Watchmen"
			talkState[talkUser] = 0
		end
	elseif(msgcontains(msg, "pass")) then
		selfSay("You can {pass} either to the {Cemetery Quarter} or {Magician Quarter}. Which one will it be?", cid)
		talkState[talkUser] = 1
	elseif(msgcontains(msg, "cemetery")) then
		if(talkState[talkUser] == 1) then
			local destination = Position(32799, 31103, 7)
			player:teleportTo(destination)
			destination:sendMagicEffect(CONST_ME_TELEPORT)
			talkState[talkUser] = 0
		end
	elseif(msgcontains(msg, "magician")) then
		if(talkState[talkUser] == 1) then
			local destination = Position(32804, 31103, 7)
			player:teleportTo(destination)
			destination:sendMagicEffect(CONST_ME_TELEPORT)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
