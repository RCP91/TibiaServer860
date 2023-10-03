function onStepIn(creature, item, target, fromPosition, toPosition)
    if isPlayer(toPosition:getThing()) then
        creature:teleportTo(fromPosition)
        return player:sendCancelMessage("You cannot walk here.")
    end
return true
end