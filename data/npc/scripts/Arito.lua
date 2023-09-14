local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	local AritosTask = getPlayerStorageValue(cid, Storage.TibiaTales.AritosTask)
		-- START TASK
	if msgcontains(msg, "nomads") then
		if getPlayerStorageValue(cid, Storage.TibiaTales.AritosTask) <= 0 and getPlayerItemCount(cid, 8267) >= 0 then
			selfSay({
				'What?? My name on a deathlist which you retrieved from a nomad?? Show me!! ...',
				'Oh my god! They found me! You must help me! Please !!!!'
			}, cid)
			if getPlayerStorageValue(cid, Storage.TibiaTales.DefaultStart) <= 0 then
				setPlayerStorageValue(cid, Storage.TibiaTales.DefaultStart, 1)
			end
			setPlayerStorageValue(cid, Storage.TibiaTales.AritosTask, 1)
		-- END TASK
		elseif getPlayerStorageValue(cid, Storage.TibiaTales.AritosTask) == 2 then
			selfSay({
				'These are great news!! Thank you for your help! I don\'t have much, but without you I wouldn\'t have anything so please take this as a reward.'
			}, cid)
			setPlayerStorageValue(cid, Storage.TibiaTales.AritosTask, 3)
			doPlayerAddItem(cid, 2152, 50)
		end
		return true
	end
end

local voices = { {text = 'Come in, have a drink and something to eat.'} }
--npcHandler:addModule(VoiceModule:new(voices))

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Be mourned, pilgrim in flesh. Be mourned in my tavern.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Do visit us again.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Do visit us again.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Sure, browse through my offers.")
npcHandler:addModule(FocusModule:new())
