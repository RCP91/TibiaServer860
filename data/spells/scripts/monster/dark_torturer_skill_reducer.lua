local combat = createCombatObject()
setCombatParam(combat,COMBAT_PARAM_EFFECT, CONST_ME_SOUND_PURPLE)

local area = createCombatArea(AREA_SQUAREWAVE6)
setCombatArea(combat, area)

local parameters = {
	{key = CONDITION_PARAM_TICKS, value = 8 * 1000},
	{key = CONDITION_PARAM_SKILL_SHIELDPERCENT, value = 85}
}

function onTargetCreature(creature, target)
	target:addAttributeCondition(parameters)
end

setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
