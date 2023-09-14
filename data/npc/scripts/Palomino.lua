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

	if msgcontains(msg, 'transport') then
		selfSay('We can bring you to Venore with one of our coaches for 125 gold. Are you interested?', cid)
		talkState[talkUser] = 1
	elseif isInArray({'rent', 'horses'}, msg) then
		selfSay('Do you want to rent a horse for one day at a price of 500 gold?', cid)
		talkState[talkUser] = 2
	elseif msgcontains(msg, 'yes') then
		
		if talkState[talkUser] == 1 then
			if player:isPzLocked() then
				selfSay('First get rid of those blood stains!', cid)
				return true
			end

			if not doPlayerRemoveMoney(cid, 125) then
				selfSay('You don\'t have enough money.', cid)
				return true
			end

			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			local destination = Position(32850, 32124, 7)
			player:teleportTo(destination)
			destination:sendMagicEffect(CONST_ME_TELEPORT)
			selfSay('Have a nice trip!', cid)
		elseif talkState[talkUser] == 2 then
			if getPlayerStorageValue(cid, Storage.RentedHorseTimer) >= os.time() then
				selfSay('You already have a horse.', cid)
				return true
			end

			if not doPlayerRemoveMoney(cid, 500) then
				selfSay('You do not have enough money to rent a horse!', cid)
				return true
			end

			local mountId = {22, 25, 26}
			player:addMount(mountId[math.random(#mountId)])
			setPlayerStorageValue(cid, Storage.RentedHorseTimer, os.time() + 86400)
			--player:addAchievement('Natural Born Cowboy')
			selfSay('I\'ll give you one of our experienced ones. Take care! Look out for low hanging branches.', cid)
		end
		talkState[talkUser] = 0
	elseif msgcontains(msg, 'no') and talkState[talkUser] > 0 then
		selfSay('Then not.', cid)
		talkState[talkUser] = 0
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, 'Salutations, |PLAYERNAME| I guess you are here for the {horses}.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
