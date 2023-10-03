local config = {
    cooldown = 20000, -- milliseconds for more precision
    storage = 99999 -- sample storage value
}

function onEquip(player, item, slot)
    if player:getStorageValue(config.storage) <= os.mtime() then
        player:setStorageValue(config.storage, os.mtime() + config.cooldown)
        return true
    end
    player:sendCancelMessage("You cannot equip this item yet")
    return false
end