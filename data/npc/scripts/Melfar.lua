
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local config = {
	{position = Position(32474, 31947, 7), type = 2, description = 'Tree 1'},
	{position = Position(32515, 31927, 7), type = 2, description = 'Tree 2'},
	{position = Position(32458, 31997, 7), type = 2, description = 'Tree 3'}
}

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	if(msgcontains(msg, "mission")) then
		if(getPlayerStorageValue(cid, Storage.TheNewFrontier.Questline) == 4) then
			selfSay({
				"Ha! Men and wood you say? Well, I might be able to relocate some of our miners to the base. Acquiring wood is an entirely different matter though. ... ",
				"I can't spare any men for woodcutting right now but I have an unusual idea that might help. ... ",
				"As you might know, this area is troubled by giant beavers. Once a year, the miners decide to have some fun, so they lure the beavers and jump on them to have some sort of rodeo. ... ",
				"However, I happen to have some beaver bait left from the last year's competition. ... ",
				"If you place it on trees on some strategic locations, we could let the beavers do the work and later on, I'll send men to get the fallen trees. ... ",
				"Does this sound like something you can handle? "
			}, cid)
			talkState[talkUser] = 1
		elseif(getPlayerStorageValue(cid, Storage.TheNewFrontier.Questline) == 6) then
			selfSay("Yes, I can hear them even from here. It has to be a legion of beavers! I'll send the men to get the wood as soon as their gnawing frenzy has settled! You can report to Ongulf that men and wood will be on their way!", cid)
			setPlayerStorageValue(cid, Storage.TheNewFrontier.Questline, 7)
			setPlayerStorageValue(cid, Storage.TheNewFrontier.Mission02, 6) --Questlog, The New Frontier Quest "Mission 02: From Kazordoon With Love"
		end
	elseif(msgcontains(msg, "yes")) then
		if(talkState[talkUser] == 1) then
			selfSay({
				"So take this beaver bait. It will work best on dwarf trees. I'll mark the three trees on your map. Here .. here .. and here! So now mark those trees with the beaver bait. ... ",
				"If you're unlucky enough to meet one of the giant beavers, try to stay calm. Don't do any hectic moves, don't yell, don't draw any weapon, and if you should carry anything wooden on you, throw it away as far as you can. "
			}, cid)
			setPlayerStorageValue(cid, Storage.TheNewFrontier.Questline, 5)
			setPlayerStorageValue(cid, Storage.TheNewFrontier.Mission02, 2) --Questlog, The New Frontier Quest "Mission 02: From Kazordoon With Love"
			doPlayerAddItem(cid, 11100, 1)
			for i = 1, #config do
				player:addMapMark(config[i].position, config[i].type, config[i].description)
			end
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 2 then
			if doPlayerRemoveMoney(cid, 100) then
				doPlayerAddItem(cid, 11100, 1)
				selfSay("Here you go.", cid)
				talkState[talkUser] = 0
			else
				selfSay("You dont have enough of gold coins.", cid)
				talkState[talkUser] = 0
			end
		end
	elseif msgcontains(msg, "buy flask") or msgcontains(msg, "flask") then
		if getPlayerStorageValue(cid, Storage.TheNewFrontier.Questline) == 5 then
			selfSay("You want to buy a Flask with Beaver Bait for 100 gold coins?", cid)
			talkState[talkUser] = 2
		else
			selfSay("Im out of stock.", cid)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
