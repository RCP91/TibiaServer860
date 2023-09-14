 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}


function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

function creatureSayCallback(cid, type, msg)
	if(not(npcHandler:isFocused(cid))) then
		return false
	end


	if(msgcontains(msg, "funding")) then
		if(getPlayerStorageValue(cid, 10050) == 7) then
			selfSay("So far you earned x votes. Each single vote can be spent on a different topic or you're also able to cast all your votes on one voting. ...", cid)
			selfSay("Well in the topic b you have the possibility to vote for the funding of the {archives}, import of bug {milk} or street {repairs}.", cid)
			talkState[talkUser] = 1
			else selfSay("You cant vote yet.", cid)
		end
			elseif(msgcontains(msg, "archives")) then
		if(talkState[talkUser] == 1) then
			selfSay("How many of your x votes do you want to cast?", cid)
			talkState[talkUser] = 2
		end
	elseif(msgcontains(msg, "1")) then
		if(talkState[talkUser] == 2) then
			selfSay("Did I get that right: You want to cast 1 of your votes on funding the {archives?}", cid)
			talkState[talkUser] = 3
		end
	elseif(msgcontains(msg, "yes")) then
		if(talkState[talkUser] == 3) then
		   setPlayerStorageValue(cid, 10050, 8)
		   setPlayerStorageValue(cid, 20057, 1)
		   setPlayerStorageValue(cid, 20058, 0)
			selfSay("Thanks, you successfully cast your vote. Feel free to continue gathering votes by helping the city! Farewell.", cid)
			talkState[talkUser] = 0
		end
	end

	return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
