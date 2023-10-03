function onSay(cid, words, param)
    local position = getPlayerPosition(cid)

    if getPlayerLookDir(cid) == 0 then
        positions = {x=position.x, y=position.y-1, z=position.z}
    elseif getPlayerLookDir(cid) == 1 then
        positions = {x=position.x+1, y=position.y, z=position.z}
    elseif getPlayerLookDir(cid) == 2 then
        positions = {x=position.x, y=position.y+1, z=position.z}
    elseif getPlayerLookDir(cid) == 3 then
        positions = {x=position.x-1, y=position.y, z=position.z}
    end

    if getHouseFromPos(positions) == false then
        doPlayerSendTextMessage(cid, 27, "Voce precisa estar na frente a porta da casa para usar o comando.")
    return true
    end

    local days = 5*24*60*60
    local own = getHouseOwner(getHouseFromPos(positions))
    local qry = db.getResult("SELECT `lastlogin` FROM `players` WHERE `id` = "..own)
    
    if(qry:getID() ~= -1) then
        last = tonumber(qry:getDataInt("lastlogin"))
        if last < os.time() - days then
            setHouseOwner(getHouseFromPos(positions), NO_OWNER_PHRASE,true)
            doPlayerSendTextMessage(cid, 27, "A Casa agora esta sem dono, você ou outro jogador pode compra-la")
        end
        if last > os.time() - days then
            doPlayerSendTextMessage(cid, 27, "O proprierário desta casa ainda está ativo no servidor, tente outra casa.")
        end
    end
    return true
end


Denunciar post 
Postado Junho 8, 2014
Salve galerinha do TK.
Hoje vim trazer um script muito útil e buscado hoje em dia nos otservers, é o sistema de !eject.
Como funciona ?

Caso o player fica X dias sem logar (configurável) qualquer outro jogador pode chegar na porta da house dizendo o comando !eject, então a house ficará sem dono e em seugida o player poderá compra-la normalmente, dizendo !buyhouse.

 

É um sript simples e que poderá dar lugar e novas houses a jogadores novos, expulsando os jogadores que não logam mais no seu servidor.

Nota: o script é vendido em uma "empresa" de open tibia onde estou colocando os créditos , disponibilizando aqui minha adaptação e o scrpit para vocês, achou errado? não gostou? ENTÃO COMPRA LÁ =p

Vamos ao que interessa;

 

Abra sua pasta talkactions/scripts e dentro dela crie um arquivo .lua com o nome de: expulse_house.lua e dentro coloque:

function onSay(cid, words, param)
    local position = getPlayerPosition(cid)

    if getPlayerLookDir(cid) == 0 then
        positions = {x=position.x, y=position.y-1, z=position.z}
    elseif getPlayerLookDir(cid) == 1 then
        positions = {x=position.x+1, y=position.y, z=position.z}
    elseif getPlayerLookDir(cid) == 2 then
        positions = {x=position.x, y=position.y+1, z=position.z}
    elseif getPlayerLookDir(cid) == 3 then
        positions = {x=position.x-1, y=position.y, z=position.z}
    end

    if getHouseFromPos(positions) == false then
        doPlayerSendTextMessage(cid, 27, "Voce precisa estar na frente a porta da casa para usar o comando.")
    return true
    end

    local days = 5*24*60*60
    local own = getHouseOwner(getHouseFromPos(positions))
    local qry = db.getResult("SELECT `lastlogin` FROM `players` WHERE `id` = "..own)
    
    if(qry:getID() ~= -1) then
        last = tonumber(qry:getDataInt("lastlogin"))
        if last < os.time() - days then
            setHouseOwner(getHouseFromPos(positions), NO_OWNER_PHRASE,true)
            doPlayerSendTextMessage(cid, 27, "A Casa agora esta sem dono, você ou outro jogador pode compra-la")
        end
        if last > os.time() - days then
            doPlayerSendTextMessage(cid, 27, "O proprierário desta casa ainda está ativo no servidor, tente outra casa.")
        end
    end
    return true
end
Pós ter feito isto, abra o seu arquivo talkactions.xml e coloque debaixo de uma linha qualquer a seguinte linha:

<talkaction words="!eject" event="script" value="expulse_house.lua"/>
Pronto. basta o player chegar na porta da casa e dizer !eject, caso o jogador esteja a 5 dias sem logar, os items do antigo dono irão para o DEPOT e a casa ficará sem dono.

 

 

@Configuração do script:

  local days = 5*24*60*60
Onde está o número 5 é o tanto de dias que o player tem que ficar sem logar para outro jogador executar o comando.

 

 

Para alterar para 3 dias, ficaria como exemplo:

    local days = 3*24*60*60

<talkaction words="!eject" event="script" value="expulse_house.lua"/>

