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

	if msgcontains(msg, "passage") then
		selfSay("Do you want to go back to {Yalahar}?", cid)
		talkState[talkUser] = 1
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			local destination = Position(32916, 31199, 7)
			Player(cid):teleportTo(destination)
			destination:sendMagicEffect(CONST_ME_TELEPORT)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Want to go back to Yalahar? Just ask me for a free {passage}.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
