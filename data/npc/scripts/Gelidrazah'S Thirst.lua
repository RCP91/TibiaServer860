local keywordHandler = KeywordHandler:new()
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
    end

    

    if msgcontains(msg, "yes") then
        if talkState[talkUser] == 0 then
            selfSay({
				"There are three questions. First: What is the name of the princess who fell in love with a Thaian nobleman during the regency of pharaoh Uthemath? Second: Who is the author of the book ,The Language of the Wolves'? ...",
				"Third: Which ancient Tibian race reportedly travelled the sky in cloud ships? Can you answer these {questions}?"
			}, cid)
			talkState[talkUser] = 1
		else
            selfSay('I don\'t know what you are talking about.', cid)
        end
    elseif msgcontains(msg, "questions") and talkState[talkUser] == 1 then
		selfSay("So I ask you: What is the name of the princess who fell in love with a Thaian nobleman during the regency of pharaoh Uthemath?", cid)
		talkState[talkUser] = 2
    elseif msgcontains(msg, "Tahmehe") and talkState[talkUser] == 2 then
        selfSay("That's right. Listen to the second question: Who is the author of the book ,The Language of the Wolves'?", cid)
		talkState[talkUser] = 3
    elseif msgcontains(msg, "Ishara") and talkState[talkUser] == 3 then
        selfSay("That's right. Listen to the third question: Which ancient Tibian race reportedly travelled the sky in cloud ships?", cid)
		talkState[talkUser] = 4
	 elseif msgcontains(msg, "Svir") and talkState[talkUser] == 4 then
        selfSay("That is correct. You satisfactorily answered all questions. You may pass and enter Gelidrazah's lair.", cid)
		talkState[talkUser] = 0
		setPlayerStorageValue(cid, Storage.FirstDragon.GelidrazahAccess, 1)
    end
    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Have you come to answer Gelidrazah's questions?")
npcHandler:setMessage(MESSAGE_FAREWELL, "See you, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "See you, |PLAYERNAME|.")
npcHandler:addModule(FocusModule:new())
