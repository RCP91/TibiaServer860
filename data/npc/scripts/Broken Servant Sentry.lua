 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end
	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

	if(msgcontains(msg, "slime") or msgcontains(msg, "mould") or msgcontains(msg, "fungus") or msgcontains(msg, "sample")) then
		if(getPlayerStorageValue(cid, 47706) < 1) then
			selfSay("If. You. Bring. Slime. Fungus. Samples. Fro-Fro-Fro-Frrrr*chhhhchrk*From. Other. Tower. You. Must. Be. The. Master. Are. You. There. Master?", cid)
			talkState[talkUser] = 1
		elseif(getPlayerStorageValue(cid, 47706) == 1) then
			selfSay("If. You. Bring. Slime. Fungus. Samples. Fro-Fro-Fro-Frrrr*chhhhchrk*From. Other. Tower. You. Must. Be. The. Master. Are. You. There. Master?", cid)
			talkState[talkUser] = 3
		end

	elseif(msgcontains(msg, "cap") or msgcontains(msg, "mage")) then
		if(getPlayerItemCount(cid, 13756) >= 1 and getPlayerStorageValue(cid, 47706) == 2) and getPlayerStorageValue(cid, 47707) < 1 then
			selfSay("Yo-Yo-Your*chhhrk*. Cap. Is. Slimed. I. Can. Clean. It. *chhhhrrrkchrk* ...", cid)
			selfSay("Here. You. Are. *chhhrrrrkchrk*", cid)
			doPlayerRemoveItem(cid, 13756, 1)
			setPlayerStorageValue(cid, 47707, 1)
			doPlayerAddOutfit(cid, 432, 1)
			doPlayerAddOutfit(cid, 433, 1)
			talkState[talkUser] = 0
		elseif(getPlayerStorageValue(cid, 47707) == 1) then
			selfSay("You already have this outfit!", cid)
			talkState[talkUser] = 0
		end


	elseif(msgcontains(msg, "staff") or msgcontains(msg, "spike")) then
		if(getPlayerItemCount(cid, 13940) >= 1 and getPlayerStorageValue(cid, 47706) == 2) and getPlayerStorageValue(cid, 47708) < 1 then
			selfSay({"Yo-Yo-Your*chhhrk*. Cap. Is. Slimed. I. Can. Clean. It. *chhhhrrrkchrk* ...",
				"Here. You. Are. *chhhrrrrkchrk*"}, cid, 0, 1, 4000)
			doPlayerRemoveItem(cid, 13940, 1)
			setPlayerStorageValue(cid, 47708, 1)
			doPlayerAddOutfit(cid, 432, 2)
			doPlayerAddOutfit(cid, 433, 2)
			talkState[talkUser] = 0
		elseif(getPlayerStorageValue(cid, 47708) == 1) then
			selfSay("You already have this outfit!", cid)
			talkState[talkUser] = 0
		end

	elseif(msgcontains(msg, "yes")) then
		if(talkState[talkUser] == 1) then
				selfSay("I. Greet. You. Ma-Ma-Ma-ster! Did. You. Bring. Mo-Mo-Mo-M*chhhhrrrk*ore. Samples. For. Me. To-To-To. Analyse-lyse-lyse?", cid)
				talkState[talkUser] = 2
		elseif(talkState[talkUser] == 2) then
				selfSay("Thank. I. Will. Start. Analysing. No-No-No-No*chhrrrk*Now.", cid)
				setPlayerStorageValue(cid, 47706, 1)
				setPlayerStorageValue(cid, 12010, 1) --this for default start of Outfit and Addon Quests
				talkState[talkUser] = 0
		elseif(talkState[talkUser] == 3) then
				selfSay("I. Greet. You. Ma-Ma-Ma-ster! Did. You. Bring. Mo-Mo-Mo-M*chhhhrrrk*ore. Samples. For. Me. To-To-To. Analyse-lyse-lyse?", cid)
				talkState[talkUser] = 4
		elseif(talkState[talkUser] == 4) and getPlayerItemCount(cid, 13758) >= 20 then
				selfSay({"Please. Wait. I. Can. Not. Han-Han-Han*chhhhhrrrchrk*Handle. *chhhhrchrk* This. Is. Enough. Material. *chrrrchhrk* ...",
				"I. Have-ve-ve-veee*chrrrck*. Also. Cleaned. Your. Clothes. Master. It. Is. No-No-No*chhrrrrk*Now. Free. Of. Sample. Stains."}, cid, 0, 1, 4000)
				doPlayerRemoveItem(cid, 13758, 20)
				setPlayerStorageValue(cid, 47706, 2)
				doPlayerAddOutfit(cid, 432, 0)
				doPlayerAddOutfit(cid, 433, 0)
				talkState[talkUser] = 0
			else
				selfSay("You do not have all the required items.", cid)
				talkState[talkUser] = 0
			end
		end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
