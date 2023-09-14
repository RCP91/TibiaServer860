local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	if msgcontains(msg, "heavy ball") then
		selfSay("Do you want to buy a heavy ball for 123 gold?", cid)
		talkState[talkUser] = 1
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			
			if getPlayerBalance(cid) + getPlayerBalance(cid) >= 123 then
				selfSay("Here it is.", cid)
				doPlayerAddItem(cid, 11257, 1)
				doPlayerRemoveMoney(cid, 123)
			else
				selfSay("You don't have enough money.", cid)
			end
			talkState[talkUser] = 0
		end
	end
	return true
end

-- Travel
local function addTravelKeyword(keyword, text, cost, destination)
	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Do you want to sail ' .. text, cost = cost})
		travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, cost = cost, destination = destination})
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'We would like to serve you some time.', reset = true})
end

addTravelKeyword('tibia', 'back to Tibia?', 0, Position(32235, 31674, 7))
addTravelKeyword('senja', 'Senja for |TRAVELCOST|?', 10, Position(32128, 31664, 7))
addTravelKeyword('vega', 'Vega for |TRAVELCOST|?', 10, Position(32020, 31692, 7))

-- Basic
keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = 'Where do you want to go? To {Tibia}, {Senja} or {Vega}?'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I am the captain of this ship.'})
keywordHandler:addKeyword({'captain'}, StdModule.say, {npcHandler = npcHandler, text = 'I am the captain of this ship.'})

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
