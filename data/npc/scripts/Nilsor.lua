local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	
	if msgcontains(msg, "svargrond") or msgcontains(msg, "passage") then
		selfSay("Do you want to go back to Svargrond?", cid)
		talkState[talkUser] = 10
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 10 then
			player:teleportTo(Position(32306, 31082, 7))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			talkState[talkUser] = 0
		end
	end

	if msgcontains(msg, "mission") then
		if getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 20 then
			selfSay({
				"I am in dire need of help. A plague has befallen my dogs. I even called a druid of Carlin for help but all he could do was to recommend some strong medicine ...",
				"The thing is the ingredients of the medicine are extremely rare and some only exist in far away and distant lands. If you could help me collecting the ingredients, I would be eternally grateful ...",
				"Are you willing to help me?"
			}, cid)
			talkState[talkUser] = 1
		elseif getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 28 then
			selfSay({
				"Thank you. Now I have all necessary ingredients. As a reward I grant you the use of our dog sled, which is located to the east of here. ...",
				"The dogs can be a bit moody, but if you always carry some ham with you there shouldnt be any problems. Oh, and Hjaern might have a mission for you. So maybe you go and talk to him."
			}, cid)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 29)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Mission07, 1) -- Questlog The Ice Islands Quest, The Secret of Helheim
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) > 20 and getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) < 28 then
			selfSay("What for ingredient do you have?", cid)
			talkState[talkUser] = 0
		else
			selfSay("I have now no mission for you.", cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "waterskin") then
		selfSay("Do you want to buy a waterskin for 25 gold?", cid)
		talkState[talkUser] = 2

	elseif msgcontains(msg, "cactus") then
		if getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 21 then
			selfSay("You will find this kind of cactus at places that are called deserts. Only an ordinary kitchen knife will be precise enough to produce the ingredient weneed. Do you have a part of that cactus with you?", cid)
			talkState[talkUser] = 3
		end
	elseif msgcontains(msg, "water") then
		if getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 22 then
			selfSay({
				"You will need a specially prepared waterskin to collect the water. You can buy one from me ...",
				"Use it on a geyser that is NOT active. The water of active geysers is far too hot. You can find inactive geysers on Okolnir. Do you have some geyser water with you?"
			}, cid)
			talkState[talkUser] = 4
		end
	elseif msgcontains(msg, "sulphur") then
		if getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 23 then
			selfSay("I need fine sulphur of an inactive lava hole. No other sulphur will do. Use an ordinary kitchen spoon on an inactive lava hole. Do you have fine sulphur with you?", cid)
			talkState[talkUser] = 5
		end
	elseif msgcontains(msg, "herb") then
		if getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 24 then
			selfSay("The frostbite herb is a local plant but its quite rare. You can find it on mountain peaks. You will need to cut it with a fine kitchen knife. Do you have a frostbite herb with you?", cid)
			talkState[talkUser] = 6
		end
	elseif msgcontains(msg, "blossom") then
		if getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 25 then
			selfSay("The purple kiss is a plant that grows in a place called jungle. You will have to use a kitchen knife to harvest its blossom. Do you have a blossom of a purple kiss with you?", cid)
			talkState[talkUser] = 7
		end
	elseif msgcontains(msg, "hydra tongue") then
		if getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 26 then
			selfSay("The hydra tongue is a common pest plant in warmer regions. You might find one in a shop. Do you have a hydra tongue with you?", cid)
			talkState[talkUser] = 8
		end
	elseif msgcontains(msg, "spores") then
		if getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 27 then
			selfSay("The giant glimmercap mushroom exists in caves and other preferably warm and humid places. Use an ordinary kitchen spoon on a mushroom to collectits spores. Do you have the glimmercap spores?", cid)
			talkState[talkUser] = 9
		end

	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			selfSay({
				"A thousand thanks in advance. I need no less than 7 ingredients for the cure. You can ask me about each specifically ...",
				"I need a part of the sun adorer cactus, a vial of geyser water, sulphur of a lava hole, a frostbite herb, a blossom of a purple kiss, a hydra tongue and spores of a giant glimmercap mushroom ...",
				"Turn them in individually by talking about them to me. As soon as I obtained them all, talk to me about the medicine. First time bring a Part of the Sun Adorer {Cactus}."
			}, cid)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 21)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Mission06, 1) -- Questlog The Ice Islands Quest, Nibelor 5: Cure the Dogs
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 2 then
			if getPlayerBalance(cid) + getPlayerBalance(cid) >= 25 then
				doPlayerRemoveMoney(cid, 25)
				selfSay("Here you are. A waterskin!", cid)
				doPlayerAddItem(cid, 7286, 1)
			else
				selfSay("You don't have enough money.", cid)
			end
			talkState[talkUser] = 0

		elseif talkState[talkUser] == 3 then
			if doPlayerRemoveItem(cid, 7245, 1) then
				selfSay("Thank you for this ingredient. Now bring me Geyser {Water} in a Waterskin. ", cid)
				setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 22)
				setPlayerStorageValue(cid, Storage.TheIceIslands.Mission06, 2) -- Questlog The Ice Islands Quest, Nibelor 5: Cure the Dogs
			else
				selfSay("Come back when you have the ingredient.", cid)
			end
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 4 then
			if doPlayerRemoveItem(cid, 7246, 1) then
				selfSay("Thank you for this ingredient. Now bring me Fine {Sulphur}.", cid)
				setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 23)
				setPlayerStorageValue(cid, Storage.TheIceIslands.Mission06, 3) -- Questlog The Ice Islands Quest, Nibelor 5: Cure the Dogs
			else
				selfSay("Come back when you have the ingredient.", cid)
			end
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 5 then
			if doPlayerRemoveItem(cid, 7247, 1) then
				selfSay("Thank you for this ingredient. Now bring me the Frostbite {Herb}", cid)
				setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 24)
				setPlayerStorageValue(cid, Storage.TheIceIslands.Mission06, 4) -- Questlog The Ice Islands Quest, Nibelor 5: Cure the Dogs
			else
				selfSay("Come back when you have the ingredient.", cid)
			end
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 6 then
			if doPlayerRemoveItem(cid, 7248, 1) then
				selfSay("Thank you for this ingredient Now bring me Purple Kiss {Blossom}.", cid)
				setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 25)
				setPlayerStorageValue(cid, Storage.TheIceIslands.Mission06, 5) -- Questlog The Ice Islands Quest, Nibelor 5: Cure the Dogs
			else
				selfSay("Come back when you have the ingredient.", cid)
			end
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 7 then
			if doPlayerRemoveItem(cid, 7249, 1) then
				selfSay("Thank you for this ingredient. Now bring me the {Hydra Tongue}", cid)
				setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 26)
				setPlayerStorageValue(cid, Storage.TheIceIslands.Mission06, 6) -- Questlog The Ice Islands Quest, Nibelor 5: Cure the Dogs
			else
				selfSay("Come back when you have the ingredient. ", cid)
			end
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 8 then
			if doPlayerRemoveItem(cid, 7250, 1) then
				selfSay("Thank you for this ingredient. Now bring me {Spores} of a Giant Glimmercap Mushroom.", cid)
				setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 27)
				setPlayerStorageValue(cid, Storage.TheIceIslands.Mission06, 7) -- Questlog The Ice Islands Quest, Nibelor 5: Cure the Dogs
			else
				selfSay("Come back when you have the ingredient.", cid)
			end
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 9 then
			if doPlayerRemoveItem(cid, 7251, 1) then
				selfSay("Thank you for this ingredient. Now you finish your {mission}", cid)
				setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 28)
				setPlayerStorageValue(cid, Storage.TheIceIslands.Mission06, 8) -- Questlog The Ice Islands Quest, Nibelor 5: Cure the Dogs
			else
				selfSay("Come back when you have the ingredient.", cid)
			end
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "no") then
		if talkState[talkUser] >= 2 then
			selfSay("Then come back when you have the ingredient.", cid)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
