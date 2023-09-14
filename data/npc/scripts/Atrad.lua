local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

function greetCallback(cid)
	
	local fire = player:getCondition(CONDITION_FIRE)

	if fire then
		return true
	end
	
	return false
end

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end
	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

	if(msgcontains(msg, "addon") or msgcontains(msg, "outfit")) then
		if(getPlayerStorageValue(cid, 18999) < 1) then
			selfSay("You managed to deceive Erayo? Impressive. Well, I guess, since you have come that far, I might as well give you a task too, eh?", cid)
			talkState[talkUser] = 2
		end
	elseif(msgcontains(msg, "nose ring") or msgcontains(msg, "ring")) then
		if(getPlayerStorageValue(cid, 18999) == 1) then
			if(getPlayerItemCount(cid, 5804) >= 1) and getPlayerItemCount(cid, 5930) >= 1 then
			selfSay("I see you brought my stuff. Good. I'll keep my promise: Here's katana in return.", cid)
			doPlayerRemoveItem(cid, 5804, 1)
			doPlayerRemoveItem(cid, 5930, 1)
			doPlayerAddOutfit(cid, getPlayerSex(cid) == 0 and 156 or 152, 2)
			setPlayerStorageValue(cid, 18999, 2) -- exaust
			talkState[talkUser] = 0
		else
			selfSay("You don't have it...", cid)
		end
	end

	elseif(msgcontains(msg, "yes")) then
		if(talkState[talkUser] == 2) then
				selfSay("Okay, listen up. I don't have a list of stupid objects, I just want two things. A behemoth claw and a nose ring. Got that?", cid)
				talkState[talkUser] = 3
		elseif(talkState[talkUser] == 3) then
				selfSay("Good. Come back then you have BOTH. Should be clear where to get a behemoth claw from. There's a horned fox who wears a nose ring. Good luck.", cid)
				setPlayerStorageValue(cid, 18999, 1)
				talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())