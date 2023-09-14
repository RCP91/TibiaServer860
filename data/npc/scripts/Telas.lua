
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

	
	if(msgcontains(msg, "farmine")) then
		if(getPlayerStorageValue(cid, Storage.TheNewFrontier.Questline) == 15) then
			selfSay("I have heard only little about this mine. I am a bit absorbed in my studies. But what does this mine have to do with me?", cid)
			talkState[talkUser] = 1
		end
	elseif(msgcontains(msg, "reason")) then
		if(talkState[talkUser] == 1) then
			if(getPlayerStorageValue(cid, Storage.TheNewFrontier.BribeTelas) < 1) then
				selfSay("Well it sounds like a good idea to test my golems in some real environment. I think it is acceptable to send some of them to Farmine.", cid)
				setPlayerStorageValue(cid, Storage.TheNewFrontier.BribeTelas, 1)
				setPlayerStorageValue(cid, Storage.TheNewFrontier.Mission05, getPlayerStorageValue(cid, Storage.TheNewFrontier.Mission05) + 1) --Questlog, The New Frontier Quest "Mission 05: Getting Things Busy"
			end
		end
	end
	return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
