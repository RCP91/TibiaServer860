local exhaust = {
    storage = 216752,
    seconds = 5
}
 
function onDirection(cid, old, current)
    if isPlayer(cid) then 
        if current ~= old and exhaustion.check(cid, exhaust.storage) then
            doPlayerSendCancel(cid, 'Don\'t saturate the server making flood.')
            return false
        else
            exhaustion.set(cid, exhaust.storage, exhaust.seconds)
        end
    end
    return true
end