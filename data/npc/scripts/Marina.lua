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
	
	if msgcontains(msg, "silk") or msgcontains(msg, "yarn") or msgcontains(msg, "silk yarn") or msgcontains(msg, "spool of yarn") then
		if getPlayerStorageValue(cid, Storage.FriendsandTraders.TheMermaidMarina) < 1 then
			selfSay("Um. You mean, you really want me to touch that gooey spider silk just because you need yarn? Well... do you think that I'm pretty?", cid)
			talkState[talkUser] = 1
		elseif getPlayerStorageValue(cid, Storage.FriendsandTraders.TheMermaidMarina) == 2 then
			selfSay("Okay... a deal is a deal, would you like me to create a {spool of yarn} from {10 pieces of spider silk}?", cid)
			talkState[talkUser] = 5
		end
	elseif msgcontains(msg, "honey") or msgcontains(msg, "honeycomb") or msgcontains(msg, "50 honeycombs") then
		if getPlayerStorageValue(cid, Storage.FriendsandTraders.TheMermaidMarina) == 1 then
			selfSay("Did you bring me the 50 honeycombs I requested and do you absolutely admire my beauty?", cid)
			talkState[talkUser] = 4
		end
	elseif msgcontains(msg, "raymond striker") then
		if getPlayerStorageValue(cid, Storage.TheShatteredIsles.APoemForTheMermaid) == 1 then
			selfSay("<giggles> I think he has a crush on me. Well, silly man, it is only for his own good. This way he can get accustomed to TRUE beauty. And I won't give him up anymore now that he is mine.", cid)
			setPlayerStorageValue(cid, Storage.TheShatteredIsles.APoemForTheMermaid, 2)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "date") then
		if getPlayerStorageValue(cid, Storage.TheShatteredIsles.ADjinnInLove) == 1 then
			selfSay("Is that the best you can do? A true Djinn would have done something more poetic.", cid)
			setPlayerStorageValue(cid, Storage.TheShatteredIsles.ADjinnInLove, 2)
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.TheShatteredIsles.ADjinnInLove) == 4 then
			selfSay({
				"This lovely, exotic Djinn is a true poet. And he is asking me for a date? Excellent. Now I can finaly dump this human pirate. He was growing to be boring more and more with each day ...",
				"As a little reward for your efforts I allow you to ride my sea turtles. Just look around at the shores and you will find them."
			}, cid)
			--player:addAchievement('Matchmaker')
			setPlayerStorageValue(cid, Storage.TheShatteredIsles.ADjinnInLove, 5)
			setPlayerStorageValue(cid, Storage.TheShatteredIsles.AccessToLagunaIsland, 1)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			selfSay("Well, everyone would say that in your position. Do you think that I'm really, absolutely the most stunning being that you have ever seen?", cid)
			talkState[talkUser] = 2
		elseif talkState[talkUser] == 2 then
			selfSay({
				"<giggles> It's funny how easy it is to get humans to say what you want. Now, proving it will be even more fun! ...",
				"You want me to touch something gooey, so you have to touch something gooey for me too. <giggles> ...",
				"I love honey and I haven't eaten it in a while, so bring me 50 honeycombs and worship my beauty a little more, then we will see."
			}, cid)
			setPlayerStorageValue(cid, Storage.FriendsandTraders.TheMermaidMarina, 1)
			setPlayerStorageValue(cid, Storage.FriendsandTraders.DefaultStart, 1)
		elseif talkState[talkUser] == 4 then
			if doPlayerRemoveItem(cid, 5902, 50) then
				selfSay("Oh goodie! Thank you! Okay... I guess since my fingers are sticky now anyway, I will help you. From now on, if you bring me {10 pieces of spider silk}, I will create one {spool of yarn}.", cid)
				talkState[talkUser] = 0
				setPlayerStorageValue(cid, Storage.FriendsandTraders.TheMermaidMarina, 2)
			else
				selfSay("You don't have enough honey.", cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 5 then
			if doPlayerRemoveItem(cid, 5879, 10) then
				doPlayerAddItem(cid, 5886, 1)
				selfSay("Ew... gooey... there you go.", cid)
				talkState[talkUser] = 0
			else
				selfSay("You don't have the required items.", cid)
				talkState[talkUser] = 0
			end
		end
	end
	return true
end

keywordHandler:addKeyword({'mermaid comb'}, StdModule.say, {npcHandler = npcHandler, text = 'Sorry, I don\'t have a spare comb. I lost my favourite one when diving around in Calassa.'})

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
