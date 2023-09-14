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

	
	if not player then
		return false
	end

	if msgcontains(msg, "recruit") then
		if getPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine) == 6 then
			selfSay({
				"Your examination is quite easy. Just step through the green crystal {apparatus} in the south! We will examine you with what we call g-rays. Where g stands for gnome of course ...",
				"Afterwards walk up to Gnomedix for your ear examination."
			}, cid)
			setPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine, 8)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, "apparatus") and talkState[talkUser] == 1 then
		selfSay("Don't be afraid. It won't hurt! Just step in!", cid)
		talkState[talkUser] = 0
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
