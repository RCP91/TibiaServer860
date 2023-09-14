local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{ text = 'Heed. Your. Will. We. Will.' },
	{ text = 'Intruder. Intrude. Must. Explain.' },
	{ text = 'Ssssttttoooopppp.' }
}

--npcHandler:addModule(VoiceModule:new(voices))

keywordHandler:addKeyword({'master'}, StdModule.say, {npcHandler = npcHandler, text = "Our. Master. Is. Gone. You. Can. Not. Visit. Him! We. Stand. {Sentry}!"})
keywordHandler:addKeyword({'sentry'}, StdModule.say, {npcHandler = npcHandler, text = "{Master}. Conducted. Experiments. Great. Problems. You. Must. Go!"})
keywordHandler:addKeyword({'slime'}, StdModule.say, {npcHandler = npcHandler, text = "{Slime}. Dangerous. We. Have. It. Under. Control. ... We. Will. Stand. {Sentry}."}, function(player) return getPlayerStorageValue(cid, Storage.TheirMastersVoice.SlimeGobblerReceived) == 1 end)

local function greetCallback(cid)
	
	if getPlayerStorageValue(cid, Storage.TheirMastersVoice.SlimeGobblerReceived) < 1 then
		selfSay("The. {Slime}. Has. Entered. Our. {Master}. Has. Left! We. Must. {Help}.", cid)
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	if msgcontains(msg, "help") then
			selfSay("Defeat. {Slime}. We. Will. Why. Did. You. Kill. Us? Do. You. Want. To. Rectify. And. Help?", cid)
			talkState[talkUser] = 1
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			setPlayerStorageValue(cid, Storage.TheirMastersVoice.SlimeGobblerReceived, 1)
			doPlayerAddItem(cid, 13601, 1)
			selfSay("Then. Take. This. Gobbler. Always. Hungry. Eats. Slime. Fungus. Go.", cid)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "The. Slime. Has. Entered. Our. Master. Has. Left! We. Must. Help.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Goodbye. Human. Being!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Goodbye. Human. Being!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
