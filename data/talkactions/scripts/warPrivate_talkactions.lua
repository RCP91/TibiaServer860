 GUILDLEVEL_LEADER = 3
    CHANNEL_GUILD = 0x00

    function getGuildId(name)
        local result_ptr = db.storeQuery("SELECT `id` FROM `guilds` WHERE `name` = " .. db.escapeString(name) .. ";")
        if not result_ptr then
            return nil
        end
        return result.getDataInt(result_ptr, 'id')
    end

    function getGuildNameById(id)
        local result_ptr = db.storeQuery("SELECT `name` FROM `guilds` WHERE `id` = " .. id .. ";")
        if not result_ptr then
            return nil
        end
        return result.getDataString(result_ptr, 'name')
    end

    function doCreateInvitationGuildWar(g, status, started, ended)
        local queryString = "INSERT INTO `guild_wars` (`guild1`, `guild2`, `name1`, `name2`, `status`, `started`, `ended`) "
        local queryValues = "VALUES (" .. g[1].id .. ", " .. g[2].id .. ", " .. db.escapeString(g[1].name) .. ", " .. db.escapeString(g[2].name) .. ", " .. status .. ", " .. started .. ", " .. ended .. ");"
        local result_ptr = db.query(queryString .. queryValues)
        if not result_ptr then
            return false
        end
        return true
    end

    function setGuildWarStatus(status, query)
        local queryString = "UPDATE `guild_wars` SET `status` = " .. status .. ", `ended` = 0 WHERE " .. query .. " AND `status` = 0;"
        local result_ptr = db.query(queryString)
        if not result_ptr then
            return false
        end
        return true
    end

    function setGuildWarDelete(query)
        local queryString = "DELETE FROM `guild_wars` WHERE " .. query .. ";"
        local result_ptr = db.query(queryString)
        if not result_ptr then
            return false
        end
        return true
    end

    function onSay(player, words, param)
    local storage = 54073 -- Make sure to select non-used storage. This is used to prevent SQL load attacks.
    local cooldown = 15 -- in seconds.

    if player:getStorageValue(storage) <= os.time() then
        player:setStorageValue(storage, os.time() + cooldown)
   
        local guild = player:getGuild()
        if not guild or player:getGuildLevel() < GUILDLEVEL_LEADER then
            player:sendCancelMessage('You cannot execute this talkaction.')
            return false
        end

        local split = param:split(', ')
        if not split[2] then
            sendGuildChannelMessage(guild:getId(), TALKTYPE_CHANNEL_R1, 'Not enough param(s).')
            return false
        end

        local action = split[1]
        local enemy = getGuildId(split[2])
        if not enemy then
            sendGuildChannelMessage(guild:getId(), TALKTYPE_CHANNEL_R1, 'Guild \'' .. split[2] .. '\' does not exists.')
            return false
        end

        if enemy == guild:getId() then
            sendGuildChannelMessage(guild:getId(), TALKTYPE_CHANNEL_R1, 'You cannot perform war action on your own guild.')
            return false
        end

        local enemyName = getGuildNameById(enemy)
        if action == 'accept' then

            local query = "`guild1` = " .. enemy .. " AND `guild2` = " .. guild:getId()
            local tmp = db.storeQuery("SELECT `id`, `ended`, `started` FROM `guild_wars` WHERE " .. query .. " AND `status` = 0;")
            if not tmp then
                sendGuildChannelMessage(guild:getId(), TALKTYPE_CHANNEL_R1, "Currently there's no pending invitation for a war with " .. enemyName .. ".")
                return false
            end

            sendGuildChannelMessage(guild:getId(), TALKTYPE_CHANNEL_R1, 'Has aceptado la invitacion de ' .. enemyName)
            setGuildWarStatus(1, query)
            return false

        end

        if action == 'cancel' or action == 'reject' then

            local query = "`guild1` = " .. enemy .. " AND `guild2` = " .. guild:getId()
            local tmp = db.storeQuery("SELECT `id`, `ended`, `started` FROM `guild_wars` WHERE " .. query .. ";")
            if not tmp then
                sendGuildChannelMessage(guild:getId(), TALKTYPE_CHANNEL_R1, "Currently there's no pending invitation for a war with " .. enemyName .. ".")
                return false
            end

            sendGuildChannelMessage(guild:getId(), TALKTYPE_CHANNEL_R1, 'Has cancelado la invitacion de ' .. enemyName)
            setGuildWarDelete(query)
            return false

        end

        if action == 'invite' then
            local str = ' '

            local query = "`guild1` = " .. guild:getId() .. " AND `guild2` = " .. enemy
            local result_ptr = db.storeQuery("SELECT `id` FROM `guild_wars` WHERE " .. query .. ";")
            if result_ptr then
                str = enemyName .. " have already invited you to war."
                sendGuildChannelMessage(guild:getId(), TALKTYPE_CHANNEL_R1, str)
                return false
            else
                str = "You are already on a war with " .. enemyName .. "."
            end

            if str ~= '' then
                sendGuildChannelMessage(guild:getId(), TALKTYPE_CHANNEL_R1, str)
            end

            local started, ended = os.time(), tonumber(split[3])
            if (ended ~= nil and ended ~= 0) then
                ended = started + (ended * 86400)
            else
                ended = 0
            end

            broadcastMessage(guild:getName() .. " has invited " .. enemyName .. " to war.", MESSAGE_EVENT_ADVANCE)
            local g = {}
            g[1], g[2] = {}, {}
            g[1].id = guild:getId()
            g[1].name = guild:getName()
            g[2].id = enemy
            g[2].name = enemyName
            doCreateInvitationGuildWar(g, 0, started, ended)
        end
        else
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Can only be executed once every " .. cooldown .. " seconds. Remaining cooldown: " .. player:getStorageValue(storage) - os.time())
     end     
        return false
    end