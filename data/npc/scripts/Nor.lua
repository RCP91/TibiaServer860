local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	if msgcontains(msg, "crystal") then
		if getPlayerStorageValue(cid, Storage.TheIceIslands.Mission08) == 2 then
			selfSay("Here, take the memory crystal and leave immediately.", cid)
			talkState[talkUser] = 0
			doPlayerAddItem(cid, 7281, 1)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Mission08, 3) -- Questlog The Ice Islands Quest, The Contact
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
