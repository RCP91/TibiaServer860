local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local voices = {
	{ text = 'Buying fresh corpses of rats, rabbits and wolves.' },
	{ text = 'Oh yeah, I\'m also interested in wolf paws and bear paws.' },
	{ text = 'Also buying minotaur leather.' }
}
--npcHandler:addModule(VoiceModule:new(voices))

-- Greeting and Farewell
keywordHandler:addGreetKeyword({'hi'}, {npcHandler = npcHandler, text = 'Hey there, |PLAYERNAME|. I\'m Tom the tanner. If you have fresh {corpses}, leather, paws or other animal body parts, {trade} with me.'})
keywordHandler:addAliasKeyword({'hello'})
keywordHandler:addFarewellKeyword({'bye'}, {npcHandler = npcHandler, text = 'Good hunting, child.'}, function(player) return player:getSex() == PLAYERSEX_FEMALE end)
keywordHandler:addAliasKeyword({'farewell'})
keywordHandler:addFarewellKeyword({'bye'}, {npcHandler = npcHandler, text = 'Good hunting, son.'})
keywordHandler:addAliasKeyword({'farewell'})

-- Basic keywords
keywordHandler:addKeyword({'hint'}, StdModule.rookgaardHints, {npcHandler = npcHandler})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'My name is Tom the tanner.'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m the local {tanner}. I buy fresh animal {corpses}, tan them, and convert them into fine leather clothes which I then sell to {merchants}.'})
keywordHandler:addKeyword({'merchant'}, StdModule.say, {npcHandler = npcHandler, text = '{Dixi} and {Lee\'Delle} sell my leather clothes in their shops.'})
keywordHandler:addKeyword({'tanner'}, StdModule.say, {npcHandler = npcHandler, text = 'That\'s my job. It can be dirty at times but it provides enough income for my living.'})
keywordHandler:addKeyword({'information'}, StdModule.say, {npcHandler = npcHandler, text = 'Do I look like a tourist information centre? Go ask someone else.'})
keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = 'Help? I will give you a few gold coins if you have some fresh dead {animals} for me. Note the word {fresh}.'})
keywordHandler:addKeyword({'fresh'}, StdModule.say, {npcHandler = npcHandler, text = 'Fresh means: shortly after their death.'})
keywordHandler:addKeyword({'how', 'are', 'you'}, StdModule.say, {npcHandler = npcHandler, text = 'Much to do these days.'})
keywordHandler:addKeyword({'monster'}, StdModule.say, {npcHandler = npcHandler, text = 'Good monsters to start with are rats. They live in the {sewers} under the village of {Rookgaard}.'})
keywordHandler:addKeyword({'dungeon'}, StdModule.say, {npcHandler = npcHandler, text = 'Dungeons can be dangerous without proper {equipment}.'})
keywordHandler:addKeyword({'equipment'}, StdModule.say, {npcHandler = npcHandler, text = 'You need at least a {backpack}, a {rope}, a {shovel}, a {weapon}, an {armor} and a {shield}.'})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = 'Sorry, I haven\'t been outside for a while, so I don\'t know.'})

keywordHandler:addKeyword({'troll'}, StdModule.say, {npcHandler = npcHandler, text = 'Troll leather stinks. Can\'t use it.'})
keywordHandler:addKeyword({'orc'}, StdModule.say, {npcHandler = npcHandler, text = 'I don\'t buy orcs. Their skin is too scratchy.'})
keywordHandler:addKeyword({'human'}, StdModule.say, {npcHandler = npcHandler, text = 'Are you crazy?!', ungreet = true})

keywordHandler:addKeyword({'backpack'}, StdModule.say, {npcHandler = npcHandler, text = 'Nope, sorry, don\'t sell that. Go see {Al Dee} or {Lee\'Delle}.'})
keywordHandler:addAliasKeyword({'rope'})

keywordHandler:addKeyword({'armor'}, StdModule.say, {npcHandler = npcHandler, text = 'Nope, sorry, don\'t sell that. Ask {Dixi} or {Lee\'Delle}.'})
keywordHandler:addAliasKeyword({'shield'})

keywordHandler:addKeyword({'weapon'}, StdModule.say, {npcHandler = npcHandler, text = 'Nope, sorry, don\'t sell that. Ask {Obi} or {Lee\'Delle}.'})

keywordHandler:addKeyword({'corpse'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m buying fresh {corpses} of rats, rabbits and wolves. I don\'t buy half-decayed ones. If you have any for sale, {trade} with me.'})
keywordHandler:addAliasKeyword({'wares'})
keywordHandler:addAliasKeyword({'animal'})
keywordHandler:addAliasKeyword({'sell'})
keywordHandler:addAliasKeyword({'buy'})
keywordHandler:addAliasKeyword({'offer'})

-- Names
keywordHandler:addKeyword({'al', 'dee'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s an apple polisher.'})
keywordHandler:addKeyword({'amber'}, StdModule.say, {npcHandler = npcHandler, text = 'Now that\'s an interesting woman.'})
keywordHandler:addKeyword({'billy'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s a better cook than his cousin {Willie}, actually.'})
keywordHandler:addKeyword({'willie'}, StdModule.say, {npcHandler = npcHandler, text = 'I kinda like him. At least he says what he thinks.'})
keywordHandler:addKeyword({'tom'}, StdModule.say, {npcHandler = npcHandler, text = 'Yep.'})
keywordHandler:addKeyword({'seymour'}, StdModule.say, {npcHandler = npcHandler, text = 'He sticks his nose too much in books.'})
keywordHandler:addKeyword({'zirella'}, StdModule.say, {npcHandler = npcHandler, text = 'My mother?? Did you meet my mother??'})
keywordHandler:addKeyword({'santiago'}, StdModule.say, {npcHandler = npcHandler, text = 'I don\'t have a problem with him.'})
keywordHandler:addKeyword({'paulie'}, StdModule.say, {npcHandler = npcHandler, text = 'Typical pencil pusher.'})
keywordHandler:addKeyword({'oracle'}, StdModule.say, {npcHandler = npcHandler, text = 'It\'s in the academy, just above Seymour. Go there once you are level 8 to leave this place.'})
keywordHandler:addKeyword({'obi'}, StdModule.say, {npcHandler = npcHandler, text = 'He is such a hypocrite.'})
keywordHandler:addKeyword({'norma'}, StdModule.say, {npcHandler = npcHandler, text = 'I like her beer.'})
keywordHandler:addKeyword({'dixi'}, StdModule.say, {npcHandler = npcHandler, text = 'She buys my fine leather clothes.'})
keywordHandler:addKeyword({'loui'}, StdModule.say, {npcHandler = npcHandler, text = 'I wonder what spectacular monsters he has found.'})
keywordHandler:addKeyword({'lee\'delle'}, StdModule.say, {npcHandler = npcHandler, text = 'Her nose is a little high in the air, I think. She never shakes my hand.'})
keywordHandler:addKeyword({'hyacinth'}, StdModule.say, {npcHandler = npcHandler, text = 'I wonder if he\'s angry because his potion monopoly fell.'})
keywordHandler:addKeyword({'cipfried'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m not what you\'d call a \'believer\'.'})
keywordHandler:addKeyword({'dallheim'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s okay.'})
keywordHandler:addAliasKeyword({'zerbrus'})

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	if msgcontains(msg, "cough syrup") then
		selfSay("I had some cough syrup a while ago. It was stolen in an ape raid. I fear if you want more cough syrup you will have to buy it in the druids guild in carlin.", cid)
	elseif msgcontains(msg, "addon") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.DruidBodyAddon) < 1 then
			selfSay("Would you like to wear bear paws like I do? No problem, just bring me 50 bear paws and 50 wolf paws and I'll fit them on.", cid)
			setPlayerStorageValue(cid, Storage.OutfitQuest.DruidBodyAddon, 1)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "paws") or msgcontains(msg, "bear paws") then
		if getPlayerStorageValue(cid, Storage.OutfitQuest.DruidBodyAddon) == 1 then
			selfSay("Have you brought 50 bear paws and 50 wolf paws?", cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			if getPlayerItemCount(cid, 5896) >= 50 and getPlayerItemCount(cid, 5897) >= 50 then
				selfSay("Excellent! Like promised, here are your bear paws. ", cid)
				doPlayerRemoveItem(cid, 5896, 50)
				doPlayerRemoveItem(cid, 5897, 50)
				setPlayerStorageValue(cid, Storage.OutfitQuest.DruidBodyAddon, 2)
				doPlayerAddOutfit(cid, 148, 1)
				doPlayerAddOutfit(cid, 144, 1)
				talkState[talkUser] = 0
			else
				selfSay("You don't have all items.", cid)
				talkState[talkUser] = 0
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_WALKAWAY, 'D\'oh?')
npcHandler:setMessage(MESSAGE_SENDTRADE, 'Sure, check what I buy.')

npcHandler:addModule(FocusModule:new())
