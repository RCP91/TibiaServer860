local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local function greetCallback(cid)
	
	if getPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon) == 1 or getPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon) > 3 then
		npcHandler:setMessage(MESSAGE_GREET, "Whatcha do in my place?")
	elseif getPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon) == 2 and getPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddonWaitTimer) < os.time() then
		npcHandler:setMessage(MESSAGE_GREET, "You back. You know, you right. Brother is right. Fist not always good. Tell him that!")
		setPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon, 3)
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	
	-- PREQUEST
	if msgcontains(msg, "mine") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon) == 1 then
			selfSay("YOURS? WHAT IS YOURS! NOTHING IS YOURS! IS MINE! GO AWAY, YES?!", cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, "no") then
		if talkState[talkUser] == 1 then
			selfSay("YOU STUPID! STUBBORN! I KILL YOU! WILL LEAVE NOW?!", cid)
			talkState[talkUser] = 2
		elseif talkState[talkUser] == 2 then
			selfSay("ARRRRRRRRRR! YOU ME DRIVE MAD! HOW I MAKE YOU GO??", cid)
			talkState[talkUser] = 3
		elseif talkState[talkUser] == 3 then
			selfSay("I GIVE YOU NO!", cid)
			talkState[talkUser] = 4
		end
	elseif msgcontains(msg, "please") then
		if talkState[talkUser] == 4 then
			selfSay("Please? What you mean please? Like I say please you say bye? Please?", cid)
			talkState[talkUser] = 5
		end
	-- OUTFIT
	elseif msgcontains(msg, "gelagos") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon) == 4 then
			selfSay("Annoying kid. Bro hates him, but talking no help. Bro needs {fighting spirit}!", cid)
			talkState[talkUser] = 6
		end
	elseif msgcontains(msg, "fighting spirit") then
		if talkState[talkUser] == 6 then
			selfSay("If you want to help bro, bring him fighting spirit. Magic fighting spirit. Ask Djinn.", cid)
			setPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon, 5)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "present") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon) == 11 then
			selfSay("Bron gave me present. Ugly, but nice from him. Me want to give present too. You help me?", cid)
			talkState[talkUser] = 6
		end
	elseif msgcontains(msg, "ore") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon) == 12 then
			selfSay("You bring 100 iron ore?", cid)
			talkState[talkUser] = 8
		end
	elseif msgcontains(msg, "iron") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon) == 13 then
			selfSay("You bring crude iron?", cid)
			talkState[talkUser] = 9
		end
	elseif msgcontains(msg, "fangs") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon) == 14 then
			selfSay("You bring 50 behemoth fangs?", cid)
			talkState[talkUser] = 10
		end
	elseif msgcontains(msg, "leather") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon) == 15 then
			selfSay("You bring 50 lizard leather?", cid)
			talkState[talkUser] = 11
		end
	elseif msgcontains(msg, "axe") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon) == 16 and getPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddonWaitTimer) < os.time() then
			selfSay("Axe is done! For you. Take. Wear like me.", cid)
			setPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon, 17)
			doPlayerAddOutfit(cid, 147, 1)
			doPlayerAddOutfit(cid, 143, 1)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			--player:addAchievement('Brutal Politeness')
		else
			selfSay("Axe is not done yet!", cid)
		end
	-- OUTFIT
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 5 then
			selfSay("Oh. Easy. Okay. Please is good. Now don't say anything. Head aches. ", cid)
			local condition = Condition(CONDITION_FIRE)
			condition:setParameter(CONDITION_PARAM_DELAYED, 1)
			condition:addDamage(10, 2000, -10)
			player:addCondition(condition)
			setPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon, 2)
			setPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddonWaitTimer, os.time() + 60 * 60) -- 1 hour
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		elseif talkState[talkUser] == 6 then
			selfSay({
				"Good! Me make shiny weapon. If you help me, I make one for you too. Like axe I wear. I need stuff. Listen. ...",
				"Me need 100 iron ore. Then need crude iron. Then after that 50 behemoth fangs. And 50 lizard leather. You understand?",
				"Help me yes or no?"
			}, cid)
			talkState[talkUser] = 7
		elseif talkState[talkUser] == 7 then
			selfSay("Good. You get 100 iron ore first. Come back.", cid)
			talkState[talkUser] = 0
			setPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon, 12)
		elseif talkState[talkUser] == 8 then
			if doPlayerRemoveItem(cid, 5880, 100) then
				selfSay("Good! Now bring crude iron.", cid)
				setPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon, 13)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 9 then
			if doPlayerRemoveItem(cid, 5892, 1) then
				selfSay("Good! Now bring 50 behemoth fangs.", cid)
				setPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon, 14)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 10 then
			if doPlayerRemoveItem(cid, 5893, 50) then
				selfSay("Good! Now bring 50 lizard leather.", cid)
				setPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon, 15)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 11 then
			if doPlayerRemoveItem(cid, 5876, 50) then
				selfSay("Ah! All stuff there. I will start making axes now. Come later and ask me for axe.", cid)
				setPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddon, 16)
				setPlayerStorageValue(cid, Storage.OutfitQuest.BarbarianAddonWaitTimer, os.time() + 2 * 60 * 60) -- 2 hours
				talkState[talkUser] = 0
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
