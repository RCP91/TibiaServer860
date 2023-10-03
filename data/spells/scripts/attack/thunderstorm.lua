dofile('data/lib/miscellaneous/warPrivate_lib.lua')
local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYHIT)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGYBALL)
combat:setArea(createCombatArea(AREA_CIRCLE3X3))

function onGetFormulaValues(player, level, maglevel)
	local min = (level / 5) + (maglevel * 1) + 6
	local max = (level / 5) + (maglevel * 2.6) + 16
	return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(creature, variant, isHotkey)
	if(creature:isPlayer()) then
		if(creature:getStorageValue(STORAGE_PLAYER_WAR_TYPE) == WAR_TYPE_SD_ONLY) then
		creature:sendCancelMessage("You are in a war zone that does not allow this spell.")
			return false
		end
	end
	return combat:execute(creature, variant)
end
