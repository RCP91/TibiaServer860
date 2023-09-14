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
	
	if isInArray({"soft boots", "repair", "soft", "boots"}, msg) then
		selfSay("Do you want to repair your worn soft boots for 10000 gold coins?", cid)
		talkState[talkUser] = 1
	elseif msgcontains(msg, 'yes') and talkState[talkUser] == 1 then
		talkState[talkUser] = 0
		if getPlayerItemCount(cid, 10021) == 0 then
			selfSay("Sorry, you don't have the item.", cid)
			return true
		end

		if not doPlayerRemoveMoney(cid, 10000) then
			selfSay("Sorry, you don't have enough gold.", cid)
			return true
		end

		doPlayerRemoveItem(cid, 10021, 1)
		doPlayerAddItem(cid, 6132, 1)
		selfSay("Here you are.", cid)
	elseif msgcontains(msg, 'no') and talkState[talkUser] == 1 then
		talkState[talkUser] = 0
		selfSay("Ok then.", cid)


	end

	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
