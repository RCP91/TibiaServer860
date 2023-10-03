function onSay(player, words, param)
	if (param == "on") then
		param = nil
	end
	if player:startLiveCast(param) then
		player:sendTextMessage(MESSAGE_INFO_DESCR, "You have started casting your gameplay.")
		
		CASTEXP[player:getName()] = os.time() + CASTEXP_NEEDTIME	
	else
		player:sendCancelMessage("You're already casting your gameplay.")
	end
	return false
end