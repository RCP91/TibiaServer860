 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	if not player then
		return false
	end

	if msgcontains(msg, "adventures") or msgcontains(msg, "join") then
		if getPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine) < 1 then
			selfSay({
				"I am glad to hear that. In the spirit of our own foreign legion we suggested the gnomes might hire heroes like you to build some kind of troop. They gave me that strange crystal to allow people passage to their realm. ...",
				"I hereby grant you permission to use the basic gnomish teleporters. I also give you four gnomish teleport crystals. One will be used up each time you use the teleporter. ...",
				"You can stock up your supply by buying more from me. Just ask me for a {trade}. Gnomette in the teleport chamber of the gnome outpost will sell them too. ...",
				"The teleporter here will transport you to one of the bigger gnomish outposts. ...",
				"There you will meet Gnomerik, the recruitment officer of the Gnomes. If you are lost, Gnomette in the teleport chamber might be able to help you with directions. ...",
				"Good luck to you and don't embarrass your race down there! Keep in mind that you are a representative of the big people."
			}, cid)

			setPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine, 1)
			doPlayerAddItem(cid, 18457, 4)

			--selfSay("Right now I am sort of {recruiting} people.", cid)
			talkState[talkUser] = 1
			else selfSay("You already talked with me.", cid)
		end
	elseif msgcontains(msg, "recruiting") then
		if talkState[talkUser] == 1 then
			selfSay("Ok, so listen. Your help is needed. That is if you're the hero type. Our ... {partners} need some help in urgent matters.", cid)
			talkState[talkUser] = 2
		end
	elseif msgcontains(msg, "partners") then
		if talkState[talkUser] == 2 then
			selfSay("I guess the time of secrecy is over now. Well, we have an old alliance with another underground dwelling race, the {gnomes}.", cid)
			talkState[talkUser] = 3
		end
	elseif msgcontains(msg, "gnomes") then
		if talkState[talkUser] == 3 then
			selfSay({
				"The gnomes preferred to keep our alliance and their whole {existence} a secret. They are a bit distrustful of others. ...",
				"They are quite self-sufficient and the fact that they are actually accepting some help is more than alarming. The gnomes are in real trouble and I am kind of an ambassador to find some people willing to {help}."
			}, cid)
			talkState[talkUser] = 4
		end
	elseif msgcontains(msg, "help") then
		if talkState[talkUser] == 4 then
			selfSay({
				"The gnomes are locked in a war with an enemy that thins out their resources but foremost their manpower. We have suggested that people like you could be just the specialists they are looking for. ...",
				"If you are interested to {join} the gnomish cause I can arrange a meeting with their recruiter."
			}, cid)
			talkState[talkUser] = 5
		end
	elseif msgcontains(msg, "join") then
		if talkState[talkUser] == 5 then
			selfSay({
				"I am glad to hear that. In the spirit of our own foreign legion we suggested the gnomes might hire heroes like you to build some kind of troop. They gave me that strange crystal to allow people passage to their realm. ...",
				"I hereby grant you permission to use the basic gnomish teleporters. I also give you four gnomish teleport crystals. One will be used up each time you use the teleporter. ...",
				"You can stock up your supply by buying more from me. Just ask me for a {trade}. Gnomette in the teleport chamber of the gnome outpost will sell them too. ...",
				"The teleporter here will transport you to one of the bigger gnomish outposts. ...",
				"There you will meet Gnomerik, the recruitment officer of the Gnomes. If you are lost, Gnomette in the teleport chamber might be able to help you with directions. ...",
				"Good luck to you and don't embarrass your race down there! Keep in mind that you are a representative of the big people."
			}, cid)

			setPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine, 1)
			doPlayerAddItem(cid, 18457, 4)
			talkState[talkUser] = 0
		end

	end


	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
