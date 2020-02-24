timer = {}
trigger = {}
setmetatable(timer, timer)
setmetatable(trigger, trigger)

--结构
local t = {}
timer.__index = t
trigger.__index = t

function t:pause(state)
    if state then
        PauseTimer(self.handle)
    else
        ResumeTimer(self.handle)
    end
end

--逝去时间
function t:getElapsed()
    return TimerGetElapsed(self.handle)
end

--剩余时间
function t:getRemaining()
    return TimerGetRemaining(self.handle)
end

--start
--[时间]
--[循环]
--[代码]
--[dialog标题]
--[dialog显示玩家]
function t:start(time,state,code,dialog,p)
    TimerStart(self.handle,time,state,nil)
    TriggerAddAction(self.trigger,code)
    if dialog then
        local td = CreateTimerDialog(self.handle)
        self.dialog = td
        TimerDialogSetTitle(t,dialog)
        if p or GetLocalPlayer() == GetLocalPlayer() then
            TimerDialogDisplay(td,true)
        end
    end
end

function t:addUnitDeadEvent(hero)
    return TriggerRegisterUnitEvent(self.trigger,hero,EVENT_UNIT_DEATH)
end

function t:addUnitDamageEvent(hero)
    return TriggerRegisterUnitEvent(self.trigger,hero,EVENT_UNIT_DAMAGED)
end

--攻击抬手
function t:addUnitAttackStartEvent(hero)
    return TriggerRegisterUnitEvent(self.trigger,hero,EVENT_UNIT_ATTACKED)
end

--进入单位指定范围事件
function t:addUnitRangeEvent(hero,range,exp)
    return TriggerRegisterUnitInRange(self.trigger,hero,range,exp)
end

function t:addAction(action)
    return TriggerAddAction(self.trigger,action)
end

function t:removeAction(action)
    TriggerRemoveAction(self.trigger,action)
end

function t:clearAction()
    TriggerClearActions(self.trigger)
end

function t:setTime(time)
    TimerStart(self.handle,time,false,nil)
end

--运行一次--不干扰时间--没有事件ID
function t:execute()
    TriggerExecute(self.trigger)
end

--获得运行次数
function t:getExeCount()
    return GetTriggerExecCount(self.trigger)
end

--获得事件
function t:getEventId()
    return GetTriggerEventId()
end

function t:addTimerEvent(time,periodic)
    TriggerRegisterTimerEvent(self.trigger,time,periodic)
end

--destroy
function t:destroy()
    self:pause(true)
    DestroyTimer(self.handle)
    DestroyTrigger(self.trigger)
    if self.dialog then
        local td = self.dialog
        TimerDialogDisplay(td,false)
        DestroyTimerDialog(td)
    end
    for i=1,#timer do
        if timer[i] == self then
            table.remove(timer,i)
            break
        end
    end
end

function timer.create()
    local t = {}
    t.handle = CreateTimer()
    t.trigger = CreateTrigger()
    TriggerRegisterTimerExpireEvent(t.trigger,t.handle)
    setmetatable(t, timer)
    table.insert(timer,t)
    return t
end

function trigger.create()
    local self = {}
    self.handle = CreateTimer()
    self.trigger = CreateTrigger()
    TriggerRegisterTimerExpireEvent(self.trigger,self.handle)
    setmetatable(self, timer)
    table.insert(timer,self)
    return self
end

return timer,trigger