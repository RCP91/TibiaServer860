local combat = createCombatObject()
setCombatParam(combat,COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGY)

local area = createCombatArea(AREA_BEAM1)
setCombatArea(combat, area)

local parameters = {
	{key = CONDITION_PARAM_TICKS, value = 6 * 1000},
	{key = CONDITION_PARAM_SKILL_MELEEPERCENT, value = nil}
}

function onTargetCreature(creature, target)
	target:addAttributeCondition(parameters)
end

setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

function onCastSpell(cid, var)
	parameters[2].value = math.random(70, 80)
	return doCombat(cid, combat, var)
end
