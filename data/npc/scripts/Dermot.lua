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
	
	if msgcontains(msg, "present") then
		if getPlayerStorageValue(cid, Storage.postman.Mission05) == 2 then
			selfSay("You have a present for me?? Realy?", cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, "key") then
		selfSay("Do you want to buy the dungeon key for 2000 gold?", cid)
		talkState[talkUser] = 2
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			if doPlayerRemoveItem(cid, 2331, 1) then
				selfSay("Thank you very much!", cid)
				setPlayerStorageValue(cid, Storage.postman.Mission05, 3)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 2 then
			if doPlayerRemoveMoney(cid, 2000) then
				selfSay("Here it is.", cid)
				local key = doPlayerAddItem(cid, 2087, 1)
				if key then
					key:setActionId(3940)
				end
			else
				selfSay("You don't have enough money.", cid)
			end
			talkState[talkUser] = 0
		end
	end
	return true
end

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I am the magistrate of this isle."})
keywordHandler:addKeyword({'magistrate'}, StdModule.say, {npcHandler = npcHandler, text = "Thats me."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "I am Dermot, the magistrate of this isle."})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = "Time is not important on Fibula."})
keywordHandler:addKeyword({'fibula'}, StdModule.say, {npcHandler = npcHandler, text = "You are at Fibula. This isle is not very dangerous. Just the wolves bother outside the village."})
keywordHandler:addKeyword({'dungeon'}, StdModule.say, {npcHandler = npcHandler, text = "Oh, my god. In the dungeon of Fibula are a lot of monsters. That's why we have sealed it with a solid door."})
keywordHandler:addKeyword({'monsters'}, StdModule.say, {npcHandler = npcHandler, text = "Oh, my god. In the dungeon of Fibula are a lot of monsters. That's why we have sealed it with a solid door."})

npcHandler:setMessage(MESSAGE_GREET, "Hello, traveller |PLAYERNAME|. How can I help you?")
npcHandler:setMessage(MESSAGE_FAREWELL, "See you again.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "See you again.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
