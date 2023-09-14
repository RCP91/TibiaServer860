local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end
	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

	
	if msgcontains(msg, "Hydra Tongue") then
		selfSay("Do you want to buy a Hydra Tongue for 100 gold?", cid)
		talkState[talkUser] = 1
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			if getPlayerBalance(cid) + getPlayerBalance(cid) >= 100 then
				doPlayerRemoveMoney(cid, 100)
				selfSay("Here you are. A Hydra Tongue!", cid)
				doPlayerAddItem(cid, 7250, 1)
				talkState[talkUser] = 0
			else
				selfSay("You don't have enough money.", cid)
			end
		end
	elseif msgcontains(msg, "no") then
		if talkState[talkUser] == 1 then
			selfSay("Then not.", cid)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
