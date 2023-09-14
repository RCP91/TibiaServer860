 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local playerTopic = {}
local function greetCallback(cid)

	

	if getPlayerStorageValue(cid, Storage.CultsOfTibia.Minotaurs.Acesso) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Gerimor is right. As an expert for minotaurs I am researching these creatures for years. I thought I already knew a lot but the monsters in this cave are {different}. It's a big {mystery}.")
		playerTopic[cid] = 1
	elseif (getPlayerStorageValue(cid, Storage.CultsOfTibia.Minotaurs.jamesfrancisTask) >= 0 and getPlayerStorageValue(cid, Storage.CultsOfTibia.Minotaurs.jamesfrancisTask) <= 50)
	and getPlayerStorageValue(cid, Storage.CultsOfTibia.Minotaurs.Mission) < 3 then
		npcHandler:setMessage(MESSAGE_GREET, "How is your {mission} going?")
		playerTopic[cid] = 5
	elseif getPlayerStorageValue(cid, Storage.CultsOfTibia.Minotaurs.Mission) == 4 then
		npcHandler:setMessage(MESSAGE_GREET, {"You say the minotaurs were controlled by a very powerful boss they worshipped. This explains why they had so much more power than the normal ones. ...",
		"I'm very thankful. Please go to the Druid of Crunor and tell him what you've seen. He might be interested in that."})
		setPlayerStorageValue(cid, Storage.CultsOfTibia.Minotaurs.Mission, 5)
		playerTopic[cid] = 10
	end
	npcHandler:addFocus(cid)
	return true
end


local voices = {
	{ text = 'Don\'t enter this area if you are an inexperienced fighter! It would be your end!' }
}
--npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	talkState[talkUser] = playerTopic[cid]
	

	-- Começou a quest
	if msgcontains(msg, "mystery") and talkState[talkUser] == 1 then
			selfSay({"The minotaurs I faced in the cave are much stronger than the normal ones. What I were able to see before I had to flee: all of them seem to belong to a cult worshipping their god. Could you do me a {favour}?"}, cid)
			talkState[talkUser] = 2
			playerTopic[cid] = 2
	elseif msgcontains(msg, "favour") and talkState[talkUser] == 2 then
			selfSay({"I'd like to work in this cave researching the minotaurs. But right now there are too many of hem and what is more, they are too powerful for me. Could you enter the cave and kill at least 50 of these creatures?"}, cid)
			talkState[talkUser] = 3
			playerTopic[cid] = 3
	elseif msgcontains(msg, "yes") and talkState[talkUser] == 3 then
			selfSay({"Very nice. Return to me if you've finished your job."}, cid)
			setPlayerStorageValue(cid, Storage.CultsOfTibia.Minotaurs.Mission, 2)
			setPlayerStorageValue(cid, Storage.CultsOfTibia.Minotaurs.jamesfrancisTask, 0)
			setPlayerStorageValue(cid, Storage.CultsOfTibia.Minotaurs.Acesso, 1)

		if getPlayerStorageValue(cid, Storage.CultsOfTibia.Questline) < 1 then
			setPlayerStorageValue(cid, Storage.CultsOfTibia.Questline, 1)
		end

	-- Entregando a quest
	elseif msgcontains(msg, "mission") and talkState[talkUser] == 5 then
		if getPlayerStorageValue(cid, Storage.CultsOfTibia.Minotaurs.jamesfrancisTask) >= 50 then
			selfSay({"Great job! You have killed at least 50 of these monsters. I give this key to you to open the door to the inner area. Go there and find out what's going on."}, cid)
			setPlayerStorageValue(cid, Storage.CultsOfTibia.Minotaurs.Mission, 3)
		else
			selfSay({"Come back when you have killed enough minotaurs."}, cid)
		end
	end
	return true
end



npcHandler:setMessage(MESSAGE_WALKAWAY, 'Well, bye then.')

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
