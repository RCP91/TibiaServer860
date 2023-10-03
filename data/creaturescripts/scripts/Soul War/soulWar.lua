local cfg = {
	["goshnars greed"] = {storage = 1125581945},
	["goshnars cruelty"] = {storage = 1025589455},
	["goshnars hatred"] = {storage = 1025589452},
	["goshnar's malice"] = {storage = 3558945},
	["goshnars spite"] = {storage = 58885555},
	["goshnars megalomania"] = {storage = 85202714555514},
	
	} 
		
function onDeath(creature, corpse, deathList)
local nme = creature:getName():lower()
if cfg[nme] then
	if creature:isMonster() then
		for pid, dmg in next, creature:getDamageMap() do
			if Player(pid) then
				if Player(pid):getStorageValue(cfg[nme].storage) ~= -1 then
					Player(pid):setStorageValue(cfg[nme].storage, 1)
				end
			end
		end
	end
end
return true
end