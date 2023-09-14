local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = { {text = 'Passage to Cormaya! Unforgettable steamboat ride!'} }
--npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, 'ticket') then
		if Player(cid):getStorageValue(Storage.wagonTicket) >= os.time() then
			selfSay('Your weekly ticket is still valid. Would be a waste of money to purchase a second one', cid)
			return true
		end

		selfSay('Do you want to purchase a weekly ticket for the ore wagons? With it you can travel freely and swiftly through Kazordoon for one week. 250 gold only. Deal?', cid)
		talkState[talkUser] = 1
	elseif msgcontains(msg, 'yes') and talkState[talkUser] > 0 then
		
		if talkState[talkUser] == 1 then
			if not doPlayerRemoveMoney(cid, 250) then
				selfSay('You don\'t have enough money.', cid)
				talkState[talkUser] = 0
				return true
			end

			setPlayerStorageValue(cid, Storage.wagonTicket, os.time() + 7 * 24 * 60 * 60)
			selfSay('Here is your stamp. It can\'t be transferred to another person and will last one week from now. You\'ll get notified upon using an ore wagon when it isn\'t valid anymore.', cid)
		end
		talkState[talkUser] = 0
	elseif msgcontains(msg, 'no') and talkState[talkUser] > 0 then
		selfSay('No then.', cid)
		talkState[talkUser] = 0
	end
	return true
end

local function addTravelKeyword(keyword, cost, discount, destination, action)
	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Do you seek a ride to ' .. keyword:titleCase() .. ' for |TRAVELCOST|?', cost = cost, discount = discount})
		travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, text = 'Full steam ahead!', cost = cost, discount = discount, destination = destination}, nil, action)
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'We would like to serve you some time.', reset = true})
end

addTravelKeyword('farmine', 210, {'postman', 'new frontier'},
	function(player)
		local destination = Position(33025, 31553, 14)
		if getPlayerStorageValue(cid, Storage.TheNewFrontier.Mission05) == 7 then --if The New Frontier Quest 'Mission 05: Getting Things Busy' complete then Stage 3
			destination.z = 10
		elseif getPlayerStorageValue(cid, Storage.TheNewFrontier.Mission03) >= 2 then --if The New Frontier Quest 'Mission 03: Strangers in the Night' complete then Stage 2
			destination.z = 12
		end

		return destination
	end
)
addTravelKeyword('cormaya', 160, 'postman', Position(33311, 31989, 15),
	function(player)
		if getPlayerStorageValue(cid, Storage.postman.Mission01) == 4 then
			setPlayerStorageValue(cid, Storage.postman.Mission01, 5)
		end
	end
)

keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = 'Do you want me take you to {Cormaya} or {Farmine}?'})

npcHandler:setMessage(MESSAGE_GREET, 'Welcome, |PLAYERNAME|! May earth protect you on the rocky grounds. If you need a {passage}, I can help you.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Good bye then.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
