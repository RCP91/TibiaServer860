local teleportPosition = Position(33314, 32647, 6)
    local inFight = getCreatureCondition(cid, CONDITION_INFIGHT)


function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if inFight == FALSE then
        player:teleportTo(teleportPosition)
        teleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
    end
    return true
end