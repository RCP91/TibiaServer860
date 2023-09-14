local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{ text = 'Indeed, there has to be some other way.' },
	{ text = 'Mmh, interesting.' },
	{ text = 'Yes indeed, all of the equipment should be checked and calibrated regularly.' },
	{ text = 'No, we have to give this another go.' }
}

local function releasePlayer(cid)
	if not Player(cid) then
		return
	end

	npcHandler:releaseFocus(cid)
	npcHandler:resetNpc(cid)
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	

	if msgcontains(msg, 'mission') then
		local qStorage = getPlayerStorageValue(cid, Storage.spiritHuntersQuest.missionUm)
		if qStorage == 3 then
			selfSay("So, did you find anything worth examining? Did you actually catch a ghost?",cid)
			talkState[talkUser] = 3
		elseif qStorage == 2 then
			selfSay({"So you have passed Spectulus' acceptance test. Well, I'm sure you will live up to that. ...",
							"We are trying to get this business up and running and need any help we can get. Did he tell you about the spirit cage?"
							}, cid)
			talkState[talkUser] = 1
		elseif qStorage > 2 then
			selfSay("You already done this quest.",cid)
			talkState[talkUser] = 0
		elseif qStorage < 2 then
			selfSay("Talk research with spectulus to take some mission.",cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, 'yes') then
		if talkState[talkUser] == 1 then
			selfSay({"Excellent. Now we need to concentrate on testing that thing. The spirit cage has been calibrated based on some tests we made - as well as your recent findings over at the graveyard. ...",
						"Using the device on the remains of a ghost right after its defeat should capture it inside this trap. We could then transfer it into our spirit chamber which is in fact a magical barrier. ..",
						"At first, however, we need you to find a specimen and bring it here for us to test the capacity of the device. Are you ready for this?"
						}, cid)
			talkState[talkUser] = 2
		elseif talkState[talkUser] == 2 then
			selfSay("Good, now all you need to do is find a ghost, defeat it and catch its very essence with the cage. Once you have it, return to me and Spectulus and I will move it into our chamber device. Good luck, return to me as soon as you are prepared.", cid)
			setPlayerStorageValue(cid, Storage.spiritHuntersQuest.missionUm, 3)
			doPlayerAddItem(cid, 12671, 1)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 3 then
			if getPlayerStorageValue(cid, Storage.spiritHuntersQuest.charmUse) == 1 then
				selfSay({"Fascinating, let me see. ...",
								"Amazing! I will transfer this to our spirit chamber right about - now! ...",
								"Alright, the device is holding it. The magical barrier should be able to contain nearly 20 times the current load. That's a complete success! Spectulus, are you seeing this? We did it! ...",
								"Well, you did! You really helped us pulling this off. Thank you Lord Stalks! ...",
								"I doubt we will have much time to hunt for new specimens ourselves in the near future. If you like, you can continue helping us by finding and capturing more and different ghosts. Just talk to me to receive a new task."
								}, cid)
				setPlayerStorageValue(cid, Storage.spiritHuntersQuest.missionUm, 4)
				player:addExperience(500, true)
				addEvent(releasePlayer, 1000, cid)
				talkState[talkUser] = 0
			else
				selfSay("Go and use the machine in a dead ghost!", cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 4 then
			selfSay({"Magnificent! Alright, we will at least need 5 caught ghosts. We will pay some more if you can catch 5 nightstalkers. Of course you will earn some more if you bring us 5 souleaters. ...",
							"I heard they dwell somewhere in that new continent - Zao? Well anyway, if you feel you've got enough, just return with what you've got and we will see. Good luck! ...",
							"Keep in mind that the specimens are only of any worth to us if the exact amount of 5 per specimen is reached. ...",
							"Furhtermore, to successfully bind Nightstalkers to the cage, you will need to have caught at least 5 Ghosts. To bind Souleaters, you will need at least 5 Ghosts and 5 Nightstalkers. ...",
							"The higher the amount of spirit energy in the cage, the higher its effective capacity. Oh and always come back and tell me if you lose your spirit cage."
							}, cid)
			setPlayerStorageValue(cid, Storage.spiritHuntersQuest.missionUm, 5)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 5 then
			selfSay("Good, of course you will also receive an additional monetary reward for your troubles. Are you fine with that?", cid)
			talkState[talkUser] = 6
		elseif talkState[talkUser] == 6 then
			local nightstalkers, souleaters, ghost = getPlayerStorageValue(cid, Storage.spiritHuntersQuest.nightstalkerUse), getPlayerStorageValue(cid, Storage.spiritHuntersQuest.souleaterUse), getPlayerStorageValue(cid, Storage.spiritHuntersQuest.ghostUse)
			if nightstalkers >= 4 and souleaters >= 4 and ghost >= 4 then
				selfSay("Alright, let us see how many ghosts you caught!", cid)
				setPlayerStorageValue(cid, Storage.spiritHuntersQuest.missionUm, 6)
				player:addExperience(8000, true)
				doPlayerAddItem(cid, 2152, 60)
				addEvent(releasePlayer, 1000, cid)
				talkState[talkUser] = 0
			else
				selfSay("You didnt catch the ghost pieces.", cid)
				talkState[talkUser] = 0
			end
		end
	elseif msgcontains(msg, 'research') then
		local qStorage = getPlayerStorageValue(cid, Storage.spiritHuntersQuest.missionUm)
		if qStorage == 4 then
			selfSay({"We are still in need of more research concerning environmental as well as psychic ecto-magical influences. Besides more common ghosts we also need some of the harder to come by nightstalkers and - if you're really hardboiled - souleaters. ...",
						"We will of course pay for every ghost you catch. You will receive more if you hunt for some of the tougher fellows - but don't overdue it. What do you say?"
						}, cid)
			talkState[talkUser] = 4
		elseif qStorage == 5 then
			selfSay(" Alright you found something! Are you really finished hunting out there?", cid)
			talkState[talkUser] = 5
		end
	end

	return true
end

--npcHandler:addModule(VoiceModule:new(voices))

npcHandler:setMessage(MESSAGE_GREET, "Greetings |PLAYERNAME|. I have - very - little time, please make it as short as possible. I may be able to help you if you are here to help us with any of our tasks or missions.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Goodbye and good luck |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Goodbye and good luck |PLAYERNAME|.")

npcHandler:addModule(FocusModule:new())

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
