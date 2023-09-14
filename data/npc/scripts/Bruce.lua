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

	if msgcontains(msg, 'report') then
		
		if isInArray({9, 11}, getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline)) then
			selfSay('Well, .. <gives a short and precise report>.', cid)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) + 1)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission02, getPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission02) + 1) -- StorageValue for Questlog 'Mission 02: Watching the Watchmen'
		end
	elseif msgcontains(msg, 'pass') then
		selfSay('You can {pass} either to the {Alchemist Quarter} or {Cemetery Quarter}. Which one will it be?', cid)
		talkState[talkUser] = 1
	elseif talkState[talkUser] == 1 then
		if msgcontains(msg, 'alchemist') then
			local destination = Position(32738, 31113, 7)
			Player(cid):teleportTo(destination)
			destination:sendMagicEffect(CONST_ME_TELEPORT)
			talkState[talkUser] = 0
		elseif msgcontains(msg, 'cemetery') then
			local destination = Position(32743, 31113, 7)
			Player(cid):teleportTo(destination)
			destination:sendMagicEffect(CONST_ME_TELEPORT)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
