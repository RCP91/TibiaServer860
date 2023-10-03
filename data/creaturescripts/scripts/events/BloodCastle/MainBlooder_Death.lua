function onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
	if BLOOD then
		BLOOD:onMainBlooderDeath(creature, killer)
	end
	return true
end