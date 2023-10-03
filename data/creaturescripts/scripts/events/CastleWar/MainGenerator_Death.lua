function onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
	if CASTLE then
		CASTLE:onMainGeneratorDeath(creature, killer)
	end
	return true
end