 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local config = {
	['brown piece'] = {
		itemId = 5913,
		count = 20,
		value = 1,
		messages = {
			done = 'Ghouls sometimes carry it with them. My assistant Irmana can also fabricate cloth from secondhand clothing.',
			deliever = 'Ah! Have you brought 20 pieces of brown cloth?',
			notEnough = 'Uh, that is not even enough cloth for a poor dwarf\'s look.',
			success = 'Yes, yes, that\'s it! Very well, now I need 50 pieces of minotaur leather to continue.'
		}
	},
	['minotaur leather'] = {
		itemId = 5878,
		count = 50,
		value = 2,
		messages = {
			done = 'If you don\'t know how to obtain minotaur leather, ask my apprentice Kalvin. I\'m far too busy for these trivial matters.',
			deliever = 'Were you able to obtain 50 pieces of minotaur leather?',
			notEnough = 'Uh, that is not even enough leather for a poor dwarf\'s look.',
			success = 'Great! This leather will suffice. Now, please, the 10 bat wings.'
		}
	},
	['bat wing'] = {
		itemId = 5894,
		count = 10,
		value = 3,
		messages = {
			done = 'Well, what do you expect? Bat wings come from bats, of course.',
			deliever = 'Did you get me the 10 bat wings?',
			notEnough = 'No, no. I need more bat wings! I said, 10!',
			success = 'Hooray! These bat wings are ugly enough. Now the last thing: Please bring me 30 heaven blossoms to neutralise the ghoulish stench.'
		}
	},
	['heaven blossom'] = {
		itemId = 5921,
		count = 30,
		value = 4,
		messages = {
			done = 'A flower favoured by almost all elves.',
			deliever = 'Is this the lovely smell of 30 heaven blossoms?',
			notEnough = 'These few flowers are not enough to neutralise the ghoulish stench.',
			success = 'This is it! I will immediately start to work on this outfit. Come back in a day or something... then my new creation will be born!'
		},
		lastItem = true
	}
}

local message = {}

local function greetCallback(cid)
	message[cid] = nil
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	if msgcontains(msg, "uniforms") then
		if getPlayerStorageValue(cid, Storage.postman.Mission06) == 1 then
			selfSay("A new uniform for the post officers? I am sorry but my dog ate the last dress pattern we used. You need to supply us with a new dress pattern.", cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, "dress pattern") then
		if talkState[talkUser] == 1 then
			selfSay("It was ... wonderous beyond wildest imaginations! I have no clue where Kevin Postner got it from. Better ask him.", cid)
			setPlayerStorageValue(cid, Storage.postman.Mission06, 2)
		elseif getPlayerStorageValue(cid, Storage.postman.Mission06) == 11 then
			selfSay("By the gods of fashion! Didn't it do that I fed the last dress pattern to my poor dog? Will this mocking of all which is taste and fashion never stop?? Ok, ok, you will get those ugly, stinking uniforms and now get lost, fashion terrorist.", cid)
			setPlayerStorageValue(cid, Storage.postman.Mission06, 12)
		end
		talkState[talkUser] = 0
	elseif msgcontains(msg, 'outfit') then
		if not player:isPremium() then
			selfSay('Sorry, but my time is currently reserved for premium matters.', cid)
			return true
		end

		if getPlayerStorageValue(cid, Storage.OutfitQuest.BeggarOutfit) < 1 then
			selfSay({
				'I think I\'m having an innovative vision! I feel that people are getting tired of attempting to look wealthy and of displaying their treasures. ...',
				'A really new and innovative look would be - the \'poor man\'s look\'! I can already see it in front of me... yes... a little ragged... but not too shabby! ...',
				'I need material right now! Argh - the vision starts to fade... please hurry, can you bring me some stuff?'
			}, cid)
			talkState[talkUser] = 2
		elseif getPlayerStorageValue(cid, Storage.OutfitQuest.BeggarOutfit) > 0 and getPlayerStorageValue(cid, Storage.OutfitQuest.BeggarOutfit) < 5 then
			selfSay('I am so excited! This poor man\'s look will be an outfit like the world has never seen before.', cid)
		elseif getPlayerStorageValue(cid, Storage.OutfitQuest.BeggarOutfit) == 5 then
			if getPlayerStorageValue(cid, Storage.OutfitQuest.BeggarOutfitTimer) > os.time() then
				selfSay('Sorry, but I am not done with the outfit yet. Venore wasn\'t built in a day.', cid)
			elseif getPlayerStorageValue(cid, Storage.OutfitQuest.BeggarOutfitTimer) > 0 and getPlayerStorageValue(cid, Storage.OutfitQuest.BeggarOutfitTimer) < os.time() then
				selfSay('Eureka! Alas, the poor man\'s outfit is finished, but... to be honest... it turned out much less appealing than I expected. However, you can have it if you want, okay?', cid)
				talkState[talkUser] = 5
			end
		elseif getPlayerStorageValue(cid, Storage.OutfitQuest.BeggarOutfit) == 6 then
			selfSay('I guess my vision wasn\'t that grand after all. I hope there are still people who enjoy it.', cid)
		end
	elseif config[msg:lower()] then
		local targetMessage = config[msg:lower()]
		if getPlayerStorageValue(cid, Storage.OutfitQuest.BeggarOutfit) ~= targetMessage.value then
			selfSay(targetMessage.messages.done, cid)
			return true
		end

		selfSay(targetMessage.messages.deliever, cid)
		talkState[talkUser] = 4
		message[cid] = targetMessage
	elseif msgcontains(msg, 'yes') then
		if talkState[talkUser] == 2 then
			selfSay({
				'Good! Listen, I need the following material - first, 20 pieces of brown cloth, like the worn and ragged ghoul clothing. ...',
				'Secondly, 50 pieces of minotaur leather. Third, I need bat wings, maybe 10. And 30 heaven blossoms, the flowers elves cultivate. ...',
				'Have you noted down everything and will help me gather the material?'
			}, cid)
			talkState[talkUser] = 3
		elseif talkState[talkUser] == 3 then
			if getPlayerStorageValue(cid, Storage.OutfitQuest.DefaultStart) ~= 1 then
				setPlayerStorageValue(cid, Storage.OutfitQuest.DefaultStart, 1)
			end
			setPlayerStorageValue(cid, Storage.OutfitQuest.BeggarOutfit, 1)
			selfSay('Terrific! What are you waiting for?! Start right away gathering 20 pieces of brown cloth and come back once you have them!', cid)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 4 then
			local targetMessage = message[cid]
			if not doPlayerRemoveItem(cid, targetMessage.itemId, targetMessage.count) then
				selfSay(targetMessage.messages.notEnough, cid)
				return true
			end

			setPlayerStorageValue(cid, Storage.OutfitQuest.BeggarOutfit, getPlayerStorageValue(cid, Storage.OutfitQuest.BeggarOutfit) + 1)
			if targetMessage.lastItem then
				setPlayerStorageValue(cid, Storage.OutfitQuest.BeggarOutfitTimer, os.time() + 86400)
			end
			selfSay(targetMessage.messages.success, cid)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 5 then
			player:addOutfit(153)
			player:addOutfit(157)
			setPlayerStorageValue(cid, Storage.OutfitQuest.BeggarOutfit, 6)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			selfSay('Here you go. Maybe you enjoy if after all.', cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, 'no') then
		if talkState[talkUser] == 2 then
			selfSay('Argh! I guess this awesome idea has to remain unimplemented. What a pity.', cid)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 3 then
			selfSay('Do you want me to repeat the task requirements?', cid)
			talkState[talkUser] = 2
		elseif talkState[talkUser] == 4 then
			selfSay('Hurry! I am at my creative peak right now!', cid)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 5 then
			selfSay('Well, if you should change your mind, just ask me for the beggar outfit.', cid)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
