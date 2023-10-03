function onPrepareDeath(cid, lastHitKiller, mostDamageKiller)
if(not isPlayer(cid)) then
return true
end
if Game.getStorageValue(t.a) == 1 then
if((cid:getStorageValue(t.g) % 2) == 1) then
    Game.setStorageValue(t.u, Game.getStorageValue(t.u)+1)
else
    Game.setStorageValue(t.l, Game.getStorageValue(t.l)+1)
end
local red = Game.getStorageValue(t.l)
local blue = Game.getStorageValue(t.u)
if blue < t.v or red < t.v then
if(isPlayer(cid) == false) then
return true
end
if((cid:getStorageValue(t.g) % 2) == 1) then
doTeleportThing(cid, t.d_1)
doSendMagicEffect(getCreaturePosition(cid), 10)
cid:addHealth(cid:getMaxHealth())
cid:addMana(cid:getMaxMana())
doPlayerRemoveLethalConditions(cid)
--if getCreatureSkullType(cid) == SKULL_WHITE then
--doCreatureSetSkullType(cid, 0)
--end
else
doTeleportThing(cid, t.d_2)
doSendMagicEffect(getCreaturePosition(cid), 10)
cid:addHealth(cid:getMaxHealth())
cid:addMana(cid:getMaxMana())
doPlayerRemoveLethalConditions(cid)
--if getCreatureSkullType(cid) == SKULL_WHITE then
--doCreatureSetSkullType(cid, 0)
--end
end
end
if blue >= t.v then
broadcastMessage(t.y, MESSAGE_STATUS_WARNING)
Game.setStorageValue(t.h, 1)
for _, pid in ipairs(Game.getPlayers()) do
if(pid:getStorageValue(t.f_1) == 1) then
doPlayerAddItem(pid, t.i_1, t.i_2)
end
end
elseif red >= t.v then
broadcastMessage(t.o, MESSAGE_STATUS_WARNING)
Game.setStorageValue(t.h, 1)
for _, pid in ipairs(Game.getPlayers()) do
if(pid:getStorageValue(t.f_2) == 1) then
doPlayerAddItem(pid, t.i_1, t.i_2)
end
end
end
if Game.getStorageValue(t.h) == 1 then
Game.setStorageValue(t.a, 0)
Game.setStorageValue(t.h, 0)
Game.setStorageValue(t.wv, -1)
cid:setStorageValue(t.f, -1)
cid:setStorageValue(t.g, 0)
cid:setStorageValue(t.l, 0)
cid:setStorageValue(t.u, 0)
cid:setStorageValue(t.f_1, -1)
cid:setStorageValue(t.f_2, -1)
cid:setStorageValue(t.h, -1)
doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)), true)
cid:removeCondition(CONDITION_OUTFIT)
doSendMagicEffect(getCreaturePosition(cid), 10)
cid:addHealth(cid:getMaxHealth())
cid:addMana(cid:getMaxMana())
doPlayerRemoveLethalConditions(cid)
for _, pid in ipairs(Game.getPlayers()) do
if(pid:getStorageValue(t.f_1) == 1 or pid:getStorageValue(t.f_2) == 1) then
pid:setStorageValue(t.f, -1)
doTeleportThing(pid, getTownTemplePosition(getPlayerTown(pid)))
pid:removeCondition(CONDITION_OUTFIT)
doSendMagicEffect(getCreaturePosition(pid), CONST_ME_TELEPORT)
pid:setStorageValue(t.g, 0)
pid:setStorageValue(t.l, 0)
pid:setStorageValue(t.u, 0)
pid:setStorageValue(t.f_1, -1)
pid:setStorageValue(t.f_2, -1)
pid:setStorageValue(t.h, -1)
pid:addHealth(pid:getMaxHealth())
pid:addMana(pid:getMaxMana())
doPlayerRemoveLethalConditions(pid)
end
end
return false
end
return false
end
return true
end