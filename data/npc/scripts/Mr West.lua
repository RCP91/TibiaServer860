local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function greetCallback(cid)
	
	if(getPlayerStorageValue(cid, Storage.InServiceofYalahar.MrWestDoor) == 1) then
		npcHandler:setMessage(MESSAGE_GREET, "Wh .. What? How did you get here? Where are all the guards? You .. you could have killed me but yet you chose to talk? What a relief! ... So what brings you here my friend, if I might call you like that? ")
	elseif(getPlayerStorageValue(cid, Storage.InServiceofYalahar.MrWestDoor) == 2) then
		npcHandler:setMessage(MESSAGE_GREET, "Murderer! But .. I give in, you won! ... Dictate me your conditions but please, I beg you, spare my life. What do you want?")
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	if(msgcontains(msg, "mission")) then
		if(getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 24) then
			if(getPlayerStorageValue(cid, Storage.InServiceofYalahar.MrWestDoor) == 1) then
				selfSay("Indeed, I can see the benefits of a mutual agreement. I will later read the details and send a letter to your superior. ", cid)
				setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, 25)
				setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission04, 3) -- StorageValue for Questlog "Mission 04: Good to be Kingpin"
				setPlayerStorageValue(cid, Storage.InServiceofYalahar.MrWestStatus, 1)
				talkState[talkUser] = 0
			elseif(getPlayerStorageValue(cid, Storage.InServiceofYalahar.MrWestDoor) == 2) then
				selfSay("Yes, for the sake of my life I'll accept those terms. I know when I have lost. Tell your master I will comply with his orders. ", cid)
				setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, 25)
				setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission04, 4) -- StorageValue for Questlog "Mission 04: Good to be Kingpin"
				setPlayerStorageValue(cid, Storage.InServiceofYalahar.MrWestStatus, 2)
				talkState[talkUser] = 0
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
