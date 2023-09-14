local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = { {text = 'Gather around me, young knights! I\'m going to teach you some spells!'} }
--npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	local addonProgress = getPlayerStorageValue(cid, Storage.OutfitQuest.Knight.AddonHelmet)
	if msgcontains(msg, 'task') then
		if not player:isPremium() then
			selfSay('Sorry, but our tasks are only for premium warriors.', cid)
			return true
		end

		if addonProgress < 1 then
			selfSay('You mean you would like to prove that you deserve to wear such a helmet?', cid)
			talkState[talkUser] = 1
		elseif addonProgress == 1 then
			selfSay('Your current task is to bring me 100 perfect behemoth fangs, |PLAYERNAME|.', cid)
		elseif addonProgress == 2 then
			selfSay('Your current task is to retrieve the helmet of Ramsay the Reckless from Banuta, |PLAYERNAME|.', cid)
		elseif addonProgress == 3 then
			selfSay('Your current task is to obtain a flask of warrior\'s sweat, |PLAYERNAME|.', cid)
		elseif addonProgress == 4 then
			selfSay('Your current task is to bring me royal steel, |PLAYERNAME|.', cid)
		elseif addonProgress == 5 then
			selfSay('Please talk to Sam and tell him I sent you. I\'m sure he will be glad to refine your helmet, |PLAYERNAME|.', cid)
		else
			selfSay('You\'ve already completed the task and can consider yourself a mighty warrior, |PLAYERNAME|.', cid)
		end

	elseif msgcontains(msg, 'behemoth fang') then
		if addonProgress == 1 then
			selfSay('Have you really managed to fulfil the task and brought me 100 perfect behemoth fangs?', cid)
			talkState[talkUser] = 3
		else
			selfSay('You\'re not serious asking that, are you? They come from behemoths, of course. Unless there are behemoth rabbits. Duh.', cid)
		end

	elseif msgcontains(msg, 'ramsay') then
		if addonProgress == 2 then
			selfSay('Did you recover the helmet of Ramsay the Reckless?', cid)
			talkState[talkUser] = 4
		else
			selfSay('These pesky apes steal everything they can get their dirty hands on.', cid)
		end

	elseif msgcontains(msg, 'sweat') then
		if addonProgress == 3 then
			selfSay('Were you able to get hold of a flask with pure warrior\'s sweat?', cid)
			talkState[talkUser] = 5
		else
			selfSay('Warrior\'s sweat can be magically extracted from headgear worn by a true warrior, but only in small amounts. Djinns are said to be good at magical extractions.', cid)
		end

	elseif msgcontains(msg, 'royal steel') then
		if addonProgress == 4 then
			selfSay('Ah, have you brought the royal steel?', cid)
			talkState[talkUser] = 6
		else
			selfSay('Royal steel can only be refined by very skilled smiths.', cid)
		end

	elseif talkState[talkUser] == 1 then
		if msgcontains(msg, 'yes') then
			selfSay({
				'Well then, listen closely. First, you will have to prove that you are a fierce and restless warrior by bringing me 100 perfect behemoth fangs. ...',
				'Secondly, please retrieve a helmet for us which has been lost a long time ago. The famous Ramsay the Reckless wore it when exploring an ape settlement. ...',
				'Third, we need a new flask of warrior\'s sweat. We\'ve run out of it recently, but we need a small amount for the show battles in our arena. ...',
				'Lastly, I will have our smith refine your helmet if you bring me royal steel, an especially noble metal. ...',
				'Did you understand everything I told you and are willing to handle this task?'
			}, cid)
			talkState[talkUser] = 2
		elseif msgcontains(msg, 'no') then
			selfSay('Bah. Then you will have to wait for the day these helmets are sold in shops, but that will not happen before hell freezes over.', cid)
			talkState[talkUser] = 0
		end

	elseif talkState[talkUser] == 2 then
		if msgcontains(msg, 'yes') then
			setPlayerStorageValue(cid, Storage.OutfitQuest.Ref, math.max(0, getPlayerStorageValue(cid, Storage.OutfitQuest.Ref)) + 1)
			setPlayerStorageValue(cid, Storage.OutfitQuest.Knight.AddonHelmet, 1)
			setPlayerStorageValue(cid, Storage.OutfitQuest.Knight.MissionHelmet, 1)
			selfSay('Alright then. Come back to me once you have collected 100 perfect behemoth fangs.', cid)
			talkState[talkUser] = 0
		elseif msgcontains(msg, 'no') then
			selfSay('Would you like me to repeat the task requirements then?', cid)
			talkState[talkUser] = 1
		end

	elseif talkState[talkUser] == 3 then
		if msgcontains(msg, 'yes') then
			if not doPlayerRemoveItem(cid, 5893, 100) then
				selfSay('Lying is not exactly honourable, |PLAYERNAME|. Shame on you.', cid)
				return true
			end

			setPlayerStorageValue(cid, Storage.OutfitQuest.Knight.AddonHelmet, 2)
			setPlayerStorageValue(cid, Storage.OutfitQuest.Knight.MissionHelmet, 2)
			setPlayerStorageValue(cid, Storage.OutfitQuest.Knight.RamsaysHelmetDoor, 1)
			selfSay('I\'m deeply impressed, brave Knight |PLAYERNAME|. I expected nothing less from you. Now, please retrieve Ramsay\'s helmet.', cid)
		elseif msgcontains(msg, 'no') then
			selfSay('There is no need to rush anyway.', cid)
		end
		talkState[talkUser] = 0

	elseif talkState[talkUser] == 4 then
		if msgcontains(msg, 'yes') then
			if not doPlayerRemoveItem(cid, 5924, 1) then
				selfSay('Lying is not exactly honourable, |PLAYERNAME|. Shame on you.', cid)
				return true
			end

			setPlayerStorageValue(cid, Storage.OutfitQuest.Knight.AddonHelmet, 3)
			setPlayerStorageValue(cid, Storage.OutfitQuest.Knight.MissionHelmet, 3)
			selfSay('Good work, brave Knight |PLAYERNAME|! Even though it is damaged, it has a lot of sentimental value. Now, please bring me warrior\'s sweat.', cid)
		elseif msgcontains(msg, 'no') then
			selfSay('There is no need to rush anyway.', cid)
		end
		talkState[talkUser] = 0

	elseif talkState[talkUser] == 5 then
		if msgcontains(msg, 'yes') then
			if not doPlayerRemoveItem(cid, 5885, 1) then
				selfSay('Lying is not exactly honourable, |PLAYERNAME|. Shame on you.', cid)
				return true
			end

			setPlayerStorageValue(cid, Storage.OutfitQuest.Knight.AddonHelmet, 4)
			setPlayerStorageValue(cid, Storage.OutfitQuest.Knight.MissionHelmet, 4)
			selfSay('Now that is a pleasant surprise, brave Knight |PLAYERNAME|! There is only one task left now: Obtain royal steel to have your helmet refined.', cid)
		elseif msgcontains(msg, 'no') then
			selfSay('There is no need to rush anyway.', cid)
		end
		talkState[talkUser] = 0

	elseif talkState[talkUser] == 6 then
		if msgcontains(msg, 'yes') then
			if not doPlayerRemoveItem(cid, 5887, 1) then
				selfSay('Lying is not exactly honourable, |PLAYERNAME|. Shame on you.', cid)
				return true
			end

			setPlayerStorageValue(cid, Storage.OutfitQuest.Knight.AddonHelmet, 5)
			setPlayerStorageValue(cid, Storage.OutfitQuest.Knight.MissionHelmet, 5)
			selfSay('You truly deserve to wear an adorned helmet, brave Knight |PLAYERNAME|. Please talk to Sam and tell him I sent you. I\'m sure he will be glad to refine your helmet.', cid)
		elseif msgcontains(msg, 'no') then
			selfSay('There is no need to rush anyway.', cid)
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

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I am the first knight. I trained some of the greatest heroes of Tibia."})
keywordHandler:addKeyword({'heroes'}, StdModule.say, {npcHandler = npcHandler, text = "Of course, you heard of them. Knights are the best fighters in Tibia."})
keywordHandler:addKeyword({'king'}, StdModule.say, {npcHandler = npcHandler, text = "Hail to our King!"})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "You are joking, eh? Of course, you know me. I am Gregor, the first knight."})
keywordHandler:addKeyword({'gregor'}, StdModule.say, {npcHandler = npcHandler, text = "A great name, isn't it?"})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = "Beautiful Tibia. And with our help everyone is save."})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = "It is time to join the Knights!"})
keywordHandler:addKeyword({'knights'}, StdModule.say, {npcHandler = npcHandler, text = "Knights are the warriors of Tibia. Without us, no one would be safe. Every brave and strong man or woman can join us."})
keywordHandler:addKeyword({'bozo'}, StdModule.say, {npcHandler = npcHandler, text = "Some day someone will make something happen to him..."})
keywordHandler:addKeyword({'elane'}, StdModule.say, {npcHandler = npcHandler, text = "A bow might be a fine weapon for someone not strong enough to wield a REAL weapon."})
keywordHandler:addKeyword({'frodo'}, StdModule.say, {npcHandler = npcHandler, text = "I and my students often share a cask of beer or wine at Frodo's hut."})
keywordHandler:addKeyword({'gorn'}, StdModule.say, {npcHandler = npcHandler, text = "Always concerned with his profit. What a loss! He was adventuring with baxter in the old days."})
keywordHandler:addKeyword({'baxter'}, StdModule.say, {npcHandler = npcHandler, text = "He was an adventurer once."})
keywordHandler:addKeyword({'lynda'}, StdModule.say, {npcHandler = npcHandler, text = "Before she became a priest she won the Miss Tibia contest three times in a row."})
keywordHandler:addKeyword({'mcronald'}, StdModule.say, {npcHandler = npcHandler, text = "Peaceful farmers."})
keywordHandler:addKeyword({'ferumbras'}, StdModule.say, {npcHandler = npcHandler, text = "A fine game to hunt. But be careful, he cheats!"})
keywordHandler:addKeyword({'muriel'}, StdModule.say, {npcHandler = npcHandler, text = "Bah, go away with these sorcerer tricks. Only cowards use tricks."})
keywordHandler:addKeyword({'oswald'}, StdModule.say, {npcHandler = npcHandler, text = "What an idiot."})
keywordHandler:addKeyword({'quentin'}, StdModule.say, {npcHandler = npcHandler, text = "I will never understand this peaceful monks and priests."})
keywordHandler:addKeyword({'sam'}, StdModule.say, {npcHandler = npcHandler, text = "He has the muscles, but lacks the guts."})
keywordHandler:addKeyword({'tibianus'}, StdModule.say, {npcHandler = npcHandler, text = "Hail to our King!"})
keywordHandler:addKeyword({'outfit'}, StdModule.say, {npcHandler = npcHandler, text = "Only the bravest warriors may wear adorned helmets. They are traditionally awarded after having completed a difficult task for our guild."})
keywordHandler:addKeyword({'helmet'}, StdModule.say, {npcHandler = npcHandler, text = "Only the bravest warriors may wear adorned helmets. They are traditionally awarded after having completed a difficult task for our guild."})

npcHandler:setMessage(MESSAGE_GREET, "Greetings, |PLAYERNAME|. What do you want?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Be careful on your journeys.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Be careful on your journeys.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
