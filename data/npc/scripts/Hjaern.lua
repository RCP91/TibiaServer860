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

	

	if msgcontains(msg, "mission") then
		if getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 3 then
			if getPlayerStorageValue(cid, Storage.TheIceIslands.Mission02) < 1 then
			selfSay({
				"We could indeed need some help. These are very cold times. The ice is growing and becoming thicker everywhere ...",
				"The problem is that the chakoyas may use the ice for a passage to the west and attack Svargrond ...",
				"We need you to get a pick and to destroy the ice at certain places to the east. You will quickly recognise those spots by their unstable look ...",
				"Use the pickaxe on at least three of these places and the chakoyas probably won't be able to pass the ice. Once you are done, return here and report about your mission."
			}, cid)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Mission02, 1) -- Questlog The Ice Islands Quest, Nibelor 1: Breaking the Ice
			talkState[talkUser] = 0
			end
		elseif getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 4 then
			selfSay("The spirits are at peace now. The threat of the chakoyas is averted for now. I thank you for your help. Perhaps you should ask Silfind if you can help her in some matters. ", cid)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 5)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Mission02, 5) -- Questlog The Ice Islands Quest, Nibelor 1: Breaking the Ice
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 29 then
			selfSay({
				"There is indeed an important mission. For a long time, the spirits have been worried and have called us for help. It seems that some of our dead have not reached the happy hunting grounds of after life ...",
				"Everything we were able to find out leads to a place where none of our people is allowed to go. Just like we would never allow a stranger to go to that place ...",
				"But you, you are different. You are not one of our people, yet you have proven worthy to be one us. You are special, the child of two worlds ...",
				"We will grant you permission to travel to that isle of Helheim. Our legends say that this is the entrance to the dark world. The dark world is the place where the evil and lost souls roam in eternal torment ...",
				"There you find for sure the cause for the unrest of the spirits. Find someone in Svargrond who can give you a passage to Helheim and seek for the cause. Are you willing to do that?"
			}, cid)
			talkState[talkUser] = 1
		elseif getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 31 then
			selfSay({
				"There is no need to report about your mission. To be honest, Ive sent a divination spirit with you as well as a couple of destruction spirits that were unleashed when you approached the altar ...",
				"Forgive me my secrecy but you are not familiar with the spirits and you might have get frightened. The spirits are at work now, destroying the magic with that those evil creatures have polluted Helheim ...",
				"I cant thank you enough for what you have done for the spirits of my people. Still I have to ask: Would you do us another favour?"
			}, cid)
			talkState[talkUser] = 2
		elseif getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 38 then
			selfSay({
				"These are alarming news and we have to act immediately. Take this spirit charm of cold. Travel to the mines and find four special obelisks to mark them with the charm ...",
				"I can feel their resonance in the spirits world but we cant reach them with our magic yet. They have to get into contact with us in a spiritual way first ...",
				"This will help us to concentrate all our frost magic on this place. I am sure this will prevent to melt any significant number of demons from the ice ...",
				"Report about your mission when you are done. Then we can begin with the great ritual of summoning the children of Chyll ...",
				"I will also inform Lurik about the events. Now go, fast!"
			}, cid)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 39)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Mission11, 2) -- Questlog The Ice Islands Quest, Formorgar Mines 3: The Secret
			setPlayerStorageValue(cid, Storage.TheIceIslands.Mission12, 1) -- Questlog The Ice Islands Quest, Formorgar Mines 4: Retaliation
			doPlayerAddItem(cid, 7289, 1)
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 39
				and getPlayerStorageValue(cid, Storage.TheIceIslands.Obelisk01) == 5
				and getPlayerStorageValue(cid, Storage.TheIceIslands.Obelisk02) == 5
				and getPlayerStorageValue(cid, Storage.TheIceIslands.Obelisk03) == 5
				and getPlayerStorageValue(cid, Storage.TheIceIslands.Obelisk04) == 5 then
			if doPlayerRemoveItem(cid, 7289, 1) then
				setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 40)
				setPlayerStorageValue(cid, Storage.TheIceIslands.yakchalDoor, 1)
				setPlayerStorageValue(cid, Storage.TheIceIslands.Mission12, 6) -- Questlog The Ice Islands Quest, Formorgar Mines 4: Retaliation
				setPlayerStorageValue(cid, Storage.OutfitQuest.NorsemanAddon, 1) -- Questlog Norseman Outfit Quest
				setPlayerStorageValue(cid, Storage.OutfitQuest.DefaultStart, 1) --this for default start of Outfit and Addon Quests
				player:addOutfit(251, 0)
				player:addOutfit(252, 0)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				selfSay({
					"Yes, I can feel it! The spirits are in touch with the obelisks. We will begin to channel a spell of ice on the caves. That will prevent the melting of the ice there ...",
					"If you would like to help us, you can turn in frostheart shards from now on. We use them to fuel our spell with the power of ice. ...",
					"Oh, and before I forget it - since you have done a lot to help us and spent such a long time in this everlasting winter, I have a special present for you. ...",
					"Take this outfit to keep your warm during your travels in this frozen realm!"
				}, cid)
			end
			talkState[talkUser] = 0
		else
		selfSay("I have now no mission for you.", cid)
		talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "shard") then
		if getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 40 then
			selfSay("Do you bring frostheart shards for our spell?", cid)
			talkState[talkUser] = 3
		elseif getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 42 then
			selfSay("Do you bring frostheart shards for our spell? ", cid)
			talkState[talkUser] = 4
		elseif getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 44 then
			selfSay("Do you want to sell all your shards for 2000 gold coins per each? ", cid)
			talkState[talkUser] = 5
		end
	elseif msgcontains(msg, "reward") then
		if getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 41 then
			selfSay("Take this. It might suit your Nordic outfit fine. ", cid)
			doPlayerAddOutfit(cid, 252, 1)
			doPlayerAddOutfit(cid, 251, 1)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 42)
			setPlayerStorageValue(cid, Storage.OutfitQuest.NorsemanAddon, 2) -- Questlog Norseman Outfit Quest
			talkState[talkUser] = 3
		elseif getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 43 then
			doPlayerAddOutfit(cid, 252, 2)
			doPlayerAddOutfit(cid, 251, 2)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			selfSay("Take this. It might suit your Nordic outfit fine. From now on we only can give you 2000 gold pieces for each shard. ", cid)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 44)
			setPlayerStorageValue(cid, Storage.OutfitQuest.NorsemanAddon, 3) -- Questlog Norseman Outfit Quest
			talkState[talkUser] = 4
		end
	elseif msgcontains(msg, "tylaf") then
		if getPlayerStorageValue(cid, Storage.TheIceIslands.Questline) == 36 then
			selfSay({
				"You encountered the restless ghost of my apprentice Tylaf in the old mines? We must find out what has happened to him. I enable you to talk to his spirit ...",
				"Talk to him and then report to me about your mission."
			}, cid)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 37)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Mission10, 1) -- Questlog The Ice Islands Quest, Formorgar Mines 2: Ghostwhisperer
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, 'cookie') then
		if getPlayerStorageValue(cid, Storage.WhatAFoolishQuest.Questline) == 31
				and getPlayerStorageValue(cid, Storage.WhatAFoolishQuest.CookieDelivery.Hjaern) ~= 1 then
			selfSay('You want to sacrifice a cookie to the spirits?', cid)
			talkState[talkUser] = 6
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			selfSay("This is good news. As I explained, travel to Helheim, seek the reason for the unrest there and then report to me about your mission. ", cid)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 30)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Mission07, 2) -- Questlog The Ice Islands Quest, The Secret of Helheim
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 2 then
			selfSay({
				"Thank you my friend. The local representative of the explorers society has asked for our help ...",
				"You know their ways better than my people do and are probably best suited to represent us in this matter.",
				"Search for Lurik and talk to him about aprobable mission he might have for you."
			}, cid)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 32)
			setPlayerStorageValue(cid, Storage.TheIceIslands.Mission08, 1) -- Questlog The Ice Islands Quest, The Contact
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 3 then
			if doPlayerRemoveItem(cid, 7290, 5) then
				selfSay("Excellent, you collected 5 of them. If you have collected 5 or more, talk to me about your {reward}. ", cid)
				setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 41)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 4 then
			if doPlayerRemoveItem(cid, 7290, 10) then
				selfSay("Excellent, you collected 10 of them. If you have collected 15 or more, talk to me about your {reward}. ", cid)
				setPlayerStorageValue(cid, Storage.TheIceIslands.Questline, 43)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 5 then
			if getPlayerItemCount(cid, 7290) > 0 then
				local count = getPlayerItemCount(cid, 7290)
				player:addMoney(count * 2000)
				doPlayerRemoveItem(cid, 7290, count)
				selfSay("Here your are. " .. count * 2000 .. " gold coins for " .. count .. " shards.", cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 6 then
			if not doPlayerRemoveItem(cid, 8111, 1) then
				selfSay('You have no cookie that I\'d like.', cid)
				talkState[talkUser] = 0
				return true
			end

			setPlayerStorageValue(cid, Storage.WhatAFoolishQuest.CookieDelivery.Hjaern, 1)
			if player:getCookiesDelivered() == 10 then
				--player:addAchievement('Allow Cookies?')
			end

			Npc():getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
			selfSay('In the name of the spirits I accept this offer ... UHNGH ... The spirits are not amused!', cid)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		end
	elseif msgcontains(msg, 'no') then
		if talkState[talkUser] == 6 then
			selfSay('I see.', cid)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())


keywordHandler:addSpellKeyword({'animate','dead'}, {npcHandler = npcHandler, spellName = 'Animate Dead', price = 1200, level = 27, vocation ={2}})
keywordHandler:addSpellKeyword({'avalanche'}, {npcHandler = npcHandler, spellName = 'Avalanche', price = 1200, level = 30, vocation ={2}})
keywordHandler:addSpellKeyword({'chameleon'}, {npcHandler = npcHandler, spellName = 'Chameleon', price = 1300, level = 27, vocation ={2}})
keywordHandler:addSpellKeyword({'convince','creature'}, {npcHandler = npcHandler, spellName = 'Convince Creature', price = 800, level = 16, vocation ={2}})
keywordHandler:addSpellKeyword({'creature','illusion'}, {npcHandler = npcHandler, spellName = 'Creature Illusion', price = 1000, level = 23, vocation ={2}})
keywordHandler:addSpellKeyword({'cure','poison'}, {npcHandler = npcHandler, spellName = 'Cure Poison', price = 150, level = 10, vocation ={2}})
keywordHandler:addSpellKeyword({'cure','poison','rune'}, {npcHandler = npcHandler, spellName = 'Cure Poison Rune', price = 600, level = 15, vocation ={2}})
keywordHandler:addSpellKeyword({'destroy','field'}, {npcHandler = npcHandler, spellName = 'Destroy Field', price = 700, level = 17, vocation ={2}})
keywordHandler:addSpellKeyword({'disintegrate'}, {npcHandler = npcHandler, spellName = 'Disintegrate', price = 900, level = 21, vocation ={2}})
keywordHandler:addSpellKeyword({'energy','field'}, {npcHandler = npcHandler, spellName = 'Energy Field', price = 700, level = 18, vocation ={2}})
keywordHandler:addSpellKeyword({'energy','strike'}, {npcHandler = npcHandler, spellName = 'Energy Strike', price = 800, level = 12, vocation ={2}})
keywordHandler:addSpellKeyword({'energy','wall'}, {npcHandler = npcHandler, spellName = 'Energy Wall', price = 2500, level = 41, vocation ={2}})
keywordHandler:addSpellKeyword({'explosion'}, {npcHandler = npcHandler, spellName = 'Explosion', price = 1800, level = 31, vocation ={2}})
keywordHandler:addSpellKeyword({'find','person'}, {npcHandler = npcHandler, spellName = 'Find Person', price = 80, level = 8, vocation ={2}})
keywordHandler:addSpellKeyword({'fire','bomb'}, {npcHandler = npcHandler, spellName = 'Fire Bomb', price = 1500, level = 27, vocation ={2}})
keywordHandler:addSpellKeyword({'fire','field'}, {npcHandler = npcHandler, spellName = 'Fire Field', price = 500, level = 15, vocation ={2}})
keywordHandler:addSpellKeyword({'fire','wall'}, {npcHandler = npcHandler, spellName = 'Fire Wall', price = 2000, level = 33, vocation ={2}})
keywordHandler:addSpellKeyword({'flame','strike'}, {npcHandler = npcHandler, spellName = 'Flame Strike', price = 800, level = 14, vocation ={2}})
keywordHandler:addSpellKeyword({'food'}, {npcHandler = npcHandler, spellName = 'Food', price = 300, level = 14, vocation ={2}})
keywordHandler:addSpellKeyword({'great','light'}, {npcHandler = npcHandler, spellName = 'Great Light', price = 500, level = 13, vocation ={2}})
keywordHandler:addSpellKeyword({'haste'}, {npcHandler = npcHandler, spellName = 'Haste', price = 600, level = 14, vocation ={2}})
keywordHandler:addSpellKeyword({'heal','friend'}, {npcHandler = npcHandler, spellName = 'Heal Friend', price = 800, level = 18, vocation ={2}})
keywordHandler:addSpellKeyword({'heavy','magic','missile'}, {npcHandler = npcHandler, spellName = 'Heavy Magic Missile', price = 1500, level = 25, vocation ={2}})
keywordHandler:addSpellKeyword({'ice','strike'}, {npcHandler = npcHandler, spellName = 'Ice Strike', price = 800, level = 15, vocation ={2}})
keywordHandler:addSpellKeyword({'ice','wave'}, {npcHandler = npcHandler, spellName = 'Ice Wave', price = 850, level = 18, vocation ={2}})
keywordHandler:addSpellKeyword({'icicle'}, {npcHandler = npcHandler, spellName = 'Icicle', price = 1700, level = 28, vocation ={2}})
keywordHandler:addSpellKeyword({'intense','healing','rune'}, {npcHandler = npcHandler, spellName = 'Intense Healing Rune', price = 600, level = 15, vocation ={2}})
keywordHandler:addSpellKeyword({'invisible'}, {npcHandler = npcHandler, spellName = 'Invisible', price = 2000, level = 35, vocation ={2}})
keywordHandler:addSpellKeyword({'levitate'}, {npcHandler = npcHandler, spellName = 'Levitate', price = 500, level = 12, vocation ={2}})
keywordHandler:addSpellKeyword({'light'}, {npcHandler = npcHandler, spellName = 'Light', price = 0, level = 8, vocation ={2}})
keywordHandler:addSpellKeyword({'light','healing'}, {npcHandler = npcHandler, spellName = 'Light Healing', price = 0, level = 8, vocation ={2}})
keywordHandler:addSpellKeyword({'light','magic','missile'}, {npcHandler = npcHandler, spellName = 'Light Magic Missile', price = 500, level = 15, vocation ={2}})
keywordHandler:addSpellKeyword({'magic','rope'}, {npcHandler = npcHandler, spellName = 'Magic Rope', price = 200, level = 9, vocation ={2}})
keywordHandler:addSpellKeyword({'magic','shield'}, {npcHandler = npcHandler, spellName = 'Magic Shield', price = 450, level = 14, vocation ={2}})
keywordHandler:addSpellKeyword({'mass','healing'}, {npcHandler = npcHandler, spellName = 'Mass Healing', price = 2200, level = 36, vocation ={2}})
keywordHandler:addSpellKeyword({'poison','bomb'}, {npcHandler = npcHandler, spellName = 'Poison Bomb', price = 1000, level = 25, vocation ={2}})
keywordHandler:addSpellKeyword({'poison','field'}, {npcHandler = npcHandler, spellName = 'Poison Field', price = 300, level = 14, vocation ={2}})
keywordHandler:addSpellKeyword({'poison','wall'}, {npcHandler = npcHandler, spellName = 'Poison Wall', price = 1600, level = 29, vocation ={2}})
keywordHandler:addSpellKeyword({'soulfire'}, {npcHandler = npcHandler, spellName = 'Soulfire', price = 1800, level = 27, vocation ={2}})
keywordHandler:addSpellKeyword({'stalagmite'}, {npcHandler = npcHandler, spellName = 'Stalagmite', price = 1400, level = 24, vocation ={2}})
keywordHandler:addSpellKeyword({'stone','shower'}, {npcHandler = npcHandler, spellName = 'Stone Shower', price = 1100, level = 28, vocation ={2}})
keywordHandler:addSpellKeyword({'strong','haste'}, {npcHandler = npcHandler, spellName = 'Strong Haste', price = 1300, level = 20, vocation ={2}})
keywordHandler:addSpellKeyword({'summon','creature'}, {npcHandler = npcHandler, spellName = 'Summon Creature', price = 2000, level = 25, vocation ={2}})
keywordHandler:addSpellKeyword({'summon','grovebeast'}, {npcHandler = npcHandler, spellName = 'Summon Grovebeast', price = 50000, level = 200, vocation ={2}})
keywordHandler:addSpellKeyword({'terra','strike'}, {npcHandler = npcHandler, spellName = 'Terra Strike', price = 800, level = 13, vocation ={2}})
keywordHandler:addSpellKeyword({'terra','wave'}, {npcHandler = npcHandler, spellName = 'Terra Wave', price = 2500, level = 38, vocation ={2}})
keywordHandler:addSpellKeyword({'ultimate','healing'}, {npcHandler = npcHandler, spellName = 'Ultimate Healing', price = 1000, level = 30, vocation ={2}})
keywordHandler:addSpellKeyword({'ultimate','light'}, {npcHandler = npcHandler, spellName = 'Ultimate Light', price = 1600, level = 26, vocation ={2}})
keywordHandler:addKeyword({'attack', 'spells'}, StdModule.say, {npcHandler = npcHandler, text = "In this category I have '{Energy Strike}', '{Flame Strike}', '{Ice Strike}', '{Ice Wave}', '{Terra Strike}' and '{Terra Wave}'."})
keywordHandler:addKeyword({'healing', 'spells'}, StdModule.say, {npcHandler = npcHandler, text = "In this category I have '{Cure Poison}', '{Heal Friend}', '{Light Healing}', '{Mass Healing}' and '{Ultimate Healing}'."})
keywordHandler:addKeyword({'support', 'spells'}, StdModule.say, {npcHandler = npcHandler, text = "In this category I have '{Animate Dead}', '{Avalanche}', '{Chameleon}', '{Convince Creature}', '{Creature Illusion}', '{Cure Poison Rune}', '{Destroy Field}', '{Disintegrate}', '{Energy Field}', '{Energy Wall}', '{Explosion}', '{Find Person}', '{Fire Bomb}', '{Fire Field}', '{Fire Wall}', '{Food}', '{Great Light}', '{Haste}', '{Heavy Magic Missile}', '{Icicle}', '{Intense Healing Rune}', '{Invisible}', '{Levitate}', '{Light}', '{Light Magic Missile}', '{Magic Rope}', '{Magic Shield}', '{Poison Bomb}', '{Poison Field}', '{Poison Wall}', '{Soulfire}', '{Stalagmite}', '{Stone Shower}', '{Strong Haste}', '{Summon Creature}', '{Summon Grovebeast}' and '{Ultimate Light}'."})
keywordHandler:addKeyword({'spells'}, StdModule.say, {npcHandler = npcHandler, text = 'I can teach you {Attack spells}, {Healing spells} and {Support spells}.'})

