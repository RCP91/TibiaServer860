local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = { {text = 'Pssst!'} }
--npcHandler:addModule(VoiceModule:new(voices))

local function greetCallback(cid)
	

	if getPlayerStorageValue(cid, Storage.secretService.AVINMission01) == 1 and getPlayerItemCount(cid, 12666) > 0 then
		setPlayerStorageValue(cid, Storage.secretService.AVINMission01, 2)
		selfSay("I don't like the way you look. Help me boys!", cid)
		for i = 1, 2 do
			Game.createMonster("Bandit", Npc():getPosition())
		end
		talkState[talkUser] = 0
	else
		npcHandler:setMessage(MESSAGE_GREET, "Pssst! Be silent. Do you wish to {buy} something?")
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	

	if msgcontains(msg, "letter") then
		if getPlayerStorageValue(cid, Storage.secretService.AVINMission01) == 2 then
			selfSay("You have a letter for me?", cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			if doPlayerRemoveItem(cid, 12666, 1) then
				setPlayerStorageValue(cid, Storage.secretService.AVINMission01, 3)
				selfSay("Oh well. I guess I am still on the hook. Tell your 'uncle' I will proceed as he suggested.", cid)
			else
				selfSay("You don't have any letter!", cid)
			end
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Bye. Tell others about... my little shop here.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Bye. Tell others about... my little shop here.")
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
