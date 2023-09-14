local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	

	if msgcontains(msg, 'egg') then
		selfSay('Do you like ten eggs for 50 gold?', cid)
			talkState[talkUser] = 1
	elseif talkState[talkUser] == 1 then
		if msgcontains(msg, 'yes') then
			if not doPlayerRemoveMoney(cid, 50) then
				selfSay('No gold, no sale, that\'s it.', cid)
				return true
			end
			selfSay('Here you are.', cid)			
			doPlayerAddItem(cid, 2695, 10)
		elseif msgcontains(msg, 'no') then
			selfSay('I have but a few eggs, anyway.', cid)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, 'Welcome to the Creature Products Supermarket, |PLAYERNAME|. Have a good time!')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
local focusModule = FocusModule:new()
focusModule:addGreetMessage('hi')
npcHandler:addModule(focusModule)
