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
	
	if msgcontains(msg, "trouble") and talkState[talkUser] ~= 3 and getPlayerStorageValue(cid, Storage.TheInquisition.MilesGuard) < 1 and getPlayerStorageValue(cid, Storage.TheInquisition.Mission01) ~= -1 then
		selfSay("I'm fine. There's no trouble at all.", cid)
		talkState[talkUser] = 1
	elseif msgcontains(msg, "foresight of the authorities") and talkState[talkUser] == 1 then
		selfSay("Well, of course. We live in safety and peace.", cid)
		talkState[talkUser] = 2
	elseif msgcontains(msg, "also for the gods") and talkState[talkUser] == 2 then
		selfSay("I think the gods are looking after us and their hands shield us from evil.", cid)
		talkState[talkUser] = 3
	elseif msgcontains(msg, "trouble will arise in the near future") and talkState[talkUser] == 3 then
		selfSay("I think the gods and the government do their best to keep away harm from the citizens.", cid)
		talkState[talkUser] = 0
		if getPlayerStorageValue(cid, Storage.TheInquisition.MilesGuard) < 1 then
			setPlayerStorageValue(cid, Storage.TheInquisition.MilesGuard, 1)
			setPlayerStorageValue(cid, Storage.TheInquisition.Mission01, getPlayerStorageValue(cid, Storage.TheInquisition.Mission01) + 1) -- The Inquisition Questlog- "Mission 1: Interrogation"
			player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
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
