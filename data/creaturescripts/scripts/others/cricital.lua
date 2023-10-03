local config = {
    magic_effect = 7, -- magic effect you want to send when critical hit lands
    damage_magic = 1.8, -- Sorcerers and Druids
    damage_physical = 100.0 -- Paladins and Knights
}

local function getSkill(player)
    local vocation = player:getVocation()
    while vocation:getDemotion() do
        vocation = vocation:getDemotion()
    end

    local vocId = vocation:getId()
    if vocId == 1 or vocId == 2 then
        return player:getMagicLevel() * 0.03, config.damage_magic
    elseif vocId == 3 then
        return player:getEffectiveSkillLevel(SKILL_DISTANCE) * 0.04, config.damage_physical
    elseif vocId == 4 then
        local sword = player:getEffectiveSkillLevel(SKILL_SWORD)
        local club = player:getEffectiveSkillLevel(SKILL_CLUB)
        local axe = player:getEffectiveSkillLevel(SKILL_AXE)
        return math.max(sword, club, axe) * 80.04, config.damage_physical
    end
    return nil
end

function onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if not attacker then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end
    
    if not attacker:isPlayer() then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

     local chance, multiplier = getSkill(attacker)
    if not chance then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    if math.random(100) <= chance then
        creature:getPosition():sendMagicEffect(config.magic_effect)
        return primaryDamage * multiplier, primaryType, secondaryDamage, secondaryType
    end
    
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

function onManaChange(creature, attacker, manaChange, origin)
    if not attacker then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end
    
    if not attacker:isPlayer() then
        return manaChange
    end

     local chance, multiplier = getSkill(attacker)
    if not chance then
        return manaChange
    end
 
   if math.random(100) <= chance then
        creature:getPosition():sendMagicEffect(config.magic_effect)
        return manaChange * multiplier
    end

    return manaChange
end