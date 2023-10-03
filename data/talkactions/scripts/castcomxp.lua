function onSay(player, words, param)
	local defaultParam = param

	param = param:lower()
	if param == '' or param == "on" then
		if not player:isLiveCaster() then
			player:startLiveCast()
		CASTEXP[player:getName()] = os.time() + CASTEXP_NEEDTIME	
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You have started casting your gameplay.")
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Apos 20 segundos de cast aberto voce receberar 5% a mais de experiencia.')
		end
	elseif param == "off" then
		if player:isLiveCaster() then
			player:stopLiveCast()
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You have stop casting your gameplay.")
		CASTEXP[player:getName()] = nil
		end
	else -- a password
		if not player:isLiveCaster() then
			player:startLiveCast(defaultParam)
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You have started casting password your gameplay.")
		CASTEXP[player:getName()] = nil
		end
	end
end 