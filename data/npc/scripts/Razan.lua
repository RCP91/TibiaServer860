local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local message = {}

local config = {
	['ape fur'] = {
		itemId = 5883,
		count = 100,
		storageValue = 1,
		text = {
			'Have you really managed to fulfil the task and brought me 100 pieces of ape fur?',
			'Only ape fur is good enough to touch the feet of our Caliph.',
			'Ahhh, this softness! I\'m impressed, |PLAYERNAME|. You\'re on the best way to earn that turban. Now, please retrieve 100 fish fins.'
		}
	},
	['fish fins'] = {
		itemId = 5895,
		count = 100,
		storageValue = 2,
		text = {
			'Were you able to discover the undersea race and retrieved 100 fish fins?',
			'I really wonder what the explorer society is up to. Actually I have no idea how they managed to dive unterwater.',
			'I never thought you\'d make it, |PLAYERNAME|. Now we only need two enchanted chicken wings to start our waterwalking test!'
		}
	},
	['enchanted chicken wings'] = {
		itemId = 5891,
		count = 2,
		storageValue = 3,
		text = {
			'Were you able to get hold of two enchanted chicken wings?',
			'Enchanted chicken wings are actually used to make boots of haste, so they could be magically extracted again. Djinns are said to be good at that.',
			'Great, thank you very much. Just bring me 100 pieces of blue cloth now and I will happily show you how to make a turban.'
		}
	},
	['blue cloth'] = {
		itemId = 5912,
		count = 100,
		storageValue = 4,
		text = {
			'Ah, have you brought the 100 pieces of blue cloth?',
			'It\'s a great material for turbans.',
			'Ah! Congratulations - even if you are not a true weaponmaster, you surely deserve to wear this turban. Here, I\'ll tie it for you.'
		}
	}
}

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	

	if msgcontains(msg, 'outfit') then
		selfSay(player:getSex() == PLAYERSEX_FEMALE and 'My turban? I know something better for a pretty girl like you. Why don\'t you go talk to Miraia?' or 'My turban? Eh no, you can\'t have it. Only oriental weaponmasters may wear it after having completed a difficult task.', cid)
	elseif msgcontains(msg, 'task') then
		if player:getSex() == PLAYERSEX_FEMALE then
			selfSay('I really don\'t want to make girls work for me. If you are looking for a job, ask Miraia.', cid)
			return true
		end

		if getPlayerStorageValue(cid, Storage.OutfitQuest.secondOrientalAddon) < 1 then
			selfSay('You mean, you would like to prove that you deserve to wear such a turban?', cid)
			talkState[talkUser] = 1
		end
	elseif config[msg] and talkState[talkUser] == 0 then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.secondOrientalAddon) == config[msg].storageValue then
			selfSay(config[msg].text[1], cid)
			talkState[talkUser] = 3
			message[cid] = msg
		else
			selfSay(config[msg].text[2], cid)
		end
	elseif msgcontains(msg, 'yes') then
		if talkState[talkUser] == 1 then
			selfSay({
				'Alright, then listen to the following requirements. We are currently in dire need of ape fur since the Caliph has requested a new bathroom carpet. ...',
				'Thus, please bring me 100 pieces of ape fur. Secondly, it came to our ears that the explorer society has discovered a new undersea race of fishmen. ...',
				'Their fins are said to allow humans to walk on water! Please bring us 100 of these fish fin. ...',
				'Third, if the plan of walking on water should fail, we need enchanted chicken wings to prevent the testers from drowning. Please bring me two. ...',
				'Last but not least, just drop by with 100 pieces of blue cloth and I will happily show you how to make a turban. ...',
				'Did you understand everything I told you and are willing to handle this task?'
			}, cid)
			talkState[talkUser] = 2
		elseif talkState[talkUser] == 2 then
			if getPlayerStorageValue(cid, Storage.OutfitQuest.DefaultStart) ~= 1 then
				setPlayerStorageValue(cid, Storage.OutfitQuest.DefaultStart, 1)
			end
			setPlayerStorageValue(cid, Storage.OutfitQuest.secondOrientalAddon, 1)
			selfSay('Excellent! Come back to me once you have collected 100 pieces of ape fur.', cid)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 3 then
			local targetMessage = config[message[cid]]
			if not doPlayerRemoveItem(cid, targetMessage.itemId, targetMessage.count) then
				selfSay('That is a shameless lie.', cid)
				talkState[talkUser] = 0
				return true
			end

			setPlayerStorageValue(cid, Storage.OutfitQuest.secondOrientalAddon, getPlayerStorageValue(cid, Storage.OutfitQuest.secondOrientalAddon) + 1)
			if getPlayerStorageValue(cid, Storage.OutfitQuest.secondOrientalAddon) == 5 then
				doPlayerAddOutfit(cid, 146, 2)
				doPlayerAddOutfit(cid, 150, 2)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			end
			selfSay(targetMessage.text[3], cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, 'no') and talkState[talkUser] ~= 0 then
		selfSay('What a pity.', cid)
		talkState[talkUser] = 0
	end

	return true
end

local function onReleaseFocus(cid)
	message[cid] = nil
end

npcHandler:setMessage(MESSAGE_GREET, 'Greetings |PLAYERNAME|. What leads you to me?')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Daraman\'s blessings.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)
npcHandler:addModule(FocusModule:new())

keywordHandler:addSpellKeyword({'berserk'}, {npcHandler = npcHandler, spellName = 'Berserk', price = 2500, level = 35, vocation ={4}})
keywordHandler:addSpellKeyword({'cancel','invisibility'}, {npcHandler = npcHandler, spellName = 'Cancel Invisibility', price = 1600, level = 26, vocation ={3}})
keywordHandler:addSpellKeyword({'charge'}, {npcHandler = npcHandler, spellName = 'Charge', price = 1300, level = 25, vocation ={4}})
keywordHandler:addSpellKeyword({'conjure','arrow'}, {npcHandler = npcHandler, spellName = 'Conjure Arrow', price = 450, level = 13, vocation ={3}})
keywordHandler:addSpellKeyword({'conjure','bolt'}, {npcHandler = npcHandler, spellName = 'Conjure Bolt', price = 750, level = 17, vocation ={3}})
keywordHandler:addSpellKeyword({'conjure','explosive','arrow'}, {npcHandler = npcHandler, spellName = 'Conjure Explosive Arrow', price = 1000, level = 25, vocation ={3}})
keywordHandler:addSpellKeyword({'conjure','piercing','bolt'}, {npcHandler = npcHandler, spellName = 'Conjure Piercing Bolt', price = 850, level = 33, vocation ={3}})
keywordHandler:addSpellKeyword({'conjure','poisoned','arrow'}, {npcHandler = npcHandler, spellName = 'Conjure Poisoned Arrow', price = 700, level = 16, vocation ={3}})
keywordHandler:addSpellKeyword({'conjure','sniper','arrow'}, {npcHandler = npcHandler, spellName = 'Conjure Sniper Arrow', price = 800, level = 24, vocation ={3}})
keywordHandler:addSpellKeyword({'cure','poison'}, {npcHandler = npcHandler, spellName = 'Cure Poison', price = 150, level = 10, vocation ={3,4}})
keywordHandler:addSpellKeyword({'destroy','field'}, {npcHandler = npcHandler, spellName = 'Destroy Field', price = 700, level = 17, vocation ={3}})
keywordHandler:addSpellKeyword({'disintegrate'}, {npcHandler = npcHandler, spellName = 'Disintegrate', price = 900, level = 21, vocation ={3}})
keywordHandler:addSpellKeyword({'divine','caldera'}, {npcHandler = npcHandler, spellName = 'Divine Caldera', price = 3000, level = 50, vocation ={3}})
keywordHandler:addSpellKeyword({'divine','healing'}, {npcHandler = npcHandler, spellName = 'Divine Healing', price = 3000, level = 35, vocation ={3}})
keywordHandler:addSpellKeyword({'divine','missile'}, {npcHandler = npcHandler, spellName = 'Divine Missile', price = 1800, level = 40, vocation ={3}})
keywordHandler:addSpellKeyword({'enchant','spear'}, {npcHandler = npcHandler, spellName = 'Enchant Spear', price = 2000, level = 45, vocation ={3}})
keywordHandler:addSpellKeyword({'ethereal','spear'}, {npcHandler = npcHandler, spellName = 'Ethereal Spear', price = 1100, level = 23, vocation ={3}})
keywordHandler:addSpellKeyword({'fierce','berserk'}, {npcHandler = npcHandler, spellName = 'Fierce Berserk', price = 7500, level = 90, vocation ={4}})
keywordHandler:addSpellKeyword({'find','person'}, {npcHandler = npcHandler, spellName = 'Find Person', price = 80, level = 8, vocation ={3,4}})
keywordHandler:addSpellKeyword({'great','light'}, {npcHandler = npcHandler, spellName = 'Great Light', price = 500, level = 13, vocation ={3,4}})
keywordHandler:addSpellKeyword({'groundshaker'}, {npcHandler = npcHandler, spellName = 'Groundshaker', price = 1500, level = 33, vocation ={4}})
keywordHandler:addSpellKeyword({'haste'}, {npcHandler = npcHandler, spellName = 'Haste', price = 600, level = 14, vocation ={3,4}})
keywordHandler:addSpellKeyword({'holy','missile'}, {npcHandler = npcHandler, spellName = 'Holy Missile', price = 1600, level = 27, vocation ={3}})
keywordHandler:addSpellKeyword({'intense','healing'}, {npcHandler = npcHandler, spellName = 'Intense Healing', price = 350, level = 20, vocation ={3}})
keywordHandler:addSpellKeyword({'levitate'}, {npcHandler = npcHandler, spellName = 'Levitate', price = 500, level = 12, vocation ={3,4}})
keywordHandler:addSpellKeyword({'light'}, {npcHandler = npcHandler, spellName = 'Light', price = 0, level = 8, vocation ={3,4}})
keywordHandler:addSpellKeyword({'light','healing'}, {npcHandler = npcHandler, spellName = 'Light Healing', price = 0, level = 8, vocation ={3}})
keywordHandler:addSpellKeyword({'magic','rope'}, {npcHandler = npcHandler, spellName = 'Magic Rope', price = 200, level = 9, vocation ={3,4}})
keywordHandler:addSpellKeyword({'summon','emberwing'}, {npcHandler = npcHandler, spellName = 'Summon Emberwing', price = 50000, level = 200, vocation ={3}})
keywordHandler:addSpellKeyword({'summon','skullfrost'}, {npcHandler = npcHandler, spellName = 'Summon Skullfrost', price = 50000, level = 200, vocation ={4}})
keywordHandler:addSpellKeyword({'whirlwind','throw'}, {npcHandler = npcHandler, spellName = 'Whirlwind Throw', price = 1500, level = 28, vocation ={4}})
keywordHandler:addKeyword({'attack', 'spells'}, StdModule.say, {npcHandler = npcHandler, text = "In this category I have '{Berserk}', '{Divine Caldera}', '{Divine Missile}', '{Ethereal Spear}', '{Fierce Berserk}', '{Groundshaker}' and '{Whirlwind Throw}'."})
keywordHandler:addKeyword({'healing', 'spells'}, StdModule.say, {npcHandler = npcHandler, text = "In this category I have '{Cure Poison}', '{Divine Healing}', '{Intense Healing}' and '{Light Healing}'."})
keywordHandler:addKeyword({'support', 'spells'}, StdModule.say, {npcHandler = npcHandler, text = "In this category I have '{Cancel Invisibility}', '{Charge}', '{Conjure Arrow}', '{Conjure Bolt}', '{Conjure Explosive Arrow}', '{Conjure Piercing Bolt}', '{Conjure Poisoned Arrow}', '{Conjure Sniper Arrow}', '{Destroy Field}', '{Disintegrate}', '{Enchant Spear}', '{Find Person}', '{Great Light}', '{Haste}', '{Holy Missile}', '{Levitate}', '{Light}', '{Magic Rope}', '{Summon Emberwing}' and '{Summon Skullfrost}'."})
keywordHandler:addKeyword({'spells'}, StdModule.say, {npcHandler = npcHandler, text = 'I can teach you {Attack spells}, {Healing spells} and {Support spells}.'})