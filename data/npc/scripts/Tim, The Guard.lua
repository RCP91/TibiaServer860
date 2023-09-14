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
	
	if msgcontains(msg, "trouble") and getPlayerStorageValue(cid, Storage.TheInquisition.TimGuard) < 1 and getPlayerStorageValue(cid, Storage.TheInquisition.Mission01) ~= -1 then
		selfSay("Ah, well. Just this morning my new toothbrush fell into the toilet.", cid)
		talkState[talkUser] = 1
	elseif msgcontains(msg, "authorities") then
		if talkState[talkUser] == 1 then
			selfSay("What do you mean? Of course they will immediately send someone with extra long and thin arms to retrieve it! ", cid)
			talkState[talkUser] = 2
		end
	elseif msgcontains(msg, "avoided") then
		if talkState[talkUser] == 2 then
			selfSay("Your humour might let end you up beaten in some dark alley, you know? No, I don't think someone could have prevented that accident! ", cid)
			talkState[talkUser] = 3
		end
	elseif msgcontains(msg, "gods would allow") then
		if talkState[talkUser] == 3 then
			selfSay("It's not a drama!! I think there is just no god who's responsible for toothbrush safety, that's all ... ", cid)
			talkState[talkUser] = 0
			if getPlayerStorageValue(cid, Storage.TheInquisition.TimGuard) < 1 then
				setPlayerStorageValue(cid, Storage.TheInquisition.TimGuard, 1)
				setPlayerStorageValue(cid, Storage.TheInquisition.Mission01, getPlayerStorageValue(cid, Storage.TheInquisition.Mission01) + 1) -- The Inquisition Questlog- "Mission 1: Interrogation"
				player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
			end
		end
	end
	return true
end

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "It's my duty to protect the city."})

npcHandler:setMessage(MESSAGE_GREET, "LONG LIVE THE KING!")
npcHandler:setMessage(MESSAGE_FAREWELL, "LONG LIVE THE KING!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "LONG LIVE THE KING!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
