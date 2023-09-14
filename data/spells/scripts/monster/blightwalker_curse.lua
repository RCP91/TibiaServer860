local combat = createCombatObject()
setCombatParam(combat,COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
setCombatParam(combat,COMBAT_PARAM_EFFECT, CONST_ME_SMALLCLOUDS)

local area = createCombatArea(AREA_CIRCLE6X6)
setCombatArea(combat, area)

function onTargetCreature(creature, target)
	creature:addDamageCondition(target, CONDITION_CURSED, DAMAGELIST_EXPONENTIAL_DAMAGE, math.random(52, 154))
end

setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
