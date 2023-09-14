local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

keywordHandler:addGreetKeyword({'hi'}, {npcHandler = npcHandler, text = 'Hello and welcome in the gnomish {recruitment} office.'},
  function (player)
  	if getPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine) == 1 then

  		setPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine, 3)
  	end
	end
)
keywordHandler:addAliasKeyword({'hello'})

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	

	if getPlayerStorageValue(cid, Storage.BigfootBurden.NeedsBeer) == 1 then
		if msgcontains(msg, "recruit") or msgcontains(msg, "test") or msgcontains(msg, "result") then
			selfSay({"I suggest you relax a bit with a fresh mushroom beer and we can talk after that. ...", "Gnominus... He is the one you need right now, find him."}, cid)
		end
		return
	end

	if msgcontains(msg, "recruit") then
		if getPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine) == 5 then
			selfSay("Yes... Yes... <sigh>. We already talked about that. I can't remember if you have already tried the {test}, so lets get going.", cid)
		elseif getPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine) == 3 then
			selfSay("We are hiring people to fight in our so called Bigfoot company against the foes of gnomekind. Are you interested in joining?", cid)
			talkState[talkUser] = 1
		end

	-- TEST
	elseif msgcontains(msg, "test") then
		if getPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine) == 5 then
			if talkState[talkUser] < 1 then
				setPlayerStorageValue(cid, Storage.BigfootBurden.Test, 0)
				selfSay({
					"Imagine, during your travels you come upon a rare and unknown mushroom. Would you {A}) note down its specifics and location and look for a gnome to take care of it. ...",
					"Or would you {B}) smash it to an unrecognisable pulp. Or would you {C}) pluck it to take it with you for further examination. Or would you {D}) try to become friends with the mushroom by singing questionable bar-room songs?"
				}, cid)
				talkState[talkUser] = 2
			elseif talkState[talkUser] == 3 then
				selfSay({
					"Imagine you wake up one morning and discover you have forgotten how to knot your shoelaces. Would you {A}) admit defeat and go to bed once more. ...",
					"{B}) look for a gnome that can remind you how to do it. {C}) Despite the risk of injuring yourself, try to figure it out on your own. {D}) Use some pottery instead of shoes."
				}, cid)
				talkState[talkUser] = 4
			elseif talkState[talkUser] == 5 then
				selfSay({
					"Now let us assume you see a gnome in danger. Would you {A}) not care because you must be imagining things. {B}) Save the gnome despite all odds and risk to your own life. ...",
					"{C}) Inspire the gnome by singing the gnomish national anthem. {D}) Hide and loot his corpse if he dies."
				}, cid)
				talkState[talkUser] = 6
			elseif talkState[talkUser] == 7 then
				selfSay({
					"Imagine you were participating in a gnome-throwing competition. Would you {A}) do some physical calculations in advance to increase your chances of winning. ...",
					"{B}) throw the gnome as safely as you can to ensure his safety. {C}) Sabotage the throwing gnomes of your competitors. {D}) Never participate in such an abominable competition."
				}, cid)
				talkState[talkUser] = 8
			elseif talkState[talkUser] == 9 then
				selfSay({
					"Now imagine you were given the order to guard a valuable and unique mushroom. You guard it for days and no one shows up to release you and you grow hungry. ...",
					"Would you {A}) eat your boots. {B}) eat the mushroom. {C}) eat a bit of the mushroom. {D}) stick to your duty and continue starving."
				}, cid)
				talkState[talkUser] = 10
			elseif talkState[talkUser] == 11 then
				selfSay("What do you think describes gnomish society best? {A}) Ingenuity {B}) Bravery {C}) Humility {D}) All of the above.", cid)
				talkState[talkUser] = 12
			elseif talkState[talkUser] == 13 then
				selfSay({
					"How many bigfoot does it take to change a light crystal? {A}) Only one since it's a piece of mushroom cake. {B}) Light crystals are delicate products of gnomish science and should only be handled by certified gnomish experts. ...",
					"{C}) Three. One to hold the crystal and two to turn him around. {D}) Five. A light crystal turner, a light crystal picker, a light crystal exchanger, a light crystal changing manager and finally a light crystal changing manager assistant."
				}, cid)
				talkState[talkUser] = 14
			elseif talkState[talkUser] == 15 then
				selfSay({
					"What is a pollyfluxed quantumresonator? {A}) Something funny. {B}) Something important. {C}) Something to be destroyed. ...",
					"{D}) Sadly I am not a gnome and lack the intelligence and education to know about even the simplest of gnomish inventions."
				}, cid)
				talkState[talkUser] = 16
			elseif talkState[talkUser] == 17 then
				selfSay({
					"If your mushroom patch is infested with cave worms, would you {A}) place some green light crystals to drive them away. {B}) place some disharmonic crystals to drive them away. ...",
					"{C}) burn everything down. {D}) switch your diet to cave worms."
				}, cid)
				talkState[talkUser] = 18
			elseif talkState[talkUser] == 19 then
				selfSay("What is the front part of a spear? Is it {A}) the pointed one. {B}) The blunt one. {C}) Whatever causes the most damage {D}) A spear is no weapon but a fruit that grows on surface trees.", cid)
				talkState[talkUser] = 20
			elseif talkState[talkUser] == 21 then
				selfSay({
					"On a military campaign what piece of equipment would you need most? ...",
					"Is it {A}) some tasty mushroom beer to keep the morale high. {B}) A large backpack to carry all the loot. {C}) A mighty weapon to vanquish the foes. {D}) Mushroom earplugs to be spared of the cries of agony of your opponents?"
				}, cid)
				talkState[talkUser] = 22
			elseif talkState[talkUser] == 23 then
				selfSay("What comes first? {A}) safety {B}) I {C}) duty {D}) George", cid)
				talkState[talkUser] = 24
			elseif talkState[talkUser] == 25 then
				selfSay("In case of emergency {A}) break glass {B}) break a leg {C}) have a break {D}) call a gnome?", cid)
				talkState[talkUser] = 26
			elseif talkState[talkUser] == 27 then
				selfSay("The greatest disaster I can imagine is ... {A}) to fail the gnomes {B}) a ruined mushroom pie {C}) accidentally hammering my finger {D}) having some work to do", cid)
				talkState[talkUser] = 28
			elseif talkState[talkUser] == 29 then
				selfSay("What would your favourite pet be? {A}) A Krazzelzak of course. {B}) An Uxmoff to be honest. {C}) Montpiffs were always my favourite. {D}) A Humdrella and nothing else!", cid)
				talkState[talkUser] = 30
			elseif talkState[talkUser] == 31 then
				selfSay("Why do you want to become a bigfoot? {A}) To become rich and famous. {B}) To become famous and rich. {C}) To become rich or famous. {D}) To serve the gnomish community in their struggle?", cid)
				talkState[talkUser] = 32
			end
		end
	-- ANSWERS
	elseif msg:lower() == "a" then
		if getPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine) == 5 then
			if (talkState[talkUser] % 2) == 0 then
				if talkState[talkUser] == 2 then
					selfSay("Indeed an excellent and smart decision for an ungnomish lifeform. But let us continue with the {test}.", cid)
					setPlayerStorageValue(cid, Storage.BigfootBurden.Test, getPlayerStorageValue(cid, Storage.BigfootBurden.Test) + 7)
					talkState[talkUser] = talkState[talkUser] + 1
				elseif talkState[talkUser] == 18 then
					selfSay("A well thought out answer I have to admit. But let us continue with the {test}.", cid)
					setPlayerStorageValue(cid, Storage.BigfootBurden.Test, getPlayerStorageValue(cid, Storage.BigfootBurden.Test) + 7)
					talkState[talkUser] = talkState[talkUser] + 1
				elseif talkState[talkUser] == 20 then
					selfSay("Ah, we have a true warrior here I guess. But let us continue with the {test}.", cid)
					setPlayerStorageValue(cid, Storage.BigfootBurden.Test, getPlayerStorageValue(cid, Storage.BigfootBurden.Test) + 7)
					talkState[talkUser] = talkState[talkUser] + 1
				elseif talkState[talkUser] == 28 then
					selfSay("Fear not. We don't expect too much of you anyway. But let us continue with the {test}.", cid)
					setPlayerStorageValue(cid, Storage.BigfootBurden.Test, getPlayerStorageValue(cid, Storage.BigfootBurden.Test) + 7)
					talkState[talkUser] = talkState[talkUser] + 1
				elseif talkState[talkUser] == 30 then
					selfSay("Ha! A Krazzelzak would for sure fit someone like you! But let us continue with the {test}.", cid)
					setPlayerStorageValue(cid, Storage.BigfootBurden.Test, getPlayerStorageValue(cid, Storage.BigfootBurden.Test) + 7)
					talkState[talkUser] = talkState[talkUser] + 1
				else
					if talkState[talkUser] < 33 then
						selfSay("Wrong answer!", cid)
						talkState[talkUser] = talkState[talkUser] + 1
						if talkState[talkUser] >= 33 then
							selfSay("Stop it! The test is over, you can ask me for your {results}.", cid)
						end
					end
				end
			end
		end
	elseif msg:lower() == "b" then
		if getPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine) == 5 then
			if (talkState[talkUser] % 2) == 0 then
				if talkState[talkUser] == 6 then
					selfSay("Although chances are the gnome will end up rescuing you instead, it is the attempt that counts. But let us continue with the {test}.", cid)
					setPlayerStorageValue(cid, Storage.BigfootBurden.Test, getPlayerStorageValue(cid, Storage.BigfootBurden.Test) + 7)
					talkState[talkUser] = talkState[talkUser] + 1
				elseif talkState[talkUser] == 14 then
					selfSay("I knew this question was too easy. But let us continue with the {test}.", cid)
					setPlayerStorageValue(cid, Storage.BigfootBurden.Test, getPlayerStorageValue(cid, Storage.BigfootBurden.Test) + 7)
					talkState[talkUser] = talkState[talkUser] + 1
				else
					if talkState[talkUser] < 33 then
						selfSay("Wrong answer!", cid)
						talkState[talkUser] = talkState[talkUser] + 1
						if talkState[talkUser] >= 33 then
							selfSay("Stop it! The test is over, you can ask me for your {results}.")
						end
					end
				end
			end
		end
	elseif msg:lower() == "c" then
		if getPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine) == 5 then
			if (talkState[talkUser] % 2) == 0 then
				if talkState[talkUser] == 4 then
					selfSay("That's the spirit! Initiative is always a good thing. Well most of the time. But let us continue with the {test}.", cid)
					setPlayerStorageValue(cid, Storage.BigfootBurden.Test, getPlayerStorageValue(cid, Storage.BigfootBurden.Test) + 7)
					talkState[talkUser] = talkState[talkUser] + 1
				elseif talkState[talkUser] == 22 then
					selfSay("You have no idea how many answer this question wrong. But let us continue with the {test}.", cid)
					setPlayerStorageValue(cid, Storage.BigfootBurden.Test, getPlayerStorageValue(cid, Storage.BigfootBurden.Test) + 7)
					talkState[talkUser] = talkState[talkUser] + 1
				elseif talkState[talkUser] == 24 then
					selfSay("That's the spirit! But let us continue with the {test}.", cid)
					setPlayerStorageValue(cid, Storage.BigfootBurden.Test, getPlayerStorageValue(cid, Storage.BigfootBurden.Test) + 7)
					talkState[talkUser] = talkState[talkUser] + 1
				else
					if talkState[talkUser] < 33 then
						selfSay("Wrong answer!", cid)
						talkState[talkUser] = talkState[talkUser] + 1
						if talkState[talkUser] >= 33 then
							selfSay("Stop it! The test is over, you can ask me for your {results}.", cid)
						end
					end
				end
			end
		end
	elseif msg:lower() == "d" then
		if getPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine) == 5 then
			if (talkState[talkUser] % 2) == 0 then
				if talkState[talkUser] == 8 then
					selfSay("Of COURSE you wouldn't! NO ONE would! But let us continue with the {test}.", cid)
					setPlayerStorageValue(cid, Storage.BigfootBurden.Test, getPlayerStorageValue(cid, Storage.BigfootBurden.Test) + 7)
					talkState[talkUser] = talkState[talkUser] + 1
				elseif talkState[talkUser] == 10 then
					selfSay("I can only hope that is your honest opinion. But let us continue with the test.", cid)
					setPlayerStorageValue(cid, Storage.BigfootBurden.Test, getPlayerStorageValue(cid, Storage.BigfootBurden.Test) + 7)
					talkState[talkUser] = talkState[talkUser] + 1
				elseif talkState[talkUser] == 12 then
					selfSay("Oh, you silver tongued devil almost made me blush. But of course you're right. But let us continue with the {test}.", cid)
					setPlayerStorageValue(cid, Storage.BigfootBurden.Test, getPlayerStorageValue(cid, Storage.BigfootBurden.Test) + 7)
					talkState[talkUser] = talkState[talkUser] + 1
				elseif talkState[talkUser] == 16 then
					selfSay("How true. How true. *sigh* But fear not! We gnomes are here to help! But let us continue with the {test}.", cid)
					setPlayerStorageValue(cid, Storage.BigfootBurden.Test, getPlayerStorageValue(cid, Storage.BigfootBurden.Test) + 7)
					talkState[talkUser] = talkState[talkUser] + 1
				elseif talkState[talkUser] == 26 then
					selfSay("That's just what I'd do - if I weren't a gnome already, that is. But let us continue with the {test}.", cid)
					setPlayerStorageValue(cid, Storage.BigfootBurden.Test, getPlayerStorageValue(cid, Storage.BigfootBurden.Test) + 7)
					talkState[talkUser] = talkState[talkUser] + 1
				elseif talkState[talkUser] == 32 then
					selfSay("Excellent! Well this concludes the test. Now let us see your {results}.", cid)
					setPlayerStorageValue(cid, Storage.BigfootBurden.Test, getPlayerStorageValue(cid, Storage.BigfootBurden.Test) + 7)
					talkState[talkUser] = talkState[talkUser] + 1
				else
					if talkState[talkUser] < 33 then
						selfSay("Wrong answer!", cid)
						talkState[talkUser] = talkState[talkUser] + 1
						if talkState[talkUser] >= 33 then
							selfSay("Stop it! The test is over, you can ask me for your {results}.", cid)
						end
					end
				end
			end
		end
	-- TEST

	elseif msgcontains(msg, "result") then
		if talkState[talkUser] == 33 then
			if getPlayerStorageValue(cid, Storage.BigfootBurden.Test) < 100 then
				setPlayerStorageValue(cid, Storage.BigfootBurden.NeedsBeer, 1)
				selfSay({
					"You have failed the test with " .. getPlayerStorageValue(cid, Storage.BigfootBurden.Test) .. " of 112 possible points. You probably were just too nervous. ...",
					"I suggest you relax a bit with a fresh mushroom beer and we'll start over after that. Gnominus sells some beer. You should find him somewhere in the central chamber."
				}, cid)
			else
				selfSay("You have passed the test with " .. getPlayerStorageValue(cid, Storage.BigfootBurden.Test) .. " of 112 possible points. Congratulations. You are ready to proceed with the more physical parts of your examination! Go and talk to Gnomespector about it.", cid)
				setPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine, 6)
			end
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
				selfSay("Excellent! Now let us begin with the gnomish aptitude test. Just tell me when you feel ready for the {test}!", cid)
				setPlayerStorageValue(cid, Storage.BigfootBurden.QuestLine, 5)
				talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())