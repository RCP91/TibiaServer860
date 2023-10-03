_Lib_Battle_Days = {
["Monday"] = {
["02:45"] = {players = 10},
["15:32"] = {players = 10}
},
["Wednesday"] = {
["23:06"] = {players = 10}
},
["Thursday"] = {
["11:26"] = {players = 10},
["21:02"] = {players = 10},
["23:46"] = {players = 10}
}
}
function onThink(interval)
if _Lib_Battle_Days[os.date("%A")] then
hours = tostring(os.date("%X")):sub(1, 5)
tb = _Lib_Battle_Days[os.date("%A")][hours]
if tb and (tb.players % 2 == 0) then
local tp = Game.createItem(25417, 1, _Lib_Battle_Info.tpPos)
tp:setActionId(45000)
CheckEvent(_Lib_Battle_Info.limit_Time)
Game.setStorageValue(_Lib_Battle_Info.storage_count, tb.players)
broadcastMessage("The event BattleField was opened and We are waiting "..tb.players.." Players! Team divided into "..((tb.players)/2).." VS "..((tb.players)/2))
end
end
return true
end