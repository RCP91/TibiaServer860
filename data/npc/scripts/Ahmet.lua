local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	
	if msgcontains(msg, 'documents') then
		if getPlayerStorageValue(cid, Storage.thievesGuild.Mission04) == 2 then
			setPlayerStorageValue(cid, Storage.thievesGuild.Mission04, 3)
			selfSay({
				'You need some forged documents? But I will only forge something for a friend. ...',
				'The nomads at the northern oasis killed someone dear to me. Go and kill at least one of them, then we talk about your document.'
			}, cid)
		elseif getPlayerStorageValue(cid, Storage.thievesGuild.Mission04) == 4 then
			selfSay('The slayer of my enemies is my friend! For a mere 1000 gold I will create the documents you need. Are you interested?', cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, 'mission') or msgcontains(msg, 'quest') then
		if getPlayerStorageValue(cid, Storage.QuestChests.StealFromThieves) < 1 then
			selfSay({
				"What are you talking about?? I was robbed!!!! Someone catch those filthy thieves!!!!! GUARDS! ...",
				"<nothing happens>....<SIGH> Like usual, they hide at the slightest sign of trouble! YOU! Want to earn some quick money?"
			}, cid)
			talkState[talkUser] = 2
		elseif getPlayerStorageValue(cid, Storage.QuestChests.StealFromThieves) == 1 or getPlayerStorageValue(cid, Storage.QuestChests.StealFromThieves) == 2 then
			selfSay('Did you find my stuff?', cid)
			talkState[talkUser] = 3
		end
	elseif msgcontains(msg, 'yes') then
		if talkState[talkUser] == 1 then
			if doPlayerRemoveMoney(cid, 1000) then
				doPlayerAddItem(cid, 8694, 1)
				setPlayerStorageValue(cid, Storage.thievesGuild.Mission04, 5)
				selfSay('And here they are! Now forget where you got them from.', cid)
			else
				selfSay('You don\'t have enough money.', cid)
			end
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 2 then
			selfSay({
				"Of course you do! Go hunt down the thieves and bring back the stuff they have stolen from me. ...",
				" I saw them running out of town and then to the north. Maybe they hide at the oasis."
			}, cid)
			talkState[talkUser] = 0
			setPlayerStorageValue(cid, Storage.QuestChests.StealFromThieves, 1)
		elseif talkState[talkUser] == 3 then
			if doPlayerRemoveItem(cid, 7587, 1) then
				selfSay('GREAT! If you ever need a job as my personal security guard, let me know. Here is the reward I promised you.', cid)
				setPlayerStorageValue(cid, Storage.QuestChests.StealFromThieves, 3)
				doPlayerAddItem(cid, 2148, 100)
				doPlayerAddItem(cid, 2789, 100)
				talkState[talkUser] = 0
			else
				selfSay('Come back when you find my stuff.', cid)
				talkState[talkUser] = 0
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
