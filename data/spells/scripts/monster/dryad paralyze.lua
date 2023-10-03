	local combat = Combat()
	combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_POISONAREA)

	local condition = Condition(CONDITION_PARALYZE)
	condition:setParameter(CONDITION_PARAM_TICKS, 20000)
	condition:setFormula(-0.25, 0, -0.4, 0)
	combat:setCondition(condition)

	local area = createCombatArea(AREA_CIRCLE3X3)
	combat:setArea(area)
	combat:setCondition(condition)

function onCastSpell(creature, var)
	return combat:execute(creature, var)
end
