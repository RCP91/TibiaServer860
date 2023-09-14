local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{ text = 'Now where did I put that form?' },
	{ text = 'Hail Pumin. Yes, hail.' }
}

--npcHandler:addModule(VoiceModule:new(voices))

local config = {
	[1] = "S O R C E R E R",
	[2] = "D R U I D",
	[3] = "P A L A D I N",
	[4] = "K N I G H T"
}

local function greetCallback(cid)
	npcHandler:setMessage(MESSAGE_GREET, "Hello " .. (Player(cid):getSex() == PLAYERSEX_FEMALE and "beautiful lady" or "handsome gentleman") .. ", welcome to the atrium of Pumin's Domain. We require some information from you before we can let you pass. Where do you want to go?")
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	local vocationId = player:getVocation():getBase():getId()

	if msgcontains(msg, "pumin") then
		if getPlayerStorageValue(cid, Storage.PitsOfInferno.ThronePumin) == 1 then
			selfSay("I'm not sure if you know what you are doing but anyway. Your name is?", cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, player:getName()) then
		if talkState[talkUser] == 1 then
			selfSay("Alright |PLAYERNAME|. Vocation?", cid)
			talkState[talkUser] = 2
		end
	elseif msgcontains(msg, Vocation(vocationId):getName()) then
		if talkState[talkUser] == 2 then
			selfSay(config[vocationId] .. ", is that right?! What do you want from me?", cid)
			talkState[talkUser] = 3
		end
	elseif msgcontains(msg, "356") then
		if talkState[talkUser] == 3 then
			setPlayerStorageValue(cid, Storage.PitsOfInferno.ThronePumin, 2)
			selfSay("Sorry, you need Form 145 to get Form 356. Come back when you have it", cid)
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.PitsOfInferno.ThronePumin) == 7 then
			setPlayerStorageValue(cid, Storage.PitsOfInferno.ThronePumin, 8)
			selfSay("You are better than I thought! Congratulations, here you are: Form 356!", cid)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye and don't forget me!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye and don't forget me!")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
