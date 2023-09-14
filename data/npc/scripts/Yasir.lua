local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
	return false
	end

	if msg:lower() == "name" then
		return selfSay("Me Yasir.", cid)
	elseif msg:lower() == "job" then
		return selfSay("Tje hari ku ne finjala. {Ariki}?", cid)
	elseif msg:lower() == "passage" then
		return selfSay("Soso yana. <shakes his head>", cid)
	end
	return true
end

npcHandler:setMessage(MESSAGE_FAREWELL, "Si, jema ze harun. <waves>")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
