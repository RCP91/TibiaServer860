local cleanMapAtSave = true

local function serverSave(interval)
    if cleanMapAtSave then
        cleanMap()
    end

    saveServer()
    Game.broadcastMessage('Server save complete. Next save in ' .. math.floor(interval / 60000) .. ' minutes!', MESSAGE_STATUS_WARNING)
end

function onThink(interval)
    Game.broadcastMessage('O servidor salvará todas as contas em 60 segundos. Você pode atrasar ou congelar por 5 segundos, por favor, encontre um lugar seguro.', MESSAGE_STATUS_WARNING)
    addEvent(serverSave, 60000, interval)
    return true
end