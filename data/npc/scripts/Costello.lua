local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end

function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
	return false
    end

    
	if msgcontains(msg, 'fugio') then
		if getPlayerStorageValue(cid, Storage.QuestChests.FamilyBrooch) == 1 then
			selfSay('To be honest, I fear the omen in my dreams may be true. Perhaps Fugio is unable to see the danger down there. Perhaps ... you are willing to investigate this matter?', cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, 'diary') then
		if getPlayerStorageValue(cid, Storage.WhiteRavenMonasteryQuest.Diary) == 1 then
			selfSay('Do you want me to inspect a diary?', cid)
			talkState[talkUser] = 2
		end
	elseif msgcontains(msg, 'holy water') then
		local cStorage = getPlayerStorageValue(cid, Storage.TibiaTales.RestInHallowedGround.Questline)
		if cStorage == 1 then
			selfSay('Who are you to demand holy water from the White Raven Monastery? Who sent you??', cid)
			talkState[talkUser] = 3
		elseif cStorage == 2 then
			selfSay('I already filled your vial with holy water.', cid)
		end
	elseif msgcontains(msg, 'amanda') and talkState[talkUser] == 0 then
		if getPlayerStorageValue(cid, Storage.TibiaTales.RestInHallowedGround.Questline) == 1 then
			selfSay('Ahh, Amanda from Edron sent you! I hope she\'s doing well. So why did she send you here?', cid)
		end
	elseif msgcontains(msg, 'yes') then
		if talkState[talkUser] == 1 then
			selfSay('Thank you very much! From now on you may open the warded doors to the catacombs.', cid)
			setPlayerStorageValue(cid, Storage.WhiteRavenMonasteryQuest.Diary, 1)
		elseif talkState[talkUser] == 2 then
			if not doPlayerRemoveItem(cid, 2325, 1) then
				selfSay('Uhm, as you wish.', cid)
				return true
			end

			selfSay('By the gods! This is brother Fugio\'s handwriting and what I read is horrible indeed! You have done our order a great favour by giving this diary to me! Take this blessed Ankh. May it protect you in even your darkest hours.', cid)
			doPlayerAddItem(cid, 2327, 1)
			setPlayerStorageValue(cid, Storage.WhiteRavenMonasteryQuest.Diary, 2)
		end
	elseif talkState[talkUser] == 3 then
		if not msgcontains(msg, 'amanda') then
			selfSay('I never heard that name and you won\'t get holy water for some stranger.', cid)
			talkState[talkUser] = 0
			return true
		end

		doPlayerAddItem(cid, 7494, 1)
		setPlayerStorageValue(cid, Storage.TibiaTales.RestInHallowedGround.Questline, 2)
		selfSay('Ohh, why didn\'t you tell me before? Sure you get some holy water if it\'s for Amanda! Here you are.', cid)
		talkState[talkUser] = 0
	elseif msgcontains(msg, 'no') and isInArray({1, 2}, talkState[talkUser]) then
		selfSay('Uhm, as you wish.', cid)
		talkState[talkUser] = 0
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Welcome, |PLAYERNAME|! Feel free to tell me what has brought you here.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye. Come back soon.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
