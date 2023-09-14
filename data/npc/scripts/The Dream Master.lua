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
		if getPlayerStorageValue(cid, Storage.OutfitQuest.BrotherhoodOutfit) < 1 and getPlayerStorageValue(cid, Storage.OutfitQuest.NightmareOutfit) < 1 then
			selfSay({
				"The Nightmare Knights are almost extinct now, and as far as I know I am the only teacher that is left. But you might beright and its time to accept new disciples ...",
				"After all you have passed the Dream Challenge to reach this place, which used to be the process of initiation in the past...",
				"So I ask you: do you wish to become a member of the ancient order of the Nightmare Knights, |PLAYERNAME|?"
			}, cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, "advancement") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.NightmareOutfit) == 1 then
			selfSay("So you want to advance to a {Initiate} rank? Did you bring 500 demonic essences with you?", cid)
			talkState[talkUser] = 3
		elseif getPlayerStorageValue(cid, Storage.OutfitQuest.NightmareOutfit) == 2 then
			selfSay("So you want to advance to a {Dreamer} rank? Did you bring 1000 demonic essences with you?", cid)
			talkState[talkUser] = 4
		elseif getPlayerStorageValue(cid, Storage.OutfitQuest.NightmareOutfit) == 3 then
			selfSay("So you want to advance to a {Lord Protector} rank? Did you bring 1500 demonic essences with you?", cid)
			talkState[talkUser] = 5
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			selfSay("Please know that your decision is irrevocable. You will abandon the opportunity to join any order whose doctrine is incontrast to our own ...", cid)
			selfSay("Do you still want to join our order?", cid)
			talkState[talkUser] = 2
		elseif talkState[talkUser] == 2 then
			selfSay({
				"So I welcome you as the latest member of the order of the Nightmare Knights. You entered this place as a stranger, butyou will leave this place as a friend ...",
				"You can always ask me about your current rank and about the privileges the ranks grant to those who hold them."
			}, cid)
			setPlayerStorageValue(cid, Storage.OutfitQuest.NightmareOutfit, 1)
			--player:addAchievement('Nightmare Knight')
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 3 then
			if doPlayerRemoveItem(cid, 6500, 500) then				
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				setPlayerStorageValue(cid, Storage.OutfitQuest.NightmareOutfit, 2)
				selfSay("You advanced to {Initiate} rank! You are now able to use teleports of second floor of Knightwatch Tower.", cid)
			else
				selfSay("Come back when you gather all essences.", cid)
			end
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 4 then
			if doPlayerRemoveItem(cid, 6500, 1000) then
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				setPlayerStorageValue(cid, Storage.OutfitQuest.NightmareOutfit, 3)				
				doPlayerAddItem(cid, 6391, 1)
				--player:addAchievement('Nightmare Walker')
				selfSay("You advanced to {Dreamer} rank!", cid)
			else
				selfSay("Come back when you gather all essences.", cid)
			end
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 5 then
			if doPlayerRemoveItem(cid, 6500, 1500) then
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				setPlayerStorageValue(cid, Storage.OutfitQuest.NightmareOutfit, 4)
				setPlayerStorageValue(cid, Storage.OutfitQuest.NightmareDoor, 1)
				setPlayerStorageValue(cid, Storage.KnightwatchTowerDoor, 1)
				--player:addAchievement('Lord Protector')
				selfSay("You advanced to {Lord Protector} rank! You are now able to use teleports of fourth floor of Knightwatch Tower and to create addon scrolls.", cid)
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
