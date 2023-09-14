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
	{ text = 'Deposit your money here in the safety of the Tibian Bank!' },
	{ text = 'Any questions about the functions of your bank account? Feel free to ask me for help!' }
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

-- Basic keywords
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m Paulie.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m still a bank clerk-in-training. They say I can work on the mainland of Tibia once I have proven myself!'})
keywordHandler:addKeyword({'transfer'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m afraid this service is not available to you until you reach mainland.'})
keywordHandler:addKeyword({'change'}, StdModule.say, {npcHandler = npcHandler, text = 'There are three different coin types in Tibia: 100 gold coins equal 1 platinum coin, 100 platinum coins equal 1 crystal coin. For example, if you like to change 100 gold coins into 1 platinum coin, simply say \'{change gold}\' and then \'1 platinum\'.'})
keywordHandler:addKeyword({'advanced'}, StdModule.say, {npcHandler = npcHandler, text = 'Once you are on the Tibian mainland, you can access new functions of your bank account, such as transferring money to other players safely or taking part in house auctions.'})
keywordHandler:addKeyword({'king'}, StdModule.say, {npcHandler = npcHandler, text = 'HAIL TO THE KING!'})
keywordHandler:addKeyword({'academy'}, StdModule.say, {npcHandler = npcHandler, text = 'The academy is the big stone building in the town centre. When you are ready to leave Rookgaard, you should visit the {oracle} there.'})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = 'It\'s exactly |TIME|.'})
keywordHandler:addKeyword({'temple'}, StdModule.say, {npcHandler = npcHandler, text = 'The temple is south of the city. Go there and talk to {Cipfried} if you are in dire need of healing.'})
keywordHandler:addKeyword({'mainland'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m looking forward to work on the mainland. The great Tibian cities are so much more interesting than this little village of {Rookgaard}.'})
keywordHandler:addKeyword({'rookgaard'}, StdModule.say, {npcHandler = npcHandler, text = 'What a godforsaken place! Well, at least there are no criminals robbing the bank which would be - me. <gulp>'})
keywordHandler:addKeyword({'premium'}, StdModule.say, {npcHandler = npcHandler, text = 'Another excellent way of investing your money.'})

keywordHandler:addKeyword({'trade'}, StdModule.say, {npcHandler = npcHandler, text = 'I don\'t trade. Ask the shop owners for a trade instead. I can only help you with your {bank account}.'})
keywordHandler:addAliasKeyword({'offer'})
keywordHandler:addAliasKeyword({'potion'})
keywordHandler:addAliasKeyword({'sell'})
keywordHandler:addAliasKeyword({'buy'})
keywordHandler:addAliasKeyword({'stuff'})
keywordHandler:addAliasKeyword({'wares'})
keywordHandler:addAliasKeyword({'weapon'})
keywordHandler:addAliasKeyword({'equip'})
keywordHandler:addAliasKeyword({'food'})
keywordHandler:addAliasKeyword({'armor'})
keywordHandler:addAliasKeyword({'shield'})

keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = 'Every Tibian has a bank account. You can {deposit} your gold in one bank and {withdraw} it from the same or any other Tibian bank. Ask me for your {balance} to learn how much money you\'ve already saved. There are also {advanced} functions.'})
keywordHandler:addAliasKeyword({'function'})
keywordHandler:addAliasKeyword({'account'})

keywordHandler:addKeyword({'bank'}, StdModule.say, {npcHandler = npcHandler, text = 'You can {deposit} and {withdraw} money from your {bank account} here. I can also {change} money for you.'})
keywordHandler:addAliasKeyword({'money'})

-- Names
keywordHandler:addKeyword({'zerbrus'}, StdModule.say, {npcHandler = npcHandler, text = 'Thank god that guy guards our bridge. Without him, I believe all sorts of critters would storm the bank!'})
keywordHandler:addAliasKeyword({'dallheim'})
keywordHandler:addKeyword({'al', 'dee'}, StdModule.say, {npcHandler = npcHandler, text = 'He sells general equipment such as ropes or torches.'})
keywordHandler:addKeyword({'amber'}, StdModule.say, {npcHandler = npcHandler, text = '<blushes> It\'s making me nervous to have her around my working place all the time. Actually it\'s distracting, but I can\'t say why.'})
keywordHandler:addKeyword({'billy'}, StdModule.say, {npcHandler = npcHandler, text = 'A fine cook and farmer.'})
keywordHandler:addKeyword({'willie'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s incredibly rude! I don\'t know what I\'ve done to him. Well, he buys and sells {food}.'})
keywordHandler:addKeyword({'tom'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s the local tanner. You could try selling fresh corpses or leather to him and then bring the earnt money to our {bank}.'})
keywordHandler:addKeyword({'seymour'}, StdModule.say, {npcHandler = npcHandler, text = 'A well-educated man.'})
keywordHandler:addKeyword({'zirella'}, StdModule.say, {npcHandler = npcHandler, text = 'She\'s a nice old lady, but I guess she prefers keeping her savings in one of her socks. She never comes to my bank.'})
keywordHandler:addKeyword({'santiago'}, StdModule.say, {npcHandler = npcHandler, text = 'Just a fisherman living outside the village.'})
keywordHandler:addKeyword({'paulie'}, StdModule.say, {npcHandler = npcHandler, text = 'That\'s me, in all my beauty! <coughs>'})
keywordHandler:addKeyword({'oracle'}, StdModule.say, {npcHandler = npcHandler, text = 'You can find the oracle on the top floor of the {academy}, just above {Seymour}. Go there when you are level 8.'})
keywordHandler:addKeyword({'obi'}, StdModule.say, {npcHandler = npcHandler, text = 'He sells {weapons}. His shop is south west of town, close to the {temple}.'})
keywordHandler:addKeyword({'norma'}, StdModule.say, {npcHandler = npcHandler, text = 'Going to her bar is not so much my cup of tea... I prefer reading a good book about economy.'})
keywordHandler:addKeyword({'loui'}, StdModule.say, {npcHandler = npcHandler, text = 'I don\'t know that guy.'})
keywordHandler:addKeyword({'lily'}, StdModule.say, {npcHandler = npcHandler, text = 'Lily sells {potions} in the South of town.'})
keywordHandler:addKeyword({'lee\'delle'}, StdModule.say, {npcHandler = npcHandler, text = 'Her shop is on the {premium} side of town. She has really good offers.'})
keywordHandler:addKeyword({'hyacinth'}, StdModule.say, {npcHandler = npcHandler, text = 'Hm, I\'ve never seen him. He\'s supposed to be a druid.'})
keywordHandler:addKeyword({'dixi'}, StdModule.say, {npcHandler = npcHandler, text = 'She\'s {Obi\'s} granddaughter and deals with {armors} and {shields}. Her shop is southwest of town, close to the {temple}.'})
keywordHandler:addKeyword({'cipfried'}, StdModule.say, {npcHandler = npcHandler, text = 'He guards the temple and can heal you if you are badly injured or poisoned.'})

npcHandler:setMessage(MESSAGE_GREET, 'Welcome |PLAYERNAME|! Here, you can {deposit} or {withdraw} your money from your bank account and {change} gold. I can also explain the {functions} of your bank account to you.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye, and remember: entrusting us with your gold is the safest way of storing it!')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Good bye.')
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
