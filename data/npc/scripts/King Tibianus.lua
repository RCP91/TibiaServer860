local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)	npcHandler:onCreatureSay(cid, type, msg)	end
function onThink()						npcHandler:onThink()						end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	if msgcontains(msg, "farmine") then
		if getPlayerStorageValue(cid, Storage.TheNewFrontier.Questline) == 15 then
			selfSay("King Tibianus: Ah, I vaguely remember that our little allies were eager to build some base. So speak up, what do you want?", cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, "Flatter") then
		if talkState[talkUser] == 1 then
			if getPlayerStorageValue(cid, Storage.TheNewFrontier.BribeKing) < 1 then
				selfSay("The idea of a promising market and new resources suits us quite well. I think it is reasonable to send some assistance.", cid)
				setPlayerStorageValue(cid, Storage.TheNewFrontier.BribeKing, 1)
				setPlayerStorageValue(cid, Storage.TheNewFrontier.Mission05, getPlayerStorageValue(cid, Storage.TheNewFrontier.Mission05) + 1) --Questlog, The New Frontier Quest "Mission 05: Getting Things Busy"
			end
		end
	end
	
	if getPlayerStorageValue(cid, Storage.OutfitQuest.GoldenBaseOutfit) < 1 then
		if (msg == "outfit") or (msg == "addon") then
			selfSay("In exchange for a truly generous donation, I will offer a special outfit. Do you want to make a donation?", cid)
			talkState[talkUser] = 1
		end
	elseif getPlayerStorageValue(cid, Storage.OutfitQuest.GoldenFirstAddon) < 1 or getPlayerStorageValue(cid, Storage.OutfitQuest.GoldenSecondAddon) < 1 and getPlayerStorageValue(cid, Storage.OutfitQuest.GoldenBaseOutfit) == 1 then
		if (msg == "outfit") or (msg == "addon") then
			selfSay("In exchange for a truly generous donation, I will offer a special outfit. Do you want to make a donation?", cid)
			talkState[talkUser] = 3
		end
	end
	if(msgcontains(msg, "yes")) and talkState[talkUser] == 1 then
		selfSay({
		"Excellent! Now, let me explain. If you donate 1.000.000 gold pieces, you will be entitled to wear a unique outfit. ...",
		"You will be entitled to wear the {armor} for 500.000 gold pieces, {boots} for an additional 250.000 and the {helmet} for another 250.000 gold pieces. ...",
		"What will it be?"
		}, cid)
		talkState[talkUser] = 2
	elseif (msgcontains(msg, "yes")) and talkState[talkUser] == 3 then
		selfSay({
		"Excellent! Now, let me explain. If you donate 1.000.000 gold pieces, you will be entitled to wear a unique outfit. ...",
		"You will be entitled to wear the {armor} for 500.000 gold pieces, {boots} for an additional 250.000 and the {helmet} for another 250.000 gold pieces. ...",
		"What will it be?"
		}, cid)
		talkState[talkUser] = 4
	end
		-- armor (golden outfit)
		if getPlayerStorageValue(cid, Storage.OutfitQuest.GoldenBaseOutfit) < 1 and talkState[talkUser] == 5 and (msgcontains(msg, "yes")) then
			if getPlayerBalance(cid) + getPlayerBalance(cid) >= 500000 then
				selfSay("Take this armor as a token of great gratitude. Let us forever remember this day, my friend!", cid)
				doPlayerRemoveMoney(cid, 500000)
				player:addOutfit(1211)
				player:addOutfit(1210)
				setPlayerStorageValue(cid, Storage.OutfitQuest.GoldenBaseOutfit, 1)
				talkState[talkUser] = 0
				else
				selfSay("You do not have enough money to donate that amount.", cid)
			end
		-- boots addon
		elseif (msgcontains(msg, "yes")) and talkState[talkUser] == 6 and getPlayerStorageValue(cid, Storage.OutfitQuest.GoldenFirstAddon) < 1 then
			if getPlayerBalance(cid) + getPlayerBalance(cid) >= 250000 and getPlayerStorageValue(cid, Storage.OutfitQuest.GoldenBaseOutfit) == 1 then
				selfSay("Take this boots as a token of great gratitude. Let us forever remember this day, my friend. ", cid)
				talkState[talkUser] = 0
				doPlayerAddOutfit(cid, 1210, 2)
				doPlayerAddOutfit(cid, 1211, 2)
				doPlayerRemoveMoney(cid, 250000)
				setPlayerStorageValue(cid, Storage.OutfitQuest.GoldenFirstAddon, 1)
				else
				selfSay("You do not have enough money to donate that amount.", cid)
			end
		-- helmet addon
		elseif talkState[talkUser] == 7 and (msgcontains(msg, "yes")) then
			if getPlayerBalance(cid) + getPlayerBalance(cid) >= 250000 and getPlayerStorageValue(cid, Storage.OutfitQuest.GoldenBaseOutfit) == 1  and getPlayerStorageValue(cid, Storage.OutfitQuest.GoldenSecondAddon) < 1 then
				selfSay("Take this helmet as a token of great gratitude. Let us forever remember this day, my friend. ", cid)
				talkState[talkUser] = 0
				doPlayerRemoveMoney(cid, 250000)
				doPlayerAddOutfit(cid, 1210, 1)
				doPlayerAddOutfit(cid, 1211, 1)
				setPlayerStorageValue(cid, Storage.OutfitQuest.GoldenSecondAddon, 1)
			else
				selfSay("Do not have money helmet", cid)
			end
		end
	if msgcontains(msg, "armor") and talkState[talkUser] == 2 and getPlayerStorageValue(cid, Storage.OutfitQuest.GoldenBaseOutfit) < 1 then
		selfSay("So you wold like to donate 500.000 gold pieces which in return will entitle you to wear a unique armor?", cid)
		talkState[talkUser] = 5
	elseif(msgcontains(msg, "boots")) and (talkState[talkUser] == 4 and getPlayerStorageValue(cid, Storage.OutfitQuest.GoldenBaseOutfit) == 1 and getPlayerStorageValue(cid, Storage.OutfitQuest.GoldenFirstAddon) < 1) then
		selfSay("So you would like to donate 250.000 gold pieces which in return will entitle you to wear unique boots?", cid)
		talkState[talkUser] = 6
	elseif(msgcontains(msg, "helmet")) and (talkState[talkUser] == 4 and getPlayerStorageValue(cid, Storage.OutfitQuest.GoldenBaseOutfit) == 1 and getPlayerStorageValue(cid, Storage.OutfitQuest.GoldenSecondAddon) < 1) then
		selfSay("So you would like to donate 250.000 gold pieces which in return will entitle you to wear a unique helmet?", cid)
		talkState[talkUser] = 7
	end
	return true
end

-- Promotion
local node1 = keywordHandler:addKeyword({'promot'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'I can promote you for 20000 gold coins. Do you want me to promote you?'})
	node1:addChildKeyword({'yes'}, StdModule.promotePlayer, {npcHandler = npcHandler, cost = 20000, level = 20, text = 'Congratulations! You are now promoted.'})
	node1:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Alright then, come back when you are ready.', reset = true})

-- Basic
keywordHandler:addKeyword({'eremo'}, StdModule.say, {npcHandler = npcHandler, text = 'It is said that he lives on a small island near Edron. Maybe the people there know more about him.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I am your sovereign, King Tibianus III, and it\'s my duty to uphold {justice} and provide guidance for my subjects.'})
keywordHandler:addKeyword({'justice'}, StdModule.say, {npcHandler = npcHandler, text = 'I try my best to be just and fair to our citizens. The army and the {TBI} are a great help in fulfilling this duty.'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'Preposterous! You must know the name of your own King!'})
keywordHandler:addKeyword({'news'}, StdModule.say, {npcHandler = npcHandler, text = 'The latest news is usually brought to our magnificent town by brave adventurers. They recount tales of their journeys at Frodo\'s tavern.'})
keywordHandler:addKeyword({'how', 'are', 'you'}, StdModule.say, {npcHandler = npcHandler, text = 'Thank you, I\'m fine.'})
keywordHandler:addKeyword({'castle'}, StdModule.say, {npcHandler = npcHandler, text = 'Rain Castle is my home.'})
keywordHandler:addKeyword({'sell'}, StdModule.say, {npcHandler = npcHandler, text = 'Sell? Sell what? My kingdom isn\'t for sale!'})
keywordHandler:addKeyword({'god'}, StdModule.say, {npcHandler = npcHandler, text = 'Honour the Gods and above all pay your {taxes}.'})
keywordHandler:addKeyword({'zathroth'}, StdModule.say, {npcHandler = npcHandler, text = 'Please ask a priest about the gods.'})
keywordHandler:addKeyword({'citizen'}, StdModule.say, {npcHandler = npcHandler, text = 'The citizens of Tibia are my subjects. Ask the old monk Quentin if you want to learn more about them.'})
keywordHandler:addKeyword({'sam'}, StdModule.say, {npcHandler = npcHandler, text = 'He is a skilled blacksmith and a loyal subject.'})
keywordHandler:addKeyword({'frodo'}, StdModule.say, {npcHandler = npcHandler, text = 'He is the owner of Frodo\'s Hut and a faithful tax-payer.'})
keywordHandler:addKeyword({'gorn'}, StdModule.say, {npcHandler = npcHandler, text = 'He was once one of Tibia\'s greatest fighters. Now he sells equipment.'})
keywordHandler:addKeyword({'benjamin'}, StdModule.say, {npcHandler = npcHandler, text = 'He was once my greatest general. Now he is very old and senile so we assigned him to work for the Royal Tibia Mail.'})
keywordHandler:addKeyword({'noodles'}, StdModule.say, {npcHandler = npcHandler, text = 'The royal poodle Noodles is my greatest {treasure}!'})
keywordHandler:addKeyword({'ferumbras'}, StdModule.say, {npcHandler = npcHandler, text = 'He is a follower of the evil God Zathroth and responsible for many attacks on us. Kill him on sight!'})
keywordHandler:addKeyword({'bozo'}, StdModule.say, {npcHandler = npcHandler, text = 'He is my royal jester and cheers me up now and then.'})
keywordHandler:addKeyword({'treasure'}, StdModule.say, {npcHandler = npcHandler, text = 'The royal poodle Noodles is my greatest treasure!'})
keywordHandler:addKeyword({'monster'}, StdModule.say, {npcHandler = npcHandler, text = 'Go and hunt them! For king and country!'})
keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = 'Visit Quentin the monk for help.'})
keywordHandler:addKeyword({'sewer'}, StdModule.say, {npcHandler = npcHandler, text = 'What a disgusting topic!'})
keywordHandler:addKeyword({'dungeon'}, StdModule.say, {npcHandler = npcHandler, text = 'Dungeons are no places for kings.'})
keywordHandler:addKeyword({'equipment'}, StdModule.say, {npcHandler = npcHandler, text = 'Feel free to buy it in our town\'s fine shops.'})
keywordHandler:addKeyword({'food'}, StdModule.say, {npcHandler = npcHandler, text = 'Ask the royal cook for some food.'})
keywordHandler:addKeyword({'tax collector'}, StdModule.say, {npcHandler = npcHandler, text = 'That tax collector is the bane of my life. He is so lazy. I bet you haven\'t payed any taxes at all.'})
keywordHandler:addKeyword({'king'}, StdModule.say, {npcHandler = npcHandler, text = 'I am the king, so watch what you say!'})
keywordHandler:addKeyword({'army'}, StdModule.say, {npcHandler = npcHandler, text = 'Ask the soldiers about that.'})
keywordHandler:addKeyword({'shop'}, StdModule.say, {npcHandler = npcHandler, text = 'Visit the shops of our merchants and craftsmen.'})
keywordHandler:addKeyword({'guild'}, StdModule.say, {npcHandler = npcHandler, text = 'The four major guilds are the knights, the paladins, the druids, and the sorcerers.'})
keywordHandler:addKeyword({'minotaur'}, StdModule.say, {npcHandler = npcHandler, text = 'Vile monsters, but I must admit they are strong and sometimes even cunning ... in their own bestial way.'})
keywordHandler:addKeyword({'good'}, StdModule.say, {npcHandler = npcHandler, text = 'The forces of good are hard pressed in these dark times.'})
keywordHandler:addKeyword({'evil'}, StdModule.say, {npcHandler = npcHandler, text = 'We need all strength we can muster to smite evil!'})
keywordHandler:addKeyword({'order'}, StdModule.say, {npcHandler = npcHandler, text = 'We need order to survive!'})
keywordHandler:addKeyword({'chaos'}, StdModule.say, {npcHandler = npcHandler, text = 'Chaos arises from selfishness.'})
keywordHandler:addKeyword({'excalibug'}, StdModule.say, {npcHandler = npcHandler, text = 'It\'s the sword of the Kings. If you return this weapon to me I will {reward} you beyond your wildest dreams.'})
keywordHandler:addKeyword({'reward'}, StdModule.say, {npcHandler = npcHandler, text = 'Well, if you want a reward, go on a quest to bring me Excalibug!'})
keywordHandler:addKeyword({'chester'}, StdModule.say, {npcHandler = npcHandler, text = 'A very competent person. A little nervous but very competent.'})
keywordHandler:addKeyword({'tbi'}, StdModule.say, {npcHandler = npcHandler, text = 'This organisation is an essential tool for holding our enemies in check. Its headquarter is located in the bastion in the northwall.'})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = 'Soon the whole land will be ruled by me once again!'})
keywordHandler:addAliasKeyword({'land'})
keywordHandler:addKeyword({'harkath'}, StdModule.say, {npcHandler = npcHandler, text = 'Harkath Bloodblade is the general of our glorious {army}.'})
keywordHandler:addAliasKeyword({'bloodblade'})
keywordHandler:addAliasKeyword({'general'})
keywordHandler:addKeyword({'quest'}, StdModule.say, {npcHandler = npcHandler, text = 'I will call for heroes as soon as the need arises again and then reward them appropriately.'})
keywordHandler:addAliasKeyword({'mission'})
keywordHandler:addKeyword({'gold'}, StdModule.say, {npcHandler = npcHandler, text = 'To pay your taxes, visit the royal tax collector.'})
keywordHandler:addAliasKeyword({'money'})
keywordHandler:addAliasKeyword({'tax'})
keywordHandler:addAliasKeyword({'collector'})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = 'It\'s a time for heroes!'})
keywordHandler:addAliasKeyword({'hero'})
keywordHandler:addAliasKeyword({'adventurer'})
keywordHandler:addKeyword({'enemy'}, StdModule.say, {npcHandler = npcHandler, text = 'Our enemies are numerous. The evil minotaurs, Ferumbras, and the renegade city of Carlin to the north are just some of them.'})
keywordHandler:addAliasKeyword({'enemies'})
keywordHandler:addKeyword({'carlin'}, StdModule.say, {npcHandler = npcHandler, text = 'They dare to reject my reign over the whole continent!'})
keywordHandler:addKeyword({'thais'}, StdModule.say, {npcHandler = npcHandler, text = 'Our beloved city has some fine shops, guildhouses and a modern sewerage system.'})
keywordHandler:addAliasKeyword({'city'})
keywordHandler:addKeyword({'merchant'}, StdModule.say, {npcHandler = npcHandler, text = 'Ask around about them.'})
keywordHandler:addAliasKeyword({'craftsmen'})
keywordHandler:addKeyword({'paladin'}, StdModule.say, {npcHandler = npcHandler, text = 'The paladins are great protectors for Thais.'})
keywordHandler:addAliasKeyword({'elane'})
keywordHandler:addKeyword({'knight'}, StdModule.say, {npcHandler = npcHandler, text = 'The brave knights are necessary for human survival in Thais.'})
keywordHandler:addAliasKeyword({'gregor'})
keywordHandler:addKeyword({'sorcerer'}, StdModule.say, {npcHandler = npcHandler, text = 'The magic of the sorcerers is a powerful tool to smite our enemies.'})
keywordHandler:addAliasKeyword({'muriel'})
keywordHandler:addKeyword({'druid'}, StdModule.say, {npcHandler = npcHandler, text = 'We need the druidic healing powers to fight evil.'})
keywordHandler:addAliasKeyword({'marvik'})

npcHandler:setMessage(MESSAGE_GREET, 'I greet thee, my loyal subject |PLAYERNAME|.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye, |PLAYERNAME|!')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'How rude!')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

local focusModule = FocusModule:new()
focusModule:addGreetMessage('hail king')
focusModule:addGreetMessage('salutations king')
npcHandler:addModule(focusModule)
