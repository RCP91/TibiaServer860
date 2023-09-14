local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = { {text = 'Gems and jewellery! Best prices in town!'} }
--npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	if msgcontains(msg, "addon") or msgcontains(msg, "outfit") or msgcontains(msg, "hat") then
		local addonProgress = getPlayerStorageValue(cid, Storage.OutfitQuest.Citizen.AddonHat)
		if addonProgress < 1 then
			selfSay("Pretty, isn't it? My friend Amber taught me how to make it, but I could help you with one if you like. What do you say?", cid)
			talkState[talkUser] = 1
		elseif addonProgress == 1 then
			selfSay("Oh, you're back already? Did you bring a legion helmet, 100 chicken feathers and 50 honeycombs?", cid)
			talkState[talkUser] = 2
		elseif addonProgress == 2 then
			selfSay('Pretty hat, isn\'t it?', cid)
		end
		return true
	end

	if talkState[talkUser] == 1 then
		if msgcontains(msg, 'yes') then
			setPlayerStorageValue(cid, Storage.OutfitQuest.Ref, math.max(0, getPlayerStorageValue(cid, Storage.OutfitQuest.Ref)) + 1)
			setPlayerStorageValue(cid, Storage.OutfitQuest.Citizen.AddonHat, 1)
			setPlayerStorageValue(cid, Storage.OutfitQuest.Citizen.MissionHat, 1)
			selfSay('Okay, here we go, listen closely! I need a few things... a basic hat of course, maybe a legion helmet would do. Then about 100 chicken feathers... and 50 honeycombs as glue. That\'s it, come back to me once you gathered it!', cid)
		else
			selfSay('Aw, I guess you don\'t like feather hats. No big deal.', cid)
		end
		talkState[talkUser] = 0

	elseif talkState[talkUser] == 2 then
		if msgcontains(msg, 'yes') then
			if getPlayerItemCount(cid, 2480) < 1 then
				selfSay('Sorry, but I can\'t see a legion helmet.', cid)
			elseif getPlayerItemCount(cid, 5890) < 100 then
				selfSay('Sorry, but you don\'t enough chicken feathers.', cid)
			elseif getPlayerItemCount(cid, 5902) < 50 then
				selfSay('Sorry, but you don\'t have enough honeycombs.', cid)
			else
				selfSay('Great job! That must have taken a lot of work. Okay, you put it like this... then glue like this... here!', cid)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)

				doPlayerRemoveItem(cid, 2480, 1)
				doPlayerRemoveItem(cid, 5902, 50)
				doPlayerRemoveItem(cid, 5890, 100)

				doPlayerAddOutfit(cid, 136, 2)
				doPlayerAddOutfit(cid, 128, 2)

				setPlayerStorageValue(cid, Storage.OutfitQuest.Ref, math.min(0, getPlayerStorageValue(cid, Storage.OutfitQuest.Ref) - 1))
				setPlayerStorageValue(cid, Storage.OutfitQuest.Citizen.MissionHat, 0)
				setPlayerStorageValue(cid, Storage.OutfitQuest.Citizen.AddonHat, 2)
			end
		else
			selfSay('Maybe another time.', cid)
		end
		talkState[talkUser] = 0
	end

	return true
end

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I am a jeweler. Maybe you want to have a look at my wonderful offers.'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'I am Hanna.'})

npcHandler:setMessage(MESSAGE_GREET, 'Oh, please come in, |PLAYERNAME|. What do you need? Have a look at my wonderful {offers} in gems and jewellery.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Good bye.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
