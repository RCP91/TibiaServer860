
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
	end

	
	if(msgcontains(msg, "farmine")) then
		if(getPlayerStorageValue(cid, Storage.TheNewFrontier.Questline) == 15) then
			selfSay("Bah, Farmine here, Farmine there. Is there nothing else than Farmine to talk about these days? Hrmpf, whatever. So what do you want?", cid)
			talkState[talkUser] = 1
		end
	elseif(msgcontains(msg, "flatter")) then
		if(talkState[talkUser] == 1) then
			if(getPlayerStorageValue(cid, Storage.TheNewFrontier.BribeHumgolf) < 1) then
				selfSay("Yeah, of course they can't do without my worms. Mining and worms go hand in hand. Well, in the case of the worms it is only an imaginary hand of course. I'll send them some of my finest worms.", cid)
				setPlayerStorageValue(cid, Storage.TheNewFrontier.BribeHumgolf, 1)
				setPlayerStorageValue(cid, Storage.TheNewFrontier.Mission05, getPlayerStorageValue(cid, Storage.TheNewFrontier.Mission05) + 1) --Questlog, The New Frontier Quest "Mission 05: Getting Things Busy"
			end
		end
	end
	return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
