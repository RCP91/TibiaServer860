local keywordHandler = KeywordHandler:new() 
local npcHandler = NpcHandler:new(keywordHandler) 
NpcSystem.parseParameters(npcHandler) 
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end 
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end 
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end 
function onThink() npcHandler:onThink() end 
function creatureSayCallback(cid, type, msg) 
if(not npcHandler:isFocused(cid)) then 
return false 
end 
local talkState = {}
local talkUser = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid
local shopWindow = {}
local moeda = 15515 -- id da sua moeda vip
local t = {
      [27063] = {price = 400},
      [18394] = {price = 180},
      [24809] = {price = 600},
      [16007] = {price = 150},
      [2197] = {price = 4},
      [2164] = {price = 3},  
      [5919] = {price = 1000},
      [5015] = {price = 800},
      [5804] = {price = 1000},
      [5809] = {price = 1500},
      [6099] = {price = 800},
      [6102] = {price = 300},   
      [6101] = {price = 200},
      [6100] = {price = 200},  
      [11754] = {price = 100},
      [11144] = {price = 100},
      [10063] = {price = 100},
      [6579] = {price = 100},
      [3954] = {price = 100},
      [2108] = {price = 100},  	 
      [9019] = {price = 100},  
      [6512] = {price = 100},
      [11256] = {price = 100}, 		  
      [5903] = {price = 8000}
      }
      
local onBuy = function(cid, item, subType, amount, ignoreCap, inBackpacks)
    if  t[item] and not doPlayerRemoveItem(cid, moeda, t[item].price) then
          selfSay("You don't have "..t[item].price.." "..getItemName(moeda), cid)
             else
        doPlayerAddItem(cid, item)
        selfSay("Here are you.", cid)
       end
    return true
end
if (msgcontains(msg, 'trade') or msgcontains(msg, 'TRADE'))then
            for var, ret in pairs(t) do
                    table.insert(shopWindow, {id = var, subType = 0, buy = ret.price, sell = 0, name = getItemName(var)})
                end
            openShopWindow(cid, shopWindow, onBuy, onSell)
            end
return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback) 
npcHandler:addModule(FocusModule:new())