local config = {
        lottery_hour = "2 hours", -- Tempo ate a proxima loteria (Esse tempo vai aparecer somente como broadcast message)
        rewards_id = {2494, 2472, 2514, 2160}, -- ID dos Itens Sorteados na Loteria
        crystal_counts = 10, -- Usado somente se a rewards_id for crystal coin (ID: 2160).
        website = "yes", -- Only if you have php scripts and table `lottery` in your database!
}

local function getOnlineParticipants()
    local players = {}
    for _, pid in pairs(Game.getPlayers()) do
        if getPlayerAccess(pid) <= 2 and getPlayerStorageValue(pid, 281821) <= os.time() then
            table.insert(players, pid)
        end
    end
    if #players > 0 then
        return players
    end
    return false
end
     
function onTime(interval)
local players = Game.getPlayers()
    if #players > 0 then
        local random_item = config.rewards_id[math.random(1, #config.rewards_id)]
        local item_name = getItemName(random_item)  
        local data = os.date("%d/%m/%Y - %H:%M:%S")
        local online = getOnlineParticipants()
       
        if online then
			local winner = online[math.random(1, #online)]
            local world = tonumber(getPlayerByName(winner))
           
            if random_item == 2160 then
				winner:setStorageValue(281821, os.time() + 3600 * 24)
				winner:addItem(random_item, config.crystal_counts)
                broadcastMessage("[LOTTERY SYSTEM] Winner: " .. winner:getName() .. ", Reward: " .. config.crystal_counts .." " .. getItemName(random_item) .. "s! Congratulations! (Next lottery in " .. config.lottery_hour .. ")")
            else
				winner:setStorageValue(281821, os.time() + 3600 * 24)
                broadcastMessage("[LOTTERY SYSTEM] Winner: " .. winner:getName() .. ", Reward: " ..getItemName(random_item) .. "! Congratulations! (Next lottery in " .. config.lottery_hour .. ")")
                winner:addItem(random_item, 1)
            end
            if(config.website == "yes") then
                db.query("INSERT INTO `lottery` (`name`, `item`, `item_name`, `date`) VALUES ('".. winner:getName().."', '".. random_item .."', '".. item_name .."', '".. data .."');")
            end
        else
            print("No players online to win the lottery.")
        end
    end
    return true
end