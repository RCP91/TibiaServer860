 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local count = {}
local transfer = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{ text = "Get your shovels, ropes and torches here!" },
	{ text = "Do you need health potions, young knight? All the potions you could wish for are here!" },
	{ text = "Aaaaaall basic equipment for your adventure at Raffael's!" },
	{ text = "If you don't want to spend your money, I can also deposit it on your bank account for you. Or even better, withdraw it so you can shop!" },
	{ text = "Lost in the dark and out of mana to cast a light spell? Buy a torch now!" },
	{ text = "Cheapest offers on the whole island! - Well, the only offers!" },
	{ text = "Special offers for premium customers!" },
	{ text = "Don't leave for mainland without stopping by!" }
}

--npcHandler:addModule(VoiceModule:new(voices))

local function greetCallback(cid)
	count[cid], transfer[cid] = nil, nil
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	
---------------------------- help ------------------------
	if msgcontains(msg, 'bank account') then
		selfSay({
			'Every Tibian has one. The big advantage is that you can access your money in every branch of the Tibian Bank! ...',
			'Would you like to know more about the {basic} functions of your bank account, the {advanced} functions, or are you already bored, perhaps?'
		}, cid)
		talkState[talkUser] = 0
		return true
---------------------------- balance ---------------------
	elseif msgcontains(msg, 'balance') then
		talkState[talkUser] = 0
		if getPlayerBalance(cid) >= 100000000 then
			selfSay('I think you must be one of the richest inhabitants in the world! Your account balance is ' .. getPlayerBalance(cid) .. ' gold.', cid)
			return true
		elseif getPlayerBalance(cid) >= 10000000 then
			selfSay('You have made ten millions and it still grows! Your account balance is ' .. getPlayerBalance(cid) .. ' gold.', cid)
			return true
		elseif getPlayerBalance(cid) >= 1000000 then
			selfSay('Wow, you have reached the magic number of a million gp!!! Your account balance is ' .. getPlayerBalance(cid) .. ' gold!', cid)
			return true
		elseif getPlayerBalance(cid) >= 100000 then
			selfSay('You certainly have made a pretty penny. Your account balance is ' .. getPlayerBalance(cid) .. ' gold.', cid)
			return true
		else
			selfSay('Your account balance is ' .. getPlayerBalance(cid) .. ' gold.', cid)
			return true
		end
---------------------------- deposit ---------------------
	elseif msgcontains(msg, 'deposit') then
		if (Player.getExhaustion(player, 494934) > 0) then
            selfSay('You need to wait a time before try deposit.', cid)
            talkState[talkUser] = 0
            return false
        end

		count[cid] = getPlayerBalance(cid)
		if count[cid] < 1 then
			selfSay('You do not have enough gold.', cid)
			talkState[talkUser] = 0
			return false
		end
		if msgcontains(msg, 'all') then
			count[cid] = getPlayerBalance(cid)
			selfSay('Would you really like to deposit ' .. count[cid] .. ' gold?', cid)
			talkState[talkUser] = 2
			return true
		else
			if string.match(msg,'%d+') then
				count[cid] = getMoneyCount(msg)
				if count[cid] < 1 then
					selfSay('You do not have enough gold.', cid)
					talkState[talkUser] = 0
					return false
				end
				selfSay('Would you really like to deposit ' .. count[cid] .. ' gold?', cid)
				talkState[talkUser] = 2
				return true
			else
				selfSay('Please tell me how much gold it is you would like to deposit.', cid)
				talkState[talkUser] = 1
				return true
			end
		end
		if not isValidMoney(count[cid]) then
			selfSay('Sorry, but you can\'t deposit that much.', cid)
			talkState[talkUser] = 0
			return false
		end
	elseif talkState[talkUser] == 1 then
		count[cid] = getMoneyCount(msg)
		if isValidMoney(count[cid]) then
			selfSay('Would you really like to deposit ' .. count[cid] .. ' gold?', cid)
			talkState[talkUser] = 2
			return true
		else
			selfSay('You do not have enough gold.', cid)
			talkState[talkUser] = 0
			return true
		end
	elseif talkState[talkUser] == 2 then
		if msgcontains(msg, 'yes') then
			if getPlayerBalance(cid) + getPlayerBalance(cid) >= tonumber(count[cid]) then
				player:depositMoney(count[cid])
				selfSay('Alright, we have added the amount of ' .. count[cid] .. ' gold to your {balance}. You can {withdraw} your money anytime you want to.', cid)
				Player.setExhaustion(player, 494934, 2)
			else
				selfSay('You do not have enough gold.', cid)
			end
		elseif msgcontains(msg, 'no') then
			selfSay('As you wish. Is there something else I can do for you?', cid)
		end
		talkState[talkUser] = 0
		return true
---------------------------- withdraw --------------------
	elseif msgcontains(msg, 'withdraw') then
		if (Player.getExhaustion(player, 494934) > 0) then
            selfSay('You need to wait a time before try withdraw.', cid)
            talkState[talkUser] = 0
            return false
        end

		if string.match(msg,'%d+') then
			count[cid] = getMoneyCount(msg)
			if isValidMoney(count[cid]) then
				selfSay('Are you sure you wish to withdraw ' .. count[cid] .. ' gold from your bank account?', cid)
				talkState[talkUser] = 7
			else
				selfSay('There is not enough gold on your account.', cid)
				talkState[talkUser] = 0
			end
			return true
		else
			selfSay('Please tell me how much gold you would like to withdraw.', cid)
			talkState[talkUser] = 6
			return true
		end
	elseif talkState[talkUser] == 6 then
		count[cid] = getMoneyCount(msg)
		if isValidMoney(count[cid]) then
			selfSay('Are you sure you wish to withdraw ' .. count[cid] .. ' gold from your bank account?', cid)
			talkState[talkUser] = 7
		else
			selfSay('There is not enough gold on your account.', cid)
			talkState[talkUser] = 0
		end
		return true
	elseif talkState[talkUser] == 7 then
		if msgcontains(msg, 'yes') then
			if player:getFreeCapacity() >= getMoneyWeight(count[cid]) then
				if not player:withdrawMoney(count[cid]) then
					selfSay('There is not enough gold on your account.', cid)
				else
					selfSay('Here you are, ' .. count[cid] .. ' gold. Please let me know if there is something else I can do for you.', cid)
					Player.setExhaustion(player, 494934, 2)
				end
			else
				selfSay('Whoah, hold on, you have no room in your inventory to carry all those coins. I don\'t want you to drop it on the floor, maybe come back with a cart!', cid)
			end
			talkState[talkUser] = 0
		elseif msgcontains(msg, 'no') then
			selfSay('The customer is king! Come back anytime you want to if you wish to {withdraw} your money.', cid)
			talkState[talkUser] = 0
		end
		return true
---------------------------- transfer --------------------
	elseif msgcontains(msg, 'transfer') then
		if (Player.getExhaustion(player, 494934) > 0) then
            selfSay('You need to wait a time before try transfer.', cid)
            talkState[talkUser] = 0
            return false
        end

		selfSay('Please tell me the amount of gold you would like to transfer.', cid)
		talkState[talkUser] = 11
	elseif talkState[talkUser] == 11 then
		count[cid] = getMoneyCount(msg)
		if getPlayerBalance(cid) < count[cid] then
			selfSay('There is not enough gold on your account.', cid)
			talkState[talkUser] = 0
			return true
		end
		if isValidMoney(count[cid]) then
			selfSay('Who would you like transfer ' .. count[cid] .. ' gold to?', cid)
			talkState[talkUser] = 12
		else
			selfSay('There is not enough gold on your account.', cid)
			talkState[talkUser] = 0
		end
	elseif talkState[talkUser] == 12 then
		transfer[cid] = msg
		if player:getName() == transfer[cid] then
			selfSay('Fill in this field with person who receives your gold!', cid)
			talkState[talkUser] = 0
			return true
		end
		if playerExists(transfer[cid]) then
		local arrayDenied = {"accountmanager", "rooksample", "druidsample", "sorcerersample", "knightsample", "paladinsample"}
		    if isInArray(arrayDenied, string.gsub(transfer[cid]:lower(), " ", "")) then
                selfSay('This player does not exist.', cid)
                talkState[talkUser] = 0
                return true
            end
			selfSay('So you would like to transfer ' .. count[cid] .. ' gold to ' .. transfer[cid] .. '?', cid)
			talkState[talkUser] = 13
		else
			selfSay('This player does not exist.', cid)
			talkState[talkUser] = 0
		end
	elseif talkState[talkUser] == 13 then
		if msgcontains(msg, 'yes') then
			if not player:transferMoneyTo(transfer[cid], count[cid]) then
				selfSay('You cannot transfer money to this account.', cid)
			else
				selfSay('Very well. You have transferred ' .. count[cid] .. ' gold to ' .. transfer[cid] ..'.', cid)
				Player.setExhaustion(player, 494934, 2)
				transfer[cid] = nil
			end
		elseif msgcontains(msg, 'no') then
			selfSay('Alright, is there something else I can do for you?', cid)
		end
		talkState[talkUser] = 0
---------------------------- money exchange --------------
	elseif msgcontains(msg, 'change gold') then
		selfSay('How many platinum coins would you like to get?', cid)
		talkState[talkUser] = 14
	elseif talkState[talkUser] == 14 then
		if getMoneyCount(msg) < 1 then
			selfSay('Sorry, you do not have enough gold coins.', cid)
			talkState[talkUser] = 0
		else
			count[cid] = getMoneyCount(msg)
			selfSay('So you would like me to change ' .. count[cid] * 100 .. ' of your gold coins into ' .. count[cid] .. ' platinum coins?', cid)
			talkState[talkUser] = 15
		end
	elseif talkState[talkUser] == 15 then
		if msgcontains(msg, 'yes') then
			if doPlayerRemoveItem(cid, 2148, count[cid] * 100) then
				doPlayerAddItem(cid, 2152, count[cid])
				selfSay('Here you are.', cid)
			else
				selfSay('Sorry, you do not have enough gold coins.', cid)
			end
		else
			selfSay('Well, can I help you with something else?', cid)
		end
		talkState[talkUser] = 0
	elseif msgcontains(msg, 'change platinum') then
		selfSay('Would you like to change your platinum coins into gold or crystal?', cid)
		talkState[talkUser] = 16
	elseif talkState[talkUser] == 16 then
		if msgcontains(msg, 'gold') then
			selfSay('How many platinum coins would you like to change into gold?', cid)
			talkState[talkUser] = 17
		elseif msgcontains(msg, 'crystal') then
			selfSay('How many crystal coins would you like to get?', cid)
			talkState[talkUser] = 19
		else
			selfSay('Well, can I help you with something else?', cid)
			talkState[talkUser] = 0
		end
	elseif talkState[talkUser] == 17 then
		if getMoneyCount(msg) < 1 then
			selfSay('Sorry, you do not have enough platinum coins.', cid)
			talkState[talkUser] = 0
		else
			count[cid] = getMoneyCount(msg)
			selfSay('So you would like me to change ' .. count[cid] .. ' of your platinum coins into ' .. count[cid] * 100 .. ' gold coins for you?', cid)
			talkState[talkUser] = 18
		end
	elseif talkState[talkUser] == 18 then
		if msgcontains(msg, 'yes') then
			if doPlayerRemoveItem(cid, 2152, count[cid]) then
				doPlayerAddItem(cid, 2148, count[cid] * 100)
				selfSay('Here you are.', cid)
			else
				selfSay('Sorry, you do not have enough platinum coins.', cid)
			end
		else
			selfSay('Well, can I help you with something else?', cid)
		end
		talkState[talkUser] = 0
	elseif talkState[talkUser] == 19 then
		if getMoneyCount(msg) < 1 then
			selfSay('Sorry, you do not have enough platinum coins.', cid)
			talkState[talkUser] = 0
		else
			count[cid] = getMoneyCount(msg)
			selfSay('So you would like me to change ' .. count[cid] * 100 .. ' of your platinum coins into ' .. count[cid] .. ' crystal coins for you?', cid)
			talkState[talkUser] = 20
		end
	elseif talkState[talkUser] == 20 then
		if msgcontains(msg, 'yes') then
			if doPlayerRemoveItem(cid, 2152, count[cid] * 100) then
				doPlayerAddItem(cid, 2160, count[cid])
				selfSay('Here you are.', cid)
			else
				selfSay('Sorry, you do not have enough platinum coins.', cid)
			end
		else
			selfSay('Well, can I help you with something else?', cid)
		end
		talkState[talkUser] = 0
	elseif msgcontains(msg, 'change crystal') then
		selfSay('How many crystal coins would you like to change into platinum?', cid)
		talkState[talkUser] = 21
	elseif talkState[talkUser] == 21 then
		if getMoneyCount(msg) < 1 then
			selfSay('Sorry, you do not have enough crystal coins.', cid)
			talkState[talkUser] = 0
		else
			count[cid] = getMoneyCount(msg)
			selfSay('So you would like me to change ' .. count[cid] .. ' of your crystal coins into ' .. count[cid] * 100 .. ' platinum coins for you?', cid)
			talkState[talkUser] = 22
		end
	elseif talkState[talkUser] == 22 then
		if msgcontains(msg, 'yes') then
			if doPlayerRemoveItem(cid, 2160, count[cid])  then
				doPlayerAddItem(cid, 2152, count[cid] * 100)
				selfSay('Here you are.', cid)
			else
				selfSay('Sorry, you do not have enough crystal coins.', cid)
			end
		else
			selfSay('Well, can I help you with something else?', cid)
		end
		talkState[talkUser] = 0
	end
	return true
end

keywordHandler:addKeyword({'money'}, StdModule.say, {npcHandler = npcHandler, text = 'We can {change} money for you. You can also access your {bank account}.'})
keywordHandler:addKeyword({'change'}, StdModule.say, {npcHandler = npcHandler, text = 'There are three different coin types in Tibia: 100 gold coins equal 1 platinum coin, 100 platinum coins equal 1 crystal coin. So if you\'d like to change 100 gold into 1 platinum, simply say \'{change gold}\' and then \'1 platinum\'.'})
keywordHandler:addKeyword({'bank'}, StdModule.say, {npcHandler = npcHandler, text = 'We can {change} money for you. You can also access your {bank account}.'})
keywordHandler:addKeyword({'advanced'}, StdModule.say, {npcHandler = npcHandler, text = 'Your bank account will be used automatically when you want to {rent} a house or place an offer on an item on the {market}. Let me know if you want to know about how either one works.'})
keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = 'You can check the {balance} of your bank account, {deposit} money or {withdraw} it. You can also {transfer} money to other characters, provided that they have a vocation.'})
keywordHandler:addKeyword({'functions'}, StdModule.say, {npcHandler = npcHandler, text = 'You can check the {balance} of your bank account, {deposit} money or {withdraw} it. You can also {transfer} money to other characters, provided that they have a vocation.'})
keywordHandler:addKeyword({'basic'}, StdModule.say, {npcHandler = npcHandler, text = 'You can check the {balance} of your bank account, {deposit} money or {withdraw} it. You can also {transfer} money to other characters, provided that they have a vocation.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I work in this bank. I can change money for you and help you with your bank account.'})

npcHandler:setMessage(MESSAGE_GREET, 'Welcome to the Tibian {bank}, |PLAYERNAME|! What can I do for you?')
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
