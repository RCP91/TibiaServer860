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
	if msgcontains(msg, "monument tower") or msgcontains(msg, "passage") or msgcontains(msg, "trip") then
		selfSay("Do you want to travel to the {monument tower} for a 50 gold fee?", cid)
		talkState[talkUser] = 1
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			
			if getPlayerBalance(cid) + getPlayerBalance(cid) >= 50 then
				doPlayerRemoveMoney(cid, 50)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				player:teleportTo(Position(32940, 31182, 7), false)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				talkState[talkUser] = 0

			elseif getPlayerBalance(cid) >= 50 then
				getBankMoney(cid, 50)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				player:teleportTo(Position(32940, 31182, 7), false)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				talkState[talkUser] = 0
			else
				selfSay("You don't have enought money.", cid)
				talkState[talkUser] = 0
			end
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Can I interest you in a trip to the {monument tower}?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
