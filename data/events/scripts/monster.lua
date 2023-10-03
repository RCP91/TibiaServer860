function Monster:onDropLoot(corpse)
	local mType = self:getType()
	if mType:isRewardBoss() then
		corpse:registerReward()
		return
	end

	local player = Player(corpse:getCorpseOwner())
	local mType = self:getType()
	if not player or player:getStamina() > 840 then
		local monsterLoot = mType:getLoot()
		for i = 1, #monsterLoot do
			local item = corpse:createLootItem(monsterLoot[i])
			if not item then
				print('[Warning] DropLoot:', 'Could not add loot item to corpse.')
			end
		end

		if player then
			local text = ("Loot of %s: %s"):format(mType:getNameDescription(), corpse:getContentDescription())
			local party = player:getParty()
			if party then
				party:broadcastPartyLoot(text)
			else
				player:sendTextMessage(MESSAGE_LOOT, text)
			end
		end
	else
		local text = ("Loot of %s: nothing (due to low stamina)"):format(mType:getNameDescription())
		local party = player:getParty()
		if party then
			party:broadcastPartyLoot(text)
		else
			player:sendTextMessage(MESSAGE_LOOT, text)
		end
	end
end
