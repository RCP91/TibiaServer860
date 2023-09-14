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
	
	if msgcontains(msg, "measurements") then
		if getPlayerStorageValue(cid, Storage.postman.Mission07) >= 1 and	getPlayerStorageValue(cid, Storage.postman.MeasurementsOlrik) ~= 1 then
			selfSay("My measurements? Listen, lets make that a bit more exciting ... No, no, not what you think! I mean let's gamble. I will roll a dice. If I roll a 6 you win and I'll tell you what you need to know, else I win and get 5 gold. Deal? ", cid)
			talkState[talkUser] = 1
	else
			selfSay("...", cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "yes") then
		if getPlayerBalance(cid) + getPlayerBalance(cid) >= 5 then
			doPlayerRemoveMoney(cid, 5)
			local number = math.random(6)
			if number ~= 6 then
				selfSay("Ok, here we go ... " .. number .. "! You lose! Try again.", cid)
			else
				selfSay("Ok, here we go ... " .. number .. "! You have won! How lucky you are! So listen ...<tells you what you need to know> ", cid)
				setPlayerStorageValue(cid, Storage.postman.Mission07, getPlayerStorageValue(cid, Storage.postman.Mission07) + 1)
				setPlayerStorageValue(cid, Storage.postman.MeasurementsOlrik, 1)
				talkState[talkUser] = 0
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Hello. How may I help you |PLAYERNAME|? Ask me for a {trade} if you want to buy something. I can also explain the {mail} system.")
npcHandler:setMessage(MESSAGE_FAREWELL, "It was a pleasure to help you, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Here. Don't forget that you need to buy a label too if you want to send a parcel. Always write the name of the {receiver} in the first line.")
npcHandler:addModule(FocusModule:new())
