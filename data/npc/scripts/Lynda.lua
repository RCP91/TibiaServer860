local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
    end
    
    
    
	if msgcontains(msg, "angelina") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.MageSummoner.AddonWand) == 1 then
			selfSay({
				"Angelina had been imprisoned? My, these are horrible news, but I am so glad to hear that she is safe now. ...",
				"I will happily carry out her wish and reward you, but I fear I need some important ingredients for my blessing spell first. ...",
				"Will you gather them for me?"
			}, cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, "wand") or msgcontains(msg, "rod") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.MageSummoner.AddonWand) == 2 then
			selfSay("Did you bring a sample of each wand and each rod with you?", cid)
			talkState[talkUser] = 3
		end
	elseif msgcontains(msg, "sulphur") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.MageSummoner.AddonWand) == 3 then
			selfSay("Did you obtain 10 ounces of magic sulphur?", cid)
			talkState[talkUser] = 4
		end
	elseif msgcontains(msg, "soul stone") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.MageSummoner.AddonWand) == 4 then
			selfSay("Were you actually able to retrieve the Necromancer's soul stone?", cid)
			talkState[talkUser] = 5
		end
	elseif msgcontains(msg, "ankh") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.MageSummoner.AddonWand) == 5 then
			selfSay("Am I sensing enough holy energy from ankhs here?", cid)
			talkState[talkUser] = 6
        end
    elseif msgcontains(msg, "ritual") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.MageSummoner.AddonWand) == 6 then
            if getPlayerStorageValue(cid, Storage.OutfitQuest.MageSummoner.AddonWandTimer) < os.time() then
                setPlayerStorageValue(cid, Storage.OutfitQuest.MageSummoner.AddonWand, 7)
				doPlayerAddOutfit(cid, 141, 1)
				doPlayerAddOutfit(cid, 130, 1)
                player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
                selfSay('I\'m glad to tell you that I have finished the ritual, player. Here is your new wand. I hope you carry it proudly for everyone to see..', cid)
                talkState[talkUser] = 0
			else
				selfSay('Please let me focus for a while, |PLAYERNAME|.', cid)
			end
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			selfSay({
				"Thank you, I promise that your efforts won't be in vain! Listen closely now: First, I need a sample of five druid rods and five sorcerer wands. ...",
				"I need a snakebite rod, a moonlight rod, a necrotic rod, a terra rod and a hailstorm rod. Then, I need a wand of vortex, a wand of dragonbreath ...",
				"... a wand of decay, a wand of cosmic energy and a wand of inferno. Please bring them all at once so that their energy will be balanced. ...",
				"Secondly, I need 10 ounces of magic sulphur. It can absorb the elemental energy of all the wands and rods and bind it to something else. ...",
				"Next, I will need a soul stone. These can be used as a vessel for energy, evil as well as good. They are rarely used nowaday though. ...",
				"Lastly, I need a lot of holy energy. I can extract it from ankhs, but only a small amount each time. I will need about 20 ankhs. ...",
				"Did you understand everything I told you and will help me with my blessing?"
			}, cid)
			talkState[talkUser] = 2
		elseif talkState[talkUser] == 2 then
			selfSay("Alright then. Come back to with a sample of all five wands and five rods, please.", cid)
			setPlayerStorageValue(cid, Storage.OutfitQuest.MageSummoner.AddonWand, 2)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 3 then
			if  getPlayerItemCount(cid, 2181) > 0 and getPlayerItemCount(cid, 2182) > 0 and getPlayerItemCount(cid, 2183) > 0 and getPlayerItemCount(cid, 2185) > 0 and getPlayerItemCount(cid, 2186) > 0 and getPlayerItemCount(cid, 2187) > 0 and getPlayerItemCount(cid, 2188) > 0 and getPlayerItemCount(cid, 2189) > 0 and getPlayerItemCount(cid, 2190) > 0 and getPlayerItemCount(cid, 2191) > 0 then
				selfSay("Thank you, that must have been a lot to carry. Now, please bring me 10 ounces of magic sulphur.", cid)
				doPlayerRemoveItem(cid, 2181, 1)
				doPlayerRemoveItem(cid, 2182, 1)
				doPlayerRemoveItem(cid, 2183, 1)
				doPlayerRemoveItem(cid, 2185, 1)
				doPlayerRemoveItem(cid, 2186, 1)
				doPlayerRemoveItem(cid, 2187, 1)
				doPlayerRemoveItem(cid, 2188, 1)
				doPlayerRemoveItem(cid, 2189, 1)
				doPlayerRemoveItem(cid, 2190, 1)
				doPlayerRemoveItem(cid, 2191, 1)
				setPlayerStorageValue(cid, Storage.OutfitQuest.MageSummoner.AddonWand, 3)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 4 then
			if doPlayerRemoveItem(cid, 5904, 10) then
				selfSay("Very good. I will immediately start to prepare the ritual and extract the elemental energy from the wands and rods. Please bring me the Necromancer's soul stone now.", cid)
				setPlayerStorageValue(cid, Storage.OutfitQuest.MageSummoner.AddonWand, 4)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 5 then
			if doPlayerRemoveItem(cid, 5809, 1) then
				selfSay("You have found a rarity there, |PLAYERNAME|. This will become the tip of your blessed wand. Please bring me 20 ankhs now to complete the ritual.", cid)
				setPlayerStorageValue(cid, Storage.OutfitQuest.MageSummoner.AddonWand, 5)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 6 then
			if doPlayerRemoveItem(cid, 2193, 20) then
                selfSay("The ingredients for the ritual are complete! I will start to prepare your blessed wand, but I have to medidate first. Please come back later to hear how the ritual went.", cid)
                setPlayerStorageValue(cid, Storage.OutfitQuest.MageSummoner.AddonWand, 6)
                setPlayerStorageValue(cid, Storage.OutfitQuest.MageSummoner.AddonWandTimer, os.time() + 10800)
				talkState[talkUser] = 0
			end
        end
    end
end

local function confirmWedding(cid, message, keywords, parameters, node)
    if(not npcHandler:isFocused(cid)) then
        return false
    end

    
    local playerStatus = getPlayerMarriageStatus(player:getGuid())
    local candidate = getPlayerSpouse(player:getGuid())
    if playerStatus == PROPACCEPT_STATUS then
      --  local item3 = Item(doPlayerAddItem(cid,ITEM_Meluna_Ticket,2))
        setPlayerMarriageStatus(player:getGuid(), MARRIED_STATUS)
        setPlayerMarriageStatus(candidate, MARRIED_STATUS)
        setPlayerSpouse(player:getGuid(), candidate)
        setPlayerSpouse(candidate, player:getGuid())
        delayedSay('Dear friends and family, we are gathered here today to witness and celebrate the union of ' .. getPlayerNameById(candidate) .. ' and ' .. player:getName() .. ' in marriage.')
        delayedSay('Through their time together, they have come to realize that their personal dreams, hopes, and goals are more attainable and more meaningful through the combined effort and mutual support provided in love, commitment, and family;',5000)
        delayedSay('and so they have decided to live together as husband and wife. And now, by the power vested in me by the Gods of Tibia, I hereby pronounce you husband and wife.',15000)
        delayedSay('*After a whispered blessing opens an hand towards ' .. player:getName() .. '* Take these two engraved wedding rings and give one of them to your spouse.',22000)
        delayedSay('You may now kiss your bride.',28000)
        local item1 = Item(doPlayerAddItem(cid,ITEM_ENGRAVED_WEDDING_RING,1))
        local item2 = Item(doPlayerAddItem(cid,ITEM_ENGRAVED_WEDDING_RING,1))
        item1:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, player:getName() .. ' & ' .. getPlayerNameById(candidate) .. ' forever - married on ' .. os.date('%B %d, %Y.'))
        item2:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, player:getName() .. ' & ' .. getPlayerNameById(candidate) .. ' forever - married on ' .. os.date('%B %d, %Y.'))
    else
        selfSay('Your partner didn\'t accept your proposal, yet', cid)
    end
    return true
end
		-- END --
local function confirmRemoveEngage(cid, message, keywords, parameters, node)
    if(not npcHandler:isFocused(cid)) then
        return false
    end

    
    local playerStatus = getPlayerMarriageStatus(player:getGuid())
    local playerSpouse = getPlayerSpouse(player:getGuid())
    if playerStatus == PROPOSED_STATUS then

        selfSay('Are you sure you want to remove your wedding proposal with {' .. getPlayerNameById(playerSpouse) .. '}?', cid)
        node:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, moveup = 3, text = 'Ok, let\'s keep it then.'})

        local function removeEngage(cid, message, keywords, parameters, node)
            doPlayerAddItem(cid,ITEM_WEDDING_RING,1)
       doPlayerAddItem(cid,10503,1)
            setPlayerMarriageStatus(player:getGuid(), 0)
            setPlayerSpouse(player:getGuid(), -1)
            selfSay(parameters.text, cid)
            keywordHandler:moveUp(parameters.moveup)
        end
        node:addChildKeyword({'yes'}, removeEngage, {moveup = 3, text = 'Ok, your marriage proposal to {' .. getPlayerNameById(playerSpouse) .. '} has been removed. Take your wedding ring back.'})
    else
        selfSay('You don\'t have any pending proposal to be removed.', cid)
        keywordHandler:moveUp(2)
    end
    return true
end

local function confirmDivorce(cid, message, keywords, parameters, node)
    if(not npcHandler:isFocused(cid)) then
        return false
    end

    
    local playerStatus = getPlayerMarriageStatus(player:getGuid())
    local playerSpouse = getPlayerSpouse(player:getGuid())
    if playerStatus == MARRIED_STATUS then
        selfSay('Are you sure you want to divorce of {' .. getPlayerNameById(playerSpouse) .. '}?', cid)
        node:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, moveup = 3, text = 'Great! Marriages should be an eternal commitment.'})

        local function divorce(cid, message, keywords, parameters, node)
            
            local spouse = getPlayerSpouse(player:getGuid())
            setPlayerMarriageStatus(player:getGuid(), 0)
            setPlayerSpouse(player:getGuid(), -1)
            setPlayerMarriageStatus(spouse, 0)
            setPlayerSpouse(spouse, -1)
            selfSay(parameters.text, cid)
            keywordHandler:moveUp(parameters.moveup)
        end
        node:addChildKeyword({'yes'}, divorce, {moveup = 3, text = 'Ok, you are now divorced of {' .. getPlayerNameById(playerSpouse) .. '}. Think better next time after marrying someone.'})
    else
        selfSay('You aren\'t married to get a divorce.', cid)
        keywordHandler:moveUp(2)
    end
    return true
end

local node1 = keywordHandler:addKeyword({'marry'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Would you like to get married? Make sure you have a wedding ring and the wedding outfit box with you.'})
node1:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, moveup = 1, text = 'That\'s fine.'})
local node2 = node1:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'And who would you like to marry?'})
node2:addChildKeyword({'[%w]'}, tryEngage, {})

local node3 = keywordHandler:addKeyword({'celebration'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Is your soulmate and friends here with you for the celebration?.'})
node3:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, moveup = 1, text = 'Then go bring them here!.'})
local node4 = node3:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Good, let\'s {begin} then!.'}) --, confirmWedding, {})
node4:addChildKeyword({'begin'}, confirmWedding, {})

keywordHandler:addKeyword({'remove'}, confirmRemoveEngage, {})

keywordHandler:addKeyword({'divorce'}, confirmDivorce, {})

npcHandler:setMessage(MESSAGE_GREET, "Welcome in the name of the gods, pilgrim |PLAYERNAME|!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Be careful on your journeys.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Be careful on your journeys.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())