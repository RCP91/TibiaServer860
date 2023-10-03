function onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
	if BLOOD then
		BLOOD:onBlooderDeath(creature, killer)
	end
	return true
end