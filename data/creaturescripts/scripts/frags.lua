local skulls = {SKULL_WHITE, SKULL_YELLOW, SKULL_RED, SKULL_BLACK}

function addPlayerFrag(cid, value)
	db.executeQuery("UPDATE `players` SET `frags_all` = `frags_all` + " .. value .. " WHERE `id` = " .. getPlayerGUID(cid) .. ";")
	return true
end

function onKill(cid, target)
    if isPlayer(cid) and isPlayer(target) then
    	for i= 1, #skulls do
    		if getPlayerSkullType(target) == skulls[i]  then
    			addPlayerFrag(cid, 1)
    			break
    		end
    	end
    end
    return true
end

function onLogin(cid)
	registerCreatureEvent(cid, "TopFrags")
	return true
end