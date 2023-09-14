local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)               npcHandler:onCreatureAppear(cid)             end
function onCreatureDisappear(cid)       npcHandler:onCreatureDisappear(cid)               end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()                 npcHandler:onThink()                         end

-- ID, Count, Price
local eventShopItems = {
     ["small stamina refill"] = {22473, 1, 100},
     ["zaoan chess box"] = {20620, 1, 100},
     ["pannier backpack"] = {21475, 1, 70},
     ["green light"] = {23588, 1, 70},
     ["blood herb"] = {2798, 3, 10},
     ["draken doll"] = {13031, 1, 70},
     ["bear doll"] = {3954, 1, 70}
}

local function creatureSayCallback(cid, type, msg)
     if not npcHandler:isFocused(cid) then
          return false
     end

     
     msg = string.lower(msg)
     if (msg == "event shop") then
          selfSay("In our website enter in {Events} => {Events Shop}.", cid)
     end
     
     if (eventShopItems[msg]) then
          talkState[talkUser] = 0
          local itemId, itemCount, itemPrice = eventShopItems[msg][1], eventShopItems[msg][2], eventShopItems[msg][3]
          if (getPlayerItemCount(cid, 15515) > 0) then
               selfSay("You want buy {" ..msg.. "} for " ..itemPrice.. "x?", cid)
               talkState[talkUser] = msg
          else
               selfSay("You don't have " ..itemPrice.. " {Bar of Gold(s)}!", cid)
               return true
          end
     end

     if (eventShopItems[talkState[talkUser]]) then
          local itemId, itemCount, itemPrice = eventShopItems[talkState[talkUser]][1], eventShopItems[talkState[talkUser]][2], eventShopItems[talkState[talkUser]][3]
          if (msg == "no" or
               msg == "n�o") then
               selfSay("So... what you want?", cid)
               talkState[talkUser] = 0
          elseif (msg == "yes" or
                    msg == "sim") then
               if (getPlayerItemCount(cid, 15515) >= itemPrice) then
                    selfSay("You bought {" ..talkState[talkUser].."} " ..itemCount.. "x for " ..itemPrice.. " {Bar of Gold(s)}!", cid)
                    doPlayerRemoveItem(cid, 15515, itemPrice)
                    doPlayerAddItem(cid, itemId, itemCount)
               else
                    selfSay("You don't have enough bar's.", cid)
                    return true
               end
          end
     end
end

local voices = { {text = 'Change your Bar of Gold\'s for Items here!'} }
--npcHandler:addModule(VoiceModule:new(voices))

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())