

-- Start Config --
local topos = {33385, 32627, 7} -- Posição para onde o player será teleportado.
-- End Config --
 
function onUse(cid)
   if doTeleportThing(cid, topos) then
  doPlayerSendTextMessage(cid,20,"You have been teleported.") -- Menssagem que aparecerá para o player ao ser teleportado.
 end
end