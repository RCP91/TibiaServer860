function onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
	if CASTLE then
		CASTLE:onGeneratorDeath(creature, killer)
	end
	return true
end