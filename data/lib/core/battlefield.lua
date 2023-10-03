_Lib_Battle_Info = {
Reward = {
exp = {true, 500000}, items = {true, 25172, 5}, {true, 15515, 5}, premium_days = {true, 1}
},
TeamOne = {name = "Black Assassins", storage = 140120, pos = {x=33390,y=32064,z=5}},
TeamTwo = {name = "Red Barbarians",storage = 140121,pos = {x=33488,y=32065,z=5}},
storage_count = 185400,
tpPos = {x=32364, y=32232, z=7},
limit_Time = 4 -- em minutos
}
function resetBattle()
Game.setStorageValue(_Lib_Battle_Info.TeamOne.storage, 0) 
Game.setStorageValue(_Lib_Battle_Info.TeamTwo.storage, 0)
end
function doBroadCastBattle(type, msg)
for _, cid in pairs(Game.getPlayers()) do
if Player(cid):getStorageValue(_Lib_Battle_Info.TeamOne.storage) == 1 or Player(cid):getStorageValue(_Lib_Battle_Info.TeamTwo.storage) == 1 then
Player(cid):sendTextMessage(type, msg)
end
end
end
function getWinnersBattle(storage)
local str, c = "" , 0
for _, cid in pairs(Game.getPlayers()) do
local player = Player(cid)
if player:getStorageValue(storage) >= 1 then
if _Lib_Battle_Info.Reward.exp[1] == true then player:addExperience(_Lib_Battle_Info.Reward.exp[2]) end
if _Lib_Battle_Info.Reward.items[1] == true then player:addItem(_Lib_Battle_Info.Reward.items[2], _Lib_Battle_Info.Reward.items[3]) end
if _Lib_Battle_Info.Reward.premium_days[1] == true then player:addPremiumDays(_Lib_Battle_Info.Reward.premium_days[2]) end
player:teleportTo(player:getTown():getTemplePosition())
player:setStorageValue(storage, -1)
player:removeCondition(CONDITION_OUTFIT)
c = c+1 
end
end
str = str .. ""..c.." Player"..(c > 1 and "s" or "").." from team "..(Game.getStorageValue(_Lib_Battle_Info.TeamOne.storage) == 0 and _Lib_Battle_Info.TeamTwo.name or _Lib_Battle_Info.TeamOne.name).." won the event battlefield!"
resetBattle()
OpenWallBattle()
return broadcastMessage(str)
end
function OpenWallBattle()
local B = {

{1543, {x=33437, y=32063, z=5, stackpos = 1}},
{1543, {x=33437, y=32064, z=5, stackpos = 1}},
{1543, {x=33437, y=32065, z=5, stackpos = 1}},
{1543, {x=33437, y=32066, z=5, stackpos = 1}},
{1543, {x=33437, y=32067, z=5, stackpos = 1}},
{1498, {x=33437, y=32063, z=5, stackpos = 1}},
{1498, {x=33437, y=32064, z=5, stackpos = 1}},
{1498, {x=33437, y=32065, z=5, stackpos = 1}},
{1498, {x=33437, y=32066, z=5, stackpos = 1}},
{1498, {x=33437, y=32067, z=5, stackpos = 1}}
}
	for i = 1, #B do
		if getTileItemById(B[i][2], B[i][1]).uid == 0 then
			doCreateItem(B[i][1], 1, B[i][2])
		else
			doRemoveItem(getThingfromPos(B[i][2]).uid,1)
		end
	end
end
function removeBattleTp()
local t = getTileItemById(_Lib_Battle_Info.tpPos, 25417).uid
return t > 0 and doRemoveItem(t) and doSendMagicEffect(_Lib_Battle_Info.tpPos, CONST_ME_POFF)
end
function CheckEvent(delay)
if delay > 0 and Game.getStorageValue(_Lib_Battle_Info.storage_count) > 0 then
broadcastMessage("[BattleField Event] We are waiting "..Game.getStorageValue(_Lib_Battle_Info.storage_count).." players to Battlefield starts")
elseif delay == 0 and Game.getStorageValue(_Lib_Battle_Info.storage_count) > 0 then
for _, cid in pairs(Game.getPlayers()) do
local player = Player(cid)
if player:getStorageValue(_Lib_Battle_Info.TeamOne.storage) == 1 or player:getStorageValue(_Lib_Battle_Info.TeamTwo.storage) == 1 then
player:teleportTo(player:getTown():getTemplePosition())
player:setStorageValue(_Lib_Battle_Info.TeamOne.storage, -1)
player:setStorageValue(_Lib_Battle_Info.TeamTwo.storage, -1)
player:removeCondition(CONDITION_OUTFIT)
end
end
broadcastMessage("The event cannot be started because not had enough players.")
Game.setStorageValue(_Lib_Battle_Info.storage_count, 0)
resetBattle()
removeBattleTp()
end
addEvent(CheckEvent, 60000, delay-1)
end