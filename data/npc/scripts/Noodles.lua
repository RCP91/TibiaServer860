local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{ text = 'Grrrrrrr.' },
	{ text = '<wiggles>' },
	{ text = '<sniff>' },
	{ text = 'Woof! Woof!' },
	{ text = 'Wooof!' }
}

--npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	
	if msgcontains(msg, "banana skin") then
		if getPlayerStorageValue(cid, Storage.postman.Mission06) == 7 then
			if getPlayerItemCount(cid, 2219) > 0 then
				selfSay("<sniff><sniff>", cid)
				talkState[talkUser] = 1
			end
		end
	elseif msgcontains(msg, "dirty fur") then
		if getPlayerStorageValue(cid, Storage.postman.Mission06) == 8 then
			if getPlayerItemCount(cid, 2220) > 0 then
				selfSay("<sniff><sniff>", cid)
				talkState[talkUser] = 2
			end
		end
	elseif msgcontains(msg, "cheese") then
		if getPlayerStorageValue(cid, Storage.postman.Mission06) == 9 then
			if getPlayerItemCount(cid, 2235) > 0 then
				selfSay("<sniff><sniff>", cid)
				talkState[talkUser] = 3
			end
		end
	elseif msgcontains(msg, "like") then
		if talkState[talkUser] == 1  then
			selfSay("Woof!", cid)
			setPlayerStorageValue(cid, Storage.postman.Mission06, 8)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 2 then
			selfSay("Woof!", cid)
			setPlayerStorageValue(cid, Storage.postman.Mission06, 9)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 3 then
			selfSay("Meeep! Grrrrr! <spits>", cid)
			setPlayerStorageValue(cid, Storage.postman.Mission06, 10)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "<sniff> Woof! <sniff>")
npcHandler:setMessage(MESSAGE_FAREWELL, "Woof! <wiggle>")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Woof! <wiggle>")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
