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


	

	if msgcontains(msg, "promot") then
	local vocation = player:getVocation()
    local promotion = vocation:getPromotion()
    if player:isPremium() then
        local value = getPlayerStorageValue(cid, Storage.Promotion)
        if not promotion and value ~= 1 then
		selfSay({"You want be promoted? 1"}, cid)
		talkState[talkUser] = 1
    elseif value == 1 then
		selfSay({"You want be promoted? 2"}, cid)
		talkState[talkUser] = 1
		end
    elseif not promotion then
        player:setVocation(vocation:getDemotion())
    end

	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
		local vocation = player:getVocation()
		local promotion = vocation:getPromotion()
			player:setVocation(promotion)
			--player:setVocation(vocation:getDemotion())
			selfSay("Promotion Done.", cid)
			talkState[talkUser] = 0
		else
			selfSay("Zzz...", cid)
		end

		-- YES AQUI

	elseif msgcontains(msg, "no") then
		if talkState[talkUser] == 1 then
			selfSay("Then no.", cid)
			talkState[talkUser] = 0
		end
	end
		-- YES AQUI

	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Bye, bye.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Bye, bye.")
npcHandler:setMessage(MESSAGE_GREET, "Hiho, hiho |PLAYERNAME|.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
