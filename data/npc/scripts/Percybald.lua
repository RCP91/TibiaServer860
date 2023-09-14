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
	
	if msgcontains(msg, 'disguise') then
		if getPlayerStorageValue(cid, Storage.thievesGuild.TheatreScript) < 0 then
			selfSay({
				'Hmpf. Why should I waste my time to help some amateur? I\'m afraid I can only offer my assistance to actors that are as great as I am. ...',
				'Though, your futile attempt to prove your worthiness could be amusing. Grab a copy of a script from the prop room at the theatre cellar. Then talk to me again about your test!'
			}, cid)
			setPlayerStorageValue(cid, Storage.thievesGuild.TheatreScript, 0)
		end
	elseif msgcontains(msg, 'test') then
		if getPlayerStorageValue(cid, Storage.thievesGuild.Mission04) == 5 then
			selfSay('I hope you learnt your role! I\'ll tell you a line from the script and you\'ll have to answer with the corresponding line! Ready?', cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, 'yes') then
		if talkState[talkUser] == 1 then
			selfSay('How dare you? Are you mad? I hold the princess hostage and you drop your weapons. You\'re all lost!', cid)
			talkState[talkUser] = 2
		elseif talkState[talkUser] == 3 then
			selfSay('Too late puny knight. You can\'t stop my master plan anymore!', cid)
			talkState[talkUser] = 4
		elseif talkState[talkUser] == 5 then
			selfSay('What\'s this? Behind the doctor?', cid)
			talkState[talkUser] = 6
		elseif talkState[talkUser] == 7 then
			selfSay('Grrr!', cid)
			talkState[talkUser] = 8
		elseif talkState[talkUser] == 9 then
			selfSay('You\'re such a monster!', cid)
			talkState[talkUser] = 10
		elseif talkState[talkUser] == 11 then
			selfSay('Ah well, I think you passed the test! Here is your disguise kit! Now get lost, fate awaits me!', cid)
			setPlayerStorageValue(cid, Storage.thievesGuild.Mission04, 6)
			doPlayerAddItem(cid, 8693, 1)
			talkState[talkUser] = 0
		end
	elseif talkState[talkUser] == 2 then
		if msgcontains(msg, 'I don\'t think so, dear doctor!') then
			selfSay('Ok, ok. You\'ve got this one right! Ready for the next one?', cid)
			talkState[talkUser] = 3
		else
			selfSay('No no no! That is not correct!', cid)
			talkState[talkUser] = 0
		end
	elseif talkState[talkUser] == 4 then
		if msgcontains(msg, 'Watch out! It\'s a trap!') then
			selfSay('Ok, ok. You\'ve got this one right! Ready for the next one?', cid)
			talkState[talkUser] = 5
		else
			selfSay('No no no! That is not correct!', cid)
			talkState[talkUser] = 0
		end
	elseif talkState[talkUser] == 6 then
		if msgcontains(msg, 'Look! It\'s Lucky, the wonder dog!') then
			selfSay('Ok, ok. You\'ve got this one right! Ready for the next one?', cid)
			talkState[talkUser] = 7
		else
			selfSay('No no no! That is not correct!', cid)
			talkState[talkUser] = 0
		end
	elseif talkState[talkUser] == 8 then
		if msgcontains(msg, 'Ahhhhhh!') then
			selfSay('Ok, ok. You\'ve got this one right! Ready for the next one?', cid)
			talkState[talkUser] = 9
		else
			selfSay('No no no! That is not correct!', cid)
			talkState[talkUser] = 0
		end
	elseif talkState[talkUser] == 10 then
		if msgcontains(msg, 'Hahaha! Now drop your weapons or else...') then
			selfSay('Ok, ok. You\'ve got this one right! Ready for the next one?', cid)
			talkState[talkUser] = 11
		else
			selfSay('No no no! That is not correct!', cid)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Be greeted |PLAYERNAME|!")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
