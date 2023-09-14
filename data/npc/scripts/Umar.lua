local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local function greetCallback(cid, message)
	
	if not msgcontains(message, 'djanni\'hah') and getPlayerStorageValue(cid, Storage.DjinnWar.Faction.Marid) ~= 1 then
		selfSay('Whoa! A human! This is no place for you, |PLAYERNAME|. Go and play somewhere else.', cid)
		return false
	end

	if getPlayerStorageValue(cid, Storage.DjinnWar.Faction.Greeting) == -1 then
		selfSay({
			'Hahahaha! ...',
			'|PLAYERNAME|, that almost sounded like the word of greeting. Humans - cute they are!'
		}, cid)
		return false
	end

	if getPlayerStorageValue(cid, Storage.DjinnWar.Faction.Marid) ~= 1 then
		npcHandler:setMessage(MESSAGE_GREET, {
			'Whoa? You know the word! Amazing, |PLAYERNAME|! ...',
			'I should go and tell Fa\'hradin. ...',
			'Well. Why are you here anyway, |PLAYERNAME|?'
		})
	else
		npcHandler:setMessage(MESSAGE_GREET, '|PLAYERNAME|! How\'s it going these days? What brings you {here}?')
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	

	-- To Appease the Mighty Quest
	if msgcontains(msg, "mission") and getPlayerStorageValue(cid, Storage.TibiaTales.ToAppeaseTheMightyQuest) == 1 then
			selfSay({
				'I should go and tell Fa\'hradin. ...',
				'I am impressed you know our address of welcome! I honour that. So tell me who sent you on a mission to our fortress?'}, cid)
			talkState[talkUser] = 9
			elseif msgcontains(msg, "kazzan") and talkState[talkUser] == 9 then
			selfSay({
				'How dare you lie to me?!? The caliph should choose his envoys more carefully. We will not accept his peace-offering ...',
				'...but we are always looking for support in our fight against the evil Efreets. Tell me if you would like to join our fight.'}, cid)
			setPlayerStorageValue(cid, Storage.TibiaTales.ToAppeaseTheMightyQuest, getPlayerStorageValue(cid, Storage.TibiaTales.ToAppeaseTheMightyQuest) + 1)
	end

	if msgcontains(msg, 'passage') then
		if getPlayerStorageValue(cid, Storage.DjinnWar.Faction.Marid) ~= 1 then
			selfSay({
				'If you want to enter our fortress you have to become one of us and fight the Efreet. ...',
				'So, are you willing to do so?'
			}, cid)
			talkState[talkUser] = 1
		else
			selfSay('You already have the permission to enter Ashta\'daramai.', cid)
		end

	elseif talkState[talkUser] == 1 then
		if msgcontains(msg, 'yes') then
			if getPlayerStorageValue(cid, Storage.DjinnWar.Faction.Efreet) ~= 1 then
				selfSay('Are you sure? You pledge loyalty to king Gabel, who is... you know. And you are willing to never ever set foot on Efreets\' territory, unless you want to kill them? Yes?', cid)
				talkState[talkUser] = 2
			else
				selfSay('I don\'t believe you! You better go now.', cid)
				talkState[talkUser] = 0
			end

		elseif msgcontains(msg, 'no') then
			selfSay('This isn\'t your war anyway, human.', cid)
			talkState[talkUser] = 0
		end

	elseif talkState[talkUser] == 2 then
		if msgcontains(msg, 'yes') then
			selfSay({
				'Oh. Ok. Welcome then. You may pass. ...',
				'And don\'t forget to kill some Efreets, now and then.'
			}, cid)
			setPlayerStorageValue(cid, Storage.DjinnWar.Faction.Marid, 1)
			setPlayerStorageValue(cid, Storage.DjinnWar.Faction.Greeting, 0)

		elseif msgcontains(msg, 'no') then
			selfSay('This isn\'t your war anyway, human.', cid)
		end
		talkState[talkUser] = 0
	end
	return true
end

npcHandler:setMessage(MESSAGE_FAREWELL, '<salutes>Aaaa -tention!')
npcHandler:setMessage(MESSAGE_WALKAWAY, '<salutes>Aaaa -tention!')

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

local focusModule = FocusModule:new()
focusModule:addGreetMessage('hi')
focusModule:addGreetMessage('hello')
focusModule:addGreetMessage('djanni\'hah')
npcHandler:addModule(focusModule)
