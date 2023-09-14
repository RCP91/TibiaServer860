local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)				npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)			npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)			npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()					npcHandler:onThink()					end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	
	if msgcontains(msg, 'belongings of deceasead') or msgcontains(msg, 'medicine') then
		if getPlayerItemCount(cid, 13506) > 0 then
			selfSay('Did you bring me the medicine pouch?', cid)
			talkState[talkUser] = 1
		else
			selfSay('I need a {medicine pouch}, to give you the {belongings of deceased}. Come back when you have them.', cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, 'yes') and talkState[talkUser] == 1 then
		if doPlayerRemoveItem(cid, 13506, 1) then
			doPlayerAddItem(cid, 13670, 1)
			--player:addAchievementProgress('Doctor! Doctor!', 100)
			selfSay('Here you are', cid)
		else
			selfSay('You do not have the required items.', cid)
		end
		talkState[talkUser] = 0
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
