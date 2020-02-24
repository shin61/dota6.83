local group = {}
setmetatable(group, group)

--结构
local g = {}
group.__index = g

function g:getFilter(hero,filter)
    local t = {
        ['敌人'] = function ()
            local u = GetFilterUnit()
            return IsUnitEnemy(hero,GetOwningPlayer(u)) and GetUnitAbilityLevel(u,base.string2id('Avul')) == 0 and GetUnitAbilityLevel(u,base.string2id('Aloc')) == 0
        end,
        --包括无敌
        ['敌人-无敌'] = function ()
            local u = GetFilterUnit()
            return IsUnitEnemy(hero,GetOwningPlayer(u)) and GetUnitAbilityLevel(u,base.string2id('Aloc')) == 0
        end,
        --包括蝗虫
        ['敌人-蝗虫'] = function ()
            local u = GetFilterUnit()
            return IsUnitEnemy(hero,GetOwningPlayer(u)) and GetUnitAbilityLevel(u,base.string2id('Aloc')) > 0
        end,
        ['敌人-全部'] = function ()
            local u = GetFilterUnit()
            return IsUnitEnemy(hero,GetOwningPlayer(u))
        end,
        ['友军'] = function ()
            local u = GetFilterUnit()
            return IsUnitAlly(hero,GetOwningPlayer(u)) and GetUnitAbilityLevel(u,base.string2id('Avul')) == 0 and GetUnitAbilityLevel(u,base.string2id('Aloc')) == 0
        end,
        --包括无敌
        ['友军-无敌'] = function ()
            local u = GetFilterUnit()
            return IsUnitAlly(hero,GetOwningPlayer(u)) and GetUnitAbilityLevel(u,base.string2id('Aloc')) == 0
        end,
        ['默认'] = function ()
            local u = GetFilterUnit()
            return GetUnitAbilityLevel(u,base.string2id('Aloc')) == 0
        end,
    }
    return t[filter]
end

function group.create()
    local g = {}
    g.handle = CreateGroup()
    g.data = {}
    -- g.hero = hero
    setmetatable(g, group)
    table.insert(group,g)
    return g
end

function g:size()
    return #self.data
end

--条件
function g:addRange(filter,x,y,range,hero)
    GroupEnumUnitsInRange(self.handle,x,y,range,Condition(self:getFilter(hero,filter) or filter or self:getFilter(hero,'默认')))
    ForGroup(self.handle,function ()
        local u = GetEnumUnit()
        if table.getkey(self.data,u) == 0 then
            table.insert( self.data, u )
        end
    end)
    GroupClear(self.handle)
end

function g:add(u)
    table.insert( self.data, u )
end

function g:remove(u)
    local index = table.getkey(self.data,u)
    table.remove( self.data,index )
end

function g:clear()
    for i=1,#self.data do
        table.remove(self.data)
    end
end

function g:destroy()
    local index = table.getkey(group,self)
    DestroyGroup(self.handle)
    table.remove( group, index )
end

function g:copy()
    return table.copy(self)
end

function g:getRandom()
    return self.data[math.random(1,#self.data)]
end

function g:getForce()
    local f = {}
    for i=1,#self.data do
        table.insert( f, GetOwningPlayer(self.data[i]) )
    end
    return f
end

return group