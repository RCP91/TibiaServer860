local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
local talkState = {}

function onCreatureAppear(cid)    npcHandler:onCreatureAppear(cid)   end
function onCreatureDisappear(cid)   npcHandler:onCreatureDisappear(cid)   end
function onCreatureSay(cid, type, msg)   npcHandler:onCreatureSay(cid, type, msg)  end
function onThink()     npcHandler:onThink()     end

keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "I am Albinius, a worshipper of the {Astral Shapers}."})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = "Precisely time."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I find ways to unveil the secrets of the stars. Judging by this question, I doubt you follow my weekly publications concerning this research."})

local runes = {
	{runeid = 27622},
	{runeid = 27623},
	{runeid = 27624},
	{runeid = 27625},
	{runeid = 27626},
	{runeid = 27627}
}

local function getTable()
	local itemsList = {
		{name = "heavy old tome", id = 26654, sell = 30}
	}
	return itemsList
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	if msgcontains(msg, "shapers") then
		selfSay({
			"The {Shapers} were an advanced civilisation, well versed in art, construction, language and exploration of our world in their time. ...",
			"The foundations of this {temple} are testament to their genius and advanced understanding of complex problems. They were master craftsmen and excelled in magic."
		}, cid)
	end

    if msgcontains(msg, 'temple') then
		selfSay({
			"The temple has been restored to its former glory, yet we strife to live and praise in the Shaper ways. Do you still need me to take some old tomes from you my child?"
		}, cid)
		talkState[talkUser] = 1
	end
	if msgcontains(msg, "yes") and talkState[talkUser] == 1 and getPlayerItemCount(cid, 26654) >= 5 then
		doPlayerRemoveItem(cid, 26654, 5)
		selfSay('Thank you very much for your contribution, child. Your first step in the ways of the {Shapers} has been taken.', cid)
		setPlayerStorageValue(cid, Storage.ForgottenKnowledge.Tomes, 1)
	elseif  msgcontains(msg, "no") and talkState[talkUser] == 1 then
		selfSay('I understand. Return to me if you change your mind, my child.', cid)
		npcHandler:releaseFocus(cid)
	end

	if msgcontains(msg, 'tomes') and getPlayerStorageValue(cid, Storage.ForgottenKnowledge.Tomes) < 1 then
		selfSay({
			"If you have some old shaper tomes I would {buy} them."
		}, cid)
		talkState[talkUser] = 7
	end

	if msgcontains(msg, 'buy') then
		selfSay("I'm sorry, I don't buy anything. My main concern right now is the bulding of this temple.", cid)
		openShopWindow(cid, getTable(), onBuy, onSell)
	end

	--- ##Astral Shaper Rune##
	if msgcontains(msg, 'astral shaper rune') then
		if getPlayerStorageValue(cid, Storage.ForgottenKnowledge.LastLoreKilled) >= 1 then
			selfSay('Do you wish to merge your rune parts into an astral shaper rune?', cid)
			talkState[talkUser] = 8
		else
			selfSay("I'm sorry but you lack the needed rune parts.", cid)
		end
	end

	if msgcontains(msg, 'yes') and talkState[talkUser] == 8 then
		local haveParts = false
		for k = 1, #runes do
			if doPlayerRemoveItem(cid, runes[k].runeid, 1) then
				haveParts = true
			end
		end
		if haveParts then
			selfSay('As you wish.', cid)
			doPlayerAddItem(cid, 27628, 1)
			npcHandler:releaseFocus(cid)
		end
	elseif msgcontains(msg, 'no') and talkState[talkUser] == 8 then
		selfSay('ok.', cid)
		npcHandler:releaseFocus(cid)
	end

	--- ####PORTALS###
	-- Ice Portal
	if msgcontains(msg, 'ice portal') then
		if getPlayerStorageValue(cid, Storage.ForgottenKnowledge.Tomes) == 1 then
			selfSay({
				"You may pass this portal if you have 50 fish as offering. Do you have the fish with you?"
			}, cid)
			talkState[talkUser] = 2
		else
			selfSay('Sorry, first you need to bring my Heavy Old Tomes.', cid)
		end
	end

	if msgcontains(msg, 'yes') and talkState[talkUser] == 2 then
		if getPlayerStorageValue(cid, Storage.ForgottenKnowledge.AccessIce) < 1 and getPlayerItemCount(cid, 2667) >= 50 then
			doPlayerRemoveItem(cid, 2667, 50)
			selfSay('Thank you for your offering. You may pass the Portal to the Powers of Ice now.', cid)
			setPlayerStorageValue(cid, Storage.ForgottenKnowledge.AccessIce, 1)
		else
			selfSay("I'm sorry, you don't have enough fish. Return if you can offer fifty of them.", cid)
		end
	elseif msgcontains(msg, 'no') and talkState[talkUser] == 2 then
		selfSay("In this case I'm sorry, you may not pass this portal.", cid)
	end

	-- Holy Portal
	if msgcontains(msg, 'holy portal') then
		if getPlayerStorageValue(cid, Storage.ForgottenKnowledge.Tomes) == 1 then
			selfSay({
				"You may pass this portal if you have 50 incantation notes as offering. Do you have the incantation notes with you?"
			}, cid)
			talkState[talkUser] = 3
		else
			selfSay('Sorry, first you need to bring my Heavy Old Tomes.', cid)
		end
	end

	if msgcontains(msg, 'yes') and talkState[talkUser] == 3 then
		if getPlayerStorageValue(cid, Storage.ForgottenKnowledge.AccessGolden) < 1 and getPlayerItemCount(cid, 21246) >= 50 then
			doPlayerRemoveItem(cid, 21246, 50)
			selfSay('Thank you for your offering. You may pass the Portal to the Powers of Holy now.', cid)
			setPlayerStorageValue(cid, Storage.ForgottenKnowledge.AccessGolden, 1)
		else
			selfSay("I'm sorry, you don't have enough incantation notes. Return if you can offer fifty of them.", cid)
		end
	elseif msgcontains(msg, 'no') and talkState[talkUser] == 3 then
		selfSay("In this case I'm sorry, you may not pass this portal.", cid)
	end

	-- Energy Portal
	if msgcontains(msg, 'energy portal') then
		if getPlayerStorageValue(cid, Storage.ForgottenKnowledge.Tomes) == 1 then
			selfSay({
				"You may pass this portal if you have 50 marsh stalker feathers as offering. Do you have the marsh stalker feathers with you?"
			}, cid)
			talkState[talkUser] = 4
		else
			selfSay('Sorry, first you need to bring my Heavy Old Tomes.', cid)
		end
	end

	if msgcontains(msg, 'yes') and talkState[talkUser] == 4 then
		if getPlayerStorageValue(cid, Storage.ForgottenKnowledge.AccessViolet) < 1 and getPlayerItemCount(cid, 19742) >= 50 then
			doPlayerRemoveItem(cid, 19742, 50)
			selfSay('Thank you for your offering. You may pass the Portal to the Powers of Energy now.', cid)
			setPlayerStorageValue(cid, Storage.ForgottenKnowledge.AccessViolet, 1)
		else
			selfSay("I'm sorry, you don't have enough marsh stalker feathers. Return if you can offer fifty of them.", cid)
		end
	elseif msgcontains(msg, 'no') and talkState[talkUser] == 4 then
		selfSay("In this case I'm sorry, you may not pass this portal.", cid)
	end

	-- Earth Portal
	if msgcontains(msg, 'earth portal') then
		if getPlayerStorageValue(cid, Storage.ForgottenKnowledge.Tomes) == 1 then
			selfSay({
				"You may pass this portal if you have 50 acorns as offering. Do you have the acorns with you?"
			}, cid)
			talkState[talkUser] = 5
		else
			selfSay('Sorry, first you need to bring my Heavy Old Tomes.', cid)
		end
	end

	if msgcontains(msg, 'yes') and talkState[talkUser] == 5 then
		if getPlayerStorageValue(cid, Storage.ForgottenKnowledge.AccessEarth) < 1 and getPlayerItemCount(cid, 11213) >= 50 then
			doPlayerRemoveItem(cid, 11213, 50)
			selfSay('Thank you for your offering. You may pass the Portal to the Powers of Earth now.', cid)
			setPlayerStorageValue(cid, Storage.ForgottenKnowledge.AccessEarth, 1)
		else
			selfSay("I'm sorry, you don't have enough acorns. Return if you can offer fifty of them.", cid)
		end
	elseif msgcontains(msg, 'no') and talkState[talkUser] == 5 then
		selfSay("In this case I'm sorry, you may not pass this portal.", cid)
	end

	-- Death Portal
	if msgcontains(msg, 'death portal') then
		if getPlayerStorageValue(cid, Storage.ForgottenKnowledge.Tomes) == 1 then
			selfSay({
				"You may pass this portal if you have 50 pelvis bones as offering. Do you have the pelvis bones with you?"
			}, cid)
			talkState[talkUser] = 6
		else
			selfSay('Sorry, first you need to bring my Heavy Old Tomes.', cid)
		end
	end

	if msgcontains(msg, 'yes') and talkState[talkUser] == 6 then
		if getPlayerStorageValue(cid, Storage.ForgottenKnowledge.AccessDeath) < 1 and getPlayerItemCount(cid, 12437) >= 50 then
			doPlayerRemoveItem(cid, 12437, 50)
			selfSay('Thank you for your offering. You may pass the Portal to the Powers of Death now.', cid)
			setPlayerStorageValue(cid, Storage.ForgottenKnowledge.AccessDeath, 1)
		else
			selfSay("I'm sorry, you don't have enough pelvis bones. Return if you can offer fifty of them.", cid)
		end
	elseif msgcontains(msg, 'no') and talkState[talkUser] == 6 then
		selfSay("In this case I'm sorry, you may not pass this portal.", cid)
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Oh... farewell, child.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
