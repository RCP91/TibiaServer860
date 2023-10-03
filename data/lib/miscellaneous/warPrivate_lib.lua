--[[ Global Configs ]]--
warPrivate_duration = 2 -- Time Duration of a War.

--[[ Player Storages ]]--
warPrivate_storage = 95160 -- City
warPrivate_UE = 95600 -- NOUE
warPrivate_RUNES = 95601 -- NORUNES
warPrivate_Guild = 95602 -- Guild

--- Edron
warPrivate_city1 = {
	city = 1,
	time = 95161,
	war = {guild = 95162, enemy = 95163, ue = 95164, runes = 95165, limite = 95300, count1 = 95302, count2 = 95303},
	wait = {invite = 95166, accept = 95167, ue = 95168, runes = 95169, limite = 95301},
	pos_guild = Position(30694, 30130, 7),
	pos_enemy = Position(30701, 30085, 6),
}

--- Darashia
warPrivate_city2 = {
	city = 2,
	time = 95171,
	war = {guild = 95172, enemy = 95173, ue = 95174, runes = 95175, limite = 95310, count1 = 95312, count2 = 95313},
	wait = {invite = 95176, accept = 95177, ue = 95178, runes = 95179, limite =  95311},
	pos_guild = Position(30091, 30346, 7),
	pos_enemy = Position(30166, 30374, 6),
}

--- ankrahmun
warPrivate_city3 = {
	city = 3,
	time = 95181,
	war = {guild = 95182, enemy = 95183, ue = 95184, runes = 95185, limite =  95320, count1 = 95322, count2 = 95323},
	wait = {invite = 95186, accept = 95187, ue = 95188, runes = 95189, limite =  95321},
	pos_guild = Position(30409, 30645, 7),
	pos_enemy = Position(30375, 30688, 6),
}

--- yalahar
warPrivate_city4 = {
	city = 4,
	time = 95191,
	war = {guild = 95192, enemy = 95193, ue = 95194, runes = 95195, limite =  95330, count1 = 95332, count2 = 95333},
	wait = {invite = 95196, accept = 95197, ue = 95198, runes = 95199, limite =  95331},
	pos_guild = Position(30755, 30416, 7),
	pos_enemy = Position(30785, 30441, 6),
}

--- carlin
warPrivate_city5 = {
	city = 5,
	time = 95250,
	war = {guild = 95251, enemy = 95253, ue = 95254, runes = 95255, limite =  95340, count1 = 95342, count2 = 95343},
	wait = {invite = 95256, accept = 95257, ue = 95258, runes = 95259, limite =  95341},
	pos_guild = Position(30116, 30086, 7),
	pos_enemy = Position(30176, 30124, 6),
}

function Finished_EventWar(player)
	local player = Player(cid)

	if player:getStorageValue(warPrivate_storage) > 0 then
		player:setStorageValue(warPrivate_UE, 0)
		player:setStorageValue(warPrivate_RUNES, 0)
		player:unregisterEvent("WarPrivateDeath")
		player:setStorageValue(44672, 0)
		player:teleportTo(player:getTown():getTemplePosition())
		if (tableCities[player:getStorageValue(warPrivate_storage)]) then
			local lib = tableCities[player:getStorageValue(warPrivate_storage)]
			if (player:getStorageValue(warPrivate_Guild) == 1) then
				Game.setStorageValue(lib.war.count1, Game.getStorageValue(lib.war.count1) - 1)
			elseif (player:getStorageValue(warPrivate_Guild) == 2) then
				Game.setStorageValue(lib.war.count2, Game.getStorageValue(lib.war.count2) - 1)
			end
			player:setStorageValue(warPrivate_Guild, 0)
			player:setStorageValue(warPrivate_storage, 0)
		end
	end

	return true
end