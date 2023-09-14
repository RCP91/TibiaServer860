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

	

	if msgcontains(msg, "weapons") then
		if getPlayerStorageValue(cid, Storage.secretService.AVINMission06) == 1 then
			selfSay("Crate of weapons you say.. for me?", cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			if doPlayerRemoveItem(cid, 7707, 1) then
				setPlayerStorageValue(cid, Storage.secretService.AVINMission06, 2)
				selfSay("Why thank you |PLAYERNAME|.", cid)
			else
				selfSay("You don't have any crate of weapons!", cid)
			end
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "I hope you have a cold day, friend.")
npcHandler:setMessage(MESSAGE_FAREWELL, "I hope you have a cold day, friend.")
npcHandler:setMessage(MESSAGE_GREET, "Welcome, to my cool home.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
