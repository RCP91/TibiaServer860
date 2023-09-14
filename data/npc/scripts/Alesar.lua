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

	
	local missionProgress = getPlayerStorageValue(cid, Storage.DjinnWar.EfreetFaction.Mission02)
	if msgcontains(msg, 'mission') then
		if getPlayerStorageValue(cid, Storage.DjinnWar.EfreetFaction.Mission01) == 3 then
			if missionProgress < 1 then
				selfSay({
					'So Baa\'leal thinks you are up to do a mission for us? ...',
					'I think he is getting old, entrusting human scum such as you are with an important mission like that. ...',
					'Personally, I don\'t understand why you haven\'t been slaughtered right at the gates. ...',
					'Anyway. Are you prepared to embark on a dangerous mission for us?'
				}, cid)
				talkState[talkUser] = 1

			elseif isInArray({1, 2}, missionProgress) then
				selfSay('Did you find the tear of Daraman?', cid)
				talkState[talkUser] = 2
			else
				selfSay('Don\'t forget to talk to Malor concerning your next mission.', cid)
			end
		end

	elseif talkState[talkUser] == 1 then
		if msgcontains(msg, 'yes') then
			selfSay({
				'All right then, human. Have you ever heard of the {\'Tears of Daraman\'}? ...',
				'They are precious gemstones made of some unknown blue mineral and possess enormous magical power. ...',
				'If you want to learn more about these gemstones don\'t forget to visit our library. ...',
				'Anyway, one of them is enough to create thousands of our mighty djinn blades. ...',
				'Unfortunately my last gemstone broke and therefore I\'m not able to create new blades anymore. ...',
				'To my knowledge there is only one place where you can find these gemstones - I know for a fact that the Marid have at least one of them. ...',
				'Well... to cut a long story short, your mission is to sneak into Ashta\'daramai and to steal it. ...',
				'Needless to say, the Marid won\'t be too eager to part with it. Try not to get killed until you have delivered the stone to me.'
			}, cid)
			setPlayerStorageValue(cid, Storage.DjinnWar.EfreetFaction.Mission02, 1)

		elseif msgcontains(msg, 'no') then
			selfSay('Then not.', cid)
		end
		talkState[talkUser] = 0

	elseif talkState[talkUser] == 2 then
		if msgcontains(msg, 'yes') then
			if getPlayerItemCount(cid, 2346) == 0 or missionProgress ~= 2 then
				selfSay('As I expected. You haven\'t got the stone. Shall I explain your mission again?', cid)
				talkState[talkUser] = 1
			else
				selfSay({
					'So you have made it? You have really managed to steal a Tear of Daraman? ...',
					'Amazing how you humans are just impossible to get rid of. Incidentally, you have this character trait in common with many insects and with other vermin. ...',
					'Nevermind. I hate to say it, but it you have done us a favour, human. That gemstone will serve us well. ...',
					'Baa\'leal, wants you to talk to Malor concerning some new mission. ...',
					'Looks like you have managed to extended your life expectancy - for just a bit longer.'
				}, cid)
				doPlayerRemoveItem(cid, 2346, 1)
				setPlayerStorageValue(cid, Storage.DjinnWar.EfreetFaction.Mission02, 3)
				talkState[talkUser] = 0
			end

		elseif msgcontains(msg, 'no') then
			selfSay('As I expected. You haven\'t got the stone. Shall I explain your mission again?', cid)
			talkState[talkUser] = 1
		end
	end
	return true
end

local function onTradeRequest(cid)
	
	
	if getPlayerStorageValue(cid, Storage.DjinnWar.EfreetFaction.Mission03) ~= 3 then
		selfSay('I\'m sorry, but you don\'t have Malor\'s permission to trade with me.', cid)
		return false
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, 'What do you want from me, |PLAYERNAME|?')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Finally.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Finally.')
npcHandler:setMessage(MESSAGE_SENDTRADE, 'At your service, just browse through my wares.')

npcHandler:setCallback(CALLBACK_ONTRADEREQUEST, onTradeRequest)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

local focusModule = FocusModule:new()
focusModule:addGreetMessage('hi')
focusModule:addGreetMessage('hello')
focusModule:addGreetMessage('djanni\'hah')
npcHandler:addModule(focusModule)
