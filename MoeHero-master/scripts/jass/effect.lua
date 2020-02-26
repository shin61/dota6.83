effect = {}
setmetatable(effect, effect)

--结构
local e = {}
effect.__index = e

local function init(handle)
    local e = {}
    table.insert(effect,e)
    e.handle = handle
    return e
end

function e:charge(angle,dis,time,refresh_time,charge,destroy)
    if not self.ref then
        if self.t then
            self.t:destroy()
        end
        local speed = dis/time*(refresh_time or 0.03)
        self:setAngle(angle)
        local t = timer.create()
        self.t = t
        t:start(refresh_time or 0.03,true,function ()
            local x = japi.EXGetEffectX(self.handle) + math.cosBJ( angle ) * speed
            local y = japi.EXGetEffectY(self.handle) + math.sinBJ( angle ) * speed
            self:setEffectXY(x,y)
            t.dis = (t.dis or 0) + speed
            if t.dis >= dis then
                t:destroy()
                if destroy then
                    destroy(self.handle,x,y)
                end
            else
                if charge then
                    charge(self.handle,x,y)
                end
            end
        end)
    end
end

function e:getType()
    if self.ref then
        return 'hero'
    else
        return 'point'
    end
end

--刷新特效,以后修正变身问题需要的功能
function e:refresh()
    if self.ref then
        local x = japi.EXGetEffectX(self.handle)
        local y = japi.EXGetEffectY(self.handle)
        DestroyEffect(self.handle)
        self.hand = AddSpecialEffect(self.file,x,y)
    else
        DestroyEffect(self.handle)
        self.hand = AddSpecialEffectTarget(self.file,self.unit,self.ref)
    end
end

function e:immediatelyDestroy()
    self:setZ(99999)
    self:destroy()
end

function e:destroy(time)
    local t = timer.create()
    t:start(time or 0,false,function()
        DestroyEffect(self.handle)
        local key = table.getkey(effect,self)
        table.remove(effect,key)
        t:destroy()
    end
    )
end

--默认角度为0
function e:setAngle(angle)
    if not self.ref then
        if self.angle then
            japi.EXEffectMatRotateZ(self.handle,-self.angle)
        end
        self.angle = angle
        japi.EXEffectMatRotateZ(self.handle,angle)
    end
end

function e:setSize(size)
    if not self.ref then
        japi.EXSetEffectSize(self.handle,size)
    end
end

function e:setZ(z)
    if not self.ref then
        japi.EXSetEffectZ(self.handle,z)
    end
end

function e:setEffectXY(x,y)
    if not self.ref then
        japi.EXSetEffectXY(self.handle,x,y)
    end
end

function e.create(file,x,y,angle)
    if not y then
        local hero = x
        y = GetUnitY(hero)
        x = GetUnitX(hero)
    end
    local e = init(AddSpecialEffect(file,x,y))
    e.file = file
    table.insert( effect, e )
    setmetatable(e, effect)
    e:setAngle(angle or 270)
    return e
end

function e.create_target(file,unit,ref)
    local e = init(AddSpecialEffectTarget(file,unit,ref))
    e.ref = ref
    e.unit = unit
    e.file = file
    table.insert( effect, e )
    setmetatable(e, effect)
    return e
end

return effect