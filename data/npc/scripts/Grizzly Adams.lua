 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local choose = {}
local cancel = {}
local available = {}

local grizzlyAdamsConfig = {
	ranks = {
		--NOTE: The variable 'name' is not necessary to be declared. I let it so people who wants to change the script will now wich item is each one.
		huntsMan_rank = {
			-- SELL OFFERS
			{id=11214, buy=0, sell=50, name='antlers'},
			{id=10550, buy=0, sell=100, name='bloody pincers'},
			{id=11189, buy=0, sell=35, name='crab pincers'},
			{id=10574, buy=0, sell=55, name='cyclops toe'},
			{id=13303, buy=0, sell=550, name="cavebear skull"},
			{id=20098, buy=0, sell=150, name="cheesy figurine"},
			{id=12470, buy=0, sell=110, name="colourful feather"},
			{id=7398, buy=0, sell=500, name='cyclops trophy'},
			{id=11315, buy=0, sell=15000, name='draken trophy'},
			{id=13296, buy=0, sell=800, name='draptor scales'},
			{id=21311, buy=0, sell=115, name='elven hoof'},
			{id=10565, buy=0, sell=30, name='frosty ear of a troll'},
			{id=13304, buy=0, sell=950, name='giant crab pincer'},
			{id=12495, buy=0, sell=20, name='goblin ear'},
			{id=13301, buy=0, sell=400, name='hollow stampor hoof'},
			{id=11199, buy=0, sell=600, name='hydra head'},
			{id=11372, buy=0, sell=80, name='lancer beetle shell'},
			{id=11336, buy=0, sell=8000, name='lizard trophy'},
			{id=12445, buy=0, sell=280, name='mantassin tail'},
			{id=19741, buy=0, sell=65, name='marsh stalker beak'},
			{id=19742, buy=0, sell=50, name='marsh stalker feather'},
			{id=13302, buy=0, sell=250, name='maxilla'},
			{id=7401, buy=0, sell=500, name='minotaur trophy'},
			{id=10579, buy=0, sell=420, name='mutated bat ear'},
			{id=13026, buy=0, sell=750, name='panther head'},
			{id=13027, buy=0, sell=300, name='panther paw'},
			{id=12447, buy=0, sell=500, name='quara bone'},
			{id=12447, buy=0, sell=350, name='quara eye'},
			{id=12446, buy=0, sell=410, name='quara pincers'},
			{id=12443, buy=0, sell=140, name='quara tentacle'},
			{id=13159, buy=0, sell=50, name='rabbit\'s foot'},
			{id=21310, buy=0, sell=70, name='rorc feather'},
			{id=11228, buy=0, sell=400, name='sabretooth'},
			{id=11373, buy=0, sell=20, name='sandcrawler shell'},
			{id=10548, buy=0, sell=280, name='scarab pincers'},
			{id=13299, buy=0, sell=280, name='stampor horn'},
			{id=13300, buy=0, sell=150, name='stampor talons'},
			{id=11371, buy=0, sell=60, name='terramite legs'},
			{id=11369, buy=0, sell=170, name='terramite shell'},
			{id=11190, buy=0, sell=95, name='terrorbird beak'},
			-- BUY OFFERS
			{id=5907, buy=35000, sell=0, name='slingshot'}
		},

		bigGameHunter_rank = {
			{id=11161, buy=0, sell=6000, name='bonebeast trophy'},
			{id=7397, buy=0, sell=3000, name='deer trophy'},
			{id=7400, buy=0, sell=3000, name='lion trophy'},
			{id=7395, buy=0, sell=1000, name='orc trophy'},
			{id=7394, buy=0, sell=3000, name='wolf trophy'}
		},

		trophyHunter_rank = {
			-- SELL OFFERS
			{id=7396, buy=0, sell=20000, name='behemoth trophy'},
			{id=7393, buy=0, sell=40000, name='demon trophy'},
			{id=7399, buy=0, sell=10000, name='dragon lord trophy'},
			-- BUY OFFERS
			{id=10518, buy=1000, sell=0, name='demon backpack'},
		},
	}
}

local items, data = {}
for i = 1, #grizzlyAdamsConfig.ranks.huntsMan_rank do
	data = grizzlyAdamsConfig.ranks.huntsMan_rank[i]
	items[data.id] = {id = data.id, buy = data.buy, sell = data.sell, name = ItemType(data.id):getName():lower()}
end
for i = 1, #grizzlyAdamsConfig.ranks.bigGameHunter_rank do
	data = grizzlyAdamsConfig.ranks.bigGameHunter_rank[i]
	items[data.id] = {id = data.id, buy = data.buy, sell = data.sell, name = ItemType(data.id):getName():lower()}
end
for i = 1, #grizzlyAdamsConfig.ranks.trophyHunter_rank do
	data = grizzlyAdamsConfig.ranks.trophyHunter_rank[i]
	items[data.id] = {id = data.id, buy = data.buy, sell = data.sell, name = ItemType(data.id):getName():lower()}
end

local function greetCallback(cid)
	
	if getPlayerStorageValue(cid, JOIN_STOR) == -1 then
		npcHandler:setMessage(MESSAGE_GREET, 'Welcome |PLAYERNAME|. Would you like to join the \'Paw and Fur - Hunting Elite\'?')
	else
		npcHandler:setMessage(MESSAGE_GREET, 'Welcome back old chap. What brings you here this time?')
	end
	return true
end

local function getTradeItems(t)
	local list, obj = {}
	for i = 1, #t do
		obj = t[i]
		list[obj.id] = {id = obj.id, buy = obj.buy, sell = obj.sell, name = ItemType(obj.id):getName():lower()}
	end
	return list
end

local function joinTables(old, new)
	for k, v in pairs(new) do
		old[#old+1] = v
	end
	return old
end

local function onBuy(cid, item, subType, amount, ignoreCap, inBackpacks)
	
	if not ignoreCap and player:getFreeCapacity() < ItemType(items[item].id):getWeight(amount) then
		return player:sendTextMessage(MESSAGE_INFO_DESCR, 'You don\'t have enough cap.')
	end
	if not doPlayerRemoveMoney(cid, items[item].buy * amount) then
		selfSay("You don't have enough money.", cid)
	else
		doPlayerAddItem(cid, items[item].id, amount)
		return player:sendTextMessage(MESSAGE_INFO_DESCR, 'Bought '..amount..'x '..items[item].name..' for '..items[item].buy * amount..' gold coins.')
	end
	return true
end

local function onSell(cid, item, subType, amount, ignoreCap, inBackpacks)
	
	local items = setNewTradeTable(getTable(player))
	if items[item].sellPrice and doPlayerRemoveItem(cid, items[item].itemId, amount) then
		player:addMoney(items[item].sellPrice * amount)
		return player:sendTextMessage(MESSAGE_INFO_DESCR, 'Sold '..amount..'x '..items[item].realName..' for '..items[item].sellPrice * amount..' gold coins.')
	else
		selfSay("You don't have item to sell.", cid)
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then return false end

	
	msg = msg:gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end)
	if msgcontains('trade', msg) then
		local tradeItems = {}
		if player:getPawAndFurRank() >= 2 then
			tradeItems = grizzlyAdamsConfig.ranks.huntsMan_rank
			if player:getPawAndFurRank() == 4 then
				tradeItems = joinTables(tradeItems, grizzlyAdamsConfig.ranks.bigGameHunter_rank)
			elseif player:getPawAndFurRank() == 5 or player:getPawAndFurRank() == 6 then
				tradeItems = joinTables(tradeItems, grizzlyAdamsConfig.ranks.bigGameHunter_rank)
				tradeItems = joinTables(tradeItems, grizzlyAdamsConfig.ranks.trophyHunter_rank)
			end
			openShopWindow(cid, tradeItems, onBuy, onSell)
			return selfSay('It\'s my offer.', cid)
		else
			return selfSay('You don\'t have any rank.', cid)
		end
	elseif (msgcontains('join', msg) or msgcontains('yes', msg))
			and talkState[talkUser] == 0
			and getPlayerStorageValue(cid, JOIN_STOR) ~= 1 then
		setPlayerStorageValue(cid, JOIN_STOR, 1)
		selfSay('Great!, now you can start tasks.', cid) --I'm not sure if this is as real tibia. I let this piece of code because it was in the original file.
	elseif isInArray({'tasks', 'task', 'mission'}, msg:lower()) then
		local can = player:getTasks()
		if getPlayerStorageValue(cid, JOIN_STOR) == -1 then
			return selfSay('You\'ll have to {join}, to get any {tasks}.',cid)
		end
		if #can > 0 then
			local text = ''
			local sep = ', '
			table.sort(can, function(a, b) return a < b end)
			local t = 0
			local id
			for i = 1, #can do
				id = can[i]
				t = t + 1
				if t == #can - 1 then
					sep = ' and '
				elseif t == #can then
					sep = '.'
				end
				text = text .. '{' .. (tasks[id].name or tasks[id].raceName) .. '}' .. sep
			end
			selfSay('The current task' .. (#can > 1 and 's' or '') .. ' that you can choose ' .. (#can > 1 and 'are' or 'is') .. ' ' .. text, cid)
			talkState[talkUser] = 0
		else
			selfSay('I don\'t have any task for you right now.', cid)
		end
	elseif msg ~= '' and player:canStartTask(msg) then
		if #player:getStartedTasks() >= tasksByPlayer then
			selfSay('Sorry, but you already started ' .. tasksByPlayer .. ' tasks. You can check their {status}, {cancel} or {report} a task.', cid)
			return true
		end
		local task = getTaskByName(msg)
		if task and getPlayerStorageValue(cid, QUESTSTORAGE_BASE + task) > 0 then
			return false
		end
		selfSay('In this task you must defeat ' .. tasks[task].killsRequired .. ' ' .. tasks[task].raceName .. '. Are you sure that you want to start this task?', cid)
		choose[cid] = task
		talkState[talkUser] = 1
	elseif msg:lower() == 'yes' and talkState[talkUser] == 1 then
		setPlayerStorageValue(cid, QUESTSTORAGE_BASE + choose[cid], 1)
		setPlayerStorageValue(cid, KILLSSTORAGE_BASE + choose[cid], 0)
		selfSay('Excellent! You can check the {status} of your task saying {report} to me. Also you can {cancel} tasks to.', cid)
		choose[cid] = nil
		talkState[talkUser] = 0
	elseif msgcontains('status', msg) then
		local started = player:getStartedTasks()
		if started and #started > 0 then
			local text = ''
			local sep = ', '
			table.sort(started, (function(a, b) return (a < b) end))
			local t = 0
			local id
			for i = 1, #started do
				id = started[i]
				t = t + 1
				if t == #started - 1 then
					sep = ' and '
				elseif t == #started then
					sep = '.'
				end
				text = text .. 'Task name: ' .. tasks[id].raceName .. '. Current kills: ' .. getPlayerStorageValue(cid, KILLSSTORAGE_BASE + id) .. '.\n'
			end
			selfSay({'The status of your current tasks is:\n' .. text}, cid)
		else
			selfSay('You haven\'t started any task yet.', cid)
		end
	elseif msgcontains('report', msg) then
		local started = player:getStartedTasks()
		local finishedAtLeastOne = false
		local finished = 0
		if started and #started > 0 then
			local id, reward
			for i = 1, #started do
				id = started[i]
				if getPlayerStorageValue(cid, KILLSSTORAGE_BASE + id) >= tasks[id].killsRequired then
					for j = 1, #tasks[id].rewards do
						reward = tasks[id].rewards[j]
						local deny = false
						if reward.storage then
							if getPlayerStorageValue(cid, reward.storage[1]) >= reward.storage[2] then
								deny = true
							end
						end
						if isInArray({REWARD_MONEY, 'money'}, reward.type:lower()) and not deny then
							player:addMoney(reward.value[1])
						elseif isInArray({REWARD_EXP, 'exp', 'experience'}, reward.type:lower()) and not deny then
							player:addExperience(reward.value[1], true)
						elseif isInArray({REWARD_ACHIEVEMENT, 'achievement', 'ach'}, reward.type:lower()) and not deny then
							--player:addAchievement(reward.value[1])
						elseif isInArray({REWARD_STORAGE, 'storage', 'stor'}, reward.type:lower()) and not deny then
							setPlayerStorageValue(cid, reward.value[1], reward.value[2])
						elseif isInArray({REWARD_POINT, 'points', 'point'}, reward.type:lower()) and not deny then
							setPlayerStorageValue(cid, POINTSSTORAGE, getPlayerTasksPoints(cid) + reward.value[1])
						elseif isInArray({REWARD_ITEM, 'item', 'items', 'object'}, reward.type:lower()) and not deny then
							doPlayerAddItem(cid, reward.value[1], reward.value[2])
						end

						if reward.storage then
							setPlayerStorageValue(cid, reward.storage[1], reward.storage[2])
						end
					end

					setPlayerStorageValue(cid, QUESTSTORAGE_BASE + id, (tasks[id].norepeatable and 2 or 0))
					setPlayerStorageValue(cid, KILLSSTORAGE_BASE + id, -1)
					setPlayerStorageValue(cid, REPEATSTORAGE_BASE + id, math.max(getPlayerStorageValue(cid, REPEATSTORAGE_BASE + id), 0))
					setPlayerStorageValue(cid, REPEATSTORAGE_BASE + id, getPlayerStorageValue(cid, REPEATSTORAGE_BASE + id) + 1)
					finishedAtLeastOne = true
					finished = finished + 1
				end
			end
			if not finishedAtLeastOne then
				local started = player:getStartedTasks()
				if started and #started > 0 then
					local text = ''
					local sep = ', '
					table.sort(started, (function(a, b) return (a < b) end))
					local t = 0
					local id
					for i = 1, #started do
						id = started[i]
						t = t + 1
						if (t == #started - 1) then
							sep = ' and '
						elseif (t == #started) then
							sep = '.'
						end
						text = text .. '{' .. (tasks[id].name or tasks[id].raceName) .. '}' .. sep
					end
					selfSay('The current task' .. (#started > 1 and 's' or '') .. ' that you started ' .. (#started > 1 and 'are' or 'is') .. ' ' .. text, cid)
				end
			else
				selfSay('Awesome! you finished ' .. (finished > 1 and 'various' or 'a') .. ' task' .. (finished > 1 and 's' or '') .. '. Talk to me again if you want to start a {task}.', cid)
			end
		else
			selfSay('You haven\'t started any task yet.', cid)
		end
	elseif msg:lower() == 'started' then
		local started = player:getStartedTasks()
		if started and #started > 0 then
			local text = ''
			local sep = ', '
			table.sort(started, (function(a, b) return (a < b) end))
			local t = 0
			local id
			for i = 1, #started do
				id = started[i]
				t = t + 1
				if t == #started - 1 then
					sep = ' and '
				elseif t == #started then
					sep = '.'
				end
				text = text .. '{' .. (tasks[id].name or tasks[id].raceName) .. '}' .. sep
			end

			selfSay('The current task' .. (#started > 1 and 's' or '') .. ' that you started ' .. (#started > 1 and 'are' or 'is') .. ' ' .. text, cid)
		else
			selfSay('You haven\'t started any task yet.', cid)
		end
	elseif msg:lower() == 'cancel' then
		local started = player:getStartedTasks()
		local task = getTaskByName(msg)
		local text = ''
		local sep = ', '
		table.sort(started, (function(a, b) return (a < b) end))
		local t = 0
		local id
		for i = 1, #started do
			id = started[i]
			t = t + 1
			if t == #started - 1 then
				sep = ' or '
			elseif t == #started then
				sep = '?'
			end
			text = text .. '{' .. (tasks[id].name or tasks[id].raceName) .. '}' .. sep
		end
		if started and #started > 0 then
			selfSay('Cancelling a task will make the counter restart. Which of these tasks you want cancel?' .. (#started > 1 and '' or '') .. ' ' .. text, cid)
			talkState[talkUser] = 2
		else
			selfSay('You haven\'t started any task yet.', cid)
		end
	elseif getTaskByName(msg) and talkState[talkUser] == 2 and isInArray(getPlayerStartedTasks(cid), getTaskByName(msg)) then
		local task = getTaskByName(msg)
		if getPlayerStorageValue(cid, KILLSSTORAGE_BASE + task) > 0 then
			selfSay('You currently killed ' .. getPlayerStorageValue(cid, KILLSSTORAGE_BASE + task) .. '/' .. tasks[task].killsRequired .. ' ' .. tasks[task].raceName .. '. Cancelling this task will restart the count. Are you sure you want to cancel this task?', cid)
		else
			selfSay('Are you sure you want to cancel this task?', cid)
		end
		talkState[talkUser] = 3
		cancel[cid] = task
	elseif getTaskByName(msg) and talkState[talkUser] == 1 and isInArray(getPlayerStartedTasks(cid), getTaskByName(msg)) then
		local task = getTaskByName(msg)
		if getPlayerStorageValue(cid, KILLSSTORAGE_BASE + task) > 0 then
			selfSay('You currently killed ' .. getPlayerStorageValue(cid, KILLSSTORAGE_BASE + task) .. '/' .. tasks[task].killsRequired .. ' ' .. tasks[task].raceName .. '.', cid)
		else
			selfSay('You currently killed 0/' .. tasks[task].killsRequired .. ' ' .. tasks[task].raceName .. '.', cid)
		end
		talkState[talkUser] = 0
	elseif msg:lower() == 'yes' and talkState[talkUser] == 3 then
		setPlayerStorageValue(cid, QUESTSTORAGE_BASE + cancel[cid], -1)
		setPlayerStorageValue(cid, KILLSSTORAGE_BASE + cancel[cid], -1)
		selfSay('You have cancelled the task ' .. (tasks[cancel[cid]].name or tasks[cancel[cid]].raceName) .. '.', cid)
		talkState[talkUser] = 0
	elseif isInArray({'points', 'rank'}, msg:lower()) then
		if player:getPawAndFurPoints() < 1 then
			selfSay('At this time, you have ' .. player:getPawAndFurPoints() .. ' Paw & Fur points. You ' .. (player:getPawAndFurRank() == 6 and 'are an Elite Hunter' or player:getPawAndFurRank() == 5 and 'are a Trophy Hunter' or player:getPawAndFurRank() == 4 and 'are a Big Game Hunter' or player:getPawAndFurRank() == 3 and 'are a Ranger' or player:getPawAndFurRank() == 2 and 'are a Huntsman' or player:getPawAndFurRank() == 1 and 'are a Member'  or 'haven\'t been ranked yet') .. '.', cid)
		else
			selfSay('At this time, you have ' .. player:getPawAndFurPoints() .. ' Paw & Fur points. You ' .. (player:getPawAndFurRank() == 6 and 'are an Elite Hunter' or player:getPawAndFurRank() == 5 and 'are a Trophy Hunter' or player:getPawAndFurRank() == 4 and 'are a Big Game Hunter' or player:getPawAndFurRank() == 3 and 'are a Ranger' or player:getPawAndFurRank() == 2 and 'are a Huntsman' or player:getPawAndFurRank() == 1 and 'are a Member'  or 'haven\'t been ranked yet') .. '.', cid)
		end
		talkState[talkUser] = 0
	elseif isInArray({'special task'}, msg:lower()) then
		if player:getPawAndFurPoints() >= 70 then -- Tiquandas Revenge 70 points
			if getPlayerStorageValue(cid, Storage.KillingInTheNameOf.MissionTiquandasRevenge) == 1 then  -- Check if he has already started the task.
				if (getPlayerStorageValue(cid, Storage.KillingInTheNameOf.TiquandasRevengeTeleport) ~= 0) then
					selfSay('You have already started the task. Go find Tiquandas Revenge and take revenge yourself!', cid)
				end
			else
				selfSay({
					'Have you heard about Tiquandas Revenge? It is said that the jungle itself is alive and takes revenge for all the bad things people have done to it. ...',
					'I myself believe that there is some truth in this clap trap. Something \'real\' which therefore must have a hideout somewhere. Go find it and take revenge yourself!'
				}, cid)
				setPlayerStorageValue(cid, Storage.KillingInTheNameOf.TiquandasRevengeTeleport, 1) -- Task needed to enter Tiquandas Revenge TP
				setPlayerStorageValue(cid, Storage.KillingInTheNameOf.MissionTiquandasRevenge, 1) -- Won't give this task again.
			end

			if getPlayerStorageValue(cid, Storage.KillingInTheNameOf.MissionDemodras) == 1 then  -- Check if he has already started the task.
				if (getPlayerStorageValue(cid, Storage.KillingInTheNameOf.DemodrasTeleport) ~= 0) then
					selfSay('You have already started the special task. Find Demodras and kill it.', cid)
				end
			else
				selfSay('This task is a very dangerous one. I want you to look for Demodras\' hideout. It might be somewhere under the Plains of Havoc. Good luck, old chap.', cid)
				setPlayerStorageValue(cid, Storage.KillingInTheNameOf.DemodrasTeleport, 1) -- Task needed to enter Demodras TP
				setPlayerStorageValue(cid, Storage.KillingInTheNameOf.MissionDemodras, 1) -- Won't give this task again.
			end

			if (getPlayerStorageValue(cid, Storage.KillingInTheNameOf.MissionDemodras) == 1 and
				getPlayerStorageValue(cid, Storage.KillingInTheNameOf.DemodrasTeleport) == 0 and
				getPlayerStorageValue(cid, Storage.KillingInTheNameOf.MissionTiquandasRevenge) == 1 and
				getPlayerStorageValue(cid, Storage.KillingInTheNameOf.TiquandasRevengeTeleport) == 0) then
				selfSay('You have already finished all special tasks.', cid)
			end
		end
		talkState[talkUser] = 0
	end
end


npcHandler:setMessage(MESSAGE_FAREWELL, 'Happy hunting, old chap!')
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
