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
	
	if msgcontains(msg, "addon") or msgcontains(msg, "outfit") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.HunterHatAddon) < 1 then
			selfSay("Oh, my winged tiara? Those are traditionally awarded after having completed a difficult {task} for our guild, only to female aspirants though. Male warriors will receive a hooded cloak.", cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, "task") then
		if talkState[talkUser] == 1 then
			selfSay("So you are saying that you would like to prove that you deserve to wear such a hooded cloak?", cid)
			talkState[talkUser] = 2
		end
	elseif msgcontains(msg, "crossbow") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.HunterHatAddon) == 1 then
			selfSay("I'm so excited! Have you really found my crossbow?", cid)
			talkState[talkUser] = 4
		end
	elseif msgcontains(msg, "leather") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.HunterHatAddon) == 2 then
			selfSay("Did you bring me 100 pieces of lizard leather and 100 pieces of red dragon leather?", cid)
			talkState[talkUser] = 5
		end
	elseif msgcontains(msg, "chicken wing") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.HunterHatAddon) == 3 then
			selfSay("Were you able to get hold of 5 enchanted chicken wings?", cid)
			talkState[talkUser] = 6
		end
	elseif msgcontains(msg, "steel") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.HunterHatAddon) == 4 then
			selfSay("Ah, have you brought one piece of royal steel, draconian steel and hell steel each?", cid)
			talkState[talkUser] = 7
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 2 then
			selfSay({
				"Alright, I will give you a chance. Pay close attention to what I'm going to tell you now. ...",
				"Recently, one of our members moved to Liberty Bay out of nowhere, talking about some strange cult. That is not the problem, but he took my favourite crossbow with him. ...",
				"Please find my crossbow. It has my name engraved on it and is very special to me. ...",
				"Secondly, we need a lot of leather for new quivers. 100 pieces of lizard leather and 100 pieces of red dragon leather should suffice. ...",
				"Third, since we are giving out tiaras, we are always in need of enchanted chicken wings. Please bring me 5, that would help us tremendously. ...",
				"Lastly, for our arrow heads we need a lot of steel. Best would be one piece of royal steel, one piece of draconian steel and one piece of hell steel. ...",
				"Did you understand everything I told you and are willing to handle this task?"
			}, cid)
			talkState[talkUser] = 3
		elseif talkState[talkUser] == 3 then
			selfSay("That's the spirit! I hope you will find my crossbow, |PLAYERNAME|!", cid)
			setPlayerStorageValue(cid, Storage.OutfitQuest.HunterHatAddon, 1)
			setPlayerStorageValue(cid, Storage.OutfitQuest.DefaultStart, 1) --this for default start of Outfit and Addon Quests
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 4 then
			if doPlayerRemoveItem(cid, 5947, 1) then
				selfSay("Yeah! I could kiss you right here and there! Besides, you're a handsome one. <giggles> Please bring me 100 pieces of lizard leather and 100 pieces of red dragon leather now!", cid)
				setPlayerStorageValue(cid, Storage.OutfitQuest.HunterHatAddon, 2)
				talkState[talkUser] = 0
			else
				selfSay("You don't have it...", cid)
			end
		elseif talkState[talkUser] == 5 then
			if getPlayerItemCount(cid, 5876) >= 100 and getPlayerItemCount(cid, 5948) >= 100  then
				selfSay("Good work, |PLAYERNAME|! That is enough leather for a lot of sturdy quivers. Now, please bring me 5 enchanted chicken wings.", cid)
				doPlayerRemoveItem(cid, 5876, 100)
				doPlayerRemoveItem(cid, 5948, 100)
				setPlayerStorageValue(cid, Storage.OutfitQuest.HunterHatAddon, 3)
				talkState[talkUser] = 0
			else
				selfSay("You don't have it...", cid)
			end
		elseif talkState[talkUser] == 6 then
			if doPlayerRemoveItem(cid, 5891, 5) then
				selfSay("Great! Now we can create a few more Tiaras. If only they weren't that expensive... Well anyway, please obtain one piece of royal steel, draconian steel and hell steel each.", cid)
				setPlayerStorageValue(cid, Storage.OutfitQuest.HunterHatAddon, 4)
				talkState[talkUser] = 0
			else
				selfSay("You don't have it...", cid)
			end
		elseif talkState[talkUser] == 7 then
			if getPlayerItemCount(cid, 5887) >= 1 and getPlayerItemCount(cid, 5888) >= 1 and getPlayerItemCount(cid, 5889) >= 1  then
				selfSay("Wow, I'm impressed, |PLAYERNAME|. Your really are a valuable member of our paladin guild. I shall grant you your reward now. Wear it proudly!", cid)
				doPlayerRemoveItem(cid, 5887, 1)
				doPlayerRemoveItem(cid, 5888, 1)
				doPlayerRemoveItem(cid, 5889, 1)
				setPlayerStorageValue(cid, Storage.OutfitQuest.HunterHatAddon, 5)
				doPlayerAddOutfit(cid, 129, 1)
				doPlayerAddOutfit(cid, 137, 2)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				talkState[talkUser] = 0
			else
				selfSay("You don't have it...", cid)
			end
		end
	elseif msgcontains(msg, "no") then
		if talkState[talkUser] > 1 then
			selfSay("Then no.", cid)
			talkState[talkUser] = 0
		end
	return true
	end
end

-- Sniper Gloves
keywordHandler:addKeyword({'sniper gloves'}, StdModule.say, {npcHandler = npcHandler, text = 'We are always looking for sniper gloves. They are supposed to raise accuracy. If you find a pair, bring them here. Maybe I can offer you a nice trade.'}, function(player) return getPlayerItemCount(cid, 5875) == 0 end)

local function addGloveKeyword(text, condition, action)
	local gloveKeyword = keywordHandler:addKeyword({'sniper gloves'}, StdModule.say, {npcHandler = npcHandler, text = text[1]}, condition)
		gloveKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = text[2], reset = true}, function(player) return getPlayerItemCount(cid, 5875) == 0 end)
		gloveKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = text[3], reset = true}, nil, action)
		gloveKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = text[2], reset = true})
end

-- Free Account
addGloveKeyword({
		'You found sniper gloves?! Incredible! I would love to grant you the sniper gloves accessory, but I can only do that for premium warriors. However, I would pay you 2000 gold pieces for them. How about it?',
		'Maybe another time.',
		'Alright! Here is your money, thank you very much.'
	}, function(player) return not player:isPremium() end, function(player) doPlayerRemoveItem(cid, 5875, 1) player:addMoney(2000) end
)

-- Premium account with addon
addGloveKeyword({
		'Did you find sniper gloves AGAIN?! Incredible! I cannot grant you other accessories, but would you like to sell them to me for 2000 gold pieces?',
		'Maybe another time.',
		'Alright! Here is your money, thank you very much.'
	}, function(player) return getPlayerStorageValue(cid, Storage.OutfitQuest.Hunter.AddonGlove) == 1 end, function(player) doPlayerRemoveItem(cid, 5875, 1) player:addMoney(2000) end
)

-- If you don't have the addon
addGloveKeyword({
		'You found sniper gloves?! Incredible! Listen, if you give them to me, I will grant you the right to wear the sniper gloves accessory. How about it?',
		'No problem, maybe another time.',
		'Great! I hereby grant you the right to wear the sniper gloves as an accessory. Congratulations!'
	}, function(player) return getPlayerStorageValue(cid, Storage.OutfitQuest.Hunter.AddonGlove) == -1 end, function(player) doPlayerRemoveItem(cid, 5875, 1) setPlayerStorageValue(cid, Storage.OutfitQuest.Hunter.AddonGlove, 1) doPlayerAddOutfit(cid, 129, 2) doPlayerAddOutfit(cid, 137, 1) player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE) end
)

-- Basic
keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = "I am the leader of the Paladins. I help our members."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I am the leader of the Paladins. I help our members."})
keywordHandler:addKeyword({'paladins'}, StdModule.say, {npcHandler = npcHandler, text = "Paladins are great warriors and magicians. Besides that we are excellent missile fighters. Many people in Tibia want to join us."})
keywordHandler:addKeyword({'warriors'}, StdModule.say, {npcHandler = npcHandler, text = "Of course, we aren't as strong as knights, but no druid or sorcerer will ever defeat a paladin with a sword."})
keywordHandler:addKeyword({'magicians'}, StdModule.say, {npcHandler = npcHandler, text = "There are many magic spells and runes paladins can use."})
keywordHandler:addKeyword({'missile'}, StdModule.say, {npcHandler = npcHandler, text = "Paladins are the best missile fighters in Tibia!"})
keywordHandler:addKeyword({'news'}, StdModule.say, {npcHandler = npcHandler, text = "I am a paladin, not a storyteller."})
keywordHandler:addKeyword({'members'}, StdModule.say, {npcHandler = npcHandler, text = "Every paladin profits from his vocation. It has many advantages to be a paladin."})
keywordHandler:addKeyword({'advantages'}, StdModule.say, {npcHandler = npcHandler, text = "We will help you to improve your skills. Besides I offer spells for paladins."})
keywordHandler:addKeyword({'general'}, StdModule.say, {npcHandler = npcHandler, text = "Harkath Bloodblade is the royal general."})
keywordHandler:addKeyword({'army'}, StdModule.say, {npcHandler = npcHandler, text = "Some paladins serve in the kings army."})
keywordHandler:addKeyword({'baxter'}, StdModule.say, {npcHandler = npcHandler, text = "He has some potential."})
keywordHandler:addKeyword({'bozo'}, StdModule.say, {npcHandler = npcHandler, text = "How spineless do you have to be to become a jester?"})
keywordHandler:addKeyword({'mcronald'}, StdModule.say, {npcHandler = npcHandler, text = "The McRonalds are simple farmers."})
keywordHandler:addKeyword({'eclesius'}, StdModule.say, {npcHandler = npcHandler, text = "He must have been skilled before he became the way he is now. Such a pity."})
keywordHandler:addKeyword({'elane'}, StdModule.say, {npcHandler = npcHandler, text = "Yes?"})
keywordHandler:addKeyword({'frodo'}, StdModule.say, {npcHandler = npcHandler, text = "The alcohol he sells shrouds the mind and the eye."})
keywordHandler:addKeyword({'galuna'}, StdModule.say, {npcHandler = npcHandler, text = "One of the most important members of our guild. She makes all the bows and arrows we need."})
keywordHandler:addKeyword({'gorn'}, StdModule.say, {npcHandler = npcHandler, text = "He sells a lot of useful equipment."})
keywordHandler:addKeyword({'gregor'}, StdModule.say, {npcHandler = npcHandler, text = "He and his guildfellows lack the grace of a true warrior."})
keywordHandler:addKeyword({'harkath bloodblade'}, StdModule.say, {npcHandler = npcHandler, text = "A fine warrior and a skilled general."})
keywordHandler:addKeyword({'king tibianus'}, StdModule.say, {npcHandler = npcHandler, text = "King Tibianus is a wise ruler."})
keywordHandler:addKeyword({'lugri'}, StdModule.say, {npcHandler = npcHandler, text = "A follower of evil that will get what he deserves one day."})
keywordHandler:addKeyword({'lynda'}, StdModule.say, {npcHandler = npcHandler, text = "Mhm, a little too nice for my taste. Still, it's amazing how she endures all those men stalking her, especially this creepy Oswald."})
keywordHandler:addKeyword({'marvik'}, StdModule.say, {npcHandler = npcHandler, text = "A skilled healer, that's for sure."})
keywordHandler:addKeyword({'muriel'}, StdModule.say, {npcHandler = npcHandler, text = "Just another arrogant sorcerer."})
keywordHandler:addKeyword({'oswald'}, StdModule.say, {npcHandler = npcHandler, text = "If there wouldn't be higher powers to protect him..."})
keywordHandler:addKeyword({'quentin'}, StdModule.say, {npcHandler = npcHandler, text = "A humble monk and a wise man."})
keywordHandler:addKeyword({'sam'}, StdModule.say, {npcHandler = npcHandler, text = "Strong man. But a little shy."})

npcHandler:setMessage(MESSAGE_GREET, "Welcome to the paladins' guild, |PLAYERNAME|! How can I help you?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Bye, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Bye, |PLAYERNAME|.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())


	keywordHandler:addSpellKeyword({'conjure','arrow'}, {npcHandler = npcHandler, spellName = 'Conjure Arrow', price = 450, level = 13, vocation ={3}})
	keywordHandler:addSpellKeyword({'conjure','bolt'}, {npcHandler = npcHandler, spellName = 'Conjure Bolt', price = 750, level = 17, vocation ={3}})
	keywordHandler:addSpellKeyword({'conjure','explosive','arrow'}, {npcHandler = npcHandler, spellName = 'Conjure Explosive Arrow', price = 1000, level = 25, vocation ={3}})
	keywordHandler:addSpellKeyword({'conjure','piercing','bolt'}, {npcHandler = npcHandler, spellName = 'Conjure Piercing Bolt', price = 850, level = 33, vocation ={3}})
	keywordHandler:addSpellKeyword({'conjure','poisoned','arrow'}, {npcHandler = npcHandler, spellName = 'Conjure Poisoned Arrow', price = 700, level = 16, vocation ={3}})
	keywordHandler:addSpellKeyword({'conjure','sniper','arrow'}, {npcHandler = npcHandler, spellName = 'Conjure Sniper Arrow', price = 800, level = 24, vocation ={3}})
	keywordHandler:addSpellKeyword({'cure','poison'}, {npcHandler = npcHandler, spellName = 'Cure Poison', price = 150, level = 10, vocation ={3}})
	keywordHandler:addSpellKeyword({'destroy','field'}, {npcHandler = npcHandler, spellName = 'Destroy Field', price = 700, level = 17, vocation ={3}})
	keywordHandler:addSpellKeyword({'divine','healing'}, {npcHandler = npcHandler, spellName = 'Divine Healing', price = 3000, level = 35, vocation ={3}})
	keywordHandler:addSpellKeyword({'find','person'}, {npcHandler = npcHandler, spellName = 'Find Person', price = 80, level = 8, vocation ={3}})
	keywordHandler:addSpellKeyword({'great','light'}, {npcHandler = npcHandler, spellName = 'Great Light', price = 500, level = 13, vocation ={3}})
	keywordHandler:addSpellKeyword({'intense','healing'}, {npcHandler = npcHandler, spellName = 'Intense Healing', price = 350, level = 20, vocation ={3}})
	keywordHandler:addSpellKeyword({'light'}, {npcHandler = npcHandler, spellName = 'Light', price = 0, level = 8, vocation ={3}})
	keywordHandler:addSpellKeyword({'light','healing'}, {npcHandler = npcHandler, spellName = 'Light Healing', price = 0, level = 8, vocation ={3}})
	keywordHandler:addKeyword({'healing', 'spells'}, StdModule.say, {npcHandler = npcHandler, text = "In this category I have '{Cure Poison}', '{Divine Healing}', '{Intense Healing}' and '{Light Healing}'."})
	keywordHandler:addKeyword({'support', 'spells'}, StdModule.say, {npcHandler = npcHandler, text = "In this category I have '{Conjure Arrow}', '{Conjure Bolt}', '{Conjure Explosive Arrow}', '{Conjure Piercing Bolt}', '{Conjure Poisoned Arrow}', '{Conjure Sniper Arrow}', '{Destroy Field}', '{Find Person}', '{Great Light}' and '{Light}'."})
	keywordHandler:addKeyword({'spells'}, StdModule.say, {npcHandler = npcHandler, text = 'I can teach you {Healing spells} and {Support spells}.'})
	
	