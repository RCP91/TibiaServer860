local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
combat:setArea(createCombatArea(AREA_CIRCLE5X5))

function onGetFormulaValues(player, level, magicLevel)
	local min = (level / 5) + (magicLevel * 6.5) + 25
	local max = (level / 5) + (magicLevel * 12) + 50
	return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(creature, variant)
	if(creature:isPlayer()) then
		if(creature:getStorageValue(STORAGE_PLAYER_WAR_TYPE) == WAR_TYPE_NO_UE or
		creature:getStorageValue(STORAGE_PLAYER_WAR_TYPE) == WAR_TYPE_SD_ONLY) then
		creature:sendCancelMessage("You are in a war zone that does not allow this spell.")
			return false
		end
	end
	return combat:execute(creature, variant)
end
