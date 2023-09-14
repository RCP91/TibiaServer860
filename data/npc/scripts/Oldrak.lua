local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) 		npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) 	npcHandler:onCreatureSay(cid, type, msg) end
function onThink() 						npcHandler:onThink() end

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I guard this humble temple as a monument for the order of the nightmare knights."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "My name is Oldrak."})
keywordHandler:addKeyword({'monster'}, StdModule.say, {npcHandler = npcHandler, text = "These plains are not safe for ordinary travellers. It will take heroes to survive here."})
keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = "I can't help you, sorry!"})
keywordHandler:addKeyword({'goshnar'}, StdModule.say, {npcHandler = npcHandler, text = "The greatest necromant who ever cursed our land with the steps of his feet. He was defeated by the nightmare knights."})
keywordHandler:addKeyword({'nightmare'}, StdModule.say, {npcHandler = npcHandler, text = "This ancient order was created by a circle of wise humans who were called 'the dreamers'. The order became extinct a long time ago."})
keywordHandler:addKeyword({'extinct'}, StdModule.say, {npcHandler = npcHandler, text = "Many perished in their battles against evil, some went mad, not able to stand their nightmares any longer. Others were seduced by the darkness."})
keywordHandler:addKeyword({'dreamers'}, StdModule.say, {npcHandler = npcHandler, text = "They learned the ancient art of dreamwalking from some elves they befriended."})
keywordHandler:addKeyword({'dreamwalking'}, StdModule.say, {npcHandler = npcHandler, text = "While the dreamwalkers of the elves experienenced the brightest dreams of pleasure, the humans strangely had dreams of dark omen."})
keywordHandler:addKeyword({'omen'}, StdModule.say, {npcHandler = npcHandler, text = "They dreamed of doom, destruction, talked to dead, tormented souls, and gained unwanted insight into the schemes of darkness."})
keywordHandler:addKeyword({'schemes'}, StdModule.say, {npcHandler = npcHandler, text = "They figured out how to interpret their dark dreams and so could foresee the plans of the dark gods and their minions."})
keywordHandler:addKeyword({'plan'}, StdModule.say, {npcHandler = npcHandler, text = "Using this knowledge they formed an order to thwart these plans, and because they battled their nightmares as brave as knights, they named their order accordingly."})
keywordHandler:addKeyword({'necromant'}, StdModule.say, {npcHandler = npcHandler, text = "It is rumoured to open the entrance to the pits of inferno, also called the nightmare pits. Even if I knew about this secret I wouldn't tell you."})
keywordHandler:addKeyword({'havok'}, StdModule.say, {npcHandler = npcHandler, text = "Before the battles raged across them, they were called the fair plains."})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = "That's where we are. The world of Tibia."})
keywordHandler:addKeyword({'god'}, StdModule.say, {npcHandler = npcHandler, text = "They created Tibia and all life on it ... and unlife, too."})
keywordHandler:addKeyword({'unlife'}, StdModule.say, {npcHandler = npcHandler, text = "Beware the foul undead!"})
keywordHandler:addKeyword({'undead'}, StdModule.say, {npcHandler = npcHandler, text = "Beware the foul undead!"})
keywordHandler:addKeyword({'excalibug'}, StdModule.say, {npcHandler = npcHandler, text = "A weapon of myth and legend. It was lost in ancient times ... perhaps lost forever."})
keywordHandler:addKeyword({'hugo'}, StdModule.say, {npcHandler = npcHandler, text = "Ah, the bane of the Plains of Havoc, the hidden beast, the unbeatable foe. I live here for years and I am sure it's only a myth."})
keywordHandler:addKeyword({'myth'}, StdModule.say, {npcHandler = npcHandler, text = "There are many tales about the fearsome Hugo. It's said it's an abnormality, accidentally created by Yenny the Gentle. It's half demon, halfsomething else and people say it's still alive after all these years."})
keywordHandler:addKeyword({'yenny the gentle'}, StdModule.say, {npcHandler = npcHandler, text = "Yenny, known as the Gentle, was one of most powerfull magicwielders in ancient times and known throughout the world for her mercy and kindness."})
keywordHandler:addKeyword({'offer'}, StdModule.say, {npcHandler = npcHandler, text = "I can offer you the holy tible for a small fee."})
keywordHandler:addKeyword({'trade'}, StdModule.say, {npcHandler = npcHandler, text = "I can offer you the holy tible for a small fee."})
keywordHandler:addKeyword({'sell'}, StdModule.say, {npcHandler = npcHandler, text = "I can offer you the holy tible for a small fee."})
keywordHandler:addKeyword({'buy'}, StdModule.say, {npcHandler = npcHandler, text = "I can offer you the holy tible for a small fee."})
keywordHandler:addKeyword({'have'}, StdModule.say, {npcHandler = npcHandler, text = "I can offer you the holy tible for a small fee."})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = "Now, it is |TIME|."})

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	if msgcontains(msg, 'mission') or msgcontains(msg, 'demon oak') then
		if getPlayerStorageValue(cid, Storage.DemonOak.Done) < 1 then
			selfSay("How do you know? Did you go into the infested area?", cid)
			talkState[talkUser] = 1
		elseif getPlayerStorageValue(cid, Storage.DemonOak.Progress) == 2 and getPlayerStorageValue(cid, Storage.DemonOak.Done) < 1 then
			selfSay("You better don't return here until you've defeated the Demon Oak.", cid)
		elseif getPlayerStorageValue(cid, Storage.DemonOak.Done) == 1 then
			selfSay({
				"You chopped down the demon oak?!? Unbelievable!! Let's hope it doesn't come back. As long as evil is still existent in the soil of the plains, it won't be over. Still, the demons suffered a setback, that's for sure. ...",
				"For your brave action, I tell you a secret which has been kept for many many years. There is an old house south of the location where you found the demon oak. There should be a grave with the name 'Yesim Adeit' somewhere close by. ...",
				"It belongs to a Daramian nobleman named 'Teme Saiyid'. I knew him well and he told me -almost augured- that someone will come who is worthy to obtain his treasure. I'm sure this 'someone' is you. Good luck in finding it!"
			}, cid)
			setPlayerStorageValue(cid, Storage.DemonOak.Done, 2)
		end
		elseif msgcontains(msg, 'yes') and talkState[talkUser] == 1 then
			setPlayerStorageValue(cid, Storage.DemonOak.Progress, 1)
		if getPlayerStorageValue(cid, Storage.DemonOak.Progress) == 1 then
			selfSay("A demon oak?!? <mumbles some blessings> May the gods be on our side. You'll need a {hallowed axe} to harm that tree. Bring me a simple {axe} and I'll prepare it for you.",cid)
			setPlayerStorageValue(cid, Storage.DemonOak.Progress, 2)
			talkState[talkUser] = 0
		else
			selfSay("I don't believe a word of it! How rude to lie to a monk!",cid)
			talkState[talkUser] = 0
		end
		elseif msgcontains(msg, 'axe') then
		if getPlayerStorageValue(cid, Storage.DemonOak.Progress) == 2 then
			selfSay("Ahh, you've got an axe. Very good. I can make a hallowed axe out of it. It will cost you... er... a donation of 1,000 gold. Alright?",cid)
			talkState[talkUser] = 2
		else
			selfSay("You have to first talk about {demon oak} or the {mission} before we continue.",cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, 'yes') and talkState[talkUser] == 2 then
		if getPlayerStorageValue(cid, Storage.DemonOak.Progress) == 2 then
			if getPlayerBalance(cid) + getPlayerBalance(cid) >= 1000 then
				if doPlayerRemoveItem(cid, 2386, 1) and doPlayerRemoveMoney(cid, 1000) then
					selfSay("Let's see....<mumbles a prayer>....here we go. The blessing on this axe will be absorbed by all the demonic energy around here. I presume it will not last very long, so better hurry. Actually, I can refresh the blessing as often as you like.",cid)
					doPlayerAddItem(cid, 8293, 1)
					Npc():getPosition():sendMagicEffect(CONST_ME_YELLOWENERGY)
					talkState[talkUser] = 0
				else
					selfSay("There is no axe with you.",cid)
					talkState[talkUser] = 0
				end
			else
				selfSay("There is not enough of money with you.",cid)
				talkState[talkUser] = 0
			end
		end
	elseif msgcontains(msg, 'no') and talkState[talkUser] == 1 then
		selfSay("What a pity! Let me know when you managed to get in there. Maybe I can help you when we know what we are dealing with.",cid)
		talkState[talkUser] = 0
	elseif msgcontains(msg, 'no') and talkState[talkUser] == 2 then
		selfSay("No then.",cid)
		talkState[talkUser] = 0
	end

		if msgcontains(msg, 'hugo') then
		if getPlayerStorageValue(cid, Storage.DemonOak.Done) < 1 then
			selfSay("How do you know? Did you go into the infested area?", cid)
			talkState[talkUser] = 1
		elseif getPlayerStorageValue(cid, Storage.DemonOak.Progress) == 2 and getPlayerStorageValue(cid, Storage.DemonOak.Done) < 1 then
			selfSay("You better don't return here until you've defeated the Demon Oak.", cid)
		elseif getPlayerStorageValue(cid, Storage.DemonOak.Done) == 1 then
			selfSay({
				"You chopped down the demon oak?!? Unbelievable!! Let's hope it doesn't come back. As long as evil is still existent in the soil of the plains, it won't be over. Still, the demons suffered a setback, that's for sure. ...",
				"For your brave action, I tell you a secret which has been kept for many many years. There is an old house south of the location where you found the demon oak. There should be a grave with the name 'Yesim Adeit' somewhere close by. ...",
				"It belongs to a Daramian nobleman named 'Teme Saiyid'. I knew him well and he told me -almost augured- that someone will come who is worthy to obtain his treasure. I'm sure this 'someone' is you. Good luck in finding it!"
			}, cid)
			setPlayerStorageValue(cid, Storage.DemonOak.Done, 2)
		end
		elseif msgcontains(msg, 'yes') and talkState[talkUser] == 1 then
			setPlayerStorageValue(cid, Storage.DemonOak.Progress, 1)
		if getPlayerStorageValue(cid, Storage.DemonOak.Progress) == 1 then
			selfSay("A demon oak?!? <mumbles some blessings> May the gods be on our side. You'll need a {hallowed axe} to harm that tree. Bring me a simple {axe} and I'll prepare it for you.",cid)
			setPlayerStorageValue(cid, Storage.DemonOak.Progress, 2)
			talkState[talkUser] = 0
		else
			selfSay("I don't believe a word of it! How rude to lie to a monk!",cid)
			talkState[talkUser] = 0
		end
		elseif msgcontains(msg, 'axe') then
		if getPlayerStorageValue(cid, Storage.DemonOak.Progress) == 2 then
			selfSay("Ahh, you've got an axe. Very good. I can make a hallowed axe out of it. It will cost you... er... a donation of 1,000 gold. Alright?",cid)
			talkState[talkUser] = 2
		else
			selfSay("You have to first talk about {demon oak} or the {mission} before we continue.",cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, 'yes') and talkState[talkUser] == 2 then
		if getPlayerStorageValue(cid, Storage.DemonOak.Progress) == 2 then
			if getPlayerBalance(cid) + getPlayerBalance(cid) >= 1000 then
				if doPlayerRemoveItem(cid, 2386, 1) and doPlayerRemoveMoney(cid, 1000) then
					selfSay("Let's see....<mumbles a prayer>....here we go. The blessing on this axe will be absorbed by all the demonic energy around here. I presume it will not last very long, so better hurry. Actually, I can refresh the blessing as often as you like.",cid)
					doPlayerAddItem(cid, 8293, 1)
					Npc():getPosition():sendMagicEffect(CONST_ME_YELLOWENERGY)
					talkState[talkUser] = 0
				else
					selfSay("There is no axe with you.",cid)
					talkState[talkUser] = 0
				end
			else
				selfSay("There is not enough of money with you.",cid)
				talkState[talkUser] = 0
			end
		end
	elseif msgcontains(msg, 'no') and talkState[talkUser] == 1 then
		selfSay("What a pity! Let me know when you managed to get in there. Maybe I can help you when we know what we are dealing with.",cid)
		talkState[talkUser] = 0
	elseif msgcontains(msg, 'no') and talkState[talkUser] == 2 then
		selfSay("No then.",cid)
		talkState[talkUser] = 0
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, 'Welcome |PLAYERNAME|! Only rarely I can welcome visitors these days.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Good Bye, |PLAYERNAME|')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good Bye, |PLAYERNAME|')
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())