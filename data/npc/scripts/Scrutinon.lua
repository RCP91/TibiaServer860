local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = { {text = 'Passages to Thais, Carlin, Ab\'Dendriel, Krailos, Port Hope, Edron, Darashia, Liberty Bay, Svargrond, Gray Island, Yalahar and Ankrahmun.'} }
npcHandler:addModule(VoiceModule:new(voices))

-- Travel
local function addTravelKeyword(keyword, cost, destination, condition)
	if condition then
		keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m sorry but I don\'t sail there.'}, condition)
	end

	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Do you seek a passage to ' .. keyword:titleCase() .. ' for |TRAVELCOST|?', cost = cost, discount = 'postman'})
		travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, cost = cost, discount = 'postman', destination = destination})
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'We would like to serve you some time.', reset = true})
end

addTravelKeyword('thais', 170, Position(32310, 32210, 6))
addTravelKeyword('carlin', 130, Position(32387, 31820, 6))
addTravelKeyword('ab\'dendriel', 90, Position(32734, 31668, 6))
addTravelKeyword('edron', 40, Position(33173, 31764, 6))
addTravelKeyword('venore', 150, Position(32954, 32022, 6))
addTravelKeyword('port hope', 160, Position(32527, 32784, 6))
addTravelKeyword('svargrond', 150, Position(32341, 31108, 6))
addTravelKeyword('liberty bay', 180, Position(32285, 32892, 6))
addTravelKeyword('yalahar', 185, Position(32816, 31272, 6), function(player) return player:getStorageValue(Storage.SearoutesAroundYalahar.Venore) ~= 1 and player:getStorageValue(Storage.SearoutesAroundYalahar.TownsCounter) < 5 end)
addTravelKeyword('ankrahmun', 150, Position(33092, 32883, 6))

local function addTravelKeyword(keyword, cost, destination, condition)
	if condition then
		keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m sorry but I don\'t sail there.'}, condition)
	end

	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Do you seek a passage to ' .. keyword:titleCase() .. ' for |TRAVELCOST|?', cost = cost, discount = 'postman'})
		travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = true, cost = cost, discount = 'postman', destination = destination})
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'We would like to serve you some time.', reset = true})
end
addTravelKeyword('krailos', 185, Position(33493, 31712, 6)) -- {x = 33493, y = 31712, z = 6}
addTravelKeyword('issavi', 130, Position(33901, 31462, 6))
addTravelKeyword('travora', 1000, Position(32055, 32368, 6))
addTravelKeyword('roshamuul', 210, Position(33494, 32567, 7))
addTravelKeyword('oramond', 150, Position(33479, 31985, 7))

-- Darashia
local travelNode = keywordHandler:addKeyword({'darashia'}, StdModule.say, {npcHandler = npcHandler, text = 'Do you seek a passage to Darashia for |TRAVELCOST|?', cost = 60, discount = 'postman'})
	local childTravelNode = travelNode:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'I warn you! This route is haunted by a ghostship. Do you really want to go there?'})
		childTravelNode:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, cost = 60, discount = 'postman', destination = function(player) return math.random(10) == 1 and Position(33324, 32173, 6) or Position(33289, 32481, 6) end})
		childTravelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, reset = true, text = 'We would like to serve you some time.'})
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, reset = true, text = 'We would like to serve you some time.'})

-- Kick
keywordHandler:addKeyword({'kick'}, StdModule.kick, {npcHandler = npcHandler, destination = {Position(32952, 32031, 6), Position(32955, 32031, 6), Position(32957, 32032, 6)}})

-- Basic
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler,
	text = {
		"My name is Scrutinon. However, there are not many people calling my name nowadays. Not many captains even dare to land on this island. It is too close to {Quirefang}. ...",
		"Most of them do not know this island by that name. Some call it Demon Horn, others the Dragon's Tooth or the Gray Beach as none of them ever came closer than a fair distance. ...",
		"There are drifts and storms surrounding that place that are far too dangerous to navigate through even for the most versed captains. They often sail not closer than to this island here and drop off whoever dares to explore near this dreaded coast."
	}}
)
keywordHandler:addKeyword({'quirefang'}, StdModule.say, {npcHandler = npcHandler,
	text = {
		"This island is cleft. Go there only prepared or you will meet your end. The surface of this forgotten rock is a barren wasteland full of hostile creatures. ...",
		"Its visage is covered with holes and tunnels in which its leggy inhabitants are hiding. Its bowels filled with the strangest creatures, waiting to feast on whatever dares to disturb their hive. ...",
		"And you will find no shelter in Quirefang's black depths, where the creatures of the deep are fulfilling a dark prophecy. ...",
		"It is impossible to reach it by ship or boat. However, there was one before you. A {visitor} who found a way to enter the island."
	}}
)

-- Basic
keywordHandler:addKeyword({'sail'}, StdModule.say, {npcHandler = npcHandler, text = 'Where do you want to go? To {Thais}, {Carlin}, {Ab\'Dendriel}, {Port Hope}, {Edron}, {Venore}, {Darashia}, {Liberty Bay}, {Svargrond}, {Yalahar}, or {Ankrahmun}, citys premium account {Krailos}, {Roshamuul}, {Issavi}, {Oramond}?'})
keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = 'Where do you want to go? To {Thais}, {Carlin}, {Ab\'Dendriel}, {Port Hope}, {Edron}, {Venore}, {Darashia}, {Liberty Bay}, {Svargrond}, {Yalahar}, or {Ankrahmun}, citys premium account {Krailos}, {Roshamuul}, {Issavi}, {Oramond}?'})
keywordHandler:addKeyword({'travel'}, StdModule.say, {npcHandler = npcHandler, text = 'Where do you want to go? To {Thais}, {Carlin}, {Ab\'Dendriel}, {Port Hope}, {Edron}, Venore}, {Darashia}, {Liberty Bay}, {Svargrond}, {Yalahar}, or {Ankrahmun}, citys premium account {Krailos}, {Roshamuul}, {Issavi}, {Oramond}?'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I am the captain of this ship.'})
keywordHandler:addKeyword({'captain'}, StdModule.say, {npcHandler = npcHandler, text = 'I am the captain of this ship.'})
keywordHandler:addKeyword({'venore'}, StdModule.say, {npcHandler = npcHandler, text = 'This is Venore. Where do you want to go?'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'My name is Captain Fearless from the Royal Tibia Line.'})

npcHandler:setMessage(MESSAGE_GREET, 'Welcome on board, |PLAYERNAME|. Where can I {sail} you today?')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye. Recommend us if you were satisfied with our service.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Good bye then.')

npcHandler:addModule(FocusModule:new())
