unit = {}
setmetatable(unit, unit)

--主线任务
local u = {}
unit.__index = u

function unit.init(handle)
    local self = {}
    table.insert( unit, self )
    setmetatable(self, unit)
    self.handle = handle
    return self
end

function unit.create(p,id,x,y,face)
    return unit.init(CreateUnit(p,base.string2id(id),x,y,face or 270))
end

function unit.createByName(p,name,x,y,face)
    return unit.init(CreateUnitByName(p,name,x,y,face or 270))
end

function unit.find(handle)
    for i=1,#unit do
        if unit[i].handle == handle then
            return unit[i]
        end
    end
    return unit.init(handle)
end

function u:destroy()
    local key = table.getkey(unit,self)
    table.remove( unit,key )
end

function u:kill()
    KillUnit(self.handle)
end

function u:remove(time)
    self:kill()
    RemoveUnit(self.handle)
    self:destroy()
end

function u:show(show)
    ShowUnit(self.handle,show)
end

function u:getHP()
    return GetUnitState(self.handle,UNIT_STATE_LIFE)
end

function u:getMP()
    return GetUnitState(self.handle,UNIT_STATE_MANA)
end

function u:getMaxHP()
    return japi.GetUnitState(self.handle,UNIT_STATE_MAX_LIFE)
end

function u:getMaxMP()
    return japi.GetUnitState(self.handle,UNIT_STATE_MAX_MANA)
end

function u:addHP(hp,soure)
    SetUnitState(self.handle,UNIT_STATE_LIFE,hp + self:getHP())
end

function u:addMana(mp,soure)
    SetUnitState(self.handle,UNIT_STATE_MANA,mp + self:getMP())
end

function u:addMaxHP(hp,soure)
    japi.SetUnitState(self.handle,UNIT_STATE_MAX_LIFE,hp + self:getMaxHP())
end

function u:addMaxMana(mp,soure)
    japi.SetUnitState(self.handle,UNIT_STATE_MAX_MANA,mp + self:getMaxMP())
end

function u:getOwnning()
    return GetOwningPlayer(self.handle)
end

function u:getTypeId()
    return base.id2string(GetUnitTypeId(self.handle))
end

function u:getName()
    return GetUnitName(self.handle)
end

function u:isAlly(p)
    return IsUnitAlly(self.handle,p)
end

function u:isEnemy(p)
    return IsUnitEnemy(self.handle,p)
end

function u:isSelect(p)
    return IsUnitSelected(self.handle,p)
end

function u:isHero()
    return IsUnitType(self.handle,UNIT_TYPE_HERO)
end

function u:isDead()
    return IsUnitType(self.handle,UNIT_TYPE_DEAD)
end

function u:inRange(x,y,range)
    if not y then
        y = x:getY()
        x = y:getX()
    end
    return IsUnitInRangeXY(self.handle,x,y,range)
end

function u:IsIllusion()
    return IsUnitIllusion(self.handle)
end

function u:getMoveSpeed()
    return GetUnitMoveSpeed(self.handle)
end

-- function u:addMoveSpeed(speed)
--     self.
-- end

function u:getDefeatMoveSpeed()
    return GetUnitDefaultMoveSpeed(self.handle)
end

function u:getFaceing()
    return GetUnitFacing(self.handle)
end

function u:getX()
    return GetUnitX(self.handle)
end

function u:getY()
    return GetUnitY(self.handle)
end

function u:setX(x)
    SetUnitX(self.handle,x)
end

function u:setY(y)
    SetUnitY(self.handle,y)
end

function u:move(angle,dis)
    self:setX(self.getX() + math.cosBJ( angle ) * dis)
    self:setY(self.getY() + math.sinBJ( angle ) * dis)
end

function u:setPostion(x,y)
    self:setX(x)
    self:setX(y)
end

function u:getPostion()
    return self:getX(),self:getY()
end

function u:select(p)
    if GetLocalPlayer() == p then
        SelectUnit(self.handle,true)
    end
end

function u:select(p)
    if GetLocalPlayer() == p then
        SelectUnit(self.handle,true)
    end
end

function u:setPathing(state)
    SetUnitPathing(self.handle,state)
end

function u:pause(state)
    PauseUnit(self.handle,state)
end

function u:pauseTag(state)
    if state then
        self.pauseTag = (self.pauseTag or 0) + 1
    else
        self.pauseTag = math.min( (self.pauseTag or 0) - 1,0 )
    end
    PauseUnit(self.handle,self.pauseTag > 0)
end

function u:pauseEX(state)
    japi.PauseUnitEx(self.handle,state)
end

function u:setInvulnerable(state)
    SetUnitInvulnerable(self.handle,state)
end

function u:setInvulnerableTag(state)
    if state then
        self.iniv = (self.iniv or 0) + 1
    else
        self.iniv = math.min( (self.iniv or 0) - 1,0 )
    end
    self:setInvulnerable(self.iniv > 0)
end

function u:setFlyHeight(newHeight,rate)
    SetUnitFlyHeight(self.handle,newHeight,rate or 10000)
end

function u:getFlyHeight()
    return GetUnitFlyHeight(self.handle)
end

function u:addFlyHeight(hight)
    self:setFlyHeight(self:getFlyHeight() + hight)
end

function u:setScale(scale)
    SetUnitScale(self.handle,scale,scale,scale)
end

--
function u:set255Color(r,g,b,a)
    self.r = r
    self.g = g or r
    self.b = b or r
    self.a = a or self.a or 0
    SetUnitVertexColor(self.handle,r,g or r,b or r,a or self.a)
end

--取值 0 - 100
function u:setColor(r,g,b,a)
    r = r or r*2.55
    g = g or g*2.55
    b = b or b*2.55
    a = a or a*2.55
    self:Set255Color(r,g,b,a)
end

--取值 0 - 100
function u:setAlpha(a)
    self.a = a*2.55
    SetUnitVertexColor(self.handle,self.r or 255,self.g or 255,self.b or 255,self.a)
end

--添加动画队列
function u:addAnimation(name)
    QueueUnitAnimation(self.handle,name)
end

function u:setAnimation(name)
    if type(name) == 'string' then
        SetUnitAnimation(self.handle,name)
    else
        SetUnitAnimationByIndex(self.handle,name)
    end
end

--使一个骨骼锁定看向目标 可选参数偏移位置
--这里bone只有chest和head是有效参数 并且骨骼命名必须符合标准
function u:setUnitLookAt(bone,target,x,y,z)
    SetUnitLookAt(self.handle,bone,target,x or 0,y or 0,z or 0)
end

function u:setUnitLookAtAngle(bone,angle)
    local x = math.cosBJ(angle) * 100
    local y = math.sinBJ(angle) * 100
    self:SetUnitLookAt(bone,self.handle,x,y)
end

--停止看向目标
function u:resetUnitLookAt()
    ResetUnitLookAt(self.handle)
end

--这里传递effect是为了变身刷新绑定特效
-- function u:addEffect(e)
--     table.insert( self.effects,e )
-- end

-- function u:removeEffect(e)
--     local key = table.getkey(e)
--     table.remove( self.effects,key )
-- end

function u:refreshEffect()
    for i=1,#self.effects do
        self.effects:refresh()
    end
end

function u:setFacing(angle)
    SetUnitFacing(self.handle,angle)
end

function u:charge(angle,dis,time,refresh_time,charge,destroy)
    if self.t then
        self.t:destroy()
    end
    local speed = dis/time*(refresh_time or 0.03)
    self:setAngle(angle)
    local t = timer.create()
    self.t = t
    t:addUnitDeadEvent(self.handle)
    t:start(refresh_time or 0.03,true,function ()
        self:move(angle,dis)
        -- t.dis = (t.dis or 0) + speed
        if t:getExeCount()*speed >= dis or GetTriggerEventId() == EVENT_UNIT_DEATH then
            t:destroy()
            if destroy then
                destroy(self.handle,self:getX(),self:getY())
            end
        else
            if charge then
                charge(self.handle,self:getX(),self:getY())
            end
        end
    end)
    return t
end

--碰到单位会停止
function u:chargeCollision(angle,dis,time,range,filter,refresh_time,charge,destroy)
    if self.t then
        self.t:destroy()
    end
    local speed = dis/time*(refresh_time or 0.03)
    self:setAngle(angle)
    local t = timer.create()
    self.t = t
    local g = group.create()
    t:addUnitDeadEvent(self.handle)
    t:start(refresh_time or 0.03,true,function ()
        self:move(angle,dis)
        -- t.dis = (t.dis or 0) + speed
        g:addRange(filter,self.getX(),self.getY(),range,self.handle)
        if t:getExeCount()*speed >= dis or g:size() > 0 then
            t:destroy()
            if destroy then
                destroy(self.handle,self:getX(),self:getY(),g)
            end
            g:destroy()
        elseif GetTriggerEventId() == EVENT_UNIT_DEATH then
            t:destroy()
            g:destroy()
        else
            if charge then
                charge(self.handle,self:getX(),self:getY())
            end
        end
    end)
    return t
end

--已经存在与场上的单位并不会被刷新视觉显示,将该函数放入game库里
-- function u:SetTypeModel(file)
--     japi.EXSetUnitString(GetUnitTypeId(self.handle),13,file)
--     japi.EXSetUnitString(GetUnitTypeId(self.handle),14,file)
-- end

return unit