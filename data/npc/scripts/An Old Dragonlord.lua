local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(creature, type, msg)
	if not (msgcontains(msg, 'hi') or msgcontains(msg, 'hello')) then
		selfSay('LEAVE THE DRAGONS\' CEMETERY AT ONCE!', creature.uid)
	end
	npcHandler:onCreatureSay(creature, type, msg)
end
function onThink()				npcHandler:onThink()					end

local voices = { {text = 'AHHHH THE PAIN OF AGESSS! THE PAIN!'} }
--npcHandler:addModule(VoiceModule:new(voices))

local function greetCallback(cid)
	
	if getPlayerStorageValue(cid, Storage.Dragonfetish) == 1 then
		selfSay('LEAVE THE DRAGONS\' CEMETERY AT ONCE!', cid)
		return false
	end

	if not doPlayerRemoveItem(cid, 2787, 1) then
		selfSay('AHHHH THE PAIN OF AGESSS! I NEED MUSSSSHRROOOMSSS TO EASSSE MY PAIN! BRRRING ME MUSHRRROOOMSSS!', cid)
		return false
	end

	setPlayerStorageValue(cid, Storage.Dragonfetish, 1)
	doPlayerAddItem(cid, 2319, 1)
	selfSay('AHHH MUSHRRROOOMSSS! NOW MY PAIN WILL BE EASSSED FOR A WHILE! TAKE THISS AND LEAVE THE DRAGONSSS\' CEMETERY AT ONCE!', cid)
	return false
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:addModule(FocusModule:new())
