local combat = createCombatObject()
setCombatParam(combat,COMBAT_PARAM_EFFECT, CONST_ME_SOUND_YELLOW)

local area = createCombatArea(AREA_CIRCLE3X3)
setCombatArea(combat, area)

local parameters = {
	{key = CONDITION_PARAM_TICKS, value = 5 * 1000},
	{key = CONDITION_PARAM_SKILL_SHIELDPERCENT, value = 60},
	{key = CONDITION_PARAM_SKILL_MELEEPERCENT, value = 70}
}

function onTargetCreature(creature, target)
	target:addAttributeCondition(parameters)
end

setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
