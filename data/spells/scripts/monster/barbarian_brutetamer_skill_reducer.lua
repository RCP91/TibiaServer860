local combat = createCombatObject()
setCombatParam(combat,COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_SNOWBALL)
setCombatParam(combat,COMBAT_PARAM_EFFECT, CONST_ME_POFF)

local parameters = {
	{key = CONDITION_PARAM_TICKS, value = 5 * 1000},
	{key = CONDITION_PARAM_SKILL_FIST, value = nil},
	{key = CONDITION_PARAM_SKILL_CLUB, value = nil},
	{key = CONDITION_PARAM_SKILL_SWORD, value = nil},
	{key = CONDITION_PARAM_SKILL_AXE, value = nil},
	{key = CONDITION_PARAM_SKILL_DISTANCE, value = nil},
	{key = CONDITION_PARAM_SKILL_SHIELD, value = nil},
	index = nil
}

function onTargetCreature(creature, target)
	target:addAttributeCondition({parameters[1], parameters[parameters.index]})
end

setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

function onCastSpell(cid, var)
	parameters.index = math.random(2, #parameters - 1)
	parameters[parameters.index].value = -math.random(1, 6)
	return doCombat(cid, combat, var)
end
