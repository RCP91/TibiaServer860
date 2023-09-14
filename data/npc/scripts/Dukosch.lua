local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	
	-- WAGON TICKET
	if(msgcontains(msg, "ticket")) then
		if getPlayerStorageValue(cid, Storage.wagonTicket) < os.time() then
			selfSay("Do you want to purchase a weekly ticket for the ore wagons? With it you can travel freely and swiftly through Kazordoon for one week. 250 gold only. Deal?", cid)
			talkState[talkUser] = 1
		else
			selfSay("Your weekly ticket is still valid. Would be a waste of money to purchase a second one", cid)
			talkState[talkUser] = 0
		end
	elseif(msgcontains(msg, "yes")) then
		if(talkState[talkUser] == 1) then
			if getPlayerBalance(cid) + getPlayerBalance(cid) >= 250 then
				doPlayerRemoveMoney(cid, 250)
				setPlayerStorageValue(cid, Storage.wagonTicket, os.time() + 7 * 24 * 60 * 60)
				selfSay("Here is your stamp. It can't be transferred to another person and will last one week from now. You'll get notified upon using an ore wagon when it isn't valid anymore.", cid)
			else
				selfSay("You don't have enough money.", cid)
			end
			talkState[talkUser] = 0
		end
	elseif(talkState[talkUser] == 1) then
		if(msgcontains(msg, "no")) then
			selfSay("No then.", cid)
			talkState[talkUser] = 0
		end
	-- WAGON TICKET
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Welcome, |PLAYERNAME|! Do you feel adventurous? Do you want a weekly {ticket} for the ore wagon system here? You can use it right here to get to the centre of Kazordoon!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Hope to see you again.")
npcHandler:addModule(FocusModule:new())
