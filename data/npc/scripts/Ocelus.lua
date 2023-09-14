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
	
	if msgcontains(msg, "eleonore") then
		if getPlayerStorageValue(cid, Storage.TheShatteredIsles.APoemForTheMermaid) == 2 and getPlayerStorageValue(cid, Storage.TheShatteredIsles.ADjinnInLove) < 1 then
			selfSay("I heard the birds sing about her beauty. But how could a human rival the enchanting beauty of a {mermaid}?", cid)
			talkState[talkUser] = 1
		end
	elseif msgcontains(msg, "mermaid") or msgcontains(msg, "marina") then
		if talkState[talkUser] == 1 then
			selfSay({
				"Oh yes, I noticed that lovely mermaid. From afar of course. I would not dare to step into the eyes of such a lovely creature. ...",
				"... I guess I am quite shy. Oh my, if I were not blue, I would turn red now. If there would be someone to arrange a {date} with her."
			}, cid)
			talkState[talkUser] = 2
		elseif getPlayerStorageValue(cid, Storage.TheShatteredIsles.ADjinnInLove) == 2 then
			selfSay("Oh my. Its not easy to impress a mermaid I guess. Please get me a {love poem}. I think elves are the greatest poets so their city seems like a good place to look for one.", cid)
			setPlayerStorageValue(cid, Storage.TheShatteredIsles.ADjinnInLove, 3)
		end
	elseif msgcontains(msg, "date") then
		if talkState[talkUser] == 2 then
			selfSay("Will you ask the mermaid Marina if she would date me?", cid)
			talkState[talkUser] = 3
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 3 then
			selfSay("Thank you. How ironic, a human granting a djinn a wish.", cid)
			talkState[talkUser] = 0
			setPlayerStorageValue(cid, Storage.TheShatteredIsles.ADjinnInLove, 1)
		elseif talkState[talkUser] == 4 then
			if doPlayerRemoveItem(cid, 8189, 1) then
				selfSay("Excellent. Here, with this little spell I enable you to recite the poem like a true elven poet. Now go and ask her for a date again.", cid)
				setPlayerStorageValue(cid, Storage.TheShatteredIsles.ADjinnInLove, 4)
				setPlayerStorageValue(cid, Storage.TheShatteredIsles.APoemForTheMermaid, 3)
				talkState[talkUser] = 0
			else
				talkState[talkUser] = 0
				selfSay("You don't have it...", cid)
			end
		end
	elseif msgcontains(msg, "love poem") then
		if getPlayerStorageValue(cid, Storage.TheShatteredIsles.ADjinnInLove) == 3 then
			selfSay("Did you get a love poem from Ab'Dendriel?", cid)
			talkState[talkUser] = 4
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings, dear visitor |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Oh well.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
