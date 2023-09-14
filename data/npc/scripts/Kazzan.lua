local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local function greetCallback(cid)
	talkState[talkUser] = 0
	return true
end


local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	

	-- Pegando a quest
	if msgcontains(msg, "mission") and getPlayerStorageValue(cid, Storage.TibiaTales.ToAppeaseTheMightyQuest) < 1 then
			if getPlayerStorageValue(cid, Storage.DjinnWar.Faction.Marid) < 1 and getPlayerStorageValue(cid, Storage.DjinnWar.Faction.Efreet) < 1 then
			selfSay({
				'Do you know the location of the djinn fortresses in the mountains south of here?'}, cid)
			talkState[talkUser] = 1
		end
	elseif talkState[talkUser] == 1 and msgcontains(msg, "yes") then
			selfSay({
				'Alright. The problem is that I want to know at least one of them on my side. You never know. I don\'t mind if it\'s the evil Efreet or the Marid. ...',
				'Your mission will be to visit one kind of the djinns and bring them a peace-offering. Are you interested in that mission?'
			}, cid)
			talkState[talkUser] = 2
	elseif talkState[talkUser] == 2 and msgcontains(msg, "yes") then
			selfSay({
				'Very good. I hope you are able to convince one of the fractions to stand on our side. If you haven\'t done yet, you should first go and look for old Melchior in Ankrahmun. ...',
				'He knows many things about the djinn race and he may have some hints for you.'
			}, cid)
			if getPlayerStorageValue(cid, Storage.TibiaTales.DefaultStart) <= 0 then
				setPlayerStorageValue(cid, Storage.TibiaTales.DefaultStart, 1)
			end
			setPlayerStorageValue(cid, Storage.TibiaTales.ToAppeaseTheMightyQuest, 1)
		-- Entregando
	elseif getPlayerStorageValue(cid, Storage.TibiaTales.ToAppeaseTheMightyQuest) == 2 then
		selfSay({
		'Well, I don\'t blame you for that. I am sure you did your best. Now we can just hope that peace remains. Here, take this small gratification for your effort to help and Daraman may bless you!'
		}, cid)
		setPlayerStorageValue(cid, Storage.TibiaTales.ToAppeaseTheMightyQuest, getPlayerStorageValue(cid, Storage.TibiaTales.ToAppeaseTheMightyQuest) + 1)
		doPlayerAddItem(cid, 2152, 20)
	else
		if getPlayerStorageValue(cid, Storage.WhatAFoolishQuest.Questline) == 35
				and getPlayerStorageValue(cid, Storage.WhatAFoolishQuest.ScaredKazzan) ~= 1
				and player:getOutfit().lookType == 65 then
			setPlayerStorageValue(cid, Storage.WhatAFoolishQuest.ScaredKazzan, 1)
			selfSay('WAAAAAHHH!!!', cid)
			return false	
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
