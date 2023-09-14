 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = { {text = 'This weather is killing me. If I only had enough money to retire.'} }
--npcHandler:addModule(VoiceModule:new(voices))

local function greetCallback(cid)
	
	if getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter) == -1 then
		npcHandler:setMessage(MESSAGE_GREET, 'Hello! Tell me what\'s on your mind. Time is money.')
		setPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter, 0)
	else
		npcHandler:setMessage(MESSAGE_GREET, 'Hello! Tell me what\'s on your mind. Time is money.')
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end


	if msgcontains(msg, "passage") or msgcontains(msg, "sail") then
		if getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter) < 5 then
			selfSay({
				"I see no reason to establish ship routes to other cities. There is nothing that would be worth the effort. ...",
				"But since you won\'t stop bugging me, let\'s make a deal: If you can prove that at least five of your so-called \'cities\' are not worthless, I might reconsider my position. ...",
				"Bring me something SPECIAL! The local bar tenders usually know what\'s interesting about their city.",
			}, cid)
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter) >= 5 then
			selfSay({
				"For the sake of profit, we established ship routes to {Ab\'Dendriel}, {Darashia}, {Venore}, {Ankrahmun}, {Port Hope}, {Thais}, {Liberty Bay} and {Carlin}.",
			}, cid)
			talkState[talkUser] = 0
		else return false
		end
	elseif msgcontains(msg, "Ab\'Dendriel") then
		if getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.AbDendriel) ~= 1 and getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter) < 5 then
			selfSay({
				"I\'ve never been there. I doubt the elves there came up with something noteworthy. Or did you find something interesting there?",
			}, cid)
			talkState[talkUser] = 1
		elseif getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.AbDendriel) == 1 or getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter) >= 5 then
			selfSay({
				"Do you want a passage to Ab\'Dendriel for 160 gold?", 	---missing line
			}, cid)
			talkState[talkUser] = 11
		else return false
		end
	elseif msgcontains(msg, "Darashia") then
		if getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.Darashia) ~= 1 and getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter) < 5 then
			selfSay({
				"From all what I have heard, it is an unremarkable pile of huts in the desert. Or did you find something interesting there?",
			}, cid)
			talkState[talkUser] = 2
		elseif getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.Darashia) == 1 or getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter) >= 5 then
			selfSay({
				"Of course it is merely superstition that the darashian sand wasp honey brings back youth and vitality, but as long people pay a decent price, I couldn't care less. Do you want a passage to Darashia for 210 gold?",
			}, cid)
			talkState[talkUser] = 12
		else return false
		end
	elseif msgcontains(msg, "Venore") then
		if getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.Venore) ~= 1 and getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter) < 5 then
			selfSay({
				"Another port full of smelly humans, fittingly located in a swamp. Or did you find something interesting there?",
			}, cid)
			talkState[talkUser] = 3
		elseif getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.Venore) == 1 or getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter) >= 5 then
			selfSay({"The swamp spice will turn out very lucrative considering that it helps to make even the most disgusting dish taste good. Do you want a passage to Venore for 185 gold?",}, cid)
			talkState[talkUser] = 13
		else return false
		end
	elseif msgcontains(msg, "Ankrahmun") then
		if getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.Ankrahmun) ~= 1 and getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter) < 5 then
			selfSay({
				"A city full of mad death worshippers, no thanks. Or did you find something interesting there?",
			}, cid)
			talkState[talkUser] = 4
		elseif getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.Ankrahmun) == 1 or getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter) >= 5 then
			selfSay({
				"The Yalahari seem to be obsessed with conserving their dead, so I guess the embalming fluid will be a great success in Yalahar. Do you want a passage to Ankrahmun for 230 gold?",
			}, cid)
			talkState[talkUser] = 14
		else return false
		end
	elseif msgcontains(msg, "Port Hope") then
		if getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.PortHope) ~= 1 and getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter) < 5 then
			selfSay({
				"Another pointless human settlement. Or did you find something interesting there?",
			}, cid)
			talkState[talkUser] = 5
		elseif getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.PortHope) == 1 or getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter) >= 5 then
			selfSay({
				"Ivory is highly prized by the artisans of the Yalahari. Do you want a passage to Port Hope for 260 gold?",
			}, cid)
			talkState[talkUser] = 15
		else return false
		end
	elseif msgcontains(msg, "Thais") then
		if getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.Thais) ~= 1 and getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter) < 5 then
			selfSay({
				"Thais must be a hell hole if only half of the stories we hear about it are true. Or did you find something interesting there?",
			}, cid)
			talkState[talkUser] = 6
		elseif getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.Thais) == 1 or getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter) >= 5 then
			selfSay({
				"Astonishing enough the royal satin seems to suit the exquisite taste of the Yalahari. Do you want a passage to Thais for 200 gold?",
			}, cid)
			talkState[talkUser] = 16
		else return false
		end
	elseif msgcontains(msg, "Liberty Bay") then
		if getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.LibertyBay) ~= 1 and getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter) < 5 then
			selfSay({
				"Which sane captain would sail his ship to a pirate town? Or did you find something interesting there?",
			}, cid)
			talkState[talkUser] = 7
		elseif getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.LibertyBay) == 1 or getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter) >= 5 then
			selfSay({
				"Do you want a passage to Liberty Bay for 275 gold?", ---missing line
			}, cid)
			talkState[talkUser] = 17
		else return false
		end
	elseif msgcontains(msg, "Carlin") then
		if getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.Carlin) ~= 1 and getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter) < 5 then
			selfSay({
				"An unremarkable town compared to the wonders of Yalahar. Or did you find something interesting there?",
			}, cid)
			talkState[talkUser] = 8
		elseif getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.Carlin) == 1 or getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter) >= 5 then
			selfSay({
				"The evergreen flower pots are an amusing item that might find some customers here. Do you want a passage to Carlin for 185 gold?",
			}, cid)
			talkState[talkUser] = 18
		else return false
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 and doPlayerRemoveItem(cid, 9674,1) then
			selfSay("What's that? Bug milk? Hm, perhaps I can find some customers for that! ", cid)
			setPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.AbDendriel, 1)
			setPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter, getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter) + 1)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 2 and doPlayerRemoveItem(cid, 9676,1) then
			selfSay("Sand wasp honey? Hm, interesting at least!", cid)
			setPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.Darashia, 1)
			setPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter, getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter) + 1)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 3 and doPlayerRemoveItem(cid, 9675,1) then
			selfSay("Some special spice might be of value indeed.", cid)
			setPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.Venore, 1)
			setPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter, getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter) + 1)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 4 and doPlayerRemoveItem(cid, 9677,1) then
			selfSay("I can hardly imagine that someone is interested in embalming fluid, but I\'ll give it a try.", cid)
			setPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.Ankrahmun, 1)
			setPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter, getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter) + 1)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 5 and doPlayerRemoveItem(cid, 3956,1) then
			selfSay("Of course! Ivory! Its value is quite obvious.", cid)
			setPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.PortHope, 1)
			setPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter, getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter) + 1)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 6 and doPlayerRemoveItem(cid, 9678,1) then
			selfSay("This royal satin is indeed of acceptable quality.", cid)
			setPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.Thais, 1)
			setPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter, getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter) + 1)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 7 and doPlayerRemoveItem(cid, 5553,1,27) then
			selfSay("I doubt that the esteemed Yalahari will indulge into something profane as rum. But who knows, I'll give it a try.", cid)
			setPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.LibertyBay, 1)
			setPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter, getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter) + 1)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 8 and doPlayerRemoveItem(cid, 11428,1) then
			selfSay("I doubt that these flowers will stay fresh and healthy forever. But if they do, they could be indeed valuable.", cid)
			setPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.Carlin, 1)
			setPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter, getPlayerStorageValue(cid, Storage.SearoutesAroundYalahar.TownsCounter) + 1)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 11 then
			if doPlayerRemoveMoney(cid, 160) then
				selfSay("Set the sails!", cid)
				doTeleportThing(cid, Position(32734, 31668, 6))
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				talkState[talkUser] = 0
			else
				selfSay("You don\'t have enough money.", cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 12 then
			if doPlayerRemoveMoney(cid, 210) then
				selfSay("Set the sails!", cid)
				doTeleportThing(cid, Position(33289, 32480, 6))
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				talkState[talkUser] = 0
			else
				selfSay("You don\'t have enough money.", cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 13 then
			if doPlayerRemoveMoney(cid, 185) then
				selfSay("Set the sails!", cid)
				doTeleportThing(cid, Position(32954, 32022, 6))
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				talkState[talkUser] = 0
			else
				selfSay("You don\'t have enough money.", cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 14 then
			if doPlayerRemoveMoney(cid, 230) then
				selfSay("Set the sails!", cid)
				doTeleportThing(cid, Position(33092, 32883, 6))
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				talkState[talkUser] = 0
			else
				selfSay("You don\'t have enough money.", cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 15 then
			if doPlayerRemoveMoney(cid, 260) then
				selfSay("Set the sails!", cid)
				doTeleportThing(cid, Position(32527, 32784, 6))
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				talkState[talkUser] = 0
			else
				selfSay("You don\'t have enough money.", cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 16 then
			if doPlayerRemoveMoney(cid, 200) then
				selfSay("Set the sails!", cid)
				doTeleportThing(cid, Position(32310, 32210, 6))
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				talkState[talkUser] = 0
			else
				selfSay("You don\'t have enough money.", cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 17 then
			if doPlayerRemoveMoney(cid, 275) then
				selfSay("Set the sails!", cid)
				doTeleportThing(cid, Position(32285, 32892, 6))
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				talkState[talkUser] = 0
			else
				selfSay("You don\'t have enough money.", cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 18 then
			if doPlayerRemoveMoney(cid, 185) then
				selfSay("Set the sails!", cid)
				doTeleportThing(cid, Position(32387, 31820, 6))
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				talkState[talkUser] = 0
			else
				selfSay("You don\'t have enough money.", cid)
				talkState[talkUser] = 0
			end
		else
			selfSay("Don\'t waste my time.", cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "no") then
		selfSay({"Then no.",}, cid)
		talkState[talkUser] = 0
	end
return true
end



-- Kick
--keywordHandler:addKeyword({'kick'}, StdModule.kick, {npcHandler = npcHandler, destination = {Position(32811, 31267, 6), Position(32811, 31270, 6), Position(32811, 31273, 6)}})

-- Basic
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I am the captain of this ship.'})
keywordHandler:addKeyword({'captain'}, StdModule.say, {npcHandler = npcHandler, text = 'I am the captain of this ship.'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m Karith. I don\'t belong to a caste any longer, and only serve the Yalahari.'})
keywordHandler:addKeyword({'yalahar'}, StdModule.say, {npcHandler = npcHandler, text = 'The city was a marvel to behold. It is certain that it have been the many foreigners that ruined it.'})

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye.")

local focusModule = FocusModule:new()
focusModule:addGreetMessage({'hi', 'hello', 'ashari'})
focusModule:addFarewellMessage({'bye', 'farewell', 'asgha thrazi'})
npcHandler:addModule(focusModule)

-- made by OBUCHpl
