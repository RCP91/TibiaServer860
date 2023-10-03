local bless = {1, 2, 3, 4, 5}
local price_bless = 100000

function onSay(player, words, param)

	for i = 1, table.maxn(bless) do
		if player:hasBlessing(bless[i]) then
			player:sendCancelMessage("You already have all blessings.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end
	end

	if player:removeMoney(price_bless) then
		for i = 1, table.maxn(bless) do
			player:addBlessing(bless[i])
		end
		
		player:sendTextMessage(MESSAGE_INFO_DESCR, "You have bought all blessings.")
		player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
	else
		player:sendCancelMessage("You don't have enough money.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	end
	
	return true
end