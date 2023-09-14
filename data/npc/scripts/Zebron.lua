local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = { {text = 'Hey mate, up for a game of dice?'} }
--npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	if msgcontains(msg, 'yes') then
		if talkState[talkUser] == 0 then
			selfSay('Hmmm, would you like to play for {money} or for a chance to win your own {dice}?', cid)
			talkState[talkUser] = 2
		elseif talkState[talkUser] == 4 then
			if not doPlayerRemoveMoney(cid, 100) then
				selfSay('I am sorry, but you don\'t have so much money.', cid)
				talkState[talkUser] = 0
				return false
			end

			Npc():getPosition():sendMagicEffect(CONST_ME_CRAPS)
			local realRoll = math.random(30)
			local roll = math.random(5)
			if realRoll < 30 then
				selfSay('Ok, here we go ... '.. roll ..'! You have lost. Bad luck. One more game?', cid)
			else
				selfSay('Ok, here we go ... 6! You have won a dice, congratulations. One more game?', cid)
				doPlayerAddItem(cid, 5792, 1)
			end
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, 'game') then
		if talkState[talkUser] == 1 then
			selfSay('So you care for a civilized game of dice?', cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, 'money') then
		if talkState[talkUser] == 2 then
			selfSay('I thought so. Okay, I will roll a dice. If it shows 6, you will get five times your bet. How much do you want to bet?', cid)
			talkState[talkUser] = 3
		end
	elseif msgcontains(msg, 'dice') then
		if talkState[talkUser] == 2 then
			selfSay('Hehe, good choice. Okay, the price for this game is 100 gold pieces. I will roll a dice. If I roll a 6, you can have my dice. Agreed?', cid)
			talkState[talkUser] = 4
		end
	elseif tonumber(msg) then
		local amount = tonumber(msg)
		if amount < 1 or amount > 99 then
			selfSay('I am sorry, but I accept only bets between 1 and 99 gold. I don\'t want to ruin you after all. How much do you want to bet?', cid)
			talkState[talkUser] = 3
			return false
		end

		if not doPlayerRemoveMoney(cid, amount) then
			selfSay('I am sorry, but you don\'t have so much money.', cid)
			talkState[talkUser] = 0
			return false
		end

		Npc():getPosition():sendMagicEffect(CONST_ME_CRAPS)
		local roll = math.random(6)
		if roll < 6 then
			selfSay('Ok, here we go ... '.. roll ..'! You have lost. Bad luck. One more game?', cid)
		else
			selfSay('Ok, here we go ... 6! You have won '.. amount * 5 ..', congratulations. One more game?', cid)
			player:addMoney(amount * 5)
		end
		talkState[talkUser] = 0
	elseif msgcontains(msg, 'no') then
		selfSay('Oh come on, don\'t be a child.', cid)
		talkState[talkUser] = 1
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, 'Greetings, high roller. So you care for a game, |PLAYERNAME|?')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Hey, you can\'t leave. Luck is smiling on you. I can feel it!')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Hey, you can\'t leave, |PLAYERNAME|. Luck is smiling on you. I can feel it!')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
