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

	
	if msgcontains(msg, "join") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.NightmareOutfit) < 1 and getPlayerStorageValue(cid, Storage.OutfitQuest.BrotherhoodOutfit) < 1 then
			selfSay({
				"The Brotherhood of Bones has suffered greatly in the past, but we did survive as we always will ...",
				"You have proven resourceful by beating the silly riddles the Nightmare Knights set up to test their candidates ...",
				"It's an amusing thought that after passing their test you might choose to join the ranks of their sworn enemies ...",
				"For the irony of this I ask you, |PLAYERNAME|: Do you want to join the Brotherhood of Bones?"
			}, cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, "advancement") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.BrotherhoodOutfit) == 1 then
			selfSay("So you want to advance to a {Hyaena} rank? Did you bring 500 demonic essences with you?", cid)
			talkState[talkUser] = 3
		elseif getPlayerStorageValue(cid, Storage.OutfitQuest.BrotherhoodOutfit) == 2 then
			selfSay("So you want to advance to a {Death Dealer} rank? Did you bring 1000 demonic essences with you?", cid)
			talkState[talkUser] = 4
		elseif getPlayerStorageValue(cid, Storage.OutfitQuest.BrotherhoodOutfit) == 3 then
			selfSay("So you want to advance to a {Dread Lord} rank? Did you bring 1500 demonic essences with you?", cid)
			talkState[talkUser] = 5
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			selfSay({
				"But know that your decision will be irrevocable. You will abandon the opportunity to join any order whose doctrine is incontrast to our own ...",
				"Do you still want to join the Brotherhood?"
			}, cid)
			talkState[talkUser] = 2
		elseif talkState[talkUser] == 2 then
			selfSay({
				"Welcome to the Brotherhood! From now on you will walk the path of Bones. A life full of promises and power has just beenoffered to you ...",
				"Take it, if you are up to that challenge ... or perish in agony if you deserve this fate ...",
				"You can always ask me about your current rank and about the privileges the ranks grant to those who hold them."
			}, cid)
			setPlayerStorageValue(cid, Storage.OutfitQuest.BrotherhoodOutfit, 1)
			--player:addAchievement('Bone Brother')
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 3 then
			if doPlayerRemoveItem(cid, 6500, 500) then
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				setPlayerStorageValue(cid, Storage.OutfitQuest.BrotherhoodOutfit, 2)
				selfSay("You advanced to {Hyaena} rank! You are now able to use teleports of second floor of Knightwatch Tower.", cid)
			else
				selfSay("Come back when you gather all essences.", cid)
			end
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 4 then
			if doPlayerRemoveItem(cid, 6500, 1000) then
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				setPlayerStorageValue(cid, Storage.OutfitQuest.BrotherhoodOutfit, 3)
				doPlayerAddItem(cid, 6433, 1)
				--player:addAchievement('Skull and Bones')
				selfSay("You advanced to {Death Dealer} rank!", cid)
			else
				selfSay("Come back when you gather all essences.", cid)
			end
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 5 then
			if doPlayerRemoveItem(cid, 6500, 1500) then
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				setPlayerStorageValue(cid, Storage.OutfitQuest.BrotherhoodOutfit, 4)
				setPlayerStorageValue(cid, Storage.OutfitQuest.BrotherhoodDoor, 1)
				setPlayerStorageValue(cid, Storage.KnightwatchTowerDoor, 1)
				--player:addAchievement('Dread Lord')
				selfSay("You advanced to {Dread Lord} rank! You are now able to use teleports of fourth floor of Knightwatch Tower and to create addon scrolls.", cid)
			else
				selfSay("Come back when you gather all essences.", cid)
			end
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
