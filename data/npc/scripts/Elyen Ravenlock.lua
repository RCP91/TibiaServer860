 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{ text = '<hums a dark tune>' },
	{ text = '<chants> Re Ha, Omrah, Tan Ra...' },
	{ text = 'The rats... the rats in the walls...' }
}

--npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	if(msgcontains(msg, 'scroll') or msgcontains(msg, 'mission')) and getPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission60) == 1 and getPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission61) < 1 then
		selfSay("Hello, brother. You come with a question to me, I believe?", cid)
		talkState[talkUser] = 1
	elseif msgcontains(msg, 'yes') and talkState[talkUser] == 1 and getPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission60) == 1 then
		selfSay("And what is it you want? Do you bring news from the undead, or do you seek a dark {artefact}?", cid)
		setPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission45, 1)
		talkState[talkUser] = 2
	elseif(msgcontains(msg, 'artefact') or msgcontains(msg, 'yes')) and talkState[talkUser] == 2 and getPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission60) == 1 and getPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission61) < 1 then
		selfSay({
			"The scroll piece there? The symbols look promising, but it is incomplete. ...",
			"It is of little use to us. But it seems to be of interest to you ...",
			"In exchange for the scroll piece, you must assist me with something. {Agreed}?"
		}, cid)
		talkState[talkUser] = 3
	elseif(msgcontains(msg, 'agreed') or msgcontains(msg, 'yes')) and talkState[talkUser] == 3 and getPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission60) == 1 and getPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission61) < 1 then
		selfSay({
			"I would have to sing to the Dark Shrines, but I cannot. ...",
			"I... cannot bear Urgith's breed. Everywhere, I hear them - scrabbling, squeaking ...",
			"Take this bone flute and play it in front of the five Dark Shrines so that they answer with song in return. You will find them in the Gardens of Night. ...",
			"If you have done that, you may have the scroll piece. Now go."
		}, cid)
		setPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission61, 1)
		doPlayerAddItem(cid, 21249, 1)
		talkState[talkUser] = 0
	elseif msgcontains(msg, 'mission') and getPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission66) == 1 and getPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission67) < 1 then
		selfSay("Hello, brother. You have finished the dance?", cid)
		talkState[talkUser] = 4
	elseif(msgcontains(msg, 'yes')) and talkState[talkUser] == 4 and getPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission66) == 1 and getPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission67) < 1 then
		selfSay({
			"You have indeed. The shrines have sung back to you. Well done, brother. Not many men take such an interest in our art. ...",
			"I will take the flute back. Our bargain stands. You may take the scroll."
		}, cid)
		doPlayerRemoveItem(cid, 21249, 1)
		setPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission67, 1)
		talkState[talkUser] = 0
		else selfSay({"Time is money, hurry."}, cid)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "A shadow preceded you. You wish a {scroll} or a {mission}?")
npcHandler:addModule(FocusModule:new())
