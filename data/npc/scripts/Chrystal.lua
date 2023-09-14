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
		if getPlayerStorageValue(cid, Storage.postman.Mission07) >= 1 and	getPlayerStorageValue(cid, Storage.postman.MeasurementsChrystal) ~= 1 then
			selfSay("If its necessary ... <tells you her measurements>", cid)
			setPlayerStorageValue(cid, Storage.postman.Mission07, getPlayerStorageValue(cid, Storage.postman.Mission07) + 1)
			setPlayerStorageValue(cid, Storage.postman.MeasurementsChrystal, 1)
			talkState[talkUser] = 0
	else
			selfSay("...", cid)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "At your service |PLAYERNAME| and welcome to the post office.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Who is next?")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Who is next?")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Here. Don't forget that you need to buy a label too if you want to send a parcel. Always write the name of the {receiver} in the first line.")
npcHandler:addModule(FocusModule:new())
