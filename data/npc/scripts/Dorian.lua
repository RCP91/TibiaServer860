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

	

	if msgcontains(msg, "mission") then
		if getPlayerStorageValue(cid, Storage.thievesGuild.Quest) == 1 and getPlayerStorageValue(cid, Storage.thievesGuild.Mission01) < 1 then
			setPlayerStorageValue(cid, Storage.thievesGuild.Mission01, 1)
			selfSay({
				'Your first job is quite easy. The Thaian officials are unwilling to share the wealth they\'ve accumulated in their new town Port Hope. ...',
				'They insist that most resources belong to the crown. This is quite sad, especially ivory is in high demand. Collect 10 elephant tusks and bring them to me.'
			}, cid)
		elseif getPlayerStorageValue(cid, Storage.thievesGuild.Mission01) == 1 then
			selfSay('Have you finished your mission?', cid)
			talkState[talkUser] = 2
		elseif getPlayerStorageValue(cid, Storage.thievesGuild.Quest) == 2 and getPlayerStorageValue(cid, Storage.thievesGuild.Mission02) < 1 then
			setPlayerStorageValue(cid, Storage.thievesGuild.Mission02, 1)
			selfSay({
				'A client of our guild would like to get a certain vase. Unfortunately, it\'s not for sale. Well, by the original owner, that is. ...',
				'We, on the other hand, would gladly sell him the vase. Therefore, it would come in handy if we get this vase in our hands. ...',
				'Luckily, the walls of the owner\'s house are covered with vines, that will make a burglary quite easy. ...',
				'You\'ll still need some lock picks to get the chest open in which the vase is stored. Must be your lucky day, as I\'m selling lock picks for a fair price. ...',
				'You might need some of them to get that chest open. The soon to be ex-owner of that vase is Sarina, the proprietor of Carlin\'s general store.'
			}, cid)
		elseif getPlayerStorageValue(cid, Storage.thievesGuild.Mission02) == 2 then
			selfSay('Have you finished your mission?', cid)
			talkState[talkUser] = 3
		elseif getPlayerStorageValue(cid, Storage.thievesGuild.Quest) == 3 and getPlayerStorageValue(cid, Storage.thievesGuild.Mission03) < 1 then
			setPlayerStorageValue(cid, Storage.thievesGuild.Mission03, 1)
			selfSay({
				'Our beloved king will hold a great festivity at the end of the month. Unfortunately he forgot to invite one of our guild\'s representatives. ...',
				'Of course it would be rude to point out this mistake to the king. It will be your job to get us an invitation to the ball. ...',
				'Moreover, It will be a great chance to check the castle for, well, opportunities. I\'m sure you understand. However, it\'s up to that pest Oswald to give out invitations, so he\'s the man you\'re looking for.'
			}, cid)
		elseif getPlayerStorageValue(cid, Storage.thievesGuild.Mission03) == 2 then
			selfSay('Have you finished your mission?', cid)
			talkState[talkUser] = 4
		elseif getPlayerStorageValue(cid, Storage.thievesGuild.Quest) == 4 and getPlayerStorageValue(cid, Storage.thievesGuild.Mission04) < 1 then
			setPlayerStorageValue(cid, Storage.thievesGuild.Mission04, 1)
			selfSay({
				'Your next mission is somewhat bigger and I\'m sure much fun for you. Some new-rich merchant is being a bit more greedy than it\'s good for him. ...',
				'The good thing is he\'s as stupid as greedy, so we have a little but cunning plan. We arranged the boring correspondence in advance, so you\'ll come in when the fun starts. ...',
				'You\'ll disguise yourself as the dwarven ambassador and sell that fool the old dwarven bridge, south of Kazordoon. ...',
				'Well, actually it is a bit more complicated than that. Firstly, you\'ll have to get forged documents. Ask around in the criminal camp to find a forger. ...',
				'Secondly, you\'ll need a disguise. Percybald in Carlin is an eccentric actor that might help you with that. ...',
				'As soon as you got both things, travel to Venore and find the merchant Nurik. Trade the false documents for the famous painting of Mina Losa and bring it to me.'
			}, cid)
		elseif getPlayerStorageValue(cid, Storage.thievesGuild.Mission04) == 7 then
			selfSay('Have you finished your mission?', cid)
			talkState[talkUser] = 5
		elseif getPlayerStorageValue(cid, Storage.thievesGuild.Quest) == 5 and getPlayerStorageValue(cid, Storage.thievesGuild.Mission05) < 1 then
			setPlayerStorageValue(cid, Storage.thievesGuild.Mission05, 1)
			selfSay('Some smugglers underneath Tiquanda, north west of Port Hope owe us some debts. Go there and steal their Golden Goblet and bring it to me.', cid)
		elseif getPlayerStorageValue(cid, Storage.thievesGuild.Mission05) == 1 then
			selfSay('Have you finished your mission?', cid)
			talkState[talkUser] = 6
		elseif getPlayerStorageValue(cid, Storage.thievesGuild.Quest) == 6 and getPlayerStorageValue(cid, Storage.thievesGuild.Mission06) < 1 then
			setPlayerStorageValue(cid, Storage.thievesGuild.Mission06, 1)
			selfSay({
				'Your next job will be kidnapping. You\'ll get us the only creature that this scrupulous trader Theodore Loveless in Liberty Bay holds dear. ...',
				'His little goldfish! To get that fish, you\'ll have to get in his room somehow. ...',
				'As you might know I sell lock picks, but I fear unless you\'re extremely lucky, you won\'t crack this expensive masterpiece of a lock. However, get us that fish, regardless how.'
			}, cid)
		elseif getPlayerStorageValue(cid, Storage.thievesGuild.Mission06) == 3 then
			selfSay('Have you finished your mission?', cid)
			talkState[talkUser] = 7
		elseif getPlayerStorageValue(cid, Storage.thievesGuild.Quest) == 7 and getPlayerStorageValue(cid, Storage.thievesGuild.Mission07) < 1 then
			setPlayerStorageValue(cid, Storage.thievesGuild.Mission07, 1)
			selfSay({
				'We\'d like to ease our lives somewhat. Therefore, we would appreciate the cooperation with one of the Venore city guards. ...',
				'Find some dirt about one of them. It\'s unimportant what it is. As soon as we have a foothold, we\'ll convince him to cooperate. Bring me whatever you may find.'
			}, cid)
		elseif getPlayerStorageValue(cid, Storage.thievesGuild.Mission07) == 1 then
			selfSay('Have you finished your mission?', cid)
			talkState[talkUser] = 8
		elseif getPlayerStorageValue(cid, Storage.thievesGuild.Quest) == 8 and getPlayerStorageValue(cid, Storage.thievesGuild.Mission08) < 1 then
			setPlayerStorageValue(cid, Storage.thievesGuild.Mission08, 1)
			doPlayerAddItem(cid, 8701, 1)
			selfSay({
				'Competition might be an interesting challenge but our guild isn\'t really keen on competition. ...',
				'Unfortunately, we are lacking some good fighters, which is quite a disadvantage against certain other organisations. However, I think you\'re a really good fighter ...',
				'Travel to the Plains of Havoc and find the base of our competitors under the ruins of the dark cathedral ...',
				'On the lowest level, you\'ll find a wall with two trophies. Place a message of our guild on the wall, right between the trophies. On your way, get rid of as many of our competitors as you can.'
			}, cid)
		elseif getPlayerStorageValue(cid, Storage.thievesGuild.Mission08) == 2 then
			selfSay('Have you finished your mission?', cid)
			talkState[talkUser] = 9
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			setPlayerStorageValue(cid, Storage.thievesGuild.Quest, 1)
			selfSay({
				'Excellent. You\'ll learn this trade from scratch. Our operations cover many fields of work. Some aren\'t even illegal. ...',
				'Well, as long as you don\'t get caught at least. Ask me for a mission whenever you\'re ready.'
			}, cid)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 2 then
			if doPlayerRemoveItem(cid, 3956, 10) then
				setPlayerStorageValue(cid, Storage.thievesGuild.Mission01, 2)
				setPlayerStorageValue(cid, Storage.thievesGuild.Quest, 2)
				selfSay('What a fine material. That will be worth a coin or two. So far, so good. Ask me for another mission if you\'re ready for it.', cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 3 then
			if doPlayerRemoveItem(cid, 8760, 1) then
				setPlayerStorageValue(cid, Storage.thievesGuild.Mission02, 3)
				setPlayerStorageValue(cid, Storage.thievesGuild.Quest, 3)
				selfSay('What an ugly vase. But who am I to question the taste of our customers? Anyway, I might have another mission in store for you.', cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 4 then
			if doPlayerRemoveItem(cid, 8761, 1) then
				setPlayerStorageValue(cid, Storage.thievesGuild.Mission03, 3)
				setPlayerStorageValue(cid, Storage.thievesGuild.Quest, 4)
				selfSay({
					'Ah, the key to untold riches. Don\'t worry, we\'ll make sure that no one will connect you to the disappearance of certain royal possessions. ...',
					'You\'re too valuable to us. Speaking about your value, I might have some other mission for you.'
				}, cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 5 then
			if doPlayerRemoveItem(cid, 8699, 1) then
				setPlayerStorageValue(cid, Storage.thievesGuild.Mission04, 8)
				setPlayerStorageValue(cid, Storage.thievesGuild.Quest, 5)
				selfSay('Excellent, that serves this fool right. I fear in your next mission, you\'ll have to get your hands dirty. Just ask me to learn more about it.', cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 6 then
			if doPlayerRemoveItem(cid, 8698, 1) then
				setPlayerStorageValue(cid, Storage.thievesGuild.Mission05, 2)
				setPlayerStorageValue(cid, Storage.thievesGuild.Quest, 6)
				selfSay('That goblet is hardly worth all this trouble but we had to insist on our payment. However, I assume you are eager for more missions, so just ask.', cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 7 then
			if doPlayerRemoveItem(cid, 8764, 1) then
				setPlayerStorageValue(cid, Storage.thievesGuild.Mission06, 4)
				setPlayerStorageValue(cid, Storage.thievesGuild.Quest, 7)
				selfSay('This little goldfish will bring us a hefty ransom! Just ask me if you\'re ready for another mission.', cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 8 then
			if doPlayerRemoveItem(cid, 8763, 1) then
				setPlayerStorageValue(cid, Storage.thievesGuild.Mission07, 2)
				setPlayerStorageValue(cid, Storage.thievesGuild.Quest, 8)
				selfSay({
					'Excellent, that little letter will do the trick for sure ...',
					'I think you\'re really capable and if you finish another mission, I\'ll allow you full access to our black market of lost and found items. Just ask me to learn more about that mission.'
				}, cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 9 then
			setPlayerStorageValue(cid, Storage.thievesGuild.Mission08, 3)
			setPlayerStorageValue(cid, Storage.thievesGuild.Quest, 9)
			setPlayerStorageValue(cid, Storage.thievesGuild.Door, 1)
			selfSay({
				'Once again you\'ve finished your job, and I\'ll keep my promise. From now on, you can trade with old Black Bert somewhere upstairs to get access to certain items that mightbe of value to someone like you. ...',
				'If you like, you can also enter the room to the left and pick one item of your choice.'
			}, cid)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, 'thieves') then
		if getPlayerStorageValue(cid, Storage.thievesGuild.Quest) < 1 then
			selfSay('Hm. Well, we could use some fresh blood. Ahum. Do you want to join the thieves guild, |PLAYERNAME|?', cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, 'lock pick') then
		selfSay('Yes, I sell lock picks. Ask me for a trade.', cid)
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, 'Good bye, |PLAYERNAME|!')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye, |PLAYERNAME|!')
npcHandler:setMessage(MESSAGE_GREET, 'Greetings, |PLAYERNAME|!')
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
