local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

npcHandler:setMessage(MESSAGE_GREET, "Oink.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Bye.")

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	if (msgcontains(msg, "kiss")) then
		selfSay("Do you want to try to release me with a kiss?", cid)
		talkState[talkUser] = 1
	elseif (msgcontains(msg, "yes")) then
		if (talkState[talkUser] == 1) then
			selfSay("Mhm Uhhh. Not bad, not bad at all! But you can still improve your skill a LOT.", cid)
			talkState[talkUser] = 0
		end
	end
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
