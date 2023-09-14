 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}


function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end
	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

	

	if(msgcontains(msg, "addon")) then
		if(getPlayerStorageValue(cid, 1007) < 1) then
			selfSay("Currently we are offering accessories for the nobleman - and, of course, noblewoman - outfit. Would you like to hear more about our offer?", cid)
			talkState[talkUser] = 1
		elseif getPlayerStorageValue(cid, 1008) < 1 then
			selfSay("Currently we are offering accessories for the nobleman - and, of course, noblewoman - outfit. Would you like to hear more about our offer?", cid)
			talkState[talkUser] = 1
		else
			selfSay("You have already bought the two addons.", cid)
		end

	elseif(msgcontains(msg, "yes")) then
		if talkState[talkUser] == 1 then
			selfSay("Especially for you, mylady, we are offering a pretty {hat} and a beautiful {dress} like the ones I wear. Which one are you interested in?", cid)
			talkState[talkUser] = 2
		elseif talkState[talkUser] == 3 then
			if(doPlayerRemoveMoney(cid, 150000) and getPlayerStorageValue(cid, 1007) < 1) then
				selfSay("Congratulations! Here is your brand-new accessory, I hope you like it. Please visit us again! ", cid)
				talkState[talkUser] = 0
				doPlayerAddOutfit(cid, 140, 2)
				doPlayerAddOutfit(cid, 132, 2)
				setPlayerStorageValue(cid, 1007, 1)
				if getPlayerStorageValue(cid, 1007) == 1 and getPlayerStorageValue(cid, 1008) == 1 then
					--player:addAchievement(226) -- Achievement Aristocrat
				end
			end
		elseif talkState[talkUser] == 4 then
			if(doPlayerRemoveMoney(cid, 150000) and getPlayerStorageValue(cid, 1008) < 1) then
				selfSay("Congratulations! Here is your brand-new accessory, I hope you like it. Please visit us again! ", cid)
				talkState[talkUser] = 0
				doPlayerAddOutfit(cid, 140, 1)
				doPlayerAddOutfit(cid, 132, 1)
				setPlayerStorageValue(cid, 1008, 1)
				if getPlayerStorageValue(cid, 1007) == 1 and getPlayerStorageValue(cid, 1008) == 1 then
					--player:addAchievement(226) -- Achievement Aristocrat
				end
			end
		elseif talkState[talkUser] == 5 then
			 if getPlayerItemCount(cid,2655) >= 1 then
      			doPlayerRemoveItem(cid,2655,1)
				selfSay("A {Red Robe}! Great. Here, take this red piece of cloth, I don\'t need it anyway.", cid)
				doPlayerAddItem(cid,5911,1)
				talkState[talkUser] = 0
			else
				selfSay('Are you trying to mess with me?!', cid)
			end
		elseif talkState[talkUser] == 6 then
   			 if getPlayerItemCount(cid,2663) >= 1 then
				doPlayerRemoveItem(cid,2663,1)
				selfSay("A {Mystic Turban}! Great. Here, take this blue piece of cloth, I don\'t need it anyway.", cid)
				doPlayerAddItem(cid,5912,1)
				talkState[talkUser] = 0
			else
				selfSay('Are you trying to mess with me?!', cid)
			end
		elseif talkState[talkUser] == 7 then
   			 if getPlayerItemCount(cid,2652) >= 150 then
				doPlayerRemoveItem(cid,2652,150)
				selfSay("A 150 {Green Tunic}! Great. Here, take this green piece of cloth, I don\'t need it anyway.", cid)
				doPlayerAddItem(cid,5910,1)
				talkState[talkUser] = 0
			else
				selfSay('Are you trying to mess with me?!', cid)
			end
		end
	elseif(msgcontains(msg, "hat") or msgcontains(msg, "accessory")) and (talkState[talkUser] == 2 and getPlayerStorageValue(cid, 1007) < 1) then
		selfSay("This accessory requires a small fee of 150000 gold pieces. Of course, we do not want to put you at any risk to be attacked while carrying this huge amount of money. ...", cid)
		selfSay("This is why we have established our brand-new instalment sale. You can choose to either pay the price at once, or if you want to be safe, by instalments of 10000 gold pieces. ...", cid)
		selfSay("I also have to inform you that once you started paying for one of the accessories, you have to finish the payment first before you can start paying for the other one, of course. ...", cid)
		selfSay("Are you interested in purchasing this accessory?", cid)
		talkState[talkUser] = 3
	elseif(msgcontains(msg, "dress") or msgcontains(msg, "coat")) and (talkState[talkUser] == 2 and getPlayerStorageValue(cid, 1008) < 1) then
		selfSay("This accessory requires a small fee of 150000 gold pieces. Of course, we do not want to put you at any risk to be attacked while carrying this huge amount of money. ...", cid)
		selfSay("This is why we have established our brand-new instalment sale. You can choose to either pay the price at once, or if you want to be safe, by instalments of 10000 gold pieces. ...", cid)
		selfSay("I also have to inform you that once you started paying for one of the accessories, you have to finish the payment first before you can start paying for the other one, of course. ...", cid)
		selfSay("Are you interested in purchasing this accessory?", cid)
		talkState[talkUser] = 4
	elseif(msgcontains(msg, "red robe")) then
		selfSay("Have you found a {Red Robe} for me?", cid)
		talkState[talkUser] = 5
	elseif(msgcontains(msg, "mystic turban")) then
		selfSay("Have you found a {Mystic Turban} for me?", cid)
		talkState[talkUser] = 6
	elseif(msgcontains(msg, "green tunic")) then
		selfSay("Have you found {150 Green Tunic} for me?", cid)
		talkState[talkUser] = 7	
	
	end
	
	--Scatterbrained 
	
	if getPlayerStorageValue(cid, 45215) == 1 then
		if(msgcontains(msg, "hat"))  then
			selfSay("Yes, I can help you with fabricating a {dark hat}", cid)			
		end 
		
		if(msgcontains(msg, "dark hat")) then
			selfSay("To create a dark hat, I need one piece of {minotaur leather} and two {bat wings}. Do you have those materials with you by coincidence?", cid)	
			talkState[talkUser] = 8
			
		elseif(msgcontains(msg, "yes")) and talkState[talkUser] == 8 then
			if getPlayerItemCount(cid, 5878) >= 1 and getPlayerItemCount(cid, 5894) >= 2 then
				doPlayerRemoveItem(cid, 5878, 1)
				doPlayerRemoveItem(cid, 5894, 2)
				doPlayerAddItem(player,10046,1)
				setPlayerStorageValue(cid, 45215, 2) 
				selfSay("A little stitch here and a little stitch there... perfect! Here you are. With the best wishes to your master.", cid)
			else
				selfSay("To create a dark hat, I need {one} piece of minotaur leather and {two} bat wings. Do you have those materials with you by coincidence?", cid)	
			end
			talkState[talkUser] = 9
		end
	end
	
	
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
