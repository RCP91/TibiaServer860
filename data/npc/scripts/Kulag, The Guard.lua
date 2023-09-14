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
	
	if msgcontains(msg, "trouble") and getPlayerStorageValue(cid, Storage.TheInquisition.KulagGuard) < 1 and getPlayerStorageValue(cid, Storage.TheInquisition.Mission01) ~= -1 then
		selfSay("You adventurers become more and more of a pest.", cid)
		talkState[talkUser] = 1
	elseif msgcontains(msg, "authorities") then
		if talkState[talkUser] == 1 then
			selfSay("They should throw you all into jail instead of giving you all those quests and rewards an honest watchman can only dream about.", cid)
			if getPlayerStorageValue(cid, Storage.TheInquisition.KulagGuard) < 1 then
				setPlayerStorageValue(cid, Storage.TheInquisition.KulagGuard, 1)
				setPlayerStorageValue(cid, Storage.TheInquisition.Mission01, getPlayerStorageValue(cid, Storage.TheInquisition.Mission01) + 1) -- The Inquisition Questlog- "Mission 1: Interrogation"
				player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
			end
			talkState[talkUser] = 0
		end
	end
	return true
end

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "It's my duty to protect the city."})

npcHandler:setMessage(MESSAGE_GREET, "LONG LIVE THE KING!")
npcHandler:setMessage(MESSAGE_FAREWELL, "LONG LIVE THE KING!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "LONG LIVE THE KING!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
