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
	
	if msgcontains(msg, 'letter') then
		if getPlayerStorageValue(cid, Storage.thievesGuild.Mission06) == 1 then
			selfSay('You would like Chantalle\'s letter? only if you are willing to pay a price. {gold} maybe?', cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, 'gold') then
		if talkState[talkUser] == 1 then
			selfSay('Are you willing to pay 1000 gold for this letter?', cid)
			talkState[talkUser] = 2
		end
	elseif msgcontains(msg, 'yes') then
		if talkState[talkUser] == 2 then
			if doPlayerRemoveMoney(cid, 1000) then
				doPlayerAddItem(cid, 8768, 1)
				selfSay('Here you go kind sir.', cid)
				talkState[talkUser] = 0
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
