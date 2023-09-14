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
	
	if msgcontains(msg, "riddle") then
		if getPlayerStorageValue(cid, Storage.madMageQuest) ~= 1 then
			selfSay("Great riddle, isn´t it? If you can tell me the correct answer, I will give you something. Hehehe!", cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, "PD-D-KS-P-PD") then
		if talkState[talkUser] == 1 then
			selfSay("Hurray! For that I will give you my key for - hmm - let´s say ... some apples. Interested?", cid)
			talkState[talkUser] = 2
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 2 then
			if doPlayerRemoveItem(cid, 2674, 1) then
				selfSay("Mnjam - excellent apples. Now - about that key. You are sure want it?", cid)
				talkState[talkUser] = 3
			else
				selfSay("Get some more apples first!", cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 3 then
			selfSay("Really, really?", cid)
			talkState[talkUser] = 4
		elseif talkState[talkUser] == 4 then
			selfSay("Really, really, really, really?", cid)
			talkState[talkUser] = 5
		elseif talkState[talkUser] == 5 then
			setPlayerStorageValue(cid, Storage.madMageQuest, 1)
			selfSay("Then take it and get happy - or die, hehe.", cid)
			local key = doPlayerAddItem(cid, 2088, 1)
			if key then
				key:setActionId(3666)
			end
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "no") then
		selfSay("Then go away!", cid)
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Wait! Don't leave! I want to tell you about my surreal numbers.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Next time we should talk about my surreal numbers.")
npcHandler:setMessage(MESSAGE_GREET, "Huh? What? I can see! Wow! A non-mino. Did they {capture} you as well?")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
