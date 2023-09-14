 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local playerTopic = {}
local playerLastResp = {}
local function greetCallback(cid)

	
	if getPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Mission) == 13 then
		npcHandler:setMessage(MESSAGE_GREET, "Enter answers for the following {questions}:")
		playerTopic[cid] = 1
	else
		npcHandler:setMessage(MESSAGE_GREET, "Greetings.")
	end
	npcHandler:addFocus(cid)
	return true
end

local quiz1 = {
	[1] = {p ="The sum of first and second digit?", r = function(player)setPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Respostas, getPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Pedra1) + getPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Pedra2))return getPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Respostas)end},
	[2] = {p ="The sum of second and third digit?", r = function(player)setPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Respostas, getPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Pedra2) + getPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Pedra3))return getPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Respostas)end},
	[3] = {p ="The sum of first and third digit?", r = function(player)setPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Respostas, getPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Pedra1) + getPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Pedra3))return getPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Respostas)end},
	[4] = {p ="The digit sum?", r = function(player)setPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Respostas, getPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Pedra1) + getPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Pedra2) + getPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Pedra3))return getPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Respostas)end},
}

local quiz2 = {
	[1] = {p = "Is the number prime?", r =
		function(player)
			local stg = getPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Respostas)
			if stg < 1 then
				return 0
			end
			if stg == 1 or stg == 2 then
				return 1
			end
			local incr = 0
			for i = 1, stg do
				if(stg % i == 0)then
					incr = incr + 1
				end
			end
			return (incr == 2 and 1 or 0)
		end
	},
	[2] = {p = "Does the number belong to a prime twing?", r =
		function(player)
			local stg = getPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Respostas)
			if stg < 2 then
				return 0
			end
			if stg == 1 or stg == 2 then
				return 1
			end
			local incr = 0
			for i = 1, stg do
				if(stg % i == 0)then
					incr = incr + 1
				end
			end
			return (incr == 2 and 1 or 0)
		end
	},
	-- [2] = {p = "", r = ""},
}

local quiz3 = {
	[1] = {p = "Is the number divisible by 3?", r = function(player)return (getPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Respostas) % 3 == 0 and 1 or 0)end},
	[2] = {p = "Is the number divisible by 2?", r = function(player)return (getPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Respostas) % 2 == 0 and 1 or 0)end},
}


local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	talkState[talkUser] = playerTopic[cid]
	
	-- Começou a quest
	if msgcontains(msg, "questions") and talkState[talkUser] == 1 then
		selfSay("Ready to {start}?", cid)
		talkState[talkUser] = 2
		playerTopic[cid] = 2
	elseif msgcontains(msg, "start") and talkState[talkUser] == 2 then
		local perguntaid = math.random(#quiz1)
		setPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Perguntaid, perguntaid)
		selfSay(quiz1[perguntaid].p, cid)
		talkState[talkUser] = 3
		playerTopic[cid] = 3
	elseif (talkState[talkUser] == 3) then
		selfSay(string.format("Your answer is %s, do you want to continue?", msg), cid)
		playerLastResp[cid] = tonumber(msg)
		talkState[talkUser] = 4
		playerTopic[cid] = 4
	elseif (talkState[talkUser] == 4) then
		if msgcontains(msg, "yes") then
			local resposta = quiz1[getPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Perguntaid)].r
			if playerLastResp[cid] ~= (tonumber(resposta(player))) then
				selfSay("Wrong. SHUT DOWN.", cid)
				npcHandler:resetNpc(cid)
				npcHandler:releaseFocus(cid)
				return false
			else
				selfSay("Correct. {Next} question?", cid)
				talkState[talkUser] = 5
				playerTopic[cid] = 5
			end
		elseif msgcontains(msg, "no") then
			selfSay("SHUT DOWN.", cid)
			npcHandler:resetNpc(cid)
			npcHandler:releaseFocus(cid)
			return false
		end
	elseif msgcontains(msg, "next") and talkState[talkUser] == 5 then
		local perguntaid = math.random(#quiz2)
		setPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Perguntaid, perguntaid)
		selfSay(quiz2[perguntaid].p, cid)
		talkState[talkUser] = 6
		playerTopic[cid] = 6
	elseif talkState[talkUser] == 6 then
		local resp = 0
		if msgcontains(msg, "no") then
			resp = 0
		elseif msgcontains(msg, "yes") then
			resp = 1
		end
		local resposta = quiz2[getPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Perguntaid)].r
		if resp == resposta(player) then
			selfSay("Correct. {Next} question?", cid)
			talkState[talkUser] = 7
			playerTopic[cid] = 7
		else
			selfSay("Wrong. SHUT DOWN.", cid)
			npcHandler:resetNpc(cid)
			npcHandler:releaseFocus(cid)
			return false
		end
	elseif talkState[talkUser] == 7 and msgcontains(msg, "next") then
		local perguntaid = math.random(#quiz3)
		setPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Perguntaid, perguntaid)
		selfSay(quiz3[perguntaid].p, cid)
		talkState[talkUser] = 8
		playerTopic[cid] = 8
	elseif talkState[talkUser] == 8 then
		local resp = 0
		if msgcontains(msg, "no") then
			resp = 0
		elseif msgcontains(msg, "yes") then
			resp = 1
		end
		local resposta = quiz3[getPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Perguntaid)].r
		if resp == resposta(player) then
			selfSay("Correct. {Last} question?", cid)
			talkState[talkUser] = 9
			playerTopic[cid] = 9
		else
			selfSay("Wrong. SHUT DOWN.", cid)
			npcHandler:resetNpc(cid)
			npcHandler:releaseFocus(cid)
			return false
		end
	elseif talkState[talkUser] == 9 and msgcontains(msg, "last") then
		selfSay("Tell me the correct number?", cid)
		talkState[talkUser] = 10
		playerTopic[cid] = 10
	elseif talkState[talkUser] == 10 then
		selfSay(string.format("Your answer is %s, do you want to continue?", msg), cid)
		playerLastResp[cid] = tonumber(msg)
		talkState[talkUser] = 11
		playerTopic[cid] = 11
	elseif talkState[talkUser] == 11 then
		if msgcontains(msg, "yes") then
			local correct = string.format("%d%d%d", getPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Pedra1), getPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Pedra2), getPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Pedra3))
			if tonumber(playerLastResp[cid]) ~= (tonumber(correct)) then
				selfSay("Wrong. SHUT DOWN.", cid)
				npcHandler:resetNpc(cid)
				npcHandler:releaseFocus(cid)
				return false
			else
				selfSay("Correct. The lower door is now open. The druid of Crunor lies.", cid)
				setPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Mission, getPlayerStorageValue(cid, Storage.CultsOfTibia.MotA.Mission) + 1)
			end
		elseif msgcontains(msg, "no") then
			selfSay("SHUT DOWN.", cid)
			npcHandler:resetNpc(cid)
			npcHandler:releaseFocus(cid)
			return false
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
