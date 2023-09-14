 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local tokenid = 25377

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local function greetCallback(cid)
	talkState[talkUser] = 0
	return true
end



local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	

		-- CHAT
	if msgcontains(msg, "information") and talkState[talkUser] == 0 then
		selfSay({"{Tokens} are small objects made of metal or other materials. You can use them to buy superior equipment from token traders like me.", "There are several ways to obtain the tokens I'm interested in - killing certain bosses, for example. In exchange for a certain amount of tokens, I can offer you some first-class items."}, cid)
		talkState[talkUser] = 0
	elseif msgcontains(msg, "worth") and talkState[talkUser] == 0 then
		selfSay({"Disrupt the Heart of Destruction, fell the World Devourer to prove your worth and you will be granted the power to imbue 'Powerful Strike', 'Powerful Void' and 'Powerful Vampirism'."}, cid)
		talkState[talkUser] = 0
	elseif msgcontains(msg, "tokens") then
		selfSay("If you have any {gold} tokens with you, let's have a look! Maybe I can offer you something in exchange.", cid)
		talkState[talkUser] = 2
	elseif talkState[talkUser] == 2 and msgcontains(msg, "gold") then
		selfSay({"Here are my deals. For 50 of your gold tokens, I sell the following weapons of destruction: I can offer you a one-handed weapon: {sword}, {axe} or {club}. ...", "You may also take a two-handed weapon: {slayer}, {chopper} or {hammer}. I also can offer you a {bow}, {crossbow}, {wand} or {rod}. Furthermore I trade {creature products}. What do you choose?"}, cid)
		talkState[talkUser] = 3
	elseif talkState[talkUser] == 3 and msgcontains(msg, "creature products") then
		selfSay({"I have creature products for the imbuements {strike}, {vampirism} and {void}. Make your choice, please!"}, cid)
		talkState[talkUser] = 4
	elseif msgcontains(msg, "gold") and talkState[talkUser] == 0 then
		selfSay({"Here are my deals. For 50 of your gold tokens, I sell the following weapons of destruction: I can offer you a one-handed weapon: {sword}, {axe} or {club}. ...", "You may also take a two-handed weapon: {slayer}, {chopper} or {hammer}. I also can offer you a {bow}, {crossbow}, {wand} or {rod}. Furthermore I trade {creature products}. What do you choose?"}, cid)
		talkState[talkUser] = 3

		-- ARMAS
	elseif msgcontains(msg, "wand") and talkState[talkUser] == 3 then
	if player:getFreeCapacity() < 35 then
		selfSay("You don\'t have enough cap.", cid)
		talkState[talkUser] = 3
		return false
		end
	if getPlayerItemCount(cid, 25377) >= 50 then
	doPlayerAddItem(cid, 30692, 1)
	doPlayerRemoveItem(cid, 25377, 50)
	selfSay({"Very good. Here's your wand of destruction."}, cid)
		else
			selfSay("I'm sorry but it seems you don't have enough tokens yet. Bring me fifty of them and we'll make a trade.", cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "rod") and talkState[talkUser] == 3 then
	if player:getFreeCapacity() < 35 then
		selfSay("You don\'t have enough cap.", cid)
		talkState[talkUser] = 3
		return false
		end
	if getPlayerItemCount(cid, 25377) >= 50 then
	doPlayerAddItem(cid, 30693, 1)
	doPlayerRemoveItem(cid, 25377, 50)
	selfSay({"Very good. Here's your rod of destruction."}, cid)
		else
			selfSay("I'm sorry but it seems you don't have enough tokens yet. Bring me fifty of them and we'll make a trade.", cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "sword") and talkState[talkUser] == 3 then
	if player:getFreeCapacity() < 50 then
		selfSay("You don\'t have enough cap.", cid)
		talkState[talkUser] = 3
		return false
		end
	if getPlayerItemCount(cid, 25377) >= 50 then
	doPlayerAddItem(cid, 30684, 1)
	doPlayerRemoveItem(cid, 25377, 50)
	selfSay({"Very good. Here's your blade of destruction."}, cid)
		else
			selfSay("I'm sorry but it seems you don't have enough tokens yet. Bring me fifty of them and we'll make a trade.", cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "axe") and talkState[talkUser] == 3 then
	if player:getFreeCapacity() < 50 then
		selfSay("You don\'t have enough cap.", cid)
		talkState[talkUser] = 3
		return false
		end
	if getPlayerItemCount(cid, 25377) >= 50 then
	doPlayerAddItem(cid, 30686, 1)
	doPlayerRemoveItem(cid, 25377, 50)
	selfSay({"Very good. Here's your axe of destruction."}, cid)
		else
			selfSay("I'm sorry but it seems you don't have enough tokens yet. Bring me fifty of them and we'll make a trade.", cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "club") and talkState[talkUser] == 3 then
	if player:getFreeCapacity() < 50 then
		selfSay("You don\'t have enough cap.", cid)
		talkState[talkUser] = 3
		return false
		end
	if getPlayerItemCount(cid, 25377) >= 50 then
	doPlayerAddItem(cid, 30688, 1)
	doPlayerRemoveItem(cid, 25377, 50)
	selfSay({"Very good. Here's your mace of destruction."}, cid)
		else
			selfSay("I'm sorry but it seems you don't have enough tokens yet. Bring me fifty of them and we'll make a trade.", cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "slayer") and talkState[talkUser] == 3 then
	if player:getFreeCapacity() < 70 then
		selfSay("You don\'t have enough cap.", cid)
		talkState[talkUser] = 3
		return false
		end
	if getPlayerItemCount(cid, 25377) >= 50 then
	doPlayerAddItem(cid, 30685, 1)
	doPlayerRemoveItem(cid, 25377, 50)
	selfSay({"Very good. Here's your slayer of destruction."}, cid)
		else
			selfSay("I'm sorry but it seems you don't have enough tokens yet. Bring me fifty of them and we'll make a trade.", cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "chopper") and talkState[talkUser] == 3 then
	if player:getFreeCapacity() < 70 then
		selfSay("You don\'t have enough cap.", cid)
		talkState[talkUser] = 3
		return false
		end
	if getPlayerItemCount(cid, 25377) >= 50 then
	doPlayerAddItem(cid, 30687, 1)
	doPlayerRemoveItem(cid, 25377, 50)
	selfSay({"Very good. Here's your chopper of destruction."}, cid)
		else
			selfSay("I'm sorry but it seems you don't have enough tokens yet. Bring me fifty of them and we'll make a trade.", cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "hammer") and talkState[talkUser] == 3 then
	if player:getFreeCapacity() < 70 then
		selfSay("You don\'t have enough cap.", cid)
		talkState[talkUser] = 3
		return false
		end
	if getPlayerItemCount(cid, 25377) >= 50 then
	doPlayerAddItem(cid, 30689, 1)
	doPlayerRemoveItem(cid, 25377, 50)
	selfSay({"Very good. Here's your hammer of destruction."}, cid)
		else
			selfSay("I'm sorry but it seems you don't have enough tokens yet. Bring me fifty of them and we'll make a trade.", cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "bow") and talkState[talkUser] == 3 then
	if player:getFreeCapacity() < 65 then
		selfSay("You don\'t have enough cap.", cid)
		talkState[talkUser] = 3
		return false
		end
	if getPlayerItemCount(cid, 25377) >= 50 then
	doPlayerAddItem(cid, 30690, 1)
	doPlayerRemoveItem(cid, 25377, 50)
	selfSay({"Very good. Here's your bow of destruction."}, cid)
		else
			selfSay("I'm sorry but it seems you don't have enough tokens yet. Bring me fifty of them and we'll make a trade.", cid)
			talkState[talkUser] = 0
		end

	elseif msgcontains(msg, "crossbow") and talkState[talkUser] == 3 then
	if player:getFreeCapacity() < 65 then
		selfSay("You don\'t have enough cap.", cid)
		talkState[talkUser] = 3
		return false
		end
	if getPlayerItemCount(cid, 25377) >= 50 then
	doPlayerAddItem(cid, 30691, 1)
	doPlayerRemoveItem(cid, 25377, 50)
	selfSay({"Very good. Here's your crossbow of destruction."}, cid)

		else
			selfSay("I'm sorry but it seems you don't have enough tokens yet. Bring me fifty of them and we'll make a trade.", cid)
			talkState[talkUser] = 0
		end

		-- CREATURE PRODUCTS
		-- STRIKE
		elseif talkState[talkUser] == 4 and msgcontains(msg, "strike") then
		selfSay({"You have chosen 'strike'. {Basic}, {intricate} or {powerful}?"}, cid)
		talkState[talkUser] = 5
		elseif talkState[talkUser] == 5 and msgcontains(msg, "powerful") then
		selfSay({'The powerful bundle for the strike imbuement consists of 20 protective charms, 25 sabreteeth and 5 vexclaw talons. Would you like to buy it for 6 gold tokens? ...',
		'Make sure that you have one free slot and that you can carry 101 oz in addition to that.'}, cid)
		talkState[talkUser] = 8
		elseif talkState[talkUser] == 8 and msgcontains(msg, "yes") then
		if player:getFreeCapacity() < 101 then
		selfSay("You don\'t have enough cap.", cid)
		talkState[talkUser] = 4
		return false
		end
		if getPlayerItemCount(cid, 25377) >= 6 then
		doPlayerAddItem(cid, 12400, 20) -- Protective Charm
		doPlayerAddItem(cid, 11228, 25) -- Sabretooth
		doPlayerAddItem(cid, 25384, 5) -- Vexclaw Talon
		doPlayerRemoveItem(cid, 25377, 6)
		selfSay({"Very good. Here's your items."}, cid)
		talkState[talkUser] = 4
			else
			selfSay("I'm sorry but it seems you don't have enough tokens yet. Bring me six of them and we'll make a trade.", cid)
			talkState[talkUser] = 0
			end

		elseif talkState[talkUser] == 5 and msgcontains(msg, "intricate") then
		selfSay({'The intricate bundle for the strike imbuement consists of 20 protective charms and 25 sabreteeth. Would you like to buy it for 4 gold tokens? ...',
		'Make sure that you have one free slot and that you can carry 56 oz in addition to that.'}, cid)
		talkState[talkUser] = 9
		elseif talkState[talkUser] == 9 and msgcontains(msg, "yes") then
		if player:getFreeCapacity() < 56 then
		selfSay("You don\'t have enough cap.", cid)
		talkState[talkUser] = 4
		return false
		end
		if getPlayerItemCount(cid, 25377) >= 4 then
		doPlayerAddItem(cid, 12400, 20) -- Protective Charm
		doPlayerAddItem(cid, 11228, 25) -- Sabretooth
		doPlayerRemoveItem(cid, 25377, 4)
		selfSay({"Very good. Here's your items."}, cid)
		talkState[talkUser] = 4
			else
			selfSay("I'm sorry but it seems you don't have enough tokens yet. Bring me four of them and we'll make a trade.", cid)
			talkState[talkUser] = 0
			end

		elseif talkState[talkUser] == 5 and msgcontains(msg, "basic") then
		selfSay({'The basic bundle for the strike imbuement consists of 20 protective charms. Would you like to buy it for 2 gold tokens? ...',
		'Make sure that you have one free slot and that you can carry 24 oz in addition to that.'}, cid)
		talkState[talkUser] = 10
		elseif talkState[talkUser] == 10 and msgcontains(msg, "yes") then
		if player:getFreeCapacity() < 24 then
		selfSay("You don\'t have enough cap.", cid)
		talkState[talkUser] = 4
		return false
		end
		if getPlayerItemCount(cid, 25377) >= 2 then
		doPlayerAddItem(cid, 12400, 20) -- Protective Charm
		doPlayerRemoveItem(cid, 25377, 2)
		selfSay({"Very good. Here's your items."}, cid)
		talkState[talkUser] = 4
			else
			selfSay("I'm sorry but it seems you don't have enough tokens yet. Bring me two of them and we'll make a trade.", cid)
			talkState[talkUser] = 0
			end

		-- VAMPIRISM
		elseif talkState[talkUser] == 4 and msgcontains(msg, "vampirism") then
		selfSay({"You have chosen 'vampirism'. {Basic}, {intricate} or {powerful}?"}, cid)
		talkState[talkUser] = 6
		elseif talkState[talkUser] == 6 and msgcontains(msg, "basic") then
		selfSay({'The basic bundle for the vampirism imbuement consists of 25 vampire teeth. Would you like to buy it for 2 gold tokens? ...',
		'Make sure that you have one free slot and that you can carry 12.5 oz in addition to that.'}, cid)
		talkState[talkUser] = 11
		elseif talkState[talkUser] == 11 and msgcontains(msg, "yes") then
		if player:getFreeCapacity() < 12.5 then
		selfSay("You don\'t have enough cap.", cid)
		talkState[talkUser] = 4
		return false
		end
		if getPlayerItemCount(cid, 25377) >= 2 then
		doPlayerAddItem(cid, 10602, 25) -- Vampire Teeth
		doPlayerRemoveItem(cid, 25377, 2)
		selfSay({"Very good. Here's your items."}, cid)
		talkState[talkUser] = 4
			else
			selfSay("I'm sorry but it seems you don't have enough tokens yet. Bring me two of them and we'll make a trade.", cid)
			talkState[talkUser] = 0
			end

		elseif talkState[talkUser] == 6 and msgcontains(msg, "intricate") then
		selfSay({'The intricate bundle for the vampirism imbuement consists of 25 vampire teeth and 15 bloody pincers. Would you like to buy it for 4 gold tokens? ...',
		'Make sure that you have one free slot and that you can carry 30.5 oz in addition to that.'}, cid)
		talkState[talkUser] = 12
		elseif talkState[talkUser] == 12 and msgcontains(msg, "yes") then
		if player:getFreeCapacity() < 30.5 then
		selfSay("You don\'t have enough cap.", cid)
		talkState[talkUser] = 4
		return false
		end
		if getPlayerItemCount(cid, 25377) >= 4 then
		doPlayerAddItem(cid, 10602, 25) -- Vampire Teeth
		doPlayerAddItem(cid, 10550, 15) -- Bloody Pincers
		doPlayerRemoveItem(cid, 25377, 4)
		selfSay({"Very good. Here's your items."}, cid)
		talkState[talkUser] = 4
			else
			selfSay("I'm sorry but it seems you don't have enough tokens yet. Bring me four of them and we'll make a trade.", cid)
			talkState[talkUser] = 0
			end

		elseif talkState[talkUser] == 6 and msgcontains(msg, "powerful") then
		selfSay({'The powerful bundle for the vampirism imbuement consists of 25 vampire teeth, 15 bloody pincers and 5 pieces of dead brain. Would you like to it for 6 gold tokens? ...',
		'Make sure that you have one free slot and that you can carry 37.1 oz in addition to that.'}, cid)
		talkState[talkUser] = 13
		elseif talkState[talkUser] == 13 and msgcontains(msg, "yes") then
		if player:getFreeCapacity() < 37.1 then
		selfSay("You don\'t have enough cap.", cid)
		talkState[talkUser] = 4
		return false
		end
		if getPlayerItemCount(cid, 25377) >= 6 then
		doPlayerAddItem(cid, 10602, 25) -- Vampire Teeth
		doPlayerAddItem(cid, 10550, 15) -- Bloody Pincers
		doPlayerAddItem(cid, 10580, 5) -- Piece of Dead Brain
		doPlayerRemoveItem(cid, 25377, 6)
		selfSay({"Very good. Here's your items."}, cid)
		talkState[talkUser] = 4
			else
			selfSay("I'm sorry but it seems you don't have enough tokens yet. Bring me six of them and we'll make a trade.", cid)
			talkState[talkUser] = 0
			end

			-- VOID
		elseif talkState[talkUser] == 4 and msgcontains(msg, "void") then
		selfSay({"You have chosen 'void'. {Basic}, {intricate} or {powerful}?"}, cid)
		talkState[talkUser] = 7
		elseif talkState[talkUser] == 7 and msgcontains(msg, "basic") then
		selfSay({'The basic bundle for the void imbuement consists of 25 rope belts. Would you like to buy it for 2 gold tokens? ...',
		'Make sure that you have one free slot and that you can carry 24.25 oz in addition to that.'}, cid)
		talkState[talkUser] = 14
		elseif talkState[talkUser] == 14 and msgcontains(msg, "yes") then
		if player:getFreeCapacity() < 24.25 then
		selfSay("You don\'t have enough cap.", cid)
		talkState[talkUser] = 4
		return false
		end
		if getPlayerItemCount(cid, 25377) >= 2 then
		doPlayerAddItem(cid, 12448, 25) -- Rope Belt
		doPlayerRemoveItem(cid, 25377, 2)
		selfSay({"Very good. Here's your items."}, cid)
		talkState[talkUser] = 4
			else
			selfSay("I'm sorry but it seems you don't have enough tokens yet. Bring me two of them and we'll make a trade.", cid)
			talkState[talkUser] = 0
			end

		elseif talkState[talkUser] == 7 and msgcontains(msg, "intricate") then
		selfSay({'The intricate bundle for the void imbuement consists of 25 rope belts and 25 silencer claws. Would you like to buy it for 4 gold tokens? ...',
		'Make sure that you have one free slot and that you can carry 129.25 oz in addition to that.'}, cid)
		talkState[talkUser] = 15
		elseif talkState[talkUser] == 15 and msgcontains(msg, "yes") then
		if player:getFreeCapacity() < 129.25 then
		selfSay("You don\'t have enough cap.", cid)
		talkState[talkUser] = 4
		return false
		end
		if getPlayerItemCount(cid, 25377) >= 4 then
		doPlayerAddItem(cid, 12448, 25) -- Rope Belt
		doPlayerAddItem(cid, 22534, 25) -- Silencer Claws
		doPlayerRemoveItem(cid, 25377, 4)
		selfSay({"Very good. Here's your items."}, cid)
		talkState[talkUser] = 4
			else
			selfSay("I'm sorry but it seems you don't have enough tokens yet. Bring me four of them and we'll make a trade.", cid)
			talkState[talkUser] = 0
			end

		elseif talkState[talkUser] == 7 and msgcontains(msg, "powerful") then
		selfSay({'The powerful bundle for the void imbuement consists of 25 rope belts, 25 silencer claws and 5 grimeleech wings. Would you like to buy it for 6 gold tokens? ...',
		'Make sure that you have one free slot and that you can carry 171.75 oz in addition to that.'}, cid)
		talkState[talkUser] = 16
		elseif talkState[talkUser] == 16 and msgcontains(msg, "yes") then
	if player:getFreeCapacity() < 171.75 then
		selfSay("You don\'t have enough cap.", cid)
		talkState[talkUser] = 4
		return false
		end
		if getPlayerItemCount(cid, 25377) >= 6 then
		doPlayerAddItem(cid, 12448, 25) -- Rope Belt
		doPlayerAddItem(cid, 22534, 25) -- Silencer Claws
		doPlayerAddItem(cid, 25386, 5) -- Grimeleech Wings
		doPlayerRemoveItem(cid, 25377, 6)
		selfSay({"Very good. Here's your items."}, cid)
		talkState[talkUser] = 4
			else
			selfSay("I'm sorry but it seems you don't have enough tokens yet. Bring me six of them and we'll make a trade.", cid)
			talkState[talkUser] = 0
			end
		end
	return true
end



local voices = { {text = 'Trading tokens! First-class equipment available!'} }
--npcHandler:addModule(VoiceModule:new(voices))

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
