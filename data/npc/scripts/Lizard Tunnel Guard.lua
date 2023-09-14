local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function greetCallback(cid)
	
	if getPlayerStorageValue(cid, Storage.WrathoftheEmperor.Questline) >= 2 then
		setPlayerStorageValue(cid, Storage.WrathoftheEmperor.GuardcaughtYou, 1)
		setPlayerStorageValue(cid, Storage.WrathoftheEmperor.CrateStatus, 0)
		player:teleportTo(Position(33361, 31206, 8))
		player:say("The guards have spotted you. You were forcibly dragged into a small cell. It looks like you need to build another disguise.", TALKTYPE_MONSTER_SAY)
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:addModule(FocusModule:new())
