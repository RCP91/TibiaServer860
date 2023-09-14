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

	

	if msgcontains(msg, "nokmir") then
		if getPlayerStorageValue(cid, Storage.hiddenCityOfBeregar.JusticeForAll) == 2 then
			selfSay("Oh well, I liked Nokmir. He used to be a good dwarf until that day on which he stole the ring from {Rerun}.", cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, "rerun") then
		if talkState[talkUser] == 1 then
			setPlayerStorageValue(cid, Storage.hiddenCityOfBeregar.JusticeForAll, 3)
			selfSay("Yeah, he's the lucky guy in this whole story. I heard rumours that emperor Rehal had plans to promote Nokmir, but after this whole thievery story, he might pick Rerun instead.", cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "mission") then
		if getPlayerStorageValue(cid, Storage.hiddenCityOfBeregar.TheGoodGuard) < 1 then
			selfSay("Got any dwarven brown ale?? I DON'T THINK SO....and Bolfana, the tavern keeper, won't sell you anything. I'm sure about that...she doesn't like humans... I tell you what, if you get me a cask of dwarven brown ale, I allow you to enter the mine. Alright?", cid)
			talkState[talkUser] = 2
		elseif getPlayerStorageValue(cid, Storage.hiddenCityOfBeregar.TheGoodGuard) == 1 and doPlayerRemoveItem(cid, 9689, 1) then
			setPlayerStorageValue(cid, Storage.hiddenCityOfBeregar.TheGoodGuard, 2)
			setPlayerStorageValue(cid, Storage.hiddenCityOfBeregar.DoorSouthMine, 1)
			selfSay("HOW?....WHERE?....AHHHH, I don't mind....SLUUUUUURP....tastes a little flat but I had worse. Thank you. Just don't tell anyone that I let you in.", cid)
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 2 then
			setPlayerStorageValue(cid, Storage.hiddenCityOfBeregar.TheGoodGuard, 1)
			setPlayerStorageValue(cid, Storage.hiddenCityOfBeregar.DefaultStart, 1)
			selfSay("Haha, fine! Don't waste time and get me the ale. See you.", cid)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "See you my friend.")
npcHandler:setMessage(MESSAGE_FAREWELL, "See you my friend.")
npcHandler:setMessage(MESSAGE_GREET, "STOP RIGHT THERE!..... Oh, just a human. What's up big guy?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
