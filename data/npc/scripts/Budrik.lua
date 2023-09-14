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

	

	if msgcontains(msg, "mission") then
		if getPlayerStorageValue(cid, Storage.toOutfoxAFoxQuest) < 1 then
			selfSay({
				"Funny that you are asking me for a mission! There is indeed something you can do for me. Ever heard about The Horned Fox? Anyway, yesterday his gang has stolen my mining helmet during a raid. ...",
				"It belonged to my father and before that to my grandfather. That helmet is at least 600 years old! I need it back. Are you willing to help me?"
			}, cid)
			talkState[talkUser] = 1

		elseif getPlayerStorageValue(cid, Storage.toOutfoxAFoxQuest) == 1 then
			if doPlayerRemoveItem(cid, 7497, 1) then
				setPlayerStorageValue(cid, Storage.toOutfoxAFoxQuest, 2)
				doPlayerAddItem(cid, 7939, 1)
				selfSay("I always said it to the others 'This brave fellow will bring me my mining helmet back' and here you are with it!! Here take my spare helmet, I don't need it anymore!", cid)
			else
				selfSay("We presume the hideout of The Horned Fox is somewhere in the south-west near the coast, good luck finding my mining helmet!", cid)
			end
			talkState[talkUser] = 0
			else selfSay("Hum... what, {task}?", cid)
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			setPlayerStorageValue(cid, Storage.toOutfoxAFoxQuest, 1)
			selfSay("I knew you have the guts for that task! We presume the hideout of The Horned Fox somewhere in the south-west near the coast. Good luck!", cid)
			talkState[talkUser] = 0

			elseif talkState[talkUser] == 2 then
			selfSay("Hussah! Let's bring war to those hoof-legged, dirt-necked, bull-headed minotaurs!! Come back to me when you are done with your mission.", cid)
			setPlayerStorageValue(cid, JOIN_STOR, 1)
			setPlayerStorageValue(cid, Storage.KillingInTheNameOf.BudrikMinos, 1)
			setPlayerStorageValue(cid, Storage.KillingInTheNameOf.BudrikMinosCount, 0)
			talkState[talkUser] = 0


			else selfSay("Zzz...", cid)

		end
		elseif msgcontains(msg, "task") then
		-- AQUI
		if getPlayerStorageValue(cid, Storage.KillingInTheNameOf.BudrikMinos) <= 0 then
			selfSay({
				"I am so angry I could spit grit! That damn Horned Fox and his attacks! Let's show those bull-heads that they have messed with the wrong people....",
				"I want you to kill {5000 minotaurs} - no matter where - for me and all the dwarfs of Kazordoon! Are you willing to do that?"
			}, cid)
			talkState[talkUser] = 2
		elseif getPlayerStorageValue(cid, Storage.KillingInTheNameOf.BudrikMinos) == 1 then
			if getPlayerStorageValue(cid, Storage.KillingInTheNameOf.BudrikMinosCount) >= 5000 then
				selfSay({
					"By all that is holy! You are a truly great warrior! With much patience! I have just found out the location the hideout of {The Horned Fox}! I have marked the spot on your map so you can find it. Go there and slay him!! Good luck!"
				}, cid)
				setPlayerStorageValue(cid, 17522, 1)
				setPlayerStorageValue(cid, Storage.KillingInTheNameOf.BudrikMinos, 2)
			else
				selfSay("Come back when you have slain {5000 minotaurs!}", cid)
			end
		elseif getPlayerStorageValue(cid, Storage.KillingInTheNameOf.BudrikMinos) == 2 then
			selfSay({
				"It was very decent of you to help me, and I am thankful, really I am, but now I have to get back to my duties as a foreman."
			}, cid)
			setPlayerStorageValue(cid, Storage.KillingInTheNameOf.BudrikMinos, 3)
		elseif getPlayerStorageValue(cid, Storage.KillingInTheNameOf.BudrikMinos) == 3 then
			selfSay("You already done this task.", cid)
			talkState[talkUser] = 0
			else selfSay("You need to do the {To Outfox a Fox Quest} before.", cid)
		end
		-- AQUI

		-- YES AQUI

	elseif msgcontains(msg, "no") then
		if talkState[talkUser] > 1 then
			selfSay("Then no.", cid)
			talkState[talkUser] = 0
		end
	end
		-- YES AQUI

	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Bye, bye.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Bye, bye.")
npcHandler:setMessage(MESSAGE_GREET, "Hiho, hiho |PLAYERNAME|.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
