local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	if msgcontains(msg, "mission") then
		if getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 5 then
			selfSay("I heard you have already helped our cause. Are you interested in another mission, even when it requires you to travel to a distant land?", cid)
			talkState[talkUser] = 1
		elseif getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 7 then
			selfSay("Well done. The termites caused just the distraction that we needed. Are you ready for the next step of my plan?", cid)
			talkState[talkUser] = 3
		elseif getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 9 then
			selfSay("You saved the lives of many innocent animals. Thank you very much. If you are looking for another mission, just ask me.", cid)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 10)
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 10 then
			selfSay("Our warriors need a more potent yet more secure berserker elixir to fight our enemies. To brew it, I need several ingredients. The first things needed are 5 bat wings. Bring them to me and Ill tell you the next ingredients we need.", cid)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 11)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Mission05, 1) -- Questlog The Ice Islands Quest, Nibelor 4: Berserk Brewery
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 11 then
			selfSay("Do you have the 5 bat wings I requested?", cid)
			talkState[talkUser] = 5
		elseif getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 12 then
			selfSay("The second things needed are 4 bear paws. Bring them to me and Ill tell you the next ingredients we need.", cid)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 13)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Mission05, 2) -- Questlog The Ice Islands Quest, Nibelor 4: Berserk Brewery
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 13 then
			selfSay("Do you have the 4 bear paws I requested?", cid)
			talkState[talkUser] = 6
		elseif getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 14 then
			selfSay("The next things needed are 3 bonelord eyes. Bring them to me and Ill tell you the next ingredients we need.", cid)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 15)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Mission05, 3) -- Questlog The Ice Islands Quest, Nibelor 4: Berserk Brewery
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 15 then
			selfSay("Do you have the 3 bonelord eyes I requested?", cid)
			talkState[talkUser] = 7
		elseif getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 16 then
			selfSay("The next things needed are 2 fish fins. Bring them to me and Ill tell you the next ingredients we need.", cid)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 17)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Mission05, 4) -- Questlog The Ice Islands Quest, Nibelor 4: Berserk Brewery
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 17 then
			selfSay("Do you have the 2 fish fins I requested?", cid)
			talkState[talkUser] = 8
		elseif getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 18 then
			selfSay("The last thing needed is a green dragon scale. Bring them to me and Ill tell you the next ingredients we need.", cid)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 19)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Mission05, 5) -- Questlog The Ice Islands Quest, Nibelor 4: Berserk Brewery
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 19 then
			selfSay("Do you have the green dragon scale I requested?", cid)
			talkState[talkUser] = 9
		else
		selfSay("I have now no mission for you.", cid)
		talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "jug") then
		selfSay("Do you want to buy a jug for 1000 gold?", cid)
		talkState[talkUser] = 2
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			selfSay({
				"I am pleased to hear that. On the isle of Tyrsung foreign hunters have set up camp. They are hunting the animals there with no mercy. We will haveto find something that distracts them from hunting ...",
				"Take this jug here and travel to the jungle of Tiquanda. There you will find a race of wood eating ants called termites. Use the jug on one of their hills to catch some of them ...",
				"Then find someone in Svargrond that brings you to Tyrsung. There, release the termites on the bottom of a mast in the hull of the hunters' ship. If you are done, report to me about your mission."
			}, cid)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 6)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Mission03, 1) -- Questlog The Ice Islands Quest, Nibelor 2: Ecological Terrorism
			doPlayerAddItem(cid, 7243, 1)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 2 then
			if getPlayerBalance(cid) + getPlayerBalance(cid) >= 1000 then
				doPlayerRemoveMoney(cid, 1000)
				selfSay("Here you are.", cid)
				talkState[talkUser] = 0
				doPlayerAddItem(cid, 7243, 1)
			end
		elseif talkState[talkUser] == 3 then
			selfSay("Good! Now listen. To protect the animals there, we have to harm the profit of the hunters. Therefor, I ask you to ruin their best source of earnings. Are you willing to do that?", cid)
			talkState[talkUser] = 4
		elseif talkState[talkUser] == 4 then
			selfSay("So let's proceed. Take this vial of paint. Travel to Tyrsung again and ruin as many pelts of baby seals as possible before the paint runs dry or freezes. Then return here to report about your mission. ", cid)
			doPlayerAddItem(cid, 7253, 1)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 8)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Mission04, 1) -- Questlog The Ice Islands Quest, Nibelor 3: Artful Sabotage
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 5 then -- Wings
			if doPlayerRemoveItem(cid, 5894, 5) then
				selfSay("Thank you very much.", cid)
				setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 12)
				talkState[talkUser] = 0
			else
				selfSay("Come back when you do.", cid)
			end
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 6 then -- Paws
			if doPlayerRemoveItem(cid, 5896, 4) then
				selfSay("Thank you very much.", cid)
				setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 14)
				talkState[talkUser] = 0
			else
				selfSay("Come back when you do.", cid)
			end
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 7 then -- Eyes
			if doPlayerRemoveItem(cid, 5898, 3) then
				selfSay("Thank you very much.", cid)
				setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 16)
				talkState[talkUser] = 0
			else
				selfSay("Come back when you do.", cid)
			end
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 8 then -- Fins
			if doPlayerRemoveItem(cid, 5895, 2) then
				selfSay("Thank you very much.", cid)
				setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 18)
				talkState[talkUser] = 0
			else
				selfSay("Come back when you do.", cid)
			end
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 9 then -- Scale
			if doPlayerRemoveItem(cid, 5920, 1) then
				selfSay("Thank you very much. This will help us to defend Svargrond. But I heard young Nilsor is in dire need of help. Please contact him immediately.", cid)
				setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 20)
				setPlayerStorageValue(cid, Storage.TheIceIslands.Mission05, 6) -- Questlog The Ice Islands Quest, Nibelor 4: Berserk Brewery
				talkState[talkUser] = 0
			else
				selfSay("Come back when you do.", cid)
			end
			talkState[talkUser] = 0
		end
	end
	if msgcontains(msg, "buy animal cure") or msgcontains(msg, "animal cure") then -- animal cure for in service of yalahar
		if getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) >= 30 and getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) <= 54 then
			selfSay("You want to buy animal cure for 400 gold coins?", cid)
			talkState[talkUser] = 13
		else
			selfSay("Im out of stock.", cid)
		end
	elseif msgcontains(msg, "yes") and talkState[talkUser] == 13 then
		if talkState[talkUser] == 13 and doPlayerRemoveMoney(cid, 400) then
			doPlayerAddItem(cid, 9734, 1)
			selfSay("Here you go.", cid)
			talkState[talkUser] = 0
		else
			selfSay("You dont have enough of gold coins.", cid)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
