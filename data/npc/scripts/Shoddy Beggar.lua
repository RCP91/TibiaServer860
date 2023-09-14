local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{ text = '*mumbles*' },
	{ text = 'That astronomer of the academy simply has no idea what he is dealing with...' },
	{ text = 'Some secrets should better be left uncovered.' },
	{ text = 'Ha, ha... *mumbles* Hmm.' }
}

--npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	

	if msgcontains(msg, 'spare') then
		selfSay('Hmm, if you can spare a coin... we can talk. What do you say?', cid)
		talkState[talkUser] = 1
	elseif msgcontains(msg, 'device') then
		if getPlayerStorageValue(cid, Storage.SeaOfLightQuest.Questline) == 1 then
			selfSay('Persistent little nuisance, aren\'t we? Well, I like your spirit so I will tell you a secret. I may not look the part but I was once a {scientist}. The academy seemed to not like my... attitude and never actually invited me.', cid)
		end
	elseif msgcontains(msg, 'scientist') then
		if getPlayerStorageValue(cid, Storage.SeaOfLightQuest.Questline) == 1 then
			selfSay('Indeed, I was one myself a long time ago. I may seem a little... distracted by now, but I was working on many important projects. I even created a device to... well, it will cost you another gold coin if you want me to tell you the whole story. You\'re in?', cid)
			talkState[talkUser] = 2
		end
	elseif msgcontains(msg, 'yes') then
		if talkState[talkUser] == 1 then
			if not doPlayerRemoveMoney(cid, 1) then
				selfSay(getPlayerStorageValue(cid, Storage.SeaOfLightQuest.Questline) ~= 1 and 'Is that all you have? That would be less than I have... *mumbles*' or 'Mh, it seems you don\'t have any coins.', cid)
				talkState[talkUser] = 0
				return true
			end

			selfSay(getPlayerStorageValue(cid, Storage.SeaOfLightQuest.Questline) ~= 1 and 'Very kind indeed. Maybe you are not such a bad guy after all. Maybe I can even give it back to you one day... you know I was not always like that *mumbles*.' or 'Thank you very much... plans you say? I don\'t know what you are talking about. Plans for a magic... {device}? And the people call ME crazy.', cid)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 2 then
			if not doPlayerRemoveMoney(cid, 1) then
				selfSay('Well, if that is all you can spare... better keep it.', cid)
				talkState[talkUser] = 0
				return true
			end

			selfSay('Alright, it seems you are serious about this. I will tell you about my device. Every night I looked up to the stars and wondered what worlds we would be able to find if we could just look where we wanted to. So... hey are you still listening?', cid)
			talkState[talkUser] = 3
		elseif talkState[talkUser] == 3 then
			selfSay('Good, good. So eventually I found a way and invented a magic device I called the Lightboat. It was a large construction you could sit in and... well, judging by your looks you don\'t believe a word. Do you want to hear the story or not?', cid)
			talkState[talkUser] = 4
		elseif talkState[talkUser] == 4 then
			selfSay('Fine. For years I gathered all the necessary items to build the device. I travelled, traded and took advantage of some rare opportunities. With luck and patience I eventually got every component I needed. Can you imagine the excitement I experienced?', cid)
			talkState[talkUser] = 5
		elseif talkState[talkUser] == 5 then
			selfSay('And there I stood before my greatest invention. Door to unknown places, mysterious worlds... yet one of my components was flawed. A small crack in a vital element of my construction quickly led to the failure of the whole project. Still following?', cid)
			talkState[talkUser] = 6
		elseif talkState[talkUser] == 6 then
			selfSay('The device was ultimately destroyed. I barely escaped the chaos with my life. My laboratory was shattered, as were all the components of the cursed device. With nothing left, I started to lead a new, different life. Do you know what that means?', cid)
			talkState[talkUser] = 7
		elseif talkState[talkUser] == 7 then
			selfSay('Pah!! You have NO idea, leave me alone now.', cid)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 8 then
			selfSay('Right... I\'m glad everything was destroyed. I don\'t even know why I kept the remaining copy of the plans all those years... oh, did I say this aloud?', cid)
			talkState[talkUser] = 9
		elseif talkState[talkUser] == 9 then
			selfSay('Yes, well... I do have one remaining copy of the plans. I will keep them as a... reminder. Such ill-fated devices only cause trouble and despair. Mankind would be better off, without them, right?', cid)
			talkState[talkUser] = 10
		elseif talkState[talkUser] == 10 then
			selfSay('Ah, you think you are wise but you know nothing, nothing about science, nothing about the opportunities it offers... You will never understand scientists like me.', cid)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 11 then
			doPlayerAddItem(cid, 10613, 1)
			setPlayerStorageValue(cid, Storage.SeaOfLightQuest.Questline, 2)
			setPlayerStorageValue(cid, Storage.SeaOfLightQuest.Mission1, 2)
			selfSay('Well, to be honest, I envy him a little. He can continue his research in his laboratory. He still has working equipment... I sometimes read his publications. He is an able man, but completely on the wrong track... give these plans to him.', cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, 'no') then
		if talkState[talkUser] == 1 then
			selfSay('Mean, heartless... go and leave me be.', cid)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 2 then
			selfSay('Well, whatever then...', cid)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 3 then
			selfSay('Then stop bothering me.', cid)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 4 then
			selfSay('Your decision.', cid)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 5 then
			selfSay('Yes and I, I... you mean what? Can\'t imagine? Well, then there is no purpose to continue telling you this story.', cid)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 6 then
			selfSay('*mumbles*', cid)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 7 then
			selfSay('Thought so. It means starting anew, without any home, money or goal in your life. However, it also opens up opportunities... don\'t you agree?', cid)
			talkState[talkUser] = 8
		elseif talkState[talkUser] == 8 then
			selfSay('No, no, you are right, I should have tried to rebuild it, I should have been more careful, I should... ah, why did I even tell you this.', cid)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 9 then
			selfSay('Phew... alright, it was nice talking to you.', cid)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 10 then
			selfSay('Hm, maybe you are right. You could give these plans to someone who might be able to finish this project. Someone who will not make the mistakes I made. Someone... hm, do you know the astronomer Spectulus?', cid)
			talkState[talkUser] = 11
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "What do you want? Listen to the old madman? If you have nothing to {spare}, leave me alone.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Yes, whatever.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Yes, whatever.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
