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

	
		
	--Cuadno responde Mission
	if msgcontains(msg, 'mission') then	
		if getPlayerStorageValue(cid, 45101) == -1 then
			selfSay({
				'Would you like to help me discover the secrets of the island of evil?'
			}, cid)
			talkState[talkUser] = 1  
		elseif getPlayerStorageValue(cid, 45101) == 1 then
			selfSay({
				'Did you find my book?'
			}, cid)
			talkState[talkUser] = 2  
		elseif getPlayerStorageValue(cid, 45101) == 2 then
			selfSay({
				'Did you catch a Mechanical Fish?'
			}, cid)
			talkState[talkUser] = 3 
		elseif getPlayerStorageValue(cid, 45101) == 3 then
			selfSay({
				'Did you have 10 Vials of Rum?'
			}, cid)
			talkState[talkUser] = 4  
			
		elseif getPlayerStorageValue(cid, 45101) == 4 then
			selfSay({
				'Did you have 1 Vial of Fruit Juice?'
			}, cid)
			talkState[talkUser] = 5  

		elseif getPlayerStorageValue(cid, 45101) == 5  or getPlayerStorageValue(cid, 45101) == 6 then
			selfSay({
				'Did you Kill the F°k!ng rotworm?'
			}, cid)
			talkState[talkUser] = 6 
		
		elseif getPlayerStorageValue(cid, 45101) == 7 then
			selfSay({
				'Did you found the Nautical Map?'
			}, cid)
			talkState[talkUser] = 7 
			
			
		elseif getPlayerStorageValue(cid, 45101) == 8 then
			selfSay({
				'Did you found the Tibianus Card?'
			}, cid)
			talkState[talkUser] = 8 	
			
		
		
		else		
		selfSay({'Get out of here Im going to the fan club with the kings card'}, cid)		
		end
	
	
	--Cuando Responde 'YES'
	elseif msgcontains(msg, 'yes') then
		if talkState[talkUser] == 1 then
			setPlayerStorageValue(cid, 45101, 1) -- Inicia la quest con ir con la hoja
			selfSay({
				'Excellent! ... Your first mission to go for my {book} in the chest crossing the door'
			}, cid)
		elseif talkState[talkUser] == 2 then			
			selfSay({
				'What!! There was only one blank sheet!...',
				'Well .. forget my book! the next mission is: I need you to catch a special fish ... bring me a {Mechanical Fish}...',
				'Please do not use the black market better I give you a fishing rod and a few nails..',
				'Good luck.',
			}, cid)
			setPlayerStorageValue(cid, 45101, 2) -- se da cuenta que esta vacia y va por la segunda mission
			doPlayerAddItem(cid, 10223, 1)
			doPlayerAddItem(cid, 8309, 20)
			
		elseif talkState[talkUser] == 3 then
			if doPlayerRemoveItem(cid, "mechanical fish", 1) then
				setPlayerStorageValue(cid, 45101, 3)
				selfSay('Excellent! ... Your next mission is: please bring me {10 Vials of Rum}.', cid)				
			else
				selfSay('You are a liar you dont have it', cid)
			end
			
		elseif talkState[talkUser] == 4 then
			if doPlayerRemoveItem(cid, 2006, 10, 27) then --10 vials
				setPlayerStorageValue(cid, 45101, 4)
				selfSay('Excellent! ... Your next mission is: please bring me {1 Vial of Fruit Juice}.', cid)				
			else
				selfSay('You are a liar you dont have it', cid)
			end
			
		elseif talkState[talkUser] == 5 then
			if doPlayerRemoveItem(cid, 2006, 1, 21) then --1 vial
				setPlayerStorageValue(cid, 45101, 5)
				selfSay({'Excellent! ... Your next mission is: {Kill the rotworm} outside my house.. you need fire and this hammer',
				'Use the crucible to be efective'}, cid)
				doPlayerAddItem(cid, 10152, 1)				
			else
				selfSay('You are a liar you dont have it', cid)
			end	
			
		elseif talkState[talkUser] == 6 then
			if getPlayerStorageValue(cid, 45101) == 6 then --Kill rotworm
				setPlayerStorageValue(cid, 45101, 7)
				selfSay({'Excellent! ... Well i will stop playing with you ...Your next mission is: Serch and give me the {Nautical Map}',
				'The last time I saw was in Northport'}, cid)								
			else
				selfSay('You are a liar you dont kill it', cid)
			end		
			
		elseif talkState[talkUser] == 7 then
			if doPlayerRemoveItem(cid, 10225, 1) then --Nautical map
				setPlayerStorageValue(cid, 45101, 8)
				setPlayerStorageValue(cid, 45103, 1) -- Aceeso a la isla
				selfSay({'Excellent! ... This map is just what I needed to go to the island of evil...',
				'Another thing .. some kind of monster stole the {Fan Club Membership Card of King Tibianus} that I had stolen ... bring it to me and I will reward you...',
				'I see on the boat going down the stairs'}, cid)
							
			else
				selfSay('You are a liar this is not the map I need', cid)
			end	
		
		elseif talkState[talkUser] == 8 then
			if doPlayerRemoveItem(cid, 10308, 1) then --Membership
				setPlayerStorageValue(cid, 45101, 9)				
				selfSay({'Excellent! ... Thank you child .. you have been useful to me .. take your reward'}, cid)
				player:addExperience(6666)			
			else
				selfSay('You are a liar this is not the Membership I need', cid)
			end			
			
		end

		
	end
	
		
	return true
end


npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
