local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{ text = "<mumbles> So where was I again?" },
	{ text = "<mumbles> Typical - you can never find a hero when you need one!" },
	{ text = "<mumbles> Could the bonelord language be the invention of some madman?" },
	{ text = "<mumbles> The curse algorithm of triplex shadowing has to be two times higher than an overcharged nanoquorx on the peripheral..." }
}

--npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	if msgcontains(msg, "mission") then
		if getPlayerStorageValue(cid, Storage.TheWayToYalahar.QuestLine) < 1 and getPlayerStorageValue(cid, Storage.ExplorerSociety.JoiningtheExplorers) >= 4 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) >= 4 then
			selfSay({
				"There is indeed something that needs our attention. In the far north, a new city named Yalahar was discovered. It seems to be incredibly huge. ...",
				"According to travelers, it's a city of glory and wonders. We need to learn as much as we can about this city and its inhabitants. ...",
				"Gladly the explorer's society already sent a representative there. Still, we need someone to bring us the information he was able to gather until now. ...",
				"Please look for the explorer's society's captain Maximilian in Liberty Bay. Ask him for a passage to Yalahar. There visit Timothy of the explorer's society and get his research notes. ...",
				"It might be a good idea to explore the city a bit on your own before you deliver the notes here, but please make sure you don't lose them."
			}, cid)
			setPlayerStorageValue(cid, Storage.TheWayToYalahar.QuestLine, 1)
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.TheWayToYalahar.QuestLine) == 2 then
			selfSay("Did you bring the papers I asked you for?", cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			if doPlayerRemoveItem(cid, 10090, 1) then
				setPlayerStorageValue(cid, Storage.TheWayToYalahar.QuestLine, 3)
				selfSay("Oh marvellous, please excuse me. I need to read this text immediately. Here, take this small reward of 500 gold pieces for your efforts.", cid)
				player:addMoney(500)
				talkState[talkUser] = 0
			end
		end
	--The New Frontier
	elseif msgcontains(msg, "farmine") then
		if getPlayerStorageValue(cid, Storage.TheNewFrontier.Questline) == 15 then
			selfSay("I've heard some odd rumours about this new dwarven outpost. But tell me, what has the Edron academy to do with Farmine?", cid)
			talkState[talkUser] = 2
		end
	elseif msgcontains(msg, "plea") then
		if talkState[talkUser] == 2 then
			if getPlayerStorageValue(cid, Storage.TheNewFrontier.BribeWydrin) < 1 then
				selfSay("Hm, you are right, we are at the forefront of knowledge and innovation. Our dwarven friends could learn much from one of our representatives.", cid)
				setPlayerStorageValue(cid, Storage.TheNewFrontier.BribeWydrin, 1)
				setPlayerStorageValue(cid, Storage.TheNewFrontier.Mission05, getPlayerStorageValue(cid, Storage.TheNewFrontier.Mission05) + 1) --Questlog, The New Frontier Quest "Mission 05: Getting Things Busy"
			end
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hello, what brings you here?")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
