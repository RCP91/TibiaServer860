
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

	
	if msgcontains(msg, "offer") then
		if getPlayerStorageValue(cid, Storage.TheNewFrontier.Questline) == 23 then
		selfSay("You are ztill a captive and your life is forfeit. Zere might be a way for you to ezcape if you agree to {work} for my mazter.", cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, "work") then
		if talkState[talkUser] == 1 then
			selfSay({
				"Zere iz a great tournament of ztrengz each decade. It determinez ze granted privilegez for zertain individualz of power for ze comming decade. ...",
				"My mazter wantz to zurprize hiz opponentz by an unexpected move. He will uze warriorz from ze outzide, zomeone zat no one can azzezz. ...",
				"One of ziz warriorz could be you. Or you could ztay here and rot in ze dungeon. Are you interezted in ziz deal?"
			}, cid)
			talkState[talkUser] = 2
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 2 then
			selfSay({
				"You are zmart for a zoftzkin, but before you begin to feel too zmart, you should know zat we will zeal our deal wiz you drinking a ztrong poizon zat will inevitably kill you if you want to trick me and not attend ze tournament. ...",
				"Zo are you ready to drink ziz poizon here?"
			}, cid)
			talkState[talkUser] = 3
		elseif talkState[talkUser] == 3 then
			selfSay({
				"Excellent! Now you may leave ziz area zrough ze teleporter to ze norz. It will bring you to a hidden boat. Ziz boat will take you to ze tournament izle. ...",
				"Zere you'll learn anyzing you need to know about ze great tournament."
			}, cid)
			setPlayerStorageValue(cid, Storage.TheNewFrontier.Questline, 24)
			setPlayerStorageValue(cid, Storage.TheNewFrontier.Mission07, 3) --Questlog, The New Frontier Quest "Mission 07: Messengers Of Peace"
			setPlayerStorageValue(cid, Storage.TheNewFrontier.Mission08, 1) --Questlog, The New Frontier Quest "Mission 08: An Offer You Can't Refuse"
			talkState[talkUser] = 0
		end
	end
	return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
