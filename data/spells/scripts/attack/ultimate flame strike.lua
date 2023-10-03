local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_FIREATTACK)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_FIRE)

function onGetFormulaValues(player, level, maglevel)
	local min = (level / 5) + (maglevel * 4.5) + 35
	local max = (level / 5) + (maglevel * 7.3) + 55
	return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")
local function executeAttack(cid, variant, i, j)
    local player = Player(cid)
    if not player then
        return
    end
    if i >= j then
        return
    end
    addEvent(executeAttack, 200, cid, variant, i + 1, j)
    return combat:execute(player, variant)
end

local storage = 123456
local exhaust = 10

function resetStorage(cid)
    local player = Player(cid)
    if player then
        player:setStorageValue(storage, -1)
    end
end

function onCastSpell(creature, variant, isHotkey)
    -- is the creature who is using this spell a player, always good to check
    if creature:isPlayer() then
        -- have they used this spell yet?
        if creature:getStorageValue(storage) < 0 then
            -- when they do lets set the storage value so they can't use it again
            creature:setStorageValue(storage, 1)
            -- make preperations to reset the storage value
            addEvent(resetStorage, exhaust * 1000, creature:getId())
            -- execute the spell
            return executeAttack(creature:getId(), variant, 0, 1)
        else
            -- if they have used the spell warn them they need to wait to use it again
            creature:sendCancelMessage("This spell is still cooling down.")
        end
    end
    -- if the nested else executes or creature is not a player then the spell will return false and not perform any actions
    return false
end