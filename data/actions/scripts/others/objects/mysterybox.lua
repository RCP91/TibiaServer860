local prize = {
    [1] = {chance = 50, id = 28037, amount = 1 },
    [2] = {chance = 50, id = 28036, amount = 1 },
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)

    for i = 1,#prize do local number = math.random() * 100
    if prize[i].chance>100-number then
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        player:addItem(prize[i].id, prize[i].amount)
        item:remove()
        break
    end
    end
    return true
end
