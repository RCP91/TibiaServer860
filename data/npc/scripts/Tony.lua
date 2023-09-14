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

	
	if msgcontains(msg, "report") then
		if getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 7 or getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 13 then
			selfSay("Uhm, report, eh? <slowly gives a clumsy description of recent problems>. ", cid)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, math.max(1, getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) +1))
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission02, math.max(1, getPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission02) +1)) -- StorageValue for Questlog "Mission 02: Watching the Watchmen"
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "pass") then
		selfSay("You can {pass} either to the {Arena Quarter} or {Foreigner Quarter}. Which one will it be?", cid)
		talkState[talkUser] = 1
	elseif(msgcontains(msg, "arena")) then
		if talkState[talkUser] == 1 then
			player:teleportTo(Position(32695, 31254, 7))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			talkState[talkUser] = 0
		end
	elseif(msgcontains(msg, "foreigner")) then
		if talkState[talkUser] == 1 then
			player:teleportTo(Position(32695, 31259, 7))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
