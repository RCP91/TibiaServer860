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

	
	if getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) < 1 then
		setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, 3)
	end

	if msgcontains(msg, "job") or msgcontains(msg, "vampiric crest") and not getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 54 then
		selfSay("I'm an Augur of the city of Yalahar. My special duty consists of coordinating the efforts to keep the city and its services running.", cid)
	elseif msgcontains(msg, "job") then
		if getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 54 then
			selfSay("Did you bring me the vampiric crest?", cid)
			talkState[talkUser] = 6
		end
	elseif msgcontains(msg, "mission") then
		if getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 3 then
			selfSay({
				"You probably heard that we have numerous problems in different quarters of our city. Our forces are limited, so we really could need some help from outsiders. ...",
				"Would you like to assist us in re-establishing order in our city?"
			}, cid)
			talkState[talkUser] = 1
		elseif getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 4 then
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission01, 1) -- StorageValue for Questlog "Mission 01: Something Rotten"
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, 5)
			selfSay({
				"I hope your first mission will not scare you off. Even though, we cut off our sewer system from other parts of the city to prevent the worst, it still has deteriorated in the last decades. ...",
				"Certain parts of the controls are rusty and the drains are stuffed with garbage. Get yourself a crowbar, loosen the controls and clean the pipes from the garbage. ...",
				"We were able to locate the 4 worst spots in the sewers. I will mark them for you on your map so you have no trouble finding them. Report to me when you have finished your {mission}. ..."
			}, cid)
			player:addMapMark(Position(32823, 31161, 8), 4, "Sewer Problem 1")
			player:addMapMark(Position(32795, 31152, 8), 4, "Sewer Problem 2")
			player:addMapMark(Position(32842, 31250, 8), 4, "Sewer Problem 3")
			player:addMapMark(Position(32796, 31192, 8), 4, "Sewer Problem 4")
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 5 then
			selfSay("So are you done with your work?", cid)
			talkState[talkUser] = 2
		elseif getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 6 then
			selfSay({
				"We are still present at each quarter's city wall, even though we can do little to stop the chaos from spreading. Still, our garrisons are necessary to maintain some sort of order in the city. ...",
				"My superiors ask for a first hand report about the current situation in the single city quarters. I need someone to travel to our garrisons to get the reports from the guards. Are you willing to do that?"
			}, cid)
			talkState[talkUser] = 3
		elseif getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) >= 7 and getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) <= 14 then
			selfSay("Did you get all the reports my superiors asked for? ", cid)
			talkState[talkUser] = 4
		elseif getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 15 then
			selfSay({
				"I did my best to impress my superiors with your accomplishments and it seems that it worked quite well. They want you for their own missions now. ...",
				"Missions that are more important than the ones you've fulfilled for me. However, before you leave, there are still some things I need to tell you. ...",
				"Listen, I can't explain you everything in detail right now and here. You never know who might be eavesdropping. ...",
				"I left some notes in the small room there. Get them and read them. Talk to me again when you've read the notes."
			}, cid)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission03, 1) -- StorageValue for Questlog "Mission 03: Death to the Deathbringer"
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, 16)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.NotesPalimuth, 0)
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.InServiceofYalahar.NotesPalimuth) == 1 and getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 16 then
			selfSay({
				"Now you know as much as we do about the things happening in Yalahar. It's up to you what you do with this information. ...",
				"Now leave and talk to my superior Azerus in the city centre to get your next mission. I urge you, though, to talk to me whenever he sends you on a new mission. ...",
				"I think it is important that you hear my opinion about them. Now hurry. I suppose Azerus is already waiting."
			}, cid)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission03, 2) -- StorageValue for Questlog "Mission 03: Death to the Deathbringer"
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, 17)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.DoorToAzerus, 1)
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 20 then
			selfSay({
				"This quarter has been sealed off years ago. To send someone there poses a high risk to spread the plague. I assume these research notes you've mentioned must be very important. ...",
				"After all those years it is more than strange that someone shows interest in these notes now. Considering what has happened to the alchemists, it is rather unlikely that they contain harmless information. ...",
				"I fear these notes will be used to turn the plague into some kind of weapon. Someone with this plague at his disposal could subdue the whole city by blackmailing. ...",
				"I beg you to destroy these notes. Just put them into some burning oven to get rid of them and report that you did not find the notes."
			}, cid)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, 21)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.DoorToBog, 1)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission03, 5) -- StorageValue for Questlog "Mission 03: Death to the Deathbringer"
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 23 then
			selfSay({
				"Mr. West is a little paranoid. That's the reason for his immense private army of bodyguards. He could surely be helpful, especially as he rules over the former trade quarter. ...",
				"If you were able to reach him without killing his henchmen, you could probably convince him that you mean no harm to him. ...",
				"That would certainly cement our relationship without any needless bloodshed. Perhaps you could use the way through the sewers to avoid his men. ...",
				"Mr. West is not a bad man. We should be able to work out some plans to reconstruct the city's safety as soon as he overcomes his paranoia towards us."
			}, cid)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, 24)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission04, 2) -- StorageValue for Questlog "Mission 04: Good to be Kingpin"
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 25 and getPlayerStorageValue(cid, Storage.InServiceofYalahar.MrWestStatus) == 1 then
			selfSay({
				"You did quite well in gaining a new friend who will work together with us. ...",
				"I'm sure he'll still try to gain some profit but that's still better than his former one-man rule during which he dictated his own laws."
			}, cid)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.GoodSide, getPlayerStorageValue(cid, Storage.InServiceofYalahar.GoodSide) >= 0 and getPlayerStorageValue(cid, Storage.InServiceofYalahar.GoodSide) + 1 or 0)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, 26)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission04, 5) -- StorageValue for Questlog "Mission 04: Good to be Kingpin"
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 28 then
			selfSay({
				"Warbeasts? Is this true? People are already starving. ...",
				"How can we afford to feed an army of hungry beasts? They will not only strengthen the power of the Yalahari over the citizens, they also mean starvation and deathfor the poor. ...",
				"Instead of breeding warbeasts, this druid should breed cattle to feed our people. Please I beg you, convince him to do that!"
			}, cid)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, 29)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.TamerinStatus, 0)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission05, 2) -- StorageValue for Questlog "Mission 05: Food or Fight"
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 32 and getPlayerStorageValue(cid, Storage.InServiceofYalahar.TamerinStatus) == 1 then
			selfSay("These are great news indeed. The people of Yalahar will be grateful. The Yalahari probably not, so take care of yourself. ", cid)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.GoodSide, getPlayerStorageValue(cid, Storage.InServiceofYalahar.GoodSide) >= 0 and getPlayerStorageValue(cid, Storage.InServiceofYalahar.GoodSide) + 1 or 0) -- Side Storage
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, 33)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission05, 8) -- StorageValue for Questlog "Mission 05: Food or Fight"
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 35 then
			selfSay({
				"What a sick idea to misuse tortured souls to power some device! Though, this charm might be useful to free these poor souls. ...",
				"Please capture the souls as you have been instructed and then bring the charm to me. I will see to it that the souls are freed to go to the afterlife in peace."
			}, cid)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, 36)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission06, 2) -- StorageValue for Questlog "Mission 06: Frightening Fuel"
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 37 then
			if doPlayerRemoveItem(cid, 9742, 1) then
				selfSay({
					"I thank you also in the name of these poor lost souls. I will send the charm to a priest who is able to release them. ...",
					"Tell the Yalahari that the charm was destroyed by the energy it contained."
				}, cid)
				setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, 38)
				setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission06, 4) -- StorageValue for Questlog "Mission 06: Frightening Fuel"
				setPlayerStorageValue(cid, Storage.InServiceofYalahar.QuaraState, 1)
				setPlayerStorageValue(cid, Storage.InServiceofYalahar.GoodSide, getPlayerStorageValue(cid, Storage.InServiceofYalahar.GoodSide) >= 0 and getPlayerStorageValue(cid, Storage.InServiceofYalahar.GoodSide) + 1 or 0) -- Side Storage
				talkState[talkUser] = 0
			end
		elseif getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 40 then
			selfSay({
				"The quara are indeed a threat. Yet, they are numerous and reproduce quickly. Slaying some of them will only enrage them even more. ...",
				"The quara have been there for many generations. They have never threatened anyone who stayed out of their watery realm. ...",
				"It would be much more useful to find out what the quara are so upset about. Better avoid slaying their leaders as this will only further the animosities."
			}, cid)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, 41)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.DoorToQuara, 1)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission07, 2) -- StorageValue for Questlog "Mission 07: A Fishy Mission"
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 42 and getPlayerStorageValue(cid, Storage.InServiceofYalahar.QuaraState) == 1 then
			selfSay("Oh no! So that's the reason for the quara attacks! I will do my best to close these sewage pipes. We will have to use other drains. ", cid)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, 43)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission07, 5) -- StorageValue for Questlog "Mission 07: A Fishy Mission"
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.GoodSide, getPlayerStorageValue(cid, Storage.InServiceofYalahar.GoodSide) >= 0 and getPlayerStorageValue(cid, Storage.InServiceofYalahar.GoodSide) + 1 or 0) -- Side Storage
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 44 then
			selfSay({
				"The constant unrest in the city is to a great extent caused by the lack of food. Weapons will only serve to suppress the poor. ...",
				"The factory you were sent to was once used for the production of food. Somewhere in the factory you might find an old pattern crystal for the production of food. ...",
				"If you use it on the controls instead of the weapon pattern, you will ensure that our people are supplied with the desperately needed food. ..."
			}, cid)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, 45)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.DoorToMatrix, 1)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission08, 2) -- StorageValue for Questlog "Mission 08: Dangerous Machinations"
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 48 then
			selfSay({
				"Listen, I know you have worked for Azerus and his friends, but it is not too late to change your mind! I beg you to rethink your loyalties. ...",
				"The fate of the whole city might depend on your decision! Think about your options carefully."
			}, cid)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, 49)
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 49 or getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 48 then
			selfSay("So do you want to side with me? ", cid)
			talkState[talkUser] = 5
		elseif getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 50 and getPlayerStorageValue(cid, Storage.InServiceofYalahar.SideDecision) == 1 then
			selfSay({
				"I cannot tell you how we acquired this information, but we have heard that a circle of Yalahari is planning some kind of ritual. ...",
				"They plan to create a portal for some powerful demons and to unleash them in the city to 'purge' it once and for all. ...",
				"I doubt those poor fools will be able to control such entities. I can't figure out how they came up with such an insane idea, but they have to be stopped. ...",
				"The entrance to their inner sanctum has been opened for you. Please hurry and stop them before it's too late. Be prepared for a HARD battle! Better gather some friends to assist you."
			}, cid)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, 51)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.DoorToLastFight, 1)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission10, 2) -- StorageValue for Questlog "Mission 10: The Final Battle"
			talkState[talkUser] = 0
		elseif getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 52 then
			selfSay({
				"So the Yalahari that opposed us are dead or fled from the city. This should bring us more stability and perhaps a true chance to rebuild the city. ...",
				"Still, I wonder from where they gained some of the Yalahari secrets. Did they find some source of knowledge? ...",
				"And if so, is this source still around so that we can use it for the benefit of our city? What really troubles me is that none of those false Yalahari had the personality of agreat leader. ...",
				"Quite the opposite, they were opportunistic and not exactly bold. Perhaps they were led by some greater power which stayed behind the scenes. ...",
				"I'm afraid we have not seen the last chapter of Yalahar's drama. But anyhow, I wish to thank you for putting your life at stake for our cause. ...",
				"I allow you to enter the Yalaharian treasure room. I'm sure that you can put what you find inside to better use than them. Choose one chest, but think before takingone! ...",
				"Also, take this Yalaharian outfit. Depending on which side you chose previously, you can also acquire one specific addon. Thank you again for your help."
			}, cid)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, 53)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.DoorToReward, 1)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission10, 4) -- StorageValue for Questlog "Mission 10: The Final Battle"
			player:addOutfit(324, 0)
			player:addOutfit(325, 0)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			talkState[talkUser] = 0
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, 4)
			selfSay({
				"I'm pleased to hear that. Rarely we meet outsiders that care about our problems. Most people come here looking for wealth and luxury. ...",
				"However, I have to tell you that our ranking system is quite rigid. So, I'm not allowed to entrust you with important missions as long as you haven't proven yourself as reliable. ...",
				"If you are willing to work for the city of Yalahar, you can ask me for a {mission} any time, be it night or day."
			}, cid)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 2 then
			if getPlayerStorageValue(cid, Storage.InServiceofYalahar.SewerPipe01) == 1 and getPlayerStorageValue(cid, Storage.InServiceofYalahar.SewerPipe02) == 1 and getPlayerStorageValue(cid, Storage.InServiceofYalahar.SewerPipe03) == 1 and getPlayerStorageValue(cid, Storage.InServiceofYalahar.SewerPipe04) == 1 then
				setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, 6)
				setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission01, 6) -- StorageValue for Questlog "Mission 01: Something Rotten"
				selfSay("Thank you very much. You have no idea how hard it was to find someone volunteering for that job. If you feel ready for further {missions}, just tell me.", cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 3 then
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission02, 1) -- StorageValue for Questlog "Mission 02: Watching the Watchmen"
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, 7)
			selfSay({
				"You'll find our seven guards at the gates of each quarter. Just ask them for their report and they will tell you all you need to know.",
				"I must warn you, the quarters are in a horrible state. I strongly advise you to stay on the main roads whenever possible while you get those reports. ..."
			}, cid)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 4 then
			if getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) == 14 then
				setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission02, 8) -- StorageValue for Questlog "Mission 02: Watching the Watchmen"
				setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, 15)
				selfSay("Excellent! My superiors will be pleased to get these reports. I will for sure emphasise your efforts in this mission. Please come back soon to see if there are any more {missions} available for you. ", cid)
				talkState[talkUser] = 0
			else
				selfSay("Come back when you do.", cid)
				talkState[talkUser] = 0
			end
		elseif talkState[talkUser] == 5 then
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, 50)
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission09, 2) -- StorageValue for Questlog "Mission 09: Decision"
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.Mission10, 1) -- StorageValue for Questlog "Mission 10: The Final Battle"
			setPlayerStorageValue(cid, Storage.InServiceofYalahar.SideDecision, 1)
			selfSay("I knew that you were smart enough to make the right decision! Your next mission will be a special one! ", cid)
			talkState[talkUser] = 0
		elseif talkState[talkUser] == 6 then
			if getPlayerItemCount(cid, 9955) > 0 and getPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline) >= 50 then
				setPlayerStorageValue(cid, Storage.InServiceofYalahar.Questline, 55)
				selfSay("Great! Here, take this yalaharian addon in a return.", cid)
				doPlayerAddOutfit(cid, 325, getPlayerStorageValue(cid, Storage.InServiceofYalahar.SideDecision) == 1 and 1 or 2)
				doPlayerAddOutfit(cid, 324, getPlayerStorageValue(cid, Storage.InServiceofYalahar.SideDecision) == 1 and 1 or 2)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				talkState[talkUser] = 0
			else
				selfSay("Come back when you do.", cid)
				talkState[talkUser] = 0
			end
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye, |PLAYERNAME|.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
