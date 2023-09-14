local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	if (msg) then
		msg = msg:lower()
	end

	if isInArray({"sail", "passage", "wreck", "liberty bay", "ship"}, msg) then
		if getPlayerStorageValue(cid, Storage.TheShatteredIsles.AccessToGoroma) ~= 1 then
			if getPlayerStorageValue(cid, Storage.TheShatteredIsles.Shipwrecked) < 1 then
				selfSay('I\'d love to bring you back to Liberty Bay, but as you can see, my ship is ruined. I also hurt my leg and can barely move. Can you help me?', cid)
				talkState[talkUser] = 1
			elseif getPlayerStorageValue(cid, Storage.TheShatteredIsles.Shipwrecked) == 1 then
				selfSay('Have you brought 30 pieces of wood so that I can repair the ship?', cid)
				talkState[talkUser] = 3
			end
		else
			selfSay('Do you want to travel back to Liberty Bay?', cid)
			talkState[talkUser] = 4
		end
	elseif msgcontains(msg, 'yes') then
		if talkState[talkUser] == 1 then
			selfSay({
				"Thank you. Luckily the damage my ship has taken looks more severe than it is, so I will only need a few wooden boards. ...",
				"I saw some lousy trolls running away with some parts of the ship. It might be a good idea to follow them and check if they have some more wood. ...",
				"We will need 30 pieces of wood, no more, no less. Did you understand everything?"
			}, cid)
			talkState[talkUser] = 2
		elseif talkState[talkUser] == 2 then
			selfSay('Good! Please return once you have gathered 30 pieces of wood.', cid)
			setPlayerStorageValue(cid, Storage.TheShatteredIsles.DefaultStart, 1)
			setPlayerStorageValue(cid, Storage.TheShatteredIsles.Shipwrecked, 1)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 3 then
			if doPlayerRemoveItem(cid, 5901, 30) then
				selfSay("Excellent! Now we can leave this godforsaken place. Thank you for your help. Should you ever want to return to this island, ask me for a passage to Goroma.", cid)
				setPlayerStorageValue(cid, Storage.TheShatteredIsles.Shipwrecked, 2)
				setPlayerStorageValue(cid, Storage.TheShatteredIsles.AccessToGoroma, 1)
				talkState[talkUser] = 0
			else
				selfSay("You don't have enough...", cid)
			end
		elseif talkState[talkUser] == 4 then
			player:teleportTo(Position(32285, 32892, 6), false)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			selfSay('Set the sails!', cid)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			talkState[talkUser] = 0
		end
	end
	return true
end

keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'My name is Jack Fate from the Royal Tibia Line.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m the captain of this - well, wreck. Argh.'})
keywordHandler:addKeyword({'captain'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m the captain of this - well, wreck. Argh'})
keywordHandler:addKeyword({'goroma'}, StdModule.say, {npcHandler = npcHandler, text = 'This is where we are... the volcano island Goroma. There are many rumours about this place.'})

npcHandler:setMessage(MESSAGE_GREET, "Hello, Sir |PLAYERNAME|. Where can I {sail} you today?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye then.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
