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
	[1] = "wand",
	[2] = "rod",
	[3] = "bow",
	[4] = "sword"
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
		if talkState[talkUser] == 0 and getPlayerStorageValue(cid, Storage.PitsOfInferno.ThronePumin) < 1 then
			selfSay("Sure, where else. Everyone likes to meet my master, he is a great demon, isn't he? Your name is ...?", cid)
			talkState[talkUser] = 1
		elseif talkState[talkUser] == 3 then
			setPlayerStorageValue(cid, Storage.PitsOfInferno.ThronePumin, 1)
			selfSay("How very interesting. I need to tell that to my master immediately. Please go to my colleagues and ask for Form 356. You will need it in order to proceed.", cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, player:getName()) then
		if talkState[talkUser] == 1 then
			selfSay("Alright |PLAYERNAME|. Vocation?", cid)
			talkState[talkUser] = 2
		end
	elseif msgcontains(msg, Vocation(vocationId):getName()) then
		if talkState[talkUser] == 2 then
			selfSay("Huhu, please don't hurt me with your " .. config[vocationId] .. "! Reason of your visit?", cid)
			talkState[talkUser] = 3
		end
	elseif msgcontains(msg, "411") then
		if getPlayerStorageValue(cid, Storage.PitsOfInferno.ThronePumin) == 3 then
			selfSay("Form 411? You need Form 287 to get that! Do you have it?", cid)
			talkState[talkUser] = 4
		elseif getPlayerStorageValue(cid, Storage.PitsOfInferno.ThronePumin) == 5 then
			selfSay("Form 411? You need Form 287 to get that! Do you have it?", cid)
			talkState[talkUser] = 5
		end
	elseif msgcontains(msg, "no") then
		if talkState[talkUser] == 4 then
			setPlayerStorageValue(cid, Storage.PitsOfInferno.ThronePumin, 4)
			selfSay("Oh, what a pity. Go see one of my colleagues. I give you the permission to get Form 287. Bye!", cid)
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 5 then
			setPlayerStorageValue(cid, Storage.PitsOfInferno.ThronePumin, 6)
			selfSay("Great. Here you are. Form 411. Come back anytime you want to talk. Bye.", cid)
		end
	elseif msgcontains(msg, "356") then
		if getPlayerStorageValue(cid, Storage.PitsOfInferno.ThronePumin) == 8 then
			setPlayerStorageValue(cid, Storage.PitsOfInferno.ThronePumin, 9)
			selfSay("INCREDIBLE, you did it!! Have fun at Pumin's Domain!", cid)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye and don't forget me!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye and don't forget me!")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
