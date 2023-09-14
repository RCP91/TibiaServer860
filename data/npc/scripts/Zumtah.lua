local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local condition = Condition(CONDITION_OUTFIT)
condition:setOutfit({lookType = 352})
condition:setTicks(-1)

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	if msgcontains(msg, "exit") then
		if getPlayerStorageValue(cid, Storage.WrathoftheEmperor.ZumtahStatus) ~= 1 then
			if talkState[talkUser] < 1 then
				selfSay("Oh of course, may I show you around a bit before? You want to go straight to the exit? Would you please follow me. Oh right, I am terribly sorry but THERE IS NONE. Will you finally give it up please?", cid)
				talkState[talkUser] = 1
			elseif talkState[talkUser] == 3 then
				talkState[talkUser] = 4
			elseif talkState[talkUser] == 6 then
				talkState[talkUser] = 7
			elseif talkState[talkUser] == 10 then
				selfSay("Oh, you mean - if I have ever been out of here in those 278 years? Well, I - I can't remember. No, I can't remember. Sorry.", cid)
				talkState[talkUser] = 11
			elseif talkState[talkUser] == 11 then
				selfSay("No, I really can't remember. I enjoyed my stay here so much that I forgot how it looks outside of this hole. Outside. The air, the sky, the light. Oh well... well.", cid)
				talkState[talkUser] = 12
			elseif talkState[talkUser] == 12 then
				selfSay("Oh yes, yes. I... I never really thought about how you creatures feel in here I guess. I... just watched all these beings die here. ...", cid)
				talkState[talkUser] = 13
			elseif talkState[talkUser] == 13 then
				selfSay("Oh, excuse me of course, you... wanted to go. Like all... the others. I am sorry, so sorry. You... you can leave. Yes. You can go. You are free. I shall stay here and help every poor soul which ever gets thrown in here from this day onward. ...", cid)
				talkState[talkUser] = 14
			elseif talkState[talkUser] == 14 then
				selfSay({
					"Alright, as I said you are free now. There will not be an outside for the next three centuries, but you - go. ...",
					"Oh and I recovered the strange crate you where hiding in, it will wait for you at the exit since you can't carry it as... a beetle, muhaha. Yes, you shall now crawl through the passage as a beetle. There you go."
				}, cid)
				talkState[talkUser] = 0
				setPlayerStorageValue(cid, Storage.WrathoftheEmperor.ZumtahStatus, 1)
				setPlayerStorageValue(cid, Storage.WrathoftheEmperor.PrisonReleaseStatus, 1)
				player:addCondition(condition)
			end
		else
			selfSay("It's you, why did they throw you in here again? Anyway, I will just transform you once more. I also recovered your crate which will wait for you at the exit. There, feel free to go.", cid)
			setPlayerStorageValue(cid, Storage.WrathoftheEmperor.PrisonReleaseStatus, 1)
			player:addCondition(condition)
		end
	elseif msgcontains(msg, "no") then
		if talkState[talkUser] == 1 then
			selfSay("You are starting to get on my nerves. Is this the only topic you know?", cid)
			talkState[talkUser] = 2
		elseif talkState[talkUser] == 4 then
			talkState[talkUser] = 5
		elseif talkState[talkUser] == 7 then
			talkState[talkUser] = 8
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 2 then
			selfSay("Pesky, persistent human.", cid)
			talkState[talkUser] = 3
		elseif talkState[talkUser] == 5 then
			talkState[talkUser] = 6
		elseif talkState[talkUser] == 8 then
			selfSay("Muhahaha. Then I will give you a test. How many years do you think have I been here? {89}, {164} or {278}?", cid)
			talkState[talkUser] = 9
		end
	elseif msgcontains(msg, "278") and talkState[talkUser] == 9 then
		selfSay("Correct human, and that is not nearly how high you would need to count to tell all the lost souls I've seen dying here. I AM PERPETUAL. Muahahaha.", cid)
		talkState[talkUser] = 10
	elseif (msgcontains(msg, "164") or msgcontains(msg, "89")) and talkState[talkUser] == 9 then
		selfSay("Wrong answer human! Muahahaha.", cid)
		talkState[talkUser] = 0
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
