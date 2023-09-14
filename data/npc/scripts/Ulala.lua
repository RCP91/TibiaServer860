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
		if getPlayerStorageValue(cid, Storage.UnnaturalSelection.Questline) == 5 then
			selfSay({
				"The great hunt! About to begin, but gods are not in favour of us yet. We need all help we get. We please Krunus with special nature dance. ...",
				"You seen Krunus altar south in camp, on mountain top? This is where dance is. If you do right steps Krunus will give you sign. If wrong, he not pleased. ...",
				"Do Krunus dance for us! Step and dance and turn around! You will know when you do good. Make {Krunus} happy and support our great hunt!"
			}, cid)
			talkState[talkUser] = 1
		elseif getPlayerStorageValue(cid, Storage.UnnaturalSelection.Questline) == 6 then
			selfSay("Come back if you finished the dance.", cid)
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.UnnaturalSelection.Questline) == 7 then
			selfSay({
				"You born dancer! Krunus is pleased and support the great hunt. But he easy to please! Pandor much harder. We weak, so he sad about us. ...",
				"Maybe we can please with sacrifice of body parts of our enemies. But you need help us get it! We much too weak. ...",
				"If you bring us 5 teeth of green men, 5 skin of horned ones and 5 skin of snakemen that already be good. Please help tribe make Pandor happy!"
			}, cid)
			setPlayerStorageValue(cid, Storage.UnnaturalSelection.Questline, 8)
			setPlayerStorageValue(cid, Storage.UnnaturalSelection.Mission04, 1) --Questlog, Unnatural Selection Quest "Mission 4: Bits and Pieces"
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.UnnaturalSelection.Questline) == 8 then
			selfSay("Please help tribe make Pandor happy! Did you bring us what I asked?", cid)
			talkState[talkUser] = 2
		elseif getPlayerStorageValue(cid, Storage.UnnaturalSelection.Questline) == 9 then
			selfSay({
				"We need make sure Fasuon is on our side. There is laaaaaaaarge crystal on top of mountain. Don't know where come from, was there before us. Problem is - way is infested with creatures! ...",
				"Creatures from the other side of mountain. Bony! Scary! We too weak to go through there, can just run and hope to survive.. but you do better! ...",
				"Please find great crystal of Fasuon and pray there for his support!"
			}, cid)
			setPlayerStorageValue(cid, Storage.UnnaturalSelection.Questline, 10)
			setPlayerStorageValue(cid, Storage.UnnaturalSelection.Mission05, 1) --Questlog, Unnatural Selection Quest "Mission 5: Ray of Light"
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.UnnaturalSelection.Questline) == 10 then
			selfSay("Please find great crystal of Fasuon and pray there for his support!", cid)
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.UnnaturalSelection.Questline) == 11 then
			selfSay("You prayed to Fasuon! Me saw ray of lights on mountain top! Beautiful it was. Me thank you for your help. Great hunt almost can't go wrong now!", cid)
			setPlayerStorageValue(cid, Storage.UnnaturalSelection.Questline, 12)
			setPlayerStorageValue(cid, Storage.UnnaturalSelection.Mission05, 3) --Questlog, Unnatural Selection Quest "Mission 5: Ray of Light"
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.UnnaturalSelection.Questline) == 12 then
			selfSay({
				"Uzroth very easy to anger. You been great help so far but me think that need to pray to Uzroth meself. Only me understand what he wants at time and he is veeeeeery moody. Cannot risk to make angry! ...",
				"So me will do when you gone. But me thank you very much. Go speak Lazaran and tell the gods are pleased now."
			}, cid)
			setPlayerStorageValue(cid, Storage.UnnaturalSelection.Questline, 13)
			setPlayerStorageValue(cid, Storage.UnnaturalSelection.Mission06, 1) --Questlog, Unnatural Selection Quest "Mission 6: Firewater Burn"
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "krunus") then
		if talkState[talkUser] == 1 then
			selfSay("Krunus is God for plants and birth. He hidden in all that grows.", cid)
			setPlayerStorageValue(cid, Storage.UnnaturalSelection.Questline, 6)
			setPlayerStorageValue(cid, Storage.UnnaturalSelection.Mission03, 2) --Questlog, Unnatural Selection Quest "Mission 3: Dance Dance Evolution"
			setPlayerStorageValue(cid, Storage.UnnaturalSelection.DanceStatus, 1)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 2 then
			if getPlayerItemCount(cid, 11113) >= 5 and getPlayerItemCount(cid, 5878) >= 5 and getPlayerItemCount(cid, 5876) >= 5 then
				doPlayerRemoveItem(cid, 11113, 5)
				doPlayerRemoveItem(cid, 5878, 5)
				doPlayerRemoveItem(cid, 5876, 5)
				selfSay("Me thank you! Me will bring sacrifice for Pandor. He surely be pleased with our work. Well your work, but me won't tell him. Teehee.", cid)
				setPlayerStorageValue(cid, Storage.UnnaturalSelection.Questline, 9)
				setPlayerStorageValue(cid, Storage.UnnaturalSelection.Mission04, 2) --Questlog, Unnatural Selection Quest "Mission 4: Bits and Pieces"
				talkState[talkUser] = 0
			else
				selfSay("You do not have these things!", cid)
				talkState[talkUser] = 0
			end
		end
	end
	return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
