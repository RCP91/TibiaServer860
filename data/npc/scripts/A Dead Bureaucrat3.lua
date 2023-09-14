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

local function greetCallback(cid)
	npcHandler:setMessage(MESSAGE_GREET, "Hello " .. (Player(cid):getSex() == PLAYERSEX_FEMALE and "beautiful lady" or "handsome gentleman") .. ", welcome to the atrium of Pumin's Domain. We require some information from you before we can let you pass. Where do you want to go?")
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	local vocation = Vocation(player:getVocation():getBase():getId())

	if msgcontains(msg, "pumin") then
		if getPlayerStorageValue(cid, Storage.PitsOfInferno.ThronePumin) == 2 then
			selfSay("Tell me if you liked it when you come back. What is your name?", cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, player:getName()) then
		if talkState[talkUser] == 1 then
			selfSay("Alright |PLAYERNAME|. Vocation?", cid)
			talkState[talkUser] = 2
		end
	elseif msgcontains(msg, vocation:getName()) then
		if talkState[talkUser] == 2 then
			selfSay("I was a " .. vocation:getName() .. ", too, before I died!! What do you want from me?", cid)
			talkState[talkUser] = 3
		end
	elseif msgcontains(msg, "145") then
		if talkState[talkUser] == 3 then
			setPlayerStorageValue(cid, Storage.PitsOfInferno.ThronePumin, 3)
			selfSay("That's right, you can get Form 145 from me. However, I need Form 411 first. Come back when you have it.", cid)
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.PitsOfInferno.ThronePumin) == 6 then
			setPlayerStorageValue(cid, Storage.PitsOfInferno.ThronePumin, 7)
			selfSay("Well done! You have form 411!! Here is Form 145. Have fun with it.", cid)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye and don't forget me!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye and don't forget me!")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
