game = {}
function game.display(text,time,p)
    -- DisplayTimedTextToPlayer(p or GetLocalPlayer(),0,0,time or 20,text)
    DisplayTimedTextToPlayer(p or GetLocalPlayer(),0,0,time or 20,color.yellow .. '[系统]:'.. color.lr .. text)
end

--所有在线玩家
game.allPlayer = {}

function game.getAllPlayer()
    local t = {}
    for i=1,#allPlayer do
        table.insert( t, allPlayer[i].handle )
    end
    return t
end

function game.SetUnitTypeModel(type,file)
    japi.EXSetUnitString(base.string2id(type),13,file)
    japi.EXSetUnitString(base.string2id(type),14,file)
end

--获得玩家英雄
function game.getPlayerHero(p)
    return game.allPlayer[GetPlayerId(p) + 1].hero
end

function game.isPlayerHero(unit)
    return game.getPlayerHero(GetOwningPlayer(unit)) == unit
end

function game.setPlayerHero(p,hero)
    game.allPlayer[GetPlayerId(p) + 1].hero = hero
end

--初始化玩家
local function init()
    for i=1,15 do
        local t = {}
        t.handle = Player(i-1)
        table.insert( game.allPlayer,t )
    end
end

init()

return game