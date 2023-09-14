local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)	npcHandler:onCreatureSay(cid, type, msg)	end
function onThink()						npcHandler:onThink()						end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	local storage = Storage.OutfitQuest.PirateSabreAddon

	if isInArray({"outfit", "addon"}, msg) and getPlayerStorageValue(cid, Storage.OutfitQuest.PirateBaseOutfit) == 1 then
		selfSay("You're talking about my sabre? Well, even though you earned our trust, you'd have to fulfill a task first before you are granted to wear such a sabre.", cid)
	elseif msgcontains(msg, "task") then
		if getPlayerStorageValue(cid, storage) < 1 then
			selfSay("Are you up to the task which I'm going to give you and willing to prove you're worthy of wearing such a sabre?", cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, "eye patches") then
		if getPlayerStorageValue(cid, storage) == 1 then
			selfSay("Have you gathered 100 eye patches?", cid)
			talkState[talkUser] = 3
		end
	elseif msgcontains(msg, "peg legs") then
		if getPlayerStorageValue(cid, storage) == 2 then
			selfSay("Have you gathered 100 peg legs?", cid)
			talkState[talkUser] = 4
		end
	elseif msgcontains(msg, "hooks") then
		if getPlayerStorageValue(cid, storage) == 3 then
			selfSay("Have you gathered 100 hooks?", cid)
			talkState[talkUser] = 5
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			selfSay({
				"Listen, the task is not that hard. Simply prove that you are with us and not with the pirates from Nargor by bringingme some of their belongings. ...",
				"Bring me 100 of their eye patches, 100 of their peg legs and 100 of their hooks, in that order. ...",
				"Have you understood everything I told you and are willing to handle this task?"
			}, cid)
			talkState[talkUser] = 2
		elseif talkState[talkUser] == 2 then
			setPlayerStorageValue(cid, storage, 1)
			setPlayerStorageValue(cid, Storage.OutfitQuest.DefaultStart, 1) --this for default start of Outfit and Addon Quests
			selfSay("Good! Come back to me once you have gathered 100 eye patches.", cid)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 3 then
			if doPlayerRemoveItem(cid, 6098, 100) then
				setPlayerStorageValue(cid, storage, 2)
				selfSay("Good job. Alright, now bring me 100 peg legs.", cid)
				talkState[talkUser] = 0
			else
				selfSay("You don't have it...", cid)
			end
		elseif talkState[talkUser] == 4 then
			if doPlayerRemoveItem(cid, 6126, 100) then
				setPlayerStorageValue(cid, storage, 3)
				selfSay("Nice. Lastly, bring me 100 pirate hooks. That should be enough to earn your sabre.", cid)
				talkState[talkUser] = 0
			else
				selfSay("You don't have it...", cid)
			end
		elseif talkState[talkUser] == 5 then
			if doPlayerRemoveItem(cid, 6097, 100) then
				setPlayerStorageValue(cid, storage, 4)
				selfSay("I see, I see. Well done. Go to Morgan and tell him this codeword: 'firebird'. He'll know what to do.", cid)
				talkState[talkUser] = 0
			else
				selfSay("You don't have it...", cid)
			end
		end
	elseif msgcontains(msg, "no") then
		if talkState[talkUser] >= 1 then
			selfSay("Then no.", cid)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
