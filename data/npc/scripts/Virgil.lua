local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local count = {}
local transfer = {}

function onCreatureAppear(cid)          npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)       npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)        end
function onThink()      npcHandler:onThink()        end

local voices = { {text = 'Don\'t forget to deposit your money here in the Tibian Bank before you head out for adventure.'} }
if VoiceModule then
    --npcHandler:addModule(VoiceModule:new(voices))
end
--------------------------------guild bank-----------------------------------------------
local receiptFormat = 'Date: %s\nType: %s\nGold Amount: %d\nReceipt Owner: %s\nRecipient: %s\n\n%s'
local function getReceipt(info)
    local receipt = Game.createItem(info.success and 24301 or 24302)
    receipt:setAttribute(ITEM_ATTRIBUTE_TEXT, receiptFormat:format(os.date('%d. %b %Y - %H:%M:%S'), info.type, info.amount, info.owner, info.recipient, info.message))

    return receipt
end

local function getGuildIdByName(name, func)
    db.asyncStoreQuery('SELECT `id` FROM `guilds` WHERE `name` = ' .. db.escapeString(name),
        function(resultId)
            if resultId then
                func(result.getNumber(resultId, 'id'))
                result.free(resultId)
            else
                func(nil)
            end
        end
    )
end

local function getGuildBalance(id)
    local guild = Guild(id)
    if guild then
        return guild:getBankBalance()
    else
        local balance
        local resultId = db.storeQuery('SELECT `balance` FROM `guilds` WHERE `id` = ' .. id)
        if resultId then
            balance = result.getNumber(resultId, 'balance')
            result.free(resultId)
        end

        return balance
    end
end

local function setGuildBalance(id, balance)
    local guild = Guild(id)
    if guild then
        guild:setBankBalance(balance)
    else
        db.query('UPDATE `guilds` SET `balance` = ' .. balance .. ' WHERE `id` = ' .. id)
    end
end

local function transferFactory(playerName, amount, fromGuildId, info)
    return function(toGuildId)
        if not toGuildId then
            local player = Player(playerName)
            if player then
                info.success = false
                info.message = 'We are sorry to inform you that we could not fulfil your request, because we could not find the recipient guild.'
                local inbox = player:getInbox()
                local receipt = getReceipt(info)
                inbox:addItemEx(receipt, INDEX_WHEREEVER, FLAG_NOLIMIT)
            end
        else
            local fromBalance = getGuildBalance(fromGuildId)
            if fromBalance < amount then
                info.success = false
                info.message = 'We are sorry to inform you that we could not fulfill your request, due to a lack of the required sum on your guild account.'
            else
                info.success = true
                info.message = 'We are happy to inform you that your transfer request was successfully carried out.'
                setGuildBalance(fromGuildId, fromBalance - amount)
                setGuildBalance(toGuildId, getGuildBalance(toGuildId) + amount)
            end

            local player = Player(playerName)
            if player then
                local inbox = player:getInbox()
                local receipt = getReceipt(info)
                inbox:addItemEx(receipt, INDEX_WHEREEVER, FLAG_NOLIMIT)
            end
        end
    end
end
--------------------------------guild bank-----------------------------------------------

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
--------------------------------guild bank-----------------------------------------------
    elseif msgcontains(msg, 'guild balance') then
        talkState[talkUser] = 0
        if not player:getGuild() then
            selfSay('You are not a member of a guild.', cid)
            return false
        end
        selfSay('Your guild account balance is ' .. player:getGuild():getBankBalance() .. ' gold.', cid)
        return true
--------------------------------guild bank-----------------------------------------------
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
--------------------------------guild bank-----------------------------------------------
    elseif msgcontains(msg, 'guild deposit') then
        if not player:getGuild() then
            selfSay('You are not a member of a guild.', cid)
            talkState[talkUser] = 0
            return false
        end
       -- count[cid] = getPlayerBalance(cid)
       -- if count[cid] < 1 then
           -- selfSay('You do not have enough gold.', cid)
           -- talkState[talkUser] = 0
           -- return false
        --end
        if string.match(msg, '%d+') then
            count[cid] = getMoneyCount(msg)
            if count[cid] < 1 then
                selfSay('You do not have enough gold.', cid)
                talkState[talkUser] = 0
                return false
            end
            selfSay('Would you really like to deposit ' .. count[cid] .. ' gold to your {guild account}?', cid)
            talkState[talkUser] = 23
            return true
        else
            selfSay('Please tell me how much gold it is you would like to deposit.', cid)
            talkState[talkUser] = 22
            return true
        end
    elseif talkState[talkUser] == 22 then
        count[cid] = getMoneyCount(msg)
        if isValidMoney(count[cid]) then
            selfSay('Would you really like to deposit ' .. count[cid] .. ' gold to your {guild account}?', cid)
            talkState[talkUser] = 23
            return true
        else
            selfSay('You do not have enough gold.', cid)
            talkState[talkUser] = 0
            return true
        end
    elseif talkState[talkUser] == 23 then
        if msgcontains(msg, 'yes') then
            selfSay('Alright, we have placed an order to deposit the amount of ' .. count[cid] .. ' gold to your guild account. Please check your inbox for confirmation.', cid)
            local guild = player:getGuild()
            local info = {
                type = 'Guild Deposit',
                amount = count[cid],
                owner = player:getName() .. ' of ' .. guild:getName(),
                recipient = guild:getName()
            }
            local playerBalance = getPlayerBalance(cid)
            if playerBalance < tonumber(count[cid]) then
                info.message = 'We are sorry to inform you that we could not fulfill your request, due to a lack of the required sum on your bank account.'
                info.success = false
            else
                info.message = 'We are happy to inform you that your transfer request was successfully carried out.'
                info.success = true
                guild:setBankBalance(guild:getBankBalance() + tonumber(count[cid]))
                player:setBankBalance(playerBalance - tonumber(count[cid]))
            end

            local inbox = player:getInbox()
            local receipt = getReceipt(info)
            inbox:addItemEx(receipt, INDEX_WHEREEVER, FLAG_NOLIMIT)
        elseif msgcontains(msg, 'no') then
            selfSay('As you wish. Is there something else I can do for you?', cid)
        end
        talkState[talkUser] = 0
        return true
--------------------------------guild bank-----------------------------------------------
    elseif msgcontains(msg, 'deposit') then
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
            else
                selfSay('You do not have enough gold.', cid)
            end
        elseif msgcontains(msg, 'no') then
            selfSay('As you wish. Is there something else I can do for you?', cid)
        end
        talkState[talkUser] = 0
        return true
---------------------------- withdraw --------------------
--------------------------------guild bank-----------------------------------------------
    elseif msgcontains(msg, 'guild withdraw') then
        if not player:getGuild() then
            selfSay('I am sorry but it seems you are currently not in any guild.', cid)
            talkState[talkUser] = 0
            return false
        elseif player:getGuildLevel() < 2 then
            selfSay('Only guild leaders or vice leaders can withdraw money from the guild account.', cid)
            talkState[talkUser] = 0
            return false
        end

        if string.match(msg,'%d+') then
            count[cid] = getMoneyCount(msg)
            if isValidMoney(count[cid]) then
                selfSay('Are you sure you wish to withdraw ' .. count[cid] .. ' gold from your guild account?', cid)
                talkState[talkUser] = 25
            else
                selfSay('There is not enough gold on your guild account.', cid)
                talkState[talkUser] = 0
            end
            return true
        else
            selfSay('Please tell me how much gold you would like to withdraw from your guild account.', cid)
            talkState[talkUser] = 24
            return true
        end
    elseif talkState[talkUser] == 24 then
        count[cid] = getMoneyCount(msg)
        if isValidMoney(count[cid]) then
            selfSay('Are you sure you wish to withdraw ' .. count[cid] .. ' gold from your guild account?', cid)
            talkState[talkUser] = 25
        else
            selfSay('There is not enough gold on your guild account.', cid)
            talkState[talkUser] = 0
        end
        return true
    elseif talkState[talkUser] == 25 then
        if msgcontains(msg, 'yes') then
            local guild = player:getGuild()
            local balance = guild:getBankBalance()
            selfSay('We placed an order to withdraw ' .. count[cid] .. ' gold from your guild account. Please check your inbox for confirmation.', cid)
            local info = {
                type = 'Guild Withdraw',
                amount = count[cid],
                owner = player:getName() .. ' of ' .. guild:getName(),
                recipient = player:getName()
            }
            if balance < tonumber(count[cid]) then
                info.message = 'We are sorry to inform you that we could not fulfill your request, due to a lack of the required sum on your guild account.'
                info.success = false
            else
                info.message = 'We are happy to inform you that your transfer request was successfully carried out.'
                info.success = true
                guild:setBankBalance(balance - tonumber(count[cid]))
                local playerBalance = getPlayerBalance(cid)
                player:setBankBalance(playerBalance + tonumber(count[cid]))
            end

            local inbox = player:getInbox()
            local receipt = getReceipt(info)
            inbox:addItemEx(receipt, INDEX_WHEREEVER, FLAG_NOLIMIT)
            talkState[talkUser] = 0
        elseif msgcontains(msg, 'no') then
            selfSay('As you wish. Is there something else I can do for you?', cid)
            talkState[talkUser] = 0
        end
        return true
--------------------------------guild bank-----------------------------------------------
    elseif msgcontains(msg, 'withdraw') then
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
--------------------------------guild bank-----------------------------------------------
    elseif msgcontains(msg, 'guild transfer') then
        if not player:getGuild() then
            selfSay('I am sorry but it seems you are currently not in any guild.', cid)
            talkState[talkUser] = 0
            return false
        elseif player:getGuildLevel() < 2 then
            selfSay('Only guild leaders or vice leaders can transfer money from the guild account.', cid)
            talkState[talkUser] = 0
            return false
        end

        if string.match(msg, '%d+') then
            count[cid] = getMoneyCount(msg)
            if isValidMoney(count[cid]) then
                transfer[cid] = string.match(msg, 'to%s*(.+)$')
                if transfer[cid] then
                    selfSay('So you would like to transfer ' .. count[cid] .. ' gold from your guild account to guild ' .. transfer[cid] .. '?', cid)
                    talkState[talkUser] = 28
                else
                    selfSay('Which guild would you like to transfer ' .. count[cid] .. ' gold to?', cid)
                    talkState[talkUser] = 27
                end
            else
                selfSay('There is not enough gold on your guild account.', cid)
                talkState[talkUser] = 0
            end
        else
            selfSay('Please tell me the amount of gold you would like to transfer.', cid)
            talkState[talkUser] = 26
        end
        return true
    elseif talkState[talkUser] == 26 then
        count[cid] = getMoneyCount(msg)
        if player:getGuild():getBankBalance() < count[cid] then
            selfSay('There is not enough gold on your guild account.', cid)
            talkState[talkUser] = 0
            return true
        end
        if isValidMoney(count[cid]) then
            selfSay('Which guild would you like to transfer ' .. count[cid] .. ' gold to?', cid)
            talkState[talkUser] = 27
        else
            selfSay('There is not enough gold on your account.', cid)
            talkState[talkUser] = 0
        end
        return true
    elseif talkState[talkUser] == 27 then
        transfer[cid] = msg
        if player:getGuild():getName() == transfer[cid] then
            selfSay('Fill in this field with person who receives your gold!', cid)
            talkState[talkUser] = 0
            return true
        end
        selfSay('So you would like to transfer ' .. count[cid] .. ' gold from your guild account to guild ' .. transfer[cid] .. '?', cid)
        talkState[talkUser] = 28
        return true
    elseif talkState[talkUser] == 28 then
        if msgcontains(msg, 'yes') then
            selfSay('We have placed an order to transfer ' .. count[cid] .. ' gold from your guild account to guild ' .. transfer[cid] .. '. Please check your inbox for confirmation.', cid)
            local guild = player:getGuild()
            local balance = guild:getBankBalance()
            local info = {
                type = 'Guild to Guild Transfer',
                amount = count[cid],
                owner = player:getName() .. ' of ' .. guild:getName(),
                recipient = transfer[cid]
            }
            if balance < tonumber(count[cid]) then
                info.message = 'We are sorry to inform you that we could not fulfill your request, due to a lack of the required sum on your guild account.'
                info.success = false
                local inbox = player:getInbox()
                local receipt = getReceipt(info)
                inbox:addItemEx(receipt, INDEX_WHEREEVER, FLAG_NOLIMIT)
            else
                getGuildIdByName(transfer[cid], transferFactory(player:getName(), tonumber(count[cid]), guild:getId(), info))
            end
            talkState[talkUser] = 0
        elseif msgcontains(msg, 'no') then
            selfSay('Alright, is there something else I can do for you?', cid)
        end
        talkState[talkUser] = 0
--------------------------------guild bank-----------------------------------------------
    elseif msgcontains(msg, 'transfer') then
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

npcHandler:setMessage(MESSAGE_GREET, "Yes? What may I do for you, |PLAYERNAME|? Bank business, perhaps?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Have a nice day.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Have a nice day.")
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
