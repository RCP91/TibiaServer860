staminaEvents = {}
local config = {
    timeToAdd = 2,
    addTime = 1,
}

local function addStamina(cid)
    local player = Player(cid)
    if not player then
        stopEvent(staminaEvents[cid])
        staminaEvents[cid] = nil
        return true
    end
    player:setStamina(player:getStamina() + config.addTime)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You received "..config.addTime.." minutes of stamina.")
    staminaEvents[cid] = addEvent(addStamina, config.timeToAdd * 60 * 1000, cid)
end

function onStepIn(creature)
    if creature:isPlayer() then
        creature:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You will receive "..config.addTime.." minute of stamina every "..config.timeToAdd.." minutes.")
        staminaEvents[creature:getId()] = addEvent(addStamina, config.timeToAdd * 60 * 1000, creature:getId())
    end
    return true
end

function onStepOut(creature)
    if creature:isPlayer() then
        stopEvent(staminaEvents[creature:getId()])
        staminaEvents[creature:getId()] = nil
    end
    return true
end