dofile('data/lib/miscellaneous/warPrivate_lib.lua')
local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_FIREAREA)
combat:setArea(createCombatArea(AREA_CROSS5X5))

function onGetFormulaValues(player, level, maglevel)
	local min = (level / 5) + (maglevel * 8) + 50
	local max = (level / 5) + (maglevel * 12) + 75
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
