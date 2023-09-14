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

	

	if msgcontains(msg, "chocolate cake") then
		if getPlayerStorageValue(cid, Storage.hiddenCityOfBeregar.SweetAsChocolateCake) == 1 and getPlayerItemCount(cid, 8847) >= 1 then
			selfSay("Is that for me?", cid)
			talkState[talkUser] = 1
		elseif getPlayerStorageValue(cid, Storage.hiddenCityOfBeregar.SweetAsChocolateCake) == 2 then
			selfSay("So did you tell her that the cake came from me?", cid)
			talkState[talkUser] = 2
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			if doPlayerRemoveItem(cid, 8847, 1) then
				selfSay("Err, thanks. I doubt it's from you. Who sent it?", cid)
				talkState[talkUser] = 2
				setPlayerStorageValue(cid, Storage.hiddenCityOfBeregar.SweetAsChocolateCake, 2)
			else
				selfSay("Oh, I thought you have one.", cid)
				talkState[talkUser] = 0
			end
		end
	elseif talkState[talkUser] == 2 then
		if msgcontains(msg, "Frafnar") then
			selfSay("Oh, Frafnar. That's so nice of him. I gotta invite him for a beer.", cid)
			talkState[talkUser] = 0
		else
			selfSay("Never heard that name. Well, I don't mind, thanks for the cake.", cid)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "See you my friend.")
npcHandler:setMessage(MESSAGE_FAREWELL, "See you my friend.")
npcHandler:setMessage(MESSAGE_GREET, "Are you talking to me? Well, go on chatting but don't expect an answer.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
