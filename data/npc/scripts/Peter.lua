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
		if(getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 7 or getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 13) then
			selfSay("A report? What do they think is happening here? <gives an angry and bitter report>. ", cid)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) + 1)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission02, getPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission02) + 1) -- StorageValue for Questlog "Mission 02: Watching the Watchmen"
			talkState[talkUser] = 0
		end
	elseif(msgcontains(msg, "pass")) then
		selfSay("You can {pass} either to the {Factory Quarter} or {Trade Quarter}. Which one will it be?", cid)
		talkState[talkUser] = 1
	elseif(msgcontains(msg, "factory")) then
		if(talkState[talkUser] == 1) then
			local destination = Position(32859, 31302, 7)
			player:teleportTo(destination)
			destination:sendMagicEffect(CONST_ME_TELEPORT)
			talkState[talkUser] = 0
		end
	elseif(msgcontains(msg, "trade")) then
		if(talkState[talkUser] == 1) then
			local destination = Position(32854, 31302, 7)
			player:teleportTo(destination)
			destination:sendMagicEffect(CONST_ME_TELEPORT)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
