local config = {
	[14515] = Position{x = 31914, y = 32355, z = 8},
	[14516] = Position{x = 31914, y = 32355, z = 8},
	[14530] = Position(33649, 31444, 10),
	[14531] = Position(33649, 31444, 10),
	-- fim ida
}


function onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local teleport = config[item.actionid]

	
	if teleport then
		player:teleportTo(teleport)
		end
		return true
	end