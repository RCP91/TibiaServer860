 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local playerTopic = {}
local voices = { {text = 'abc'} }
local quantidade = {}

local function greetCallback(cid)
	
	if player then
		npcHandler:setMessage(MESSAGE_GREET, {"Greetings. A warning straight ahead: I don't like loiterin'. If you're not here to {help} us, you're here to waste my time. Which I consider loiterin'. Now, try and prove your {worth} to our alliance. ... ",
											  "I have sealed some of the areas far too dangerous for anyone to enter. If you can prove you're capable, you'll get an opportunity to help destroy the weird machines, pumping lava into the caves leading to the most dangerous enemies."})
		playerTopic[cid] = 1
	end
	npcHandler:addFocus(cid)
	return true
end

keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = 'Well, the biggest problem we need to address are the ever charging {subterraneans} around here. And on top of that, there\'s the threat of the Lost, who quite made themselves at {home} in these parts.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'Maintainin\' this whole operation, the dwarven involvement \'course. Don\'t know about them gnomes but if I ain\'t gettin\' those dwarves in line, there\'ll be chaos down here. I also oversee the {defences} and {counterattacks}.'})
keywordHandler:addKeyword({'defences'}, StdModule.say, {npcHandler = npcHandler, text = {'The attacks of the enemy forces are fierce but we hold our ground. ... ',
																						'I\'d love to face one of their generals in combat but as their masters they cowardly hide far behind enemy lines and I have other duties to fulfil. ... ',
																						'I envy you for the chance to thrust into the heart of the enemy, locking weapons with their jaws... or whatever... and see the fear in their eyes when they recognise they were bested.'}})
keywordHandler:addKeyword({'counterattacks'}, StdModule.say, {npcHandler = npcHandler, text = {'I welcome a fine battle as any dwarf worth his beard should do. As long as it\'s a battle against something I can hit with my trusty axe. ...',
																							  'But here the true {enemy} eludes us. We fight wave after wave of their lackeys and if the gnomes are right the true enemy is up to something far more sinister. '}})
keywordHandler:addKeyword({'enemy'}, StdModule.say, {npcHandler = npcHandler, text = {'I have no idea what kind of creeps are behind all this. Even the gnomes don\'t and they have handled that stuff way more often. ...',
																					 'But even if we knew nothing more about them, the fact alone that they employ the help of those mockeries of all things dwarfish, marks them as an enemy of the dwarves and it\'s our obligation to annihilate them.'}})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'Klom Stonecutter\'s the name. '})

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	talkState[talkUser] = playerTopic[cid]
	
	npc = Npc(cid)

	local tempo = 20*60*60

	-- missão subterraneans
	if msgcontains(msg, "subterraneans") and talkState[talkUser] == 1 then
		if getPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Subterranean) == 2 and getPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.timeTaskSubterranean) > 0 then
			selfSay({"I don't need your help for now. Come back later."}, cid)
			playerTopic[cid] = 1
			talkState[talkUser] = 1
		end
		if getPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Subterranean) == 2 and getPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.timeTaskSubterranean) <= 0 then
			selfSay({"Vermin. Everywhere. We get a lot of strange four-legged crawlers and worms down here lately. It's getting out of hand and... well, I need a real killer for this. ",
							"Prepared to get rid of some seriously foul creepers for us?"}, cid)
			playerTopic[cid] = 2
			talkState[talkUser] = 2
		end
		if getPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Subterranean) < 1 then -- Não possuía a missão, agora possui!
			selfSay({"Vermin. Everywhere. We get a lot of strange four-legged crawlers and worms down here lately. It's getting out of hand and... well, I need a real killer for this. ",
							"Prepared to get rid of some seriously foul creepers for us?"}, cid)
			playerTopic[cid] = 2
			talkState[talkUser] = 2
		elseif (getPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Subterranean) == 1) and (getPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Organisms) < 50) then -- Está na missão porém não terminou a task!
			selfSay({"Come back when you have finished your job."}, cid)
			playerTopic[cid] = 1
			talkState[talkUser] = 1
		elseif (getPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Subterranean) == 1) and (getPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Organisms) >= 50) then
			selfSay({"I'l say I'm blown away but a Klom Stonecutter is not that easily impressed. Still, your got your hands dirt for us and I appreciate that."}, cid)
			-- Entregando surprise jar + 1 ponto de missão!
			setPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.timeTaskSubterranean, os.time() + tempo)
			doPlayerAddItem(cid, 32014, 1)
			setPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Status, getPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Status) + 1)
			setPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Subterranean, 2)
			playerTopic[cid] = 1
			talkState[talkUser] = 1
		end
	elseif talkState[talkUser] == 2 and msgcontains(msg, "yes") then
		selfSay({"Alright, good. Those things are strolling about and I ain't gonna have that. If it moves more than two legs, destroy it. If it moves legs and tentacles, destroy it again."}, cid)
		if getPlayerStorageValue(cid, Storage.DangerousDepths.Questline) < 1 then
			setPlayerStorageValue(cid, Storage.DangerousDepths.Questline, 1)
		end
		setPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Subterranean, 1)
		setPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Organisms, 0) -- Garantindo que a task não inicie com -1
		playerTopic[cid] = 1
		talkState[talkUser] = 1
	end

	-- missão home
	if msgcontains(msg, "home") and talkState[talkUser] == 1 then
		if getPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Home) == 2 and getPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.timeTaskHome) > 0 then
			selfSay({"I don't need your help for now. Come back later."}, cid)
			playerTopic[cid] = 1
			talkState[talkUser] = 1
		end
		if getPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Home) == 2 and getPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.timeTaskHome) <= 0 then
			selfSay({"We need to find a way to drive off the exiles from these caves. Countless makeshift homes are popping up at every corner. Destroy them and get the Lost out of hiding to eliminate them. ... ",
							"If you can capture a few of them, you'll receive a bonus. Just bring 'em to the border of our outpost and we will take care of the rest. ... ",
							"Are you ready for that? "}, cid)
			playerTopic[cid] = 22
			talkState[talkUser] = 22
		end
		if getPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Home) < 1 then -- Não possuía a missão, agora possui!
			selfSay({"We need to find a way to drive off the exiles from these caves. Countless makeshift homes are popping up at every corner. Destroy them and get the Lost out of hiding to eliminate them. ... ",
							"If you can capture a few of them, you'll receive a bonus. Just bring 'em to the border of our outpost and we will take care of the rest. ... ",
							"Are you ready for that? "}, cid)
			playerTopic[cid] = 22
			talkState[talkUser] = 22
		elseif (getPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Home) == 1) and (getPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.LostExiles) < 20 and getPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Prisoners) < 3) then -- Está na missão porém não terminou nenhuma das tasks!
			selfSay({"Come back when you have finished your job."}, cid)
			playerTopic[cid] = 1
			talkState[talkUser] = 1
		elseif (getPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Home) == 1) and (getPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.LostExiles) >= 20 and getPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Prisoners) < 3) then
			selfSay({"So you did it. Well, that won't be the last of 'em but this sure helps our situation down here. Return to me later if you want to help me again!"}, cid) -- Caso não tenha feito o task bônus
			-- Entregando surprise jar + 1 ponto de missão!
			setPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.timeTaskHome, os.time() + tempo)
			setPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Home, 2)
			doPlayerAddItem(cid, 32014, 1)
			setPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Status, getPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Status) + 1)
			playerTopic[cid] = 1
		talkState[talkUser] = 1
		elseif (getPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Home) == 1) and (getPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.LostExiles) >= 20 and getPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Prisoners) >= 3) then
			selfSay({"So you did it. And you even made prisoners, the bonus is yours! Well, that won't be the last of 'em but this sure helps our situation down here. Return to me later if you want to help me again!"}, cid) -- Se tiver feito ambas
			-- Entregando 2 surprise jars + 2 pontos de missão!
			setPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.timeTaskHome, os.time() + tempo)
			setPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Home, 2)
			doPlayerAddItem(cid, 32014, 2) -- +1 item pela task bônus!
			setPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Status, getPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Status) + 2) -- +1 ponto pela task bônus!
			playerTopic[cid] = 1
			talkState[talkUser] = 1
		end
	elseif talkState[talkUser] == 22 and msgcontains(msg, "yes") then
		selfSay({"Very well, now try to find some of their makeshift homes and tear'em down. There's bound to be some stragglers you can 'persuade' to surrender, eliminate any resistance. Get back here when you're done."}, cid)
			if getPlayerStorageValue(cid, Storage.DangerousDepths.Questline) < 1 then
				setPlayerStorageValue(cid, Storage.DangerousDepths.Questline, 1)
			end
		setPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Home, 1)
		setPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.LostExiles, 0) -- Garantindo que a task não inicie com -1
		setPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Prisoners, 0) -- Garantindo que a task não inicie com -1
		playerTopic[cid] = 1
		talkState[talkUser] = 1
	end

	local plural = ""
	if msgcontains(msg, "suspicious devices") or msgcontains(msg, "suspicious device") then
		selfSay({"If you bring me any suspicious devices on creatures you slay down here, I'll make it worth your while by telling the others of your generosity. How many do you want to offer? "}, cid)
		playerTopic[cid] = 55
		talkState[talkUser] = 55
	elseif talkState[talkUser] == 55 then
		quantidade[cid] = tonumber(msg)
		if quantidade[cid] then
			if quantidade[cid] > 1 then
				plural = plural .. "s"
			end
			selfSay({"You want to offer " .. quantidade[cid] .. " suspicious device" ..plural.. ". Which leader shall have it, (Gnomus) of the {gnomes}, (Klom Stonecutter) of the {dwarves} or the {scouts} (Lardoc Bashsmite)?"}, cid)
			playerTopic[cid] = 56
			talkState[talkUser] = 56
		else
			selfSay({"Don't waste my time."}, cid)
			playerTopic[cid] = 1
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, "gnomes") and talkState[talkUser] == 56 then
		if getPlayerItemCount(cid, 30888) >= quantidade[cid] then
			selfSay({"Done."}, cid)
			if quantidade[cid] > 1 then
				plural = plural .. "s"
			end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You earned ".. quantidade[cid] .." point"..plural.." on the gnomes mission.")
			doPlayerRemoveItem(cid, 30888, quantidade[cid])
			setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Status, getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Status) + quantidade[cid])
		else
			selfSay({"You don't have enough suspicious devices."}, cid)
			playerTopic[cid] = 1
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, "dwarves") and talkState[talkUser] == 56 then
		if getPlayerItemCount(cid, 30888) >= quantidade[cid] then
			selfSay({"Done."}, cid)
			if quantidade[cid] > 1 then
				plural = plural .. "s"
			end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You earned ".. quantidade[cid] .." point"..plural.." on the dwarves mission.")
			doPlayerRemoveItem(cid, 30888, quantidade[cid])
			setPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Status, getPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Status) + quantidade[cid])
		else
			selfSay({"You don't have enough suspicious devices."}, cid)
			playerTopic[cid] = 1
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, "scouts") and talkState[talkUser] == 56 then
		if getPlayerItemCount(cid, 30888) >= quantidade[cid] then
			selfSay({"Done."}, cid)
			if quantidade[cid] > 1 then
				plural = plural .. "s"
			end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You earned ".. quantidade[cid] .." point"..plural.." on the scouts mission.")
			doPlayerRemoveItem(cid, 30888, quantidade[cid])
			setPlayerStorageValue(cid, Storage.DangerousDepths.Scouts.Status, getPlayerStorageValue(cid, Storage.DangerousDepths.Scouts.Status) + quantidade[cid])
		else
			selfSay({"You don't have enough suspicious devices."}, cid)
			playerTopic[cid] = 1
			talkState[talkUser] = 1
		end
	end



 	-- Início checagem de pontos de tasks!!
	if msgcontains(msg, "status") then
		selfSay({"So you want to know what we all think about your deeds? What leader\'s opinion are you interested in, the {gnomes} (Gnomus), the {dwarves} (Klom Stonecutter) or the {scouts} (Lardoc Bashsmite)?"}, cid)
		playerTopic[cid] = 5
		talkState[talkUser] = 5
	elseif msgcontains(msg, "gnomes") and talkState[talkUser] == 5 then
		selfSay({'The gnomes are still in need of your help, member of Bigfoot\'s Brigade. Prove your worth by answering their calls! (' .. math.max(getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Status), 0) .. '/10)'}, cid)
	elseif msgcontains(msg, "dwarves") and talkState[talkUser] == 5 then
		selfSay({'The dwarves are still in need of your help, member of Bigfoot\'s Brigade. Prove your worth by answering their calls! (' .. math.max(getPlayerStorageValue(cid, Storage.DangerousDepths.Dwarves.Status), 0) .. '/10)'}, cid)
	elseif msgcontains(msg, "scouts") and talkState[talkUser] == 5 then
		selfSay({'The scouts are still in need of your help, member of Bigfoot\'s Brigade. Prove your worth by answering their calls! (' .. math.max(getPlayerStorageValue(cid, Storage.DangerousDepths.Scouts.Status), 0) .. '/10)'}, cid)
	end
	return true
end



npcHandler:setMessage(MESSAGE_WALKAWAY, 'Well, bye then.')

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
