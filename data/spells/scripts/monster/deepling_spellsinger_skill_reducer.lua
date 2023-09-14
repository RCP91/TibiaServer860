local combat = createCombatObject()
setCombatParam(combat,COMBAT_PARAM_EFFECT, CONST_ME_STUN)
setCombatParam(combat,COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_EXPLOSION)

local area = createCombatArea(AREA_BEAM1)
setCombatArea(combat, area)

local parameters = {
	{key = CONDITION_PARAM_TICKS, value = 8 * 1000},
	{key = CONDITION_PARAM_SKILL_MELEEPERCENT, value = nil},
	{key = CONDITION_PARAM_SKILL_DISTANCEPERCENT, value = nil}
}

function onTargetCreature(creature, target)
	target:addAttributeCondition(parameters)
end

setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

function onCastSpell(cid, var)
	parameters[2].value = math.random(45, 65)
	parameters[3].value = parameters[2].value
	return doCombat(cid, combat, var)
end