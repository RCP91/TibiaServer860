dofile('data/lib/miscellaneous/warPrivate_lib.lua')
local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGY)
combat:setArea(createCombatArea(AREA_SQUAREWAVE5, AREADIAGONAL_SQUAREWAVE5))

function onGetFormulaValues(player, level, maglevel)
	local min = (level / 5) + (maglevel * 4.5) + 20
	local max = (level / 5) + (maglevel * 7.6) + 48
	return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(creature, variant)
	if(creature:isPlayer()) then
		if(creature:getStorageValue(STORAGE_PLAYER_WAR_TYPE) == WAR_TYPE_SD_ONLY) then
		creature:sendCancelMessage("You are in a war zone that does not allow this spell.")
			return false
		end
	end
	return combat:execute(creature, variant)
end

