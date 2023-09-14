local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local function greetCallback(cid)
	
	if getPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon) == 6 then
		npcHandler:setMessage(MESSAGE_GREET, "Oh no! Was that really me? This is so embarassing, I have no idea what has gotten into me. Was that the fighting spirit you gave me?")
	end
	return true
end

keywordHandler:addKeyword({'gelagos'}, StdModule.say, {npcHandler = npcHandler, text = "This... person... makes me want to... say something bad... must... control myself. <sweats>"})

local function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end
	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

	
	if isInArray({"recruitment", "violence", "outfit", "addon"}, msg) then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon) < 1 then
			selfSay({
				"Convincing Ajax that it is not always necessary to use brute force... this would be such an achievement. Definitely a hard task though. ...",
				"Listen, I simply have to ask, maybe a stranger can influence him better than I can. Would you help me with my brother?"
			}, cid)
			talkState[talkUser] = 1
		end
	elseif(msgcontains(msg, "fist")) then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon) == 3 then
			selfSay("Oh! He really said that? I am so proud of you, |PLAYERNAME|. These are really good news. Everything would be great... if only there wasn't this {person} near my house.", cid)
			talkState[talkUser] = 3
		end
	elseif(msgcontains(msg, "person")) then
		if(talkState[talkUser] == 3) then
			selfSay({
				"This... person... makes me want to... say something bad... must... control myself. <sweats> I really don't know what to do anymore. ...",
				"I wonder if Ajax has an idea. Could you ask him about Gelagos?"
			}, cid)
			talkState[talkUser] = 4
		end
	elseif(msgcontains(msg, "fighting spirit")) then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon) == 5 then
			if doPlayerRemoveItem(cid, 5884, 1) then
				setPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon, 6)
				selfSay("Fighting spirit? What am I supposed to do with this fi... - oh! I feel strange... ME MIGHTY! ME WILL CHASE OFF ANNOYING KIDS!GROOOAARR!! RRRRRRRRRRRRAAAAAAAGE!!", cid)
				talkState[talkUser] = 0
			end
		end
	elseif(msgcontains(msg, "cloth")) then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon) == 7 then
			selfSay("Have you really managed to fulfil the task and brought me 50 pieces of red cloth and 50 pieces of green cloth?", cid)
			talkState[talkUser] = 8
		end
	elseif(msgcontains(msg, "silk")) then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon) == 8 then
			selfSay("Oh, did you bring 10 rolls of spider silk yarn for me?", cid)
			talkState[talkUser] = 9
		end
	elseif(msgcontains(msg, "sweat")) then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon) == 9 then
			selfSay("Were you able to get hold of a flask with pure warrior's sweat?", cid)
			talkState[talkUser] = 10
		end
	elseif(msgcontains(msg, "yes")) then
		if(talkState[talkUser] == 1) then
			selfSay({
				"Really! That is such an incredibly nice offer! I already have a plan. You have to teach him that sometimes words are stronger than fists. ...",
				"Maybe you can provoke him with something to get angry, like saying... 'MINE!' or something. But beware, I'm sure that he will try to hit you. ...",
				"Don't do this if you feel weak or ill. He will probably want to make you leave by using violence, but just stay strong and refuse to give up. ...",
				"If he should ask what else is necessary to make you leave, tell him to 'say please'. Afterwards, do leave and return to him one hour later. ...",
				"This way he might learn that violence doesn't always help, but that a friendly word might just do the trick. ...",
				"Have you understood everything I told you and are really willing to take this risk?"
			}, cid)
			talkState[talkUser] = 2
		elseif(talkState[talkUser] == 2) then
			selfSay("You are indeed not only well educated, but also very courageous. I wish you good luck, you are my last hope.", cid)
			setPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon, 1)
			setPlayerStorageValue(cid, Storage.OutfitQuest.DefaultStart, 1) --this for default start of Outfit and Addon Quests
			talkState[talkUser] = 0
		elseif(talkState[talkUser] == 4) then
			selfSay("Again, I have to thank you for your selfless offer to help me. I hope that Ajax can come up with something, now that he has experienced the power of words.", cid)
			setPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon, 4)
			talkState[talkUser] = 0
		elseif(getPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon) == 6 and talkState[talkUser] == 0) then
			selfSay({
				"I'm impressed... I am sure this was Ajax' idea. I would love to give him a present, but if I leave my hut to gather ingredients, hewill surely notice. ...",
				"Would you maybe help me again, one last time, my friend? I assure you that your efforts will not be in vain."
			}, cid)
			talkState[talkUser] = 6
		elseif(talkState[talkUser] == 6) then
			selfSay({
				"Great! You see, I really would love to sew a nice shirt for him. I just need a few things for that, so please listen closely: ...",
				"He loves green and red, so I will need about 50 pieces of red cloth - like the material heroes make their capes of - and 50 pieces of the green cloth Djinns like. ...",
				"Secondly, I need about 10 rolls of spider silk yarn. I think mermaids can yarn silk of large spiders to create a smooth thread. ...",
				"The only remaining thing needed would be a bottle of warrior's sweat to spray it over the shirt... he just loves this smell. ...",
				"Have you understood everything I told you and are willing to handle this task?"
			}, cid)
			talkState[talkUser] = 7
		elseif(talkState[talkUser] == 7) then
			selfSay("Thank you, my friend! Come back to me once you have collected 50 pieces of red cloth and 50 pieces of green cloth.", cid)
			setPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon, 7)
			talkState[talkUser] = 0
		elseif(talkState[talkUser] == 8) then
			if getPlayerItemCount(cid, 5910) >= 50 and getPlayerItemCount(cid, 5911) >= 50 then
				selfSay("Terrific! I will start to trim it while you gather 10 rolls of spider silk. I'm sure that Ajax will love it.", cid)
				doPlayerRemoveItem(cid, 5910, 50)
				doPlayerRemoveItem(cid, 5911, 50)
				setPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon, 8)
				talkState[talkUser] = 0
			end
		elseif(talkState[talkUser] == 9) then
			if doPlayerRemoveItem(cid, 5886, 10) then
				selfSay("I'm impressed! You really managed to get spider silk yarn for me! I will immediately start to work on this shirt. Please don't forget to bring me warrior's sweat!", cid)
				setPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon, 9)
				talkState[talkUser] = 0
			end
		elseif(talkState[talkUser] == 10) then
			if doPlayerRemoveItem(cid, 5885, 1) then
				selfSay("Good work, |PLAYERNAME|! Now I can finally finish this present for Ajax. Because you were such a great help, I have also a present for you. Will you accept it?", cid)
				setPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon, 10)
				talkState[talkUser] = 0
			end
		elseif getPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon) == 10 then
			selfSay("I have kept this traditional barbarian wig safe for many years now. It is now yours! I hope you will wear it proudly, friend.", cid)
			setPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon, 11)
			doPlayerAddOutfit(cid, 147, 2)
			doPlayerAddOutfit(cid, 143, 2)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_FAREWELL, "Take care, |PLAYERNAME|!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Take care!")
npcHandler:addModule(FocusModule:new())
