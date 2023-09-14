local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end
	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
	
	if msgcontains(msg, "outfit") or msgcontains(msg, "addon") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.WizardAddon) < 1 then
			selfSay("This skull shows that you are a true follower of Zathroth and the glorious gods of darkness. Are you willing to prove your loyalty?", cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, "shield") or msgcontains(msg, "medusa shield") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.WizardAddon) == 1 then
			selfSay("Is it your true wish to sacrifice a medusa shield to Zathroth?", cid)
			talkState[talkUser] = 3
		end
	elseif msgcontains(msg, "mail") or msgcontains(msg, "dragon scale mail") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.WizardAddon) == 2 then
			selfSay("Is it your true wish to sacrifice a dragon scale mail to Zathroth?", cid)
			talkState[talkUser] = 4
		end
	elseif msgcontains(msg, "legs") or msgcontains(msg, "crown legs") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.WizardAddon) == 3 then
			selfSay("Is it your true wish to sacrifice crown legs to Zathroth?", cid)
			talkState[talkUser] = 5
		end
	elseif msgcontains(msg, "ring") or msgcontains(msg, "ring of the sky") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.WizardAddon) == 4 then
			selfSay("Is it your true wish to sacrifice a ring of the sky to Zathroth?", cid)
			talkState[talkUser] = 6
		end

	------------Task Part-------------
	elseif msgcontains(msg, "task") then
		if getPlayerStorageValue(cid, Storage.KillingInTheNameOf.LugriNecromancers) <= 0 then
			selfSay({
				"What? Who are you to imply I need help from a worm like you? ...",
				"I don't need help. But if you desperately wish to do something to earn the favour of Zathroth, feel free. Don't expect any reward though. ...",
				"Do you want to help and serve Zathroth out of your own free will, without demanding payment or recognition?"
			}, cid)
			talkState[talkUser] = 7
		elseif getPlayerStorageValue(cid, Storage.KillingInTheNameOf.LugriNecromancers) == 1 then
			if getPlayerStorageValue(cid, Storage.KillingInTheNameOf.LugriNecromancerCount) >= 4000 then
				selfSay({
					"You've slain a mere {4000 necromancers and priestesses}. Still, you've shown some dedication. Maybe that means you can kill one of those so-called 'leaders' too. ...",
					"Deep under Drefia, a necromancer called Necropharus is hiding in the Halls of Sacrifice. I'll place a spell on you with which you will be able to pass his weak protective gate. ...",
					"Know that this will be your only chance to enter his room. If you leave it or die, you won't be able to return. We'll see if you really dare enter those halls."
				}, cid)
				setPlayerStorageValue(cid,17521, 1)
				setPlayerStorageValue(cid,Storage.KillingInTheNameOf.LugriNecromancers, 2)
			else
				selfSay("Come back when you have slain {4000 necromancers and priestesses!}", cid)
			end
		elseif getPlayerStorageValue(cid, Storage.KillingInTheNameOf.LugriNecromancers) == 2 then
			selfSay({
				"So you had the guts to enter that room. Well, it's all fake magic anyway and no real threat. ...",
				"What are you looking at me for? Waiting for something? I told you that there was no reward. Despite being allowed to stand before me without being squashed like a bug. Get out of my sight!"
			}, cid)
			setPlayerStorageValue(cid,Storage.KillingInTheNameOf.LugriNecromancers, 3)
		elseif getPlayerStorageValue(cid, Storage.KillingInTheNameOf.LugriNecromancers) == 3 then
			selfSay("You can't live without serving, can you? Although you are quite annoying, you're still somewhat useful. Continue killing Necromancers and Priestesses for me. 1000 are enough this time. What do you say?", cid)
			talkState[talkUser] = 8
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			selfSay("It will be a hard task which requires many sacrifices. Do you still want to proceed?", cid)
			talkState[talkUser] = 2
		elseif talkState[talkUser] == 2 then
			selfSay("Good decision, " .. getPlayerName(cid) .. " Your first sacrifice will be a medusa shield. Bring it to me and do give it happily.", cid)
			setPlayerStorageValue(cid,Storage.OutfitQuest.WizardAddon, 1)
			setPlayerStorageValue(cid,Storage.OutfitQuest.DefaultStart, 1) --this for default start of Outfit and Addon Quests
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 3 then
			if doPlayerRemoveItem(cid, 2536, 1) then
				selfSay("Good. I accept your sacrifice. The second sacrifice I require from you is a dragon scale mail. Bring it to me and do give it happily.", cid)
				setPlayerStorageValue(cid,Storage.OutfitQuest.WizardAddon, 2)
				talkState[talkUser] = 0
			else
				selfSay("You don't have it...", cid)
			end
		elseif talkState[talkUser] == 4 then
			if doPlayerRemoveItem(cid, 2492, 1) then
				selfSay("Good. I accept your sacrifice. The third sacrifice I require from you are crown legs. Bring them to me and do give them happily.", cid)
				setPlayerStorageValue(cid,Storage.OutfitQuest.WizardAddon, 3)
				talkState[talkUser] = 0
			else
				selfSay("You don't have it...", cid)
			end
		elseif talkState[talkUser] == 5 then
			if doPlayerRemoveItem(cid, 2488, 1) then
				selfSay("Good. I accept your sacrifice. The last sacrifice I require from you is a ring of the sky. Bring it to me and do give it happily.", cid)
				setPlayerStorageValue(cid,Storage.OutfitQuest.WizardAddon, 4)
				talkState[talkUser] = 0
			else
				selfSay("You don't have it...", cid)
			end
		elseif talkState[talkUser] == 6 then
			if doPlayerRemoveItem(cid, 2123, 1) then
				selfSay("Good. I accept your sacrifice. You have proven that you are a true follower of Zathroth and do not hesitate to sacrifice worldly goods. Thus, I will reward you with this headgear. ", cid)
				setPlayerStorageValue(cid,Storage.OutfitQuest.WizardAddon, 5)
				if (getSex(cid) == 1) then
					doPlayerAddOutfit(cid, 145, 1)
				else
					doPlayerAddOutfit(cid, 149, 2)
				end
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				talkState[talkUser] = 0
			else
				selfSay("You don't have it...", cid)
			end
		elseif talkState[talkUser] == 7 then
			selfSay({
				"You do? I mean - wise decision. Let me explain. By now, Tibia has been overrun by numerous followers of different cults and beliefs. The true Necromancers died or left Tibia long ago, shortly after their battle was lost. ...",
				"What is left are mainly pseudo-dark pretenders, the old wisdom and power being far beyond their grasp. They think they have the right to tap that dark power, but they don't. ...",
				"I want you to eliminate them. As many as you can. All of the upstart necromancer orders, and those priestesses. And as I said, don't expect a reward - this is what has to be done to cleanse Tibia of its false dark prophets."
			}, cid)

			-- aqui
			setPlayerStorageValue(cid,JOIN_STOR, 1)
			-- aqui
			setPlayerStorageValue(cid,Storage.KillingInTheNameOf.LugriNecromancers, 1)
			setPlayerStorageValue(cid,Storage.KillingInTheNameOf.LugriNecromancerCount, 0)
		elseif talkState[talkUser] == 8 then
			selfSay("Good. Then go.", cid)
			setPlayerStorageValue(cid,Storage.KillingInTheNameOf.LugriNecromancers, 4)
		end
	elseif msgcontains(msg, "no") then
		if talkState[talkUser] > 1 then
			selfSay("Then no.", cid)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "What is it that you want, |PLAYERNAME|?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Bye.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
