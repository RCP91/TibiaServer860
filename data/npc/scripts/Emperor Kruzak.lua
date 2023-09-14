local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)	npcHandler:onCreatureSay(cid, type, msg)	end
function onThink()						npcHandler:onThink()						end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	if getPlayerStorageValue(cid, Storage.OutfitQuest.GoldenBaseOutfit) < 1 then
		if (msg == "outfit") or (msg == "addon") then
			selfSay("In exchange for a truly generous donation, I will offer a special outfit. Do you want to make a donation?", cid)
			talkState[talkUser] = 1
		end
	elseif getPlayerStorageValue(cid, Storage.OutfitQuest.GoldenFirstAddon) < 1 or getPlayerStorageValue(cid, Storage.OutfitQuest.GoldenSecondAddon) < 1 and getPlayerStorageValue(cid, Storage.OutfitQuest.GoldenBaseOutfit) == 1 then
		if (msg == "outfit") or (msg == "addon") then
			selfSay("In exchange for a truly generous donation, I will offer a special outfit. Do you want to make a donation?", cid)
			talkState[talkUser] = 3
		end
	end
	if(msgcontains(msg, "yes")) and talkState[talkUser] == 1 then
		selfSay({
		"Excellent! Now, let me explain. If you donate 1.000.000.000 gold pieces, you will be entitled to wear a unique outfit. ...",
		"You will be entitled to wear the {armor} for 500.000.000 gold pieces, {boots} for an additional 250.000.000 and the {helmet} for another 250.000.000 gold pieces. ...",
		"What will it be?"
		}, cid)
		talkState[talkUser] = 2
	elseif (msgcontains(msg, "yes")) and talkState[talkUser] == 3 then
		selfSay({
		"Excellent! Now, let me explain. If you donate 1.000.000.000 gold pieces, you will be entitled to wear a unique outfit. ...",
		"You will be entitled to wear the {armor} for 500.000.000 gold pieces, {boots} for an additional 250.000.000 and the {helmet} for another 250.000.000 gold pieces. ...",
		"What will it be?"
		}, cid)
		talkState[talkUser] = 4
	end
		-- armor (golden outfit)
		if getPlayerStorageValue(cid, Storage.OutfitQuest.GoldenBaseOutfit) < 1 and talkState[talkUser] == 5 and (msgcontains(msg, "yes")) then
			if getPlayerBalance(cid) + getPlayerBalance(cid) >= 500000000 then
				selfSay("Take this armor as a token of great gratitude. Let us forever remember this day, my friend!", cid)
				doPlayerRemoveMoney(cid, 500000000)
				player:addOutfit(1211)
				player:addOutfit(1210)
				setPlayerStorageValue(cid, Storage.OutfitQuest.GoldenBaseOutfit, 1)
				talkState[talkUser] = 0
				else
				selfSay("You do not have enough money to donate that amount.", cid)
			end
		-- boots addon
		elseif (msgcontains(msg, "yes")) and talkState[talkUser] == 6 and getPlayerStorageValue(cid, Storage.OutfitQuest.GoldenFirstAddon) < 1 then
			if getPlayerBalance(cid) + getPlayerBalance(cid) >= 250000000 and getPlayerStorageValue(cid, Storage.OutfitQuest.GoldenBaseOutfit) == 1 then
				selfSay("Take this boots as a token of great gratitude. Let us forever remember this day, my friend. ", cid)
				talkState[talkUser] = 0
				doPlayerAddOutfit(cid, 1210, 2)
				doPlayerAddOutfit(cid, 1211, 2)
				doPlayerRemoveMoney(cid, 250000000)
				setPlayerStorageValue(cid, Storage.OutfitQuest.GoldenFirstAddon, 1)
				else
				selfSay("You do not have enough money to donate that amount.", cid)
			end
		-- helmet addon
		elseif talkState[talkUser] == 7 and (msgcontains(msg, "yes")) then
			if getPlayerBalance(cid) + getPlayerBalance(cid) >= 250000000 and getPlayerStorageValue(cid, Storage.OutfitQuest.GoldenBaseOutfit) == 1  and getPlayerStorageValue(cid, Storage.OutfitQuest.GoldenSecondAddon) < 1 then
				selfSay("Take this helmet as a token of great gratitude. Let us forever remember this day, my friend. ", cid)
				talkState[talkUser] = 0
				doPlayerRemoveMoney(cid, 250000000)
				doPlayerAddOutfit(cid, 1210, 1)
				doPlayerAddOutfit(cid, 1211, 1)
				setPlayerStorageValue(cid, Storage.OutfitQuest.GoldenSecondAddon, 1)
			else
				selfSay("Do not have money helmet", cid)
			end
		end
	if msgcontains(msg, "armor") and talkState[talkUser] == 2 and getPlayerStorageValue(cid, Storage.OutfitQuest.GoldenBaseOutfit) < 1 then
		selfSay("So you wold like to donate 500.000.000 gold pieces which in return will entitle you to wear a unique armor?", cid)
		talkState[talkUser] = 5
	elseif(msgcontains(msg, "boots")) and (talkState[talkUser] == 4 and getPlayerStorageValue(cid, Storage.OutfitQuest.GoldenBaseOutfit) == 1 and getPlayerStorageValue(cid, Storage.OutfitQuest.GoldenFirstAddon) < 1) then
		selfSay("So you would like to donate 250.000.000 gold pieces which in return will entitle you to wear unique boots?", cid)
		talkState[talkUser] = 6
	elseif(msgcontains(msg, "helmet")) and (talkState[talkUser] == 4 and getPlayerStorageValue(cid, Storage.OutfitQuest.GoldenBaseOutfit) == 1 and getPlayerStorageValue(cid, Storage.OutfitQuest.GoldenSecondAddon) < 1) then
		selfSay("So you would like to donate 250.000.000 gold pieces which in return will entitle you to wear a unique helmet?", cid)
		talkState[talkUser] = 7
	end
	return true
end

-- Promotion
local node1 = keywordHandler:addKeyword({'promot'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'I can promote you for 20000 gold coins. Do you want me to promote you?'})
	node1:addChildKeyword({'yes'}, StdModule.promotePlayer, {npcHandler = npcHandler, cost = 20000, level = 20, text = 'Congratulations! You are now promoted.'})
	node1:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Alright then, come back when you are ready.', reset = true})

npcHandler:setMessage(MESSAGE_GREET, 'Hiho, may fire and earth bless you, my child. Are you looking for a promotion?')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Farewell, |PLAYERNAME|, my child!')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

local focusModule = FocusModule:new()
focusModule:addGreetMessage('hail emperor')
npcHandler:addModule(focusModule)