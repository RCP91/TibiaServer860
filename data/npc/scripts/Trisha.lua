local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local config = {
	['hardened bones'] = {
		storageValue = 1,
		message = {
			wrongValue = 'Well, I\'ll give you a little hint. They can sometimes be extracted from creatures that consist only of - you guessed it, bones. You need an obsidian knife though.',
			deliever = 'How are you faring with your mission? Have you collected all 100 hardened bones?',
			success = 'I\'m surprised. That\'s pretty good for a man. Now, bring us the 100 turtle shells.'
		},
		itemId = 5925,
		count = 100
	},
	['turtle shells'] = {
		storageValue = 2,
		message = {
			wrongValue = 'Turtles can be found on some idyllic islands which have recently been discovered.',
			deliever = 'Did you get us 100 turtle shells so we can make new shields?',
			success = 'Well done - for a man. These shells are enough to build many strong new shields. Thank you! Now - show me fighting spirit.'
		},
		itemId = 5899,
		count = 100
	},
	['fighting spirit'] = {
		storageValue = 3,
		message = {
			wrongValue = 'You should have enough fighting spirit if you are a true hero. Sorry, but you have to figure this one out by yourself. Unless someone grants you a wish.',
			deliever = 'So, can you show me your fighting spirit?',
			success = 'Correct - pretty smart for a man. But the hardest task is yet to come: the claw from a lord among the dragon lords.'
		},
		itemId = 5884
	},
	['dragon claw'] = {
		storageValue = 4,
		message = {
			wrongValue = 'You cannot get this special red claw from any common dragon in Tibia. It requires a special one, a lord among the lords.',
			deliever = 'Have you actually managed to obtain the dragon claw I asked for?',
			success = 'You did it! I have seldom seen a man as courageous as you. I really have to say that you deserve to wear a spike. Go ask Cornelia to adorn your armour.'
		},
		itemId = 5919
	}
}

local message = {}

local function greetCallback(cid)
	npcHandler:setMessage(MESSAGE_GREET, 'Salutations, |PLAYERNAME|. What can I do for you?')
	message[cid] = nil
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player, storage = Player(cid), Storage.OutfitQuest.WarriorShoulderAddon

	if talkState[talkUser] == 0 then
		if isInArray({'outfit', 'addon'}, msg) then
			selfSay('Are you talking about my spiky shoulder pad? You can\'t buy one of these. They have to be {earned}.', cid)
		elseif msgcontains(msg, 'earn') then
			if getPlayerStorageValue(cid, storage) < 1 then
				selfSay('I\'m not sure if you are enough of a hero to earn them. You could try, though. What do you think?', cid)
				talkState[talkUser] = 1
			elseif getPlayerStorageValue(cid, storage) >= 1 and getPlayerStorageValue(cid, storage) < 5 then
				selfSay('Before I can nominate you for an award, please complete your task.', cid)
			elseif getPlayerStorageValue(cid, storage) == 5 then
				selfSay('You did it! I have seldom seen a man as courageous as you. I really have to say that you deserve to wear a spike. Go ask Cornelia to adorn your armour.', cid)
			end
		elseif config[msg:lower()] then
			local targetMessage = config[msg:lower()]
			if getPlayerStorageValue(cid, storage) ~= targetMessage.storageValue then
				selfSay(targetMessage.message.wrongValue, cid)
				return true
			end

			selfSay(targetMessage.message.deliever, cid)
			talkState[talkUser] = 3
			message[cid] = targetMessage
		end
	elseif talkState[talkUser] == 1 then
		if msgcontains(msg, 'yes') then
			selfSay({
				'Okay, who knows, maybe you have a chance. A really small one though. Listen up: ...',
				'First, you have to prove your guts by bringing me 100 hardened bones. ...',
				'Next, if you actually managed to collect that many, please complete a small task for our guild and bring us 100 turtle shells. ...',
				'It is said that excellent shields can be created from these. ...',
				'Alright, um, afterwards show me that you have fighting spirit. Any true hero needs plenty of that. ...',
				'The last task is the hardest. You will need to bring me a claw from a mighty dragon king. ...',
				'Did you understand everything I told you and are willing to handle this task?'
			}, cid)
			talkState[talkUser] = 2
		elseif msgcontains(msg, 'no') then
			selfSay('I thought so. Train hard and maybe some day you will be ready to face this mission.', cid)
			talkState[talkUser] = 0
		end
	elseif talkState[talkUser] == 2 then
		if msgcontains(msg, 'yes') then
			setPlayerStorageValue(cid, storage, 1)
			setPlayerStorageValue(cid, Storage.OutfitQuest.DefaultStart, 1) --this for default start of Outfit and Addon Quests
			selfSay('Excellent! Don\'t forget: Your first task is to bring me 100 hardened bones. Good luck!', cid)
			talkState[talkUser] = 0
		elseif msgcontains(msg, 'no') then
			selfSay('Would you like me to repeat the task requirements then?', cid)
			talkState[talkUser] = 1
		end
	elseif talkState[talkUser] == 3 then
		if msgcontains(msg, 'yes') then
			local targetMessage = message[cid]
			if not doPlayerRemoveItem(cid, targetMessage.itemId, targetMessage.count or 1) then
				selfSay('Why do men always lie?', cid)
				return true
			end

			setPlayerStorageValue(cid, storage, getPlayerStorageValue(cid, storage) + 1)
			selfSay(targetMessage.message.success, cid)
		elseif msgcontains(msg, 'no') then
			selfSay('Don\'t give up just yet.', cid)
		end
		talkState[talkUser] = 0
	end
	return true
end

keywordHandler:addSpellKeyword({'cure','poison'}, {npcHandler = npcHandler, spellName = 'Cure Poison', price = 150, level = 10, vocation ={4}})
keywordHandler:addSpellKeyword({'find','person'}, {npcHandler = npcHandler, spellName = 'Find Person', price = 80, level = 8, vocation ={4}})
keywordHandler:addSpellKeyword({'great','light'}, {npcHandler = npcHandler, spellName = 'Great Light', price = 500, level = 13, vocation ={4}})
keywordHandler:addSpellKeyword({'light'}, {npcHandler = npcHandler, spellName = 'Light', price = 0, level = 8, vocation ={4}})
keywordHandler:addKeyword({'healing', 'spells'}, StdModule.say, {npcHandler = npcHandler, text = "In this category I have '{Cure Poison}'."})
keywordHandler:addKeyword({'support', 'spells'}, StdModule.say, {npcHandler = npcHandler, text = "In this category I have '{Find Person}', '{Great Light}' and '{Light}'."})
keywordHandler:addKeyword({'spells'}, StdModule.say, {npcHandler = npcHandler, text = 'I can teach you {Healing spells} and {Support spells}.'})

npcHandler:setMessage(MESSAGE_WALKAWAY, 'Be careful on your journeys.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Don\'t hurt yourself with that weapon, little one.')

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
