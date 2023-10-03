local STORAGE_PREMIUM = 64555
local TEMPLE_ID = 1

function onLogin(cid)
	local player = Player(cid)

	if player:getPremiumDays() < 1 and player:getStorageValue(STORAGE_PREMIUM) > 0 then
		player:setStorageValue(STORAGE_PREMIUM, 0)
		player:teleportTo(Town(TEMPLE_ID):getTemplePosition())
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:setTown(TEMPLE_ID)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Sua premium acabou!")
	end

	return true
end