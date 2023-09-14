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
	
	if msgcontains(msg, "trouble") and getPlayerStorageValue(cid, Storage.TheInquisition.GrofGuard) < 1 and getPlayerStorageValue(cid, Storage.TheInquisition.Mission01) ~= -1 then
		selfSay("I think it'll rain soon and I left some laundry out for drying.", cid)
		talkState[talkUser] = 1
	elseif msgcontains(msg, "authorities") then
		if talkState[talkUser] == 1 then
			selfSay("Yes I'm pretty sure they have failed to send the laundry police to take care of it, you fool.", cid)
			talkState[talkUser] = 0
			if getPlayerStorageValue(cid, Storage.TheInquisition.GrofGuard) < 1 then
				setPlayerStorageValue(cid, Storage.TheInquisition.GrofGuard, 1)
				setPlayerStorageValue(cid, Storage.TheInquisition.Mission01, getPlayerStorageValue(cid, Storage.TheInquisition.Mission01) + 1) -- The Inquisition Questlog- "Mission 1: Interrogation"
				player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
			end
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
