local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

keywordHandler:addKeyword({'magic'}, StdModule.say, {npcHandler = npcHandler, text = "Okay, then just browse through all of my wares."})

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	
	local items = {[1] = 2190, [2] = 2182}
	local itemId = items[player:getVocation():getBase():getId()]
	if msgcontains(msg, 'first rod') or msgcontains(msg, 'first wand') then
		if player:isMage() then
			if getPlayerStorageValue(cid, Storage.firstMageWeapon) == -1 then
				selfSay('So you ask me for a {' .. ItemType(itemId):getName() .. '} to begin your adventure?', cid)
				talkState[talkUser] = 1
			else
				selfSay('What? I have already gave you one {' .. ItemType(itemId):getName() .. '}!', cid)
			end
		else
			selfSay('Sorry, you aren\'t a druid either a sorcerer.', cid)
		end
	elseif msgcontains(msg, 'yes') then
		if talkState[talkUser] == 1 then
			doPlayerAddItem(cid, itemId, 1)
			selfSay('Here you are young adept, take care yourself.', cid)
			setPlayerStorageValue(cid, Storage.firstMageWeapon, 1)
		end
		talkState[talkUser] = 0
	elseif msgcontains(msg, 'no') and talkState[talkUser] == 1 then
		selfSay('Ok then.', cid)
		talkState[talkUser] = 0
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Welcome |PLAYERNAME|! Whats your need?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Of course, just browse through my wares. Or do you want to look only at {potions}, {wands} or {runes}?")
npcHandler:addModule(FocusModule:new())
