function onLogin(player)
	player:registerEvent("DeadTP")
	return true
end

function onDeath(player, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)

	-- teleportando o player para o templo
	player:teleportTo(player:getTown():getTemplePosition())

	-- enchenco life e mana
	player:addHealth(player:getMaxHealth())
	player:addMana(player:getMaxMana())

	-- criando efeito de teleport
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)

	return false
end