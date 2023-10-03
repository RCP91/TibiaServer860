function onDeath(cid)
    for b = 1, 5 do
        if isPlayer(cid) and getPlayerBlessing(cid, b) and getCreatureSkullType(cid) < 4 then
            doCreatureSetDropLoot(cid, false)
        end
    end

    return true
end