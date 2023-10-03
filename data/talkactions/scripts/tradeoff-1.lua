local config = {
    level_add = 20,
    max_offer = 5,
    offer_pz = true,
    itens_bloqueados = {2165, 2152, 2148, 2160, 2166, 2167, 2168, 2169, 2202, 2203, 2204, 2205, 2206, 2207, 2208, 2209, 2210, 2211, 2212, 2213, 2214, 2215, 2343, 2433, 2640, 6132, 6300, 6301, 9932, 9933}
}

function onSay(player, words, param, channel)
    if (param == 'saldo') then
        local consulta = db.storeQuery("SELECT * FROM `players` WHERE `id` = " .. player:getGuid() .. ";")
        local balance = result.getNumber(consulta, "auction_balance")
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Seu saldo é de " .. saldo .. " gps de suas vendas no mercado!")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Seu saldo é de " .. saldo .. " gps de suas vendas no mercado!")
        return true
    end
    if(param == '') or (param == 'info') then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Comandos para utilizar este sistema:\n!offer saldo\nUse este comando para verificar o saldo de suas vendas.\n!offer add, nomedoitem, preco, qtd\nexemplo: !offer add,plate armor,500,1\n\n\n!offer buy,id_da_compra\nexemplo: !offer buy,1943\n\n\n!offer remove,id_da_compra\nexemplo: !offer remove,1943\n\n\n!offer withdraw, qtd\nexemplo: !offer withdraw, 1000.\n")
        return true
    end
    local split = param:split(",")
    if split[2] == nil  then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Parâmetros necessários. Use !offer info para mais informações!")
        return false
    end
    split[2] = split[2]:gsub("^%s*(.-)$", "%1")
    _BUSCA_DB = db.storeQuery("SELECT * FROM `auction_system` WHERE `player` = " .. player:getGuid())
    if(split[1] == "add") then
        if(not tonumber(split[3]) or (not tonumber(split[4]))) then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Use somente números.")
            return true
        end
        if(string.len(split[3]) > 7 or (string.len(split[4]) > 3)) then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Este preço ou a quantidade itens e muito alta.")
            return true
        end
        local itemType, item_s = ItemType(split[2]), ItemType(split[2]):getId()
        if(not item_s) then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "O item "..itemType.." nao existe!")
            return true
        end
        if(player:getLevel() < config.level_add) then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Desculpe, mas voce precisa de level igual ou superior a (" .. config.level_add .. ") para continuar.")
            return true
        end
        if(isInArray(config.itens_bloqueados, item_s)) then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Voce nao pode adicionar este item.")
            return true
        end
        if(player:getItemCount(item_s) < tonumber(split[4])) then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Desculpe, mas voce nao tem este item.")
            return true
        end
        local amount, tmp_BUSCA_DB  = 0, _BUSCA_DB
        while tmp_BUSCA_DB ~= false do
            tmp_BUSCA_DB = result.next(_BUSCA_DB)
            amount = amount + 1
        end
        if _BUSCA_DB ~= false then
            local limit = amount >= config.max_offer
            if limit then
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Desculpe, mas voce atingiu o limite maximo(" .. config.max_offer .. ") de publicações de venda de itens.")
                return true
            end
            if(config.SendOffersOnlyInPZ) then    
            if(not getTilePzInfo(player:getPosition())) then
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Desculpe, mas voce so pode usar este comando estando em protection zone.")
                return true
            end
        end
    end
    if(tonumber(split[4]) < 1 or (tonumber(split[3]) < 1)) then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Desculpe, mas voce precisa informar um numero maior que 0.")
        return true
    end
    local itemcount, costgp = math.floor(split[4]), math.floor(split[3])
    player:removeItem(item_s, itemcount)
    db.query("INSERT INTO `auction_system` (`player`, `item_name`, `item_id`, `count`, `cost`, `date`) VALUES (" .. player:getGuid() .. ", \"" .. split[2] .. "\", " .. item_s .. ", " .. itemcount .. ", " .. costgp ..", " .. os.time() .. ")")
    player:sendTextMessage(MESSAGE_INFO_DESCR, "Parabens! Voce adicionou para à venda " .. itemcount .." " .. split[2] .." por " .. costgp .. " gps!")
end
if(split[1] == "buy") then
    _BUSCA_DB = db.storeQuery("SELECT * FROM `auction_system` WHERE `id` = ".. tonumber(split[2]))
    local player_id, player_vendas, item_s, costs, item_names, counts = player:getGuid(), result.getNumber(_BUSCA_DB, "player"), result.getNumber(_BUSCA_DB, "item_id"), result.getNumber(_BUSCA_DB, "cost"), result.getString(_BUSCA_DB, "item_name"), result.getNumber(_BUSCA_DB, "count")
   
    if(not tonumber(split[2])) then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Desculpe, mas somente números são aceitos.")
        return true
    end
 
    if(_BUSCA_DB ~= false) then
        local total_custo = costs - player:getMoney()
        if(player:getMoney() < costs) then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Desculpe, mas voce não possui a quantia necessaria para buy. Sao necessarios: "..costs.."gps para buy o item: "..item_names..". Voce tem: " .. player:getMoney() .. "gps. Voce precisa de: "..total_custo.." gps.")
            return true
        end
        if(player_id == player_vendas) then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Desculpe, mas voce nao pode buy seu proprio item.")
        return true
    end
        if player:removeMoney(costs) then
            if(isItemStackable((item_s))) then
                player:isNearDepotBox(item_s, counts)
            else
                for i = 1, counts do
                    player:isNearDepotBox(item_s, 1)
                end
            end
            db.query("DELETE FROM `auction_system` WHERE `id` = " .. split[2] .. ";")
            player:sendTextMessage(MESSAGE_INFO_DESCR, "Parabens! Voce comprou " .. counts .. " ".. item_names .. " por " .. costs .. " gps com sucesso!")
            db.query("UPDATE `players` SET `auction_balance` = `auction_balance` + " .. costs .. " WHERE `id` = " .. player_vendas .. ";")
        end
else
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Desculpe, mas o ID "..split[2].." não existe!.")
end
end
 
if(split[1] == "remove") then
    local _BUSCA_DB = db.storeQuery("SELECT * FROM `auction_system` WHERE `id` = ".. tonumber(split[2]))
    local player_id, player_vendas, item_s, costs, item_names, counts = player:getGuid(), result.getNumber(_BUSCA_DB, "player"), result.getNumber(_BUSCA_DB, "item_id"), result.getNumber(_BUSCA_DB, "cost"), result.getString(_BUSCA_DB, "item_name"), result.getNumber(_BUSCA_DB, "count")
    if((not tonumber(split[2]))) then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Desculpe, mas somente numeros sao aceitos.")
        return true
    end
    if(config.SendOffersOnlyInPZ) then    
    if(not getTilePzInfo(player:getPosition())) then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You must be in PZ area when you remove offerts from database.")
        return true
    end
end  
if(_BUSCA_DB ~= false) then
    if(player_id == player_vendas) then
    db.query("DELETE FROM `auction_system` WHERE `id` = " .. split[2] .. ";")
    if(isItemStackable(item_s)) then
        player:isNearDepotBox(item_s, counts)
    else
        for i = 1, counts do
            player:isNearDepotBox(item_s, 1)
        end
    end
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Parabens! A offer "..split[2].." foi removida com sucesso do mercado.\nVoce recebeu: "..counts.." "..item_names..".")
else
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Desculpe, mas essa offer nao é sua.")
end
result.free(resultado)
else
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Desculpe, mas este ID nao existe.")
end
end
if(split[1] == "withdraw") then
    if((not tonumber(split[2]))) then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Desculpe, mas somente numeros sao aceitos.")
        return true
    end
    local balance = db.storeQuery("SELECT * FROM `players` WHERE `id` = " .. player:getGuid() .. ";")
    local auction_balance = result.getNumber(balance, "auction_balance")
    if(auction_balance < 1) then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Voce nao possuí saldo suficiente para withdraw.")
        result.free(balance)
        return true
    end
    local tz = auction_balance - split[2]
    player:sendTextMessage(MESSAGE_INFO_DESCR, "Voce sacou " .. split[2] .. " gps de suas vendas no mercado! Seu saldo e de: "..tz.."gps.")
    player:addMoney(tz)
    db.query("UPDATE `players` SET `auction_balance` = ".. tz .." WHERE `id` = " .. player:getGuid() .. ";")
    result.free(balance)
end
 
return true
end