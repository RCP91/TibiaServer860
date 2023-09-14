local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local function greetCallback(cid)
	
	if getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) < 37 then
		selfSay("Uhhhh...", cid)
		return false
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "story") then
		
		if getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 37 then
			selfSay({
				"I was captured and tortured to death by the cultists here. They worship a being that they call Ghazbaran ...",
				"In his name they have claimed the mines and started to melt the ice to free an army of vile demons that have been frozen here for ages ...",
				"Their plan is to create a new demon army for their master to conquer the world. Hjaern and the other shamans must learn about it! Hurry before its too late."
			}, cid)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 38)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Mission10, 2) -- Questlog The Ice Islands Quest, Formorgar Mines 2: Ghostwhisperer
			setPlayerStorageValue(cid, Storage.TheIceIslands.Mission11, 1) -- Questlog The Ice Islands Quest, Formorgar Mines 3: The Secret
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
