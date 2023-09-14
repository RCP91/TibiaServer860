local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg)	end
function onThink()				npcHandler:onThink()					end

-- ID, Count, Price
local eventShopItems = {
	["stamina refill low"] = {1000, 1, 10},
	["stamina refill medium"] = {1000, 1, 20},
	["stamina refill high"] = {1000, 1, 30},
	["blood herb"] = {2798, 10, 3}
}

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	
	msg = string.lower(msg)
	if (msg == "ofertas") then
		local answerOffers = ""
		for i, v in pairs(eventShopItems) do
			answerOffers = answerOffers.. " {" ..i.."} (" ..v[2].. "x) - " ..v[3].." event token(s) |"
		end
		selfSay("Eu troco os itens: " ..answerOffers, cid)
	elseif (msg == "event shop") then
		selfSay("Entre no nosso site, clique em {Events} => {Events Shop}.", cid)
	end
	
	if (eventShopItems[msg]) then
		talkState[talkUser] = 0
		local itemId, itemCount, itemPrice = eventShopItems[msg][1], eventShopItems[msg][2], eventShopItems[msg][3]
		if (getPlayerItemCount(cid, 26143) > 0) then
			selfSay("Deseja comprar o item {" ..msg.. "} por " ..itemPrice.. "x?", cid)
			talkState[talkUser] = msg
		else
			selfSay("Voc� n�o tem " ..itemPrice.. " {Event Token(s)}!", cid)
			return true
		end
	end

	if (eventShopItems[talkState[talkUser]]) then
		local itemId, itemCount, itemPrice = eventShopItems[talkState[talkUser]][1], eventShopItems[talkState[talkUser]][2], eventShopItems[talkState[talkUser]][3]
		if (msg == "no" or
			msg == "n�o") then
			selfSay("Ent�o qual item deseja comprar?", cid)
			talkState[talkUser] = 0
		elseif (msg == "yes" or
				msg == "sim") then
			if (getPlayerItemCount(cid, 26143) > 0) then
				selfSay("Voc� comprou o Item {" ..talkState[talkUser].."} " ..itemCount.. "x por " ..itemPrice.. " {Event Token(s)}!", cid)
				doPlayerRemoveItem(cid, 26143, itemPrice)
				doPlayerAddItem(cid, itemId, itemCount)
			end
		end
	end
end

local voices = { {text = 'Troco itens por Event Tokens, venha ver minhas ofertas!'} }
--npcHandler:addModule(VoiceModule:new(voices))

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, 'Ol�, |PLAYERNAME|! Caso n�o me conhe�a, v� no site e clique em {Event Shop}. Deseja trocar seus Event Tokens? fale {ofertas}.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Foi �timo negociar com voc�, |PLAYERNAME|.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Foi �timo negociar com voc�, |PLAYERNAME|.')
npcHandler:addModule(FocusModule:new())
