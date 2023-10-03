function onUse(player, item, fromPosition, target, toPosition, isHotkey)
  local teleportPosition = Position(33395, 32660, 6)
  local inFight = getCreatureCondition(cid, CONDITION_INFIGHT)
  local boss = "bosscobra1"
    if inFight == FALSE then
        player:teleportTo(teleportPosition)
        teleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
        doSummonCreature(bosscobra1, teleportPosition)
    end
    return true
end