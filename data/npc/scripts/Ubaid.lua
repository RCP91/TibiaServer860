local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local function greetCallback(cid, message)
	
	if not msgcontains(message, 'djanni\'hah') and getPlayerStorageValue(cid, Storage.DjinnWar.Faction.Efreet) ~= 1 then
		selfSay('Shove off, little one! Humans are not welcome here, |PLAYERNAME|!', cid)
		return false
	end

	if getPlayerStorageValue(cid, Storage.DjinnWar.Faction.Greeting) == -1 then
		selfSay({
			'Hahahaha! ...',
			'|PLAYERNAME|, that almost sounded like the word of greeting. Humans - cute they are!'
		}, cid)
		return false
	end

	if getPlayerStorageValue(cid, Storage.DjinnWar.Faction.Efreet) ~= 1 then
		npcHandler:setMessage(MESSAGE_GREET, 'What? You know the word, |PLAYERNAME|? All right then - I won\'t kill you. At least, not now.  What brings you {here}?')
	else
		npcHandler:setMessage(MESSAGE_GREET, 'Still alive, |PLAYERNAME|? What brings you {here}?')
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	

	-- To Appease the Mighty Quest
	if msgcontains(msg, "mission") and getPlayerStorageValue(cid, Storage.TibiaTales.ToAppeaseTheMightyQuest) == 2 then
			selfSay({
				'You have the smell of the Marid on you. Tell me who sent you?'}, cid)
			talkState[talkUser] = 9
			elseif msgcontains(msg, "kazzan") and talkState[talkUser] == 9 then
			selfSay({
				'And he is sending a worm like you to us!?! The mighty Efreet!! Tell him that we won\'t be part in his \'great\' plans and now LEAVE!! ...',
				'...or do you want to join us and fight those stinking Marid who claim themselves to be noble and righteous?!? Just let me know.'}, cid)
			setPlayerStorageValue(cid, Storage.TibiaTales.ToAppeaseTheMightyQuest, getPlayerStorageValue(cid, Storage.TibiaTales.ToAppeaseTheMightyQuest) + 1)
	end

	if msgcontains(msg, 'passage') then
		if getPlayerStorageValue(cid, Storage.DjinnWar.Faction.Efreet) ~= 1 then
			selfSay({
				'Only the mighty Efreet, the true djinn of Tibia, may enter Mal\'ouquah! ...',
				'All Marid and little worms like yourself should leave now or something bad may happen. Am I right?'
			}, cid)
			talkState[talkUser] = 1
		else
			selfSay('You already pledged loyalty to king Malor!', cid)
		end

	elseif msgcontains(msg, 'here') then
			selfSay({
				'Only the mighty Efreet, the true djinn of Tibia, may enter Mal\'ouquah! ...',
				'All Marid and little worms like yourself should leave now or something bad may happen. Am I right?'
			}, cid)
			talkState[talkUser] = 1

	elseif talkState[talkUser] == 1 then
		if msgcontains(msg, 'yes') then
			selfSay('Of course. Then don\'t waste my time and shove off.', cid)
			talkState[talkUser] = 0

		elseif msgcontains(msg, 'no') then
			if getPlayerStorageValue(cid, Storage.DjinnWar.Faction.Marid) == 1 then
				selfSay('Who do you think you are? A Marid? Shove off you worm!', cid)
				talkState[talkUser] = 0
			else
				selfSay({
					'Of cour... Huh!? No!? I can\'t believe it! ...',
					'You... you got some nerves... Hmm. ...',
					'Maybe we have some use for someone like you. Would you be interested in working for us. Helping to fight the Marid?'
				}, cid)
				talkState[talkUser] = 2
			end
		end

	elseif talkState[talkUser] == 2 then
		if msgcontains(msg, 'yes') then
			selfSay('So you pledge loyalty to king Malor and you are willing to never ever set foot on Marid\'s territory, unless you want to kill them? Yes?', cid)
			talkState[talkUser] = 3

		elseif msgcontains(msg, 'no') then
			selfSay('Of course. Then don\'t waste my time and shove off.', cid)
			talkState[talkUser] = 0
		end

	elseif talkState[talkUser] == 3 then
		if msgcontains(msg, 'yes') then
			selfSay({
				'Well then - welcome to Mal\'ouquah. ...',
				'Go now to general Baa\'leal and don\'t forget to greet him correctly! ...',
				'And don\'t touch anything!'
			}, cid)
			setPlayerStorageValue(cid, Storage.DjinnWar.Faction.Efreet, 1)
			setPlayerStorageValue(cid, Storage.DjinnWar.Faction.Greeting, 0)

		elseif msgcontains(msg, 'no') then
			selfSay('Of course. Then don\'t waste my time and shove off.', cid)
		end
		talkState[talkUser] = 0
	end
	return true
end

npcHandler:setMessage(MESSAGE_FAREWELL, 'Farewell human!')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Farewell human!')

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

local focusModule = FocusModule:new()
focusModule:addGreetMessage('hi')
focusModule:addGreetMessage('hello')
focusModule:addGreetMessage('djanni\'hah')
npcHandler:addModule(focusModule)
