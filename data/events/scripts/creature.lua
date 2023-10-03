__picif = {}
function Creature:onChangeOutfit(outfit)
	return true
end

function Creature:onAreaCombat(tile, isAggressive)
	return true
end

local function removeCombatProtection(cid)
	local player = Player(cid)
	if not player then
		return true
	end

	local time = 0
	if player:isMage() then
		time = 10
	elseif player:isPaladin() then
		time = 20
	else
		time = 30
	end

	player:setStorageValue(Storage.combatProtectionStorage, 2)
	addEvent(function(cid)
		local player = Player(cid)
		if not player then
			return
		end

		player:setStorageValue(Storage.combatProtectionStorage, 0)
		player:remove()
	end, time * 1000, cid)
end

function Creature:onTargetCombat(target)
if not self then return true end
if self:isPlayer() and target:isPlayer() then
if self:getStorageValue(_Lib_Battle_Info.TeamOne.storage) >= 1 and target:getStorageValue(_Lib_Battle_Info.TeamOne.storage) >= 1 or self:getStorageValue(_Lib_Battle_Info.TeamTwo.storage) >= 1 and target:getStorageValue(_Lib_Battle_Info.TeamTwo.storage) >= 1 then 
return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER
end
end
return true
end

function Creature:onDrainHealth(attacker, typePrimary, damagePrimary, typeSecondary, damageSecondary, colorPrimary, colorSecondary)
	if (not self) then
		return typePrimary, damagePrimary, typeSecondary, damageSecondary, colorPrimary, colorSecondary
	end

	if (not attacker) then
		return typePrimary, damagePrimary, typeSecondary, damageSecondary, colorPrimary, colorSecondary
	end

	-- New prey => Bonus damage
	if (attacker:isPlayer()) then
		if (self:isMonster() and not self:getMaster()) then
			for slot = CONST_PREY_SLOT_FIRST, CONST_PREY_SLOT_THIRD do
				if (attacker:getPreyCurrentMonster(slot) == self:getName() and attacker:getPreyBonusType(slot) == CONST_BONUS_DAMAGE_BOOST) then
					damagePrimary = damagePrimary + math.floor(damagePrimary * (attacker:getPreyBonusValue(slot) / 100))
					break
				end
			end
		end
	-- New prey => Damage reduction
	elseif (attacker:isMonster()) then
		if (self:isPlayer()) then
			for slot = CONST_PREY_SLOT_FIRST, CONST_PREY_SLOT_THIRD do
				if (self:getPreyCurrentMonster(slot) == attacker:getName() and self:getPreyBonusType(slot) == CONST_BONUS_DAMAGE_REDUCTION) then
					damagePrimary = damagePrimary - math.floor(damagePrimary * (self:getPreyBonusValue(slot) / 100))
					break
				end
			end
		end
	end

	return typePrimary, damagePrimary, typeSecondary, damageSecondary, colorPrimary, colorSecondary
end
