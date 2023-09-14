local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = { {text = 'Quality armors for sale!'} }
--npcHandler:addModule(VoiceModule:new(voices))

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I run this armoury. If you want to protect your life, you better buy my wares."})

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	if isInArray({"addon", "armor"}, msg) then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.WarriorShoulderAddon) == 5 then
			setPlayerStorageValue(cid, Storage.OutfitQuest.WarriorShoulderAddon, 6)
			setPlayerStorageValue(cid, Storage.OutfitQuest.WarriorShoulderTimer, os.time() + (player:getSex() == PLAYERSEX_FEMALE and 3600 or 7200))
			selfSay('Ah, you must be the hero Trisha talked about. I\'ll prepare the shoulder spikes for you. Please give me some time to finish.', cid)
		elseif getPlayerStorageValue(cid, Storage.OutfitQuest.WarriorShoulderAddon) == 6 then
			if getPlayerStorageValue(cid, Storage.OutfitQuest.WarriorShoulderTimer) > os.time() then
				selfSay('I\'m not done yet. Please be as patient as you are courageous.', cid)
			elseif getPlayerStorageValue(cid, Storage.OutfitQuest.WarriorShoulderTimer) > 0 and getPlayerStorageValue(cid, Storage.OutfitQuest.WarriorShoulderTimer) < os.time() then
				doPlayerAddOutfit(cid, 142, 1)
				doPlayerAddOutfit(cid, 134, 1)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				setPlayerStorageValue(cid, Storage.OutfitQuest.WarriorShoulderAddon, 7)
				--player:addAchievementProgress('Wild Warrior', 2)
				selfSay('Finished! Since you are a man, I thought you probably wanted two. Men always want that little extra status symbol. <giggles>', cid)
			else
				selfSay('I\'m selling leather armor, chain armor, and brass armor. Ask me for a {trade} if you like to take a look.', cid)
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Welcome to the finest {armor} shop in the land, |PLAYERNAME|!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye. Come back soon.")
npcHandler:addModule(FocusModule:new())
