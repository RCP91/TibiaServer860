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
	
	if msgcontains(msg, "mission") then
		if getPlayerStorageValue(cid, Storage.CaptainHaba) <= 1 then
			selfSay("Ya wanna join the hunt fo' the sea serpent? Be warned ya may pay with ya life! Are ya in to it?", cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			selfSay("A'right, we are here to resupply our stock of baits to catch the sea serpent. Your first task is to bring me 5 fish they are easy to catch. When you got them ask me for the bait again.", cid)
			setPlayerStorageValue(cid, Storage.CaptainHaba, 2)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 7 then
			selfSay("Let's go fo' a hunt and bring the beast down!", cid)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:teleportTo(Position(31947, 31045, 6), false)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			talkState[talkUser] = 8
		end
	elseif msgcontains(msg, "bait") then
		if getPlayerStorageValue(cid, Storage.CaptainHaba) == 2 then
			if doPlayerRemoveItem(cid, 2667, 5) then
				selfSay("Excellent, now bring me 5 northern pike.", cid)
				setPlayerStorageValue(cid, Storage.CaptainHaba, 3)
				talkState[talkUser] = 3
			else
				selfSay("Bring me 5 fish.", cid)
			end
		elseif getPlayerStorageValue(cid, Storage.CaptainHaba) == 3 then
			if doPlayerRemoveItem(cid, 2669, 5) then
				selfSay("Excellent, now bring me 5 green perch.", cid)
				setPlayerStorageValue(cid, Storage.CaptainHaba, 4)
				talkState[talkUser] = 4
			else 
				selfSay("Bring me 5 northern pike.", cid)
			end
		elseif getPlayerStorageValue(cid, Storage.CaptainHaba) == 4 then
			if doPlayerRemoveItem(cid, 7159, 5) then
				selfSay("Excellent, now bring me 5 rainbow trout.", cid)
				setPlayerStorageValue(cid, Storage.CaptainHaba, 5)
				talkState[talkUser] = 5
			else 
				selfSay("Bring me 5 green perch.", cid)
			end
		elseif getPlayerStorageValue(cid, Storage.CaptainHaba) == 5 then
			if doPlayerRemoveItem(cid, 7158, 5) then
				selfSay("Excellent, that should be enough fish to make the bait. Tell me when ya're ready fo' the hunt.", cid)
				setPlayerStorageValue(cid, Storage.CaptainHaba, 6)
				talkState[talkUser] = 6
			else 
				selfSay("Bring me 5 rainbow trout.", cid)
			end
		end
	elseif msgcontains(msg, "hunt") then
		if getPlayerStorageValue(cid, Storage.CaptainHaba) == 6 then
			selfSay("A'right, wanna put out to sea?", cid)
			talkState[talkUser] = 7
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Harrr, landlubber wha'd ya want?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Bye.")
npcHandler:addModule(FocusModule:new())
