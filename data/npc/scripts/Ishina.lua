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

	

	if msgcontains(msg, 'outfit') then
		if player:getSex() == PLAYERSEX_MALE then
			selfSay('My jewelled belt? <giggles> That\'s not very manly. Maybe you\'d prefer a scimitar like Habdel has.', cid)
			return true
		end

		if getPlayerStorageValue(cid, Storage.OutfitQuest.firstOrientalAddon) < 1 then
			selfSay('My jewelled belt? Of course I could make one for you, but I have a small request. Would you fulfil a task for me?', cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, 'comb') then
		if player:getSex() == PLAYERSEX_MALE then
			selfSay('Comb? This is a jewellery shop.', cid)
			return true
		end

		if getPlayerStorageValue(cid, Storage.OutfitQuest.firstOrientalAddon) == 1 then
			selfSay('Have you brought me a mermaid\'s comb?', cid)
			talkState[talkUser] = 3
		end
	elseif msgcontains(msg, 'yes') then
		if talkState[talkUser] == 1 then
			selfSay({
				'Listen, um... I have been wanting a comb for a long time... not just any comb, but a mermaid\'s comb. Having a mermaid\'s comb means never having split ends again! ...',
				'You know what that means to a girl! Could you please bring me such a comb? I really would appreciate it.'
			}, cid)
			talkState[talkUser] = 2
		elseif talkState[talkUser] == 2 then
			setPlayerStorageValue(cid, Storage.OutfitQuest.DefaultStart, 1)
			setPlayerStorageValue(cid, Storage.OutfitQuest.firstOrientalAddon, 1)
			selfSay('Yay! I will wait for you to return with a mermaid\'s comb then.', cid)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 3 then
			if not doPlayerRemoveItem(cid, 5945, 1) then
				selfSay('No... that\'s not it.', cid)
				talkState[talkUser] = 0
				return true
			end

			setPlayerStorageValue(cid, Storage.OutfitQuest.firstOrientalAddon, 2)
			doPlayerAddOutfit(cid, 150, 1)
			doPlayerAddOutfit(cid, 146, 1)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			selfSay('Yeah! That\'s it! I can\'t wait to comb my hair! Oh - but first, I\'ll fulfil my promise: Here is your jewelled belt! Thanks again!', cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, 'no') and talkState[talkUser] ~= 0 then
		selfSay('Oh... okay.', cid)
		talkState[talkUser] = 0
	end

	return true
end

keywordHandler:addKeyword({'need'}, StdModule.say, {npcHandler = npcHandler, text = 'I am a jeweller. Maybe you want to have a look at my wonderful {offers}.'})
keywordHandler:addKeyword({'offers'}, StdModule.say, {npcHandler = npcHandler, text = 'Well, I sell gems and {goblets}. If you\'d like to see my offers, ask me for a {trade}.'})
keywordHandler:addKeyword({'goblets'}, StdModule.say, {npcHandler = npcHandler, text = 'Ah, our newest import! We have golden goblets, silver goblets and bronze goblets. All of them have space for a hand-written dedication.'})

npcHandler:setMessage(MESSAGE_GREET, 'Be greeted, |PLAYERNAME|. Which of my fine gems do you {need}?')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Daraman\'s blessings and good bye.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Daraman\'s blessings and good bye.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
