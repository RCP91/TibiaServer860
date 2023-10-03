local setting = {
	centerRoom = {x = 33709, y = 31599, z = 14},
	kickPosition = {x = 33682, y = 31596, z = 14},
	playerTeleport = {x = 33709, y = 31593, z = 14}
}
local SymbolofHatredposRight = {
	[1] = Position(33705, 31596, 14),
}


local function summonSymbolofHatredRight(i)
	local boss = false
	local positionCenter = Position(33709, 31599, 14)
	local spectator = Game.getSpectators(positionCenter, false, false, 20, 20, 20, 20)
	for _, creature in pairs(spectator) do
		if creature:isMonster() then
			if creature:getName():lower() == "goshnar's malice" then
				boss = true
			end
		end
	end
	if boss == true then
		if i >= 1 then
			for j, position in pairs(SymbolofHatredposRight) do
				position:sendMagicEffect(CONST_ME_TELEPORT)
			end
			i = i - 1
			addEvent(summonSymbolofHatredRight, 2*1000, i)
		elseif i == 0 then
			for j, position in pairs(SymbolofHatredposRight) do
				local lava = Game.createMonster("Poor Soul", position)
			end
			addEvent(summonSymbolofHatredRight, 25*1000, 10)
		end
	end
end

local infernoLever = Action()

-- Start Script
function infernoLever.onUse(creature, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 9825 and item.actionid == 49926 then
	local clearOberonRoom = Game.getSpectators(Position(setting.centerRoom), false, false, 15, 15, 15, 15)       
	for index, spectatorcheckface in ipairs(clearOberonRoom) do
		if spectatorcheckface:isPlayer() then
			creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is fighting against the boss! You need wait awhile.")
			return false
		end
	end	
	for index, removeOberon in ipairs(clearOberonRoom) do
		if (removeOberon:isMonster()) then
			removeOberon:remove()
		end
	end
		Game.createMonster("Goshnar's Malice", Position(33713, 31595, 14), false, true)
			addEvent(function()
            Game.createMonster("Malicious Soul", Position(33713, 31602, 14), true, true)
        end, 10 * 1000, 5)
			addEvent(function()
            Game.createMonster("Malicious Soul", Position(33705, 31602, 14), true, true)
        end, 30 * 1000, 5)
			addEvent(function()
            Game.createMonster("Dreadful Harvester", Position(33703, 31597, 14), true, true)
        end, 20 * 1000, 5)
			addEvent(function()
            Game.createMonster("Dreadful Harvester", Position(33706, 31597, 14), true, true)
        end, 40 * 1000, 5)
			addEvent(function()
            Game.createMonster("Dreadful Harvester", Position(33711, 31601, 14), true, true)
        end, 50 * 1000, 5)
	local players = {}
	for i = 0, 4 do
		local player1 = Tile({x = (Position(item:getPosition()).x + 1) + i, y = Position(item:getPosition()).y, z = Position(item:getPosition()).z}):getTopCreature()
		players[#players+1] = player1
	end
		for i, player in ipairs(players) do
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			player:teleportTo(Position(setting.playerTeleport), false)
			doSendMagicEffect(player:getPosition(), CONST_ME_TELEPORT)
			--setPlayerStorageValue(player,setting.storage, os.time() + 20 * 60 * 60)
				addEvent(function()
					local spectatorsOberon = Game.getSpectators(Positsion(setting.centerRoom), false, false, 10, 10, 10, 10)
						for u = 1, #spectatorsOberon, 1 do
							if spectatorsOberon[u]:isPlayer() and (spectatorsOberon[u]:getName() == player:getName()) then
								player:teleportTo(Position(setting.kickPosition))
								player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
								player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Time is over.')
							end
						end
				end, 20 * 60 * 1000)
		end
	end
	return true
end

infernoLever:aid(49926)
infernoLever:register()