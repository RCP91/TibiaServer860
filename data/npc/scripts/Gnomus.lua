 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local playerTopic = {}
local quantidade = {}

local function greetCallback(cid)
	
	if player then
		npcHandler:setMessage(MESSAGE_GREET, {"Greetings, member of the Bigfoot Brigade. We could really use some {help} from you right now. You should prove {worthy} to our alliance."})
		playerTopic[cid] = 1
	end
	npcHandler:addFocus(cid)
	return true
end

keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = 'If you\'re willing to help us, we could need an escort for arriving {ordnance}, help with {charting} the cave system and someone needs to get some heat {measurements} fast.'})
keywordHandler:addKeyword({'worthy'}, StdModule.say, {npcHandler = npcHandler, text = {'You\'re already known amongst the gnomes, member of the Bigfoot Brigade. I will make sure that the alliance learns of your deeds but you\'ll still need to help the dwarves and gnomes of this outpost to show your worth. ...',
																					   'We also found {suspicious devices} carried by all kinds of creatures down here. Down here, they are of extreme worth to us since they could contain the key to what\'s happening all around us. ...',
																					   'If you can aquire any, return them to me and I make sure to tell the others of your generosity. Return to me afterwards to check on your current {status}.'}})
keywordHandler:addKeyword({'base'}, StdModule.say, {npcHandler = npcHandler, text = {'Gnomish supplies and ingenuity have helped to establish and fortify this outpost. ...',
																					 'Our knowledge of the enemy and it\'s tactics would be of more use if the dwarves would listen to us somewhat more. But gnomes have learned to live with the imperfection of the other races.'}})
keywordHandler:addKeyword({'efforts'}, StdModule.say, {npcHandler = npcHandler, text = {'Our surveys of the area showed us some spikes in heat and seismic activity at very specific places. ...',
																				    'We conclude this is no coincidence and the enemy is using devices to pump up the lava to flood the area. We have seen it before and had to retreat each time. ...',
																				    'This time though we might have a counter prepared - given me manage to pierce their defences.'}})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'My name is Gnomus.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m the main gnomish contact for this base. I coordinate our efforts with those of the dwarves to ensure everything is running smoothly.'})

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	talkState[talkUser] = playerTopic[cid]
	
	npc = Npc(cid)

	local tempo = 20*60*60

	-- missão measurements
	if msgcontains(msg, "measurements") and talkState[talkUser] == 1 then
		if getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Measurements ) == 2 and getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.timeTaskMeasurements) > 0 then -- Ainda não se passaram as 20h
			selfSay({"I don't need your help for now. Come back later."}, cid)
			playerTopic[cid] = 1
			talkState[talkUser] = 1
		end
		if getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Measurements) == 2 and getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.timeTaskMeasurements) <= 0 then -- Vai fazer a missão após 20h
			selfSay({"The heat down here is not the only problem we have but one of our greatest concerns. Not only is it almost unbearable for us, it also seems to be rising. ...",
							"We need to find out if this is true and what that means for this place - and for us gnomes. You can help us do this by grabbing one of our trignometres and collecting as much as data from the heat in this area as possible. ...",
							"We'd need at least 5 measurements. Are you willing to do this?"}, cid)
			playerTopic[cid] = 2
			talkState[talkUser] = 2
		end
		if getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Measurements) < 1 then -- Não possuía a missão, agora possui!
			selfSay({"The heat down here is not the only problem we have but one of our greatest concerns. Not only is it almost unbearable for us, it also seems to be rising. ...",
							"We need to find out if this is true and what that means for this place - and for us gnomes. You can help us do this by grabbing one of our trignometres and collecting as much as data from the heat in this area as possible. ...",
							"We'd need at least 5 measurements. Are you willing to do this?"}, cid)
			playerTopic[cid] = 2
			talkState[talkUser] = 2
		elseif (getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Measurements) == 1) and (getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.locationCount) < 5) then -- Está na missão porém não terminou a task!
			selfSay({"Come back when you have finished your job."}, cid)
			playerTopic[cid] = 1
			talkState[talkUser] = 1
		elseif getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Measurements) == 1 and getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.locationCount) == 5 then -- Não possuía a missão, agora possui!
			selfSay({"Excellent, you returned with more data! Let me see... hmm. ...",
							"Well, we need more data on this but first I will have to show this to our grand horticulturist. Thank you for getting this for us!"}, cid)
			setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.timeTaskMeasurements, os.time() + tempo)
			doPlayerAddItem(cid, 32014, 1)
			setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Status, getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Status) + 1)
			setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Measurements, 2)
			playerTopic[cid] = 1
			talkState[talkUser] = 1
		end
	elseif talkState[talkUser] == 2 and msgcontains(msg, "yes") then
		selfSay({"How fortunate! There are some trignometres lying around next to that device behind me. Take one and hold it next to high temperature heat sources. ...",
						"If you gathered enough data, you will actually smell it from the device. ...",
						"Return to me with the results afterwards. Best of luck, we count on you!"}, cid)
		if getPlayerStorageValue(cid, Storage.DangerousDepths.Questline) < 1 then
			setPlayerStorageValue(cid, Storage.DangerousDepths.Questline, 1)
		end
		setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Measurements, 1)
		setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.GnomeChartChest, 1) -- Permissão para usar o baú
		setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.locationCount, 0) -- Garantindo que a task não inicie com -1
		setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.locationA, 0) -- Garantindo que a task não inicie com -1
		setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.locationB, 0) -- Garantindo que a task não inicie com -1
		setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.locationC, 0) -- Garantindo que a task não inicie com -1
		setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.locationD, 0) -- Garantindo que a task não inicie com -1
		setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.locationE, 0) -- Garantindo que a task não inicie com -1
		playerTopic[cid] = 1
		talkState[talkUser] = 1
	end

	-- missão ordnance
	if msgcontains(msg, "ordnance") and talkState[talkUser] == 1 then
		if getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Ordnance) == 3 and getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.timeTaskOrdnance) > 0 then -- Ainda não se passaram as 20h
			selfSay({"I don't need your help for now. Come back later."}, cid)
			playerTopic[cid] = 1
			talkState[talkUser] = 1
		end
		if getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Ordnance) == 3 and getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.timeTaskOrdnance) <= 0 then -- Vai fazer a missão após 20h
			selfSay({"I am constantly waiting for ordnance to arrive. A lot of gnomes intend to travel out here to help us but the main access path to our base is not safe anymore. ...",
							"Tragically we lost several gnomes after an outbreak of what I can only describe as a force from below. We were completely surprised by their onslaught and retreated to this outpost. ...",
							"All our reinforcements arrive at the crystal teleporter to the east of the cave system. We need someone to navigate the new arrivals through the hazards of the dangerous caves. ...",
							"Hideous creatures and hot lava makes travelling extremely dangerous. And on top of that there is also the constant danger from falling rocks in the area. ...",
							"Are you willing to help?"}, cid)
			playerTopic[cid] = 22
			talkState[talkUser] = 22
		end
		if getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Ordnance) < 1 then -- Não possuía a missão, agora possui!
			selfSay({"I am constantly waiting for ordnance to arrive. A lot of gnomes intend to travel out here to help us but the main access path to our base is not safe anymore. ...",
							"Tragically we lost several gnomes after an outbreak of what I can only describe as a force from below. We were completely surprised by their onslaught and retreated to this outpost. ...",
							"All our reinforcements arrive at the crystal teleporter to the east of the cave system. We need someone to navigate the new arrivals through the hazards of the dangerous caves. ...",
							"Hideous creatures and hot lava makes travelling extremely dangerous. And on top of that there is also the constant danger from falling rocks in the area. ...",
							"Are you willing to help?"}, cid)
			playerTopic[cid] = 22
			talkState[talkUser] = 22
		elseif (getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Ordnance) == 1) or (getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Ordnance) == 2 and getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.GnomesCount) < 5) then -- Está na missão porém não terminou a task!
			selfSay({"Come back when you have finished your job."}, cid)
			playerTopic[cid] = 1
			talkState[talkUser] = 1
		elseif getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Ordnance) == 2 and getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.GnomesCount) >= 5 then -- Não possuía a missão, agora possui!
			if getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.CrawlersCount) >= 3 then
				selfSay({"AMAZING! Not only did you salve all our friends - you also rescued the animals! Here is your reward and bonus! ...",
								"The other are already telling stories about you. Please return to me later if you want to help out some more!"}, cid)
				setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.timeTaskOrdnance, os.time() + tempo)
				doPlayerAddItem(cid, 32014, 2)
				setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Status, getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Status) + 2)
				setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Ordnance, 3)
			else
				selfSay({"The other are already telling stories about you. Please return to me later if you want to help out some more!"}, cid)
				setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.timeTaskOrdnance, os.time() + tempo)
				doPlayerAddItem(cid, 32014, 1)
				setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Status, getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Status) + 1)
				setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Ordnance, 3)
			end
			playerTopic[cid] = 1
			talkState[talkUser] = 1
		end
	elseif talkState[talkUser] == 22 and msgcontains(msg, "yes") then
		selfSay({"Excellent, just follow the path to east until you reach a dead end, there is a hole that leads to a small cave underneath which will bring you right to the old trail. ...",
						"Help whoever you can and return them to the save cave exit - oh, and while you're at it... some of them will have pack animals. If you can rescue those as well, I'll hand you a bonus. Good luck!"}, cid)
		if getPlayerStorageValue(cid, Storage.DangerousDepths.Questline) < 1 then
			setPlayerStorageValue(cid, Storage.DangerousDepths.Questline, 1)
		end
		setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Ordnance, 1)
		setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.GnomesCount, 0) -- Garantindo que a task não inicie com -1
		setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.CrawlersCount, 0) -- Garantindo que a task não inicie com -1
		playerTopic[cid] = 1
		talkState[talkUser] = 1
	end

	-- missão charting
	if msgcontains(msg, "charting") and talkState[talkUser] == 1 then
		if getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Charting) == 2 and getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.timeTaskCharting) > 0 then -- Ainda não se passaram as 20h
			selfSay({"I don't need your help for now. Come back later."}, cid)
			playerTopic[cid] = 1
			talkState[talkUser] = 1
		end
		if getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Charting) == 2 and getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.timeTaskCharting) <= 0 then -- Vai fazer a missão após 20h
			selfSay({"While exploring these caves to find places to collect spores and grow mushrooms, we found several strange structures. I am convinced that this system was once home to intelligent beings. ...",
							"However, the creatures from below are now disturbing our research as well as some particularly pesky dwarves who just would not leave us alone. ...",
							"As we have our hands full with a lot of things right now, we could need someone to chart the unknown parts of this underground labyrinth ...",
							"I am especially interested in the scattered dark structures around these parts. Would you do that?"}, cid)
			playerTopic[cid] = 33
			talkState[talkUser] = 33
		end
		if getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Charting) < 1 then -- Não possuía a missão, agora possui!
			selfSay({"While exploring these caves to find places to collect spores and grow mushrooms, we found several strange structures. I am convinced that this system was once home to intelligent beings. ...",
							"However, the creatures from below are now disturbing our research as well as some particularly pesky dwarves who just would not leave us alone. ...",
							"As we have our hands full with a lot of things right now, we could need someone to chart the unknown parts of this underground labyrinth ...",
							"I am especially interested in the scattered dark structures around these parts. Would you do that?"}, cid)
			playerTopic[cid] = 33
			talkState[talkUser] = 33
		elseif (getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Charting) == 1) and (getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.ChartingCount) < 3) then -- Está na missão porém não terminou a task!
		selfSay({"Come back when you have finished your job."}, cid)
		playerTopic[cid] = 1
		talkState[talkUser] = 1
		end
		if getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Charting) == 1 and getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.ChartingCount) >= 3 then -- Não possuía a missão, agora possui!
			selfSay({"Thank you very much! With those structures mapped out we will be able to complete the puzzle in no time!"}, cid)
			if getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.ChartingCount) == 6 then
				doPlayerAddItem(cid, 32014, 2)
				setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Status, getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Status) + 2)
			else
				doPlayerAddItem(cid, 32014, 1)
				setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Status, getPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Status) + 1)
			end
			setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Charting, 2)
			setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.timeTaskCharting, os.time() + tempo)
			playerTopic[cid] = 1
			talkState[talkUser] = 1
		end
	elseif talkState[talkUser] == 33 and msgcontains(msg, "yes") then
		selfSay({"Very good. We prepared a lot of maps as the complete mapping of this system will probably take a lot of research. ...",
						"Take one from the stack here next to me and map as many structures as possible. However, we need at least three locations to make any sense of this ancient layout at all. ...",
						"If you manage to map one of each structure around these parts - I assume there must be at least two times as many around here - I will hand you a bonus!"}, cid)
		if getPlayerStorageValue(cid, Storage.DangerousDepths.Questline) < 1 then
			setPlayerStorageValue(cid, Storage.DangerousDepths.Questline, 1)
		end
		setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Charting, 1)
		setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.ChartingCount, 0) -- Garantindo que a task não inicie com -1
		setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.GnomeChartPaper, 1) -- Permissão para usar o papel
		setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.OldGate, 0) -- Garantindo que a task não inicie com -1
		setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.TheGaze, 0) -- Garantindo que a task não inicie com -1
		setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.LostRuin, 0) -- Garantindo que a task não inicie com -1
		setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Outpost, 0) -- Garantindo que a task não inicie com -1
		setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.Bastion, 0) -- Garantindo que a task não inicie com -1
		setPlayerStorageValue(cid, Storage.DangerousDepths.Gnomes.BrokenTower, 0) -- Garantindo que a task não inicie com -1
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
