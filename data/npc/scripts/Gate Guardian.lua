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
	
	if msgcontains(msg, "mission") or msgcontains(msg, "pass") then
		if getPlayerStorageValue(cid, Storage.WrathoftheEmperor.Questline) == 13 then
			selfSay("You want entranzzze to zzze zzzity?", cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			selfSay("Mh, zzzezzze paperzzz zzzeem legit, I have orderzzz to let you pazzz. Zzzo be it.", cid)
			setPlayerStorageValue(cid, Storage.WrathoftheEmperor.Questline, 22)
			setPlayerStorageValue(cid, Storage.WrathoftheEmperor.Mission05, 2) --Questlog, Wrath of the Emperor "Mission 05: New in Town"
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:teleportTo(Position(33114, 31197, 7), false)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
