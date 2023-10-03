function onTime(interval, lastExecution)
Game.setStorageValue(t.g, 1)
Game.setStorageValue(t.u, 0)
Game.setStorageValue(t.l, 0)
Game.setStorageValue(t.a, 1)
Game.setStorageValue(t.c, 0)
Game.setStorageValue(t.wv, 0)
broadcastMessage("Attention! Immediately register to Rush Event, event will start for ".. t.t .." minutes. All players can join to event typing this command: !rush", MESSAGE_STATUS_WARNING)
addEvent(function()
broadcastMessage("Massive team battles starts in 2 minutes. If you want to join, type in the command: !rush", MESSAGE_STATUS_WARNING)
end, (t.t - 2) * 1000 * 60)
addEvent(function()
broadcastMessage("Massive team battles starts in a minute. If you want to join, type in the command: !rush", MESSAGE_STATUS_WARNING)
end, (t.t - 1) * 1000 * 60)
addEvent(start, t.t * 1000 * 60, cid)
end
function results()
if(Game.getStorageValue(t.a) == 1) then
local red = Game.getStorageValue(t.l)
local blue = Game.getStorageValue(t.u)
broadcastMessage("Massive team battle, results:\nRed Team scored: ".. red .." frags.\nBlue Team scored: ".. blue .." frags.\nMatch is under way to ".. t.v .." frags.", MESSAGE_STATUS_WARNING)
addEvent(results, t.r * 1000 * 60)
end
end
function start(cid)
if(Game.getStorageValue(t.a) == 1 and Game.getStorageValue(t.c) >= t.mn) then
broadcastMessage(t.q, MESSAGE_STATUS_WARNING)
Game.setStorageValue(t.wv, 1)
addEvent(results, t.r * 1000 * 60)
for _, pid in ipairs(Game.getPlayers()) do
if pid:getStorageValue(t.f) == 1 then
pid:addHealth(pid:getMaxHealth())
pid:addMana(pid:getMaxMana())
if((pid:getStorageValue(t.g) % 2) == 1) then
outfit = pid:getOutfit()
local conditionRed = Condition(CONDITION_OUTFIT)
conditionRed:setTicks(120 * 60 * 1000)
conditionRed:setOutfit({lookType = outfit.lookType, lookHead = 94, lookBody = 94, lookLegs = 94, lookFeet = 94})
pid:addCondition(conditionRed)
pid:setStorageValue(t.h, 0)
doTeleportThing(pid, t.d_1)
pid:setStorageValue(t.f, 1)
pid:setStorageValue(t.f_1, 0)
pid:setStorageValue(t.f_2, 1)
doSendMagicEffect(getCreaturePosition(pid), 10)
doPlayerSendTextMessage(pid, MESSAGE_EVENT_ADVANCE, "You are in RED TEAM!\nThis battle will continue up to ".. t.v .." frags!")
else
outfit = pid:getOutfit()
local conditionBlue = Condition(CONDITION_OUTFIT)
conditionBlue:setTicks(120 * 60 * 1000)
conditionBlue:setOutfit({lookType = outfit.lookType, lookHead = 86, lookBody = 86, lookLegs = 86, lookFeet = 86})
pid:addCondition(conditionBlue)
pid:setStorageValue(t.h, 0)
doTeleportThing(pid, t.d_2)
pid:setStorageValue(t.f, 1)
pid:setStorageValue(t.f_1, 1)
pid:setStorageValue(t.f_2, 0)
doSendMagicEffect(getCreaturePosition(pid), 10)
doPlayerSendTextMessage(pid, MESSAGE_EVENT_ADVANCE, "You are in BLUE TEAM!\nThis battle will continue up to ".. t.v .." frags!")
end
end
end
elseif(Game.getStorageValue(t.c) < t.mn) then
broadcastMessage(t.x, MESSAGE_STATUS_WARNING)
Game.setStorageValue(t.a, 0)
for _, pid in ipairs(Game.getPlayers()) do
if pid:getStorageValue(t.f) == 1 then
pid:setStorageValue(t.f, -1)
doTeleportThing(pid, getTownTemplePosition(getPlayerTown(pid)))
doSendMagicEffect(getCreaturePosition(pid), CONST_ME_TELEPORT)
end
end
end
end