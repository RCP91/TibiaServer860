function onThink(interval)
if(Game.getStorageValue(t.a) == 1) then
for _, pid in ipairs(Game.getPlayers()) do
if pid:getStorageValue(t.f) == 1 then
if(pid:getStorageValue(t.f_1) == 0) then
pid:sendTextMessage(29, "RED TEAM!")
elseif(pid:getStorageValue(t.f_1) == 1) then
pid:sendTextMessage(29, "BLUE TEAM!")
end
end
end
return true
end
return true
end