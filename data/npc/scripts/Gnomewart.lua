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

	
	if msgcontains(msg, "endurance") then
		if getPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine) == 15 then
			selfSay({
				"Ah, the test is a piece of mushroomcake! Just take the teleporter over there in the south and follow the hallway. ...",
				"You'll need to run quite a bit. It is important that you don't give up! Just keep running and running and running and ... I guess you got the idea. ...",
				"At the end of the hallway you'll find a teleporter. Step on it and you are done! I'm sure you'll do a true gnomerun! Afterwards talk to me."
			}, cid)
			setPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine, 17)
		elseif getPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine) == 17 then
			selfSay("Just take the teleporter over there to the south and follow the hallway. At the end of the hallway you'll find a teleporter. Step on it and you are done!", cid)
		elseif getPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine) == 18 then
			selfSay("You have passed the test and are ready to create your soul melody. Talk to Gnomelvis in the east about it.", cid)
			setPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine, 19)
		elseif getPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine) < 15 then
			selfSay("Your endurance will be tested here when the time comes. For the moment please continue with the other phases of your recruitment.", cid)
		elseif getPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine) >= 19 then
			selfSay("You have passed the test. If you consider what huge feet you have to move it's quite impressive.", cid)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
