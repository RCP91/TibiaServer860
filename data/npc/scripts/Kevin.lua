local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)	npcHandler:onCreatureSay(cid, type, msg)	end
function onThink()						npcHandler:onThink()						end

local function getPlayerBones(cid)
	
	return getPlayerItemCount(cid, 2230) + getPlayerItemCount(cid, 2231)
end

local function doPlayerRemoveBones(cid)
	
	return doPlayerRemoveItem(cid, 2230, getPlayerItemCount(cid, 2230)) and doPlayerRemoveItem(cid, 2231, getPlayerItemCount(cid, 2231))
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	
	if msgcontains(msg, "mission") then
		if getPlayerStorageValue(cid, Storage.postman.Mission01) < 1 then
			selfSay("You are not a member of our guild yet! We have high standards for our members. To rise in our guild is a difficult but rewarding task. Are you interested in joining?", cid)
			talkState[talkUser] = 1
		elseif getPlayerStorageValue(cid, Storage.postman.Mission01) == 5 then
			selfSay("So you have finally made it! I did not think that you would have it in you ... However: are you ready for another assignment?", cid)
			talkState[talkUser] = 8
		elseif getPlayerStorageValue(cid, Storage.postman.Mission02) == 2 then
			selfSay("Excellent, you got it fixed! This will teach this mailbox a lesson indeed! Are you interested in another assignment?", cid)
			setPlayerStorageValue(cid, Storage.postman.Mission02, 3)
			talkState[talkUser] = 9
		elseif getPlayerStorageValue(cid, Storage.postman.Mission03) == 2 then
			selfSay("You truly got him? Quite impressive. You are a very promising candidate! I think I have another mission for you. Are you interested?", cid)
			talkState[talkUser] = 11
		elseif getPlayerStorageValue(cid, Storage.postman.Mission04) == 1 then
			selfSay("Do you bring all bones for our officers' safety fund at once?", cid)
			talkState[talkUser] = 13
		elseif getPlayerStorageValue(cid, Storage.postman.Mission05) == 3 then
			selfSay("Splendid, I knew we could trust you. I would like to ask for your help in another matter. Are you interested?", cid)
			talkState[talkUser] = 16
		elseif getPlayerStorageValue(cid, Storage.postman.Mission07) ==  7 then
			selfSay("Once more you have impressed me! Are you willing to do another job?", cid)
			talkState[talkUser] = 21
		elseif getPlayerStorageValue(cid, Storage.postman.Mission06) >= 1	and	getPlayerStorageValue(cid, Storage.postman.Mission06) < 10 then
			selfSay("First you need to complete your current mission.", cid)
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.postman.Mission06) == 12 then
			selfSay("Excellent! Another job well done! Would you accept another mission?", cid)
			setPlayerStorageValue(cid, Storage.postman.Mission06, 13)
			talkState[talkUser] = 28
		elseif getPlayerStorageValue(cid, Storage.postman.Mission06) == 10 then
			selfSay("Fine, fine. I think that should do it. Tell Hugo that we order those uniforms. The completed dress pattern will soon arrive in Venore. Report to me when you have talked to him.", cid)
			setPlayerStorageValue(cid, Storage.postman.Mission06, 11)
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.postman.Mission08) == 2 then
			selfSay("So Waldo is dead? This is grave news indeed. Did you recover his posthorn?", cid)
			talkState[talkUser] = 23
		elseif getPlayerStorageValue(cid, Storage.postman.Mission09) == 3 then
			selfSay("You did it? I hope you did not catch a flu in the cold! Anyway, there's another mission for you. Are you interested?", cid)
			talkState[talkUser] = 26
		elseif getPlayerStorageValue(cid, Storage.postman.Mission10) == 2 then
			selfSay("You have delivered that letter? You are a true postofficer. All over the land bards shallpraise your name. There are no missions for you left right now.", cid)
			setPlayerStorageValue(cid, Storage.postman.Mission10, 3)
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.postman.Mission10) == 3	and getPlayerStorageValue(cid, Storage.postman.Rank) == 5 then
			selfSay("There are no missions for you left right now. You already have the title of Archpostman.", cid)
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.postman.Mission10) == 3	and getPlayerStorageValue(cid, Storage.postman.Rank) == 4 then
			selfSay("There are no missions for you left right now. But you are worthy indeed. Do you want to advance in our guild?", cid)
			talkState[talkUser] = 27
		elseif getPlayerStorageValue(cid, Storage.postman.Mission08) == 3 and getPlayerStorageValue(cid, Storage.postman.Rank) == 3 then
			selfSay("So are you ready for another mission?", cid)
			talkState[talkUser] = 28
		elseif getPlayerStorageValue(cid, Storage.postman.Mission08) == 3	and getPlayerStorageValue(cid, Storage.postman.Rank) == 4 then
			selfSay("So are you ready for another mission?", cid)
			talkState[talkUser] = 25
		elseif getPlayerStorageValue(cid, Storage.postman.Rank) == 4	or	getPlayerStorageValue(cid, Storage.postman.Rank) == 3 and getPlayerStorageValue(cid, Storage.postman.Mission09) == 0 then
			selfSay("So are you ready for another mission?", cid)
			talkState[talkUser] = 25
		elseif getPlayerStorageValue(cid, Storage.postman.Mission06) == 13 and getPlayerStorageValue(cid, Storage.postman.Rank) == 3 then
			selfSay("Excellent! Another job well done! Would you accept another mission?", cid)
			talkState[talkUser] = 19
		elseif getPlayerStorageValue(cid, Storage.postman.Mission06) == 13 and getPlayerStorageValue(cid, Storage.postman.Rank) == 2 then
			selfSay("Excellent! Another job well done! Would you accept another mission?", cid)
			talkState[talkUser] = 28
		elseif getPlayerStorageValue(cid, Storage.postman.Mission04) == 2 and getPlayerStorageValue(cid, Storage.postman.Rank) == 2 then
			selfSay("You have made it! We have enough bones for the fund! You remind me of myself when I was young! Interested in another mission?", cid)
			talkState[talkUser] = 15
		elseif getPlayerStorageValue(cid, Storage.postman.Mission04) == 2 and getPlayerStorageValue(cid, Storage.postman.Rank) == 1 then
			selfSay("You have made it! We have enough bones for the fund! You remind me of myself when I was young! Interested in another mission?", cid)
			talkState[talkUser] = 28
		elseif getPlayerStorageValue(cid, Storage.postman.Mission03) == 3 and getPlayerStorageValue(cid, Storage.postman.Mission04) == 0 then
			selfSay("You truly got him? Quite impressive. You are a very promising candidate! I think I have another mission for you. Are you interested?", cid)
			talkState[talkUser] = 11
		elseif getPlayerStorageValue(cid, Storage.postman.Rank) == 1	 and getPlayerStorageValue(cid, Storage.postman.Mission03) == 3 then
			selfSay("So are you ready for another mission?", cid)
			talkState[talkUser] = 11
		elseif getPlayerStorageValue(cid, Storage.postman.Mission02) == 3	and getPlayerStorageValue(cid, Storage.postman.Rank) == 1 then
			selfSay("So are you ready for another mission?", cid)
			talkState[talkUser] = 10
		end
	elseif msgcontains(msg, "dress pattern") then
		if getPlayerStorageValue(cid, Storage.postman.Mission06) == 2 then
			selfSay("Oh yes, where did we get that from ...? Let's see, first ask the great technomancer in Kazordoon for the technical details. Return here afterwards.", cid)
			setPlayerStorageValue(cid, Storage.postman.Mission06, 3)
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.postman.Mission06) == 4 then
			selfSay("The mail with Talphion's instructions just arived. I remember we asked Queen Eloise of Carlin for the perfect colours. Go there, ask her about the UNIFORMS and report back here.", cid)
			setPlayerStorageValue(cid, Storage.postman.Mission06, 5)
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.postman.Mission06) == 6 then
			selfSay("The queen has sent me the samples we needed. The next part is tricky. We need theuniforms to emanate some odor that dogs hate.The dog with the best 'taste' in that field is Noodles,the dog of King Tibianus. Do you understand so far?", cid)
			talkState[talkUser] = 18
		elseif getPlayerStorageValue(cid, Storage.postman.Mission06) == 10 then
			selfSay("Fine, fine. I think that should do it. Tell Hugo that we order those uniforms. The completed dress pattern will soon arrive in Venore. Report to me when you have talked to him.", cid)
			setPlayerStorageValue(cid, Storage.postman.Mission06, 11)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "advancement") then
		if getPlayerStorageValue(cid, Storage.postman.Mission04) == 2 and getPlayerStorageValue(cid, Storage.postman.Rank) == 1 then
			selfSay("You are worthy indeed. Do you want to advance in our guild?", cid)
			talkState[talkUser] = 14
		elseif getPlayerStorageValue(cid, Storage.postman.Mission06) == 13 and getPlayerStorageValue(cid, Storage.postman.Rank) == 2 then
			selfSay("You are worthy indeed. Do you want to advance in our guild?", cid)
			talkState[talkUser] = 20
		elseif getPlayerStorageValue(cid, Storage.postman.Mission08) == 3 and getPlayerStorageValue(cid, Storage.postman.Rank) == 3 then
			selfSay("You are worthy indeed. Do you want to advance in our guild?", cid)
			talkState[talkUser] = 24
		elseif getPlayerStorageValue(cid, Storage.postman.Mission10) == 3 and getPlayerStorageValue(cid, Storage.postman.Rank) == 4 then
			selfSay("You are worthy indeed. Do you want to advance in our guild?", cid)
			talkState[talkUser] = 27
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			selfSay("Hm, I might consider your proposal, but first you will have to prove your worth by doing some tasks for us. Are you willing to do that?", cid)
			talkState[talkUser] = 2
		elseif talkState[talkUser] == 2 then
			selfSay("Excellent! Your first task will be quite simple. But you should better write my instructions down anyways. You can read and write?", cid)
			talkState[talkUser] = 3
		elseif talkState[talkUser] == 3 then
			selfSay("So listen, you will check certain tours our members have to take to see if there is some trouble. First travel with Captain Bluebear's ship from Thais to Carlin, understood?", cid)
			talkState[talkUser] = 4
		elseif talkState[talkUser] == 4 then
			selfSay("Excellent! Once you have done that you will travel with Uzon to Edron. You will find him in the Femor Hills. Understood?", cid)
			talkState[talkUser] = 5
		elseif talkState[talkUser] == 5 then
			selfSay("Fine, fine! Next, travel with Captain Seahorse to the city of Venore. Understood?", cid)
			talkState[talkUser] = 6
		elseif talkState[talkUser] == 6 then
			selfSay("Good! Finally, find the technomancer Brodrosch and travel with him to the Isle of Cormaya. After this passage report back to me here. Understood?", cid)
			talkState[talkUser] = 7
		elseif talkState[talkUser] == 7 then
			selfSay("Ok, remember: the Tibian mail service puts trust in you! Don't fail and report back soon. Just tell me about your {mission}.", cid)
			setPlayerStorageValue(cid, Storage.postman.Mission01, 1)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 8 then
			selfSay("I am glad to hear that. One of our mailboxes was reported to be jammed. It is located on the so called 'mountain' on theisle Folda. Get a crowbar and fix the mailbox. Report about your mission when you have done so.", cid)
			setPlayerStorageValue(cid, Storage.postman.Mission01, 6)
			setPlayerStorageValue(cid, Storage.postman.Mission02, 1)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 9 then
			selfSay("For your noble deeds I grant you the title Assistant Postofficer. All Postofficers will charge you less money from now on. After every second mission ask me for an ADVANCEMENT. Your next task will be a bit more challenging. Do you feel ready for it?", cid)
			setPlayerStorageValue(cid, Storage.postman.Rank, 1)
			talkState[talkUser] = 10
		elseif talkState[talkUser] == 10 then
			selfSay("I need you to deliver a bill to the stage magician David Brassacres. He's hiding from his creditors somewhere in Venore. It's likely you will have to trick him somehow to reveal his identity. Report back when you delivered this bill.", cid)
			setPlayerStorageValue(cid, Storage.postman.Mission03, 1)
			doPlayerAddItem(cid, 2329, 1)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 11 then
			selfSay("Ok, listen: we have some serious trouble with agressive dogs lately. We have accumulated some bones as a sort of pacifier but we need more. Collect 20 bones like the one in my room to the left and report here.", cid)
			setPlayerStorageValue(cid, Storage.postman.Mission03, 3)
			setPlayerStorageValue(cid, Storage.postman.Mission04, 1)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 13 then
			if getPlayerBones(cid) >= 20 then
				doPlayerRemoveBones(cid)
				selfSay("You have collected all the 20 bones needed. Excellent! Now let's talk about further missions if you are interested.", cid)
				setPlayerStorageValue(cid, Storage.postman.Mission04, 2)
				talkState[talkUser] = 0
			else
				talkState[talkUser] = 0
				selfSay("You don't have it...", cid)
			end
		elseif talkState[talkUser] == 14 then
			selfSay("I grant you the title of postman. You are now a full member of our guild. Here have your own officers hat and wear it with pride.", cid)
			setPlayerStorageValue(cid, Storage.postman.Rank, 2)
			doPlayerAddItem(cid, 2665, 1)
			talkState[talkUser] = 15
		elseif talkState[talkUser] == 15 then
			selfSay("Since I am convinced I can trust you, this time you must deliver a valuable present to Dermot on Fibula. Do NOT open it!!! You will find the present behind the door here on the lower right side of this room.", cid)
			setPlayerStorageValue(cid, Storage.postman.Mission05, 1)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 16 then
			selfSay("Ok. We need a new set of uniforms, and only the best will do for us. Please travel to Venore and negotiate with Hugo Chief acontract for new uniforms.", cid)
			setPlayerStorageValue(cid, Storage.postman.Mission05, 4)
			setPlayerStorageValue(cid, Storage.postman.Mission06, 1)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 18 then
			selfSay("Good. Go there and find out what taste he dislikes most: mouldy cheese, a piece of fur or abananaskin. Tell him to SNIFF, then the object. Show him the object and ask 'Do you like that?'.DONT let the guards know what you are doing.", cid)
			setPlayerStorageValue(cid, Storage.postman.Mission06, 7)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 19 then
			selfSay("Good, so listen. Hugo Chief informed me that he needs the measurements of our postofficers. Go and bring me the measurements of Ben, Lokur, Dove, Liane, Chrystal and Olrik.", cid)
			setPlayerStorageValue(cid, Storage.postman.Mission07, 1)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 20 then
			selfSay("From now on it shall be known that you are a grand postman. You are now a privilegedmember until the end of days. Most captains around the world have an agreement with our guild to transport our privileged members, like you, for less gold.", cid)
			setPlayerStorageValue(cid, Storage.postman.Rank, 3)
			talkState[talkUser] = 19
		elseif talkState[talkUser] == 21 then
			selfSay("Ok but your next assignment might be dangerous. Our Courier Waldo has been missing for a while. I must assume he is dead. Can you follow me so far?", cid)
			talkState[talkUser] = 22
		elseif talkState[talkUser] == 22 then
			selfSay("Find out about his whereabouts and retrieve him or at least his posthorn. He was looking for a new underground passage that is rumoured to be found underneath the troll-infested Mountain east of Thais.", cid)
			setPlayerStorageValue(cid, Storage.postman.Mission07, 8)
			setPlayerStorageValue(cid, Storage.postman.Mission08, 1)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 23 then
			if doPlayerRemoveItem(cid, 2332, 1) then
			selfSay("Thank you. We will honour this. Your next mission will be a very special one. Good thing you are a special person as well. Are you ready?", cid)
			setPlayerStorageValue(cid, Storage.postman.Mission08, 3)
			setPlayerStorageValue(cid, Storage.postman.Mission09, 0)
			talkState[talkUser] = 28
			end
		elseif talkState[talkUser] == 24 then
			selfSay("From now on you are a grand postman for special operations. You are an honoured member of our guild and earned the privilege of your own post horn. Here, take it.", cid)
			setPlayerStorageValue(cid, Storage.postman.Rank, 4)
			doPlayerAddItem(cid, 2078, 1)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 25 then
			selfSay("So listen well. Behind the lower left door you will find a bag. The letters in the bag are for none other than Santa Claus! Deliver them to his house on the isle of Vega, {use} thebag on his mailbox and report back here.", cid)
			setPlayerStorageValue(cid, Storage.postman.Mission09, 1)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 26 then
			selfSay("Excellent. Here is a letter for you to deliver. Well, to be honest, no one else volunteered. It's a letter from the mother of Markwin, the king of Mintwallin. Deliver that letter to him, but note that you will not be welcome there.", cid)
			setPlayerStorageValue(cid, Storage.postman.Mission09, 4)
			setPlayerStorageValue(cid, Storage.postman.Mission10, 1)
			doPlayerAddItem(cid, 2333, 1)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 27 then
			selfSay("I grant you the title of Archpostman. You are a legend in our guild. As privilege of your newly aquired status you are allowed to make use of certain mailboxes in dangerous areas. Just look out for them and you'll see.", cid)
			setPlayerStorageValue(cid, Storage.postman.Rank, 5)
			setPlayerStorageValue(cid, Storage.postman.Door, 1)
			--player:addAchievement('Archpostman')
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 28 then
			selfSay("Your eagerness is a virtue, young one, but first let's talk about advancement", cid)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
