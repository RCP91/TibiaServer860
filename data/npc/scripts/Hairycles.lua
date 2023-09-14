local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local function greetCallback(cid)
	if Player(cid):getStorageValue(Storage.TheApeCity.Questline) < 12 then
		npcHandler:setMessage(MESSAGE_GREET, 'Oh! Hello! Hello! Did not notice! So {busy}.')
	else
		npcHandler:setMessage(MESSAGE_GREET, 'Be greeted, friend of the ape people. If you want to {trade}, just ask for my offers. If you are injured, ask for healing.')
	end
	return true
end

local function releasePlayer(cid)
	if not Player(cid) then
		return
	end

	npcHandler:releaseFocus(cid)
	npcHandler:resetNpc(cid)
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	local questProgress = getPlayerStorageValue(cid, Storage.TheApeCity.Questline)
	if msgcontains(msg, 'mission') then
		if questProgress < 1 then
			selfSay('These are dire times for our people. Problems plenty are in this times. But me people not grant trust easy. Are you willing to prove you friend of ape people?', cid)
			talkState[talkUser] = 1

		elseif questProgress == 1 then
			if getPlayerStorageValue(cid, Storage.QuestChests.WhisperMoss) == 1 then
				selfSay('Oh, you brought me whisper moss? Good hairless ape you are! Can me take it?', cid)
				talkState[talkUser] = 3
			else
				selfSay('Please hurry. Bring me whisper moss from dworc lair. Make sure it is from dworc lair! Take it yourself only! If you need to hear background of all again, ask Hairycles for {background}.', cid)
			end

		elseif questProgress == 2 then
			selfSay({
				'Whisper moss strong is, but me need liquid that humans have to make it work ...',
				'Our raiders brought it from human settlement, it\'s called cough syrup. Go ask healer there for it.'
			}, cid)
			setPlayerStorageValue(cid, Storage.TheApeCity.Questline, 3)

		elseif questProgress == 3 then
			selfSay('You brought me that cough syrup from human healer me asked for?', cid)
			talkState[talkUser] = 4

		elseif questProgress == 4 then
			selfSay('Little ape should be healthy soon. Me so happy is. Thank you again! But me suspect we in more trouble than we thought. Will you help us again?', cid)
			talkState[talkUser] = 5

		elseif questProgress == 5 then
			selfSay('You got scroll from lizard village in south east?', cid)
			talkState[talkUser] = 7

		elseif questProgress == 6 then
			selfSay({
				'Ah yes that scroll. Sadly me not could read it yet. But the holy banana me insight gave! In dreams Hairycles saw where to find solution. ...',
				'Me saw a stone with lizard signs and other signs at once. If you read signs and tell Hairycles, me will know how to read signs. ...',
				'You go east to big desert. In desert there city. East of city under sand hidden tomb is. You will have to dig until you find it, so take shovel. ...',
				'Go down in tomb until come to big level and then go down another. There you find a stone with signs between two huge red stones. ...',
				'Read it and return to me. Are you up to that challenge?'
			}, cid)
			talkState[talkUser] = 8

		elseif questProgress == 7 then
			if getPlayerStorageValue(cid, Storage.TheApeCity.ParchmentDecyphering) == 1 then
				selfSay('Ah yes, you read the signs in tomb? Good! May me look into your mind to see what you saw?', cid)
				talkState[talkUser] = 9
			else
				selfSay('You still don\'t know signs on stone, go and look for it in tomb east in desert.', cid)
			end

		elseif questProgress == 8 then
			selfSay({
				'So much there is to do for Hairycles to prepare charm that will protect all ape people. ...',
				'You can help more. To create charm of life me need mighty token of life! Best is egg of a regenerating beast as a hydra is. ...',
				'Bring me egg of hydra please. You may find it in lair of Hydra at little lake south east of our lovely city Banuta! You think you can do?'
			}, cid)
			talkState[talkUser] = 10

		elseif questProgress == 9 then
			selfSay('You bring Hairycles egg of hydra?', cid)
			talkState[talkUser] = 11

		elseif questProgress == 10 then
			selfSay({
				'Last ingredient for charm of life is thing to lure magic. Only thing me know like that is mushroom called witches\' cap. Me was told it be found in isle called Fibula, where humans live. ...',
				'Hidden under Fibula is a secret dungeon. There you will find witches\' cap. Are you willing to go there for good ape people?'
			}, cid)
			talkState[talkUser] = 12

		elseif questProgress == 11 then
			selfSay('You brought Hairycles witches\' cap from Fibula?', cid)
			talkState[talkUser] = 13

		elseif questProgress == 12 then
			selfSay({
				'Mighty life charm is protecting us now! But my people are still in danger. Danger from within. ...',
				'Some of my people try to mimic lizards to become strong. Like lizards did before, this cult drinks strange fluid that lizards left when fled. ...',
				'Under the city still the underground temple of lizards is. There you find casks with red fluid. Take crowbar and destroy three of them to stop this madness. Are you willing to do that?'
			}, cid)
			talkState[talkUser] = 14

		elseif questProgress == 13 then
			if getPlayerStorageValue(cid, Storage.TheApeCity.Casks) == 3 then
				selfSay('You do please Hairycles again, friend. Me hope madness will not spread further now. Perhaps you are ready for other mission.', cid)
				setPlayerStorageValue(cid, Storage.TheApeCity.Questline, 14)
			else
				selfSay('Please destroy three casks in the complex beneath Banuta, so my people will come to senses again.', cid)
			end

		elseif questProgress == 14 then
			selfSay({
				'Now that the false cult was stopped, we need to strengthen the spirit of my people. We need a symbol of our faith that ape people can see and touch. ...',
				'Since you have proven a friend of the ape people I will grant you permission to enter the forbidden land. ...',
				'To enter the forbidden land in the north-east of the jungle, look for a cave in the mountains east of it. There you will find the blind prophet. ...',
				'Tell him Hairycles you sent and he will grant you entrance. ...',
				'Forbidden land is home of Bong. Holy giant ape big as mountain. Don\'t annoy him in any way but look for a hair of holy ape. ...',
				'You might find at places he has been, should be easy to see them since Bong is big. ...',
				'Return a hair of the holy ape to me. Will you do this for Hairycles?'
			}, cid)
			talkState[talkUser] = 15

		elseif questProgress == 15 then
			if getPlayerStorageValue(cid, Storage.TheApeCity.HolyApeHair) == 1 then
				selfSay('You brought hair of holy ape?', cid)
				talkState[talkUser] = 16
			else
				selfSay('Get a hair of holy ape from forbidden land in east. Speak with blind prophet in cave.', cid)
			end

		elseif questProgress == 16 then
			selfSay({
				'You have proven yourself a friend, me will grant you permission to enter the deepest catacombs under Banuta which we have sealed in the past. ...',
				'Me still can sense the evil presence there. We did not dare to go deeper and fight creatures of evil there. ...',
				'You may go there, fight the evil and find the monument of the serpent god and destroy it with hammer me give to you. ...',
				'Only then my people will be safe. Please tell Hairycles, will you go there?'
			}, cid)
			talkState[talkUser] = 17

		elseif questProgress == 17 then
			if getPlayerStorageValue(cid, Storage.TheApeCity.SnakeDestroyer) == 1 then
				selfSay({
					'Finally my people are safe! You have done incredible good for ape people and one day even me brethren will recognise that. ...',
					'I wish I could speak for all when me call you true friend but my people need time to get accustomed to change. ...',
					'Let us hope one day whole Banuta will greet you as a friend. Perhaps you want to check me offers for special friends... or shamanic powers.'
				}, cid)
				setPlayerStorageValue(cid, Storage.TheApeCity.Questline, 18)
				--player:addAchievement('Friend of the Apes')
			else
				selfSay('Me know its much me asked for but go into the deepest catacombs under Banuta and destroy the monument of the serpent god.', cid)
			end

		else
			selfSay('No more missions await you right now, friend. Perhaps you want to check me offers for special friends... or shamanic powers.', cid)
		end

	elseif msgcontains(msg, 'background') then
		if questProgress == 1
				and getPlayerStorageValue(cid, Storage.QuestChests.WhisperMoss) ~= 1 then
			selfSay({
				'So listen, little ape was struck by plague. Hairycles not does know what plague it is. That is strange. Hairycles should know. But Hairycles learnt lots and lots ...',
				'Me sure to make cure so strong to drive away all plague. But to create great cure me need powerful components ...',
				'Me need whisper moss. Whisper moss growing south of human settlement is. Problem is, evil little dworcs harvest all whisper moss immediately ...',
				'Me know they hoard some in their underground lair. My people raided dworcs often before humans came. So we know the moss is hidden in east of upper level of dworc lair ...',
				'You go there and take good moss from evil dworcs. Talk with me about mission when having moss.'
			}, cid)
		end

	elseif msgcontains(msg, 'outfit') or msgcontains(msg, 'shamanic') then
		if questProgress == 18 then
			if getPlayerStorageValue(cid, Storage.TheApeCity.ShamanOutfit) ~= 1 then
				selfSay('Me truly proud of you, friend. You learn many about plants, charms and ape people. Me want grant you shamanic power now. You ready?', cid)
				talkState[talkUser] = 18
			else
				selfSay('You already are shaman and doctor. Me proud of you.', cid)
			end
		else
			selfSay('You not have finished journey for wisdom yet, young human.', cid)
		end

	elseif msgcontains(msg, 'heal') then
		if questProgress > 11 then
			if player:getHealth() < 50 then
				player:addHealth(50 - player:getHealth())
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			elseif player:getCondition(CONDITION_FIRE) then
				player:removeCondition(CONDITION_FIRE)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
			elseif player:getCondition(CONDITION_POISON) then
				player:removeCondition(CONDITION_POISON)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
			else
				selfSay('You look for food and rest.', cid)
			end
		else
			selfSay('You look for food and rest.', cid)
		end

	elseif talkState[talkUser] == 1 then
		if msgcontains(msg, 'yes') then
			selfSay('To become friend of ape people a long and difficult way is. We do not trust easy but help is needed. Will you listen to story of Hairycles?', cid)
			talkState[talkUser] = 2
		elseif msgcontains(msg, 'no') then
			selfSay('Hairycles sad is now. But perhaps you will change mind one day.', cid)
			talkState[talkUser] = 0
		end

	elseif talkState[talkUser] == 2 then
		if msgcontains(msg, 'yes') then
			selfSay({
				'So listen, little ape was struck by plague. Hairycles not does know what plague it is. That is strange. Hairycles should know. But Hairycles learnt lots and lots ...',
				'Me sure to make cure so strong to drive away all plague. But to create great cure me need powerful components ...',
				'Me need whisper moss. Whisper moss growing south of human settlement is. Problem is, evil little dworcs harvest all whisper moss immediately ...',
				'Me know they hoard some in their underground lair. My people raided dworcs often before humans came. So we know the moss is hidden in east of upper level of dworc lair ...',
				'You go there and take good moss from evil dworcs. Talk with me about mission when having moss.'
			}, cid)
			setPlayerStorageValue(cid, Storage.TheApeCity.Started, 1)
			setPlayerStorageValue(cid, Storage.TheApeCity.Questline, 1)
			setPlayerStorageValue(cid, Storage.TheApeCity.DworcDoor, 1)
		elseif msgcontains(msg, 'no') then
			selfSay('Hairycles thought better of you.', cid)
			addEvent(releasePlayer, 1000, cid)
		end
		talkState[talkUser] = 0

	elseif talkState[talkUser] == 3 then
		if msgcontains(msg, 'yes') then
			if not doPlayerRemoveItem(cid, 4838, 1) then
				selfSay('Stupid, you no have the moss me need. Go get it. It\'s somewhere in dworc lair. If you lost it, they might restocked it meanwhile. If you need to hear background of all again, ask Hairycles for {background}.', cid)
				setPlayerStorageValue(cid, Storage.QuestChests.WhisperMoss, -1)
				return true
			end

			selfSay('Ah yes! That\'s it. Thank you for bringing mighty whisper moss to Hairycles. It will help but still much is to be done. Just ask for other mission if you ready.', cid)
			setPlayerStorageValue(cid, Storage.TheApeCity.Questline, 2)
		elseif msgcontains(msg, 'no') then
			selfSay('Strange being you are! Our people need help!', cid)
		end
		talkState[talkUser] = 0

	elseif talkState[talkUser] == 4 then
		if msgcontains(msg, 'yes') then
			if not doPlayerRemoveItem(cid, 4839, 1) then
				selfSay('No no, not right syrup you have. Go get other, get right health syrup.', cid)
				return true
			end

			selfSay('You so good! Brought syrup to me! Thank you, will prepare cure now. Just ask for {mission} if you want help again.', cid)
			setPlayerStorageValue(cid, Storage.TheApeCity.Questline, 4)
		elseif msgcontains(msg, 'no') then
			selfSay('Please hurry, urgent it is!', cid)
		end
		talkState[talkUser] = 0

	elseif talkState[talkUser] == 5 then
		if msgcontains(msg, 'yes') then
			selfSay({
				'So listen, please. Plague was not ordinary plague. That\'s why Hairycles could not heal at first. It is new curse of evil lizard people ...',
				'I think curse on little one was only a try. We have to be prepared for big strike ...',
				'Me need papers of lizard magician! For sure you find it in his hut in their dwelling. It\'s south east of jungle. Go look there please! Are you willing to go?'
			}, cid)
			talkState[talkUser] = 6
		elseif msgcontains(msg, 'no') then
			selfSay('Me sad. Me expected better from you!', cid)
			addEvent(releasePlayer, 1000, cid)
			talkState[talkUser] = 0
		end

	elseif talkState[talkUser] == 6 then
		if msgcontains(msg, 'yes') then
			selfSay('Good thing that is! Report about your mission when have scroll.', cid)
			setPlayerStorageValue(cid, Storage.TheApeCity.Questline, 5)
			setPlayerStorageValue(cid, Storage.TheApeCity.ChorDoor, 1)
		elseif msgcontains(msg, 'no') then
			selfSay('Me sad. Me expected better from you!', cid)
			addEvent(releasePlayer, 1000, cid)
		end
		talkState[talkUser] = 0

	elseif talkState[talkUser] == 7 then
		if msgcontains(msg, 'yes') then
			if not doPlayerRemoveItem(cid, 5956, 1) then
				if getPlayerStorageValue(cid, Storage.QuestChests.OldParchment) == 1 then
					selfSay('That\'s bad news. If you lost it, only way to get other is to kill holy serpents. But you can\'t go there so you must ask adventurers who can.', cid)
				else
					selfSay('No! That not scroll me looking for. Silly hairless ape you are. Go to village of lizards and get it there on your own!', cid)
				end
				return true
			end

			selfSay('You brought scroll with lizard text? Good! I will see what text tells me! Come back when ready for other mission.', cid)
			setPlayerStorageValue(cid, Storage.TheApeCity.Questline, 6)
		elseif msgcontains(msg, 'no') then
			selfSay('That\'s bad news. If you lost it, only way to get other is to kill holy serpents. But you can\'t go there so you must ask adventurers who can.', cid)
		end
		talkState[talkUser] = 0

	elseif talkState[talkUser] == 8 then
		if msgcontains(msg, 'yes') then
			selfSay('Good thing that is! Report about mission when you have read those signs.', cid)
			setPlayerStorageValue(cid, Storage.TheApeCity.Questline, 7)
		elseif msgcontains(msg, 'no') then
			selfSay('Me sad. Me expected better from you!', cid)
			addEvent(releasePlayer, 1000, cid)
		end
		talkState[talkUser] = 0

	elseif talkState[talkUser] == 9 then
		if msgcontains(msg, 'yes') then
			selfSay('Oh, so clear is all now! Easy it will be to read the signs now! Soon we will know what to do! Thank you again! Ask for mission if you feel ready.', cid)
			setPlayerStorageValue(cid, Storage.TheApeCity.Questline, 8)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		elseif msgcontains(msg, 'no') then
			selfSay('Me need to see it in your mind, other there is no way to proceed.', cid)
		end
		talkState[talkUser] = 0

	elseif talkState[talkUser] == 10 then
		if msgcontains(msg, 'yes') then
			selfSay('You brave hairless ape! Get me hydra egg. If you lose egg, you probably have to fight many, many hydras to get another.', cid)
			setPlayerStorageValue(cid, Storage.TheApeCity.Questline, 9)
		elseif msgcontains(msg, 'no') then
			selfSay('Me sad. Me expected better from you!', cid)
			addEvent(releasePlayer, 1000, cid)
		end
		talkState[talkUser] = 0

	elseif talkState[talkUser] == 11 then
		if msgcontains(msg, 'yes') then
			if not doPlayerRemoveItem(cid, 4850, 1) then
				selfSay('You not have egg of hydra. Please get one!', cid)
				return true
			end

			selfSay('Ah, the egg! Mighty warrior you be! Thank you. Hairycles will put it at safe place immediately.', cid)
			setPlayerStorageValue(cid, Storage.TheApeCity.Questline, 10)
		elseif msgcontains(msg, 'no') then
			selfSay('Please hurry. Hairycles not knows when evil lizards strike again.', cid)
		end
		talkState[talkUser] = 0

	elseif talkState[talkUser] == 12 then
		if msgcontains(msg, 'yes') then
			selfSay('Long journey it will take, good luck to you.', cid)
			setPlayerStorageValue(cid, Storage.TheApeCity.Questline, 11)
			setPlayerStorageValue(cid, Storage.TheApeCity.FibulaDoor, 1)
		elseif msgcontains(msg, 'no') then
			selfSay('Me sad. Me expected better from you!', cid)
			addEvent(releasePlayer, 1000, cid)
		end
		talkState[talkUser] = 0

	elseif talkState[talkUser] == 13 then
		if msgcontains(msg, 'yes') then
			if not doPlayerRemoveItem(cid, 4840, 1) then
				selfSay('Not right mushroom you have. Find me a witches\' cap on Fibula!', cid)
				return true
			end

			selfSay('Incredible, you brought a witches\' cap! Now me can prepare mighty charm of life. Yet still other {missions} will await you, friend.', cid)
			setPlayerStorageValue(cid, Storage.TheApeCity.Questline, 12)
			setPlayerStorageValue(cid, Storage.TheApeCity.FibulaDoor, -1)
		elseif msgcontains(msg, 'no') then
			selfSay('Please try to find me a witches\' cap on Fibula.', cid)
			addEvent(releasePlayer, 1000, cid)
		end
		talkState[talkUser] = 0

	elseif talkState[talkUser] == 14 then
		if msgcontains(msg, 'yes') then
			selfSay('Hairycles sure you will make it. Good luck, friend.', cid)
			setPlayerStorageValue(cid, Storage.TheApeCity.Questline, 13)
			setPlayerStorageValue(cid, Storage.TheApeCity.CasksDoor, 1)
		elseif msgcontains(msg, 'no') then
			selfSay('Me sad. Please reconsider.', cid)
		end
		talkState[talkUser] = 0

	elseif talkState[talkUser] == 15 then
		if msgcontains(msg, 'yes') then
			selfSay('Hairycles proud of you. Go and find holy hair. Good luck, friend.', cid)
			setPlayerStorageValue(cid, Storage.TheApeCity.Questline, 15)
		elseif msgcontains(msg, 'no') then
			selfSay('Me sad. Please reconsider.', cid)
		end
		talkState[talkUser] = 0

	elseif talkState[talkUser] == 16 then
		if msgcontains(msg, 'yes') then
			if not doPlayerRemoveItem(cid, 4843, 1) then
				selfSay('You no have hair. You lost it? Go and look again.', cid)
				setPlayerStorageValue(cid, Storage.TheApeCity.HolyApeHair, -1)
				return true
			end

			selfSay('Incredible! You got a hair of holy Bong! This will raise the spirit of my people. You are truly a friend. But one last mission awaits you.', cid)
			setPlayerStorageValue(cid, Storage.TheApeCity.Questline, 16)
		elseif msgcontains(msg, 'no') then
			selfSay('You no have hair. You lost it? Go and look again.', cid)
		end
		talkState[talkUser] = 0

	elseif talkState[talkUser] == 17 then
		if msgcontains(msg, 'yes') then
			selfSay('Hairycles sure you will make it. Just use hammer on all that looks like snake or lizard. Tell Hairycles if you succeed with mission.', cid)
			setPlayerStorageValue(cid, Storage.TheApeCity.Questline, 17)
			doPlayerAddItem(cid, 4846, 1)
		elseif msgcontains(msg, 'no') then
			selfSay('Me sad. Please reconsider.', cid)
		end
		talkState[talkUser] = 0

	elseif talkState[talkUser] == 18 then
		if msgcontains(msg, 'yes') then
			selfSay('Friend of the ape people! Take my gift and become me apprentice! Here is shaman clothing for you!', cid)
			player:addOutfit(154)
			player:addOutfit(158)
			setPlayerStorageValue(cid, Storage.TheApeCity.ShamanOutfit, 1)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		elseif msgcontains(msg, 'no') then
			selfSay('Come back if change mind.', cid)
		end
		talkState[talkUser] = 0
	
	elseif msgcontains(msg, 'cookie') then
		if getPlayerStorageValue(cid, Storage.WhatAFoolishQuest.Questline) == 31 and getPlayerStorageValue(cid, Storage.WhatAFoolishQuest.CookieDelivery.Hairycles) ~= 1 then
			selfSay('You bring me a stinking cookie???', cid)
			talkState[talkUser] = 19
		end
		
	elseif talkState[talkUser] == 19 then
		if msgcontains(msg, 'yes') then
			if not doPlayerRemoveItem(cid, 8111, 1) then
				selfSay('You have no cookie that I\'d like.', cid)
				return true
			end

			setPlayerStorageValue(cid, Storage.WhatAFoolishQuest.CookieDelivery.Hairycles, 1)
			if player:getCookiesDelivered() == 10 then
				--player:addAchievement('Allow Cookies?')
			end

			Npc():getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
			selfSay('Thank you, you are ... YOU SON OF LIZARD!', cid)
			addEvent(releasePlayer, 1000, cid)
		elseif msgcontains(msg, 'no') then
			selfSay('I see.', cid)
		end
		talkState[talkUser] = 0
	end
	return true
end

keywordHandler:addKeyword({'busy'}, StdModule.say, {npcHandler = npcHandler, text = 'Me great {wizard}. Me great doctor of {ape people}. Me know many plants. Me old and me have seen many things.'})
keywordHandler:addKeyword({'wizard'}, StdModule.say, {npcHandler = npcHandler, text = 'We see many things and learning quick. Merlkin magic learn quick, quick. We just watch and learn. Sometimes we try and learn.'})
keywordHandler:addKeyword({'things'}, StdModule.say, {npcHandler = npcHandler, text = 'Things not good now. Need helper to do {mission} for me people.'})
keywordHandler:addKeyword({'ape people'}, StdModule.say, {npcHandler = npcHandler, text = 'We be {kongra}, {sibang} and {merlkin}. Strange hairless ape people live in city called Port Hope.'})
keywordHandler:addKeyword({'kongra'}, StdModule.say, {npcHandler = npcHandler, text = 'Kongra verry strong. Kongra verry angry verry fast. Take care when kongra comes. Better climb on highest tree.'})
keywordHandler:addKeyword({'sibang'}, StdModule.say, {npcHandler = npcHandler, text = 'Sibang verry fast and funny. Sibang good gather food. Sibang know {jungle} well.'})
keywordHandler:addKeyword({'merlkin'}, StdModule.say, {npcHandler = npcHandler, text = 'Merlkin we are. Merlkin verry wise, merlkin learn many things quick. Teach other apes things a lot. Making {heal} and making {magic}.'})
keywordHandler:addKeyword({'magic'}, StdModule.say, {npcHandler = npcHandler, text = 'We see many things and learning quick. Merlkin magic learn quick, quick. We just watch and learn. Sometimes we try and learn.'})
keywordHandler:addKeyword({'jungle'}, StdModule.say, {npcHandler = npcHandler, text = 'Jungle is dangerous. Jungle also provides us food. Take care when in jungle and safe you be.'})

local function onTradeRequest(cid)
	if Player(cid):getStorageValue(Storage.TheApeCity.Questline) < 18 then
		return false
	end

	return true
end

npcHandler:setCallback(CALLBACK_ONTRADEREQUEST, onTradeRequest)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
