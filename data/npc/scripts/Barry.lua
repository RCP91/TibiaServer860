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
			selfSay('Oh my, where to begin with .. <tells about the troubles he and his men have recently encountered>.', cid)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) + 1)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission02, getPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission02) + 1) -- StorageValue for Questlog 'Mission 02: Watching the Watchmen'
		end
	elseif msgcontains(msg, 'pass') then
		selfSay('You can {pass} either to the {Magician Quarter} or {Sunken Quarter}. Which one will it be?', cid)
		talkState[talkUser] = 1
	elseif talkState[talkUser] == 1 then
		if msgcontains(msg, 'magician') then
			local destination = Position(32885, 31157, 7)
			Player(cid):teleportTo(destination)
			destination:sendMagicEffect(CONST_ME_TELEPORT)
			talkState[talkUser] = 0
		elseif msgcontains(msg, 'sunken') then
			local destination = Position(32884, 31162, 7)
			Player(cid):teleportTo(destination)
			destination:sendMagicEffect(CONST_ME_TELEPORT)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
