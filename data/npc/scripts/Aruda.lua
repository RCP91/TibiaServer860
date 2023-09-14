local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local Price = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = { {text = 'Hey there, up for a chat?'} }
--npcHandler:addModule(VoiceModule:new(voices))

local function greetCallback(cid)
	if Player(cid):getSex() == PLAYERSEX_FEMALE then
		npcHandler:setMessage(MESSAGE_GREET, "Oh, hello |PLAYERNAME|, your hair looks great! Who did it for you?")
		talkState[talkUser] = 1
	else
		npcHandler:setMessage(MESSAGE_GREET, "Oh, hello, handsome! It's a pleasure to meet you, |PLAYERNAME|. Gladly I have the time to {chat} a bit.")
		talkState[talkUser] = nil
	end
	Price[cid] = nil
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	
	local Sex = player:getSex()
	if talkState[talkUser] == 1 then
		selfSay("I would never have guessed that.", cid)
		talkState[talkUser] = nil
	elseif talkState[talkUser] == 2 then
		if doPlayerRemoveMoney(cid, Price[cid]) then
			selfSay("Oh, sorry, I was distracted, what did you say?", cid)
		else
			selfSay("Oh, I just remember I have some work to do, sorry. Bye!", cid)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		end
		talkState[talkUser] = nil
		Price[cid] = nil
	elseif talkState[talkUser] == 3 and doPlayerRemoveItem(cid, 2036, 1) then
		selfSay("Take some time to talk to me!", cid)
		talkState[talkUser] = nil
	elseif talkState[talkUser] == 4 and (msgcontains(msg, "spouse") or msgcontains(msg, "girlfriend")) then
		selfSay("Well ... I have met him for a little while .. but this was nothing serious.", cid)
		talkState[talkUser] = 5
	elseif talkState[talkUser] == 5 and msgcontains(msg, "fruit") then
		selfSay("I remember that grapes were his favourites. He was almost addicted to them.", cid)
		talkState[talkUser] = nil
	elseif msgcontains(msg, "how") and msgcontains(msg, "are") and msgcontains(msg, "you") then
		selfSay("Thank you very much. How kind of you to care about me. I am fine, thank you.", cid)
		talkState[talkUser] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "sell") then
		selfSay("Sorry, I have nothing to sell.", cid)
		talkState[talkUser] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "job") or msgcontains(msg, "chat") then
		selfSay("I do some work now and then. Nothing unusual, though. So I have plenty time to chat. If you are interested in any topic just ask me.", cid)
		talkState[talkUser] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "name") then
		if Sex == PLAYERSEX_FEMALE then
			selfSay("I am Aruda.", cid)
		else
			selfSay("I am a little sad, that you seem to have forgotten me, handsome. I am Aruda.", cid)
		end
		talkState[talkUser] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "aruda") then
		if Sex == PLAYERSEX_FEMALE then
			selfSay("Yes, that's me!", cid)
		else
			selfSay("Oh, I like it, how you say my name.", cid)
		end
		talkState[talkUser] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "time") then
		selfSay("Please don't be so rude to look for the time if you are talking to me.", cid)
		talkState[talkUser] = 3
	elseif msgcontains(msg, "help") then
		selfSay("I am deeply sorry, I can't help you.", cid)
		talkState[talkUser] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "monster") or msgcontains(msg, "dungeon") then
		selfSay("UH! What a terrifying topic. Please let us speak about something more pleasant, I am a weak and small woman after all.", cid)
		talkState[talkUser] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "sewer") then
		selfSay("What gives you the impression, I am the kind of women, you find in sewers?", cid)
		talkState[talkUser] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "god") then
		selfSay("You should ask about that in one of the temples.", cid)
		talkState[talkUser] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "king") then
		selfSay("The king, that lives in this fascinating castle? I think he does look kind of cute in his luxurious robes, doesn't he?", cid)
		talkState[talkUser] = 2
		Price[cid] = 10
	elseif msgcontains(msg, "sam") then
		if Sex == PLAYERSEX_FEMALE then
			selfSay("He is soooo strong! What muscles! What a body! Did you ask him for a date?", cid)
		else
			selfSay("He is soooo strong! What muscles! What a body! On the other hand, compared to you he looks quite puny.", cid)
		end
		talkState[talkUser] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "benjamin") then
		selfSay("He is a little simple minded but always nice and well dressed.", cid)
		talkState[talkUser] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "gorn") then
		selfSay("He should really sell some stylish gowns or something like that. We Tibians never get some clothing of the latest fashion. It's a shame.", cid)
		talkState[talkUser] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "quentin") then
		selfSay("I don't understand this lonely monks. I love company too much to become one. Hehehe!", cid)
		talkState[talkUser] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "bozo") then
		selfSay("Oh, isn't he funny? I could listen to him the whole day.", cid)
		talkState[talkUser] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "oswald") then
		selfSay("As far as I know, he is working in the castle.", cid)
		talkState[talkUser] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "rumour") or msgcontains(msg, "rumor") or msgcontains(msg, "gossip") then
		selfSay("I am a little shy and so don't hear many rumors.", cid)
		talkState[talkUser] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "kiss") and Sex == PLAYERSEX_MALE then
		selfSay("Oh, you little devil, stop talking like that! <blush>", cid)
		talkState[talkUser] = 2
		Price[cid] = 20
	elseif msgcontains(msg, "weapon") then
		selfSay("I know only little about weapons. Can you tell me something about them, please?", cid)
		talkState[talkUser] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "magic") then
		selfSay("I believe that love is stronger than magic, don't you agree?", cid)
		talkState[talkUser] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "thief") or msgcontains(msg, "theft") then
		selfSay("Oh, sorry, I have to hurry, bye!", cid)
		talkState[talkUser] = nil
		Price[cid] = nil
		npcHandler:releaseFocus(cid)
		npcHandler:resetNpc(cid)
	elseif msgcontains(msg, "tibia") then
		selfSay("I would like to visit the beach more often, but I guess it's too dangerous.", cid)
		talkState[talkUser] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "castle") then
		selfSay("I love this castle! It's so beautiful.", cid)
		talkState[talkUser] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "muriel") then
		selfSay("Powerful sorcerers frighten me a little.", cid)
		talkState[talkUser] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "elane") then
		selfSay("I personally think it's inappropriate for a woman to become a warrior, what do you think about that?", cid)
		talkState[talkUser] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "marvik") then
		selfSay("Druids seldom visit a town, what do you know about druids?", cid)
		talkState[talkUser] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "gregor") then
		selfSay("I like brave fighters like him.", cid)
		talkState[talkUser] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "noodles") then
		selfSay("Oh, he is sooooo cute!", cid)
		talkState[talkUser] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "dog") or msgcontains(msg, "poodle") then
		selfSay("I like dogs, the little ones at least. Do you like dogs, too?", cid)
		talkState[talkUser] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "excalibug") then
		selfSay("Oh, I am just a girl and know nothing about magic swords and such things.", cid)
		talkState[talkUser] = 2
		Price[cid] = 10
	elseif msgcontains(msg, "partos") then
		selfSay("I ... don't know someone named like that.", cid)
		talkState[talkUser] = 4
		Price[cid] = nil
	elseif msgcontains(msg, "yenny") then
		selfSay("Yenny? I know no Yenny, nor have I ever used that name! You have mistook me with someone else.", cid)
		talkState[talkUser] = nil
		Price[cid] = nil
		npcHandler:releaseFocus(cid)
		npcHandler:resetNpc(cid)
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "I hope to see you soon.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye, |PLAYERNAME|. I really hope we'll talk again soon.")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
