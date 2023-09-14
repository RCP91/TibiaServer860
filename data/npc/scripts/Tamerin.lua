local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local function greetCallback(cid)
	
	if getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 30 then
		npcHandler:setMessage(MESSAGE_GREET, "Have you the {animal cure}?")
	elseif getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 31 then
		npcHandler:setMessage(MESSAGE_GREET, "Have you killed {morik}?")
	else
		npcHandler:setMessage(MESSAGE_GREET, "Hello, what brings you here?")
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	
	if msgcontains(msg, "mission") then
		if getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 29 then
			selfSay({
				"Why should I do something for another human being? I have been on my own for all those years. Hmm, but actually there is something I could need some assistance with. ... ",
				"If you help me to solve my problems, I will help you with your mission. Do you accept?"
			}, cid)
			talkState[talkUser] = 1
		elseif getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 32 then
			selfSay("You have kept your promise. Now, it's time to fulfil my part of the bargain. What kind of animals shall I raise? {Warbeasts} or {cattle}?", cid)
			talkState[talkUser] = 2
		end
	elseif msgcontains(msg, "animal cure") then
		if getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 30 and doPlayerRemoveItem(cid, 9734, 1) then
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, 31)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.MorikSummon, 0)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission05, 4) -- StorageValue for Questlog "Mission 05: Food or Fight"
			selfSay("Thank you very much. As I said, as soon as you have helped me to solve both of my problems, we will talk about your mission. Have you killed {morik}?", cid)
			talkState[talkUser] = 0
		else
			selfSay("Come back when you have the cure.", cid)
		end
	elseif msgcontains(msg, "cattle") then
		if talkState[talkUser] == 2 then
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.TamerinStatus, 1)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission05, 6) -- StorageValue for Questlog "Mission 05: Food or Fight"
			selfSay("So be it!", cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "warbeast") then
		if talkState[talkUser] == 2 then
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.TamerinStatus, 2)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission05, 7) -- StorageValue for Questlog "Mission 05: Food or Fight"
			selfSay("So be it!", cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "morik") then
		if getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 31 and doPlayerRemoveItem(cid, 9735, 1) then
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, 32)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission05, 5) -- StorageValue for Questlog "Mission 05: Food or Fight"
			selfSay("So he finally got what he deserved. As I said, as soon as you have helped me to solve both of my problems, we will talk about your {mission}.", cid)
			talkState[talkUser] = 0
		else
			selfSay("Come back when you got rid with Morik.", cid)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.MorikSummon, 0)
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, 30)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission05, 3) -- StorageValue for Questlog "Mission 05: Food or Fight"
			selfSay("I ask you for two things! For one thing, I need an animal cure and for another thing, I ask you to get rid of the gladiator Morik for me.", cid)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
