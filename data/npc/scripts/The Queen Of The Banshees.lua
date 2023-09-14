 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = { {text = 'Uhhhhhh....'} }
--npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	
	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "seventh seal") then
		selfSay("If you have passed the first six seals and entered the blue fires that lead to the chamber of the seal you might receive my {kiss} ... It will open the last seal. Do you think you are ready?", cid)
		talkState[talkUser] = 1
	elseif msgcontains(msg, "kiss") and talkState[talkUser] == 7 then
		if getPlayerStorageValue(cid, Storage.QueenOfBansheesQuest.Kiss) < 1 then
			selfSay("Are you prepared to receive my kiss, even though this will mean that your death as well as a part of your soul will forever belong to me, my dear?", cid)
			talkState[talkUser] = 8
		else
			selfSay("You have already received my kiss. You should know better then to ask for it.", cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "spectral dress") then
		if getPlayerStorageValue(cid, Storage.ExplorerSociety.TheSpectralDress) == 48 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 48 and getPlayerStorageValue(cid, Storage.ExplorerSociety.bansheeDoor) < 1 then
			selfSay("Your wish for a spectral dress is silly. Although I will grant you the permission to take one. My maidens left one in a box in a room, directly south of here.", cid)
			setPlayerStorageValue(cid, Storage.ExplorerSociety.bansheeDoor, 1)
		end
	elseif msgcontains(msg, "addon") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.WizardAddon) == 5 then
			selfSay("Say... I have been longing for something for an eternity now... if you help me retrieve it, I will reward you. Do you consent to this arrangement?", cid)
			talkState[talkUser] = 9
		end
	elseif msgcontains(msg, "orchid") or msgcontains(msg, "holy orchid") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.WizardAddon) == 6 then
			selfSay("Have you really brought me 50 holy orchids?", cid)
			talkState[talkUser] = 11
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			if getPlayerStorageValue(cid, Storage.QueenOfBansheesQuest.FourthSeal) == 1 then
				selfSay("The Queen of the Banshee: Yessss, I can sense you have passed the seal of sacrifice. Have you passed any other seal yet?", cid)
				talkState[talkUser] = 2
			else
				selfSay("You have not passed the seal of sacrifice yet. Return to me when you are better prepared.", cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 2 then
			if getPlayerStorageValue(cid, Storage.QueenOfBansheesQuest.FirstSeal) == 1 then
				selfSay("The Queen of the Banshee: I sense you have passed the hidden seal as well. Have you passed any other seal yet?", cid)
				talkState[talkUser] = 3
			else
				selfSay("You have not found the hidden seal yet. Return when you are better prepared.", cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 3 then
			if getPlayerStorageValue(cid, Storage.QueenOfBansheesQuest.SecondSeal) == 1 then
				selfSay("The Queen of the Banshee: Oh yes, you have braved the plague seal. Have you passed any other seal yet?", cid)
				talkState[talkUser] = 4
			else
				selfSay("You have not faced the plagueseal yet. Return to me when you are better prepared.", cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 4 then
			if getPlayerStorageValue(cid, Storage.QueenOfBansheesQuest.ThirdSeal) == 1 then
				selfSay("The Queen of the Banshee: Ah, I can sense the power of the seal of demonrage burning in your heart. Have you passed any other seal yet?", cid)
				talkState[talkUser] = 5
			else
				selfSay("You are not filled with the fury of the imprisoned demon. Return when you are better prepared.", cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 5 then
			if getPlayerStorageValue(cid, Storage.QueenOfBansheesQuest.FifthSeal) == 1 then
				selfSay("The Queen of the Banshee: So, you have managed to pass the seal of the true path. Have you passed any other seal yet?", cid)
				talkState[talkUser] = 6
			else
				selfSay("You have not found your true path yet. Return when you are better prepared.", cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 6 then
			if getPlayerStorageValue(cid, Storage.QueenOfBansheesQuest.SixthSeal) == 1 then
				selfSay("The Queen of the Banshee: I see! You have mastered the seal of logic. You have made the sacrifice, you have seen the unseen, you possess fortitude, you have filled yourself with power and found your path. You may ask me for my {kiss} now.", cid)
				talkState[talkUser] = 7
			else
				selfSay("You have not found your true path yet. Return to meh when you are better prepared.", cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 8 then
			if not player:isPzLocked() then
				selfSay("So be it! Hmmmmmm...", cid)
				talkState[talkUser] = 0
				player:teleportTo(Position(32202, 31812, 8), false)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				setPlayerStorageValue(cid, Storage.QueenOfBansheesQuest.Kiss, 1)
			else
				selfSay("You have spilled too much blood recently and the dead are hungry for your soul. Perhaps return when you regained you inner balance.", cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 9 then
			selfSay({
				"Listen... there are no blooming flowers down here and the only smell present is that of death and decay. ...",
				"I wish that I could breathe the lovely smell of beautiful flowers just one more time, especially those which elves cultivate. ...",
				"Could you please bring me 50 holy orchids?"
			}, cid)
			talkState[talkUser] = 10
		elseif talkState[talkUser] == 10 then
			selfSay("Thank you. I will wait for your return.", cid)
			setPlayerStorageValue(cid, Storage.OutfitQuest.WizardAddon, 6)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 11 then
			if doPlayerRemoveItem(cid, 5922, 50) then
				selfSay("Thank you! You have no idea what that means to me. As promised,here is your reward... as a follower of Zathroth, I hope that you will like this accessory.", cid)
				setPlayerStorageValue(cid, Storage.OutfitQuest.WizardAddon, 7)
				doPlayerAddOutfit(cid, 145, 1)
				doPlayerAddOutfit(cid, 149, 1)
				--player:addAchievement('Warlock')
				talkState[talkUser] = 0
			else
				selfSay("You need 50 holy orchid.", cid)
				talkState[talkUser] = 0
			end
		end
	elseif msgcontains(msg, "no") then
		if talkState[talkUser] >= 1 and talkState[talkUser] <= 7 then
			selfSay("Then try to be better prepared next time we meet.", cid)
		elseif talkState[talkUser] == 8 then
			selfSay("Perhaps it is the better choice for you, my dear.", cid)
		end
	end
	return true
end

keywordHandler:addKeyword({'stay'}, StdModule.say, {npcHandler = npcHandler, text = "It's my curse to be the eternal {guardian} of this ancient {place}."})
keywordHandler:addKeyword({'guardian'}, StdModule.say, {npcHandler = npcHandler, text = "I'm the {guardian} of the {SEVENTH} and final seal. The seal to open the last door before ... but perhaps it's better to see it with your own eyes."})
keywordHandler:addKeyword({'place'}, StdModule.say, {npcHandler = npcHandler, text = "It served as a temple, a source of power and ... as a sender for an ancient {race} which lived a long time ago and has long been forgotten."})
keywordHandler:addKeyword({'race'}, StdModule.say, {npcHandler = npcHandler, text = "The race that built this edifice came to this place from the stars. They ran from an enemy even more horrible than themselves. But they carried the {seed} of their own destruction in them."})
keywordHandler:addKeyword({'seed'}, StdModule.say, {npcHandler = npcHandler, text = "This ancient race was annihilated by its own doings, that's all I know. Aeons have passed since then, but the sheer presence of this {complex} is still defiling and desecrating this area."})
keywordHandler:addKeyword({'complex'}, StdModule.say, {npcHandler = npcHandler, text = "Its constructors were too strange for you or even me to understand. We don't know what this ... thing they built was supposed to be good for. I feel a constant twisting and binding of souls, though, that is probably only a side-effect."})
keywordHandler:addKeyword({'ghostlands'}, StdModule.say, {npcHandler = npcHandler, text = "The place you know as the Ghostlands had a different name once ... and many names after. Too many to remember them all."})
keywordHandler:addKeyword({'banshee'}, StdModule.say, {npcHandler = npcHandler, text = "They are my maidens. They give me comfort in my eternal watch over the last seal."})

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Be greeted, dear visitor. Come and {stay} ... a while.")
npcHandler:setMessage(MESSAGE_FAREWELL, "We will meet again, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Yes, flee from death. But know it shall be always one step behind you.")
npcHandler:addModule(FocusModule:new())
