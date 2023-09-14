local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

-- transcript for buying fresh mushroom beer is probably wrong except for the case where you buy it
local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	
	if msgcontains(msg, 'recruitment') then
		if getPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine) == 3 then
			selfSay('Your examination is quite easy. Just step through the green crystal apparatus in the south! We will examine you with what we call g-rays. Where g stands for gnome of course ...', cid)
			selfSay('Afterwards walk up to Gnomedix for your ear examination.', cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, 'tavern') then
			selfSay('I provide the population with some fresh alcohol-free mushroom {beer}!', cid)
	elseif msgcontains(msg, 'beer') then
			selfSay('Do you want some mushroom beer for 10 gold?', cid)
			talkState[talkUser] = 2
	elseif talkState[talkUser] == 1 then
		if msgcontains(msg, 'apparatus') then
			selfSay('Don\'t be afraid. It won\'t hurt! Just step in!', cid)
			setPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine, 4)
			talkState[talkUser] = 0
		end
	elseif talkState[talkUser] == 2 then
		if msgcontains(msg, 'yes') then
			if getPlayerBalance(cid) + getPlayerBalance(cid) >= 10 then
				selfSay('And here it is! Drink it quick, it gets stale quite fast!', cid)
				doPlayerRemoveMoney(cid, 10)
				local beerItem = doPlayerAddItem(cid, 18305)
				if beerItem then
					beerItem:decay()
				end
			else
				selfSay('You do not have enough money.', cid)
			end
		else
			selfSay('Come back later.', cid)
		end
		talkState[talkUser] = 0
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, 'Hi there! Welcome to my little {tavern}.')
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
