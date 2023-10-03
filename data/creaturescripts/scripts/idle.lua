local room = {
	x1 = 31514,
	x2 = 31795,
	y1 = 31900,
	y2 = 32530,
	z1 = 7,
	z2 = 7
}

function onThink(player, interval)
	local target = player:getTarget()
	
	if (player:getIp() > 0) then
		return true
	else
		local pos = player:getPosition()
		if ((pos.x >= room.x1 and pos.x <= room.x2) and (pos.y >= room.y1 and pos.y <= room.y2) and (pos.z >= room.z1 and pos.z <= room.z2)) then
			doRemoveCreature(player)
		end
	end
	return true
end