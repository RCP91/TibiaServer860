 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = { {text = 'Now, where was I...'} }
--npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	local missionProgress = getPlayerStorageValue(cid, Storage.DjinnWar.MaridFaction.Mission01)
	if msgcontains(msg, 'recipe') or msgcontains(msg, 'mission') then
		if missionProgress < 1 then
			selfSay({
				'My collection of recipes is almost complete. There are only but a few that are missing. ...',
				'Hmmm... now that we talk about it. There is something you could help me with. Are you interested?'
			}, cid)
			talkState[talkUser] = 1
		else
			selfSay('I already told you about the recipes I am missing, now please try to find a cookbook of the dwarven kitchen.', cid)
		end

	elseif msgcontains(msg, 'cookbook') then
		if missionProgress == -1 then
			selfSay({
				'I\'m preparing the food for all djinns in Ashta\'daramai. ...',
				'Therefore, I\'m what is commonly called a cook, although I do not like that word too much. It is vulgar. I prefer to call myself \'chef\'.'
			}, cid)
		elseif missionProgress == 1 then
			selfSay('Do you have the cookbook of the dwarven kitchen with you? Can I have it?', cid)
			talkState[talkUser] = 2
		else
			selfSay('Thanks again, for bringing me that book!', cid)
		end

	elseif talkState[talkUser] == 1 then
		if msgcontains(msg, 'yes') then
			selfSay({
				'Fine! Even though I know so many recipes, I\'m looking for the description of some dwarven meals. ...',
				'So, if you could bring me a cookbook of the dwarven kitchen, I\'ll reward you well.'
			}, cid)
			setPlayerStorageValue(cid, Storage.DjinnWar.MaridFaction.Mission01, 1)

		elseif msgcontains(msg, 'no') then
			selfSay('Well, too bad.', cid)
		end
		talkState[talkUser] = 0

	elseif talkState[talkUser] == 2 then
		if msgcontains(msg, 'yes') then
			if not doPlayerRemoveItem(cid, 2347, 1) then
				selfSay('Too bad. I must have this book.', cid)
				return true
			end

			selfSay({
				'The book! You have it! Let me see! <browses the book> ...',
				'Dragon Egg Omelette, Dwarven beer sauce... it\'s all there. This is great! Here is your well-deserved reward. ...',
				'Incidentally, I have talked to Fa\'hradin about you during dinner. I think he might have some work for you. Why don\'t you talk to him about it?'
			}, cid)
			setPlayerStorageValue(cid, Storage.DjinnWar.MaridFaction.Mission01, 2)
			doPlayerAddItem(cid, 2146, 3)

		elseif msgcontains(msg, 'no') then
			selfSay('Too bad. I must have this book.', cid)
		end
		talkState[talkUser] = 0
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, 'Hey! A human! What are you doing in my kitchen, |PLAYERNAME|?')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Goodbye. I am sure you will come back for more. They all do.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Goodbye. I am sure you will come back for more. They all do.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

local focusModule = FocusModule:new()
focusModule:addGreetMessage('hi')
focusModule:addGreetMessage('hello')
focusModule:addGreetMessage('djanni\'hah')
npcHandler:addModule(focusModule)
