local cfg = {
amount = 1
}

function onUse(cid, item, fromPosition, itemEx, toPosition)

if getPlayerLevel(cid) > 8 then
doAccountAddCoins(cid, cfg.amount)
doCreatureSay(cid, "Parabéns! Você recebeu 1 Coin! ", TALKTYPE_ORANGE_1)
doSendMagicEffect(getCreaturePosition(cid), 28)
doRemoveItem(item.uid,1)
else
doPlayerSendCancel(cid,"Você precisa de level 8 para usar este item.")
end
return TRUE
end