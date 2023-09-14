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

	
	if(msgcontains(msg, "trouble") and getPlayerStorageValue(cid, Storage.TheInquisition.WalterGuard) < 1 and getPlayerStorageValue(cid, Storage.TheInquisition.Mission01) ~= -1) then
		selfSay("I think there is a pickpocket in town.", cid)
		talkState[talkUser] = 1
	elseif(msgcontains(msg, "authorities")) then
		if(talkState[talkUser] == 1) then
			selfSay("Well, sooner or later we will get hold of that delinquent. That's for sure.", cid)
			talkState[talkUser] = 2
		end
	elseif(msgcontains(msg, "avoided")) then
		if(talkState[talkUser] == 2) then
			selfSay("You can't tell by a person's appearance who is a pickpocket and who isn't. You simply can't close the city gates for everyone.", cid)
			talkState[talkUser] = 3
		end
	elseif(msgcontains(msg, "gods would allow")) then
		if(talkState[talkUser] == 3) then
			selfSay("If the gods had created the world a paradise, no one had to steal at all.", cid)
			talkState[talkUser] = 0
			if(getPlayerStorageValue(cid, Storage.TheInquisition.WalterGuard) < 1) then
				setPlayerStorageValue(cid, Storage.TheInquisition.WalterGuard, 1)
				setPlayerStorageValue(cid, Storage.TheInquisition.Mission01, getPlayerStorageValue(cid, Storage.TheInquisition.Mission01) + 1) -- The Inquisition Questlog- "Mission 1: Interrogation"
				player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())