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
	elseif isInArray({"trip", "passage", "back"}, msg) then
		--if Player(cid):getStorageValue(Storage.TheNewFrontier.Questline) >= 24 then
			selfSay("You want to go back?", cid)
			talkState[talkUser] = 1
		--end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			selfSay("It'zz your doom you travel to.", cid)
			local player, destination = Player(cid), Position(33158, 31228, 7)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:teleportTo(destination)
			destination:sendMagicEffect(CONST_ME_TELEPORT)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "no") then
		if talkState[talkUser] == 1 then
			selfSay("Zzoftzzkinzz zzo full of fear.", cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, 'hurry') or msgcontains(msg, 'job')  then
		selfSay('Me zzimple ferryman. I arrange {trip} to Zao.', cid)
		talkState[talkUser] = 0
	end
	return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
