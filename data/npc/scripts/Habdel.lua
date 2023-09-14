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
		if player:getSex() == PLAYERSEX_FEMALE then
			selfSay('My scimitar? Well, mylady, I do not want to sound rude, but I don\'t think a scimitar would fit to your beautiful outfit. If you are looking for an accessory, why don\'t you talk to Ishina?', cid)
			return true
		end
		if getPlayerStorageValue(cid, Storage.OutfitQuest.firstOrientalAddon) < 1 then
			selfSay('My scimitar? Yes, that is a true masterpiece. Of course I could make one for you, but I have a small request. Would you fulfil a task for me?', cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, 'comb') then			
		if player:getSex() == PLAYERSEX_FEMALE then
			selfSay('Comb? This is a weapon shop.', cid)
			return true
		end		
		if getPlayerStorageValue(cid, Storage.OutfitQuest.firstOrientalAddon) == 1 then
			selfSay('Have you brought a mermaid\'s comb for Ishina?', cid)
			talkState[talkUser] = 3
		end
	elseif msgcontains(msg, 'yes') then
		if talkState[talkUser] == 1 then
			selfSay({
				'Listen, um... I know that Ishina has been wanting a comb for a long time... not just any comb, but a mermaid\'s comb. She said it prevents split ends... or something. ...',
				'Do you think you could get one for me so I can give it to her? I really would appreciate it. {yes/no}'
			}, cid)
			talkState[talkUser] = 2
		elseif talkState[talkUser] == 2 then
			setPlayerStorageValue(cid, Storage.OutfitQuest.DefaultStart, 1)
			setPlayerStorageValue(cid, Storage.OutfitQuest.firstOrientalAddon, 1)
			selfSay('Brilliant! I will wait for you to return with a mermaid\'s comb then.', cid)
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
			selfSay('Yeah! That\'s it! I can\'t wait to give it to her! Oh - but first, I\'ll fulfil my promise: Here is your scimitar! Thanks again!', cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, 'no') and talkState[talkUser] ~= 0 then
		selfSay('Ah well. Doesn\'t matter.', cid)
		talkState[talkUser] = 0
	end
	return true
end

keywordHandler:addKeyword({'weapons'}, StdModule.say, {npcHandler = npcHandler, text = 'I sell the finest weapons in town. If you\'d like to see my offers, ask me for a {trade}.'})

npcHandler:setMessage(MESSAGE_GREET, 'Welcome |PLAYERNAME|! See the fine {weapons} I sell.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye. Come back soon.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Good bye. Come back soon.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
