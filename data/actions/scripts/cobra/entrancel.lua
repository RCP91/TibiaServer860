local teleportPosition = Position(33385, 32626, 7)
    local inFight = getCreatureCondition(cid, CONDITION_INFIGHT)
--// <action actionid="4444" script="teleportTree.lua"/>

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if inFight == FALSE then
        player:teleportTo(teleportPosition)
        teleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
    end
    return true
end