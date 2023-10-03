
function onStepIn(player, item, position, fromPosition)
    if not player then
        return true
    end
    local guild = player:getGuild()
    if not player:getGuild() then
        return true
    end
    if item.actionid == 16203 then
        if Game.getStorageValue(COH_STATUS) == guild:getName() then
            player:getPosition():sendMagicEffect(14)
            player:sendTextMessage(4, "[CASTLE 24H] Membros da guild dominante " .. Game.getStorageValue(COH_STATUS) .. " possuem o privilegio de passar por aqui!")
        else
            player:getPosition():sendMagicEffect(2)
            player:teleportTo(fromPosition, false)
            player:sendCancelMessage("[CASTLE 24H] Voce nao pertence a guild dominante " .. Game.getStorageValue(COH_STATUS) .. ".")
        end
        return true
    end
    if item.actionid == 16202 then
        if player:getGuildLevel() > 0 then
            if guild and guild:getName() ~= Game.getStorageValue(COH_STATUS) then
                player:sendTextMessage(20, "[Castle of Honor] Voce e sua guild estao no comando, os antigos donos [" .. tostring(Game.getStorageValue(COH_STATUS)) .. "] podem se vingar!")
                Game.setStorageValue(COH_PREPARE1, -1)
                Game.setStorageValue(COH_PREPARE2, -1)
                Game.setStorageValue(COH_STATUS, guild:getName())
                doCastleRemoveEnemies()
                Game.broadcastMessage("[Castle of Honor] O jogador [" .. player:getName() .. "] e sua guild [" .. guild:getName() .. "] estao agora no comando do castelo. Tente dominar o Castle ou os aceite como governantes!")
            end
        else
            player:getPosition():sendMagicEffect(2)
            player:teleportTo(fromPosition, false)
            player:sendCancelMessage("[CASTLE 24H] Voce nao possui uma guild.")
        end
        return true
    end
    if item.actionid == 16200 then
        if player:getGuildLevel() > 0 then
            player:sendTextMessage(4, "CASTLE 24H Invasion Camp!")
            if (Game.getStorageValue(COH_PREPARE1) ~= guild:getName()) and ((Game.getStorageValue(COH_PREPARE2) ~= guild:getName())) then
                Game.setStorageValue(COH_PREPARE1, guild:getName())
                Game.broadcastMessage("[Castle of Honor] Atençao! A guild " .. guild:getName() .. " está indo em direcao ao Castelo. Guild dominante preparem-se!")
            end
        else
            player:getPosition():sendMagicEffect(2)
            player:teleportTo(fromPosition, false)
            player:sendCancelMessage("[CASTLE 24H] Voce nao possui uma guild.") 
            return true
        end 
    end
    if item.actionid == 16201 then
        player:sendTextMessage("CASTLE 24H Invasion Castle!")
        if (Game.getStorageValue(COH_PREPARE2) ~= guild:getName()) then
            Game.getStorageValue(COH_PREPARE2, guild:getName())
            Game.broadcastMessage("[Castle of Honor] Atencao! A guild " .. guild:getName() .. " esta próxima do dominio do Castle. Guild dominanete defenda o Castle para nao perde-lo!")
        end
    end
    return true
end