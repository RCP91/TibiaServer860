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
	
	if msgcontains(msg, "sam sent me") or msgcontains(msg, "sam send me") then
		if getPlayerStorageValue(cid, Storage.SamsOldBackpack) == 1 then
			selfSay({
				"Oh, so its you, he wrote me about? Sadly I have no dwarven armor in stock. But I give you the permission to retrive one from the mines. ...",
				"The problem is, some giant spiders made the tunnels where the storage is their new home. Good luck."
			}, cid)
			setPlayerStorageValue(cid, Storage.SamsOldBackpack, 2)
		end
	elseif msgcontains(msg, "measurements") then
		if getPlayerStorageValue(cid, Storage.postman.Mission07) >= 1 and	getPlayerStorageValue(cid, Storage.postman.MeasurementsKroox) ~= 1 then
			selfSay("Hm, well I guess its ok to tell you ... <tells you about Lokurs measurements> ", cid)
			setPlayerStorageValue(cid, Storage.postman.Mission07, getPlayerStorageValue(cid, Storage.postman.Mission07) + 1)
			setPlayerStorageValue(cid, Storage.postman.MeasurementsKroox, 1)
	else
			selfSay("...", cid)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
