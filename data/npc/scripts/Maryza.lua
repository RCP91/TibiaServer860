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

	

	if msgcontains(msg, 'cookbook') then
		if getPlayerStorageValue(cid, Storage.MaryzaCookbook) ~= 1 then
			selfSay('The cookbook of the famous dwarven kitchen. You\'re lucky. I have a few copies on sale. Do you like one for 150 gold?', cid)
			talkState[talkUser] = 1
		else
			selfSay('I\'m sorry but I sell only one copy to each customer. Otherwise they would have been sold out a long time ago.', cid)
		end

	elseif talkState[talkUser] == 1 then
		if msgcontains(msg, 'yes') then
			if not doPlayerRemoveMoney(cid, 150) then
				selfSay('No gold, no sale, that\'s it.', cid)
				return true
			end

			selfSay('Here you are. Happy cooking!', cid)
			setPlayerStorageValue(cid, Storage.MaryzaCookbook, 1)
			doPlayerAddItem(cid, 2347, 1)
		elseif msgcontains(msg, 'no') then
			selfSay('I have but a few copies, anyway.', cid)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, 'Welcome to the Jolly Axeman, |PLAYERNAME|. Have a good time and eat some food!')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
local focusModule = FocusModule:new()
focusModule:addGreetMessage('hello maryza')
focusModule:addGreetMessage('hi maryza')
focusModule:addGreetMessage('hello, maryza')
npcHandler:addModule(focusModule)
