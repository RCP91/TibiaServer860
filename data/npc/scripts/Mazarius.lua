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
	
	if msgcontains(msg, "brings") then
		selfSay("Ah, you have heard about my search for experienced help. And indeed your reputation for solving certain {problems} has preceded you.", cid)
	elseif msgcontains(msg, "problems") then
		selfSay(" My problems are, so to say, dire news for the whole world. <sigh> I don't want to confuse you with overly complicated and lengthy stories, so do you want to hear the {long} version or the {short}?", cid)
	elseif msgcontains(msg, "long") then
		selfSay("He obviously had taken an interest to the topic of ascension, and I came into possession of some of his early writings. ...You have to know I'm a scholar of some renown. In the course of my latest studies about ascension, I stumbled upon disturbing facts about the person of the all to well known Ferumbras, the fiendish. ...", cid)
		selfSay("This, combined with investigation and divination, bit by bit led to the conclusion that all that Ferumbras has done in the past may be part of a cunning plan. ...", cid)
		selfSay("Considering his writings and the books he based them upon, it became clear that Ferumbras is planning his ascension to godlike status. ...", cid)
		selfSay("All of his attacks and defeats only served one purpose: to become an integral part of the people's knowledge, fears and beliefs. ...", cid)
		selfSay("He actually used this as an energy source, and combined it with some sources of power which might not all be of our own world. ...", cid)
		selfSay("He uses this energy to increasingly empower himself and will eventually be prepared to take the final step to transform himself into a godlike being. ...", cid)
		selfSay("With the knowledge what to look for, I acquired expensive but powerful artefacts to scry the world for the expected power signature - and indeed I made contact. ...", cid)
		selfSay("To my horror I had to recognise that Ferumbras had already made significant progress, and his final bid for ascension is imminent! ...", cid)
		selfSay("His power levels are already too high for there to be any hope of stopping him with conventional means. ...", cid)
		selfSay("But not all is lost yet. During my studies about godhood, I learned that the dark Zathroth himself had created a weapon so powerful that it could actually slay a god. ...", cid)
		selfSay("Yet even he deemed this so-called '{godbreaker}' too dangerous, and split it into seven parts. These were at some point entrusted to his powerful minions, known as the Ruthless Seven. ...", cid)
		selfSay("Ancient, forbidden texts hinted at a hellish place where the seven built deadly dungeons, and placed some of their most fearsome and terrible minions as guards, before they sealed the place off. ...", cid)
		selfSay("I'm confident that I can prepare a matching ritual that will breach their protection and allow someone to enter their realm; but I'm in no way suited to handle the horrors to be encountered there. ...", cid)
		selfSay("Therefore I have to ask you, if you are willing to retrieve the parts of the godbreaker, and face the threat of the ascending Ferumbras?", cid)
	elseif msgcontains(msg, "short") then
		selfSay("My studies indicate that without all doubt Ferumbras the fiendish is in the process of accumulating nearly godlike powers. We have to stop him. ...", cid)
		selfSay("Therefore I need you to enter a hellish dimension and acquire the parts of a weapon, the {godbreaker}, powerful enough to stop him once and for all. Are you willing to help me in this dire mission?", cid)
		talkState[talkUser] = 2
	elseif msgcontains(msg, "yes") and talkState[talkUser] == 2 and getPlayerStorageValue(cid, Storage.FerumbrasAscension.Access) < 1 then
		selfSay("Good!, but I need 30 {demonic essences} to exchange with the demonic messenger for a ticket for you to enter the Abodes of Torments.", cid)
	elseif msgcontains(msg, "demonic essence") or msgcontains(msg, "essence") then
		selfSay("Do you have 30 demonic essences to offer to the demonic messenger?", cid)
		talkState[talkUser] = 3
	elseif msgcontains(msg, "yes") and talkState[talkUser] == 3 then
		if not doPlayerRemoveItem(cid, 6500, 30) then
			selfSay("You don\'t have the demonic essences, back here when you get it.", cid)
			npcHandler:releaseFocus(cid)
		else
			selfSay("Excellent! This will empower possibilty to create a breach is enough to let you pass into that hellish hiding place. ...", cid)
			doPlayerAddItem(cid, 24838, 1)
			doPlayerRemoveItem(cid, 6500, 30)
			setPlayerStorageValue(cid, Storage.FerumbrasAscension.Access, 1)
		end
	elseif msgcontains(msg, "godbreaker") then
		selfSay("For a long time, I thought the godbreaker to be some apocryphal myth. But apparently others had learned about the godbreaker in the aeons past and lusted for its power. ...", cid)
		selfSay("They had gathered hint after hint - until, ultimately, they were squashed by the Seven or their minions; which only made the leads that hinted at them all the more probable. ...", cid)
		selfSay("What Zathroth hoped to accomplish with the creation of such a weapon can only be subject to speculation. Assumedly he already had slain Tibiasula, so the godbreaker might have been even more powerful, more absolute. ...", cid)
		selfSay("However, it has to be assumed that in the end the sheer power of his creation scared Zathroth, who had to fear the weapon could one day be used against him. So he disassembled it. ...", cid)
		selfSay("He kept the parts hidden and guarded, and if the resources can be trusted and my interpretation is right, moved them again and again, never satisfied with a hiding place. In the end he entrusted the parts to the {Ruthless Seven}. ...", cid)
		selfSay("Knowing that they would never, ever allow one of their own to come in possession of all parts. Since then, the parts have been hidden in a {demi-plane} shared by the Seven.", cid)
		selfSay("Well, I need 30 {demonic essences} to change for a passage to you can access", cid)
	elseif msgcontains(msg, "Ruthless Seven") or msgcontains(msg, "ruthless seven") then
		selfSay("Given the internal power plays amongst the Seven, they are the ideal keepers for individual parts of an powerful artefact. Not one of them would allow his compatriots to hold such a power, and neither would trust the other.", cid)
	elseif msgcontains(msg, "demi-plane") then
		selfSay("It is a place, so to say, not completely of this world. It is separate of, yet strongly connected to, our own world. I would imagine it is quite limited in size and its laws of physics and magic should be roughly the same as ours. ...", cid)
		selfSay("Being home to a host of demons for a while, I expect it to be an hostile and dangerous environment.", cid)
	elseif msgcontains(msg, "ascension") then
		selfSay("Ascension is a fascinating topic that dates back to efforts and philosophies of some of the most ancient, and mostly extinct, races which fought in the godwars. ...", cid)
		selfSay("Probably born out of desperation, they extensively researched ways to acquire godhood themselves. ...", cid)
		selfSay("Some of them at least even met with moderate success. But the process is complicated at best, and may vary from race to race or even from one individual to another. ...", cid)
		selfSay("The theories differ vastly and waxed and waned in popularity over the centuries if not aeons. Even today and in human society there are a number of obscure ascension cults. ...", cid)
		selfSay("Some of them claim that humans are most suitable for ascension because they already own a bit of divinity through Banor's godly spark.", cid)
	elseif msgcontains(msg, "ferumbras") then
		selfSay("Although already powerful in his own right, it is obvious that his ultimate goal seems to be the ascension to godly powers. ...", cid)
		selfSay("His whole existence seems to be centred on becoming a name that strikes fear into the heart of men and to become a persistent figure in the minds of humanity. ...", cid)
		selfSay("This gives him a hold in reality and a kind of mould to fill with his power and conscience. It's also obvious that this kind of belief of the people alone won't be enough to empower him sufficiently. ...", cid)
		selfSay("Therefore he has to tap into other, probably even more sinister power sources. I can't tell what these sources are, but my scrying revealed that he has reached massive amounts of power. He has probably been infusing himself since years. ...", cid)
		selfSay("By now he is apparently reaching the end circle of his ascension and could make his final move any day.", cid)
	elseif msgcontains(msg, "bozarn") then
		selfSay("Ah, a good man and a competent aid.", cid)
	elseif msgcontains(msg, "darashia") then
		selfSay("I like the quietness and the climate. And admittedly it helped my studies not to be constantly disturbed by petitioners.", cid)
	elseif msgcontains(msg, "thais") then
		selfSay("Thais has become a melting pot of some source. Yet whatever you melt, if the ingredients are corrupted, the outcome is always flawed.", cid)
	elseif msgcontains(msg, "carlin") then
		selfSay("Instead of banding together and starting to change something, they and Thais keep wasting resources in hostilities.", cid)
	elseif msgcontains(msg, "kazordoon") then
		selfSay("The dwarves are leftovers from a time long gone by. They have outlived their usefulness to the gods and seem to have come to terms with that. ...", cid)
		selfSay("They are as unchanging as rock and no greatness awaits them any more. They missed their chance, if they ever had any.", cid)
	elseif msgcontains(msg, "ab\'dendriel") then
		selfSay("The elves are like lost children. Their potential might be great, but they lack focus and dedication to truly improve. If their myths are true, some of the more early elves might have accomplished ascension. ...", cid)
		selfSay("Yet even if hints strongly suggest those stories are true, the sheer inaction of those assumedly ascended beings is disturbing. Perhaps what those legendary elves achieved was something completely different.", cid)
	elseif msgcontains(msg, "edron") then
		selfSay("Edron has become as stagnant as the teachings in its academy. No new idea has been thought there for decades. The whole Edron is an example for what happens when humanity has become fat and lazy.", cid)
	elseif msgcontains(msg, "demons") then
		selfSay("With all their powers and vast magic knowledge they are still more pawns than anything else. Given their resources, ascension might seem within reach. ...", cid)
		selfSay("The absence of any ascendant demon might prove that they are no true beings at all and literally damned to be stuck in their accursed forms.", cid)
	elseif msgcontains(msg, "venore") then
		selfSay("An almost laughable greed is persistent in that city. At least this makes knowledge and materials conveniently available to those who can match their prizes.", cid)
	else
		selfSay("What?!", cid)
	end

end
npcHandler:setMessage(MESSAGE_GREET, "Greetings, dear visitor. Please tell me what {brings} you here, to my humble adobe.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Oh well.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
