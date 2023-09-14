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


	npcHandler:setMessage(MESSAGE_GREET, "Hm? Oh! Oh, yes a... visitor! Intruder? Benefactor...? Wha- what are you? If you want to {pass} through this {cave}, I may have to disappoint you. Or maybe not. It... depends. So, just passing through?.")
	playerTopic[cid] = 1
	npcHandler:addFocus(cid)

return true
end


local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	talkState[talkUser] = playerTopic[cid]
	

	-- Começou a quest
	if msgcontains(msg, "pass") and talkState[talkUser] == 1 then
			selfSay({"Yes, yes. Or wait - why do you want to.. ah what does it matter. So you want to get through these {caves}, fine. But be warned! ...",
			"...wait a second, I lost it. What was I going to say again? Ah yes - DANGEROUS! These. Caves. Are. Dangerous. No way you get out alive. Ever. Again. ...",
			"Also you should not disturb those... people down there. Yeah. They... hm, wait, they - who are they again? Hey! Who are you? Are you talking to me?! Ah, ah... oh yes, I remember. ...",
			"Wait - I am the guardian here, yes! The keeper of... something... or another, yes, I... guard this place. With my life. Don't I? Of course! ...",
			"Is, er... this the moment where I should try to... stop you? Yes? No? Ah, you know what - you go down there, those guys are angry as dung anyway. Try your luck, return to me when you're done. If you still can. Or not."}, cid)
			if getPlayerStorageValue(cid, Storage.CultsOfTibia.Questline) < 1 then
			   setPlayerStorageValue(cid, Storage.CultsOfTibia.Questline, 1)
			end
			if getPlayerStorageValue(cid, Storage.CultsOfTibia.Misguided.Mission) < 2 then
			   setPlayerStorageValue(cid, Storage.CultsOfTibia.Misguided.Mission, 2)
			end
	elseif msgcontains(msg, "cave") and talkState[talkUser] == 1 then
			selfSay({"I was stationed in this cave to... guard something. Right now I am not even sure what that was."}, cid)
	elseif msgcontains(msg, "job") and talkState[talkUser] == 1 then
			selfSay({"Then don't waste my time. I'm doing some important... business... here. Actually... where am I? If I find out, I will be even more angry than I am now. Out of my sight."}, cid)
	elseif msgcontains(msg, "mission") and talkState[talkUser] == 1 then
			selfSay({"I was on a mission, too - I guess. It was all quite blurry back then. Maybe I'll leave this place after I recovered completely. I have to find out what happened to me."}, cid)
	end
return true
end



npcHandler:setMessage(MESSAGE_WALKAWAY, 'Well, bye then.')

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
