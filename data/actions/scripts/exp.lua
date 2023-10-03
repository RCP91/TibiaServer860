function onUse(cid, item, fromPosition, itemEx, toPosition)
    local player = Player(cid)
    if player:getStorageValue(1234) >= os.time() then
         player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You already 25% exp! expire '..os.date ("%d %B %Y %X ",player:getStorageValue(1234)))
        return true
    end

    player:setStorageValue(1234, os.time() + 2592000)
    Item(item.uid):remove(1)
      player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Your 30 days of 25% XP has started!')
	  player:getPosition():sendMagicEffect(48)
    return true
end

function Player:onGainExperience(source, exp, rawExp)
    if self:getStorageValue(1234) >= os.time() then
        exp = exp * 1.25
    end
    return exp
end