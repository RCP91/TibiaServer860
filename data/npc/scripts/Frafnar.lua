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
		if getPlayerStorageValue(cid, Storage.hiddenCityOfBeregar.SweetAsChocolateCake) < 1 then
			selfSay("There is indeed something you could do for me. You must know, I'm in love with Bolfana. I'm sure she'd have a beer with me if I got her a chocolate cake. Problem is that I can't leave this door as I'm on duty. Would you be so kind and help me?", cid)
			talkState[talkUser] = 1
		elseif getPlayerStorageValue(cid, Storage.hiddenCityOfBeregar.SweetAsChocolateCake) == 2 then
			selfSay("So did you tell her that the cake came from me?", cid)
			talkState[talkUser] = 2
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			setPlayerStorageValue(cid, Storage.hiddenCityOfBeregar.SweetAsChocolateCake, 1)
			setPlayerStorageValue(cid, Storage.hiddenCityOfBeregar.DefaultStart, 1)
			selfSay("Great! She works in the tavern of Beregar. It's situated in the western part of the city. Bring her a chocolate cake and tell her that it was me who sent it.", cid)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 2 then
			setPlayerStorageValue(cid, Storage.hiddenCityOfBeregar.SweetAsChocolateCake, 3)
			setPlayerStorageValue(cid, Storage.hiddenCityOfBeregar.DoorWestMine, 1)
		selfSay("Great! That's my breakthrough. Now she can't refuse to go out with me. I grant you access to the western part of the mine.", cid)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "See you my friend.")
npcHandler:setMessage(MESSAGE_FAREWELL, "See you my friend.")
npcHandler:setMessage(MESSAGE_GREET, "Don't you see that I'm trying to write a poem? <sighs> So what's the matter?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
