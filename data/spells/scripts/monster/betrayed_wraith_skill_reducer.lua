local combat = createCombatObject()
setCombatParam(combat,COMBAT_PARAM_EFFECT, CONST_ME_YELLOW_RINGS)

local area = createCombatArea(AREA_SQUAREWAVE5)
setCombatArea(combat, area)

local parameters = {
	{key = CONDITION_PARAM_TICKS, value = 5 * 1000},
	{key = CONDITION_PARAM_SKILL_DISTANCEPERCENT, value = 80}
}

function onTargetCreature(creature, target)
	target:addAttributeCondition(parameters)
end

setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
