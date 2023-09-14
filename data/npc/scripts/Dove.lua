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
		if getPlayerStorageValue(cid, Storage.postman.Mission07) >= 1 and	getPlayerStorageValue(cid, Storage.postman.MeasurementsDove) ~= 1 then
			selfSay("Oh no! I knew that day would come! I am slightly above the allowed weight and if you can't supply me with some grapes to slim down I will get fired. Do you happen to have some grapes with you? ", cid)
			talkState[talkUser] = 1
	else
			selfSay("...", cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			if doPlayerRemoveItem(cid, 2681, 1) then
				selfSay("Oh thank you! Thank you so much! So listen ... <whispers her measurements> ", cid)
				setPlayerStorageValue(cid, Storage.postman.Mission07, getPlayerStorageValue(cid, Storage.postman.Mission07) + 1)
				setPlayerStorageValue(cid, Storage.postman.MeasurementsDove, 1)
				talkState[talkUser] = 0
	else
			selfSay("Oh, you don\'t have it.", cid)
			talkState[talkUser] = 0
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
