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
	
	if msgcontains(msg, "eleonore") then
		if getPlayerStorageValue(cid, Storage.TheShatteredIsles.APoemForTheMermaid) < 1 then
			selfSay("Eleonore ... Yes, I remember her... vaguely. She is a pretty girl ... but still only a girl and now I am in love with a beautiful and passionate woman. A true {mermaid} even.", cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, "mission") then
		if getPlayerStorageValue(cid, Storage.TheShatteredIsles.APoemForTheMermaid) < 1 then
			selfSay("Don't ask about silly missions. All I can think about is this lovely {mermaid}.", cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, "mermaid") then
		if talkState[talkUser] == 1 then
			selfSay("The mermaid is the most beautiful creature I have ever met. She is so wonderful. It was some kind of magic as we first met. A look in her eyes and I suddenly knew there would be never again another woman in my life but her.", cid)
			talkState[talkUser] = 0
			setPlayerStorageValue(cid, Storage.TheShatteredIsles.APoemForTheMermaid, 1)
		end
	elseif msgcontains(msg, "pirate outfit") then
		if getPlayerStorageValue(cid, Storage.TheShatteredIsles.AccessToLagunaIsland) == 1 and getPlayerStorageValue(cid, Storage.OutfitQuest.PirateBaseOutfit) < 1 then
			selfSay("Ah, right! The pirate outfit! Here you go, now you are truly one of us.", cid)
			player:addOutfit(151)
			player:addOutfit(155)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
			setPlayerStorageValue(cid, Storage.OutfitQuest.PirateBaseOutfit, 1)
			talkState[talkUser] = 0
		else
			selfSay("test: ".. getPlayerStorageValue(cid, Storage.OutfitQuest.PirateBaseOutfit), cid)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Be greeted. Is there anything I can {do for you}?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Oh well.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
