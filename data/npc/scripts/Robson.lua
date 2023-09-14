local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{ text = '<mumbles>' },
	{ text = 'Just great. Getting stranded on a remote underground isle was not that bad but now I\'m becoming a tourist attraction!' }
}

--npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, 'parcel') then
		selfSay('Do you want to buy a parcel for 15 gold?', cid)
		talkState[talkUser] = 1
	elseif msgcontains(msg, 'label') then
		selfSay('Do you want to buy a label for 1 gold?', cid)
		talkState[talkUser] = 2
	elseif msgcontains(msg, 'yes') then
		
		if talkState[talkUser] == 1 then
			if not doPlayerRemoveMoney(cid, 15) then
				selfSay('Sorry, that\'s only dust in your purse.', cid)
				talkState[talkUser] = 0
				return true
			end

			doPlayerAddItem(cid, 2595, 1)
			selfSay('Fine.', cid)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 2 then
			if not doPlayerRemoveMoney(cid, 1) then
				selfSay('Sorry, that\'s only dust in your purse.', cid)
				talkState[talkUser] = 0
				return true
			end

			doPlayerAddItem(cid, 2599, 1)
			selfSay('Fine.', cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, 'no') then
		if isInArray({1, 2}, talkState[talkUser]) then
			selfSay('I knew I would be stuck with that stuff.', cid)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hrmpf, I'd say welcome if I felt like lying.")
npcHandler:setMessage(MESSAGE_FAREWELL, "See you next time!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "No patience at all!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
