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

	

	if msgcontains(msg, "looking") then
		if getPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine) >= 19 or getPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine) <= 22 then
			selfSay("I'm the gnomish {musical} supervisor!", cid)
		end

	elseif msgcontains(msg, "musical") then
		if getPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine) == 19 then
			selfSay({
				"Ah well. Everyone has a very personal melody in his soul. Only if you know your soul melody then you know yourself. And only if you know yourself will you be admitted to the Bigfoot company. ...",
				"So what you have to do is to find your soul melody. Do you see the huge crystals in this room? Those are harmonic crystals. Use them to deduce your soul melody. Simply use them to create a sound sequence. ...",
				"Every soul melody consists of seven sound sequences. You will have to figure out your correct soul melody by trial and error. If you hit a wrong note, you will have to start over."
			}, cid)
			setPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine, 21)
			setPlayerStorageValue(cid, Storage.BigfootBurden.MelodyStatus, 1)
			if getPlayerStorageValue(cid, Storage.BigfootBurden.MelodyTone1) < 1 then
				for i = 0, 6 do
					setPlayerStorageValue(cid, Storage.BigfootBurden.MelodyTone1 + i, math.random(3124, 3127))
				end
			end
		elseif getPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine) == 21 then
			selfSay("What you have to do is to find your soul melody. Use the harmonic crystals to deduce your soul melody. Every soul melody consists of seven sound sequences. ...", cid)
			selfSay("You will have to figure out your correct soul melody by trial and error.", cid)
		elseif getPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine) == 22 then
			selfSay({
				"Congratulations on finding your soul melody. And a pretty one as far as I can tell. Now you are a true recruit of the Bigfoot company! Commander Stone might have some tasks for you to do! ...",
				"Look for him in the central chamber. I marked your map where you will find him."
			}, cid)
			setPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine, 25)
			setPlayerStorageValue(cid, Storage.BigfootBurden.QuestLineComplete, 2)
			setPlayerStorageValue(cid, Storage.BigfootBurden.Rank)
			--player:addAchievement('Becoming a Bigfoot')

		elseif getPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine) == 25 then
			selfSay("Congratulations on finding your soul melody.", cid)
		end
	end

	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
