local function isValidMoney(value)
        if(value == nil) then
                return false
        end
        return (value > 0 and value <= 99999999999999)
end
 
function onSay(cid, words, param)
 
        local player = Player(cid)
        local guild = player:getGuild():getId()
        if(guild == nil) then
                return true
        end
 
        local t = string.split(param, ' ', 1)
       
        if(player:getGuildLevel() == GUILDLEVEL_LEADER and isInArray({'pick'}, t[1])) then
                if(t[1] == 'pick') then
                        local money = {tonumber(t[2])}
                        if(not isValidMoney(money[1])) then
                                player:sendChannelMessage('', 'Invalid amount of money specified.', TALKTYPE_CHANNEL_R1, CHANNEL_GUILD)
                                return false
                        end
 
                        local resultId = db.storeQuery("SELECT `balance` FROM `guilds` WHERE `id` = " .. guild)
                        if resultId == false then
                                return false
                        end
                       
                        money[2] = result.getDataInt(resultId, "balance")
                        result.free(resultId)
 
                        if(money[1] > money[2]) then
                                player:sendChannelMessage('', 'The balance is too low for such amount.', TALKTYPE_CHANNEL_R1, CHANNEL_GUILD)
                                return false
                        end
 
                        if(not db.query('UPDATE `guilds` SET `balance` = `balance` - ' .. money[1] .. ' WHERE `id` = ' .. guild .. ' LIMIT 1;')) then
                                return false
                        end
 
                        doPlayerAddMoney(cid, money[1])
                        player:sendChannelMessage('', 'You have just picked ' .. money[1] .. ' money from your guild balance.', TALKTYPE_CHANNEL_R1, CHANNEL_GUILD)
                else
                        player:sendChannelMessage('', 'Invalid sub-command.', TALKTYPE_CHANNEL_R1, CHANNEL_GUILD)
                end
        elseif(t[1] == 'donate') then
                local money = tonumber(t[2])
                if(not isValidMoney(money)) then
                        player:sendChannelMessage('', 'Invalid amount of money specified.', TALKTYPE_CHANNEL_R1, CHANNEL_GUILD)
                        return true
                end
 
                if(getPlayerMoney(cid) < money) then
                        player:sendChannelMessage('', 'You don\'t have enough money.', TALKTYPE_CHANNEL_R1, CHANNEL_GUILD)
                        return true
                end
 
                if(not doPlayerRemoveMoney(cid, money)) then
                        return false
                end
 
                db.query('UPDATE `guilds` SET `balance` = `balance` + ' .. money .. ' WHERE `id` = ' .. guild .. ' LIMIT 1;')
                player:sendChannelMessage('', 'You have transfered ' .. money .. ' money to your guild balance.', TALKTYPE_CHANNEL_R1, CHANNEL_GUILD)
        else
                local resultId = db.storeQuery('SELECT `name`, `balance` FROM `guilds` WHERE `id` = ' .. guild)
                if resultId == false then
                        return false
                end
                player:sendChannelMessage('', 'Current balance of guild ' .. result.getDataString(resultId, "name") .. ' is: ' .. result.getDataInt(resultId, "balance") .. ' bronze coins.', TALKTYPE_CHANNEL_R1, CHANNEL_GUILD)
                result.free(resultId)
        end
end