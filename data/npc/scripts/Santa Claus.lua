 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
local talkState = {}

function onCreatureAppear(cid)    npcHandler:onCreatureAppear(cid)   end
function onCreatureDisappear(cid)   npcHandler:onCreatureDisappear(cid)   end
function onCreatureSay(cid, type, msg)   npcHandler:onCreatureSay(cid, type, msg)  end
function onThink()     npcHandler:onThink()     end

local normalItems = {
     {7439, 7440, 7443},
     {2688, 6508},
     {2688, 6509},
     {2688, 6507},
     {2688, 2114},
     {2688, 2111},
     {2167, 2213, 2214},
     {11227},
     {2156},
     {2153}
}

local semiRareItems = {
     {2173},
     {9954},
     {9971},
     {5080}
}

local rareItems = {
     {2110},
     {5919},
     {6567},
     {11255},
     {11256},
     {6566},
     {2112},
}

local veryRareItems = {
     {2659},
     {3954},
     {2644},
     {10521},
     {5804}
}

local function getReward()
     local rewardTable = {}
     local random = math.random(100)
     if (random <= 90) then
          rewardTable = normalItems
     elseif (random <= 70) then
          rewardTable = semiRareItems
     elseif (random <= 30) then
          rewardTable = rareItems
     elseif (random <= 10) then
          rewardTable = veryRareItems
     end

     local rewardItem = rewardTable[math.random(#rewardTable)]
     return rewardItem
end

function creatureSayCallback(cid, type, msg)
     if(not npcHandler:isFocused(cid)) then
          return false
     end
     local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

     if msgcontains(msg, 'present') then
          
          if (getPlayerStorageValue(cid, 840293) > os.time()) then
               selfSay("You can't get other present.", cid)
               return false
          end



          local reward = getReward()
          local cont = Container(Player(cid):addItem(6511):getUniqueId())
          local count = 1

          for i = 1, #reward do
               if (reward[i] == 2111 or
                   reward[i] == 2688) then
                    count = 10
               end

               cont:addItem(reward[i], count)
          end

          setPlayerStorageValue(cid, 840293, os.time() + 86400)
          selfSay("Merry Christmas!", cid)
     end

     return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
