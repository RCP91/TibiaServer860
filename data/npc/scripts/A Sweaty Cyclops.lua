 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{ text = 'Hum hum, huhum' },
	{ text = 'Silly lil\' human' }
}

--npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	if msgcontains(msg, "melt") then
		selfSay("Can melt gold ingot for lil' one. You want?", cid)
		talkState[talkUser] = 10
	elseif msgcontains(msg, "yes") and talkState[talkUser] == 10 then
		if doPlayerRemoveItem(cid, 9971,1) then
			selfSay("whoooosh There!", cid)
			doPlayerAddItem(cid, 13941, 1)
		else
			selfSay("There is no gold ingot with you.", cid)
		end
		talkState[talkUser] = 0
	end

	if msgcontains(msg, "amulet") then
		if getPlayerStorageValue(cid, Storage.SweetyCyclops.AmuletStatus) < 1 then
			selfSay("Me can do unbroken but Big Ben want gold 5000 and Big Ben need a lil' time to make it unbroken. Yes or no??", cid)
			talkState[talkUser] = 9
		elseif getPlayerStorageValue(cid, Storage.SweetyCyclops.AmuletStatus) == 1 then
			selfSay("Ahh, lil' one wants amulet. Here! Have it! Mighty, mighty amulet lil' one has. Don't know what but mighty, mighty it is!!!", cid)
			doPlayerAddItem(cid, 8266, 1)
			setPlayerStorageValue(cid, Storage.SweetyCyclops.AmuletStatus, 2)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			selfSay("Wait. Me work no cheap is. Do favour for me first, yes?", cid)
			talkState[talkUser] = 2
		elseif talkState[talkUser] == 2 then
			selfSay("Me need gift for woman. We dance, so me want to give her bast skirt. But she big is. So I need many to make big one. Bring three okay? Me wait.", cid)
			talkState[talkUser] = 0
			setPlayerStorageValue(cid, Storage.FriendsandTraders.DefaultStart, 1)
			setPlayerStorageValue(cid, Storage.FriendsandTraders.TheSweatyCyclops, 1)
		elseif talkState[talkUser] == 3 then
			if doPlayerRemoveItem(cid, 3983, 3) then
				selfSay("Good good! Woman happy will be. Now me happy too and help you.", cid)
				talkState[talkUser] = 0
				setPlayerStorageValue(cid, Storage.FriendsandTraders.TheSweatyCyclops, 2)
			end
		-- Crown Armor
		elseif talkState[talkUser] == 4 then
			if doPlayerRemoveItem(cid, 2487, 1) then
				selfSay("Cling clang!", cid)
				talkState[talkUser] = 0
				doPlayerAddItem(cid, 5887, 1)
			end
		-- Dragon Shield
		elseif talkState[talkUser] == 5 then
			if doPlayerRemoveItem(cid, 2516, 1) then
				selfSay("Cling clang!", cid)
				talkState[talkUser] = 0
				doPlayerAddItem(cid, 5889, 1)
			end
		-- Devil Helmet
		elseif talkState[talkUser] == 6 then
			if doPlayerRemoveItem(cid, 2462, 1) then
				selfSay("Cling clang!", cid)
				talkState[talkUser] = 0
				doPlayerAddItem(cid, 5888, 1)
			end
		-- Giant Sword
		elseif talkState[talkUser] == 7 then
			if doPlayerRemoveItem(cid, 2393, 1) then
				selfSay("Cling clang!", cid)
				talkState[talkUser] = 0
				doPlayerAddItem(cid, 5892, 1)
			end
		-- Soul Orb
		elseif talkState[talkUser] == 8 then
			if getPlayerItemCount(cid, 5944) > 0 then
				local count = getPlayerItemCount(cid, 5944)
				for i = 1, count do
					if math.random(100) <= 1 then
						doPlayerAddItem(cid, 6529, 6)
						doPlayerRemoveItem(cid, 5944, 1)
					else
						doPlayerAddItem(cid, 6529, 3)
						doPlayerRemoveItem(cid, 5944, 1)
					end
				end
				selfSay("Cling clang!", cid)
				talkState[talkUser] = 0
				else
				selfSay("You dont have soul orbs!", cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 9 then
			if getPlayerItemCount(cid, 8262) > 0 and getPlayerItemCount(cid, 8263) > 0 and getPlayerItemCount(cid, 8264) > 0 and getPlayerItemCount(cid, 8265) > 0 and getPlayerBalance(cid) + getPlayerBalance(cid) >= 5000 then
				doPlayerRemoveItem(cid, 8262, 1)
				doPlayerRemoveItem(cid, 8263, 1)
				doPlayerRemoveItem(cid, 8264, 1)
				doPlayerRemoveItem(cid, 8265, 1)
				doPlayerRemoveMoney(cid, 5000)
				setPlayerStorageValue(cid, Storage.SweetyCyclops.AmuletTimer, os.time())
				setPlayerStorageValue(cid, Storage.SweetyCyclops.AmuletStatus, 1)
				selfSay("Well, well, I do that! Big Ben makes lil' amulet unbroken with big hammer in big hands! No worry! Come back after sun hits the horizon 24 times and ask me for amulet.", cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 11 then
			if doPlayerRemoveItem(cid, 5880, 1) then
				setPlayerStorageValue(cid, Storage.hiddenCityOfBeregar.GearWheel, getPlayerStorageValue(cid, Storage.hiddenCityOfBeregar.GearWheel) + 1)
				doPlayerAddItem(cid, 9690, 1)
			else
				selfSay("Lil' one does not have any iron ores.", cid)
			end
			talkState[talkUser] = 0
		end

	-- Crown Armor
	elseif msgcontains(msg, "uth'kean") then
		if getPlayerStorageValue(cid, Storage.FriendsandTraders.TheSweatyCyclops) < 1 then
			selfSay("Very noble. Shiny. Me like. But breaks so fast. Me can make from shiny armour. Lil' one want to trade?", cid)
			talkState[talkUser] = 1
		elseif getPlayerStorageValue(cid, Storage.FriendsandTraders.TheSweatyCyclops) == 1 then
			selfSay("Lil' one bring three bast skirts?", cid)
			talkState[talkUser] = 3
		elseif getPlayerStorageValue(cid, Storage.FriendsandTraders.TheSweatyCyclops) == 2 then
			selfSay("Very noble. Shiny. Me like. But breaks so fast. Me can make from shiny armour. Lil' one want to trade?", cid)
			talkState[talkUser] = 4
		end
	-- Dragon Shield
	elseif msgcontains(msg, "uth'lokr") then
		if getPlayerStorageValue(cid, Storage.FriendsandTraders.TheSweatyCyclops) < 1 then
			selfSay("Firy steel it is. Need green ones' breath to melt. Or red even better. Me can make from shield. Lil' one want to trade?", cid)
			talkState[talkUser] = 1
		elseif getPlayerStorageValue(cid, Storage.FriendsandTraders.TheSweatyCyclops) == 1 then
			selfSay("Lil' one bring three bast skirts?", cid)
			talkState[talkUser] = 3
		elseif getPlayerStorageValue(cid, Storage.FriendsandTraders.TheSweatyCyclops) == 2 then
			selfSay("Firy steel it is. Need green ones' breath to melt. Or red even better. Me can make from shield. Lil' one want to trade?", cid)
			talkState[talkUser] = 5
		end
	-- Devil Helmet
	elseif msgcontains(msg, "za'ralator") then
		if getPlayerStorageValue(cid, Storage.FriendsandTraders.TheSweatyCyclops) < 1 then
			selfSay("Hellsteel is. Cursed and evil. Dangerous to work with. Me can make from evil helmet. Lil' one want to trade?", cid)
			talkState[talkUser] = 1
		elseif getPlayerStorageValue(cid, Storage.FriendsandTraders.TheSweatyCyclops) == 1 then
			selfSay("Lil' one bring three bast skirts?", cid)
			talkState[talkUser] = 3
		elseif getPlayerStorageValue(cid, Storage.FriendsandTraders.TheSweatyCyclops) == 2 then
			selfSay("Hellsteel is. Cursed and evil. Dangerous to work with. Me can make from evil helmet. Lil' one want to trade?", cid)
			talkState[talkUser] = 6
		end
	-- Giant Sword
	elseif msgcontains(msg, "uth'prta") then
		if getPlayerStorageValue(cid, Storage.FriendsandTraders.TheSweatyCyclops) < 1 then
			selfSay("Good iron is. Me friends use it much for fight. Me can make from weapon. Lil' one want to trade?", cid)
			talkState[talkUser] = 1
		elseif getPlayerStorageValue(cid, Storage.FriendsandTraders.TheSweatyCyclops) == 1 then
			selfSay("Lil' one bring three bast skirts?", cid)
			talkState[talkUser] = 3
		elseif getPlayerStorageValue(cid, Storage.FriendsandTraders.TheSweatyCyclops) == 2 then
			selfSay("Good iron is. Me friends use it much for fight. Me can make from weapon. Lil' one want to trade?", cid)
			talkState[talkUser] = 7
		end
	-- Soul Orb
	elseif msgcontains(msg, "soul orb") then
		if getPlayerStorageValue(cid, Storage.FriendsandTraders.TheSweatyCyclops) < 1 then
			selfSay("Uh. Me can make some nasty lil' bolt from soul orbs. Lil' one want to trade all?", cid)
			talkState[talkUser] = 1
		elseif getPlayerStorageValue(cid, Storage.FriendsandTraders.TheSweatyCyclops) == 1 then
			selfSay("Lil' one bring three bast skirts?", cid)
			talkState[talkUser] = 3
		elseif getPlayerStorageValue(cid, Storage.FriendsandTraders.TheSweatyCyclops) == 2 then
			selfSay("Uh. Me can make some nasty lil' bolt from soul orbs. Lil' one want to trade all?", cid)
			talkState[talkUser] = 8
		end
	elseif msgcontains(msg, "gear wheel") then
		if getPlayerStorageValue(cid, Storage.hiddenCityOfBeregar.GoingDown) > 0 and getPlayerStorageValue(cid, Storage.hiddenCityOfBeregar.GearWheel) > 3 then
			selfSay("Uh. Me can make some gear wheel from iron ores. Lil' one want to trade?", cid)
			talkState[talkUser] = 11
		end
	end
	return true
end

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I am smith."})
keywordHandler:addKeyword({'smith'}, StdModule.say, {npcHandler = npcHandler, text = "Working steel is my profession."})
keywordHandler:addKeyword({'steel'}, StdModule.say, {npcHandler = npcHandler, text = "Manny kinds of. Like {Mesh Kaha Rogh'}, {Za'Kalortith}, {Uth'Byth}, {Uth'Morc}, {Uth'Amon}, {Uth'Maer}, {Uth'Doon}, and {Zatragil}."})
keywordHandler:addKeyword({'zatragil'}, StdModule.say, {npcHandler = npcHandler, text = "Most ancients use dream silver for different stuff. Now ancients most gone. Most not know about."})
keywordHandler:addKeyword({'uth\'doon'}, StdModule.say, {npcHandler = npcHandler, text = "It's high steel called. Only lil' lil' ones know how make."})
keywordHandler:addKeyword({'za\'kalortith'}, StdModule.say, {npcHandler = npcHandler, text = "It's evil. Demon iron is. No good cyclops goes where you can find and need evil flame to melt."})
keywordHandler:addKeyword({'mesh kaha rogh'}, StdModule.say, {npcHandler = npcHandler, text = "Steel that is singing when forged. No one knows where find today."})
keywordHandler:addKeyword({'uth\'byth'}, StdModule.say, {npcHandler = npcHandler, text = "Not good to make stuff off. Bad steel it is. But eating magic, so useful is."})
keywordHandler:addKeyword({'uth\'maer'}, StdModule.say, {npcHandler = npcHandler, text = "Brightsteel is. Much art made with it. Sorcerers too lazy and afraid to enchant much."})
keywordHandler:addKeyword({'uth\'amon'}, StdModule.say, {npcHandler = npcHandler, text = "Heartiron from heart of big old mountain, found very deep. Lil' lil ones fiercely defend. Not wanting to have it used for stuff but holy stuff."})
keywordHandler:addKeyword({'ab\'dendriel'}, StdModule.say, {npcHandler = npcHandler, text = "Me parents live here before town was. Me not care about lil' ones."})
keywordHandler:addKeyword({'lil\' lil\''}, StdModule.say, {npcHandler = npcHandler, text = "Lil' lil' ones are so fun. We often chat."})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = "One day I'll go and look."})
keywordHandler:addKeyword({'teshial'}, StdModule.say, {npcHandler = npcHandler, text = "Is one of elven family or such thing. Me not understand lil' ones and their business."})
keywordHandler:addKeyword({'cenath'}, StdModule.say, {npcHandler = npcHandler, text = "Is one of elven family or such thing. Me not understand lil' ones and their business."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "I called Bencthyclthrtrprr by me people. Lil' ones me call Big Ben."})
keywordHandler:addKeyword({'god'}, StdModule.say, {npcHandler = npcHandler, text = "You shut up. Me not want to hear."})
keywordHandler:addKeyword({'fire sword'}, StdModule.say, {npcHandler = npcHandler, text = "Do lil' one want to trade a fire sword?"})
keywordHandler:addKeyword({'dragon shield'}, StdModule.say, {npcHandler = npcHandler, text = "Do lil' one want to trade a dragon shield?"})
keywordHandler:addKeyword({'sword of valor'}, StdModule.say, {npcHandler = npcHandler, text = "Do lil' one want to trade a sword of valor?"})
keywordHandler:addKeyword({'warlord sword'}, StdModule.say, {npcHandler = npcHandler, text = "Do lil' one want to trade a warlord sword?"})
keywordHandler:addKeyword({'minotaurs'}, StdModule.say, {npcHandler = npcHandler, text = "They were friend with me parents. Long before elves here, they often made visit. No longer come here."})
keywordHandler:addKeyword({'elves'}, StdModule.say, {npcHandler = npcHandler, text = "Me not fight them, they not fight me."})
keywordHandler:addKeyword({'excalibug'}, StdModule.say, {npcHandler = npcHandler, text = "Me wish I could make weapon like it."})
keywordHandler:addKeyword({'cyclops'}, StdModule.say, {npcHandler = npcHandler, text = "Me people not live here much. Most are far away."})

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Hum Humm! Welcume lil' |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye lil' one.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye lil' one.")
npcHandler:addModule(FocusModule:new())
