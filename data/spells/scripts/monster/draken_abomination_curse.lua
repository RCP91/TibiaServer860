local combat = createCombatObject()
setCombatParam(combat,COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
setCombatParam(combat,COMBAT_PARAM_EFFECT, CONST_ME_SMALLCLOUDS)
setCombatParam(combat,COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_DEATH)

function onTargetCreature(creature, target)
	creature:addDamageCondition(target, CONDITION_CURSED, DAMAGELIST_EXPONENTIAL_DAMAGE, math.random(62, 128))
end

setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end