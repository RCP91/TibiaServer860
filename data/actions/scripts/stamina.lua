--script made by Sh4dowDan
function onUse(player, item, fromPosition, itemEx, toPosition, isHotkey)

    local s = player:getStamina() / 60
    local cfg = {}
        cfg.refuel = 42
        cfg.full = 40

    if s >= cfg.full then
        player:sendCancelMessage("Your stamina is already full.")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Your stamina now is "..s.." h.")
    else
        player:setStamina(cfg.refuel*60)
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Your stamina has been refilled.")
        item:remove(1)
    end
    return true
end