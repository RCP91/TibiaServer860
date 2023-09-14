local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{ text = 'Interesting reaction. Bloodcurdling. Must inspect further.' },
	{ text = 'This is really sanguine!' },
	{ text = 'Hmm... the conductors are too dry to transmit energy.' },
	{ text = 'Ah, fresh blood. My favourite.' }
}

--npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	
	if(msgcontains(msg, 'scroll') or msgcontains(msg, 'mission')) and getPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission35) == 1 and getPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission36) < 1 then
		selfSay({
			"So someone sent you after a scroll, eh? A stroll for a scroll! <chuckles> Sounds like an old-fashioned necromancer thing. ...",
			"Well, this piece here is a rather fascinating thing - see those strange blood stains? - ...",
			"My predecessors have had it for quite a while without finding out more - I was hoping to investigate, but there's always so much to do! ...",
			"Ah, so you want it, too? Well, do me a favour: fetch two samples and assist in my experiment, in exchange for the scroll piece. Yes?"
		}, cid)
		talkState[talkUser] = 1
	elseif msgcontains(msg, 'yes') and talkState[talkUser] == 1 and getPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission35) == 1 then
		selfSay({
			"Sanguine! I need two different blood samples - The first one from the necromancer's pure blood chamber. ... ",
			"I was barred from the premises. For my research! Shameful! I'm a martyr to the cause - oh, the second sample you said? ...",
			"The second sample you must retrieve from the sacrificial chamber in the ancient vampire crypts, first floor, far west. ...",
			"Take these two sterilised vials, one for each blood basin. Oh, I wish I could go myself! Come back when you have filled both vials."
		}, cid)
		setPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission36, 1)
		doPlayerAddItem(cid, 21417, 2)
		talkState[talkUser] = 0
	elseif(msgcontains(msg, 'scroll') or msgcontains(msg, 'mission') or msgcontains(msg, 'blood')) and getPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission37) == 1 and getPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission38) < 1 then
		selfSay("Hello hello! Did you bring those blood samples?", cid)
		talkState[talkUser] = 2
	elseif msgcontains(msg, 'yes') and talkState[talkUser] == 2 and getPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission37) == 1 then
		if getPlayerItemCount(cid, 21419) >= 1 and getPlayerItemCount(cid, 21418) >= 1 then
			selfSay({
				"Now, let me see... yes... yes... very good. Let me add THIS ..... swill it... there. Sanguine! ...",
				"We're not finished yet. Take this tainted blood vial ...",
				"Dab some drops from it on to the four blood pagodas in the inner circle here. Then pull the lightning lever over there."
			}, cid)
			setPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission38, 1)
			doPlayerRemoveItem(cid, 21418, 1)
			doPlayerRemoveItem(cid, 21419, 1)
			doPlayerAddItem(cid, 21449, 1)
			talkState[talkUser] = 0
		else
			selfSay("You haven't got any blood.", cid)
			talkState[talkUser] = 0
		end
	elseif(msgcontains(msg, 'scroll') or msgcontains(msg, 'mission')) and getPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission40) == 1 and getPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission41) < 1 then
		selfSay("Hello hello! Did Hello hello! Well now, painted all those blood pagodas properly?", cid)
		talkState[talkUser] = 3
	elseif msgcontains(msg, 'yes') and talkState[talkUser] == 3 and getPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission40) == 1 then
		selfSay({
			"Sanguine! Did you see those sparks! We definitely had some energy transfer! Well done! Now, for your reward. ...",
			"Err... I would awfully like to know more about the scroll ...",
			"Would you settle for a heartfelt handshake instead - oh, you wouldn't? Well, er, okay ...",
			"Give me a minute or two to retrieve it. Ask me for the {scroll} or the {mission}"
		}, cid)
		setPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission41, 1)
		talkState[talkUser] = 0
	elseif(msgcontains(msg, 'scroll') or msgcontains(msg, 'mission')) and getPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission41) == 1 and getPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission42) < 1 then
		selfSay("Hello hell- oh, you've come for the scroll, haven't you?", cid)
		talkState[talkUser] = 4
	elseif msgcontains(msg, 'yes') and talkState[talkUser] == 4 and getPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission41) == 1 then
		selfSay("My heart bleeds to part from it. Here. Extend your hand - I'll just retrieve some blood from in exchange - HOLD STILL.", cid)
		setPlayerStorageValue(cid, Storage.GravediggerOfDrefia.Mission42, 1)
		doPlayerAddItem(cid, 21250, 1)
		talkState[talkUser] = 0
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
