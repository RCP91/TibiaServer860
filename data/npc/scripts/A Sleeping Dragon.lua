 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local function greetCallback(cid)
	if Player(cid):getStorageValue(Storage.WrathoftheEmperor.Questline) == 27 then
		npcHandler:setMessage(MESSAGE_GREET, "ZzzzZzzZz...chrrr...")
	else
		npcHandler:setMessage(MESSAGE_GREET, "Greetings, {wayfarer}.")
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	
	if getPlayerStorageValue(cid, Storage.WrathoftheEmperor.Questline) == 27 then
		if(msg == "SOLOSARASATIQUARIUM") and getPlayerStorageValue(cid, Storage.WrathoftheEmperor.InterdimensionalPotion) == 1 then
			selfSay({
				"Dragon dreams are golden. ...",
				"A broad darkness surrounds you as if a heavy curtain is closing before your eyes. After what seems like minutes of floating through emptiness, you get the feeling as if a hole opens in the dark before you. ...",
				"The hole grows larger, you cannot close your eyes. An unimaginable black. Deeper and darker than any nothingness you could possibly imagine drags you into it. ...",
				"You feel as if you cannot breathe anymore. The very second you let loose of your consciousness, you sense all heaviness around you lifted. ...",
				"You dive into an ocean of emerald light. Feeling like born anew the colour around you is almost overwhelming. Countless objects of all shapes and sizes are dashing past you. Racing against each other, millions are clashing in the distance. ..",
				"The loudness of the gargantuan spectacle around you bursts your hearing, yet you absorb all the sounds around you. ...",
				"As several large obstacles move aside directly in front of you, an intense bright centre leaps into your view. Though you cannot perceive how fast you are, your pace seems too slow. ...",
				"Ever decelerating, you ultimately approach a middle in this chaos of tones of green. ...",
				"As you come closer to it, yellowish shades of orange embrace you, softer shapes emerge and you almost forget the mayhem before. In warm comfort you see what lies in the heart of it all. ...",
				"A majestic dragon in his sleep is surrounded by what seems the warmth and energy of a thousand suns. The tranquillity of its sight makes you smile gently. ...",
				"You feel a perfect mixture of joy, compassion and sudden peacefulness. Bright xanthous impressions of topaz, orange and white welcome you at the final halt of your journey. ...",
				"Dragon dreams are golden. ...",
				"You find yourself inside the dragon's dream. You can {look} around or {go} into a specific direction. You can also {take} or {use} an object. Enter {help} to display this information at any time."
			}, cid)
			talkState[talkUser] = 1
		elseif(msg:lower() == "help" and talkState[talkUser] > 0 and talkState[talkUser] < 34) then
			selfSay("You find yourself inside the dragon's dream. You can {look} around or {go} into a specific direction. You can also {take} or {use} an object. Enter {help} to display this information at any time.", cid)
		elseif(msg:lower() == "west" and talkState[talkUser] == 1) then
			selfSay("Advancing to the west, you recognise an increase of onyx on the ground.", cid)
			talkState[talkUser] = 2
		elseif(msg:lower() == "take attachment" and talkState[talkUser] == 2) then
			selfSay("You carefully lift the onyx attachment from its socket. It is lighter than you expected.", cid)
			talkState[talkUser] = 3
		elseif(msg:lower() == "east" and talkState[talkUser] == 3) then
			selfSay("You return to the plateau in the east.", cid)
			talkState[talkUser] = 4
		elseif(msg:lower() == "south" and talkState[talkUser] == 4) then
			selfSay("You wander to the south, passing large obelisks of emerald to your left and sprawling trees of topaz to your right. ", cid)
			talkState[talkUser] = 5
		elseif(msg:lower() == "take stand" and talkState[talkUser] == 5) then
			selfSay("As you rip the solid stand out of its socket and take it with you, the large gate opens with a deafening rumble. ", cid)
			talkState[talkUser] = 6
		elseif(msg:lower() == "east" and talkState[talkUser] == 6) then
			selfSay("You gasp at the size of the large open gate as you walk through to head further to the east.", cid)
			talkState[talkUser] = 7
		elseif(msg:lower() == "take model" and talkState[talkUser] == 7) then
			selfSay("You reach for a small solitary arrangement of combined small houses and put it in your pocket.", cid)
			talkState[talkUser] = 8
		elseif(msg:lower() == "take emeralds" and talkState[talkUser] == 8) then
			selfSay("You take an emerald from the pile. ", cid)
			talkState[talkUser] = 9
		elseif(msg:lower() == "west" and talkState[talkUser] == 9) then
			selfSay("You return through the semi-translucent gate to the west. ", cid)
			talkState[talkUser] = 10
		elseif(msg:lower() == "north" and talkState[talkUser] == 10) then
			selfSay("You head back north to the plateau. ", cid)
			talkState[talkUser] = 11
		elseif(msg:lower() == "east" and talkState[talkUser] == 11) then
			selfSay("You travel east across several large emerald bluffs and edges. All sorts of gems are scattered alongside your path. ", cid)
			talkState[talkUser] = 12
		elseif(msg:lower() == "take rubies" and talkState[talkUser] == 12) then
			selfSay("You take a rather large ruby out of a pile before you. ", cid)
			talkState[talkUser] = 13
		elseif(msg:lower() == "north" and talkState[talkUser] == 13) then
			selfSay("You head north passing countless stones in the crimson sea of stones beneath your feet.", cid)
			talkState[talkUser] = 14
		elseif(msg:lower() == "use attachment" and talkState[talkUser] == 14) then
			selfSay({
				"Avoiding the bright light, you carefully put the attachment on top of the strange socket. ...",
				"As your eyes adjust to the sudden reduction of brightness, you see the giant wings of the gate before you move to the side. You can also make out something shiny on the ground."
			}, cid)
			talkState[talkUser] = 15
		elseif(msg:lower() == "take mirror" and talkState[talkUser] == 15) then
			selfSay("You pick the mirror from the ground.", cid)
			talkState[talkUser] = 16
		elseif(msg:lower() == "north" and talkState[talkUser] == 16) then
			selfSay({
				"Your path to the north is open. You pass the gigantic gate wings to your left and right as you advance. After about an hour of travel you hear a slight rustling in the distance. You head further into that direction. ...",
				"The rustling gets louder until you come to a small dune. Behind it you find the source of the noise."
			}, cid)
			talkState[talkUser] = 17
		elseif(msg:lower() == "use model" and talkState[talkUser] == 17) then
			selfSay({
				"You lunge out and throw the model far into the water. As nothing happens, you turn your back to the ocean. ...",
				"The very moment you walk down the dune to head back south, rays of light burst over your head in a shock wave that makes you tumble down the rest of the hill. ...",
				"You can also hear a deep loud scraping for several minutes somewhere far in the west."
			}, cid)
			talkState[talkUser] = 18
		elseif(msg:lower() == "south" and talkState[talkUser] == 18) then
			selfSay("You travel all the way back down the dune and through the gate to the south. ", cid)
			talkState[talkUser] = 19
		elseif(msg:lower() == "south" and talkState[talkUser] == 19) then
			selfSay("You return to the crimson sea of rubies in the south. ", cid)
			talkState[talkUser] = 20
		elseif(msg:lower() == "west" and talkState[talkUser] == 20) then
			selfSay("You travel back to the plateau in the west. ", cid)
			talkState[talkUser] = 21
		elseif(msg:lower() == "west" and talkState[talkUser] == 21) then
			selfSay("Advancing to the west, you recognise an increase of onyx on the ground. ", cid)
			talkState[talkUser] = 22
		elseif(msg:lower() == "north" and talkState[talkUser] == 22) then
			selfSay("You continue travelling the barren sea of gemstones to the north. ", cid)
			talkState[talkUser] = 23
		elseif(msg:lower() == "west" and talkState[talkUser] == 23) then
			selfSay("You leave the massive open gate behind you and go to the west. ", cid)
			talkState[talkUser] = 24
		elseif(msg:lower() == "bastesh" and talkState[talkUser] == 24) then
			selfSay("This huge statue of Bastesh is made from onyx, and thrones on a large plateau which can be reached by a sprawling stairway. She holds a large {sapphire} in her hands. ", cid)
			talkState[talkUser] = 25
		elseif(msg:lower() == "take sapphire" and talkState[talkUser] == 25) then
			selfSay("You carefully remove the sapphire from Bastesh's grasp. ", cid)
			talkState[talkUser] = 26
		elseif(msg:lower() == "east" and talkState[talkUser] == 26) then
			selfSay("You head back to the east and to the plateau. ", cid)
			talkState[talkUser] = 27
		elseif(msg:lower() == "south" and talkState[talkUser] == 27) then
			selfSay("You head back south to the site with the onyx lookout. ", cid)
			talkState[talkUser] = 28
		elseif(msg:lower() == "east" and talkState[talkUser] == 28) then
			selfSay("You return to the plateau in the east. ", cid)
			talkState[talkUser] = 29
		elseif(msg:lower() == "use stand" and talkState[talkUser] == 29) then
			selfSay("You put the stand into a small recess you find near the middle of the plateau. ", cid)
			talkState[talkUser] = 30
		elseif(msg:lower() == "use ruby" and talkState[talkUser] == 30) then
			selfSay("As the ruby slips into the notch, the strong red of the stone intensifies a thousandfold. You fear to hurt your eyes and turn away immediately. The ray seems to be directed to the centre of the plateau with astounding precision. ", cid)
			talkState[talkUser] = 31
		elseif(msg:lower() == "use sapphire" and talkState[talkUser] == 31) then
			selfSay("As the sapphire slips into the notch, the deep blue of the stone intensifies a thousandfold. You fear to hurt your eyes and turn away immediately. The ray seems to be directed to the centre of the plateau with astounding precision. ", cid)
			talkState[talkUser] = 32
		elseif(msg:lower() == "use emerald" and talkState[talkUser] == 32) then
			selfSay("As the emerald slips into the notch, the vibrant green of the stone intensifies a thousandfold. You fear to hurt your eyes and turn away immediately. The ray seems to be directed to the centre of the plateau with astounding precision. ", cid)
			talkState[talkUser] = 33
		elseif(msg:lower() == "use mirror" and talkState[talkUser] == 33) then
			selfSay({
				"With your eyes covered and avoiding direct sight of the rays, you put the mirror into the stand. ...",
				"Instinctively you run to a larger emerald bluff near the raise to find cover. Mere seconds after you claimed the sturdy shelter, a deep dark humming starts to swirl through the air. ...",
				"Seconds pass as the hum gets louder. The noise is maddening, drowning all other sounds around you. As you cover your ears in pain, the humming explodes into a deafening growl. ...",
				"You raise your head above the edge of the emerald to catch a glimpse of what's happening. ...",
				"The hand seems to have grown into a fist. In the distance you can now see a blurry scheme of a creature too large for your eyes to get a sharper view of its head. ...",
				"Blending the rays, the mirror directs pure white light directly towards the part where you assume the face of the creature. ...",
				"The growl transforms into a scream, everything around you seems to compress. As you press yourself tightly against the bluff, everything falls silent and in a split second, the dark being dissolves into bursts of blackness. You wake."
			}, cid)
			setPlayerStorageValue(cid, Storage.WrathoftheEmperor.Questline, 28)
			setPlayerStorageValue(cid, Storage.WrathoftheEmperor.Mission09, 2) --Questlog, Wrath of the Emperor "Mission 09: The Sleeping Dragon"
			talkState[talkUser] = 0
	end
	elseif getPlayerStorageValue(cid, Storage.WrathoftheEmperor.Questline) == 28 then
		if(msgcontains(msg, "wayfarer")) then
			selfSay("I call you the wayfarer. You travelled through my dreams. You ultimately freed my mind. My mind accepted you and so will I.", cid)
			talkState[talkUser] = 40
		elseif(msgcontains(msg, "mission") and talkState[talkUser] == 40) then
			selfSay({
				"Aaaah... free at last. Hmmm. ...",
				"I assume you need to get through the gate to reach the evildoer. I can help you if you trust me, wayfarer. I will share a part of my mind with you which should enable you to step through the gate. ...",
				"This procedure may be exhausting. Are you prepared to receive my key?"
			}, cid)
			talkState[talkUser] = 41
		elseif(msgcontains(msg, "yes") and talkState[talkUser] == 41) then
			selfSay({
				"SAETHELON TORILUN GARNUM. ...",
				"SLEEP. ...",
				"GAIN. ...",
				"RISE. ...",
				"The transfer was successful. ...",
				"You are now prepared to enter the realm of the evildoer. I am grateful for your help, wayfarer. Should you seek my council, use this charm I cede to you. For my spirit will guide you wherever you are. May you enjoy a sheltered future, you shall prevail."
			}, cid)
			setPlayerStorageValue(cid, Storage.WrathoftheEmperor.Questline, 29)
			setPlayerStorageValue(cid, Storage.WrathoftheEmperor.Mission10, 1) --Questlog, Wrath of the Emperor "Mission 10: A Message of Freedom"
			doPlayerAddItem(cid, 11260, 1)
			--player:addAchievement('Wayfarer')
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
