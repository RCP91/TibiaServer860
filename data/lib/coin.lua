function getAccountCoins(cid)
local res = db.getResult('select `coins` from accounts where name = \''.. player:getAccountType() ..'\'')
if(res:getID() == -1) then
return false
end
local ret = res:getDataInt("coins")
res:free()
return tonumber(ret)
end

function doAccountAddCoins(cid, count)
return db.executeQuery("UPDATE `accounts` SET `coins` = '".. getAccountCoins(cid) + count .."' WHERE `name` ='".. player:getAccountType() .."'")
end

function doAccountRemoveCoins(cid, count)
return db.executeQuery("UPDATE `accounts` SET `coins` = '".. getAccountCoins(cid) - count .."' WHERE `name` ='".. player:getAccountType() .."'")
end