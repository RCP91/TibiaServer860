local guilds = {}

function onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    local isGuild = false
    local damage = primaryDamage + secondaryDamage

    if attacker:isPlayer() == false then
        if attacker:getMaster() == false then
            return
        end
        attacker = attacker:getMaster()
    end

    if attacker:getGuild() == nil then
        return
    end

    for k,v in pairs(guilds) do
        if v[1] == attacker:getGuild():getId() then
            v = {v[1], v[2] + damage}
            isGuild = true
            break
        end
    end


    if not isGuild then
        guilds[#guilds+1] = {attacker:getGuild():getId(), damage}
    end

    if creature:getHealth() - damage <= 0 then
        table.sort(guilds, function(a,b) return a[2] > b[2] end)
        db.query("CREATE TABLE IF NOT EXISTS `castle` (`guild_id` int(11) NOT NULL, guild_name varchar(255) NOT NULL) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;")
        db.query("DELETE FROM `castle`")
        if guilds[1][1] ~= nil then
            local info = db.storeQuery("SELECT `name`, `ownerid` FROM `guilds` WHERE `id` = " .. guilds[1][1] .. " LIMIT 1")
            local name = result.getString(info, "name")
            local owner = result.getString(info, "ownerid")
            db.query("INSERT INTO `castle` VALUES (".. guilds[1][1] ..", '".. name .."')")
            broadcastMessage(woe.eventName.." has ended. Congratulations to ".. name .." for claiming ownership of the castle!", MESSAGE_EVENT_ADVANCE)
            Tile(woe.castle):getHouse():setOwnerGuid(owner)
        end
        guilds = {}

        for k,v in pairs(woe.doors) do

            if Creature(v.name) ~= nil then
                Creature(v.name):remove()
            end
        
            local door = Game.createItem(v.id, 1, v.pos)
            door:setActionId(woe.actionid)
        end

    end

    return primaryDamage, primaryType, -secondaryDamage, secondaryType
end