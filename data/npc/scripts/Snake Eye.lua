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
	
	if msgcontains(msg, 'package for rashid') then
		if getPlayerStorageValue(cid, Storage.TravellingTrader.Mission02) >= 1 and getPlayerStorageValue(cid, Storage.TravellingTrader.Mission02) < 3 then
			selfSay('So you\'re the delivery boy? Go ahead, but I warn you, it\'s quite heavy. You can take it from the box over there.', cid)
			setPlayerStorageValue(cid, Storage.TravellingTrader.Mission02, 3)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, 'documents') then
		if getPlayerStorageValue(cid, Storage.thievesGuild.Mission04) == 1 then
			setPlayerStorageValue(cid, Storage.thievesGuild.Mission04, 2)
			selfSay('Funny thing that everyone thinks we have forgers for fake documents here. But no, we don\'t. The best forger is old Ahmet in Ankrahmun.', cid)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
