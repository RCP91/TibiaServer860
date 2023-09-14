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
		
		if getPlayerStorageValue(cid, Storage.WrathoftheEmperor.Questline) == 30 and getPlayerStorageValue(cid, Storage.WrathoftheEmperor.BossStatus) == 5 then
			selfSay({
				"The amplified force of the snake god is tearing the land apart. It is using my crystals in a reverse way to drain the vital force from the land and its inhabitants to fuel its power. ...",
				"I will withstand its influence as good as possible and slow this process. You will have to fight its worldly incarnation though. ...",
				"It is still weak and disoriented. You might stand a chance - this is our only chance. I will send you to the point to where the vital force is channelled. I have no idea where that might be though. ...",
				"You will probably have to fight some sort of vessel the snake god uses. Even if you defeat it, it is likely that it only weakens the snake. ...",
				"You might have to fight several incarnations until the snake god is worn out enough. Then use the power of the snake's own sceptre against it. Use it on its corpse to claim your victory. ...",
				"Be prepared for the fight of your life! Are you ready?"
			}, cid)
			talkState[talkUser] = 1
		elseif getPlayerStorageValue(cid, Storage.WrathoftheEmperor.Questline) == 32 then
			selfSay({
				"So you have mastered the crisis you invoked with your foolishness. I should crush you for your involvement right here and now. ...",
				"But such an act would bring me down to your own barbaric level and only fuel the corruption that destroys the land that I own. Therefore I will not only spare your miserable life but show your the generosity of the dragon emperor. ...",
				"I will reward you beyond your wildest dreams! ...",
				"I grant you three chests - filled to the lid with platinum coins, a house in the city in which you may reside, a set of the finest armor Zao has to offer, and a casket of never-ending mana. ...",
				"Speak with magistrate Izsh in the ministry about your reward. And now leave before I change my mind!"
			}, cid)
			setPlayerStorageValue(cid, Storage.WrathoftheEmperor.Questline, 33)
			setPlayerStorageValue(cid, Storage.WrathoftheEmperor.Mission12, 0) --Questlog, Wrath of the Emperor "Mission 12: Just Rewards"
		end
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			
			setPlayerStorageValue(cid, Storage.WrathoftheEmperor.Questline, 31)
			setPlayerStorageValue(cid, Storage.WrathoftheEmperor.Mission11, 1) --Questlog, Wrath of the Emperor "Mission 11: Payback Time"
			selfSay("So be it!", cid)
			talkState[talkUser] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
