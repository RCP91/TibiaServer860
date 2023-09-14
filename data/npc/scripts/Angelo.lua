 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local playerTopic = {}
local function greetCallback(cid)

	

	-- Se estiver na 1º missão
	if getPlayerStorageValue(cid, Storage.CultsOfTibia.Life.Mission) == 1 then
		npcHandler:setMessage(MESSAGE_GREET, "The Druid of Crunor? He told you that a new cave appeared here? That's right. I'm the head of a {project} that tries to find out more about this new {area}.")
		playerTopic[cid] = 1
	-- Se já tiver após a 1º missão
	elseif getPlayerStorageValue(cid, Storage.CultsOfTibia.Life.Mission) > 1 then
		npcHandler:setMessage(MESSAGE_GREET, "How is your {mission} going?")
		playerTopic[cid] = 6
	end
	npcHandler:addFocus(cid)
	return true
end


local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	talkState[talkUser] = playerTopic[cid]
	

-- Sequência para pegar a quest
if talkState[talkUser] == 1 and msgcontains(msg, "project") then
		selfSay({"The project is called 'Sandy {Cave} Project' and is funded by the {MoTA}. Its goal is the investigation of this {cave}."}, cid)
		playerTopic[cid] = 2

	elseif talkState[talkUser] == 2 and msgcontains(msg, "mota") then
		selfSay({"MoTA is short for the recently founded Museum of Tibian Arts. We work together in close collaboration. New {results} are communicated to the museum instantly."}, cid)
		playerTopic[cid] = 3

	elseif talkState[talkUser] == 3 and msgcontains(msg, "results") then
		selfSay({"We have no scientific results so far to reach our {goal}, because my workers aren't back yet. Should I be {worried}?"}, cid)
		playerTopic[cid] = 4

	elseif talkState[talkUser] == 4 and msgcontains(msg, "yes") then
		selfSay({"Alright. I have to find out why they don't return. But I'm old and my back aches. Would you like to go there and look for my workers?"}, cid)
		playerTopic[cid] = 5

	elseif talkState[talkUser] == 5 and msgcontains(msg, "yes") then
		selfSay({"Fantastic! Go there and then tell me what you've seen. I've oppened the door for you. Take care of yourself!"}, cid)
		setPlayerStorageValue(cid, Storage.CultsOfTibia.Life.Mission, 2)
		playerTopic[cid] = 0

	-- Inútil
	elseif talkState[talkUser] == 2 and msgcontains(msg, "cave") then
		selfSay({"We don't know exactly why this cave has now exposed an entry via the {dark pyramid}. It seems that the cave already existed for a long time, however, without a connection to our world. Maybe some smaller earth movements have changed the situation."}, cid)
		playerTopic[cid] = 11

	elseif talkState[talkUser] == 11 and msgcontains(msg, "dark pyramid") then
		selfSay({"We don't know yet to wich extent the cave and the dark pyramid belong together. Thisi s what we try to find out. Maybe the history of this place has to be rewritten."}, cid)
		playerTopic[cid] = 0
end



	-- Depois de encontrar o Oasis
if getPlayerStorageValue(cid, Storage.CultsOfTibia.Life.Mission) == 3 then
	if msgcontains(msg, "mission") and talkState[talkUser] == 6 then
		selfSay({"The scientists are still missing? You just found some strange green shining mummies and a big oasis? I give you this analysis tool for the water of the oasis. Maybe that's the key. Could you bring me a sample of this water?"}, cid)
		playerTopic[cid] = 15
			elseif msgcontains(msg, "yes") and talkState[talkUser] == 15 then
			selfSay({"Very good. Hopefully analysing this sample will get us closer to the solution of this mistery."}, cid)
			doPlayerAddItem(cid, 28666, 1)
			setPlayerStorageValue(cid, Storage.CultsOfTibia.Life.Mission, 4)
	end
end

-- Depois de usar o analyzing tool
if getPlayerStorageValue(cid, Storage.CultsOfTibia.Life.Mission) == 5 then
	if msgcontains(msg, "mission") and talkState[talkUser] == 6 then
		selfSay({"Do you have the sample I asked you for?"}, cid)
		playerTopic[cid] = 16
			elseif msgcontains(msg, "yes") and talkState[talkUser] == 16 then
			selfSay({"Thanks a lot. Let me check the result. Well, I think you need the counteragent. Please apply it to the oasis!"}, cid)
			doPlayerAddItem(cid, 28665, 1)
			setPlayerStorageValue(cid, Storage.CultsOfTibia.Life.Mission, 6)
	end
end

-- Depois de usar o conteragent
if getPlayerStorageValue(cid, Storage.CultsOfTibia.Life.Mission) == 7 then
	if msgcontains(msg, "mission") and talkState[talkUser] == 6 then
		selfSay({"What has happened? You applied the counteragent to the oasis and then it was destroyed by a sandstorm? Keep on investigating the place."}, cid)
		playerTopic[cid] = 17
	end
end

-- after killing the boss the sandking
if getPlayerStorageValue(cid, Storage.CultsOfTibia.Life.Mission) == 8 then
		npcHandler:setMessage(MESSAGE_GREET, "Just get out of my way! You killed this beautiful creature. I have nothing more to say. Damn druid of Crunor!")
		setPlayerStorageValue(cid, Storage.CultsOfTibia.Life.Mission, 9)	
end


----------------------------------------- MOTA -------------------------------
	-- Pedindo o Magnifier de Gareth
if getPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Mission) == 6 then
	if msgcontains(msg, "magnifier") then
			selfSay({"{Gareth} told you that there are rumours about fake artefacts in the MoTA? And it is your task to check that with a magnifier? I see. I don't need one right now, so you can have one of mine. You find one in the crate over there."}, cid)
			setPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Mission, 7)
		end
	end

	-- Pedindo a pintura de Gareth para Angelo
if getPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Mission) == 10 then
	if msgcontains(msg, "picture") then
			selfSay({"So you found out that one artefact in the MoTA is fake? And {Gareth} sent you to me to get a new artefact as a replacement? Sorry, I hardly know you so I don't trust you. I won't help you with that!"}, cid)
			setPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Mission, 11)
		end
	end

	return true
end



npcHandler:setMessage(MESSAGE_WALKAWAY, 'Well, bye then.')

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
