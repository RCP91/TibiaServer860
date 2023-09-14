
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
	--The New Frontier
	elseif msgcontains(msg, "farmine") then
		if getPlayerStorageValue(cid, Storage.TheNewFrontier.Questline) == 15 then
			selfSay("Oh yes, that project the whole dwarven community is so excited about. I guess I already know why you are here, but speak up.", cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, "impress") or msgcontains(msg, "plea") then
		if talkState[talkUser] == 1 then
			if getPlayerStorageValue(cid, Storage.TheNewFrontier.BribeLeeland) < 1 then
				selfSay("The idea of a promising market and new resources suits us quite well. I think it is reasonable to send some assistance.", cid)
				setPlayerStorageValue(cid, Storage.TheNewFrontier.BribeLeeland, 1)
				setPlayerStorageValue(cid, Storage.TheNewFrontier.Mission05, getPlayerStorageValue(cid, Storage.TheNewFrontier.Mission05) + 1) --Questlog, The New Frontier Quest "Mission 05: Getting Things Busy"
			end
		end
	end
	return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
