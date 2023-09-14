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

	

	if msgcontains(msg, "addon") or msgcontains(msg, "help") then
		if getPlayerStorageValue(cid, 72326) < 1 then
			selfSay("If you want anything, you should talk to Old Rock Boy over there. I do {collect} stuff, though. So just ask if you're interested in helping me.", cid)
			setPlayerStorageValue(cid, 72326, 1)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "collect") then
		if getPlayerStorageValue(cid, 72326) == 1 then
			selfSay("I collect everything that reflects light in strange ways. However, I am bored by my collection. And there wasn't anything new to add for years. ...", cid)
			selfSay("I like pearls for example - but I have already enough. I also like shells - but I can't even count how many I already own. ...", cid)
			selfSay("If you find anything of REAL VALUE - bring it to me. I will reward you well. You don't already have something for me by chance?", cid)
			talkState[talkUser] = 1
		elseif getPlayerStorageValue(cid, 72326) == 2 then
			selfSay("Have you got anything for me today?", cid)
			talkState[talkUser] = 2
		elseif getPlayerStorageValue(cid, 72326) == 3 then
			selfSay("Have you got anything for me today?", cid)
			talkState[talkUser] = 3
		elseif getPlayerStorageValue(cid, 72326) == 4 and doPlayerRemoveItem(cid, 15434, 1) then
			selfSay("Have you got anything... what? You want what? A reward? HAHAHAHAAAA!! ...", cid)
			selfSay("No I'm just teasing you. I'm really happy about my collection now. ...", cid)
			selfSay("Well, I found some kind of weapon a long time ago. I believe it may be especially helpful underwater as it is from the deep folk. In any case it is of more use for you than it would be for me.", cid)
			doPlayerAddOutfit(cid, 464, 1)
			doPlayerAddOutfit(cid, 463, 1)
			setPlayerStorageValue(cid, 72326, 5)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			selfSay("Great! Let me see. Amazing! I will take this, thank you!", cid)
			setPlayerStorageValue(cid, 72326, 2)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 2 and doPlayerRemoveItem(cid, 15435, 1) then
			selfSay("Great! Let me see. Amazing! I will take this, thank you!", cid)
			setPlayerStorageValue(cid, 72326, 3)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 3 and doPlayerRemoveItem(cid, 15436, 1) then
			selfSay("Great! Let me see. Amazing! I will take this, thank you!", cid)
			setPlayerStorageValue(cid, 72326, 4)
			talkState[talkUser] = 0
			else selfSay("You dont have the required items!", cid)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
