local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{ text = 'Great spirit potions as well as health and mana potions in different sizes!' },
	{ text = 'If you need alchemical fluids like slime and blood, get them here.' }
}

--npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	
	if isInArray({"vial", "ticket", "bonus", "deposit"}, msg) then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.MageSummoner.AddonBelt) < 1 then
			selfSay("You have "..getPlayerStorageValue(cid, 38412).." credits. We have a special offer right now for depositing vials. Are you interested in hearing it?", cid)
			talkState[talkUser] = 1
		elseif getPlayerStorageValue(cid, Storage.OutfitQuest.MageSummoner.AddonBelt) >= 1 then
			selfSay("Would you like to get a lottery ticket instead of the deposit for your vials?", cid)
			talkState[talkUser] = 3
		end
	elseif msgcontains(msg, "prize") then
		selfSay("Are you here to claim a prize?", cid)
		talkState[talkUser] = 4
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			selfSay({
				"The Edron academy has introduced a bonus system. Each time you deposit 100 vials without claiming the money for it, you will receive a lottery ticket. ...",
				"Some of these lottery tickets will grant you a special potion belt accessory, if you bring the ticket to me. ...",
				"If you join the bonus system now, I will ask you each time you are bringing back 100 or more vials to me whether you claim your deposit or rather want a lottery ticket. ...",
				"Of course, you can leave or join the bonus system at any time by just asking me for the 'bonus'. ...",
				"Would you like to join the bonus system now?"
			}, cid)
			talkState[talkUser] = 2
		elseif talkState[talkUser] == 2 then
			selfSay("Great! I've signed you up for our bonus system. From now on, you will have the chance to win the potion belt addon!", cid)
			setPlayerStorageValue(cid, Storage.OutfitQuest.MageSummoner.AddonBelt, 1)
			setPlayerStorageValue(cid, Storage.OutfitQuest.DefaultStart, 1) --this for default start of Outfit and Addon Quests
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 3 then
			if getPlayerStorageValue(cid, 38412) >= 100 or doPlayerRemoveItem(cid, 7634, 100) or doPlayerRemoveItem(cid, 7635, 100) or doPlayerRemoveItem(cid, 7636, 100) then
				selfSay("Alright, thank you very much! Here is your lottery ticket, good luck. Would you like to deposit more vials that way?", cid)
				setPlayerStorageValue(cid, 38412, getPlayerStorageValue(cid, 38412)-100);
				doPlayerAddItem(cid, 5957, 1)
				talkState[talkUser] = 0
			else
				selfSay("Sorry, but you don't have 100 empty flasks or vials of the SAME kind and thus don't qualify for the lottery. Would you like to deposit the vials you have as usual and receive 5 gold per vial?", cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 4 then
			if getPlayerStorageValue(cid, Storage.OutfitQuest.MageSummoner.AddonBelt) == 1 and doPlayerRemoveItem(cid, 5958, 1) then
				selfSay("Congratulations! Here, from now on you can wear our lovely potion belt as accessory.", cid)
				setPlayerStorageValue(cid, Storage.OutfitQuest.MageSummoner.AddonBelt, 2)
				doPlayerAddOutfit(cid, 138, 1)
				doPlayerAddOutfit(cid, 133, 1)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			else
				selfSay("Sorry, but you don't have your lottery ticket with you.... or not signed in bonus system", cid)
			end
			talkState[talkUser] = 0
		end
		return true
	end
end

keywordHandler:addKeyword({'shop'}, StdModule.say, {npcHandler = npcHandler, text = 'I sell potions and fluids. If you\'d like to see my offers, ask me for a {trade}.'})

npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|, welcome to the fluid and potion {shop} of Edron.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye, |PLAYERNAME|, please come back soon.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye, |PLAYERNAME|, please come back soon.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Of course, just browse through my wares. By the way, if you'd like to join our bonus system for depositing flasks and vial, you have to tell me about that {deposit}.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
