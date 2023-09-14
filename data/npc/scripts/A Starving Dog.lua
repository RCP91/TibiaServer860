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
	
	if msgcontains(msg, "sniffler") then
		if getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 1 then
			selfSay("!", cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, "meat") then
		if talkState[talkUser] == 1 then
			if doPlayerRemoveItem(cid, 2666, 1) then
				selfSay("<munch>", cid)
				setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 2)
				setPlayerStorageValue(cid, Storage.TheIceIslands.Mission01, 2) -- Questlog The Ice Islands Quest, Befriending the Musher
				talkState[talkUser] = 0
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
