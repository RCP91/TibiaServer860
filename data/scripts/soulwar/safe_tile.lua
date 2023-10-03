local safeTile = MoveEvent()

function safeTile.onStepIn(creature, item, position, fromPosition)

    if item.actionid == 34201 then   
        creature:setStorageValue(56465465, 1)              
    end
    return true
end

safeTile:type("stepin")
safeTile:aid(34201)
safeTile:register()


safeTile = MoveEvent()

function safeTile.onStepOut(creature, item, position, fromPosition)
        creature:setStorageValue(56465465, 0)  
    return true
end

safeTile:type("stepout")
safeTile:aid(34201)
safeTile:register()