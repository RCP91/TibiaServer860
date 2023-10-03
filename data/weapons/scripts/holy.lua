 local combat = Combat()
	 combat:setParameter(COMBAT_PARAM_BLOCKARMOR, 1)
	 combat:setParameter(COMBAT_PARAM_BLOCKSHIELD, 1)
	 combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HOLYDAMAGE)
     combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_holy)
	  combat:setFormula(COMBAT_FORMULA_SKILL, 1, 1, 1, 1)

 function onUseWeapon(player, variant)
 	return combat:execute(player, variant)
 end