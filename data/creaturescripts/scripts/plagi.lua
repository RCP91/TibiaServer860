local position = Position(33174, 31511, 13) -- aqui onde seu teleport vai ficar, e onde ele vai sumir
 
local function removeTeleport(position)
local teleportItem = Tile(position):getItemById(1387)
if teleportItem then
teleportItem:remove()
position:sendMagicEffect(CONST_ME_POFF)
end
end
 
 
function onDeath(creature, target, deathlist)
local targetMonster = target:getMonster()
if not targetMonster then
return true
end
if targetMonster:getName():lower() == 'Demon' then -- aqui tu coloca o nome do monstro que quando morrer vai surgir o tp
local item = Game.createItem(1387, 1, position)
if item:isTeleport() then
item:setDestination(Position(X, Y, Z))
addEvent(removeTeleport, 2 * 60 * 1000)
end
end
return true
end