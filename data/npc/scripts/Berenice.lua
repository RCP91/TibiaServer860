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

	

	if msgcontains(msg, "mission") then
		if getPlayerStorageValue(cid, Storage.ExplorerSociety.CalassaQuest) == 2 then
			selfSay("OH! So you have safely returned from Calassa! Congratulations, were you able to retrieve the logbook?", cid)
			talkState[talkUser] = 5
		elseif getPlayerStorageValue(cid, Storage.ExplorerSociety.TheOrcPowder) > 34 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) > 34 then
			selfSay("The most important mission we currently have is an expedition to {Calassa}.", cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, "calassa") then
		if talkState[talkUser] == 1 and getPlayerStorageValue(cid, Storage.ExplorerSociety.CalassaQuest) < 1 then
			selfSay("Ah! So you have heard about our special mission to investigate the Quara race in their natural surrounding! Would you like to know more about it?", cid)
			talkState[talkUser] = 2
		elseif talkState[talkUser] == 4 then
			selfSay("Captain Max will bring you to Calassa whenever you are ready. Please try to retrieve the missing logbook which must be in one of the sunken shipwrecks.", cid)
			
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.ExplorerSociety.CalassaQuest) == 2 then
			selfSay("OH! So you have safely returned from Calassa! Congratulations, were you able to retrieve the logbook?", cid)
			talkState[talkUser] = 5
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 2 then
			selfSay({
				"Since you have already proved to be a valuable member of our society, I will happily entrust you with this mission, but there are a few things which you need to know, so listen carefully. ...",
				"Calassa is an underwater settlement, so you are in severe danger of drowning unless you are well-prepared. ...",
				"We have developed a new device called 'Helmet of the Deep' which will enable you to breathe even in the depths of the ocean. ...",
				"I will instruct Captain Max to bring you to Calassa and to lend one of these helmets to you. These helmets are very valuable, so there is a deposit of 5000 gold pieces on it. ...",
				"While in Calassa, do not take the helmet off under any circumstances. If you have any questions, don't hesitate to ask Captain Max. ...",
				"Your mission there, apart from observing the Quara, is to retrieve a special logbook from one of the shipwrecks buried there. ...",
				"One of our last expeditions there failed horribly and the ship sank, but we still do not know the exact reason. ...",
				"If you could retrieve the logbook, we'd finally know what happened. Have you understood your task and are willing to take this risk?"
			}, cid)
			talkState[talkUser] = 3
		elseif talkState[talkUser] == 3 then
			setPlayerStorageValue(cid, Storage.ExplorerSociety.CalassaQuest, 1)
			selfSay("Excellent! I will immediately inform Captain Max to bring you to {Calassa} whenever you are ready. Don't forget to make thorough preparations!", cid)
			talkState[talkUser] = 4
		elseif talkState[talkUser] == 5 then
			if doPlayerRemoveItem(cid, 6124, 1) then
				setPlayerStorageValue(cid, Storage.ExplorerSociety.CalassaQuest, 3)
				selfSay("Yes! That's the logbook! However... it seems that the water has already destroyed many of the pages. This is not your fault though, you did your best. Thank you!", cid)
				talkState[talkUser] = 0
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
