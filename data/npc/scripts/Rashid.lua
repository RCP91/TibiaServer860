local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end
	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
	
	if(msgcontains(msg, "mission")) then
		--if(os.date("%A") == "Monday") then
			if(getPlayerStorageValue(cid, Storage.TravellingTrader.Mission01) < 1) then
				selfSay("Well, you could attempt the mission to become a recognised trader, but it requires a lot of travelling. Are you willing to try?", cid)
				talkState[talkUser] = 1
			elseif(getPlayerStorageValue(cid, Storage.TravellingTrader.Mission01) == 1) then
				selfSay("Have you managed to obtain a rare deer trophy for my customer?", cid)
				talkState[talkUser] = 3
			end
		--elseif(os.date("%A") == "Tuesday") then
			if(getPlayerStorageValue(cid, Storage.TravellingTrader.Mission01) == 2 and getPlayerStorageValue(cid, Storage.TravellingTrader.Mission02) < 1 ) then
				selfSay("So, my friend, are you willing to proceed to the next mission to become a recognised trader?", cid)
				talkState[talkUser] = 4
			elseif(getPlayerStorageValue(cid, Storage.TravellingTrader.Mission02) == 4) then
				selfSay("Did you bring me the package?", cid)
				talkState[talkUser] = 6
			end
		--elseif(os.date("%A") == "Wednesday") then
			if(getPlayerStorageValue(cid, Storage.TravellingTrader.Mission02) == 5 and getPlayerStorageValue(cid, Storage.TravellingTrader.Mission03) < 1 ) then
				selfSay("So, my friend, are you willing to proceed to the next mission to become a recognised trader?", cid)
				talkState[talkUser] = 7
			elseif(getPlayerStorageValue(cid, Storage.TravellingTrader.Mission03) == 2) then
				selfSay("Have you brought the cheese?", cid)
				talkState[talkUser] = 9
			end
		--elseif(os.date("%A") == "Thursday") then
			if(getPlayerStorageValue(cid, Storage.TravellingTrader.Mission03) == 3 and getPlayerStorageValue(cid, Storage.TravellingTrader.Mission04) < 1) then
				selfSay("So, my friend, are you willing to proceed to the next mission to become a recognised trader?", cid)
				talkState[talkUser] = 10
			elseif(getPlayerStorageValue(cid, Storage.TravellingTrader.Mission04) == 2) then
				selfSay("Have you brought the vase?", cid)
				talkState[talkUser] = 12
			end
		--elseif(os.date("%A") == "Friday") then
			if(getPlayerStorageValue(cid, Storage.TravellingTrader.Mission04) == 3 and getPlayerStorageValue(cid, Storage.TravellingTrader.Mission05) < 1) then
				selfSay("So, my friend, are you willing to proceed to the next mission to become a recognised trader?", cid)
				talkState[talkUser] = 13
			elseif(getPlayerStorageValue(cid, Storage.TravellingTrader.Mission05) == 2) then
				selfSay("Have you brought a cheap but good crimson sword?", cid)
				talkState[talkUser] = 15
			end
		--elseif(os.date("%A") == "Saturday") then
			if(getPlayerStorageValue(cid, Storage.TravellingTrader.Mission05) == 3 and getPlayerStorageValue(cid, Storage.TravellingTrader.Mission06) < 1) then
				selfSay("So, my friend, are you willing to proceed to the next mission to become a recognised trader?", cid)
				talkState[talkUser] = 16
			elseif(getPlayerStorageValue(cid, Storage.TravellingTrader.Mission06) == 1) then
				selfSay("Have you brought me a gold fish??", cid)
				talkState[talkUser] = 18
			end
		--elseif(os.date("%A") == "Sunday") then
			if(getPlayerStorageValue(cid, Storage.TravellingTrader.Mission06) == 2 and getPlayerStorageValue(cid, Storage.TravellingTrader.Mission07) ~= 1) then
				selfSay("Ah, right. <ahem> I hereby declare you - one of my recognised traders! Feel free to offer me your wares!", cid)
				setPlayerStorageValue(cid, Storage.TravellingTrader.Mission07, 1)
				--player:addAchievement('Recognised Trader')
				talkState[talkUser] = 0
			end
		--end
	elseif(msgcontains(msg, "yes")) then
		if(talkState[talkUser] == 1) then
			selfSay({
				"Very good! I need talented people who are able to handle my wares with care, find good offers and the like, so I'm going to test you. ...",
				"First, I'd like to see if you can dig up rare wares. Something like a ... mastermind shield! ...",
				"Haha, just kidding, fooled you there, didn't I? Always control your nerves, that's quite important during bargaining. ...",
				"Okay, all I want from you is one of these rare deer trophies. I have a customer here in Svargrond who ordered one, so I'd like you to deliver it tome while I'm in Svargrond. ...",
				"Everything clear and understood?"
			}, cid)

			talkState[talkUser] = 2
		elseif(talkState[talkUser] == 2) then
			selfSay("Fine. Then get a hold of that deer trophy and bring it to me while I'm in Svargrond. Just ask me about your mission.", cid)
			setPlayerStorageValue(cid, Storage.TravellingTrader.Mission01, 1)
			talkState[talkUser] = 0
		elseif(talkState[talkUser] == 3) then
			if doPlayerRemoveItem(cid, 7397, 1) then
				selfSay("Well done! I'll take that from you. <snags it> Come see me another day, I'll be busy for a while now. ", cid)
				setPlayerStorageValue(cid, Storage.TravellingTrader.Mission01, 2)
				talkState[talkUser] = 0
			end
		elseif(talkState[talkUser] == 4) then
			selfSay({
				"Alright, that's good to hear. From you as my trader and deliveryman, I expect more than finding rare items. ...",
				"You also need to be able to transport heavy wares, weaklings won't get far here. I have ordered a special package from Edron. ...",
				"Pick it up from Willard and bring it back to me while I'm in Liberty Bay. Everything clear and understood?"
			}, cid)
			talkState[talkUser] = 5
		elseif(talkState[talkUser] == 5) then
			selfSay("Fine. Then off you go, just ask Willard about the 'package for Rashid'.", cid)
			setPlayerStorageValue(cid, Storage.TravellingTrader.Mission02, 1)
			talkState[talkUser] = 0
		elseif(talkState[talkUser] == 6) then
			if doPlayerRemoveItem(cid, 7503, 1) then
				selfSay("Great. Just place it over there - yes, thanks, that's it. Come see me another day, I'll be busy for a while now. ", cid)
				setPlayerStorageValue(cid, Storage.TravellingTrader.Mission02, 5)
				talkState[talkUser] = 0
			end
		elseif(talkState[talkUser] == 7) then
			selfSay({
				"Well, that's good to hear. From you as my trader and deliveryman, I expect more than carrying heavy packages. ...",
				"You also need to be fast and deliver wares in time. I have ordered a very special cheese wheel made from Darashian milk. ...",
				"Unfortunately, the high temperature in the desert makes it rot really fast, so it must not stay in the sun for too long. ...",
				"I'm also afraid that you might not be able to use ships because of the smell of the cheese. ...",
				"Please get the cheese from Miraia and bring it to me while I'm in Port Hope. Everything clear and understood?"
			}, cid)
			talkState[talkUser] = 8
		elseif(talkState[talkUser] == 8) then
			selfSay("Okay, then please find Miraia in Darashia and ask her about the {'scarab cheese'}.", cid)
			setPlayerStorageValue(cid, Storage.TravellingTrader.Mission03, 1)
			talkState[talkUser] = 0
		elseif(talkState[talkUser] == 9) then
			if doPlayerRemoveItem(cid, 8112, 1) then
				selfSay("Mmmhh, the lovely odeur of scarab cheese! I really can't understand why most people can't stand it. Thanks, well done! ", cid)
				setPlayerStorageValue(cid, Storage.TravellingTrader.Mission03, 3)
				talkState[talkUser] = 0
			end
		elseif(talkState[talkUser] == 10) then
			selfSay({
				"Well, that's good to hear. From you as my trader and deliveryman, I expect more than bringing stinky cheese. ...",
				"I wonder if you are able to deliver goods so fragile they almost break when looked at. ...",
				"I have ordered a special elven vase from Briasol in Ab'Dendriel. Get it from him and don't even touch it, just bring it to me while I'm in Ankrahmun. Everything clear and understood?"
			}, cid)
			talkState[talkUser] = 11
		elseif(talkState[talkUser] == 11) then
			selfSay("Okay, then please find {Briasol} in {Ab'Dendriel} and ask for a {'fine vase'}.", cid)
			setPlayerStorageValue(cid, Storage.TravellingTrader.Mission04, 1)
			player:addMoney(1000)
			talkState[talkUser] = 0
		elseif(talkState[talkUser] == 12) then
			if doPlayerRemoveItem(cid, 7582, 1) then
				selfSay("I'm surprised that you managed to bring this vase without a single crack. That was what I needed to know, thank you. ", cid)
				setPlayerStorageValue(cid, Storage.TravellingTrader.Mission04, 3)
				talkState[talkUser] = 0
			end
		elseif(talkState[talkUser] == 13) then
			selfSay({
				"Fine! There's one more skill that I need to test and which is cruicial for a successful trader. ...",
				"Of course you must be able to haggle, else you won't survive long in this business. To make things as hard as possible for you, I have the perfect trade partner for you. ...",
				"Dwarves are said to be the most stubborn of all traders. Travel to {Kazordoon} and try to get the smith {Uzgod} to sell a {crimson sword} to you. ...",
				"Of course, it has to be cheap. Don't come back with anything more expensive than 400 gold. ...",
				"And the quality must not suffer, of course! Everything clear and understood?",
				"Dwarves are said to be the most stubborn of all traders. Travel to Kazordoon and try to get the smith Uzgod to sell a crimson sword to you. ..."
			}, cid)
			talkState[talkUser] = 14
		elseif(talkState[talkUser] == 14) then
			selfSay("Okay, I'm curious how you will do with {Uzgod}. Good luck!", cid)
			setPlayerStorageValue(cid, Storage.TravellingTrader.Mission05, 1)
			talkState[talkUser] = 0
		elseif(talkState[talkUser] == 15) then
			if doPlayerRemoveItem(cid, 7385, 1) then
				selfSay("Ha! You are clever indeed, well done! I'll take this from you. Come see me tomorrow, I think we two might get into business after all.", cid)
				setPlayerStorageValue(cid, Storage.TravellingTrader.Mission05, 3)
				talkState[talkUser] = 0
			end
		elseif(talkState[talkUser] == 16) then
			selfSay({
				"My friend, it seems you have already learnt a lot about the art of trading. I think you are more than worthy to become a recognised trader. ...",
				"There is just one little favour that I would ask from you... something personal, actually, forgive my boldness. ...",
				"I have always dreamed to have a small pet, one that I could take with me and which wouldn't cause problems. ...",
				"Could you - just maybe - bring me a small goldfish in a bowl? I know that you would be able to get one, wouldn't you?"
			}, cid)
			talkState[talkUser] = 17
		elseif(talkState[talkUser] == 17) then
			selfSay("Thanks so much! I'll be waiting eagerly for your return then.", cid)
			setPlayerStorageValue(cid, Storage.TravellingTrader.Mission06, 1)
			talkState[talkUser] = 0
		elseif(talkState[talkUser] == 18) then
			if doPlayerRemoveItem(cid, 5929, 1) then
				selfSay("Thank you!! Ah, this makes my day! I'll take the rest of the day off to get to know this little guy. Come see me tomorrow, if you like.", cid)
				setPlayerStorageValue(cid, Storage.TravellingTrader.Mission06, 2)
				talkState[talkUser] = 0
			end
		end
	end
	return true
end

keywordHandler:addKeyword({"job"}, StdModule.say, {npcHandler = npcHandler, text = "I am a travelling trader. I don't buy everything, though. And not from everyone, for that matter."})
keywordHandler:addKeyword({"name"}, StdModule.say, {npcHandler = npcHandler, text = "I am Rashid, son of the desert."})
keywordHandler:addKeyword({"offers"}, StdModule.say, {npcHandler = npcHandler, text = "Of course, old friend. You can also browse only armor, legs, shields, helmets, boots, weapons, enchanted weapons, jewelry or miscellaneous stuff."})
keywordHandler:addKeyword({"ab'dendriel"}, StdModule.say, {npcHandler = npcHandler, text = "Elves... I don't really trust them. All this talk about nature and flowers and treehugging... I'm sure there's some wicked scheme behind all this."})
keywordHandler:addKeyword({"desert"}, StdModule.say, {npcHandler = npcHandler, text = "My beloved hometown! Ah, the sweet scent of the desert sands, the perfect shape of the pyramids... stunningly beautiful."})
keywordHandler:addKeyword({"carlin"}, StdModule.say, {npcHandler = npcHandler, text = "I have to go to Carlin once in a while, since the queen wishes to see my exclusive wares in regular intervals."})
keywordHandler:addKeyword({"cormaya"}, StdModule.say, {npcHandler = npcHandler, text = "Cormaya? Not a good place to make business, it's way too far and small."})
keywordHandler:addKeyword({"darashia"}, StdModule.say, {npcHandler = npcHandler, text = "It's not the real thing, but almost as good. The merchants there claim ridiculous prices, which is fine for my own business."})
keywordHandler:addKeyword({"edron"}, StdModule.say, {npcHandler = npcHandler, text = "Ah yes, Edron! Such a lovely and quiet island! I usually make some nice business there."})
keywordHandler:addKeyword({"fibula"}, StdModule.say, {npcHandler = npcHandler, text = "Too few customers there, it's not worth the trip."})
keywordHandler:addKeyword({"greenshore"}, StdModule.say, {npcHandler = npcHandler, text = "Um... I don't think so."})
keywordHandler:addKeyword({"kazordoon"}, StdModule.say, {npcHandler = npcHandler, text = "I don't like being underground much. I also tend to get lost in these labyrinthine dwarven tunnels, so I rather avoid them."})
keywordHandler:addKeyword({"liberty bay"}, StdModule.say, {npcHandler = npcHandler, text = "When you avoid the slums, it's a really pretty city. Almost as pretty as the governor's daughter."})
keywordHandler:addKeyword({"northport"}, StdModule.say, {npcHandler = npcHandler, text = "Um... I don't think so."})
keywordHandler:addKeyword({"port hope"}, StdModule.say, {npcHandler = npcHandler, text = "I like the settlement itself, but I don't set my foot into the jungle. Have you seen the size of these centipedes??"})
keywordHandler:addKeyword({"senja"}, StdModule.say, {npcHandler = npcHandler, text = "Um... I don't think so."})
keywordHandler:addKeyword({"svargrond"}, StdModule.say, {npcHandler = npcHandler, text = "I wish it was a little bit warmer there, but with a good mug of barbarian mead in your tummy everything gets a lot cosier."})
keywordHandler:addKeyword({"thais"}, StdModule.say, {npcHandler = npcHandler, text = "I feel uncomfortable and rather unsafe in Thais, so I don't really travel there."})
keywordHandler:addKeyword({"vega"}, StdModule.say, {npcHandler = npcHandler, text = "Um... I don't think so."})
keywordHandler:addKeyword({"venore"}, StdModule.say, {npcHandler = npcHandler, text = "Although it's the flourishing trade centre of Tibia, I don't like going there. Too much competition for my taste."})
keywordHandler:addKeyword({"time"}, StdModule.say, {npcHandler = npcHandler, text = "It's almost time to journey on."})
keywordHandler:addKeyword({"king"}, StdModule.say, {npcHandler = npcHandler, text = "Kings, queens, emperors and kaliphs... everyone claims to be different and unique, but actually it's the same thing everywhere."})

npcHandler:setMessage(MESSAGE_GREET, "Ah, a customer! Be greeted, |PLAYERNAME|!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Farewell, |PLAYERNAME|, may the winds guide your way.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Come back soon!")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Take all the time you need to decide what you want!")

local function onTradeRequest(cid)
	if Player(cid):getStorageValue(Storage.TravellingTrader.Mission07) ~= 1 then
		selfSay('Sorry, but you do not belong to my exclusive customers. I have to make sure that I can trust in the quality of your wares.', cid)
		return false
	end

	return true
end

npcHandler:setCallback(CALLBACK_ONTRADEREQUEST, onTradeRequest)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
