function onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if CASTLE then
		primaryDamage, primaryType, secondaryDamage, secondaryType = CASTLE:onGeneratorChangeHealth(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	end
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end