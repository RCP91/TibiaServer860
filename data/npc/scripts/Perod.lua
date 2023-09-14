local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = { {text = 'Stop by before embarking on your great adventure! Distance weapons and general equipment on sale today!'} }
--npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	if msgcontains(msg, "football") then
		selfSay("Do you want to buy a football for 111 gold?", cid)
		talkState[talkUser] = 1
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			
			if getPlayerBalance(cid) + getPlayerBalance(cid) >= 111 then
				selfSay("Here it is.", cid)
				doPlayerAddItem(cid, 2109, 1)
				doPlayerRemoveMoney(cid, 111)
			else
				selfSay("You don't have enough money.", cid)
			end
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye, |PLAYERNAME|.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())