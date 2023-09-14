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
	
	if msgcontains(msg, "mission") then
		if getPlayerStorageValue(cid, Storage.WrathoftheEmperor.Questline) == 10 then
			if player:getPosition().z == 12 and getPlayerStorageValue(cid, Storage.WrathoftheEmperor.GhostOfAPriest01) < 1 and talkState[talkUser] ~= 1 then
				selfSay({
					"Although we are willing to hand this item to you, there is something you have to understand: There is no such thing as 'the' sceptre. ...",
					"Those sceptres are created for special purposes each time anew. Therefore you will have to create one on your own. It will be your {mission} to find us three keepers and to get the three parts of the holy sceptre. ...",
					"Then go to the holy altar and create a new one."
				}, cid)
				talkState[talkUser] = 1
			elseif talkState[talkUser] == 1 then
				selfSay({
					"Even though we are spirits, we can't create anything out of thin air. You will have to donate some precious metal which we can drain for energy and substance. ...",
					"The equivalent of 5000 gold will do. Are you willing to make such a donation?"
				}, cid)
				talkState[talkUser] = 2
			elseif player:getPosition().z == 13 and getPlayerStorageValue(cid, Storage.WrathoftheEmperor.GhostOfAPriest02) < 1 then
				selfSay({
					"Even though we are spirits, we can't create anything out of thin air. You will have to donate some precious metal which we can drain for energy and substance. ...",
					"The equivalent of 5000 gold will do. Are you willing to make such a donation?"
				}, cid)
				talkState[talkUser] = 3
			elseif player:getPosition().z == 14 and getPlayerStorageValue(cid, Storage.WrathoftheEmperor.GhostOfAPriest03) < 1 then
				selfSay({
					"Even though we are spirits, we can't create anything out of thin air. You will have to donate some precious metal which we can drain for energy and substance. ...",
					"The equivalent of 5000 gold will do. Are you willing to make such a donation?"
				}, cid)
				talkState[talkUser] = 4
			end
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 2 then
			if getPlayerBalance(cid) + getPlayerBalance(cid) >= 5000 then
				setPlayerStorageValue(cid, Storage.WrathoftheEmperor.GhostOfAPriest01, 1)
				doPlayerRemoveMoney(cid, 5000)
				doPlayerAddItem(cid, 12324, 1)
				selfSay("So be it! Here is my part of the sceptre. Combine it with the other parts on the altar of the Great Snake in the depths of this temple.", cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 3 then
			if getPlayerBalance(cid) + getPlayerBalance(cid) >= 5000 then
				setPlayerStorageValue(cid, Storage.WrathoftheEmperor.GhostOfAPriest02, 1)
				doPlayerRemoveMoney(cid, 5000)
				doPlayerAddItem(cid, 12325, 1)
				selfSay("So be it! Here is my part of the sceptre. Combine it with the other parts on the altar of the Great Snake in the depths of this temple.", cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 4 then
			if getPlayerBalance(cid) + getPlayerBalance(cid) >= 5000 then
				setPlayerStorageValue(cid, Storage.WrathoftheEmperor.GhostOfAPriest03, 1)
				doPlayerRemoveMoney(cid, 5000)
				doPlayerAddItem(cid, 12326, 1)
				selfSay("So be it! Here is my part of the sceptre. Combine it with the other parts on the altar of the Great Snake in the depths of this temple.", cid)
				talkState[talkUser] = 0
			end
		end
	elseif msgcontains(msg, "no") and talkState[talkUser] then
		selfSay("No deal then.", cid)
		talkState[talkUser] = 0
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
